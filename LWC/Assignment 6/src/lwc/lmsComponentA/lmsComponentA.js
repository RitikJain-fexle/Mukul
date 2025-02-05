/**
*  Description     :  Component to Perform LWCs Communication           
*
*  Created By      :  Mukul Pichunia
*
*  Created Date    :  04/02/2025
*
*  Revision Logs   :  V1.0 - Created - Mukul Pichunia
*
**/
import { LightningElement, wire } from 'lwc';
import { MessageContext, publish, subscribe, unsubscribe } from 'lightning/messageService';
import MSGCHANNEL from '@salesforce/messageChannel/messageChannelFirst__c';

export default class LmsComponentA extends LightningElement {
    inputValue;
    recievedMessage;
    subscription = null;
    @wire(MessageContext) context;

    connectedCallback() {
        this.subscribeMessage();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    publishMessage() {
        const message = {
            lmsData: {
                value: this.inputValue
            }
        };

        console.log('this.inputValue in publish method ', this.inputValue);
        
        console.log('Publishing message from A:', message);
        publish(this.context, MSGCHANNEL, message);
    }

    subscribeMessage() {
        if (!this.subscription) {
            this.subscription = subscribe(this.context, MSGCHANNEL, (message) => {
                this.handleMessage(message);
            });
        }
    }

    handleMessage(message) {
        this.recievedMessage = message.lmsData.value || "NO Message Published";
        console.log('Message received in A:', this.recievedMessage);
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}