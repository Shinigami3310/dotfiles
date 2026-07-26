pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../core"
import "../Singletons"

SurfaceBase {
    id: root

    surfaceName: "calendar"

    property real paddingX: 18
    property real paddingY: 16
    property real panelGap: 16
    property real gridGap: 4
    property real cellSize: 30
    property real detailWidth: 184

    readonly property var loc: Qt.locale("en_US")

    SystemClock {
        id: sysClock
        precision: SystemClock.Minutes
    }

    readonly property date today: sysClock.date

    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    property string selectedDate: ""

    readonly property int offset: firstWeekdayOffset(viewYear, viewMonth)
    readonly property int monthLen: daysInMonth(viewYear, viewMonth)
    readonly property int rows: Math.ceil((offset + monthLen) / 7)

    readonly property real headerH: 28
    readonly property real weekdayH: 16
    readonly property real gridW: 7 * cellSize + 6 * gridGap
    readonly property real gridH: headerH + 10 + weekdayH + 8 + rows * cellSize + Math.max(0, rows - 1) * gridGap

    readonly property bool hasSelection: selectedDate.length > 0

    implicitWidth: Math.ceil(content.implicitWidth + paddingX * 2)
    implicitHeight: Math.ceil(content.implicitHeight + paddingY * 2)

    function firstWeekdayOffset(year, month) {
        var d = new Date(year, month, 1).getDay();
        return (d + 6) % 7;
    }

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }

    function dateKey(day) {
        var mm = viewMonth + 1;
        var m = mm < 10 ? "0" + mm : "" + mm;
        var d = day < 10 ? "0" + day : "" + day;
        return viewYear + "-" + m + "-" + d;
    }

    function keyToDate(key) {
        var p = key.split("-");
        return new Date(Number(p[0]), Number(p[1]) - 1, Number(p[2]));
    }

    function isToday(day) {
        return day === today.getDate() && viewMonth === today.getMonth() && viewYear === today.getFullYear();
    }

    function formatMonthTitle() {
        return loc.toString(new Date(viewYear, viewMonth, 1), "MMMM yyyy").toUpperCase();
    }

    function formatSelectedDate() {
        if (selectedDate.length === 0)
            return "";
        return loc.toString(keyToDate(selectedDate), "ddd dd MMM").toUpperCase();
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
        selectedDate = "";
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
        selectedDate = "";
    }

    function resetView() {
        viewYear = today.getFullYear();
        viewMonth = today.getMonth();
        selectedDate = "";
    }

    function selectDay(day) {
        var key = dateKey(day);
        if (selectedDate === key) {
            selectedDate = "";
            return;
        }
        selectedDate = key;
    }

    onActiveChanged: if (active)
        resetView()

    Item {
        id: content
        x: root.paddingX
        y: root.paddingY

        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        Row {
            id: row
            spacing: root.hasSelection ? root.panelGap : 0

            Item {
                id: gridPane
                width: root.gridW
                height: root.gridH

                Column {
                    anchors.fill: parent
                    spacing: 8

                    Row {
                        width: parent.width
                        height: root.headerH

                        IslandButton {
                            size: 22
                            glyph: "‹"
                            onClicked: root.prevMonth()
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 44
                            horizontalAlignment: Text.AlignHCenter

                            text: root.formatMonthTitle()
                            font.family: Theme.font
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: Theme.text
                            antialiasing: true
                            elide: Text.ElideRight
                        }

                        IslandButton {
                            anchors.right: parent.right
                            size: 22
                            glyph: "›"
                            onClicked: root.nextMonth()
                        }
                    }

                    Row {
                        width: parent.width
                        height: root.weekdayH
                        spacing: root.gridGap

                        Repeater {
                            model: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

                            delegate: Text {
                                width: root.cellSize
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
                        id: monthGrid
                        width: parent.width
                        columns: 7
                        rowSpacing: root.gridGap
                        columnSpacing: root.gridGap

                        Repeater {
                            model: 42

                            delegate: Item {
                                required property int index

                                width: root.cellSize
                                height: root.cellSize

                                readonly property int dayNumber: index - root.offset + 1
                                readonly property bool inMonth: dayNumber >= 1 && dayNumber <= root.monthLen
                                readonly property bool selected: inMonth && root.selectedDate === root.dateKey(dayNumber)
                                readonly property bool todayMark: inMonth && root.isToday(dayNumber)
                                readonly property bool hovered: area.containsMouse

                                scale: hovered && inMonth ? 1.05 : 1.0
                                transformOrigin: Item.Center
                                opacity: inMonth ? 1.0 : 0.0
                                z: hovered ? 10 : 0

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: Motion.fast
                                        easing.type: Motion.easeStandard
                                    }
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 8

                                    color: selected ? Theme.accent : hovered ? Theme.hover : "transparent"

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

                                MouseArea {
                                    id: area
                                    anchors.fill: parent
                                    enabled: inMonth
                                    hoverEnabled: true
                                    acceptedButtons: Qt.LeftButton
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.selectDay(dayNumber)
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: detailPane
                width: root.hasSelection ? root.detailWidth : 0
                height: gridPane.height
                clip: true
                visible: width > 1
                opacity: root.hasSelection ? 1 : 0

                Behavior on width {
                    NumberAnimation {
                        duration: Motion.expand
                        easing.type: Easing.InOutQuad
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Motion.fade
                        easing.type: Motion.easeStandard
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 16
                    color: Theme.surface2
                    border.width: 1
                    border.color: Theme.separator
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Row {
                        width: parent.width

                        Text {
                            text: "Selected"
                            font.family: Theme.font
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                            color: Theme.text
                            antialiasing: true
                        }

                        Item {
                            width: 1
                            height: 1
                        }

                        IslandButton {
                            size: 22
                            glyph: "×"
                            onClicked: root.selectedDate = ""
                        }
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: root.formatSelectedDate()
                        font.family: Theme.font
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: Theme.text
                        antialiasing: true
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Theme.separator
                        opacity: 0.7
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: "Event editor comes next."
                        font.family: Theme.font
                        font.pixelSize: 10
                        color: Theme.textMuted
                        antialiasing: true
                    }
                }
            }
        }
    }
}
