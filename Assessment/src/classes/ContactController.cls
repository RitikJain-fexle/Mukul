/**
 * 
 * Purpose 			: Apex Controller Class to handle Contact-related operations.
 * 
 * Created Date 	: 05/02/2025
 * 
 * Created By 		: Mukul Pichunia
 * 
 * Revision Logs 	: V_1.0 - Created - 05/02/2025
 * 
 */
public without sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT
                Id,
                Name,
                FirstName,
                LastName,
                Title,
                Phone,
                Email,
                Picture__c
            FROM Contact
            WHERE Picture__c != NULL
            WITH USER_MODE
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Name LIKE :key AND Picture__c != NULL
            WITH USER_MODE
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WITH USER_MODE
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static void updateContacts(List<Contact> contactsForUpdate) {
        // Make sure we can update the database before trying to update
        if (!Schema.sObjectType.Contact.isUpdateable()) {
            throw new SecurityException(
                'Insufficient permissions to update contacts'
            );
        }
        update contactsForUpdate;
    }

    @AuraEnabled
    public static void updateContact(
        Id recordId,
        String firstName,
        String lastName
    ) {
        Contact contact = new Contact(
            Id = recordId,
            FirstName = firstName,
            LastName = lastName
        );
        update contact;
    }
    
    
/**
* @description	:	Retrieves a list of contacts associated with a given Account ID. Supports optional filtering by contact name.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	recordId and search key.
* 
* @return		:	data and error in JSON format.
* 
* @revision Log	:	V1.1 - Created  - 06/02/2025 - Developer Name - Mukul Pichunia
*/ 
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactsFromRelatedAccountId(Id recordId, String searchKey){
        
        try {
            
            if (String.isEmpty(recordId)) {
                throw new IllegalArgumentException('Record ID cannot be null or empty');
            }
            
            List<Contact> contactList = new List<Contact>();
            String queryString = 'SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE accountId = :recordId';
            
            if (!String.isEmpty(searchKey)) {
                
                String searchWord =   '\'%' + searchKey + '%\''  ;
                queryString = queryString+' AND Name LIKE ' + searchWord;
            }
            
            contactList = Database.query(queryString);
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException('An error occurred while fetching contacts: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Contact insertContact(String firstName, String lastName, String email, String id, Boolean active) {
        System.debug('firstName' + firstName);
        System.debug('lastName' + lastName);
        System.debug('email' + email);
        System.debug('id' + id);
        try {
            if (String.isEmpty(lastName)) {
                throw new IllegalArgumentException('lastName cannot be null or empty');
            }
            Contact insertContact = new Contact(FirstName = firstName, LastName = lastName, Email = email, AccountId = id, isActive__c = active);
            
            insert insertContact;
            return insertContact;
        } catch(Exception e) {
            throw new AuraHandledException('An error occurred while fetching contacts: ' + e.getMessage());
        }
    }
    
    
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts() {

        System.debug('Inside Get COntacts');
        return [SELECT ID, FirstName, LastName,Phone ,Email FROM Contact LIMIT 10];
    }
    

@AuraEnabled    
    public static String updateContactRecords(Object contactData) {
        System.debug('contact-data : ' + contactData);
        
        List<Contact> contactList =(List<Contact>) JSON.deserialize(JSON.serialize(contactData), List<Account>.class);
        if (!contactList.isEMpty()) {
            update contactList;
            return 'Success';
        }
        return 'Failed'; 
       
    }
}