
Schema.DescribeSObjectResult ticketDescribe =
    Schema.SObjectType.Ticket__c;

System.debug('TICKET OBJECT API NAME: ' + ticketDescribe.getName());
System.debug('TICKET OBJECT CREATEABLE: ' + ticketDescribe.isCreateable());

Map<String, Schema.SObjectField> ticketFields =
    ticketDescribe.fields.getMap();

System.debug('ATTENDEE FIELD EXISTS: ' +
    ticketFields.containsKey('Attendee__c'));

if (ticketFields.containsKey('Attendee__c')) {
    Schema.DescribeFieldResult attendeeDescribe =
        ticketFields.get('Attendee__c').getDescribe();

    System.debug('ATTENDEE FIELD API NAME: ' +
        attendeeDescribe.getName());
    System.debug('ATTENDEE FIELD CREATEABLE: ' +
        attendeeDescribe.isCreateable());
    System.debug('ATTENDEE FIELD TYPE: ' +
        attendeeDescribe.getType());
}
