@isTest
private class DateUtilsTest {
    @isTest private static void getDayOfWeekByStringDayTest() {
        Test.startTest();
        DateUtils.WeekDay dayOfTheWeek = DateUtils.getDayOfWeekByStringDay('Wed');
        Test.stopTest();

        System.assertEquals(DateUtils.WeekDay.WEDNESDAY, dayOfTheWeek);
    }

    @isTest private static void getDayOfWeekByStringDayWithIncorrectStringTest() {
        Exception caughtException = null;
        Test.startTest();
        try{
            DateUtils.WeekDay dayOfTheWeek = DateUtils.getDayOfWeekByStringDay('Wedn');
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'Exception should be thrown');
        System.assert(caughtException instanceof DateUtils.IncorrectStringDayException, 'Exception should be IncorrectStringDayException');
    }

    @isTest private static void getDayOfWeekTest() {
        Test.startTest();
        DateUtils.WeekDay dayOfTheWeek = DateUtils.getDayOfWeek(Date.newInstance(2022, 6, 13));
        Test.stopTest();

        System.assertEquals(DateUtils.WeekDay.MONDAY, dayOfTheWeek);
    }
}
