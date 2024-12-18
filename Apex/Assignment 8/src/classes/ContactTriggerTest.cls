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
        Account acc4 = new Account(Name = 'gmail2.com');
        insert new List<Account> {acc, acc2, acc3, acc4};
            
            
            
        List<Contact> contactList = makeContactData();
        System.debug('>>>>>> contactList' + contactList);
        
        Database.insert(contactList, false);
        
        
        
        
    }
    
    public static List<Contact> makeContactData() {
        
       	List<Account> accountList = [SELECT Id, Name From Account];
        Contact con;
        List<Contact> contactList = new list<Contact>();
        for (integer i = 0; i < 15; i++) {
            if(i < 4) {
                 //Email = gmail.com and account mail gmail.com 
                con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@gmail.com', phone = '9024318901', accountId = accountList[0].id);
            } else if (i >= 4 && i <=6) {
                //Email = fexle.com and account mail fexle.com
                con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@fexle.com', phone = '9024318901', accountId = accountList[1].id);
            } else if (i > 6 && i <= 12) {
  
                con = new Contact(LastName = 'Pichunia' + i , phone = '9024318901', accountId = accountList[3].id);
            } else {
                // This Must not be insert Email = @fexle.com and Domain on account gmail.com
                 con = new Contact(LastName = 'Pichunia' + i , Email = 'mukul.pichunia'+i+'@fexle.com', phone = '9024318901', accountId = accountList[0].id);
            }
            contactList.add(con);
        }
        
        System.debug('contactList: '+contactList);
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

    @isTest(seeAllData = false)
    public static void testAfterInsert() {	
       List<Account> accountList = [SELECT Id,Number_Of_Contacts__c FROM Account WHERE Name = 'gmail.com'];
        //List<Contact> contactList = [SELECT Id, AccountId From Contact WHERE AccountId = :accountList[0].id];
        //System.debug('??????? >>> ' + contactList);
        System.debug('accountList: '+accountList);
        for (Account acc : accountList) {
            System.debug('>>>>> accountList: '+ acc );
        }
        Test.startTest();  
        Assert.areEqual(4, Integer.valueOf(accountList[0].Number_Of_Contacts__c), 'Number of Contacts does not match');
        Test.stopTest();
    }
    @isTest(seeAllData = false)
    public static void testAfterUpdate() {
        
        List<Account> accountList = [SELECT Id, Number_Of_Contacts__c From Account];
        System.debug('Account inside testForUpdate >>>>>>>>>>>>>>>>>>>> ' + accountList);
        List<Contact> contactList = [SELECT Id, Email, AccountId From Contact WHERE LastName LIKE '%Pichunia%'];
        System.debug('contactList inside testForUpdate >>>>>>>>>>>>>>>>>>>> ' + contactList);
        List<Contact> newContactList = new List<Contact>();
        for (Contact cc : contactList) {
            if (String.isBlank(cc.Email)) {
                cc.AccountId = accountList[2].id;
            }
        }
        
        System.debug('newContactList inside testForUpdate >>>>>>>>>>>>>>>>>>>> ' + newContactList);
        
        
        Test.startTest();  
        update contactList;
        List<Account> accountList2 = [SELECT Id, Number_Of_Contacts__c From Account];
        System.debug('Account inside testForUpdate >>>>>>>>>>>>>>>>>>>> ' + accountList2);
        Assert.areEqual(6, Integer.valueOf(accountList[2].Number_Of_Contacts__c), 'Number of Contacts does not match accountList[2]' + accountList[2].id);
        Assert.areEqual(0, Integer.valueOf(accountList[3].Number_Of_Contacts__c), 'Number of Contacts does not match accountList[3]' + accountList[3].id);
        Test.stopTest();
        	
        
        
    }
    
    @isTest(seeAllData = false)
    public static void testAfterDelete() {
        List<Contact> contactList = [SELECT Id, Email, AccountId From Contact];
        Database.delete(contactList);
        List<Account> accountList = [SELECT Id, Number_Of_Contacts__c From Account];
        
        Test.startTest(); 
        Assert.areEqual(0, Integer.valueOf(accountList[3].Number_Of_Contacts__c), 'Number of Contacts does not match accountList[3]' + accountList[3].id);
        Test.stopTest();
    }
    
}