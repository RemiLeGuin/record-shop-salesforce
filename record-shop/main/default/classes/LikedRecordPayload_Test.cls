/**
 * @author Rémi Le Guin
 * @date 01/03/2021
 * @description Test for the LikedRecordPayload class.
 */
@isTest
private class LikedRecordPayload_Test {

    /**
     * @description Test the getPayload method.
     */
    @isTest
    private static void getPayload_Test() {
        Record__c record = new Record__c(Name = 'Song', Artist__c = 'Artist', Likes__c = 10,
                                         Year__c = 2020, Cover__c = 'http://example.com');

        Test.startTest();
        WebPushNotificationPayload payload = LikedRecordPayload.getPayload(record);
        Test.stopTest();

        System.assertEquals('Song from Artist has been liked!', payload.title, 'The method did not generate the right message');
        System.assertEquals('It now scores 10 likes.', payload.body, 'The method did not generate the right message');
        System.assertEquals(null, payload.iconUrl, 'The method generated an icon URL');
        System.assertEquals('http://example.com', payload.imageUrl, 'The method did not took the right URL from the record');
        System.assertEquals(null, payload.badgeUrl, 'The method generated an badge URL');
    }

}