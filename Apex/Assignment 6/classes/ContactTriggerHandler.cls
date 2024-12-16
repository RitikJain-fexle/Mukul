/*Purpose: Class to validate the domains of Contacts' email addresses 
*          against the associated Account's domain.
*
* Created by: Mukul Pichunia
*
* Created Date : 05-12-24
*
* Revision Log: V:1.1
*/
public without sharing class ContactTriggerHandler {
    
    /**
     * Purpose    : Method to validate Contacts Email With Account Domain 
     *              in case of new contact record is updated
     * Created by : Mukul Pichunia
     * @return    : void
     * @Param     : List<Contact> contacts and Map<Id, Contact> contactOldMap
     */
    public static void validateAccountAndContactDomainsInsertAndUpdate(List<Contact> contacts, Map<Id, Contact> contactOldMap) {
        
        List<Contact> newContacts = new List<Contact>();
        for (Contact c2 : contacts) {
            if(contactOldMap == null || (contactOldMap!=null && (c2.Email != contactOldMap.get(c2.Id).Email
                || c2.AccountId != contactOldMap.get(c2.Id).AccountId))) {
                newContacts.add(c2);
            }
        }
        
        if (!newContacts.isEmpty()) {
            checkDomainWithEmail(newContacts);
        }
    }

    /**
     * Purpose    :   This Method is used to validate Contact Email With the Domain in Account
     * 
     * Created by :   Mukul Pichunia
     * 
     * @Params    :   List<Contact> contacts    
     * 
     */
    public static void checkDomainWithEmail(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact c2 : contacts) {
            if (c2.AccountId != null) {
                accountIds.add(c2.AccountId);
            }
        }
        Map<Id, Account> domainMap = new Map<Id, Account>([SELECT Id, Domain_Name__c 
                                                           FROM Account 
                                                           WHERE ID IN :accountIds]);
        for (Contact c : contacts) {            
            if (c.AccountId != null) {
                if (String.isNotEmpty(c.Email)) { // vs IsBlank
                    List<String> emailParts = c.Email.split('@'); //['mukul','gmail.com']
                    if (domainMap.containsKey(c.AccountId)) {
                        if (!domainMap.get(c.AccountId).Domain_Name__c.equalsIgnoreCase(emailParts.get(1))) {
                            c.Email.addError('Email domain must match the domain in the associated Account.');
                        }
                    } 
                }   
            } 
        }
    }
    
}