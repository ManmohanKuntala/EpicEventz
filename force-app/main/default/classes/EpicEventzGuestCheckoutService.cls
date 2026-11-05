public without sharing class EpicEventzGuestCheckoutService {

    public class Request {
        @InvocableVariable(required=true label='Ticket ID')
        public Id ticketId;
    }

    public class Result {
        @InvocableVariable(label='Checkout Updated')
        public Boolean success;

        @InvocableVariable(label='Checkout Message')
        public String message;
    }

    @InvocableMethod(
        label='Complete EpicEventz Simulated Checkout'
        description='Confirms a reserved ticket and marks its linked payment successful.'
    )
    public static List<Result> completeCheckout(List<Request> requests) {

        if (requests == null || requests.isEmpty()) {
            throw new AuraHandledException('A ticket ID is required.');
        }

        Set<Id> ticketIds = new Set<Id>();

        for (Request r : requests) {
            if (r == null || r.ticketId == null) {
                throw new AuraHandledException('A valid ticket ID is required.');
            }
            ticketIds.add(r.ticketId);
        }

        Map<Id, Ticket__c> tickets = new Map<Id, Ticket__c>([
            SELECT Id, Status__c
            FROM Ticket__c
            WHERE Id IN :ticketIds
            WITH SYSTEM_MODE
        ]);

        if (tickets.size() != ticketIds.size()) {
            throw new AuraHandledException('One or more tickets could not be found.');
        }

        List<Payment__c> payments = [
            SELECT Id, Ticket__c, Status__c, Payment_Method__c
            FROM Payment__c
            WHERE Ticket__c IN :ticketIds
            WITH SYSTEM_MODE
        ];

        Map<Id, Payment__c> paymentByTicket = new Map<Id, Payment__c>();

        for (Payment__c p : payments) {
            if (paymentByTicket.containsKey(p.Ticket__c)) {
                throw new AuraHandledException(
                    'Multiple payments are linked to a ticket. Checkout was not updated.'
                );
            }
            paymentByTicket.put(p.Ticket__c, p);
        }

        List<Ticket__c> ticketsToUpdate = new List<Ticket__c>();
        List<Payment__c> paymentsToUpdate = new List<Payment__c>();

        for (Id ticketId : ticketIds) {

            Ticket__c ticket = tickets.get(ticketId);
            Payment__c payment = paymentByTicket.get(ticketId);

            if (ticket.Status__c != 'Reserved') {
                throw new AuraHandledException(
                    'Only Reserved tickets can be confirmed through checkout.'
                );
            }

            if (payment == null || payment.Status__c != 'Pending') {
                throw new AuraHandledException(
                    'A linked Pending payment is required for checkout.'
                );
            }

            payment.Status__c = 'Success';
            payment.Payment_Method__c = 'Cash';
            paymentsToUpdate.add(payment);

            ticket.Status__c = 'Confirmed';
            ticketsToUpdate.add(ticket);
        }

        Database.update(paymentsToUpdate, AccessLevel.SYSTEM_MODE);
        Database.update(ticketsToUpdate, AccessLevel.SYSTEM_MODE);

        List<Result> results = new List<Result>();

        for (Id ticketId : ticketIds) {
            Result output = new Result();
            output.success = true;
            output.message = 'Simulated payment successful. Ticket confirmed.';
            results.add(output);
        }

        return results;
    }
}