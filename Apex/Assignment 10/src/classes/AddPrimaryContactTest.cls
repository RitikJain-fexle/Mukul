/*
 * Purpose 		: Test class to test AddPrimaryContact
 * 
 * Created by	: Mukul Pichunia
 * 
 * Created Date : 20-12-24
 * 
 * Revision Log : V_1.0 - Created
 */
@isTest(SeeAllData = false)
public class AddPrimaryContactTest {
    @TestSetup
    public static void makeDate() {
        List<Account> accountsNY = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accountsNY.add(new Account(
                Name = 'Account NY ' + i,
                BillingState = 'NY'
            ));
        }
        
        // Create 50 Account records for CA
        List<Account> accountsCA = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accountsCA.add(new Account(
                Name = 'Account CA ' + i,
                BillingState = 'CA'
            ));
        }
        
         insert accountsNY;
        insert accountsCA;
    }
    
    @isTest
    static void testAddPrimaryContact() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test.contact@example.com'
        );
        
        
        insert testContact;
        AddPrimaryContact ap = new AddPrimaryContact(testContact, 'CA');
        Test.startTest();
        System.enqueueJob(ap);
        Test.stopTest();
        List<Contact> insertedContacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE Account.BillingState = 'CA'
        ];
        Assert.areEqual(50, insertedContacts.size(), 'Expected 50 Contacts to be inserted for CA Accounts');
    }
    
}