/**
 * Purpose      : To Test The Attendee Trigger Handler
 * 
 * Created By 	: Mukul Pichunia
 * 
 * Created Date : 16-12-2024
 */


// This annotation indicates that the class is a test class.
// seeAllData = false (we are not using DB for testing) 
@isTest(seeAllData = false)
public with sharing class AttendeeTriggerTest {
	// Test data setup
    @TestSetup
    static void makeData () {
        System.debug('1');

        Contact contact_1 = new Contact(FirstName = 'Contact_1', LastName = 'Test_1', Phone = '9024318901');
        Contact contact_2 = new Contact(FirstName = 'Contact_2', LastName = 'Test_2', Phone = '9024318901');
        insert new List<Contact> {contact_1, contact_2};

        Training_Session__c session_1 = new Training_Session__c(Name = 'Java Session');
        Training_Session__c session_2 = new Training_Session__c(Name = 'Python Session');
        Training_Session__c session_3 = new Training_Session__c(Name = 'Salesforce Session');
        insert new List<Training_Session__c> {session_1, session_2, session_3};

        Attendee__c attendee_1 = new Attendee__c(Contact__c = contact_1.Id, Training_Session__c = session_1.Id, Email__c = 'mukulpichunia@gmail.com');
        Attendee__c attendee_2 = new Attendee__c(Contact__c = contact_2.Id, Training_Session__c = session_2.Id, Email__c = 'mukulpichunia@gmail.com');
        
        Attendee__c attendee_3 = new Attendee__c(Training_Session__c = session_2.Id, Email__c = 'mukulpichunia@gmail.com');
        Attendee__c attendee_4 = new Attendee__c(Contact__c = contact_2.Id, Training_Session__c = session_1.Id, Email__c = 'mukulpichunia@gmail.com');
        Attendee__c attendee_5 = new Attendee__c(Contact__c = contact_1.Id, Training_Session__c = session_3.Id, Email__c = 'mukulpichunia@gmail.com');
        insert new List<Attendee__c> {attendee_1, attendee_2, attendee_3, attendee_4, attendee_5};
        
    }

    
	/*
     * To check To Check the Number of Training Session on contact after Creating Attendee 
     * And adding contact and session to it.
     */
    @isTest
    public static void checkContactTest() {
        List<Contact> contactList = [SELECT Id, Number_of_training_sessions__c FROM Contact Where LastName  = 'Test_2' LIMIT 1];
        Test.startTest();
        
        for (Contact eachContact : contactList) {
            System.AssertEquals(2, eachContact.Number_of_training_sessions__c, 'Traning session count does not match');
        }
        
        Test.stopTest();
        
        
    }
    /*
     * To check To Check the Number of Training Session on contact after updating training 
     * session on Attendee either removing or after changing the session
     */
    @isTest
    public static void updateData() {
        List<Attendee__c> fetchAttendee = [SELECT Id, Contact__c, Training_Session__c FROM Attendee__c WHERE Contact__r.LastName = 'Test_1' AND Training_Session__r.Name = 'Salesforce Session'];
        
         Test.startTest();
       
       
       	List<Contact> contactList1 = [SELECT Id, Number_of_training_sessions__c FROM Contact Where LastName  = 'Test_2' LIMIT 1];
        
        for (Attendee__c eachAttendee : fetchAttendee) {
            eachAttendee.Contact__c = contactList1[0].id;
        }
        if (!fetchAttendee.isEmpty()) {
            Update fetchAttendee;
        }
        
        List<Contact> contactList = [SELECT Id, Number_of_training_sessions__c FROM Contact Where LastName  = 'Test_2' LIMIT 1];
        for (Contact eachContact : contactList) {
            System.AssertEquals(3, eachContact.Number_of_training_sessions__c, 'Traning session count does not match');
        }
        
        Test.stopTest();
    }

    // To Check the Number of contact on contact after deletion of attendee
   @isTest
    public static void deleteData() {
        Test.startTest();
        List<Attendee__c> fetchAttendee = [SELECT Id, Contact__c, Training_Session__c FROM Attendee__c WHERE Contact__r.LastName = 'Test_2'];
       	delete fetchAttendee;
        
        
       
        List<Contact> contactList = [SELECT Id, Number_of_training_sessions__c FROM Contact Where LastName  = 'Test_2' LIMIT 1];
        for (Contact eachContact : contactList) {
            System.AssertEquals(0, eachContact.Number_of_training_sessions__c, 'Traning session count does not match');
        }
        
        Test.stopTest();
    }
    
    
    
    
    
    
    
}