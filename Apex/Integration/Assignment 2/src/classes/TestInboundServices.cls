/** 
 * Purpose          :   Test Class for InboundServices class
 * 
 * Created by       :   Mukul Pichunia
 * 
 * Created Date     :   25-02-2025
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
@isTest
public with sharing class TestInboundServices {
    
    
    // Test Setup method for creating pre-required fake data
    @TestSetup
    static void makeData(){
        //Inserting New Account
        Account acc = new Account(Name = 'Fexle Services Private Limited');
        insert acc;
        Contact con = new Contact(LastName = 'testContact', AccountId = acc.id, Email = 'mukul.pichunia@fexle.com');
        insert con;
    }
    
    /**
     * Test method for doGet
     * Ensures account retrieval works correctly with valid account IDs.
     */
    @isTest
    static void testDoGet() {
        
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Fexle Services Private Limited' LIMIT 1];
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = 'https://fexle45-dev-ed.develop.my.salesforce.com/services/apexrest/InboundServices/' + acc.id;
        request.httpMethod = 'GET';
        RestContext.request = request; // used to set the actual Request
        // testing The API
        Account returnedAccount = InboundServices.doGet();
        
        Test.stopTest();
        
        Assert.isTrue(returnedAccount != null);
        Assert.areEqual('Fexle Services Private Limited', acc.Name);

    }
    
    /**
     * Test method for doPost
     * Ensures that a new Account and Contact are created successfully when valid data is provided.
     */
    
    @isTest
    static void testCreateAccountAndContact() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://fexle45-dev-ed.develop.my.salesforce.com/services/apexrest/InboundServices/';
        request.httpMethod = 'POST';
        String jsonBody = ' {"accountName" : "Shubham","firstName" : "hello","lastName" : "world 2","email" : "Xoriant2world@Homes.com"}';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        InboundResponseWrapper response = InboundServices.doPost();
       	System.debug(response);
        Test.stopTest();
        Assert.areEqual(response.status, 'Success');
        Assert.isNotNull(response.accountId);
        Assert.isNotNull(response.contactId);
    }
    
    /**
     * Test method for doPost
     * Ensures that an error is returned when attempting to create a Contact with an email that already exists.
     */
    @isTest
    static void testErrorCreateAccountAndContact() {
        test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://fexle45-dev-ed.develop.my.salesforce.com/services/apexrest/InboundServices/';
        request.httpMethod = 'POST';
        String jsonBody = ' {"accountName" : "Fexle Services Private Limited", "firstName" : "hello","lastName" : "world 2","email" : "mukul.pichunia@fexle.com"}';
        
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        InboundResponseWrapper response = InboundServices.doPost();
       	System.debug(response);
        Test.stopTest();
        Assert.areEqual(response.status, 'Error');
        Assert.areEqual(response.message, 'Contact already exist');
        
    }
    
    /**
     * Test method for doPost
     * Ensures that a new Contact is created successfully on an existing Account.
     */
    @isTest
    static void testNewContactOnExistingAccount() {
        test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://fexle45-dev-ed.develop.my.salesforce.com/services/apexrest/InboundServices/';
        request.httpMethod = 'POST';
        String jsonBody = ' {"accountName" : "Fexle Services Private Limited", "firstName" : "hello","lastName" : "world 2","email" : "mukul.pichunia2@fexle.com"}';
        
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        InboundResponseWrapper response = InboundServices.doPost(); 
        Test.stopTest();
        Assert.areEqual(response.status, 'Success');
        Assert.areEqual(response.message, 'Account And Contact Created Successfully');
        
    }
    
    /**
     * Test method for doPost
     * Ensures that an error is returned when required fields are missing or null.
     */
    @isTest
    static void testAccountContactNull() {
        test.startTest();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://fexle45-dev-ed.develop.my.salesforce.com/services/apexrest/InboundServices/';
        request.httpMethod = 'POST';
        String jsonBody = ' {"accountName" : "", "firstName" : "hello","lastName" : "world 2","email" : "mukul.pichunia2@fexle.com"}';
        
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        InboundResponseWrapper response = InboundServices.doPost(); 
        Test.stopTest();
        Assert.areEqual(response.status, 'Error');
        Assert.areEqual(response.message, 'All fields are required');
        
    }

    
}