import { LightningElement} from 'lwc';

export default class ParentComponent extends LightningElement {
    
      
        parentGreet = '';


        childMessage = 'Child Message'
        handleInputChange(event) {
            this.parentGreet = event.target.value;
            
        }

        storeMessage(event) {
            console.log(event.detail);
            this.childMessage = event.detail;
        }

}