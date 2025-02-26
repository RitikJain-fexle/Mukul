/**
 * Purpose        : This class serves as a response wrapper for the RESTful API endpoints in the InboundServices class.
 *                  It is used to standardize the structure of the response returned by the API, including status, message,
 *                  and the IDs of the created or updated records (Account and Contact).
 * 
 * Created by     : Mukul Pichunia
 * 
 * Created Date   : 22-02-2025
 * 
 * Revision Logs  : V_1.0 - Created
 */
global class InboundResponseWrapper {
    public String status;
    public String message;
    public String accountId;
    public String contactId;
}