import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import accountRecord from '@salesforce/apex/AccountManagerController.getAccountListByCreatedDate'
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import ACCOUNT_PHONE from '@salesforce/schema/Account.Phone';
import INDUSTRY from '@salesforce/schema/Account.Industry';
import RATING from '@salesforce/schema/Account.Rating';
import WEBSITE from '@salesforce/schema/Account.Website';
import CreateContactModal from 'c/createContactModal';
const columnsData = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Rating', fieldName: 'Rating' },
    { label: 'Website', fieldName: 'Website' }

];

export default class CreateAccountTableContactPage extends LightningElement {
    @track columns = columnsData;
    showAccountDetail = false;
    data = [];
    error;
    Account_Name = NAME_FIELD;
    AccountObj = ACCOUNT_OBJ;
    phone = ACCOUNT_PHONE;
    industry = INDUSTRY;
    rating = RATING;
    website = WEBSITE;
    wiredAccountsResult;
    // @track
    // fields = [
    //     NAME_FIELDS,
    //     ACCOUNT_PHONE,
    //     INDUSTRY,
    //     RATING,
    //     WEBSITE
    // ]

    @wire(accountRecord)
    wiredAccounts(result) {
        this.wiredAccountsResult = result;
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
        } else {
            this.data = undefined;
            this.error = result.errors;
        }
    }

    showAccountDetails() {
        this.showAccountDetail = true;
    }

    closeModal() {
        this.showAccountDetail = false;
    }

    async handleSuccess(event) {
        console.log('Created Account', event.detail.id);
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Your Account has been added successfully',
            varient: 'success'
        });
        this.dispatchEvent(toastEvent);



        try {
            const result = await CreateContactModal.open({
                size: 'large',//small, medium, large, and full
                accountId: event.detail.id,
            })
            await refreshApex(this.wiredAccountsResult);
        } catch (error) {
            console.log(error);
        }
    }


    handleError(event) {
        let errorMessage = event.detail.detail;
        console.log("response", errorMessage);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: errorMessage,
                variant: 'error'
            })
        );
    }
}