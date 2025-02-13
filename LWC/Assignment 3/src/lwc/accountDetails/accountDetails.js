/**
 * 
 * Purpose : To Create Generic Data Table
 * 
 * Created Date : 02/02/2025
 * 
 * Created By : Mukul Pichunia
 * 
 * Revision Logs : V_1.0 - Created - 02/02/2025
 * 
 */

import { LightningElement, api, track  } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import ACCOUNT_ID from '@salesforce/schema/Contact.AccountId';
import FIRST_NAME from '@salesforce/schema/Contact.FirstName';
import LAST_NAME from '@salesforce/schema/Contact.LastName';
import PHONE from '@salesforce/schema/Contact.Phone';
import EMAIL from '@salesforce/schema/Contact.Email';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AccountDetails extends LightningElement {
    @api recordId;
    @track showContactForm = false;
    
    contactObject = CONTACT_OBJECT;
    
        accountId = ACCOUNT_ID;
        firstName = FIRST_NAME;
        lastName = LAST_NAME;
        phone = PHONE;
        email = EMAIL;
    

    handleCreateContact() {
        this.showContactForm = true;
    }

    handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Contact Created Successfully',
                variant: 'success'
            })
        );
        this.showContactForm = false; 
    }

    handleCancel() {
        this.showContactForm = false; 
    }
}