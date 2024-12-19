/*
 * Purpose 		: Test class to test the changes on LeadProcessor
 * 
 * Created By 	: Mukul Pichunia
 * 
 * Created Date : 19-12-2024
 * 
 * Revision Log : V_1.0 - Created
 */
@isTest(SeeAllData = false)
public class LeadProcessorTest {
    
    @TestSetup
    public static void makeData() {
        List<Lead> leadToInsert = new List<Lead>();
        for (INteger i = 0; i < 200 ; i++) {
            leadToInsert.add(new Lead(LastName = 'Pichunia ' + i, Company = 'Fexle ' + i));
        }
        insert leadToInsert;
    }
    
    @isTest 
    public static void test() {
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        Assert.areEqual(200, [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce'], 'Count Doesnot match');
    }
}