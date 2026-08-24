import QtQuick
import "../../shared/theme"
import "../../services"

Item {
    id: root

    signal monthChanged
    property alias transitionOpacity: monthTitleText.opacity

    width: CalendarConfig.headerWidth
    height: CalendarConfig.headerHeight

    SequentialAnimation {
        id: monthTransitionAnim
        property int delta: 0

        NumberAnimation {
            target: monthTitleText
            property: "opacity"
            to: 0
            duration: Motion.durationMorph
            easing.type: Motion.curveOpacityOut
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
            duration: Motion.durationMorph
            easing.type: Motion.curveOpacityIn
        }
    }

    function requestMonthChange(delta: int) {
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
