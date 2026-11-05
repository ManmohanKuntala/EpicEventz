
import { LightningElement, wire } from 'lwc';
import getEvents from '@salesforce/apex/EventListingsController.getEvents';

export default class EventListings extends LightningElement {
    @wire(getEvents)
    eventsResult;

    selectedEventId;
    showBookingFlow = false;

    get events() {
        const records = this.eventsResult?.data;

        if (!Array.isArray(records)) {
            return [];
        }

        return records
            .filter(event => event && event.Id)
            .map(event => {
                const capacity = event.Capacity__c;
                const ticketsSold = event.Tickets_Sold__c || 0;
                const remaining = capacity != null
                    ? Math.max(0, capacity - ticketsSold)
                    : null;

                const rating = event.Avg_Rating__c;
                const healthScore = event.Event_Health_Score__c;

                return {
                    ...event,

                    venueName: event.Venue__r?.Name ||
                        'Venue to be announced',

                    eventCategory: event.Category__c || 'General',

                    eventDescription: event.Description__c ||
                        'Discover this event with EpicEventz.',

                    ticketsRemaining: remaining,

                    hasAvailableTickets:
                        remaining !== null && remaining > 0,

                    isSoldOut: remaining !== null && remaining === 0,

                    hasRating: rating !== null && rating !== undefined,

                    formattedRating:
                        rating !== null && rating !== undefined
                            ? Number(rating).toFixed(1)
                            : 'Not rated yet',

                    hasHealthScore:
                        healthScore !== null &&
                        healthScore !== undefined,

                    formattedHealthScore:
                        healthScore !== null &&
                        healthScore !== undefined
                            ? Number(healthScore).toFixed(0)
                            : '',

                    healthStatus:
                        event.Event_Health_Status__c || 'Not available'
                };
            });
    }

    get flowInputVariables() {
        return [
            {
                name: 'recordId',
                type: 'String',
                value: this.selectedEventId
            }
        ];
    }

    get hasEvents() {
        return this.events.length > 0;
    }

    get hasNoEvents() {
        return (
            Array.isArray(this.eventsResult?.data) &&
            this.eventsResult.data.length === 0
        );
    }

    get isLoading() {
        return (
            !this.eventsResult?.data &&
            !this.eventsResult?.error
        );
    }

    get hasError() {
        return !!this.eventsResult?.error;
    }

    handleBookTickets(event) {
    const eventId = event.currentTarget.dataset.eventId;

    console.log('EpicEventz Book Tickets clicked');
    console.log('Selected Event ID:', eventId);

    if (!eventId) {
        console.error('No event ID found on the button.');
        return;
    }

    this.selectedEventId = eventId;
    this.showBookingFlow = true;

    console.log('Booking flow requested for event:', eventId);
}

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.showBookingFlow = false;
            this.selectedEventId = undefined;
        }
    }

    handleCloseBooking() {
        this.showBookingFlow = false;
        this.selectedEventId = undefined;
    }
}
