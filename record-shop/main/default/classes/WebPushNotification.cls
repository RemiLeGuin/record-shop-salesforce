/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Queueable class using a generator to send web push notifications.
 */
public with sharing class WebPushNotification implements Queueable, Database.AllowsCallouts {

    public Subscription__c[] subscriptions;
    public SObject[] records;
    public String payloadType;

    /**
     * @description Queueable class using a generator to send web push notifications.
     * @param subscriptions List of subscriptions SObject records to send a notification to.
     * @param records List of SObject records for which to display notifications.
     * @param payloadType Name of the class implementing the PayloadComposition interface to compose the desired payload.
     */
    public WebPushNotification(Subscription__c[] subscriptions, SObject[] records, String payloadType) {
        this.subscriptions = subscriptions;
        this.records = records;
        this.payloadType = payloadType;
    }

    /**
     * @description Once the job is enqueued, standard method to execute for classes implementing the queueable interface.
     * @param context Standard parameter to instanciate a job.
     */
    public void execute(QueueableContext context) {
        PayloadComposition payloadCompositionInstance = (PayloadComposition)Type.forName(payloadType)?.newInstance();
        if (payloadCompositionInstance != null && records != null && !records.isEmpty()) {
            WebPushNotificationPayload[] payloads = new WebPushNotificationPayload[] {};
            for (SObject record : records) {
                WebPushNotificationPayload payload = payloadCompositionInstance.getPayload(record);
                if (payload != null && String.isNotBlank(payload.title)) {
                    payloads.add(payload);
                }
            }
            if (subscriptions != null && !subscriptions.isEmpty() && !payloads.isEmpty()) {
                sendNotifications(subscriptions, payloads);
            }
        }
    }

    /**
     * @description Make a callout to the web push notification generator service.
     * @param subscriptions List of subscriptions SObject records to send a notification to.
     * @param payloads List of payloads containing information to display in the notification.
     * @return Webservice response from the generator.
     */
    @TestVisible
    private static HttpResponse sendNotifications(Subscription__c[] subscriptions, WebPushNotificationPayload[] payloads) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:WebPushNotification/sendNotifications');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('vapidPublicKey', '{!$Credential.Username}');
        generator.writeStringField('vapidPrivateKey', '{!$Credential.Password}');
        generator.writeFieldName('payloads');
        generator.writeObject(payloads);
        generator.writeFieldName('subscriptions');
        generator.writeStartArray();
        for (Subscription__c subscription : subscriptions) {
            generator.writeStartObject();
            generator.writeStringField('endpoint', subscription.endpoint__c);
            generator.writeStringField('p256dh', subscription.p256dh__c);
            generator.writeStringField('auth', subscription.auth__c);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();
        generator.close();
        request.setBody(generator.getAsString());
        System.debug(request.getBody());

        HttpResponse response = new Http().send(request);
        return response;
    }

}