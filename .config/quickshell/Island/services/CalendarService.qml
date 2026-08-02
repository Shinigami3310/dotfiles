pragma Singleton
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

    function monthTitle(year, month) {
        return locale.toString(new Date(year, month, 1), "MMMM yyyy").toUpperCase();
    }

    function dayKey(year, month, day) {
        return year + "-" + (month + 1) + "-" + day;
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
