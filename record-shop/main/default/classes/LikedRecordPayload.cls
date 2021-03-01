/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Class to compose payloads when records are liked.
 */
public with sharing class LikedRecordPayload implements PayloadComposition {

    /**
     * @description Compose a WebPushNotificationPayload object ready to be serialized.
     * @param salesforceRecord A SObject record.
     * @return A WebPushNotificationPayload object instanciation.
     */
    public static WebPushNotificationPayload getPayload(SObject salesforceRecord) {
        Record__c record = (Record__c)salesforceRecord;
        WebPushNotificationPayload payload = new WebPushNotificationPayload();
        payload.title = record.Name + ' from ' + record.Artist__c + ' has been liked!';
        payload.body = 'It now scores ' + record.Likes__c + ' likes.';
        payload.imageUrl = record.Cover__c;
        return payload;
    }

}