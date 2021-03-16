/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Test class for the WebPushNotification class.
 */
@isTest
private class WebPushNotification_Test {

    /**
     * @description Test setup for dataset insertion.
     */
    @testSetup
    private static void setup() {
        Subscription__c[] subscriptions = new Subscription__c[] {};
        for (Integer i = 0; i < 210; i++) {
            subscriptions.add(new Subscription__c(Endpoint__c = 'http://example' + i + '.com',
                                                  p256dh__c = 'p256dhTest',
                                                  auth__c = 'authTest'));
        }
        insert subscriptions;

        Record__c[] records = new Record__c[] {};
        for (Integer i = 0; i < 210; i++) {
            records.add(new Record__c(Name = 'Song', Artist__c = 'Artist', Likes__c = 10,
                                      Year__c = 2020, Cover__c = 'http://example.com'));
        }
        insert records;
    }

    /**
     * @description Test the sendNotifications callout method.
     */
    @isTest
    private static void sendNotifications_Test() {
        PayloadComposition payloadCompositionInstance = (PayloadComposition)Type.forName('LikedRecordPayload').newInstance();
        WebPushNotificationPayload[] payloads = new WebPushNotificationPayload[] {};
        Record__c[] records = [SELECT Id, Name, Artist__c, Cover__c, Likes__c, Year__c FROM Record__c];
        for (SObject record : records) {
            payloads.add(payloadCompositionInstance.getPayload(record));
        }
        Subscription__c[] subscriptions = [SELECT Id, Endpoint__c, p256dh__c, auth__c FROM Subscription__c];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        HttpResponse response = WebPushNotification.sendNotifications(subscriptions, payloads);
        Test.stopTest();

        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('Notifications sent', response.getBody(), 'The request body does not confirm the notification sending');
    }

    /**
     * @description Test the queueable class execution.
     */
    @isTest
    private static void execute_Test() {
        Subscription__c[] subscriptions = [SELECT Id, Endpoint__c, p256dh__c, auth__c FROM Subscription__c];
        Record__c[] records = [SELECT Id, Name, Artist__c, Cover__c, Likes__c, Year__c FROM Record__c];
        String errorMessage;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        try {
            System.enqueueJob(new WebPushNotification(subscriptions, records, 'LikedRecordPayload'));
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(null, errorMessage, 'The process returned an error');
    }

}