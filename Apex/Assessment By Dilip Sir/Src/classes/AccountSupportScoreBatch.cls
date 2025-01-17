public class AccountSupportScoreBatch implements Database.Batchable<sObject>{
    
    public Database.queryLocator start(Database.BatchableContext ctx) {
        //String status = 'CLOSED';
        String query = 'SELECT Id, AccountId, Priority, CreatedDate FROM CASE WHERE status != \'CLOSED\''; 
    	return Database.getQueryLocator(query) ;  
    }
    
    public void execute (Database.BatchableContext ctx, List<Case> records) {
        Map<Id, List<Case>> accIdCaseMap = new Map<Id, List<Case>>();
       
        for (Case c : records) {
            if (!accIdCaseMap.containsKey(c.AccountId)) {
                accIdCaseMap.put(c.AccountId, new List<Case>());
            }
            accIdCaseMap.get(c.AccountId).add(c);
        }
        List<Account> insertAccountList = new List<Account>();
        //Support_Score__c
        for (Id accId : accIdCaseMap.keySet()) {
            
            Integer severityCount = scoreCalculation(accIdCaseMap.get(accId));
            Account acc = new Account(Id = accId, Support_Score__c = severityCount);
            insertAccountList.add(acc);
            
        }
        
        if (!insertAccountList.isEmpty()) {
            Update insertAccountList;
        }
        
        
    }
    
    public void finish(Database.BatchableContext ctx) {
        AsyncApexJob apxx = [SELECT ID, JObType FROM AsyncApexJob WHERE Id = :ctx.getJobId()];
    }
    
    public static Integer scoreCalculation(List<Case> records) {
        Integer severity = 0;
        for (Case c : records) {
            if (String.valueOf(c.Priority) == 'High') {
                severity  +=  3;
            }
            else if (String.valueOf(c.Priority) == 'Medium') {
                severity  +=  2;
            } else {
                 severity  +=  1;
            }
            Date createddate = Date.newInstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
            if(Date.today().daysBetween(createddate) < 30) {
                severity+=1;
            } else if (Date.today().daysBetween(createddate) > 60) {
                severity-=1;
            }
        }
        return severity < 0 ? 0 : severity;
    }
    
}