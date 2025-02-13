/**
 * 
 * Purpose          : This Lightning Web Component (LWC) dynamically fetches 
 *                    and displays picklist values for a specified object 
 *                    and field in Salesforce. It retrieves object metadata 
 *                    to determine the record type and fetches picklist values 
 *                    accordingly, enabling dynamic and reusable picklist 
 *                    functionality (This is Called from showPickListCombobox componenet).
 * 
 * Created Date     : 10/02/2025
 * 
 * Created By       : Mukul Pichunia
 * 
 * Revision Logs    : V_1.0 - Created - 10/02/2025
 * 
 */

import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class GetPicklistValuesUIObjectInfoApi extends LightningElement {


    @api objectName;
    @api fieldName;
    recordTypeId;
    picklistValues;
    options = [];

/**
* @description	:	fetching Record Type from uiObjectInfoApi/getObjectInfo wire adapter.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	objectApiName.
* 
* @return		:	RecordTypeId.
* 
* @revision Log	:	V1.1 - Created  - 10/02/2025 - Developer Name - Mukul Pichunia
*/ 

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    propertyOrFunction({ data, error }) {
        if (data) {

            this.recordTypeId = data.defaultRecordTypeId;

        } else if (error) {
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please Enter a valid object name or in proper format.',
                    variant: 'error',
                }),
            );

        }
    };

/**
* @description	:	fetching Picklist values in an objecton basis of Record Type and objectApi Name using uiObjectInfoApi/getPicklistValues wire adapter.
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	recordTypeId and fieldApiName.
* 
* @return		:	Picklist in an Object.
* 
* @revision Log	:	V1.1 - Created  - 10/02/2025 - Developer Name - Mukul Pichunia
*/ 

    @wire(getPicklistValues, { recordTypeId: "$recordTypeId", fieldApiName: '$fieldApiName' })
    picklistResults({ error, data }) {
        if (data) {
            let arr = []
            
            this.picklistValues = data.values;
            
            this.picklistValues.map(currentItem => {
                arr.push({ label: currentItem.value, value: currentItem.value })
            })
            this.options = arr;

            this.error = undefined;
        } else if (error) {
            console.error('Error fetching picklist values', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Invalid field name or object.',
                    variant: 'error',
                })
            );
        }
    }

/**
* @description	:	Generate the Picklist Field Api Name
* 
* Created by	:	Mukul Pichunia
* 
* @args			:	-
* 
* @return		:	ObjectApiName.FieldApiName.
* 
* @revision Log	:	V1.1 - Created  - 10/02/2025 - Developer Name - Mukul Pichunia
*/ 
    get fieldApiName() {
        return this.objectName && this.fieldName ? `${this.objectName}.${this.fieldName}` : null;
    }

}