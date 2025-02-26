/** 
 * Purpose          :   This class serves as a helper for the Contact trigger, specifically to validate mailing addresses
 *                      using an external API (Smarty Streets). It ensures that the address provided for a Contact is valid
 *                      and updates the Contact record with the validation result.
 * 
 * Created by       :   Mukul Pichunia
 * 
 * Created Date     :   20-02-2025
 * 
 * Revision Logs    :   V_1.0 - Created
 * 
**/

public class ContactNameValidator {
/**
 * @description    :   Validates the mailing address of a Contact using the Smarty Streets API. This method makes an HTTP callout
 *                      to the API, checks the response for address validation, and updates the Contact record with the validation result.
 *                      The method is marked as `@future` to allow callouts from triggers.
 * 
 * @param mailingCity     :   The city part of the Contact's mailing address.
 * @param mailingState    :   The state part of the Contact's mailing address.
 * @param mailingCountry  :   The country part of the Contact's mailing address.
 * @param mailingStreet   :   The street part of the Contact's mailing address.
 * @param contactId       :   The ID of the Contact record to be updated with the validation result.
 * 
 * @return               :   void - This method does not return any value but updates the Contact record in the database.
 * 
 * @revision Log         :   V1.0 - Created  - 20/02/2025 - Developer Name - Mukul Pichunia
 */
    @future(Callout = true)
    public static void createConnection(String mailingCity, String mailingState, String mailingCountry, String mailingStreet, Id contactId) {
        
        
        // Insert These in Custom meta data
        String authId = 'db1caac2-8aa4-9f98-c07e-5ca4b2e1f4ad';
        String authtoken='8izFQVLwrdDHXVctvAXu';
        Http http = new Http();
        HttpRequest connection = new HttpRequest();
        String city = EncodingUtil.urlEncode(mailingCity, 'UTF-8'); // Encodes a string into the application/x-www-form-urlencoded
        //String country = EncodingUtil.urlEncode(mailingCountry, 'UTF-8');
        String street = EncodingUtil.urlEncode(mailingStreet, 'UTF-8');
        String state = EncodingUtil.urlEncode(mailingState, 'UTF-8');
        
        connection.setEndPoint('https://us-street.api.smarty.com/street-address?auth-id='
                               +authId+'&auth-token='
                               +authtoken+'&street='
                               +street+'&city='
                               +city+'&state='
                               +state+'&candidates=10');
        
        //connection.setHeader('Content-Type', 'application/json');
        connection.setMethod('GET');
        HttpResponse res = http.send(connection);
        
        String resBody = (String) res.getBody();
        
        System.debug('BODY ' + resBody);
        String dpvMatchCode = '';
        if (resBody.length() > 3) {
            List<Object> responseList  = (List<Object>)JSON.deserializeUntyped(resBody);
            Map<String, Object> firstResponse = (Map<String, Object>) responseList[0];
            Map<String, Object> analysisMap = (Map<String, Object>) firstResponse.get('analysis');
            dpvMatchCode = (String) analysisMap.get('dpv_match_code');
        } 
        
        
        List<Contact> updateContactList = new List<Contact>();
        Contact updateContact = new Contact(Id = contactId);
        if (res.getStatusCode() == 200 && dpvMatchCode.equals('Y')) {
            
            updateContact.isAddressValid__c = true;
            
        } else if (dpvMatchCode.equals(''))  {
            
            updateContact.isAddressValid__c = false;
        }
        
        updateContactList.add(updateContact);
        
        if (!updateContactList.isEmpty()) {
            
            upsert updateContactList;
        }
        
    }
    
}