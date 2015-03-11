public without sharing class EverStringAPIIntegration {

    public void leadBulkInsert(List<Lead> leadList, Map<String,String> sfdcAndEverstringAPINameMap) {
        
        String authKey = '', bulkInsertEndpoint = '';
        Everstring_Settings__c calloutDetails =  Everstring_Settings__c.getValues('EverStringAPIValues');
        
        if(calloutDetails != null){
            if (calloutDetails.EverString_EndPoint_BaseURL__c != NULL) {
                bulkInsertEndpoint = calloutDetails.EverString_EndPoint_BaseURL__c+'/lead/bulk';
            }
            System.debug('bulkInsertEndpoint ::: ' + bulkInsertEndpoint);
            authKey = UserInfo.getOrganizationId();
        }
        System.debug('authKey ::: ' + authKey);
        
        if (leadList != null && leadList.size() > 0) {
            
            String reqBody = '[';  
            System.debug('Request Body ::: '+reqBody);
            for (Lead ld : leadList) {
            
                reqBody += '{"email":"'+ld.Email+'","data":{';
                for (String sfdcAPIName : sfdcAndEverstringAPINameMap.keySet()) {
                    if (ld.get(sfdcAPIName) != NULL) {
                        
                        if(sfdcAPIName == 'CreatedDate'){
                            reqBody += '"'+sfdcAndEverstringAPINameMap.get(sfdcAPIName)+'":"'+DateTime.valueOf(ld.get(sfdcAPIName)).format()+'",';
                        }else{
                            String tempVal = String.valueOf(ld.get(sfdcAPIName));
                            if(tempVal.contains('\r') || tempVal.contains('\n')){
                                tempVal = tempVal.replace('\r', '');
                                tempVal = tempVal.replace('\n', ' ');
                            }
                            reqBody += '"'+sfdcAndEverstringAPINameMap.get(sfdcAPIName)+'":"'+ tempVal +'",';
                        }
                    }
                }
                reqBody += '"datasource":"salesforce",';
                reqBody = reqBody.subString(0,reqBody.length()-1)+'}},';
                
            }
            
            try {
                HTTP htp = new HTTP();
                HTTPRequest req = new HTTPRequest();
                req.setEndPoint(bulkInsertEndpoint);
                req.setHeader('Authorization',authKey);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Accept','application/json');
                req.setMethod('POST');            
                          
                
                System.debug('Request Body ::: '+reqBody);
                if (reqBody != '[' && reqBody.length() > 1) {
                    reqBody = reqBody.subString(0,reqBody.length()-1)+']';
                    req.setBody(reqBody);
                    System.debug('Bulk Insert Request body : ' + req.getBody());
                    HTTPResponse res = new HTTPResponse();        
                    res = htp.send(req);
                    System.debug('Bulk Insert Response ::: '+res);
                    System.debug('Bulk Insert Response Body ::: '+res.getBody());
                    JSONParser parser = JSON.createParser(res.getBody());
                    EverStringResponseClass everStrRes = (EverStringResponseClass)parser.readValueAs(EverStringResponseClass.class);
                    System.debug('everStrRes ::: ' + everStrRes);
                    if (everStrRes.status == 200) {
                        //update custom setting value - Syndate as today date
                        System.debug('***************need to update custom setting value ************');
                        Everstring_Settings__c everSet = new Everstring_Settings__c();
                        everSet.Id = Everstring_Settings__c.getInstance('EverStringAPIValues').Id;
                        everSet.EverString_Last_Sync_Date__c = System.now();
                        update everSet;
                    }
                }
            } catch (Exception e) {
                System.debug('Exception message ::: ' + e.getMessage());
            }
        }
    }
    
    //Inner class to hold the response
    public class EverStringResponseClass {
        public Integer status;
        public String errorMessage;
    }
}