/**
 * 
 * Purpose : Component to fetch the Accounts Using the imperative call
 * 
 * Created Date : 03/02/2025
 * 
 * Created By : Mukul Pichunia
 * 
 * Revision Logs : V_1.0 - Created - 03/02/2025
 * 
 */

import { LightningElement } from 'lwc';

import getAccounts from '@salesforce/apex/AccountManagerController.getAccountList';

const columnsData = [
    {label: 'Id', fieldName: 'Id'},
    {label: 'Name', fieldName: 'Name'},
    {label: 'Phone', fieldName: 'Phone'},
    {label: 'Industry', fieldName: 'Industry'},
    {label: 'Rating', fieldName: 'Rating'},
    {label: 'Website', fieldName: 'Website'}

];
export default class FetchDataFromApexUsingImperativeCall extends LightningElement {
   
    connectedCallback() {
        // handleLoad()
        this.handleClick();
    }

    error;
    accounts;
    columns = columnsData;

    async handleClick() {
        try {
            this.accounts = await getAccounts();
            console.log('OUTPUT : ', this.accounts);
            this.error = undefined;
        } catch(error) {
            this.error = error;
            this.accounts = undefined;
        }
    }

    // Using Then Callback methods
    
    
    // handleLoad() {
    //     getAccounts().then((result) => {
    //         this.accounts = result;
    //         error = undefined;
    //     }).catch((err) => {
    //         this.error = error;
    //         this.accounts = undefined;
    //     });
    // }
}