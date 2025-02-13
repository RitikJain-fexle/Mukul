/**
 * 
 * Purpose          : Component to generate the Dynamic Picklist on a button click
 * 
 * Created Date     : 10/02/2025
 * 
 * Created By       : Mukul Pichunia
 * 
 * Revision Logs    : V_1.0 - Created - 10/02/2025
 * 
 */

import { LightningElement, api } from 'lwc';
export default class ShowPickListCombobox extends LightningElement {
    @api objectApiName;
    @api fieldName;

    showChildComponent = false;

/**
* @description	:	Handle Change in the input box.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	event on change.
* 
* @return		:	-
* 
* @revision Log	:	V1.1 - Created  - 10/02/2025 - Developer Name - Mukul Pichunia
*/ 

    handleChange(event) {

        if (event.target.name === 'Object') {
            this.objectApiName = event.target.value;
        }
        if (event.target.name === 'Field') {
            this.fieldName = event.target.value;
        }
    }


/**
* @description	:	Handle button click.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	event on button click.
* 
* @return		:	-
* 
* @revision Log	:	V1.1 - Created  - 10/02/2025 - Developer Name - Mukul Pichunia
*/ 
    handleClick(event) {
        event.preventDefault();
        if (!this.objectApiName || !this.fieldName) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please enter both Object API Name and Field Name.',
                    variant: 'error',
                })
            );
            return;
        }


        this.showChildComponent = !this.showChildComponent;
    }



}