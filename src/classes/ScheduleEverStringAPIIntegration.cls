global without sharing class ScheduleEverStringAPIIntegration implements Schedulable {
        
        public String testValue;
        
        global void execute(SchedulableContext SC) {
          
            Map<String, String> sfdcAndEverstringAPINameMap = new Map<String, String>();
            List<Lead> leadListToProcess = new List<Lead>();
            Set<String> leadfieldsSet = new Set<String>();
            String   leadFieldsToQuery = '', leadQueryString = '';
            DateTime syncDate;
            String syncDateStr;
            Everstring_Settings__c evrSettings;
            Boolean isFirstSynch;

            for (Schema.SObjectField fld : Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().values()) {
                Schema.DescribeFieldResult dfr = fld.getDescribe();
                //if(dfr.isAccessible()) {
                    leadfieldsSet.add(dfr.getName());
                //}
            }
            System.debug('leadfieldsSet  ::: ' + leadfieldsSet); 
            
            for (Everstring_Lead_Field_Mapping__c lfm : [SELECT Id, Name, Everstring_Lead_API_Name__c, SFDC_Lead_API_Name__c, Active__c
                                                         FROM Everstring_Lead_Field_Mapping__c
                                                         WHERE Everstring_Lead_API_Name__c != NULL
                                                         AND SFDC_Lead_API_Name__c != NULL
                                                         AND Active__c = TRUE]) {
                if (leadfieldsSet.contains(lfm.SFDC_Lead_API_Name__c)) {
                    sfdcAndEverstringAPINameMap.put(lfm.SFDC_Lead_API_Name__c, lfm.Everstring_Lead_API_Name__c);
                    leadFieldsToQuery += lfm.SFDC_Lead_API_Name__c + ', ';
                }
            }
            System.debug('sfdcAndEverstringAPINameMap ::: ' + sfdcAndEverstringAPINameMap);
            System.debug('leadFieldsToQuery ::: ' + leadFieldsToQuery);
            
            evrSettings = Everstring_Settings__c.getValues('EverStringAPIValues');
            
            if (evrSettings != null) {
                if(evrSettings.EverString_Last_Sync_Date__c != NULL){
                    isFirstSynch = false;
                    syncDate = evrSettings.EverString_Last_Sync_Date__c;
                    syncDateStr =syncDate.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                    System.debug('syncDate ::: ' + syncDate);
                    System.debug('syncDateStr ::: ' + syncDateStr);
                }else{
                    isFirstSynch = true;
                }
            
                
                if (leadFieldsToQuery != '' && leadFieldsToQuery.length() > 0) {
                    leadFieldsToQuery = leadFieldsToQuery.subString(0, leadFieldsToQuery.length() - 2);
                    
                    if(isFirstSynch){
                        leadQueryString += 'SELECT Email, '+leadFieldsToQuery+' FROM Lead WHERE Email != NULL AND IsConverted = false AND ES_Comp_Fit_Score__c = NULL';
                    }else{
                        leadQueryString += 'SELECT Email, '+leadFieldsToQuery+' FROM Lead WHERE Email != NULL AND IsConverted = false AND CreatedDate > '+syncDateStr+' AND ES_Comp_Fit_Score__c = NULL';
                    }
                    
                    //leadQueryString += 'SELECT Email, '+leadFieldsToQuery+' FROM Lead WHERE Email != NULL AND CreatedDate > :syncDate AND (';
                    /*if (leadQueryString.endsWithIgnoreCase('(')) {
                        leadQueryString = leadQueryString.subString(0, leadQueryString.length() - 6);
                    } else if (leadQueryString.endsWithIgnoreCase('OR ')) {
                        leadQueryString = leadQueryString.subString(0, leadQueryString.length() - 4) + ')';
                    }*/
                }
                
                System.debug('leadQueryString for Bulk Insert ::: ' + leadQueryString);
                
                if (sfdcAndEverstringAPINameMap.size() > 0 && leadQueryString != '' && leadQueryString.length() > 0) {
                
                    leadListToProcess = Database.Query(leadQueryString);
                                    
                    if(testValue == 'test' || (leadListToProcess != null && leadListToProcess.size() > 1000)){
                    
                        //Pass leads to batch class
                        system.debug('leadListToProcess SIZE::Going to BATCH:'+leadListToProcess.size());
                        system.debug('sfdcAndEverstringAPINameMap::Going to Normal cls:'+sfdcAndEverstringAPINameMap);
                        
                        EverStringAPIIntegration_Batch  b = new EverStringAPIIntegration_Batch (leadQueryString);
                        
                        if(evrSettings != null && evrSettings.Last_Executed_Batch_Job_Id__c != null){
                            
                            List<AsyncApexJob> jobList = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                                                    FROM AsyncApexJob WHERE ID = :evrSettings.Last_Executed_Batch_Job_Id__c ];
                                                    
                            system.debug('JOB::'+jobList); 
                            
                            AsyncApexJob job;
                            
                            if(jobList != null && jobList.size() > 0){
                                job = jobList[0];
                            }
                            
                            if(job == null || (job != null && (job.Status == 'Completed' || job.Status == 'Aborted' || job.Status == 'Failed'))){
                                Id batchId = Database.executeBatch(b, 1000);
                                
                                evrSettings.Last_Executed_Batch_Job_Id__c = batchId;
                                
                                try{
                                    update evrSettings;
                                }catch(Exception e){ system.debug('Exception occured:::'+e.getMessage());}
                            }
                        }else if(evrSettings != null && evrSettings.Last_Executed_Batch_Job_Id__c == null){
                        
                            Id batchId = Database.executeBatch(b, 1000);
                            evrSettings.Last_Executed_Batch_Job_Id__c = batchId;
                                
                            try{
                                update evrSettings;
                            }catch(Exception e){ system.debug('Exception occured:::'+e.getMessage());}
                        }

                    }else if(leadListToProcess != null && leadListToProcess.size() > 0){
                    
                        //Pass leads to process normally
                        system.debug('leadListToProcess SIZE::Going to Normal cls:'+leadListToProcess.size());
                        system.debug('sfdcAndEverstringAPINameMap::Going to Normal cls:'+sfdcAndEverstringAPINameMap);
                        
                        doEverStringAPIIntegration(leadQueryString,sfdcAndEverstringAPINameMap);                
                    }
                }
            }
       }
       
        @future(callout=true)
        public static void doEverStringAPIIntegration(String queryStr , Map<String,String> sfdcAndEverstringAPINameMap){
           
            List<Lead> leadList = Database.Query(queryStr);           
            
            if(leadList != null && leadList.size() > 0){
                EverStringAPIIntegration eve = new EverStringAPIIntegration();
                eve.leadBulkInsert(leadList,sfdcAndEverstringAPINameMap);
            }
        }
    }