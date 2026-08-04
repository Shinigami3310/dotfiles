import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    readonly property int paddingX: 20
    readonly property int paddingY: 16

    implicitWidth: contentColumn.implicitWidth + (paddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (paddingY * 2)

    CalendarService {
        id: calendarService
    }

    SequentialAnimation {
        id: monthTransitionAnim
        property int delta: 0

        ParallelAnimation {
            NumberAnimation {
                target: monthFade
                property: "opacity"
                to: 0
                duration: Motion.morph
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: monthTitleText
                property: "opacity"
                to: 0
                duration: Motion.morph
                easing.type: Easing.InOutQuad
            }
        }

        ScriptAction {
            script: calendarService.changeMonth(monthTransitionAnim.delta)
        }

        ParallelAnimation {
            NumberAnimation {
                target: monthFade
                property: "opacity"
                to: 1
                duration: Motion.morph
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: monthTitleText
                property: "opacity"
                to: 1
                duration: Motion.morph
                easing.type: Easing.InOutQuad
            }
        }
    }

    function requestMonthChange(delta) {
        if (!monthTransitionAnim.running) {
            monthTransitionAnim.delta = delta;
            monthTransitionAnim.start();
        }
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 10

        Row {
            width: dayGrid.implicitWidth
            height: 28

            NavButton {
                text: "‹"
                onClicked: root.requestMonthChange(-1)
            }

            Text {
                id: monthTitleText
                width: parent.width - (24 * 2)
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                text: calendarService.monthTitle(calendarService.viewYear, calendarService.viewMonth)
                font {
                    family: Theme.font
                    pixelSize: 14
                    weight: Font.Normal
                }
                color: ThemeColor.on_surface
                elide: Text.ElideRight
            }

            NavButton {
                text: "›"
                onClicked: root.requestMonthChange(1)
            }
        }

        Row {
            spacing: 4
            Repeater {
                model: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
                delegate: Text {
                    width: 30
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font {
                        family: Theme.font
                        pixelSize: 12
                        weight: Font.Normal
                    }
                    color: ThemeColor.on_surface
                }
            }
        }

        Item {
            id: monthFade
            implicitWidth: dayGrid.implicitWidth
            implicitHeight: dayGrid.implicitHeight

            Grid {
                id: dayGrid
                columns: 7
                rowSpacing: 4
                columnSpacing: 4

                Repeater {
                    model: 42
                    delegate: DayCell {
                        required property int index

                        readonly property int dayNum: index - calendarService.firstWeekdayOffset + 1
                        readonly property bool validDay: dayNum >= 1 && dayNum <= calendarService.daysInMonth

                        dayNumber: dayNum
                        inMonth: validDay
                        selected: validDay && calendarService.selectedDateKey === calendarService.dayKey(calendarService.viewYear, calendarService.viewMonth, dayNum)
                        isToday: validDay && calendarService.isToday(calendarService.viewYear, calendarService.viewMonth, dayNum)
                        isPast: validDay && calendarService.isPast(calendarService.viewYear, calendarService.viewMonth, dayNum)

                        onClicked: calendarService.selectDay(dayNum)
                    }
                }
            }
        }
    }
}
