global without sharing class EverStringAPIIntegration_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts{
   
    global String Query;   

    global EverStringAPIIntegration_Batch(String queryStr){
        Query = queryStr;             
    }

    global Database.QueryLocator start(Database.BatchableContext BC){      
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead> leadListToProcess){
        
        if(leadListToProcess != null && leadListToProcess.size() > 0){
            
            Set<String> leadfieldsSet = new Set<String>();
            Map<String, String> sfdcAndEverstringAPINameMap = new Map<String, String>();
            
            for (Schema.SObjectField fieldSet : Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().values()) {
                leadfieldsSet.add(fieldSet.getDescribe().getName());
            }
            System.debug('leadfieldsSet  ::: ' + leadfieldsSet);
            for (Everstring_Lead_Field_Mapping__c lfm : [SELECT Id, Name, Everstring_Lead_API_Name__c, SFDC_Lead_API_Name__c, Active__c
                                                         FROM Everstring_Lead_Field_Mapping__c
                                                         WHERE Everstring_Lead_API_Name__c != NULL
                                                         AND SFDC_Lead_API_Name__c != NULL
                                                         AND Active__c = TRUE]) {
                if (leadfieldsSet.contains(lfm.SFDC_Lead_API_Name__c)) {
                    sfdcAndEverstringAPINameMap.put(lfm.SFDC_Lead_API_Name__c, lfm.Everstring_Lead_API_Name__c);
                }
            }
            System.debug('sfdcAndEverstringAPINameMap ::: ' + sfdcAndEverstringAPINameMap);
            
            EverStringAPIIntegration eve = new EverStringAPIIntegration();
            eve.leadBulkInsert(leadListToProcess,sfdcAndEverstringAPINameMap);
        }
   }

   global void finish(Database.BatchableContext BC){

   }

}