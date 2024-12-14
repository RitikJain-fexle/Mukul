trigger AttendeeTrigger on Attendee__c (before insert, after insert, after update, after delete) {
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate || trigger.isDelete) {
            AttendeeTriggerHandler.handleAttendeeInsertUpdateAndDelete(trigger.new, trigger.oldMap);
        }
    }
    
}