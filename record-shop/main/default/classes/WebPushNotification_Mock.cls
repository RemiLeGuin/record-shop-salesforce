@isTest
global class WebPushNotification_Mock implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('callout:WebPushNotification' + '/sendNotification', request.getEndpoint());
        System.assertEquals('POST', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setBody('Notification OK');
        response.setStatusCode(201);
        return response;
    }

}