
public without sharing class EpicEventzGuestAttendeeService {
    public class Request {
        @InvocableVariable(label='Attendee Email' required=true)
        public String attendeeEmail;

        @InvocableVariable(label='Attendee Full Name' required=true)
        public String attendeeFullName;
    }

    public class Result {
        @InvocableVariable(label='Created Contact ID')
        public Id contactId;
    }

    @InvocableMethod(
        label='Create EpicEventz Guest Attendee'
        description='Creates an attendee Contact for a public EpicEventz booking.'
    )
    public static List<Result> createAttendees(List<Request> requests) {
        if (requests == null || requests.isEmpty()) {
            throw new AuraHandledException('Attendee details are required.');
        }

        List<Contact> contactsToInsert = new List<Contact>();

        for (Request requestItem : requests) {
            if (requestItem == null ||
                String.isBlank(requestItem.attendeeEmail) ||
                String.isBlank(requestItem.attendeeFullName)) {
                throw new AuraHandledException(
                    'Enter the attendee name and email.'
                );
            }

            String email = requestItem.attendeeEmail.trim();
            String fullName = requestItem.attendeeFullName.trim();

            if (email.length() > 80 ||
                !Pattern.matches(
                    '^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$',
                    email
                )) {
                throw new AuraHandledException(
                    'Enter a valid email address.'
                );
            }

            if (fullName.length() > 80) {
                throw new AuraHandledException(
                    'The attendee name is too long.'
                );
            }

            List<String> nameParts = fullName.split('\\s+');
            Contact newContact = new Contact();
            newContact.Email = email;

            if (nameParts.size() > 1) {
                newContact.FirstName = nameParts[0];
                newContact.LastName =
                    fullName.substring(nameParts[0].length()).trim();
            } else {
                newContact.LastName = fullName;
            }

            contactsToInsert.add(newContact);
        }

Database.insert(contactsToInsert, AccessLevel.SYSTEM_MODE);
        List<Result> results = new List<Result>();

        for (Contact createdContact : contactsToInsert) {
            Result resultItem = new Result();
            resultItem.contactId = createdContact.Id;
            results.add(resultItem);
        }

        return results;
    }
}
