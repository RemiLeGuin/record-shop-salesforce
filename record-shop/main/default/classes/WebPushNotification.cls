public with sharing class WebPushNotification implements Queueable, Database.AllowsCallouts {

    public List<Subscription__c> subscriptions;
    public String title;
    public String body;
    public String icon;
    public String image;
    public String badge;

    public WebPushNotification(List<Subscription__c> subscriptions,
                               String title,
                               String body,
                               String icon,
                               String image,
                               String badge) {
        this.subscriptions = subscriptions;
        this.title = title;
        this.body = body;
        this.icon = icon;
        this.image = image;
        this.badge = badge;
    }

    public void execute(QueueableContext context) {
        for (Subscription__c subscription : subscriptions) {
            sendSingleWebPushNotification(subscription, title, body, icon, image, badge);
        }
    }

    @TestVisible
    private static HttpResponse sendSingleWebPushNotification(Subscription__c subscription,
                                                              String title,
                                                              String body,
                                                              String icon,
                                                              String image,
                                                              String badge) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:WebPushNotification' + '/sendNotification');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        JSONGenerator generator = JSON.createGenerator(false);
        generator.writeStartObject();
        generator.writeStringField('endpoint', subscription.Endpoint__c);
        generator.writeStringField('p256dh', subscription.p256dh__c);
        generator.writeStringField('auth', subscription.auth__c);
        generator.writeStringField('vapidPublicKey', '{!$Credential.Username}');
        generator.writeStringField('vapidPrivateKey', '{!$Credential.Password}');
        generator.writeFieldName('payload');
        generator.writeStartObject();
        if(String.isNotBlank(title)) {
            generator.writeStringField('title', title);
        }
        if(String.isNotBlank(body)) {
            generator.writeStringField('body', body);
        }
        if(String.isNotBlank(icon)) {
            generator.writeStringField('icon', icon);
        }
        if(String.isNotBlank(image)) {
            generator.writeStringField('image', image);
        }
        if(String.isNotBlank(badge)) {
            generator.writeStringField('badge', badge);
        }
        generator.writeEndObject();
        generator.writeEndObject();
        generator.close();
        request.setBody(generator.getAsString());

        HttpResponse response = new Http().send(request);
        return response;
    }
    
}