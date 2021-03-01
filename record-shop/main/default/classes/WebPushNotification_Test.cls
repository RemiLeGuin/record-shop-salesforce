/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Test for the WebPushNotification class.
 */
@isTest
private class WebPushNotification_Test {

    /**
     * @description Test the sendNotifications callout method.
     */
    @isTest
    private static void sendNotifications_Test() {
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        Subscription__c[] subscriptions = new Subscription__c[] {};
        for (Integer i = 0; i < 500; i++) {
            subscriptions.add(new Subscription__c(Endpoint__c = 'http://example.com',
                                                  p256dh__c = 'p256dhTest',
                                                  auth__c = 'authTest'));
        }
        Record__c[] records = new Record__c[] {};
        for (Integer i = 0; i < 200; i++) {
            records.add(new Record__c(Name = 'Song', Artist__c = 'Artist', Likes__c = 10,
                                      Year__c = 2020, Cover__c = 'http://example.com'));
        }
        PayloadComposition payloadCompositionInstance = (PayloadComposition)Type.forName('LikedRecordPayload').newInstance();
        WebPushNotificationPayload[] payloads = new WebPushNotificationPayload[] {};
        for (SObject record : records) {
            payloads.add(payloadCompositionInstance.getPayload(record));
        }

        Test.startTest();
        HttpResponse response = WebPushNotification.sendNotifications(subscriptions, payloads);
        Test.stopTest();

        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('Notification sent', response.getBody(), 'The request body does not confirm the notification sending');
    }

    /**
     * @description Test the queueable class execution.
     */
    @isTest
    private static void execute_Test() {
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        Subscription__c[] subscriptions = new Subscription__c[] {};
        for (Integer i = 0; i < 500; i++) {
            subscriptions.add(new Subscription__c(Endpoint__c = 'http://example.com',
                                                  p256dh__c = 'p256dhTest',
                                                  auth__c = 'authTest'));
        }
        Record__c[] records = new Record__c[] {};
        for (Integer i = 0; i < 200; i++) {
            records.add(new Record__c(Name = 'Song', Artist__c = 'Artist', Likes__c = 10,
                                      Year__c = 2020, Cover__c = 'http://example.com'));
        }
        String errorMessage;

        Test.startTest();
        try {
            System.enqueueJob(new WebPushNotification(subscriptions, records, 'LikedRecordPayload'));
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assertEquals(null, errorMessage, 'The process returned an error');
    }

}