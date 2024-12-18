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
        if (!accountIds.isEmpty()) {
            Map<Id, Integer> accountIdContactCountMap = new Map<Id, Integer>();
            List<Account> listToInsert = new List<Account>();
            List<AggregateResult> aggResults = [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE Id IN: accountIds GROUP BY AccountId];
            if (!aggResults.isEmpty()) {
                for(AggregateResult result : aggResults) {
                    accountIdContactCountMap.put((Id) result.get('AccountId'), (Integer) result.get('contactCount'));
                }
                
                if (!accountIdContactCountMap.isEmpty()) {
                    for (Id eachAccountId : accountIds) {
                        if (accountIdContactCountMap.containsKey(eachAccountId)) {
                            listToInsert.add(new Account(Id = eachAccountId, Number_Of_Contacts__c = accountIdContactCountMap.get(eachAccountId)));
                        }
                    }
                }
            }
            
            if (!listToInsert.isEmpty()) {
                update listToInsert;
            }
            
        }
    }
}