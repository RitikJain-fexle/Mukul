/* 
 * Trigger Name: contactTrigger
 * Purpose: If Contact Status is blank and related account status is not blank then copy the account status in
 *      contact status.
 * If account status is blank and related property status is not blank then copy the property status in
 *       contact status.
 * 
 * Author: Mukul Pichunia
 * Created Date: 10-12-24
 */
trigger contactTrigger on Contact (before insert) {
    if (trigger.isBefore) {
        if(trigger.isInsert) {
            UpdateStatus.statusUpdateOnContact(trigger.new);
        }
    }
}