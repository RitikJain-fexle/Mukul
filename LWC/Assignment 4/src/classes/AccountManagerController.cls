/*
 * Purpose 		: Class To Fetch The List of Account to show in Component
 * 
 * Created by	: Mukul Pichunia
 * 
 * Created Date : 03-02-25
 * 
 * Revision Log : V_1.0 - Created
 */
public without sharing class AccountManagerController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Phone, Industry, Rating, Website FROM Account LIMIT 10];
    }
}