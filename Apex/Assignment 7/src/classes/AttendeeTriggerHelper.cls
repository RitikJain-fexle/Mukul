/**
 * Purpose          :   Helper Class of Trigger on Attendee__c object
 * 
 * Created by       :   Mukul Pichunia
 * 
 * Created Date     :   16-12-2024
 * 
 * Revision Logs    :   V_1.0 - Created
 */
public without sharing class AttendeeTriggerHelper extends TriggerHandler {
    
    public override void afterInsert() {
        AttendeeTriggerHandler.handleAttendeeInsertUpdateAndDelete((List<Attendee__c>)trigger.new, (Map<Id, Attendee__c>)trigger.oldMap);
    }
    
    public override void afterUpdate() {
        AttendeeTriggerHandler.handleAttendeeInsertUpdateAndDelete((List<Attendee__c>)trigger.new, (Map<Id, Attendee__c>)trigger.oldMap);
    }
    
    public override void afterDelete() {
        AttendeeTriggerHandler.handleAttendeeInsertUpdateAndDelete((List<Attendee__c>)trigger.new, (Map<Id, Attendee__c>)trigger.oldMap);
    }
    
}