import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property var locale: Qt.locale("en_US")

    readonly property SystemClock clock: SystemClock {
        precision: SystemClock.Hours
    }
    readonly property date today: clock.date

    readonly property int currentYear: today.getFullYear()
    readonly property int currentMonth: today.getMonth()
    readonly property int currentDay: today.getDate()

    property int viewYear: currentYear
    property int viewMonth: currentMonth
    property string selectedDateKey: ""

    readonly property int firstWeekdayOffset: (new Date(viewYear, viewMonth, 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    function resetView() {
        viewYear = currentYear;
        viewMonth = currentMonth;
        selectedDateKey = "";
    }

    function selectDay(day: int) {
        if (day >= 1 && day <= daysInMonth) {
            selectedDateKey = dayKey(viewYear, viewMonth, day);
        }
    }

    function changeMonth(delta: int) {
        let d = new Date(viewYear, viewMonth + delta, 1);
        viewYear = d.getFullYear();
        viewMonth = d.getMonth();
        selectedDateKey = "";
    }

    function monthTitle(year: int, month: int): string {
        return locale.toString(new Date(year, month, 1), "MMMM yyyy").toUpperCase();
    }

    function dayKey(year: int, month: int, day: int): string {
        return `${year}-${month + 1}-${day}`;
    }

    function isToday(year: int, month: int, day: int): bool {
        return day === currentDay && month === currentMonth && year === currentYear;
    }

    function isPast(year: int, month: int, day: int): bool {
        if (year !== currentYear)
            return year < currentYear;
        if (month !== currentMonth)
            return month < currentMonth;
        return day < currentDay;
    }
}
