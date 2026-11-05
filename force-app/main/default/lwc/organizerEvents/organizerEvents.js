
import { LightningElement, wire } from 'lwc';
import getEvents from '@salesforce/apex/EventListingsController.getEvents';

export default class OrganizerEvents extends LightningElement {
    events = [];
    error;

    @wire(getEvents)
    wiredEvents({ data, error }) {
        if (data) {
            this.events = data.map(event => ({
                ...event,
                recordUrl:
                    'https://resilient-narwhal-kgnenf-dev-ed.trailblaze.lightning.force.com/lightning/r/Event__c/' +
                    event.Id +
                    '/view'
            }));
            this.error = undefined;
        } else if (error) {
            this.events = [];
            this.error = error;
        }
    }

    get isEmpty() {
        return this.events.length === 0 && !this.error;
    }
}
