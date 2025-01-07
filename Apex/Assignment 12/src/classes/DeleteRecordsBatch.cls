/**
 *  Description     :  Batch class to delete records, generate a CSV log of the deleted records, 
 *                     and email the CSV file as an attachment.
 *
 *  Created By      :  Mukul Pichunia
 *
 *  Created Date    :  03/01/2025
 *
 *  Revision Logs   :  V1.0 - Created - Mukul Pichunia
 *
 **/
public without sharing class DeleteRecordsBatch implements Database.Batchable<sObject> , Database.stateful{
    
    @testVisible
    public static String csv = '';
    
    @testVisible
    public static String csvHeaders = '';
    
    @testVisible
    String query = '';
    
    @testVisible
    private List<String> parameter = new List<String>();
    private Blob csvBlob;
    
    public DeleteRecordsBatch(String query, List<String> parameter) {
        System.debug('@@@ Parameter' + parameter);
         System.debug('@@@ query' + query);
        this.query = query;
        this.parameter = parameter;
        System.debug('@@@ this.query ' + this.query );
        System.debug('@@@ this.parameter' + this.parameter);
        
    }
    
    /**
     * 
     *   @description    :   Start method to provide the query locator for the batch execution.
     *
     *   @args           :   Database.BatchableContext ctx - Batchable context for the execution.
     *
     *   @return         :   Database.QueryLocator
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Start logic implemented.
     * 
     **/
    
    public Database.QueryLocator start(Database.BatchableContext ctx) {
         Database.QueryLocator ql = Database.getQueryLocator(query);
         System.debug('Check For ' + ql);
        return ql;
    } 
    
     /**
     * 
     *   @description    :   Execute method to process the records in batches, 
     *                       delete them, and create a CSV log.
     *
     *   @args           :   Database.BatchableContext ctsx - Batchable context for the execution.
     *                        List<SObject> records - List of records to be processed in the batch.
     *
     *   @return         :   void
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Execute logic implemented.
     * 
     **/
    public void execute(Database.BatchableContext ctsx, List<SObject> records) {
        
        if (!records.isEmpty()) {
            
            csv = csvCreator(records, parameter);
            
            csvBlob = Blob.valueOf(csv);
            
            delete records;
            
        }
    }
    
     /**
     * 
     *   @description    :   Finish method to email the generated CSV log as an attachment.
     *
     *   @args           :   Database.BatchableContext ctx - Batchable context for the execution.
     *
     *   @return         :   void
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Finish logic implemented.
     * 
     **/
    public void finish(Database.BatchableContext ctx) {
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('csvfile.csv'); // Name of the file
        attachment.setBody(csvBlob); // Attach the CSV content
        attachment.setContentType('text/csv'); // Specify content type
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {'mukulpichunia@gmail.com'});
        email.setSubject('Test CSV');
        email.setPlainTextBody('Please find attached csv');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        Messaging.sendEmail(new Messaging.Email[] { email });
        
    }
    
    /**
     * 
     *   @description    :   Helper method to create a CSV string from a list of SObjects and parameters.
     *
     *   @args           :   List<SObject> records - List of records to include in the CSV.
     *                        List<String> parameters - List of fields to include in the CSV.
     *
     *   @return         :   String - The generated CSV content.
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - CSV creation logic implemented.
     * 
     **/
    public static String csvCreator(List<SObject> records, List<String> parameters) {
        
        csvHeaders = String.join(parameters, ',') + '\n';
        String csvContent = csvHeaders;
        
        for (Sobject record : records) {
            List<String> csvValues = new List<String>();
            
            for (String param : parameters) {
                Object obj = record.get(param);
                csvValues.add(obj != null ?  String.valueOf(obj) : '');
            }
            csvContent += String.join(csvValues, ',') + '\n';
        }
        
        return csvContent;
    }
    
    
    
    
}