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
        String[] titleParameters = new String[] { record.Name, record.Artist__c };
        payload.title = String.format(System.Label.LikeNotificationTitle, titleParameters);
        String[] bodyParameters = new String[] { String.valueOf((Integer)record.Likes__c) };
        payload.body = String.format(System.Label.LikeNotificationBody, bodyParameters);
        payload.icon = System.Label.RecordShopIcon;
        payload.image = record.Cover__c;
        payload.badge = System.Label.RecordShopIconMonochrome;
        return payload;
    }

}