pragma Singleton
import QtQuick
import Quickshell

QtObject {
    readonly property var locale: Qt.locale("en_US")
    readonly property date today: clock.date
    readonly property SystemClock clock: SystemClock {
        precision: SystemClock.Hours
    }

    function monthTitle(year, month) {
        return locale.toString(new Date(year, month, 1), "MMMM yyyy").toUpperCase();
    }

    function dayKey(year, month, day) {
        const m = String(month + 1).padStart(2, "0");
        const d = String(day).padStart(2, "0");
        return `${year}-${m}-${d}`;
    }

    function isToday(year, month, day) {
        return day === today.getDate() && month === today.getMonth() && year === today.getFullYear();
    }

    function isPast(year, month, day) {
        const cell = new Date(year, month, day);
        const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        return cell < startOfToday;
    }
}
