/*Purpose: Class to validate the domains of Contacts email addresses against the associated Account's domain. 
 * Created by: Mukul Pichunia
 * Created Date : 05-12-24
 * Rivision Log: V:1.1
 */
public without sharing class ValidateDomains {
    public static void validateAccountAndContactDomains(List<Contact> contacts) {
        if (contacts == null || contacts.isEmpty()) {
            return; // No contacts to process
        }
        Set<Id> accountIds = new Set<Id>();
                for (Contact c2 : contacts) {
                    if (c2.AccountId != null) {
                        accountIds.add(c2.AccountId);
                    }
                }
                Map<Id, Account> domainMap = new Map<Id, Account>([SELECT Id, Domain_Name__c FROM Account WHERE ID IN :accountIds]);
                for (Contact c : contacts) {            
                    if (c.AccountId != null) {
                        if (String.isNotEmpty(c.Email)) {
                            List<String> emailParts = c.Email.split('@'); //['mukul','gmail.com']
                            if(emailParts.size() == 2) {
                                 if (domainMap.containsKey(c.AccountId)) {
                                    if (!domainMap.get(c.AccountId).Domain_Name__c.equalsIgnoreCase(emailParts.get(1))) {
                                        c.Email.addError('Email domain must match the domain in the associated Account.');
                                    }
                            	}
                            } else {
                                c.Email.addError('Invalid email format. Please provide a valid email address.');
                            }
                           
                        } else {
                        	c.Email.addError('Enter Your Email Address');
                    	}
                        
                    } 
                }
    }
}