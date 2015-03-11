trigger copyMaxCompanyScoreToAccount on Contact (after insert, after update, after delete, after undelete) {
    
    Set<Id> accountIdSet = new Set<Id>();
    Map<Id,Decimal> accountIdAndMaxCompanyScoreMap = new Map<Id,Decimal>();
    List<Account> accountRecordsListTobeUpdated = new List<Account>();
    
    if(Trigger.isDelete) {
        for(Contact con : trigger.old) {
            
            if(con.everstring__ES_Comp_Fit_Score__c != NULL && con.AccountId != NULL) {
                accountIdSet.add(con.AccountId);
            }
        }
    }else {
        for(Contact con : trigger.new) {
            if(Trigger.isInsert || Trigger.isUndelete) {        
                if(con.everstring__ES_Comp_Fit_Score__c != NULL && con.AccountId != NULL) {
                    accountIdSet.add(con.AccountId);
                }
            }else if(Trigger.isUpdate) {        
                if((con.everstring__ES_Comp_Fit_Score__c != Trigger.oldMap.get(con.Id).everstring__ES_Comp_Fit_Score__c) || (con.AccountId != Trigger.oldMap.get(con.Id).AccountId)) {
                    accountIdSet.add(con.AccountId);
                    accountIdSet.add(Trigger.oldMap.get(con.Id).AccountId);
                }
            }
        }
    }

    for(AggregateResult ar : [SELECT AccountId, MAX(everstring__ES_Comp_Fit_Score__c) FROM Contact WHERE AccountId IN :accountIdSet GROUP BY AccountId]) {
        
        Id acctId = (Id)ar.get('AccountId');
        Decimal maxCompanyScore = (Decimal)ar.get('expr0');
        
        if(!accountIdAndMaxCompanyScoreMap.containsKey(acctId)) {               
            accountIdAndMaxCompanyScoreMap.put(acctId, maxCompanyScore);
        }
    }

    for(Id acctId : accountIdSet) {
        if(acctId != null){
        Account acc = new Account(Id = acctId);
        acc.everstring__ES_Comp_Fit_Score__c = accountIdAndMaxCompanyScoreMap.get(acctId);
        accountRecordsListTobeUpdated.add( acc );
        }
    }

    if(accountRecordsListTobeUpdated.size() > 0) {
        update accountRecordsListTobeUpdated;
    }
}