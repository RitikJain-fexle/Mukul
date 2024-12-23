/*
 * Purpose 		: Queueable Apex class that inserts the same Contact for each Account for a specific state
 * 
 * Created by	: Mukul Pichunia
 * 
 * Created Date : 20-12-24
 * 
 * Revision Log : V_1.0 - Created
 */
public class AddPrimaryContact implements Queueable {
    private Contact con;
    private String state;
    public AddPrimaryContact(Contact cont, String billingState ) {
        // Clone without Id, related records, or readonly fields
        this.con = cont.clone(false, false, false);
        System.debug(con);
        this.state = billingState;
    }
    
    public void execute(QueueableContext qc) {
        List<Contact> insertContactList = new List<Contact>();
        List<Account> accList = [SELECT Id FROM Account Where BillingState = :state Limit 200];
        system.debug('accList>>' + accList);
        for (Account eachAccount : accList) {
            Contact clonedContact = con.clone(false, false, false);
            clonedContact.AccountId = eachAccount.Id;
            clonedContact.Phone = '9024318901';
            insertContactList.add(clonedContact);
        }
        
        system.debug(insertContactList);
        
        if (!insertContactList.isEmpty()) {
            insert insertContactList;
        }
    }
}