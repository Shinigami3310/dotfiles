import QtQuick
import Quickshell
import "../core"
import "../modules/bar"
import "../Singletons"
import "../services"

SurfaceBase {
    id: root

    surfaceName: "calendar"
    persistent: false
    wantsKeyboardFocus: true
    escapePolicy: escapeBack
    canGoBack: true

    property real paddingX: 18
    property real paddingY: 16
    property real gridGap: 4
    property real cellSize: 30

    readonly property var locale: Qt.locale("en_US")

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }

    readonly property date today: sysClock.date
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    property string selectedDateKey: ""

    readonly property int firstWeekdayOffset: {
        var d = new Date(viewYear, viewMonth, 1).getDay();
        return (d + 6) % 7;
    }

    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    readonly property real headerHeight: 28
    readonly property real weekdayHeight: 16
    readonly property real gridWidth: 7 * cellSize + 6 * gridGap
    readonly property real gridHeight: headerHeight + 10 + weekdayHeight + 8 + 6 * cellSize + 5 * gridGap

    implicitWidth: gridWidth + paddingX * 2
    implicitHeight: gridHeight + paddingY * 2

    function resetView() {
        viewYear = today.getFullYear();
        viewMonth = today.getMonth();
        selectedDateKey = "";
    }

    function monthTitle() {
        return locale.toString(new Date(viewYear, viewMonth, 1), "MMMM yyyy").toUpperCase();
    }

    function dayKey(day) {
        var mm = viewMonth + 1;
        var m = mm < 10 ? "0" + mm : "" + mm;
        var d = day < 10 ? "0" + day : "" + day;
        return viewYear + "-" + m + "-" + d;
    }

    function isToday(day) {
        return day === today.getDate() && viewMonth === today.getMonth() && viewYear === today.getFullYear();
    }

    function prevMonth() {
        var m = viewMonth - 1;
        var y = viewYear;
        if (m < 0) {
            m = 11;
            y -= 1;
        }
        viewMonth = m;
        viewYear = y;
        selectedDateKey = "";
    }

    function nextMonth() {
        var m = viewMonth + 1;
        var y = viewYear;
        if (m > 11) {
            m = 0;
            y += 1;
        }
        viewMonth = m;
        viewYear = y;
        selectedDateKey = "";
    }

    onActiveChanged: {
        if (active)
            resetView();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: root.backRequested()
    }

    Item {
        anchors.centerIn: parent
        implicitWidth: gridWidth
        implicitHeight: gridHeight

        Column {
            spacing: 8

            Row {
                width: gridWidth
                height: headerHeight

                Item {
                    width: 22
                    height: 22

                    Text {
                        anchors.centerIn: parent
                        text: "‹"
                        font.family: Theme.font
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: Theme.textMuted
                        antialiasing: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.prevMonth()
                    }
                }

                Text {
                    width: gridWidth - 44
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: root.monthTitle()
                    font.family: Theme.font
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: Theme.text
                    antialiasing: true
                    elide: Text.ElideRight
                }

                Item {
                    width: 22
                    height: 22

                    Text {
                        anchors.centerIn: parent
                        text: "›"
                        font.family: Theme.font
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: Theme.textMuted
                        antialiasing: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton
                        onClicked: root.nextMonth()
                    }
                }
            }
            Row {
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

            Grid {
                width: gridWidth
                columns: 7
                rowSpacing: gridGap
                columnSpacing: gridGap

                Repeater {
                    model: 42

                    delegate: Item {
                        required property int index

                        width: cellSize
                        height: cellSize

                        readonly property int dayNumber: index - root.firstWeekdayOffset + 1
                        readonly property bool inMonth: dayNumber >= 1 && dayNumber <= root.daysInMonth
                        readonly property bool selected: inMonth && root.selectedDateKey === root.dayKey(dayNumber)
                        readonly property bool todayMark: inMonth && root.isToday(dayNumber)
                        readonly property bool hovered: hover.hovered

                        scale: hovered && inMonth ? 1.05 : 1.0
                        z: hovered ? 10 : 0
                        transformOrigin: Item.Center

                        Behavior on scale {
                            NumberAnimation {
                                duration: Motion.fast
                                easing.type: Motion.easeStandard
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: 8

                            color: selected ? Theme.accent : hovered && inMonth ? Theme.hover : "transparent"
                            border.width: selected || todayMark || hovered ? 1 : 0
                            border.color: selected ? Theme.accent : todayMark ? Theme.accent : Theme.separator
                            opacity: selected ? 1.0 : todayMark ? 0.95 : 0.55

                            Behavior on color {
                                ColorAnimation {
                                    duration: Motion.fast
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: Motion.fast
                                }
                            }
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Motion.fast
                                    easing.type: Motion.easeStandard
                                }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: inMonth ? dayNumber : ""
                            font.family: Theme.font
                            font.pixelSize: 11
                            font.weight: selected ? Font.DemiBold : Font.Medium
                            color: selected ? Theme.accentText : todayMark ? Theme.text : Theme.textMuted
                            antialiasing: true
                        }

                        HoverHandler {
                            id: hover
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: inMonth
                            acceptedButtons: Qt.LeftButton
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectDay(dayNumber)
                        }
                    }
                }
            }
        }
    }
}
