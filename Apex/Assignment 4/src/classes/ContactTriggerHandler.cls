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
    //This Method Will be used in called of before insert
    /**
     * Purpose : Method to validate Contacts Email With Account Domain 
     *           in case of new contact record is inserted
     * @return : void
     * @Param  : List<Contact>
     */
    public static void validateAccountAndContactDomains(List<Contact> contacts) {
        checkDomainWithEmail(contacts);
    }
    /**
     * Purpose : Method to validate Contacts Email With Account Domain 
     *           in case of new contact record is updated
     * @return : void
     * @Param  : List<Contact> contacts and Map<Id, Contact> contactOldMap
     */
    public static void validateAccountAndContactDomainsUpdate(List<Contact> contacts, Map<Id, Contact> contactOldMap) {
      	/* Old map can contain changed email ID or cannot contain Email Id and Can contain 
      	 * other changed email fields then Email Ids: What I have to check if oldMap have values changes in Email then i have to store 
      	 * it into list and call the method
      	 */
        List<Contact> newContacts = new List<Contact>();
        for (Contact c2 : contacts) {
            if (c2.Email != contactOldMap.get(c2.Id).Email) {
                newContacts.add(c2);
            }
        }
        
        if (!newContacts.isEmpty()) {
            checkDomainWithEmail(newContacts);
        }
    }

    /**
     * Purpose  :   This Method is used to validate Contact Email With the Domain in Account
     * @Params  :   List<Contact> contacts    
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
                if (String.isNotEmpty(c.Email)) {
                    List<String> emailParts = c.Email.split('@'); //['mukul','gmail.com']
                        if (domainMap.containsKey(c.AccountId)) {
                            if (!domainMap.get(c.AccountId).Domain_Name__c.equalsIgnoreCase(emailParts.get(1))) {
                                c.Email.addError('Email domain must match the domain in the associated Account.');
                            }
                        }
                    
                } else {
                    c.Email.addError('Enter Your Email Address');
                }
                
            } 
        }
    }
    
}