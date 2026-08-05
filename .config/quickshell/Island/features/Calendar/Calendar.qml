import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    implicitWidth: layout.implicitWidth + (CalendarConfig.paddingX * 2)
    implicitHeight: layout.implicitHeight + (CalendarConfig.paddingY * 2)

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
        id: layout
        anchors.centerIn: parent
        spacing: CalendarConfig.layoutSpacing

        Item {
            width: dayGrid.implicitWidth
            height: CalendarConfig.headerHeight

            NavButton {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                text: "‹"
                onClicked: root.requestMonthChange(-1)
            }

            Text {
                id: monthTitleText
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                text: calendarService.monthTitle(calendarService.viewYear, calendarService.viewMonth)
                renderType: Text.NativeRendering
                font {
                    family: Theme.font
                    pixelSize: CalendarConfig.titleTextSize
                    weight: Font.Normal
                }
                color: ThemeColor.on_surface
                elide: Text.ElideRight
            }

            NavButton {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                text: "›"
                onClicked: root.requestMonthChange(1)
            }
        }

        Row {
            spacing: CalendarConfig.weekdaySpacing
            Repeater {
                model: CalendarConfig.daysOfWeek
                delegate: Text {
                    width: CalendarConfig.weekdayCellWidth
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font {
                        family: Theme.font
                        pixelSize: CalendarConfig.weekdayTextSize
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
                columns: CalendarConfig.gridColumns
                rowSpacing: CalendarConfig.gridRowSpacing
                columnSpacing: CalendarConfig.gridColumnSpacing

                Repeater {
                    model: CalendarConfig.totalCells
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
