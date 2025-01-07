/**
*  Description     :  Schedulable class to query metadata records, generate SOQL dynamically, 
*                     and execute batch operations for record deletion based on the configurations.
*
*  Created By      :  Mukul Pichunia
*
*  Created Date    :  03/01/2025
*
*  Revision Logs   :  V1.0 - Created - Mukul Pichunia
*
**/
public without sharing class DeleteRecordsSchedular implements Schedulable {
    
    @testVisible
    public static List<String> parameters = new List<String>();
    
    @testVisible
    private List<SObject> customMetaDataRecords = new List<SObject>();
    
    @testVisible
    private Id batchId = null;
    
    /**
     * 
     *   @description    :   Executes the scheduled job to fetch metadata configurations,
     *                       construct dynamic SOQL queries, and invoke batch classes.
     *
     *   @args           :   SchedulableContext ctx - The context of the scheduled job.
     *
     *   @return         :   void
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Scheduled job execution logic implemented.
     * 
     **/
    public void execute(SchedulableContext ctx) {
        customMetaDataRecords = [SELECT Developer_Name__c, Duration__c, Filter__c, Label__c FROM Archive_Config__mdt];
        String query = '';
       
        for (SObject result : customMetaDataRecords) {
            String name = (String) result.get('Developer_Name__c');
            String fields = getFields(name);
            Decimal duration = (Decimal) result.get('Duration__c');
            String filter = (String) result.get('Filter__c');
            String label = (String) result.get('Label__c');
            
            query = 'SELECT ' + fields + ' FROM ' + name + ' WHERE ' + filter + ' AND CreatedDate >= Last_N_Days:' + duration;
            System.debug('QUERY: ' + query);
            
            batchId = Database.executeBatch(new DeleteRecordsBatch(query, parameters));
        }
         
    }
    /**
     * 
     *   @description    :   Retrieves all fields of the given SObject and constructs a CSV.
     *
     *   @args           :   String Name - The API name of the SObject.
     *
     *   @return         :   String - A comma separated list of field API names for the SObject.
     *
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Field retrieval and CSV construction logic implemented.
     * 
     **/
    public static String getFields(String Name) {
        String queryParameter = '';
        Schema.DescribeSObjectResult describeResult = ((SObject) Type.forName(Name).newInstance()).getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fields = describeResult.fields.getMap();
        

        for (String fieldName : fields.keySet()) {
            Schema.DescribeFieldResult describeFieldResult = fields.get(fieldName).getDescribe();
            queryParameter += describeFieldResult.getName() + ',';
            parameters.add(describeFieldResult.getName());
        }
        
        return queryParameter.substring(0, queryParameter.lastIndexOf(','));
    }
}