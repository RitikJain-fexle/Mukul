trigger AttendeeTrigger on Attendee__c (before insert, after insert, after update, after delete) {
   new AttendeeTriggerHelper().run();
}