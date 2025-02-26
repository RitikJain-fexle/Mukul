/**
 * Purpose        : This class serves as a RESTful API on Account.
 * 
 * Created by     : Mukul Pichunia
 * 
 * Created Date   : 22-02-2025
 * 
 * Revision Logs  : V_1.0 - Created
 */
@RestResource(urlMapping='/InboundServices/*')
global with sharing class InboundServices {
     /**
     * Method Name  :   doGet
     * 
     * Created by   :   Mukul Pichunia
     * 
     * Purpose      :   Method to handle HTTP GET requests
     * 
     * return       :   Returns a JSON object containing Account details or an error message in case of failure
     *    
    **/
    @HttpGet
	global static Account doGet() {
		RestRequest req = RestContext.request;
        RestResponse res = RestContext.response; // Represents an object used to pass data from an Apex RESTful Web service method to an HTTP response.
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        return result;
	}
    
    /**
     * Method Name  :   doPost
     * 
     * Created by   :   Mukul Pichunia
     * 
     * Purpose      :   Method to handle HTTP POST requests
     * 
     * return       :   Returns a JSON object with created AccountId and ContactId or an error message in case of failure
     * 
    **/

    @HttpPost
    global static InboundResponseWrapper  doPost() {

      
        RestRequest request = RestContext.request;
        InboundResponseWrapper response = new InboundResponseWrapper();
        System.debug(request);
        Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
        
        String accountName = (String) requestBody.get('accountName');
        String firstname = (String) requestBody.get('firstName');
        String lastName = (String) requestBody.get('lastName');
        String email = (String) requestBody.get('email');
        
        if (String.isBlank(accountName) || String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)) {
            response.status = 'Error';
            response.message = 'All fields are required';
            return response;
        } 
        
         
         List<Account> accList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];
         List<Account> accountList = new List<Account>();
         List<Contact> contactList = new List<Contact>();
         Contact con;
         Account existingAccount;
         if (!accList.isEmpty()) {
            System.debug(accList);
            existingAccount = accList[0];
            List<Contact> existingContact = [SELECT Id FROM Contact WHERE AccountId = :existingAccount.Id AND Email = :email LIMIT 1];
            if (!existingContact.isEmpty()) {
                response.status = 'Error';
                response.message = 'Contact already exist';
                response.accountId = existingAccount.Id;
                response.contactId = existingContact[0].id;
                return response;
            } else {
                    con = new Contact(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    AccountId = existingAccount.Id
                    );
                    contactList.add(con);
            }

         } else {
           existingAccount = new Account(Name = accountName);
            accountList.add(existingAccount);
            insert accountList;
            con = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                AccountId = existingAccount.id);
            contactList.add(con);
         }
        
        Database.SaveResult[] srList = Database.insert(contactList, false);

         for (Database.SaveResult result : srList) {
            if (result.isSuccess()) {
                response.status = 'Success';
                response.message = 'Account And Contact Created Successfully';
                response.accountId = existingAccount.id;
                response.contactId = con.id;
            } else {
                for(Database.Error err : result.getErrors()) {
                    response.status = 'Failed';
                    response.message = err.getStatusCode() + ': ' + err.getMessage();
                }
            }
         }
        
         return response;

    }
}