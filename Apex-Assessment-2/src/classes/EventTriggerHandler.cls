public class EventTriggerHandler {
    
    public static void updateActivitiesCountOnAccount(List<Event> newList, Map<Id, Event> oldMap) {
        
        Set<Id> accountIds = new Set<Id>();
        
        for (Event incEvent : newList != null ? newList : oldMap.values()) {
            if (incEvent.WhatId != null && String.valueOf(incEvent.WhatId.getSObjectType()).equals('Account')) {
                accountIds.add(incEvent.WhatId);
            }
            
            if (oldMap != null && oldMap.get(incEvent.Id).WhatId != incEvent.WhatId ) {
                accountIds.add(oldMap.get(incEvent.Id).WhatId);
            }
        }
        
        if (!accountIds.isEmpty()) {
            
            Map<Id, Decimal> accIdTaskCountMap = new Map<Id, Decimal>();
            List<AggregateResult> taskCount = [SELECT whatId, COUNT(Id) eventCount FROM Event WHERE whatId IN: accountIds GROUP BY whatId];
            Map<Id, Account> accountIdMap = new Map<Id, Account>([SELECT Id, Total_Open_Activities__c , 
                                                                  Total_Activities__c, 
                                                                  Total_Closed_Activities__c FROM Account WHERE Id IN:accountIds]);
            
            if (!taskCount.isEmpty()) {
                
                for (AggregateResult result : taskCount) {
                    accIdTaskCountMap.put((Id)result.get('whatId'), (Decimal)result.get('taskCount'));
                }
            }
            
            if (!accIdTaskCountMap.isEmpty()) {
                List<Account> insertAccountList = new List<Account>();
            for(Event eachTask : newList) {
                Account acc = new Account(Id = eachTask.WhatId, Total_Open_Activities__c = 0,
                                          Total_Activities__c = 0, Total_Closed_Activities__c = 0);
                if (accIdTaskCountMap.containsKey(eachTask.WhatId)) {
                    acc.Total_Activities__c = accountIdMap.get(eachTask.WhatId).Total_Activities__c != null ?  + accountIdMap.get(eachTask.WhatId).Total_Activities__c + accIdTaskCountMap.get(eachTask.WhatId) : accIdTaskCountMap.get(eachTask.WhatId);
                    
                    if (eachTask.Status__c == 'Open') {
                        acc.Total_Open_Activities__c =  accountIdMap.get(eachTask.WhatId).Total_Open_Activities__c != null ?  accountIdMap.get(eachTask.WhatId).Total_Open_Activities__c + 1 :  1 ;
                    }
                    
                    if (eachTask.Status__c == 'Closed') {
                        acc.Total_Closed_Activities__c += accountIdMap.get(eachTask.WhatId).Total_Closed_Activities__c != null ? accountIdMap.get(eachTask.WhatId).Total_Closed_Activities__c + 1 :  1 ;
                    }
                }
                
                insertAccountList.add(acc);
            }
            
            update insertAccountList;
            }
            
        }
    }
}