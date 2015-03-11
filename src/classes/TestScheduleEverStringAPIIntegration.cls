@isTest
public class TestScheduleEverStringAPIIntegration {
    public static testmethod void scheduleEverStringAPIIntegrationmethod() {
       
        List<Everstring_Lead_Field_Mapping__c> lfmListToInsert = new List<Everstring_Lead_Field_Mapping__c>();
        List<Lead> leadListToInsert = new List<Lead>();
        
        Everstring_Lead_Field_Mapping__c lfm1 = new Everstring_Lead_Field_Mapping__c();
        lfm1.SFDC_Lead_API_Name__c = 'createdDate';
        lfm1.Everstring_Lead_API_Name__c = 'orgName';
        lfm1.Active__c = TRUE;
        lfmListToInsert.add(lfm1);
        
        Everstring_Lead_Field_Mapping__c lfm2 = new Everstring_Lead_Field_Mapping__c();
        lfm2.SFDC_Lead_API_Name__c = 'Title';
        lfm2.Everstring_Lead_API_Name__c = 'title';
        lfm2.Active__c = TRUE;
        lfmListToInsert.add(lfm2);
        insert lfmListToInsert;
        
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
        es.Last_Executed_Batch_Job_Id__c = '12345';
        insert es;

        Test.startTest();
            String CRON_EXP = '0 0 0 1 1 ? 2025';  
            ScheduleEverStringAPIIntegration sch = new ScheduleEverStringAPIIntegration();
            sch.testValue = 'test';
            String jobId = System.schedule('TestScheduledApex', CRON_EXP, sch);
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

            System.assertEquals(CRON_EXP, ct.CronExpression); 
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
    
     public static testmethod void scheduleEverStringAPIIntegrationmethod2() {
       
        List<Everstring_Lead_Field_Mapping__c> lfmListToInsert = new List<Everstring_Lead_Field_Mapping__c>();
        List<Lead> leadListToInsert = new List<Lead>();
        
        Everstring_Lead_Field_Mapping__c lfm1 = new Everstring_Lead_Field_Mapping__c();
        lfm1.SFDC_Lead_API_Name__c = 'createdDate';
        lfm1.Everstring_Lead_API_Name__c = 'orgName';
        lfm1.Active__c = TRUE;
        lfmListToInsert.add(lfm1);
        
        Everstring_Lead_Field_Mapping__c lfm2 = new Everstring_Lead_Field_Mapping__c();
        lfm2.SFDC_Lead_API_Name__c = 'Title';
        lfm2.Everstring_Lead_API_Name__c = 'title';
        lfm2.Active__c = TRUE;
        lfmListToInsert.add(lfm2);
        insert lfmListToInsert;
        
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
        es.Last_Executed_Batch_Job_Id__c = '12345';
        insert es;

        
        Test.startTest();
            String CRON_EXP1 = '0 0 0 1 1 ? 2025';  
            ScheduleEverStringAPIIntegration sch1 = new ScheduleEverStringAPIIntegration();
            String jobId1 = System.schedule('TestScheduledApex', CRON_EXP1, sch1);
            CronTrigger ct1 = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId1];

            System.assertEquals(CRON_EXP1, ct1.CronExpression); 
            System.assertEquals(0, ct1.TimesTriggered);

        Test.stopTest();
    }
}