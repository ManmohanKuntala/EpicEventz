
import { LightningElement } from 'lwc';
import findBooking from '@salesforce/apex/ManageMyBookingsController.findBooking';
import cancelBooking from '@salesforce/apex/ManageMyBookingsController.cancelBooking';

export default class ManageMyBookings extends LightningElement {
    ticketCode = '';
    attendeeEmail = '';
    booking;
    errorMessage = '';
    successMessage = '';
    isLoading = false;

    handleTicketCodeChange(event) {
        this.ticketCode = event.target.value;
    }

    handleEmailChange(event) {
        this.attendeeEmail = event.target.value;
    }

    async handleFindBooking() {
        this.booking = undefined;
        this.errorMessage = '';
        this.successMessage = '';

        if (!this.ticketCode.trim() || !this.attendeeEmail.trim()) {
            this.errorMessage =
                'Enter both your ticket code and booking email.';
            return;
        }

        this.isLoading = true;

        try {
            this.booking = await findBooking({
                ticketCode: this.ticketCode.trim(),
                attendeeEmail: this.attendeeEmail.trim()
            });
        } catch (error) {
            this.errorMessage =
                error?.body?.message ||
                'Unable to find this booking. Please check your details.';
        } finally {
            this.isLoading = false;
        }
    }

    async handleCancelBooking() {
        this.errorMessage = '';
        this.successMessage = '';

        if (!this.booking || !this.canCancelBooking) {
            this.errorMessage =
                'Find an eligible booking before cancelling.';
            return;
        }

        if (
            !window.confirm(
                'Are you sure you want to cancel this booking?'
            )
        ) {
            return;
        }

        this.isLoading = true;

        try {
            await cancelBooking({
                ticketCode: this.ticketCode.trim(),
                attendeeEmail: this.attendeeEmail.trim()
            });

            this.successMessage =
                'Your booking has been cancelled successfully.';

            this.booking = await findBooking({
                ticketCode: this.ticketCode.trim(),
                attendeeEmail: this.attendeeEmail.trim()
            });
        } catch (error) {
            this.errorMessage =
                error?.body?.message ||
                'Unable to cancel this booking. Please try again.';
        } finally {
            this.isLoading = false;
        }
    }

    get canCancelBooking() {
        return (
            this.booking &&
            ['Reserved', 'Confirmed'].includes(this.booking.status)
        );
    }
}
