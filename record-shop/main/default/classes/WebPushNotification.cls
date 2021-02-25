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
            gen.writeFieldName('payload');
            gen.writeStartObject();
            if(String.isNotBlank(title)) {
                gen.writeStringField('title', title);
            }
            if(String.isNotBlank(body)) {
                gen.writeStringField('body', body);
            }
            if(String.isNotBlank(icon)) {
                gen.writeStringField('icon', icon);
            }
            if(String.isNotBlank(image)) {
                gen.writeStringField('image', image);
            }
            if(String.isNotBlank(badge)) {
                gen.writeStringField('badge', badge);
            }
            gen.writeEndObject();
            gen.writeEndObject();
            gen.close();
            request.setBody(gen.getAsString());

            HttpResponse response = new Http().send(request);
        }
    }
    
}