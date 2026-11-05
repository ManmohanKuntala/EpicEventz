public without sharing class EpicEventzGuestFeedbackCreateService {

    public class Request {
        @InvocableVariable(required=true)
        public String attendeeEmail;

        @InvocableVariable(required=true)
        public Id eventId;

        @InvocableVariable(required=true)
        public Decimal rating;

        @InvocableVariable
        public String comments;
    }

    public class Result {
        @InvocableVariable
        public Id feedbackId;
    }

    @InvocableMethod(label='Create EpicEventz Guest Feedback')
    public static List<Result> createFeedback(List<Request> requests) {

        Set<String> emails = new Set<String>();

        for (Request req : requests) {
            if (req != null && !String.isBlank(req.attendeeEmail)) {
                emails.add(req.attendeeEmail.trim().toLowerCase());
            }
        }

        Map<String, Id> contactsByEmail = new Map<String, Id>();

        if (!emails.isEmpty()) {
            for (Contact c : [
                SELECT Id, Email, CreatedDate
                FROM Contact
                WHERE Email IN :emails
                WITH SYSTEM_MODE
                ORDER BY CreatedDate DESC
            ]) {
                String key = c.Email.trim().toLowerCase();

                if (!contactsByEmail.containsKey(key)) {
                    contactsByEmail.put(key, c.Id);
                }
            }
        }

        List<Feedback__c> feedbackRecords = new List<Feedback__c>();

        for (Request req : requests) {
            if (req == null || String.isBlank(req.attendeeEmail)
                || req.eventId == null || req.rating == null) {
                throw new AuraHandledException(
                    'Please provide all required feedback details.'
                );
            }

            String key = req.attendeeEmail.trim().toLowerCase();

            if (!contactsByEmail.containsKey(key)) {
                throw new AuraHandledException(
                    'No existing Contact was found for this email.'
                );
            }

            feedbackRecords.add(new Feedback__c(
                Attendee_Email__c = req.attendeeEmail.trim(),
                Attendee__c = contactsByEmail.get(key),
                Event__c = req.eventId,
                Rating__c = req.rating,
                Comments__c = req.comments,
                Feedback_Date__c = Date.today()
            ));
        }

        Database.insert(feedbackRecords, AccessLevel.SYSTEM_MODE);

        List<Result> results = new List<Result>();

        for (Feedback__c recordItem : feedbackRecords) {
            Result r = new Result();
            r.feedbackId = recordItem.Id;
            results.add(r);
        }

        return results;
    }
}