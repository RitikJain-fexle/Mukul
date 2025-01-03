/**Purpose		:	Class for Contact Trigger
*
 * Created by	:	Mukul Pichunia
*
 * Created Date	:	05-12-24
*
 * Revision Log	:	V:1.0
 * 				:	V1.1 - Modified - 03/01/2024 - Mukul Pichunia -  Created method "addNameToContact", "getObjectName", "getAllPickList". 
*/
public without sharing class ContactTriggerHandler {
    
    /**
	 * @description		:	Method to validate Contacts Email With Account Domain in case of new contact record is updated
	 * 
	 * Created by		:	Mukul Pichunia
	 * 
	 * @args			:	List<Contact> contacts and Map<Id, Contact> contactOldMap
	 * 
	 * @return			:	void
	 * 
	 * @revision Log	:	V1.1 - Created  - 05-12-24 - Developer Name - Mukul Pichunia
     */
    public static void validateAccountAndContactDomainsInsertAndUpdate(List<Contact> contacts, Map<Id, Contact> contactOldMap) {
        
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact c2 : contacts) {
            if(contactOldMap == null || (contactOldMap!=null && contactOldMap.get(c2.Id).Email != null  
                                                			 && (c2.Email != contactOldMap.get(c2.Id).Email  
                                                             || c2.AccountId != contactOldMap.get(c2.Id).AccountId))) {
                    accountIds.add(c2.AccountId);
            }
        }
        
        if (!accountIds.isEmpty()) {

            Map<Id, Account> domainMap = new Map<Id, Account>([SELECT Id, Domain_Name__c 
                                                               FROM Account 
                                                               WHERE ID IN :accountIds]);
            for (Contact c : contacts) {         
                if (c.AccountId != null && String.isNotEmpty(c.Email) && !domainMap.isEmpty()) {
                    
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
    
    /**
    * @description	:	Method to populate the object name and picklist fields on the Contact record based on the provided RecordId__c field.
    * 
    * Created by	:	Mukul Pichunia
    * 
    * @args			:	List<Contact> newList - List of new Contact records,  Map<Id, Contact> oldMap - Map of old Contact records for comparison.
    * 
    * @return		:	void
    * 
    * @revision Log	:	V1.1 - Created  - 31/12/2024 - Developer Name - Mukul Pichunia
    */    
    public static void addNameToContact(List<Contact> newList,  Map<Id, Contact> oldMap) {

        Map<Id, String> recordIdNameMap = new Map<Id, String>();
        String textAreaValue = '';
        for (Contact con : newList) {
            System.debug('record Ids'  + con.RecordId__c);
            if (String.isNotBlank(con.RecordId__c)) {
                recordIdNameMap = getObjectName(con.RecordId__c);
            }
            
            if (!recordIdNameMap.isEmpty()) {
                System.debug('record Ids'  + con.RecordId__c);
                con.ObjectName__c = recordIdNameMap.get(con.RecordId__c);
                
                textAreaValue = String.join(getAllPickList(con.RecordId__c), '\n');
                
                con.PicklistFields__c = textAreaValue;
                
            } else {
                con.ObjectName__c = '';
                con.PicklistFields__c = '';
            }
            
            
        }
    }
    	
    /**
    * @description	:	Method to fetch the object name associated with the given record ID. Verifies the record existence and retrieves the object type name.
    * 
    * Created by	:	Mukul Pichunia
    * 
    * @args			:	Id recordId - Record ID to fetch the object name.
    * 
    * @return		:	Map<id, String>
    * 
    * @revision Log	:	V1.1 - Created  - 31/12/2024 - Developer Name - Mukul Pichunia
    */   
    public static Map<id, String> getObjectName(Id recordId) {

        Map<Id, String> recordIdNameMap = new Map<Id, String>();
        Schema.SObjectType sObjectRecord  = recordId.getSObjectType();
        if (!checkForRecordExistance(sObjectRecord, recordId)) {
            throw new DMLException('Invalid Record Id');
        }
        Schema.DescribeSObjectResult objDescribe = sObjectRecord.getDescribe();
        if (String.isNotBlank(objDescribe.getName())) {
            recordIdNameMap.put(recordId, objDescribe.getName());
        }
        return recordIdNameMap;
        
    }
    
    /**
    * @description	:	Method to check if a record exists in the database for a given record ID.
    * 
    * Created by	:	Mukul Pichunia
    * 
    * @args			:	Schema.SObjectType objectName - SObject type of the record, Id recordId - Record ID to check existence.
    * 
    * @return		:	Boolean - True if the record exists, otherwise false.
    * 
    * @revision Log	:	V1.1 - Created  - 31/12/2024 - Developer Name - Mukul Pichunia
    */ 
    public static Boolean checkForRecordExistance(Schema.SObjectType objectName, Id recordId) {

        if (objectName != null) {
            String query = 'SELECT ID FROM '+objectName+' WHERE ID =: recordId';
            List<SObject> records = Database.query(query);
            if (!records.isEmpty()) {
                return true;
            }
        }
        return false;
    }
    
    /**
    * @description	:	Method to retrieve all picklist field names for a given record ID's object type.
    * 
    * Created by	:	Mukul Pichunia
    * 
    * @args			:	Id recordId - Record ID to fetch picklist fields.
    * 
    * @return		:	List<String> - List of picklist field names for the object.
    * 
    * @revision Log	:	V1.1 - Created  - 31/12/2024 - Developer Name - Mukul Pichunia
    */ 
    public static List<String> getAllPickList(Id recordId) {

        List<String> picklistName = new List<String>();
        if (recordId != null) {
        Map<String, Schema.SObjectField> fieldMap = recordId.getSObjectType().getDescribe().Fields.getMap();
        for (Schema.SobjectField sc : fieldMap.values()) {
            Schema.DescribeFieldResult dfr = sc.getDescribe();
            if (dfr != null && (dfr.getType() == Schema.DisplayType.PICKLIST)) {
                picklistName.add(dfr.getName());
            }
        }
        }
        return picklistName;
    }
    
}