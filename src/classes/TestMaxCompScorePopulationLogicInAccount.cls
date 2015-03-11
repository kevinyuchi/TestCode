@isTest
public class TestMaxCompScorePopulationLogicInAccount {
    
    static testmethod void method1() {
        
        Account[] acct = new Account[] {
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2'),
            new Account(Name = 'Test Account 3')
        };
        insert acct;
        
        List<Contact> conList = new List<Contact>();
        for(integer i=1;i<=10;i++){
            
            Contact con = new Contact();
            con.LastName = 'Contact'+i;
            con.FirstName = 'Test ';
            con.everstring__ES_Comp_Fit_Score__c = ((i * 100) + 30);
            if(i <= 3) {
                con.AccountId = acct[0].Id;
            }else if(i > 3 && i <= 6) {
                con.AccountId = acct[1].Id;
            }else {
                con.AccountId = acct[2].Id;
            }
            conList.add( con );
        }
        
        if(conList.size() > 0) {
            insert conList;
        }
        
        List<Account> acctRecordsList = [SELECT everstring__ES_Comp_Fit_Score__c, Id FROM Account WHERE Id IN :acct];
        
        if(acctRecordsList.size() == 3) {
            system.assertEquals(acctRecordsList[0].everstring__ES_Comp_Fit_Score__c, 330);
            system.assertEquals(acctRecordsList[1].everstring__ES_Comp_Fit_Score__c, 630);
            system.assertEquals(acctRecordsList[2].everstring__ES_Comp_Fit_Score__c, 1030);
        }
        
        List<Contact> conRecordsList = [SELECT AccountId, everstring__ES_Comp_Fit_Score__c, Id FROM Contact WHERE everstring__ES_Comp_Fit_Score__c > 1000];
        
        if(conRecordsList.size() > 0) {
            
            List<Contact> tobeUpdatedContactsList = new List<Contact>();
            
            Contact c = new Contact( Id = conRecordsList[0].Id );
            c.AccountId = acctRecordsList[1].Id;
            tobeUpdatedContactsList.add( c );
            
            if(tobeUpdatedContactsList.size() > 0) {
                update tobeUpdatedContactsList;
            }
            
            List<Account> acctRecordsListAfterUpdate = [SELECT everstring__ES_Comp_Fit_Score__c, Id FROM Account WHERE Id IN :acct];
            
            if(acctRecordsListAfterUpdate.size() == 3) {
                system.assertEquals(acctRecordsListAfterUpdate[0].everstring__ES_Comp_Fit_Score__c, 330);
                system.assertEquals(acctRecordsListAfterUpdate[1].everstring__ES_Comp_Fit_Score__c, 1030);
                system.assertEquals(acctRecordsListAfterUpdate[2].everstring__ES_Comp_Fit_Score__c, 930);
            }
        }

        List<Contact> tobeChangedParentIdContacts = [SELECT AccountId, everstring__ES_Comp_Fit_Score__c, Id FROM Contact WHERE AccountId = :acct[1].Id];
        
        if(tobeChangedParentIdContacts.size() > 0) {
            
            List<Contact> tobeChangedParentIdConRec = new List<Contact>();
            
            for(Contact con : tobeChangedParentIdContacts) {
                
                Contact c = new Contact( Id = con.Id );
                c.AccountId = acct[0].Id;
                tobeChangedParentIdConRec.add( c );
            }
            
            if(tobeChangedParentIdConRec.size() > 0) {
                update tobeChangedParentIdConRec;
            }
            
            List<Account> acctRecordsListAfterUpdate1 = [SELECT everstring__ES_Comp_Fit_Score__c, Id FROM Account WHERE Id IN :acct];
            
            if(acctRecordsListAfterUpdate1.size() == 3) {
                system.assertEquals(acctRecordsListAfterUpdate1[0].everstring__ES_Comp_Fit_Score__c, 1030);
                system.assertEquals(acctRecordsListAfterUpdate1[1].everstring__ES_Comp_Fit_Score__c, null);
                system.assertEquals(acctRecordsListAfterUpdate1[2].everstring__ES_Comp_Fit_Score__c, 930);
            }
        }

        List<Contact> tobeDeletedContacts = [SELECT AccountId, everstring__ES_Comp_Fit_Score__c, Id FROM Contact WHERE AccountId = :acct[2].Id];
        
        if(tobeDeletedContacts.size() > 0) {
            delete tobeDeletedContacts;
        }
            
        List<Account> acctList = [SELECT everstring__ES_Comp_Fit_Score__c, Id FROM Account WHERE Id = :acct[2].Id];
        
        if(acctList.size() > 0) {
            system.assertEquals(acctList[0].everstring__ES_Comp_Fit_Score__c, null);
        }
    }
}