import QtQuick
import "../../theme"
import "../../services"

// Шапка календаря: кнопки навигации по месяцам + заголовок месяца.
// Анимирует только заголовок (fade); грид дней анимируется в Calendar.qml.
Item {
    id: root

    signal monthChanged

    width: CalendarConfig.headerWidth
    height: CalendarConfig.headerHeight

    SequentialAnimation {
        id: monthTransitionAnim
        property int delta: 0

        NumberAnimation {
            target: monthTitleText
            property: "opacity"
            to: 0
            duration: Motion.morph
            easing.type: Easing.InOutQuad
        }

        ScriptAction {
            script: {
                CalendarService.changeMonth(monthTransitionAnim.delta);
                root.monthChanged();
            }
        }

        NumberAnimation {
            target: monthTitleText
            property: "opacity"
            to: 1
            duration: Motion.morph
            easing.type: Easing.InOutQuad
        }
    }

    function requestMonthChange(delta) {
        if (!monthTransitionAnim.running) {
            monthTransitionAnim.delta = delta;
            monthTransitionAnim.start();
        }
    }

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