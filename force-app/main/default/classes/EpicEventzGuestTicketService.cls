
public without sharing class EpicEventzGuestTicketService {

    public class Request {
        @InvocableVariable(required=true label='Attendee Contact ID')
        public Id attendeeId;

        @InvocableVariable(required=true label='Event ID')
        public Id eventId;

        @InvocableVariable(required=true label='Ticket Type ID')
        public Id ticketTypeId;

        @InvocableVariable(required=true label='Ticket Status')
        public String ticketStatus;
    }

    public class Result {
        @InvocableVariable(label='Created Ticket ID')
        public Id ticketId;

        @InvocableVariable(label='Ticket Number')
        public String ticketNumber;

        @InvocableVariable(label='Ticket Code')
        public String ticketCode;

        @InvocableVariable(label='Price Paid')
        public Decimal pricePaid;

        @InvocableVariable(label='Ticket QR Code URL')
        public String ticketQrCode;
    }

    @InvocableMethod(
        label='Create EpicEventz Guest Ticket'
        description='Creates a reserved or waitlisted ticket for public booking.'
    )
    public static List<Result> createTickets(List<Request> requests) {

        if (requests == null || requests.isEmpty()) {
            throw new AuraHandledException('Booking details are required.');
        }

        Set<Id> attendeeIds = new Set<Id>();
        Set<Id> eventIds = new Set<Id>();
        Set<Id> ticketTypeIds = new Set<Id>();

        for (Request r : requests) {
            if (r == null ||
                r.attendeeId == null ||
                r.eventId == null ||
                r.ticketTypeId == null ||
                !new Set<String>{'Reserved', 'Waitlisted'}
                    .contains(r.ticketStatus)) {

                throw new AuraHandledException(
                    'Valid attendee, event, ticket type, and ticket status are required.'
                );
            }

            attendeeIds.add(r.attendeeId);
            eventIds.add(r.eventId);
            ticketTypeIds.add(r.ticketTypeId);
        }

        Map<Id, Contact> attendees = new Map<Id, Contact>([
            SELECT Id
            FROM Contact
            WHERE Id IN :attendeeIds
            WITH SYSTEM_MODE
        ]);

        Map<Id, Event__c> events = new Map<Id, Event__c>([
            SELECT Id
            FROM Event__c
            WHERE Id IN :eventIds
            WITH SYSTEM_MODE
        ]);

        Map<Id, Ticket_Type__c> ticketTypes =
            new Map<Id, Ticket_Type__c>([
                SELECT Id, Price__c, Event__c
                FROM Ticket_Type__c
                WHERE Id IN :ticketTypeIds
                WITH SYSTEM_MODE
            ]);

        List<Ticket__c> tickets = new List<Ticket__c>();

        for (Request r : requests) {

            if (!attendees.containsKey(r.attendeeId) ||
                !events.containsKey(r.eventId) ||
                !ticketTypes.containsKey(r.ticketTypeId)) {

                throw new AuraHandledException(
                    'The selected attendee, event, or ticket type was not found.'
                );
            }

            Ticket_Type__c tt = ticketTypes.get(r.ticketTypeId);

            if (tt.Event__c != r.eventId) {
                throw new AuraHandledException(
                    'The selected ticket type does not belong to this event.'
                );
            }

            tickets.add(new Ticket__c(
                Attendee__c = r.attendeeId,
                Event__c = r.eventId,
                Ticket_Type__c = r.ticketTypeId,
                Price_Paid__c = tt.Price__c,
                Status__c = r.ticketStatus
            ));
        }

        Database.insert(tickets, AccessLevel.SYSTEM_MODE);

        Set<Id> createdIds = new Set<Id>();

        for (Ticket__c t : tickets) {
            createdIds.add(t.Id);
        }

        Map<Id, Ticket__c> createdTickets =
            new Map<Id, Ticket__c>([
                SELECT Id, Name, Ticket_Code__c, Price_Paid__c,
                       Ticket_QR_Code__c
                FROM Ticket__c
                WHERE Id IN :createdIds
                WITH SYSTEM_MODE
            ]);

        List<Result> results = new List<Result>();

        for (Ticket__c t : tickets) {
            Ticket__c saved = createdTickets.get(t.Id);

            Result output = new Result();
            output.ticketId = saved.Id;
            output.ticketNumber = saved.Name;
            output.ticketCode = saved.Ticket_Code__c;
            output.pricePaid = saved.Price_Paid__c;
            output.ticketQrCode = saved.Ticket_QR_Code__c;

            results.add(output);
        }

        return results;
    }
}
