/** 
 * Purpose          :   Helper Class of Trigger on contact object
 * 
 * Created by       :   Mukul Pichunia
 * 
 * Created Date     :   16-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
public without sharing class ContactTriggerHelper extends TriggerHandler {
    
    public override void beforeInsert() {
         ContactTriggerHandler.validateAccountAndContactDomainsInsertAndUpdate((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
    }
    
    public override void beforeUpdate() {
         ContactTriggerHandler.validateAccountAndContactDomainsInsertAndUpdate((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
    }  
}