import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    implicitWidth: contentColumn.implicitWidth + (Configs.calPaddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (Configs.calPaddingY * 2)

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
                duration: Configs.calTransitionDuration / 2
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: monthTitleText
                property: "opacity"
                to: 0
                duration: Configs.calTransitionDuration / 2
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
                duration: Configs.calTransitionDuration / 2
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: monthTitleText
                property: "opacity"
                to: 1
                duration: Configs.calTransitionDuration / 2
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
            height: Configs.calHeaderHeight

            NavButton {
                text: "‹"
                onClicked: root.requestMonthChange(-1)
            }

            Text {
                id: monthTitleText
                width: parent.width - (Configs.calNavButtonSize * 2)
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                text: calendarService.monthTitle(calendarService.viewYear, calendarService.viewMonth)
                font {
                    family: Theme.font
                    pixelSize: Configs.calTitleSize
                    weight: Font.DemiBold
                }
                color: Theme.text
                elide: Text.ElideRight
            }

            NavButton {
                text: "›"
                onClicked: root.requestMonthChange(1)
            }
        }

        Row {
            spacing: Configs.calGridGap
            Repeater {
                model: Configs.calWeekdays
                delegate: Text {
                    width: Configs.calCellSize
                    horizontalAlignment: Text.AlignHCenter
                    text: modelData
                    font {
                        family: Theme.font
                        pixelSize: Configs.calWeekdaySize
                        weight: Font.DemiBold
                    }
                    color: Theme.textMuted
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
                rowSpacing: Configs.calGridGap
                columnSpacing: Configs.calGridGap

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
