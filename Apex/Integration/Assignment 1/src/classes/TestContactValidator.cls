/**
 * Purpose        : This test class is used to test the functionality of the `ContactNameValidator` class,
 *                  specifically the address validation logic using the Smarty Streets API.
 * 
 * Created by     : Mukul Pichunia
 * 
 * Created Date   : 20-02-2025
 * 
 * Revision Logs  : V_1.0 - Created
 */
@isTest
public class TestContactValidator {
    
    
    /**
     * Inner class to mock HTTP callouts for testing purposes.
     * This class implements the `HttpCalloutMock` interface to simulate API responses
     * without making actual HTTP requests.
     */
    
    private class HttpMockFactory implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req){
            HttpResponse res = new httpResponse();
            res.setBody('[{"input_index":0,"candidate_index":0,"delivery_line_1":"525 S Winchester Blvd","last_line":"San Jose CA 95128-2537","delivery_point_barcode":"951282537251","components":{"primary_number":"525","street_predirection":"S","street_name":"Winchester","street_suffix":"Blvd","city_name":"San Jose","default_city_name":"San Jose","state_abbreviation":"CA","zipcode":"95128","plus4_code":"2537","delivery_point":"25","delivery_point_check_digit":"1"},"metadata":{"record_type":"S","zip_type":"Standard","county_fips":"06085","county_name":"Santa Clara","carrier_route":"C013","congressional_district":"17","rdi":"Commercial","elot_sequence":"0095","elot_sort":"A","latitude":37.3176,"longitude":-121.95026,"precision":"Zip9","time_zone":"Pacific","utc_offset":-8,"dst":true},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","dpv_no_stat":"N","active":"Y"}}]');
            res.setStatusCode(200);
            return res;
        }
    }
    
    /**
     * Test method to validate the address validation logic in the `ContactNameValidator` class.
     * This method creates a test Contact record, mocks the HTTP callout, and verifies that
     * the address validation result is correctly updated on the Contact record.
     */
   
    @isTest
    static void checkForValidation() {
        contact contactTest = new Contact();
        contactTest.LastName = 'Contact1000';
        contactTest.MailingStreet ='1600 amphitheatre';
        contactTest.MailingCity = 'mountain view';
        contactTest.MailingState ='CA';
        insert contactTest;
        //String mailingCity, String mailingState, String mailingCountry, String mailingStreet, Id contactId
        Test.setMock(HttpCalloutMock.class,new HttpMockFactory());
        List<Contact> CheckTestId = [SELECT Id, MailingStreet, MailingCity, MailingState FROM Contact WHERE LastName = 'Contact1000'];
        Test.startTest();
        ContactNameValidator.createConnection(CheckTestId[0].MailingCity, CheckTestId[0].MailingState, Null, CheckTestId[0].MailingStreet, CheckTestId[0].id);
        Test.stopTest();
        List<Contact> fetchedContact  = [SELECT Id, MailingStreet, MailingCity, MailingState, isAddressValid__c FROM Contact WHERE LastName = 'Contact1000'];
        System.debug('fetchedContact ' +fetchedContact);
        Assert.areEqual(true, fetchedContact[0].isAddressValid__c);
        
    }

	    
}