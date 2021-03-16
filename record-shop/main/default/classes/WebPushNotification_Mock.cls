/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Mock class for the WebPushNotification class.
 */
@isTest
global class WebPushNotification_Mock implements HttpCalloutMock {

    /**
     * @description Mock method for the WebPushNotification callout.
     * @param request The HTTP request object.
     * @return The mocking HTTP response.
     */
    global HttpResponse respond(HttpRequest request) {
        System.assertEquals('callout:WebPushNotification/sendNotifications', request.getEndpoint(), 'The endpoint is wrong');
        System.assertEquals('POST', request.getMethod(), 'The method is wrong');
        HttpResponse response = new HttpResponse();
        response.setBody('Notifications sent');
        response.setStatusCode(201);
        return response;
    }

}