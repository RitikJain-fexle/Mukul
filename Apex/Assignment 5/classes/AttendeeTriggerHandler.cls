public without sharing class AttendeeTriggerHandler {
    public static void handleAttendeeInsertUpdateAndDelete(List<Attendee__c> newList, Map<Id, Attendee__c> oldMap) {
        System.debug('***** newList' + newList);
        System.debug('***** oldMap' + oldMap);
        Set<Id> contactIds = new Set<Id>();
        for (Attendee__c att : newList != null ? newList : oldMap.values()) {
            if (newList != null || oldMap != null) {
                if (att.Contact__c != null) {
                    contactIds.add(att.Contact__c);
                }
            }
            if (oldMap != null && oldMap.get(att.Id).Contact__c != null && att.Contact__c != oldMap.get(att.Id).Contact__c) {
                contactIds.add(oldMap.get(att.Id).Contact__c);
            }
        }
        updateContact(contactIds);
    }
    
    
    public static void updateContact(Set<Id> contactIds) {
        System.debug('****** contactIds ' + contactIds);
        // This Query Provide List of attendees where contact__c value matches contact id in set
        List<Attendee__c> existingList = [SELECT Id, Attendee_Name__c, Contact__c, Training_Session__c 
                                          FROM Attendee__c 
                                          WHERE Contact__c IN :contactIds];
        System.debug('****** existingList ' + existingList);
        Map<Id, Set<Id>> contactTrainingSessionMap = new Map<Id, Set<Id>>();
        for (Attendee__c att : existingList) {
            if (att.Contact__c != null) {
                if (!contactTrainingSessionMap.containsKey(att.Contact__c)) {
                    contactTrainingSessionMap.put(att.Contact__c, new Set<Id>());
                }
                contactTrainingSessionMap.get(att.Contact__c).add(att.Training_Session__c);
            }
        }
        System.debug('$$$$ contactTrainingSessionMap IN Delete : ' + contactTrainingSessionMap);
        List<Contact> contactsToUpdate = new List<Contact>();
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
        System.debug('####contactsToUpdate ' + contactsToUpdate);
        // Performing the update if there are contacts to update
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}