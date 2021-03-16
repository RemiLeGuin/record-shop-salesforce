trigger Record on Record__c (after update) {
    Subscription__c[] subscriptions = [SELECT Endpoint__c, p256dh__c, auth__c
                                       FROM Subscription__c
                                       ORDER BY CreatedDate DESC];
    Record__c[] likedRecords = new Record__c[] {};
    for (Record__c record : Trigger.new) {
        if (record.Likes__c > Trigger.oldMap.get(record.Id).Likes__c) {
            likedRecords.add(record);
        }
    }
    if (!subscriptions.isEmpty() && !likedRecords.isEmpty()) {
        System.enqueueJob(new WebPushNotification(subscriptions, likedRecords, 'LikedRecordPayload'));
    }
}