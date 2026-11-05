
public without sharing class EpicEventzGuestFeedbackContactService {

    public class Request {
        @InvocableVariable(label='Attendee Email' required=true)
        public String attendeeEmail;
    }

    public class Result {
        @InvocableVariable(label='Matching Contact ID')
        public Id contactId;
    }

    @InvocableMethod(
        label='Find Existing EpicEventz Attendee'
        description='Finds the most recently created Contact using attendee email.'
    )
    public static List<Result> findAttendees(List<Request> requests) {

        List<Result> results = new List<Result>();
        Set<String> emails = new Set<String>();

        if (requests == null) {
            return results;
        }

        for (Request req : requests) {
            Result resultItem = new Result();
            results.add(resultItem);

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

                // Keep the newest Contact for each email.
                if (!contactsByEmail.containsKey(key)) {
                    contactsByEmail.put(key, c.Id);
                }
            }
        }

        for (Integer i = 0; i < requests.size(); i++) {
            Request req = requests[i];

            if (req == null || String.isBlank(req.attendeeEmail)) {
                continue;
            }

            String key = req.attendeeEmail.trim().toLowerCase();

            if (contactsByEmail.containsKey(key)) {
                results[i].contactId = contactsByEmail.get(key);
            }
        }

        return results;
    }
}
