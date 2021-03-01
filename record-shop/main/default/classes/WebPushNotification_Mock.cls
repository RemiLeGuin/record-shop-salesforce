@isTest
global class WebPushNotification_Mock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('callout:WebPushNotification' + '/sendNotifications', request.getEndpoint());
        System.assertEquals('POST', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setBody('Notification sent');
        response.setStatusCode(201);
        return response;
    }

}