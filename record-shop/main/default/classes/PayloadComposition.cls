/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Interface to compose payloads for web push notifications.
 */
public interface PayloadComposition {
    WebPushNotificationPayload getPayload(SObject record);
}