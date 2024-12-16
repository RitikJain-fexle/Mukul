/* 
* Trigger Name: contactTrigger
* Purpose: To validate that the email domains of Contact records match 
*          the domain in their associated Account before they are inserted or updated.
* 
* Trigger Events:
* - Before Insert: Validate new Contact records before they are saved to the database.
* - Before Update: Validate existing Contact records when they are being updated.
* 
* Author: Mukul Pichunia
* Created Date: 05-12-24
*/
trigger contactTrigger on Contact (before insert, before update, after insert) {
    
    new ContactTriggerHelper().run();
    
}