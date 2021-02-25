trigger Record on Record__c (after update) {
    List<Subscription__c> subscriptions = [SELECT Endpoint__c, p256dh__c, auth__c FROM Subscription__c];
    for (Record__c record : Trigger.new) {
        System.enqueueJob(new WebPushNotification(subscriptions,
                                                  record.Name + ' from ' + record.Artist__c + ' has been liked!',
                                                  'It now scores ' + record.Likes__c + ' likes.',
                                                  null,
                                                  record.Cover__c,
                                                  null));
    }
}