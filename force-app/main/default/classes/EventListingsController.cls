public with sharing class EventListingsController {
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getEvents() {
        return [
            SELECT Id,
                   Name,
                   Category__c,
                   Start_Date__c,
                   End_Date__c,
                   Venue__r.Name,
                   Description__c,
                   Status__c,
                   Avg_Rating__c,
                   Event_Health_Score__c,
                   Event_Health_Status__c,
                   Capacity__c,
                   Tickets_Sold__c
            FROM Event__c
            WHERE Status__c = 'Published'
            ORDER BY Start_Date__c ASC
            LIMIT 50
        ];
    }
}
