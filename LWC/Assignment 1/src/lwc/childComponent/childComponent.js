import { api, LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api
    greeting;

    handleClick(event) {
        event.preventDefault();
        let message = this.template.querySelector('lightning-input').value;
        this.dispatchEvent(new CustomEvent('send', {detail: message}));
    }
}