
public without sharing class ManageMyBookingsController {
    public class BookingDetails {
        @AuraEnabled public Id ticketId { get; set; }
        @AuraEnabled public String ticketNumber { get; set; }
        @AuraEnabled public String ticketCode { get; set; }
        @AuraEnabled public String eventName { get; set; }
        @AuraEnabled public String ticketType { get; set; }
        @AuraEnabled public Decimal pricePaid { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String attendeeEmail { get; set; }
        @AuraEnabled public String qrCodeUrl { get; set; }
    }

    // Find a booking using the ticket code and booking email.
    @AuraEnabled
    public static BookingDetails findBooking(
        String ticketCode,
        String attendeeEmail
    ) {
        if (String.isBlank(ticketCode) ||
            String.isBlank(attendeeEmail)) {
            throw new AuraHandledException(
                'Enter both your ticket code and booking email.'
            );
        }

        List<Ticket__c> tickets = [
            SELECT Id, Name, Ticket_Code__c, Status__c,
                   Price_Paid__c, Ticket_QR_Code__c,
                   Event__r.Name, Ticket_Type__r.Name,
                   Attendee__r.Email
            FROM Ticket__c
            WHERE Ticket_Code__c = :ticketCode.trim()
              AND Attendee__r.Email = :attendeeEmail.trim()
            LIMIT 2
        ];

        if (tickets.isEmpty()) {
            throw new AuraHandledException(
                'No booking matched those details. Check your ticket code and email.'
            );
        }

        if (tickets.size() > 1) {
            throw new AuraHandledException(
                'Multiple bookings matched. Please contact support.'
            );
        }

        Ticket__c t = tickets[0];

        BookingDetails result = new BookingDetails();
        result.ticketId = t.Id;
        result.ticketNumber = t.Name;
        result.ticketCode = t.Ticket_Code__c;
        result.eventName =
            t.Event__r == null ? null : t.Event__r.Name;
        result.ticketType =
            t.Ticket_Type__r == null
                ? null
                : t.Ticket_Type__r.Name;
        result.pricePaid = t.Price_Paid__c;
        result.status = t.Status__c;
        result.attendeeEmail = t.Attendee__r.Email;
        result.qrCodeUrl = t.Ticket_QR_Code__c;

        return result;
    }

    // Cancel an eligible ticket and allow existing
    // record-triggered cancellation automation to run.
    @AuraEnabled
    public static void cancelBooking(
        String ticketCode,
        String attendeeEmail
    ) {
        if (String.isBlank(ticketCode) ||
            String.isBlank(attendeeEmail)) {
            throw new AuraHandledException(
                'Enter both your ticket code and booking email.'
            );
        }

        List<Ticket__c> tickets = [
            SELECT Id, Status__c
            FROM Ticket__c
            WHERE Ticket_Code__c = :ticketCode.trim()
              AND Attendee__r.Email = :attendeeEmail.trim()
            LIMIT 2
            FOR UPDATE
        ];

        if (tickets.isEmpty()) {
            throw new AuraHandledException(
                'No booking matched those details.'
            );
        }

        if (tickets.size() > 1) {
            throw new AuraHandledException(
                'Multiple bookings matched. Please contact support.'
            );
        }

        Ticket__c ticket = tickets[0];

        if (ticket.Status__c == 'Cancelled') {
            throw new AuraHandledException(
                'This booking is already cancelled.'
            );
        }

        if (ticket.Status__c == 'Checked In') {
            throw new AuraHandledException(
                'A checked-in ticket cannot be cancelled online.'
            );
        }

        if (ticket.Status__c != 'Reserved' &&
            ticket.Status__c != 'Confirmed') {
            throw new AuraHandledException(
                'This ticket is not eligible for online cancellation.'
            );
        }

        ticket.Status__c = 'Cancelled';
        update ticket;
    }
}
