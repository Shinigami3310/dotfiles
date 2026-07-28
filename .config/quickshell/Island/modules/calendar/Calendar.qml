import QtQuick
import Quickshell
import "../../Singletons"
import "../../services"

Item {
    id: root

    property real paddingX: 18
    property real paddingY: 16

    property real gridGap: 4
    property real cellSize: 30
    property int viewYear: CalendarService.today.getFullYear()
    property int viewMonth: CalendarService.today.getMonth()
    property string selectedDateKey: ""

    readonly property real headerHeight: 28
    readonly property real weekdayHeight: 16
    readonly property real gridWidth: 7 * cellSize + 6 * gridGap
    readonly property real gridHeight: headerHeight + 10 + weekdayHeight + 8 + 6 * cellSize + 5 * gridGap

    implicitWidth: gridWidth + paddingX * 2
    implicitHeight: gridHeight + paddingY * 2

    readonly property int firstWeekdayOffset: {
        const dayOfWeek = new Date(viewYear, viewMonth, 1).getDay();
        return (dayOfWeek + 6) % 7;
    }
    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    property bool transitioning: false

    function resetView() {
        viewYear = CalendarService.today.getFullYear();
        viewMonth = CalendarService.today.getMonth();
        selectedDateKey = "";
    }

    function selectDay(day) {
        if (day >= 1 && day <= daysInMonth)
            selectedDateKey = CalendarService.dayKey(viewYear, viewMonth, day);
    }

    function changeMonth(delta) {
        if (transitioning)
            return;
        transitioning = true;
        monthFade.opacity = 0;
        transitionTimer.delta = delta;
        transitionTimer.start();
    }

    Timer {
        id: transitionTimer
        interval: 300 // половина длительности анимации opacity
        repeat: false
        property int delta: 0

        onTriggered: {
            if (delta < 0) {
                if (viewMonth === 0) {
                    viewMonth = 11;
                    viewYear--;
                } else {
                    viewMonth--;
                }
            } else {
                if (viewMonth === 11) {
                    viewMonth = 0;
                    viewYear++;
                } else {
                    viewMonth++;
                }
            }
            selectedDateKey = "";
            monthFade.opacity = 1;
            transitioning = false;
        }
    }

    Row {
        id: headerRow
        anchors.top: parent.top
        anchors.topMargin: root.paddingY
        anchors.horizontalCenter: parent.horizontalCenter
        width: gridWidth
        height: headerHeight

        NavButton {
            text: "‹"
            onClicked: root.changeMonth(-1)
        }

        Text {
            width: gridWidth - 44
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            text: CalendarService.monthTitle(root.viewYear, root.viewMonth)
            font.family: Theme.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
            color: Theme.text
            antialiasing: true
            elide: Text.ElideRight
        }

        NavButton {
            text: "›"
            onClicked: root.changeMonth(1)
        }
    }

    Row {
        id: weekdayRow
        anchors.top: headerRow.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        width: gridWidth
        height: weekdayHeight
        spacing: gridGap

        Repeater {
            model: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
            delegate: Text {
                width: cellSize
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                font.family: Theme.font
                font.pixelSize: 9
                font.weight: Font.DemiBold
                color: Theme.textMuted
                antialiasing: true
            }
        }
    }
    Item {
        id: monthFade
        anchors.top: weekdayRow.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        width: gridWidth
        height: 6 * cellSize + 5 * gridGap
        opacity: 1

        Behavior on opacity {
            NumberAnimation {
                duration: 300
                easing.type: Motion.easeStandard
            }
        }

        Grid {
            id: dayGrid
            columns: 7
            rowSpacing: gridGap
            columnSpacing: gridGap

            Repeater {
                model: 42

                delegate: DayCell {
                    dayNumber: index - root.firstWeekdayOffset + 1
                    inMonth: dayNumber >= 1 && dayNumber <= root.daysInMonth
                    selected: inMonth && root.selectedDateKey === CalendarService.dayKey(root.viewYear, root.viewMonth, dayNumber)
                    isToday: inMonth && CalendarService.isToday(root.viewYear, root.viewMonth, dayNumber)
                    isPast: inMonth && CalendarService.isPast(root.viewYear, root.viewMonth, dayNumber)
                    onClicked: root.selectDay(dayNumber)
                }
            }
        }
    }
}
