@isTest
public class TestDataFactory {
    public static ExcursionType__c createExcursionType(String name, String daysOfWeek) {
        ExcursionType__c excursionType = new ExcursionType__c(
            Name = name, 
            DaysOfWeek__c = daysOfWeek
        );
        return excursionType;
    }

    public static Tour__c createTour(String name, Date tourDate, Id excursionTypeId) {
        Tour__c tour = new Tour__c(
            Name = name, 
            Date__c = tourDate, 
            ExcursionType__c = excursionTypeId
        );
        return tour;
    }

    public static List<ExcursionType__c> createExcursionTypes(Integer numberOfExcursionTypes, String daysOfWeek) {
        List<ExcursionType__c> excursionTypes = new List<ExcursionType__c>();
        for(Integer i = 0; i < numberOfExcursionTypes; i++) {
            ExcursionType__c excursionType = new ExcursionType__c(
                Name = 'Test excursion Type ' + i, 
                DaysOfWeek__c = daysOfWeek
            );
            excursionTypes.add(excursionType);
        }
        return excursionTypes;
    }
}
