@isTest
private class TourServiceTest {
    private final static Date START_DATE = Date.newInstance(2022, 6, 13);
    private final static Date END_DATE = START_DATE.addDays(13);

    @isTest private static void generateToursWithNullExcursionTypeIdsTest() {
        
        Test.startTest();
        TourService tourService = new TourService();
        Integer numberOfTours = tourService.generateTours(null, START_DATE, END_DATE);
        Test.stopTest();

        System.assertEquals(0, numberOfTours, '0 tours should be created');
    }

    @isTest private static void generateToursWithEmptyExcursionTypeIdsTest() {
        Set<Id> excursionTypeIds = new Set<Id>();

        Test.startTest();
        TourService tourService = new TourService();
        Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, END_DATE);
        Test.stopTest();

        System.assertEquals(0, numberOfTours, '0 tours should be created');
    }

    @isTest private static void generateToursWithNullStartDateTest() {
        ExcursionType__c excursionType = TestDataFactory.createExcursionType('Test Excursion Type', '');
        insert excursionType;

        Set<Id> excursionTypeIds = new Set<Id>();
        excursionTypeIds.add(excursionType.Id);

        Exception caughtException = null;
        TourService tourService = new TourService();

        Test.startTest();
        try {
            Integer numberOfTours = tourService.generateTours(excursionTypeIds, null, END_DATE);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'Exception should be thrown');
        System.assert(caughtException instanceof TourService.IncorrectDateRangeException, 'Exception should be IncorrectDateRangeException');
        System.assertEquals(System.Label.IncorrectDateRangeExceptionMessage, caughtException.getMessage(), 'Incorrect Exception Message');
    }

    @isTest private static void generateToursWithNullEndDateTest() {
        ExcursionType__c excursionType = TestDataFactory.createExcursionType('Test Excursion Type', '');
        insert excursionType;

        Set<Id> excursionTypeIds = new Set<Id>();
        excursionTypeIds.add(excursionType.Id);

        Exception caughtException = null;
        TourService tourService = new TourService();

        Test.startTest();
        try {
            Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, null);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'Exception should be thrown');
        System.assert(caughtException instanceof TourService.IncorrectDateRangeException, 'Exception should be IncorrectDateRangeException');
        System.assertEquals(System.Label.IncorrectDateRangeExceptionMessage, caughtException.getMessage(), 'Incorrect Exception Message');
    }

    @isTest private static void generateToursWithEndDateEarlierThanStartDateTest() {
        Date endDate = START_DATE.addDays(-14);

        ExcursionType__c excursionType = TestDataFactory.createExcursionType('Test Excursion Type', '');
        insert excursionType;

        Set<Id> excursionTypeIds = new Set<Id>();
        excursionTypeIds.add(excursionType.Id);

        Exception caughtException = null;
        TourService tourService = new TourService();

        Test.startTest();
        try {
            Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, endDate);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'Exception should be thrown');
        System.assert(caughtException instanceof TourService.IncorrectDateRangeException, 'Exception should be IncorrectDateRangeException');
        System.assertEquals(System.Label.IncorrectDateRangeExceptionMessage, caughtException.getMessage(), 'Incorrect Exception Message');
    }

    @isTest private static void generateToursWithNoExistingToursTest() {
        ExcursionType__c excursionType = TestDataFactory.createExcursionType('Test Excursion Type', 'Mon;Wed;Fri');
        insert excursionType;

        Set<Id> excursionTypeIds = new Set<Id>();
        excursionTypeIds.add(excursionType.Id);

        Test.startTest();
        TourService tourService = new TourService();
        Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, END_DATE);
        Test.stopTest();

        Integer numberOfToursForExcursionType = [SELECT COUNT() FROM Tour__c WHERE ExcursionType__c = :excursionType.Id];
        System.assertEquals(6, numberOfTours, '6 tours should be created');
        System.assertEquals(6, numberOfToursForExcursionType, '6 tours should be for this excursion type');
    }

    @isTest private static void generateToursWithExistingToursTest() {
        ExcursionType__c excursionType = TestDataFactory.createExcursionType('Test Excursion Type', 'Mon;Wed;Fri');
        insert excursionType;

        Set<Id> excursionTypeIds = new Set<Id>();
        excursionTypeIds.add(excursionType.Id);

        List<Tour__c> tours = new List<Tour__c>();
        tours.add(TestDataFactory.createTour('Tour1', Date.newInstance(2022, 6, 15), excursionType.Id));
        tours.add(TestDataFactory.createTour('Tour2', Date.newInstance(2022, 6, 24), excursionType.Id));
        insert tours;

        Test.startTest();
        TourService tourService = new TourService();
        Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, END_DATE);
        Test.stopTest();

        Integer numberOfToursForExcursionType = [SELECT COUNT() FROM Tour__c WHERE ExcursionType__c = :excursionType.Id];
        System.assertEquals(4, numberOfTours, '4 tours should be created');
        System.assertEquals(6, numberOfToursForExcursionType, '6 tours should be for this excursion type');
    }

    @isTest private static void generateToursBulkTest() {
        List<ExcursionType__c> excursionTypesToInsert = TestDataFactory.createExcursionTypes(50, 'Mon;Wed;Fri');
        insert excursionTypesToInsert;
        
        Set<Id> excursionTypeIds = (new Map<Id,ExcursionType__c>(excursionTypesToInsert)).keySet();

        Test.startTest();
        TourService tourService = new TourService();
        Integer numberOfTours = tourService.generateTours(excursionTypeIds, START_DATE, END_DATE);
        Test.stopTest();

        Integer numberOfToursForExcursionType = [SELECT COUNT() FROM Tour__c];
        System.assertEquals(300, numberOfTours, '300 tours should be created');
        System.assertEquals(300, numberOfToursForExcursionType, '300 tours should be on the org');
    }
}
