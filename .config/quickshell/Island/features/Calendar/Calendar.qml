import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    implicitWidth: layout.implicitWidth + (CalendarConfig.paddingX * 2)
    implicitHeight: layout.implicitHeight + (CalendarConfig.paddingY * 2)

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
            script: CalendarService.changeMonth(monthTransitionAnim.delta)
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
                text: CalendarService.monthTitle(CalendarService.viewYear, CalendarService.viewMonth)
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

                        readonly property int dayNum: index - CalendarService.firstWeekdayOffset + 1
                        readonly property bool validDay: dayNum >= 1 && dayNum <= CalendarService.daysInMonth

                        dayNumber: dayNum
                        inMonth: validDay
                        selected: validDay && CalendarService.selectedDateKey === CalendarService.dayKey(CalendarService.viewYear, CalendarService.viewMonth, dayNum)
                        isToday: validDay && CalendarService.isToday(CalendarService.viewYear, CalendarService.viewMonth, dayNum)
                        isPast: validDay && CalendarService.isPast(CalendarService.viewYear, CalendarService.viewMonth, dayNum)

                        onClicked: CalendarService.selectDay(dayNum)
                    }
                }
            }
        }
    }
}
