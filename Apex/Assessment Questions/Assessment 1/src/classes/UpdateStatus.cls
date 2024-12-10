public without sharing class UpdateStatus {
    public static void statusUpdateOnContact(List<Contact> newList) {
        //Create a Set of Account ID
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : newList) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        
        if (!accountIds.isEmpty()) {
            Map<Id, String> mapOfIdAndStatus = new Map<Id, String>();
            for (Account acc : [SELECT ID, Status__c, Property__r.Status__c FROM Account WHERE ID IN :accountIds]) {
                if(String.isNotBlank(acc.Status__c)) {
                    mapOfIdAndStatus.put(acc.Id, acc.Status__c);
                } else if (String.isNotBlank(acc.Property__r.Status__c)) {
                    mapOfIdAndStatus.put(acc.Id, acc.Property__r.Status__c);
                }
            }
            
            for(Contact con : newList) {
                if (mapOfIdAndStatus.containsKey(con.AccountId) && String.isBlank(con.Status__c)) {
                    con.Status__c = mapOfIdAndStatus.get(con.AccountId);
                }
            }
        }
    }
}