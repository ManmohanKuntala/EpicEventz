
@IsTest
private class EpicEventzGuestAttendeeServiceTest {

    @IsTest
    static void createsAttendeeContact() {
        EpicEventzGuestAttendeeService.Request requestItem =
            new EpicEventzGuestAttendeeService.Request();

        requestItem.attendeeEmail = 'epiceventz.test@example.com';
        requestItem.attendeeFullName = 'Test Attendee';

        Test.startTest();
        List<EpicEventzGuestAttendeeService.Result> results =
            EpicEventzGuestAttendeeService.createAttendees(
                new List<EpicEventzGuestAttendeeService.Request>{
                    requestItem
                }
            );
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertNotEquals(null, results[0].contactId);

        Contact savedContact = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE Id = :results[0].contactId
            LIMIT 1
        ];

        System.assertEquals('Test', savedContact.FirstName);
        System.assertEquals('Attendee', savedContact.LastName);
        System.assertEquals(
            'epiceventz.test@example.com',
            savedContact.Email
        );
    }

    @IsTest
    static void rejectsMissingDetails() {
        EpicEventzGuestAttendeeService.Request requestItem =
            new EpicEventzGuestAttendeeService.Request();

        try {
            EpicEventzGuestAttendeeService.createAttendees(
                new List<EpicEventzGuestAttendeeService.Request>{
                    requestItem
                }
            );
            System.assert(false, 'Expected validation to reject missing details.');
        } catch (AuraHandledException expectedException) {
            System.assert(true);
        }
    }
}
