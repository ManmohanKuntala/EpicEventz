
public without sharing class MyTicketsController {
    @AuraEnabled
    public static List<Ticket__c> getMyTickets(String attendeeEmail) {

        if (String.isBlank(attendeeEmail)) {
            throw new AuraHandledException(
                'Enter your booking email.'
            );
        }

        List<Ticket__c> tickets = [
            SELECT Id,
                   Name,
                   Ticket_Code__c,
                   Status__c,
                   Price_Paid__c,
                   Event__r.Name,
                   Ticket_Type__r.Name
            FROM Ticket__c
            WHERE Attendee__r.Email = :attendeeEmail
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];

        return tickets;
    }
}
