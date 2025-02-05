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

export default class LmsComponentB extends LightningElement {
    recievedMessage;
    inputMessage;
    subscription = null;
    @wire(MessageContext) context;

    connectedCallback() {
        this.subscribeMessage();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    subscribeMessage() {
        if (!this.subscription) {
            this.subscription = subscribe(this.context, MSGCHANNEL, (message) => {
                this.handleMessage(message);
            });
        }
    }

    handleMessage(message) {
        this.recievedMessage = message.lmsData.value;
        console.log('Message received in B:', this.recievedMessage);
    }

    handleInputChange(event) {
        this.inputMessage = event.target.value;
    }

    publishMessage() {
        const message = {
            lmsData: {
                value: this.inputMessage
            }
        };
        console.log('Publishing message from B:', message);
        publish(this.context, MSGCHANNEL, message);
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}