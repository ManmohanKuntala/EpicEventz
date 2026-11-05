List<EpicEventzGuestFeedbackContactService.Request> requests =
    new List<EpicEventzGuestFeedbackContactService.Request>();

EpicEventzGuestFeedbackContactService.Request req =
    new EpicEventzGuestFeedbackContactService.Request();

req.attendeeEmail = 'chinni@gmail.com';
requests.add(req);

List<EpicEventzGuestFeedbackContactService.Result> results =
    EpicEventzGuestFeedbackContactService.findAttendees(requests);

System.debug('MATCHING CONTACT ID: ' + results[0].contactId);
