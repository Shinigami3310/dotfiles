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

    // --- State Management ---
    property int viewYear: currentYear
    property int viewMonth: currentMonth
    property string selectedDateKey: ""

    // Автоматический перерасчет при изменении viewYear/viewMonth
    readonly property int firstWeekdayOffset: (new Date(viewYear, viewMonth, 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    function resetView() {
        viewYear = currentYear;
        viewMonth = currentMonth;
        selectedDateKey = "";
    }

    function selectDay(day) {
        if (day >= 1 && day <= daysInMonth) {
            selectedDateKey = dayKey(viewYear, viewMonth, day);
        }
    }

    function changeMonth(delta) {
        let newMonth = viewMonth + delta;
        if (newMonth < 0) {
            viewMonth = 11;
            viewYear--;
        } else if (newMonth > 11) {
            viewMonth = 0;
            viewYear++;
        } else {
            viewMonth = newMonth;
        }
        selectedDateKey = "";
    }

    // --- Helpers ---
    function monthTitle(year, month) {
        return locale.toString(new Date(year, month, 1), "MMMM yyyy").toUpperCase();
    }

    function dayKey(year, month, day) {
        return `${year}-${month + 1}-${day}`;
    }

    function isToday(year, month, day) {
        return day === currentDay && month === currentMonth && year === currentYear;
    }

    function isPast(year, month, day) {
        if (year !== currentYear)
            return year < currentYear;
        if (month !== currentMonth)
            return month < currentMonth;
        return day < currentDay;
    }
}
