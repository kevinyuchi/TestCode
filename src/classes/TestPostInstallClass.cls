@isTest
public class TestPostInstallClass{

    private static testMethod void testPostInstallClass1() {
    
        PostInstallClass postinstall = new PostInstallClass();
        postinstall.testAvailJobs = 90;
        
        Test.testInstall(postinstall, null);
        List<Everstring_Settings__c> evrs = [select Id from Everstring_Settings__c where Name = 'EverStringAPIValues' limit 1];
        
        System.assertEquals(evrs.size() > 0, true);
    }
    
    private static testMethod void testPostInstallClass2() {
    
        PostInstallClass postinstall = new PostInstallClass();
        postinstall.testAvailJobs = 80;
        
        Test.testInstall(postinstall, null);
        List<Everstring_Settings__c> evrs = [select Id from Everstring_Settings__c where Name = 'EverStringAPIValues' limit 1];
        
        System.assertEquals(evrs.size() > 0, true);
    }
    
    private static testMethod void testPostInstallClass3() {
    
        PostInstallClass postinstall = new PostInstallClass();
        postinstall.testAvailJobs = 95;
        
        Test.testInstall(postinstall, null);
        List<Everstring_Settings__c> evrs = [select Id from Everstring_Settings__c where Name = 'EverStringAPIValues' limit 1];
        
        System.assertEquals(evrs.size() > 0, true);
    }
    
    private static testMethod void testPostInstallClass4() {
    
        PostInstallClass postinstall = new PostInstallClass();
        postinstall.testAvailJobs = 97;
        
        Test.testInstall(postinstall, null);
        List<Everstring_Settings__c> evrs = [select Id from Everstring_Settings__c where Name = 'EverStringAPIValues' limit 1];
        
        System.assertEquals(evrs.size() > 0, true);
    }
}