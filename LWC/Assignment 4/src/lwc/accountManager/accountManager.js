/**
*  Description     :  Component to display the account records from the account using the Wire method            
*
*  Created By      :  Mukul Pichunia
*
*  Created Date    :  03/02/2025
*
*  Revision Logs   :  V1.0 - Created - Mukul Pichunia
*
**/
import { LightningElement, wire, track, api} from 'lwc';
import accountRecord from '@salesforce/apex/AccountManagerController.getAccountList'
const columnsData = [
    {label: 'Id', fieldName: 'Id'},
    {label: 'Name', fieldName: 'Name'},
    {label: 'Phone', fieldName: 'Phone'},
    {label: 'Industry', fieldName: 'Industry'},
    {label: 'Rating', fieldName: 'Rating'},
    {label: 'Website', fieldName: 'Website'}

];

export default class AccountManager extends LightningElement {

    
    @track columns = columnsData;
    @track data1 = [];
    error;
    @wire (accountRecord)
    wiredAccounts({data, errors}) {
        if (data) {
            console.log('Account Data ' ,data);
            
           this.data1 = data;
           this.error = undefined;
        } else {
            this.data1 = undefined;
            this.error = errors;
        }
    }
   
    //data = accounts;    

}