/**
 * Description		:	Test Class for Testing Contact Trigger Handler
 * 
 * Created Date 	:	17-12-2024
 * 
 * Created By 		:	Mukul Pichunia
 * 
 * Revision Logs   	: 	V1.0 - Created - Mukul Pichunia
 *		       	 	 
 */

 @isTest(seeAllData = false)
 public class ContactTriggerTest {
     
    
     @testSetup
     static void setupTestData() {
        
         Account acc1 = new Account(Name = 'Test Account', Domain_Name__c = 'example.com');
         Account acc2 = new Account(Name = 'Another Account', Domain_Name__c = 'test.com');
         insert new List<Account> { acc1, acc2 };
             
         Contact contact1 = new Contact(FirstName = 'mukul', LastName = 'pichunia', 
                                        Email = 'mukul.pichunia@example.com', AccountId = acc1.Id, Phone = '9024318901', RecordId__c = acc1.Id);
         
         Contact contact2 = new Contact(FirstName = 'abc', LastName = 'xyz', 
                                        Email = 'mukul.pichunia@test.com', AccountId = acc2.Id, Phone = '9024318901', RecordId__c = acc1.Id);
         insert new List<Contact> { contact1, contact2 };
     }
     
     /**
     * @description	:	Method to test Insertion of Contact record when Account Domain Not Equals To Email Domain on Contact.
     * 
     * Created by	:	Mukul Pichunia
     * 
     * @args			:	-
     * 
     * @return		:	-
     * 
     * @revision Log	:	V1.1 - Created  - 03/01/2024 - Developer Name - Mukul Pichunia
     */
     @isTest
     static void testInsertScenario() {
         
         Account acc1 = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
   
         Contact contactInvalid = new Contact(FirstName = 'pichunia', LastName = 'mukul', 
                                              Email = 'mukul.pichunia@gmail.com', AccountId = acc1.Id, Phone = '9024318901');
 
         Test.startTest();
         try {
             insert contactInvalid;
         } catch (Exception e) {
             System.assert(e.getMessage().contains('Email domain must match the domain in the associated Account.'));
         }
         Test.stopTest();
     }
     
     /**
     * @description	:	Method to test updation of Contact record when Account Domain Not Equals To Email Domain on Contact.
     * 
     * Created by	:	Mukul Pichunia
     * 
     * @args			:	-
     * 
     * @return		:	-
     * 
     * @revision Log	:	V1.1 - Created  - 03/01/2024 - Developer Name - Mukul Pichunia
     */
     @isTest
     static void testUpdateScenario() {
 
         Contact contactToUpdate = [SELECT Id, Email, AccountId FROM Contact WHERE Email = 'mukul.pichunia@example.com' LIMIT 1];
         contactToUpdate.Email = 'mukul.pichunia@invalid.com';
         Test.startTest();
         try {
              update contactToUpdate;
         } catch (Exception e) {
             System.assert(e.getMessage().contains('Email domain must match the domain in the associated Account.'));
         }
         Test.stopTest();
     }
     
 }