/**
 *  Description     :  Test class to validate the functionality of the DeleteRecordsSchedular class and its associated batch job.
 *
 *  Created By      :  Mukul Pichunia
 *
 *  Created Date    :  03/01/2025
 *
 *  Revision Logs   :  V1.0 - Created - Mukul Pichunia
 *
 **/
@isTest(SeeAllData = false)
private class TestDeleteRecordBatch {
    
    @TestSetup
    static void makeData() {
        Account acc = new Account(Name = 'Test', Domain_Name__c = 'fexle.com');
        insert acc;
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
     *   @revision Log   :   V1.0 - Created  - 03/01/2025 - Mukul Pichunia - Unit test for DeleteRecordsSchedular.
     * 
     **/
    @isTest(SeeAllData = false)
    static void testDeleteRecords() {
        
        Test.startTest();
        
        //System.schedule('Delete JOb' , '0 51 16 2 1 ?', new DeleteRecordsSchedular());
        
        List<SObject> customMetaDataRecords = [SELECT Developer_Name__c, Duration__c, Filter__c, Label__c FROM Archive_Config__mdt];
        for (Sobject result : customMetaDataRecords) {
            
            String name = (String)result.get('Developer_Name__c');
            String fields = DeleteRecordsSchedular.getFields(name);
            Decimal duration = (Decimal)result.get('Duration__c');
            String filter = (String)result.get('Filter__c'); //Name = 'Test ANd 
            String label = (String)result.get('Label__c');
            String query = 'SELECT ' +fields+ ' FROM ' +name+ ' where ' + filter +  ' AND CreatedDate >= Last_N_Days:' + duration;
            
            Database.executeBatch(new DeleteRecordsBatch(query, DeleteRecordsSchedular.parameters));
            
        }
        
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Test' AND Domain_Name__c = 'fexle.com'];
        Assert.areEqual(0, accounts.size(), 'Accounts should be deleted.');
        
    }
    
    
}