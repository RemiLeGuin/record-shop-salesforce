public with sharing class WebPushNotification implements Queueable, Database.AllowsCallouts {

    public List<Subscription__c> subscriptions;
    public String message;

    public WebPushNotification(List<Subscription__c> subscriptions, String message) {
        this.subscriptions = subscriptions;
        this.message = message;
    }

    public void execute(QueueableContext context) {
        for (Subscription__c subscription : subscriptions) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:WebPushNotification' + '/sendNotification');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');

            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeStringField('endpoint', subscription.Endpoint__c);
            gen.writeStringField('p256dh', subscription.p256dh__c);
            gen.writeStringField('auth', subscription.auth__c);
            gen.writeStringField('vapidPublicKey', '{!$Credential.Username}');
            gen.writeStringField('vapidPrivateKey', '{!$Credential.Password}');
            gen.writeStringField('payload', message);
            gen.writeEndObject();
            request.setBody(gen.getAsString());

            HttpResponse response = new Http().send(request);
        }
    }
    
}