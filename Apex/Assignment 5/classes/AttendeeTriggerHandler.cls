/*
* Purpose          :   Handler Class of Trigger on Attendee__c object
* 
* Created by       :   Mukul Pichunia
* 
* Created Date     :   08-12-2024
* 
* Revision Logs    :   V_1.0 - Created
*/
public without sharing class AttendeeTriggerHandler {
    /*
	 * Method Name  :   handleAttendeeInsertUpdateAndDelete
	 * 
	 * Created by   :   Mukul Pichunia
	 * 
	 * Purpose      :   Create a set of contact ids
	 * 
	 * @return      :   void
	 * 
	 * @params      :   List<Attendee__c> newListOfAttendee, Map<Id, Attendee__c> mapOfOldAttendies 
	 * 
	 */
    public static void handleAttendeeInsertUpdateAndDelete(List<Attendee__c> newList, Map<Id, Attendee__c> oldMap) {
        
        Set<Id> contactIds = new Set<Id>();
        if (newList != null || oldMap != null) {
            
            for (Attendee__c att : newList != null ? newList : oldMap.values()) {
                
                if (att.Contact__c != null) {
                    contactIds.add(att.Contact__c);
                }
                if (oldMap != null && oldMap.get(att.Id).Contact__c != null && att.Contact__c != oldMap.get(att.Id).Contact__c) {
                    contactIds.add(oldMap.get(att.Id).Contact__c);
                }
            }
        }
        if (!contactIds.isEmpty()) {
            updateContact(contactIds);
        }
    }
    
    /*
	 * Method Name  :   updateContact
	 * 
	 * Created by   :   Mukul Pichunia
	 * 
	 * Purpose      :   Updates the 'No. Of Attended Training Session' field on the Contact object according to the number of sessions that the contact is enrolled in.
	 * 
	 * @return      :   void
	 * 
	 * @params      :   Set<Id> contactIds
	 * 
	 */
    public static void updateContact(Set<Id> contactIds) {
        
        Map<Id, Set<Id>> contactTrainingSessionMap = new Map<Id, Set<Id>>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        // This Query Provide List of attendees where contact__c value matches contact id in set
        List<Attendee__c> existingList = [SELECT Id, Attendee_Name__c, Contact__c, Training_Session__c 
                                          FROM Attendee__c 
                                          WHERE Contact__c IN :contactIds];
        
        
        if (!existingList.isEmpty()) {
           
            for (Attendee__c att : existingList) {
                if (att.Contact__c != null) {
                    if (!contactTrainingSessionMap.containsKey(att.Contact__c)) {
                        contactTrainingSessionMap.put(att.Contact__c, new Set<Id>());
                    }
                    contactTrainingSessionMap.get(att.Contact__c).add(att.Training_Session__c);
                }
            }
        }
        
        
        for (Id notAvail : contactIds) {
            
            if (!contactTrainingSessionMap.containsKey(notAvail)) {
                Contact cont = new Contact(
                    Id = notAvail,
                    Number_of_training_sessions__c = 0
                );
                contactsToUpdate.add(cont);
            } 
        }
        for (Id contactId : contactTrainingSessionMap.keySet()) {
            
            Contact cont = new Contact(
                Id = contactId,
                Number_of_training_sessions__c = contactTrainingSessionMap.get(contactId).size()
            );
            contactsToUpdate.add(cont);
        }
        
        // Performing the update if there are contacts to update
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
        
    }
}