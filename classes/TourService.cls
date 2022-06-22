public with sharing class TourService {
    public Integer generateTours(final Set<Id> excursionTypeIds, final Date startDate, final Date endDate) {
        Integer numberOfTours = 0;
        List<Tour__c> toursToInsert = new List<Tour__c>();

        if(excursionTypeIds == null || excursionTypeIds.isEmpty()) {
            return numberOfTours;
        }

        if(startDate == null || endDate == null || startDate > endDate) {
            throw new IncorrectDateRangeException(System.Label.IncorrectDateRangeExceptionMessage);
        }

        List<ExcursionType__c> excursionTypesList = queryExcursionTypesByIdsAndDateInterval(excursionTypeIds, startDate, endDate);

        for(ExcursionType__c excursionType : excursionTypesList) {
            Set<DateUtils.WeekDay> weekDaysToCreateTours = new Set<DateUtils.WeekDay>();
            Set<Date> existingTourDates = new Set<Date>();

            for(String day : excursionType.DaysOfWeek__c.split(';')) {
                weekDaysToCreateTours.add(DateUtils.getDayOfWeekByStringDay(day));
            }
            
            for(Tour__c tour : excursionType.Tours__r) {
                existingTourDates.add(tour.Date__c);
            }

            Date dateIterator = startDate;
            while(dateIterator <= endDate) {
                DateUtils.WeekDay currentWeekDay = DateUtils.getDayOfWeek(dateIterator);
                if(weekDaysToCreateTours.contains(currentWeekDay) && !existingTourDates.contains(dateIterator)) {
                    Tour__c tour = createTourRecord(excursionType, dateIterator);
                    toursToInsert.add(tour);
                }
                dateIterator = dateIterator.addDays(1);
            }
        }
        insert toursToInsert;
        numberOfTours = toursToInsert.size();

        return numberOfTours;
    }

    private Tour__c createTourRecord(ExcursionType__c excursionType, Date dateIterator) {
        return new Tour__c(
            Name = excursionType.Name + ' ' + dateIterator.format(), 
            Date__c = dateIterator, 
            ExcursionType__c = excursionType.Id
        );
    }

    private List<ExcursionType__c> queryExcursionTypesByIdsAndDateInterval(final Set<Id> excursionTypeIds, final Date startDate, final Date endDate) {
        return [
            SELECT Name, DaysOfWeek__c, 
                (SELECT Date__c 
                FROM Tours__r 
                WHERE Date__c >= :startDate 
                    AND Date__c <= :endDate) 
            FROM ExcursionType__c 
            WHERE Id IN :excursionTypeIds
                AND DaysOfWeek__c != null
        ];
    }

    public class IncorrectDateRangeException extends Exception {}
}
