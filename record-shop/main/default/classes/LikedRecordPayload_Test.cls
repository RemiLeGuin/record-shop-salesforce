/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Test class for the LikedRecordPayload class.
 */
@isTest
private class LikedRecordPayload_Test {

    /**
     * @description Test the getPayload method.
     */
    @isTest
    private static void getPayload_Test() {
        Record__c record = new Record__c(Name = 'Song', Artist__c = 'Artist', Likes__c = 10,
                                         Year__c = 2021, Cover__c = 'http://example.com');

        Test.startTest();
        WebPushNotificationPayload payload = LikedRecordPayload.getPayload(record);
        Test.stopTest();

        String[] titleParameters = new String[] { record.Name, record.Artist__c };
        System.assertEquals(String.format(System.Label.LikeNotificationTitle, titleParameters), payload.title, 'The method did not generate the right message');
        String[] bodyParameters = new String[] { String.valueOf((Integer)record.Likes__c) };
        System.assertEquals(String.format(System.Label.LikeNotificationBody, bodyParameters), payload.body, 'The method did not generate the right message');
        System.assertEquals(System.Label.RecordShopIcon, payload.icon, 'The method did not generated an icon URL');
        System.assertEquals('http://example.com', payload.image, 'The method did not took the right URL from the record');
        System.assertEquals(System.Label.RecordShopIconMonochrome, payload.badge, 'The method did not generated an badge URL');
    }

}