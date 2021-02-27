@isTest
private class WebPushNotification_Test {

    @isTest
    private static void sendSingleWebPushNotification_Test() {
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        Subscription__c subscription = new Subscription__c(Endpoint__c = 'http://example.com',
                                                           p256dh__c = 'p256dhTest',
                                                           auth__c = 'authTest');
        Test.startTest();
        HttpResponse response = WebPushNotification.sendSingleWebPushNotification(subscription,
                                                                                  'Song from artist has been liked!',
                                                                                  'It now scores 2 likes.',
                                                                                  'http://example.com',
                                                                                  'http://example.com',
                                                                                  'http://example.com');
        Test.stopTest();
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals(response.getBody(), 'Notification OK', 'The request body does not confirm the notification sending');
    }

    @isTest
    private static void execute_TestSuccess() {
        Test.setMock(HttpCalloutMock.class, new WebPushNotification_Mock());
        List<Subscription__c> subscriptions = new List<Subscription__c> ();
        for (Integer i = 0; i < 100; i++) {
            subscriptions.add(new Subscription__c(Endpoint__c = 'http://example.com',
                                                  p256dh__c = 'p256dhTest',
                                                  auth__c = 'authTest'));
        }
        String errorMessage;
        Test.startTest();
        try {
            System.enqueueJob(new WebPushNotification(subscriptions,
                                                      'Song from artist has been liked!',
                                                      'It now scores 2 likes.',
                                                      null,
                                                      'http://example.com',
                                                      null));
        } catch(Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();
        System.assertEquals(errorMessage, null, 'The process returned an error');
    }

}