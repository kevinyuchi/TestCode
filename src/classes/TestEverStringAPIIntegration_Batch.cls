@isTest
public class TestEverStringAPIIntegration_Batch{
    
    public static testMethod void method1(){
        
        List<Everstring_Lead_Field_Mapping__c> lfmListToInsert = new List<Everstring_Lead_Field_Mapping__c>();
        List<Lead> leadListToInsert = new List<Lead>();
        
        Lead ld1 =  new Lead();
        ld1.LastName = 'testlead1';
        ld1.Company = 'Test-Company1';
        ld1.Email = 'testlead1@testcompany1.com';
        ld1.Title = 'Test-title1';
        leadListToInsert.add(ld1);
        
        Lead ld2 =  new Lead();
        ld2.LastName = 'testlead2';
        ld2.Company = 'Test-Company2';
        ld2.Email = 'testlead2@testcompany2.com';
        ld2.Title = 'Test-title2';
        leadListToInsert.add(ld2);
        insert leadListToInsert;
        
        Everstring_Settings__c es = new Everstring_Settings__c();
        es.Name = 'EverStringAPIValues';
        es.EverString_EndPoint_BaseURL__c = 'https://api-uat.everstring.com/v1/service';
        es.EverString_Last_Sync_Date__c = Date.valueOf(System.today().addDays(-10));
        insert es;
        
        Test.StartTest();
            String queryStrng = 'SELECT id, Name, Email FROM Lead WHERE Email != null';
            EverStringAPIIntegration_Batch ever = new EverStringAPIIntegration_Batch(queryStrng);
            //ever.query = 'SELECT id, Name, Email FROM Lead WHERE Email != null';
            ID batchprocessid = Database.executeBatch(ever);
        Test.StopTest();
    }
}