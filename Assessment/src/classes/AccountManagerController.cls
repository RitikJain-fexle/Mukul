public without sharing class AccountManagerController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Phone, Industry, Rating, Website FROM Account LIMIT 10];
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountListByCreatedDate() {
        return [SELECT Id, Name, Phone, Industry, Rating, Website FROM Account ORDER BY CreatedDate DESC];
    }

}