import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    implicitWidth: layout.implicitWidth + (CalendarConfig.paddingX * 2)
    implicitHeight: layout.implicitHeight + (CalendarConfig.paddingY * 2)

    Column {
        id: layout
        anchors.centerIn: parent
        spacing: CalendarConfig.layoutSpacing

        MonthHeader {
            id: header
            onMonthChanged: monthFadeAnim.restart()
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

            // Fade-анимация грида при смене месяца (запускается из MonthHeader).
            NumberAnimation on opacity {
                id: monthFadeAnim
                from: 0
                to: 1
                duration: Motion.morph
                easing.type: Easing.InOutQuad
            }

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