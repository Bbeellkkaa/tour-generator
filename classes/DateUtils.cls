public inherited sharing class DateUtils {
    public enum WeekDay {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}
    private final static Date MONDAY_DATE = date.newInstance(0001, 1, 3);

    private final static Map<String, WeekDay> DAY_TO_NUMBER_MAP = new Map<String, WeekDay> {
        'Mon' => WeekDay.MONDAY, 
        'Tue' => WeekDay.TUESDAY, 
        'Wed' => WeekDay.WEDNESDAY, 
        'Thu' => WeekDay.THURSDAY,
        'Fri' => WeekDay.FRIDAY,
        'Sat' => WeekDay.SATURDAY,
        'Sun' => WeekDay.SUNDAY
    };

    public static WeekDay getDayOfWeekByStringDay(String day) {
        if(DAY_TO_NUMBER_MAP.containsKey(day)) {
            return DAY_TO_NUMBER_MAP.get(day);
        }

        throw new IncorrectStringDayException();
    }

    public static WeekDay getDayOfWeek(Date dateValue) {
        Integer dayNumber = Math.mod(MONDAY_DATE.daysBetween(dateValue) , 7);
        return WeekDay.values()[dayNumber];
    }

    public class IncorrectStringDayException extends Exception {}
}
