/**
 * 
 * Purpose : To Create Generic Data Table
 * 
 * Created Date : 28/01/2022
 * 
 * Created By : Mukul Pichunia
 * 
 * Revision Logs : V_1.0 - Created - 28/01/2022
 * 
 */

import { LightningElement, api, track } from 'lwc';

import { CHARACTERS, NUMBERS } from 'c/constants';
import doQueryRecords from '@salesforce/apex/GenericTableController.doQuery'

const columnsData = [
    {label: 'Id', fieldName: 'Id'},
    {label: 'Name', fieldName: 'Name'}
];
// Name of Local and global varable name must not be same
export default class GenericTable extends LightningElement {

    @api objectName = CHARACTERS.CHAR_BLANK;
    @api fieldsName = CHARACTERS.CHAR_BLANK;
    @api limitValue = NUMBERS.NUMBER_ONE;
    // Imperative call cannot be called directly without user 
    // interaction we should use connected callback so that it call the imperative method
    @track data = [];

    @track columns  = columnsData; 

    

    connectedCallback() {   
        //use this keyword


        this.handleSearch()
    }
    handleSearch() {
        doQueryRecords(
            {
            objectName : this.objectName, 
            fieldsName : this.fieldsName, 
            limitValue : this.limitValue
            }
        )
        .then((result) => {
            this.data = result;
        })
        .catch((error) => {
            console.log('@error' +  JSON.stringify(error));
        })
    }

}