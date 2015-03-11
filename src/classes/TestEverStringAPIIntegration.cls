@isTest
public class TestEverStringAPIIntegration {
    public static testmethod void leadBulkDMLByEverStringAPI_BulkInsertFun1() {
        List<Lead> leadListToInsert = new List<Lead>();
        List<Lead> leadListToUpdate = new List<Lead>();
        List<Everstring_Lead_Field_Mapping__c> lfmListToInsert = new List<Everstring_Lead_Field_Mapping__c>();
        
        Everstring_Settings__c es = new Everstring_Settings__c();
        es.Name = 'EverStringAPIValues';
        es.EverString_EndPoint_BaseURL__c = 'https://api-uat.everstring.com/v1/service';
        es.EverString_Last_Sync_Date__c = Date.valueOf(System.today().addDays(-10));
        insert es;
        
        Everstring_Lead_Field_Mapping__c lfm1 = new Everstring_Lead_Field_Mapping__c();
        lfm1.SFDC_Lead_API_Name__c = 'Company';
        lfm1.Everstring_Lead_API_Name__c = 'orgName';
        lfm1.Active__c = TRUE;
        lfmListToInsert.add(lfm1);
        
        Everstring_Lead_Field_Mapping__c lfm2 = new Everstring_Lead_Field_Mapping__c();
        lfm2.SFDC_Lead_API_Name__c = 'Email';
        lfm2.Everstring_Lead_API_Name__c = 'Email' ;
        lfm2.Active__c = TRUE;
        lfmListToInsert.add(lfm2);
        insert lfmListToInsert;
        Map<String,String> sfdcAndEverstringAPINameMap = new Map<String,String>();
        
        for(Everstring_Lead_Field_Mapping__c lfm : lfmListToInsert)
        sfdcAndEverstringAPINameMap.put(lfm.SFDC_Lead_API_Name__c, lfm.Everstring_Lead_API_Name__c);
        
        Lead ld1 =  new Lead();
        ld1.LastName = 'testlead1';
        ld1.Company = 'Test-Company1';
        ld1.Email = 'testlead1@testcompany1.com';
        ld1.Title = 'Test-title1';
        leadListToInsert.add(ld1);
        
        //System.assertEquals(ld1.LastName, 'testlead1');
        
        Lead ld2 =  new Lead();
        ld2.LastName = 'testlead2';
        ld2.Company = 'Test-Company2';
        ld2.Email = 'testlead2@testcompany2.com';
        ld2.Title = 'Test-title2';
        leadListToInsert.add(ld2);
        insert leadListToInsert;
        
        Lead ld11 =  new Lead(Id=leadListToInsert[0].Id);
        ld11.Status = 'Working - Contacted';
        leadListToUpdate.add(ld11);
        
        Lead ld22 =  new Lead(Id=leadListToInsert[1].Id);
        ld22.Status = 'Working - Contacted';
        leadListToUpdate.add(ld22);
        update leadListToUpdate;        
        
        Test.startTest();
        EverStringAPIIntegration les = new EverStringAPIIntegration();
        EverStringAPIIntegration.EverStringResponseClass res = new EverStringAPIIntegration.EverStringResponseClass();
        Test.setMock(HttpCalloutMock.class, new EverStringResponseMockImpl());
        les.leadBulkInsert(leadListToUpdate,sfdcAndEverstringAPINameMap);
        
        List<Everstring_Settings__c> evrs = [select Id,EverString_Last_Sync_Date__c from Everstring_Settings__c where Name = 'EverStringAPIValues' limit 1];
        System.assertEquals(evrs[0].EverString_Last_Sync_Date__c != Null, true);
        //les.leadBulkUpdate();
        Test.stopTest();
    }
}