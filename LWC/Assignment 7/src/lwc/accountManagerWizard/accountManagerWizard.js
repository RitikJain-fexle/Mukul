/**
 * 
 * Purpose          : Component to display the account details, related contact and to call the create contact modal popup
 * 
 * Created Date     : 05/02/2025
 * 
 * Created By       : Mukul Pichunia
 * 
 * Revision Logs    : V_1.0 - Created - 05/02/2025
 * 
 */
import { LightningElement, api, track, wire } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
import NAME_FIELDS from '@salesforce/schema/Account.Name';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import getContacts from '@salesforce/apex/ContactController.getContactsFromRelatedAccountId';
import AccountWizardModal from 'c/accountWizardModal';
import { refreshApex } from '@salesforce/apex';
import { CHARACTERS, NUMBERS } from 'c/constants';
export default class AccountManagerWizard extends LightningElement {

    @api recordId;
    @api strSearchConName = CHARACTERS.CHAR_BLANK;
    showAccountDetail = false;
    objectApiName = ACCOUNT_OBJECT;
    contacts;
    data;
    error;
    result;
    createContacts = false;
    wiredAccountsResult;
    
/**
* @description	:	Wire Call to apex to fetch the contacts of particular account id and a search input based on name.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	recordId and search key.
* 
* @return		:	data and error in JSON format.
* 
* @revision Log	:	V1.1 - Created  - 06/02/2025 - Developer Name - Mukul Pichunia
*/ 
    @wire(getContacts, {recordId : '$recordId', searchKey: '$strSearchConName'})
    getContactList(result) {
        this.wiredAccountsResult = result;
        // this.result = {error, data}
        if (result.data) {
            this.data = result.data;
            console.log('Printing The data ',this.data);
            
            this.error = undefined;
        } else if(result.error) {
            this.data = undefined;
            this.error = result.error;
        }
    }


/**
 * 
 * Imperative Fetching
 */

    // async handleRefresh(detail) {
    //     try {

    //         console.log('@@@@ details', detail);
            
    //         await refreshApex(this.data);
    //     } catch(error) {
    //         this.error = error;
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error',
    //                 message: 'Data is not refreshed.',
    //                 variant: 'error',
    //             }),
    //         );
    //     }
    // }

    
    @track
    fields = [
        NAME_FIELDS,
        { objectApiName: 'Account', fieldApiName: 'OwnerId' },
        { objectApiName: 'Account', fieldApiName: 'Description' },
        { objectApiName: 'Account', fieldApiName: 'Number_Of_Contacts__c' },
    ]

    columns = [
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Email', fieldName: 'Email', type: 'email' }
    ];

    showAccountDetails() {
        this.showAccountDetail = true
    }

    
    handleSearchInput(event) {
        this.strSearchConName = event.target.value;
        console.log(this.strSearchConName);
    }

    handleSearchKeyword(event) {
        event.preventDefault();
        this.errorMsg = '';

        console.log('On Search Button Click', this.strSearchConName);
        
        //this.handleContacts(this.recordId);
        
    }


    handleSuccess(event) {
        event.preventDefault();
        alert('record saved');
        console.log('OUTPUT success: ', JSON.stringify(event.detail));
    }

    handleError(event) {
        event.preventDefault();
        console.log('OUTPUT : ', JSON.stringify(event.detail));
    }

    handleSubmit(event) {
        event.preventDefault();
        alert('record saved');
    }

    closeModal() {
        this.showAccountDetail = false;
    }



    async showContactForm() {
        try {
            const result = await AccountWizardModal.open({
                size: 'large',//small, medium, large, and full
                accountId: this.recordId,
            })
            console.log('before refresh apex');
            await refreshApex(this.wiredAccountsResult);
             console.log('before refresh apex');
        

        } catch(error) {
            console.log(error);
        }
    }

    createContact() {
        createContact = true;
    }

}