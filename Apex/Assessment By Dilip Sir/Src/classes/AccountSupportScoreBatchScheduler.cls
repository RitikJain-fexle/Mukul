public class AccountSupportScoreBatchScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
		    Database.executeBatch(new AccountSupportScoreBatch(), 200);
   
    }
    
    // To call schedule

   // System.schedule(JOb Name, CRON EXP, new AccountSupportScoreBatchScheduler());
}