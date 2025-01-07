/**
 *  Description     :  Test class to validate the functionality of the DeleteRecordsSchedular class and its associated batch job.
 *
 *  Created By      :  Mukul Pichunia
 *
 *  Created Date    :  03/01/2025
 *
 *  Revision Logs   :  V1.0 - Created - Mukul Pichunia - Coverage - 100%
 * 					   V1.1 - Added testDeleteRecordsSchedular() - Mukul Pichunia - Coverage - 100%
 * 
 *
 **/
@isTest(SeeAllData = false)
private class TestDeleteRecordBatch {
    
    @TestSetup
    static void makeData() {
        List<Account> accList = new List<Account>();
        Account acc = new Account(Name = 'Test', Domain_Name__c = 'fexle.com');
        accList.add(acc);
        insert accList;
    }
    
/**
* 
*   @description    :   Unit test method to validate the functionality of the DeleteRecordsBatch class.
*                       This test simulates the deletion of records by executing the batch operation.
*
*   @args           :   None
*
*   @return         :   void
*
*   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Unit test for DeleteRecordsSchedular.
* 
**/
    @isTest(SeeAllData = false)
    static void testDeleteRecordsBatch() {
        String name = '';
        String fields  = '';
        Decimal duration = 0;
        String filter = '';
        String query = '';
        SchedulableContext ctx = null;
        
        Test.startTest();
        
        List<SObject> customMetaDataRecords = [SELECT Developer_Name__c, Duration__c, Filter__c, Label__c FROM Archive_Config__mdt];
        for (Sobject result : customMetaDataRecords) {
            
            name = (String)result.get('Developer_Name__c');
            fields = DeleteRecordsSchedular.getFields(name);
            duration = (Decimal)result.get('Duration__c');
            filter = (String)result.get('Filter__c'); //Name = 'Test ANd 
            String label = (String)result.get('Label__c');
            query = 'SELECT ' +fields+ ' FROM ' +name+ ' where ' + filter +  ' AND CreatedDate >= Last_N_Days:' + duration;
            
            Database.executeBatch(new DeleteRecordsBatch(query, DeleteRecordsSchedular.parameters));
            
        }
        
        Test.stopTest();
        DeleteRecordsBatch batch = new DeleteRecordsBatch(query, DeleteRecordsSchedular.parameters);
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Test' AND Domain_Name__c = 'fexle.com'];
        Assert.areEqual(0, accounts.size(), 'Accounts should be deleted.');
        Assert.isNotNull(batch.query, 'Query must not be null');
        Assert.isTrue(!batch.parameter.isEmpty() , 'Parametes must not be empty');
        Assert.isNotNull(DeleteRecordsBatch.csv, 'CSV must not be null');
        
    }
    
    
/**
* 
*   @description    :   Unit test method to validate the functionality of the DeleteRecordsSchedular class.
*                       This test simulates the deletion of records by executing the batch operation.
*
*   @args           :   None
*
*   @return         :   void
*
*   @revision Log   :   V1.0 - Created  - 07/01/2025 - Mukul Pichunia - Unit test for DeleteRecordsSchedular.
* 
**/
    @isTest(SeeAllData = false)
    static void  testDeleteRecordsSchedular() {
        
        Test.startTest();
        DeleteRecordsSchedular sch = new DeleteRecordsSchedular();
        String CRON_EXP = '0 51 16 2 1 ?';
        String jobId = System.schedule('Delete_job',
                                       CRON_EXP, 
                                       sch);
        
        Test.stopTest();
        
        Assert.isTrue(!sch.customMetaDataRecords.isEmpty(), 'Custom metadata records should exist.');
        for (SObject result : sch.customMetaDataRecords) {
            String name   = (String) result.get('Developer_Name__c');
            String fields = DeleteRecordsSchedular.getFields(name);
            Assert.isTrue(String.isNotBlank(fields), 'Field Must not be Empty');
            Assert.areEqual('Account', name, 'Developer_Name__c should match expected value.');
        }
        
        Assert.isNotNull(sch.batchId, 'batch Id cannot be null');
        List<AsyncApexJob> jobs = [SELECT Id, Status, NumberOfErrors, 

            JobItemsProcessed, JobType, 

            TotalJobItems, CreatedBy.Email

            FROM AsyncApexJob

            WHERE Id = :sch.batchId];
        
        System.assertEquals('BatchApex', jobs[0].JobType, 'This Must be the batch job');
        
    }
    
    
}