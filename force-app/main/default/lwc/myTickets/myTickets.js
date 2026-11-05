
import { LightningElement } from 'lwc';
import getMyTickets from '@salesforce/apex/MyTicketsController.getMyTickets';

export default class MyTickets extends LightningElement {
    attendeeEmail = '';
    tickets = [];
    errorMessage = '';
    isLoading = false;
    hasSearched = false;

    handleEmailChange(event) {
        this.attendeeEmail = event.target.value;
    }

    async handleFindTickets() {
        this.errorMessage = '';
        this.tickets = [];
        this.hasSearched = false;

        if (!this.attendeeEmail.trim()) {
            this.errorMessage = 'Please enter your booking email.';
            return;
        }

        this.isLoading = true;

        try {
            this.tickets = await getMyTickets({
                attendeeEmail: this.attendeeEmail.trim()
            });
            this.hasSearched = true;

            if (this.tickets.length === 0) {
                this.errorMessage = 'No tickets found for this email address.';
            }
        } catch (error) {
            this.errorMessage =
                error?.body?.message ||
                'Unable to retrieve tickets. Please try again.';
        } finally {
            this.isLoading = false;
        }
    }
}
