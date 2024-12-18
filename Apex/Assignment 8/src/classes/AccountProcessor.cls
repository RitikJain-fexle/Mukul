/**
* Purpose      : Class to update no. of contacts on Account object using future method
* 
* Created By   : Mukul Pichunia
* 
* Created Date : 17-12-2024
* 
* version      : V_1.0 - Created
* 
*/

// Calling Future method from trigger
// Future method with webservice callout needs to be callout true 
// Future method are always static and void so cannot return anything and takes primitive parameters

public class AccountProcessor {
    /**
* Purpose      : This Method is Used to get the count of contacts for a particular accountId if exist
*                 And then Update the Number_Of_Contacts__c on account
* 
* Created By   : Mukul Pichunia
* 
* Created Date : 17-12-2024
*/
    
    @Future
    public static void countContacts(Set<Id> accountIds) {
        System.debug('Entering ' + accountIds);
        if (!accountIds.isEmpty()) {
            System.debug('>>>>>> accountIds in code'+ accountIds);
            Map<Id, Integer> accountIdContactCountMap = new Map<Id, Integer>();
            List<Account> listToInsert = new List<Account>();
            List<AggregateResult> aggResults = [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE AccountId IN: accountIds GROUP BY AccountId];
            System.debug('>>>>>> aggResults'+ aggResults);
            
            for(AggregateResult result : aggResults) {
                accountIdContactCountMap.put((Id) result.get('AccountId'), (Integer) result.get('contactCount'));
            }
            
            
            
            for (Id eachAccountId : accountIds) {
                Account acc = new Account(Id = eachAccountId, Number_Of_Contacts__c = 0);
                if (accountIdContactCountMap.containsKey(eachAccountId)) {
                    acc.Number_Of_Contacts__c = accountIdContactCountMap.get(eachAccountId);
                }
                if (!accountIdContactCountMap.containsKey(eachAccountId)) {
                    System.debug('listToInsert ' + eachAccountId); 
                }
                listToInsert.add(acc);
            }
            
            System.debug('listToInsert ' + listToInsert);
            
            if (!listToInsert.isEmpty()) {
                update listToInsert;
            }
            
        }
    }
}