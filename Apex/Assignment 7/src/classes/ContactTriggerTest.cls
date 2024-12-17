/*
 * Purpose		: Test Class FOR Testing Contact Trigger Handler
 * 
 * Created Date : 17-12-2024
 * 
 * Created By 	: Mukul Pichunia
 */

@isTest(seeAllData = false)
public class ContactTriggerTest {
    @TestSetup
    static void makeData() {
        Account acc = new Account(Name = 'gmail.com', Domain_Name__c = 'gmail.com');
        Account acc2 = new Account(Name = 'fexle.com', Domain_Name__c = 'fexle.com');
        Account acc3 = new Account (Name = 'Account 2');
        insert new List<Account> {acc, acc2, acc3};
            
        List<Contact> contactList = makeContactData();
        
        Database.insert(contactList, false);
        
        
    }
    
    public static List<Contact> makeContactData() {
        
       	List<Account> accountList = [SELECT Id, Name From Account];
        Contact con;
        List<Contact> contactList = new list<Contact>();
        for (integer i = 0; i < 10; i++) {
            if(i < 4) {
                 //Email = gmail.com and account mail gmail.com 
                con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@gmail.com', phone = '9024318901', accountId = accountList[0].id);
            } else if (i >= 4 && i <=6) {
                //Email = fexle.com and account mail fexle.com
                con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@fexle.com', phone = '9024318901', accountId = accountList[1].id);
            } else if (i > 6 && i <= 8) {
                
                con = new Contact(LastName = 'Pichunia' + i , phone = '9024318901');
            } else {
                // This Must not be insert Email = @fexle.com and Domain on account gmail.com
                 con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@fexle.com', phone = '9024318901', accountId = accountList[0].id);
            }
            contactList.add(con);
        }
        return contactList;
    }
    
    @isTest(seeAllData = false)
    public static void testBeforeInsertContact() {
        
        List<Contact> contactList = makeContactData();
        
        
        
        
        Test.startTest();
        try {
        	insert contactList;
        } catch (DMLException e) {
         	Assert.isTrue(String.isNotBlank(e.getMessage()), e.getMessage());
        }
        Test.StopTest();
    }
    
    @isTest(seeAllData = false)
    public static void testBeforeUpdate() {
        
        List<Account> accountList = [SELECT Id From Account];

        List<Contact> contactList = [SELECT Id, Email, AccountId From Contact WHERE LastName LIKE '%Pichunia%'];
        
        for (Contact eachContact : contactList) {
            eachContact.AccountId = accountList[1].Id;
        }
        
        // Account domain to Fexle.com
        contactList[0].AccountId = accountList[1].id;

        // removal of Account Id
        contactList[1].AccountId = null;
        
        // IN this contact email and Account id was null So I have inserted
        contactList[7].Email = 'mukul.pichunia@gmail.com';
        contactList[7].AccountId = accountList[1].id;
        
        // This Contact have fexle during insertion and in Account it had gmail during insertion
         contactList[8].Email = 'mukul.pichunia@gmail.com';


        // Removal of Email from Contact
        contactList[5].Email = null;
        
        
        Test.startTest();
        try {
            
            update contactList;
            
        } catch (DMLException e) {
            Assert.isTrue(String.isNotBlank(e.getMessage()), e.getMessage());
        }
        Test.stopTest();
        
        
    }
    
    
}