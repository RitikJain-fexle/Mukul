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
        ContactTriggerHandler.addNameToContact((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
        ContactTriggerHandler.copyAccountPhoneOnContact((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
    }
    
    public override void beforeUpdate() {
        
        ContactTriggerHandler.validateAccountAndContactDomainsInsertAndUpdate((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
        ContactTriggerHandler.addNameToContact((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
        ContactTriggerHandler.copyAccountPhoneOnContact((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
    }

    public override void afterInsert() {
        ContactTriggerHandler.validateContactAddressWhenInsertedAndUpdated((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
          Set<Id> accountIds =  createContactSet((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
          AccountProcessor.countContacts(accountIds);
            
          
    }

    public override void afterUpdate() {
        
         ContactTriggerHandler.validateContactAddressWhenInsertedAndUpdated((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
        Set<Id> accountIds = createContactSet((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
         
        try {
             AccountProcessor.countContacts(accountIds);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
      
    }

    public override void afterDelete() {
          Set<Id> accountIds = createContactSet((List<Contact>) trigger.new, (Map<Id, Contact>) trigger.oldMap);
          AccountProcessor.countContacts(accountIds);
    }
    
    
    /**
     * Purpose      : This method is used to create a Set of account Ids
     * 
     * Created By   : Mukul Pichunia
     * 
     * Created Date : 17-12-2024
     */
    public static Set<Id> createContactSet(List<Contact> newList, Map<Id, Contact> oldMap) {
       
          Set<Id> accountIds = new Set<Id>();

          for (Contact eachContact : newList != null ? newList : oldMap.values()) {
              
               if (eachContact.AccountId != null) {
                 	
                    accountIds.add(eachContact.AccountId);
               }

               if (oldMap != null && oldMap.get(eachContact.Id).AccountId != null && eachContact.AccountId != oldMap.get(eachContact.Id).AccountId) {
                   
                    accountIds.add(oldMap.get(eachContact.Id).AccountId);
               }  
          }
       		
          return accountIds;
          
    }
}