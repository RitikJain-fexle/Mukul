/**
 * 
 * Purpose          : Modal Component use to create contact when called
 * 
 * Created Date     : 04/03/2025
 * 
 * Created By       : Mukul Pichunia
 * 
 * Revision Logs    : V_1.0 - Created - 04/03/2025
 * 
 */

import { api} from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import insertContact from '@salesforce/apex/ContactController.insertContact';
import { CHARACTERS, NUMBERS } from 'c/constants';


export default class CreateContactModal extends LightningModal {
    @api accountId;
error = CHARACTERS.CHAR_BLANK;
firstName = CHARACTERS.CHAR_BLANK;
lastName = CHARACTERS.CHAR_BLANK; 
emailId = CHARACTERS.CHAR_BLANK;
checkboxVal = true;
res;

contactChangeNameVal(event) {
    console.log(event.target.label);
    console.log(event.target.value);
    this.firstName = event.target.value;
}

contactChangeEmailVal(event){
    if (event.target.label == 'Active') {
        this.checkboxVal = event.target.checked;
    }

    if (event.target.label == 'Email') {
        this.emailId = event.target.value;
    }
    
}
contactChangeLastNameVal(event){
    this.lastName = event.target.value;
}

async insertContactAction() {
    if (!this.lastName) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Last Name is a required field.',
                variant: 'error',
            }),
        );
        return;
    }
    try {
        const response = await insertContact({firstName : this.firstName, lastName : this.lastName, email :this.emailId, id : this.accountId, active: this.checkboxVal});
        if (response) {
            console.log('RESPONSE', response);
            this.error = undefined;
            this.res = true;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact created successfully',
                    variant: 'success',
                }),
            );
        }

    } catch(error) {
        this.error = error;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating contact',
                message: error.body.message,
                variant: 'error',
            }),
        );
    }    
}

dispatchSelectEvent(e) {
  

    const { id, value } = e.target;
    const selectEvent = new CustomEvent('select', {
        detail: { id, value }
    });
    this.dispatchEvent(selectEvent);
}

}