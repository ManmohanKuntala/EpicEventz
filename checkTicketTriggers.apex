
System.debug('--- TICKET TRIGGER DIAGNOSTIC ---');

for (Schema.ChildRelationship relationship :
    Schema.SObjectType.Ticket__c.getDescribe().getChildRelationships()) {
    // No changes made. This loop is intentionally read-only.
}

System.debug('Ticket object: ' +
    Schema.SObjectType.Ticket__c.getDescribe().getName());

System.debug('Attendee lookup target: ' +
    Schema.SObjectType.Ticket__c.fields.Attendee__c
        .getDescribe().getReferenceTo());
