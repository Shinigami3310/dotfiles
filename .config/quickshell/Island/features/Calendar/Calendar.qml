import QtQuick
import "../../theme"
import "../../services"

Item {
    id: root

    property int viewYear: CalendarService.today.getFullYear()
    property int viewMonth: CalendarService.today.getMonth()
    property string selectedDateKey: ""
    property bool transitioning: false

    readonly property int firstWeekdayOffset: (new Date(viewYear, viewMonth, 1).getDay() + 6) % 7
    readonly property int daysInMonth: new Date(viewYear, viewMonth + 1, 0).getDate()

    implicitWidth: contentColumn.implicitWidth + (Configs.calPaddingX * 2)
    implicitHeight: contentColumn.implicitHeight + (Configs.calPaddingY * 2)

    function resetView() {
        viewYear = CalendarService.today.getFullYear();
        viewMonth = CalendarService.today.getMonth();
        selectedDateKey = "";
    }

    function selectDay(day) {
        if (day >= 1 && day <= daysInMonth) {
            selectedDateKey = CalendarService.dayKey(viewYear, viewMonth, day);
        }
    }

    function changeMonth(delta) {
        if (transitioning)
            return;
        transitioning = true;
        transitionTimer.delta = delta;
        transitionTimer.start();
    }

    Timer {
        id: transitionTimer
        interval: Configs.calTransitionDuration
        property int delta: 0
        onTriggered: {
            let newMonth = root.viewMonth + delta;
            if (newMonth < 0) {
                root.viewMonth = 11;
                root.viewYear--;
            } else if (newMonth > 11) {
                root.viewMonth = 0;
                root.viewYear++;
            } else {
                root.viewMonth = newMonth;
            }
            root.selectedDateKey = "";
            root.transitioning = false;
        }
    }

    Column {
        id: contentColumn
        anchors.centerIn: parent
        spacing: 10

        // Заголовок (кнопки и месяц)
        Row {
            width: dayGrid.implicitWidth
            height: Configs.calHeaderHeight

            NavButton {
                text: "‹"
                onClicked: root.changeMonth(-1)
            }

            Text {
                width: parent.width - 44
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                text: CalendarService.monthTitle(root.viewYear, root.viewMonth)
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
                onClicked: root.changeMonth(1)
            }
        }

        // Дни недели
        Row {
            spacing: Configs.calGridGap
            Repeater {
                model: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
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

        // Сетка дней
        Item {
            id: monthFade
            implicitWidth: dayGrid.implicitWidth
            implicitHeight: dayGrid.implicitHeight

            // Декларативная привязка анимации исчезновения
            opacity: root.transitioning ? 0 : 1
            Behavior on opacity {
                NumberAnimation {
                    duration: Configs.calTransitionDuration
                    easing.type: Motion.easeStandard
                }
            }

            Grid {
                id: dayGrid
                columns: 7
                rowSpacing: Configs.calGridGap
                columnSpacing: Configs.calGridGap

                Repeater {
                    model: 42
                    delegate: DayCell {
                        required property int index

                        readonly property int dayNum: index - root.firstWeekdayOffset + 1

                        dayNumber: dayNum
                        inMonth: dayNum >= 1 && dayNum <= root.daysInMonth
                        selected: inMonth && root.selectedDateKey === CalendarService.dayKey(root.viewYear, root.viewMonth, dayNum)
                        isToday: inMonth && CalendarService.isToday(root.viewYear, root.viewMonth, dayNum)
                        isPast: inMonth && CalendarService.isPast(root.viewYear, root.viewMonth, dayNum)

                        onClicked: root.selectDay(dayNum)
                    }
                }
            }
        }
    }
}
