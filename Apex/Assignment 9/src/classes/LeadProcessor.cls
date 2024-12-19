/*
 * Purpose		: Batch Class to update LeadSource Field value to Dreamforce.
 * 
 * Created by	: Mukul Pichunia
 * 
 * Created Date : 19-12-24
 * 
 * Revision Log : V_1.0 - Created
 */

/*
 * Database.Batchable(Interface) : Class Implement this will executed as batch apex job
 * 
 * Database.Stateful : Retention of state across various execution methods within a batch job.
 */ 
public without sharing class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
    public Integer recordsProcessed = 0;
    
    /*
     * start() : When Invoked (Database.executeBatch()) batch job starts
     * 
     * It Identifies the scope(List of Data) to be processed 
     * @returns : Database.QueryLocator
     * @Parameters : Database.BatchableContext
     * Database.QueryLocator : When Used the governer limit for the total number of records reterived by SOQL queries is bypassed and 
     * It will not provide the HeapLimitExceed Exception Which will be in case of Normal Query.
     * 
     * Database.BatchableContext : use to track the progress of the batch job it have to mehtods and 
     * A common use case for this is in the finish() method to see if any of the execute transactions had errors or to System.abortJob
     * 
     * getJobId()		: It gives Id of Apex Batch Queue
     * 
     * getChildJobId()	: It returns the current batch job chunk Id
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, LeadSource FROM Lead';
        Database.QueryLocator ql = Database.getQueryLocator(query);
        //Implementation of iterator
        //iterator can help us iterating through that set of records.
        Database.QueryLocatorIterator iterator = ql.iterator();       
        While (iterator.hasNext()) {
            Lead le = (Lead)iterator.next();
        }
        return ql;
    }
    
    /*
     * execute() : It consist main logic to execute on the chunk of records
     * 
     * @params : Database.BatchableContext bc and Chunk or Batch of list of records
     */ 
    public void execute(Database.BatchableContext bc, List<Lead> records) {
        for (Lead eachLead : records) {
            eachLead.LeadSource = 'Dreamforce';
            recordsProcessed += 1;
        }
        update records;
    }
    
    /*
     * finish() : It execute when batch job finishes 
     * 
     * It contains clean up code and execute post-processing operations.
     */ 
    public void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, 
                            JobItemsProcessed, TotalJobItems 
                            FROM AsyncApexJob where Id = :bc.getJobId()];
        System.debug('recordsProcessed : ' + recordsProcessed);
    }

}