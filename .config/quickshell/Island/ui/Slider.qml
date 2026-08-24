import QtQuick
import QtQuick.Layouts
import "../shared/theme"

RowLayout {
    id: root

    property real value: 0.0
    property real step: 0.05
    property string iconName: ""
    property string mutedIconName: iconName
    property bool muted: false
    property bool interactiveIcon: false
    property real trackWidth: UiConfig.sliderTrackDefaultWidth
    property real trackHeight: UiConfig.sliderTrackHeight
    property real iconBoxSize: UiConfig.sliderIconBoxSize
    property real textWidth: UiConfig.sliderTextWidth
    property real textSize: UiConfig.sliderTextSize

    readonly property real clampedValue: Math.max(0.0, Math.min(1.0, root.value))
    property real visualValue: clampedValue

    signal sliderMoved(real newValue)
    signal iconClicked

    implicitWidth: trackWidth + iconBoxSize + textWidth + (spacing * 2)
    spacing: 12

    Behavior on visualValue {
        enabled: !track.pressed
        NumberAnimation {
            duration: Motion.durationMicro
            easing.type: Motion.curveContinuous
        }
    }

    Item {
        id: iconBox
        Layout.preferredWidth: iconBoxSize
        Layout.preferredHeight: iconBoxSize
        Layout.alignment: Qt.AlignVCenter

        SliderIcon {
            id: icon
            anchors.fill: parent
            interactive: root.interactiveIcon
            muted: root.muted
            iconName: root.muted && root.mutedIconName !== "" ? root.mutedIconName : root.iconName
            onClicked: root.iconClicked()
        }
    }

    SliderTrack {
        id: track
        Layout.preferredWidth: root.trackWidth > 0 ? root.trackWidth : 0
        Layout.fillWidth: root.trackWidth <= 0
        Layout.alignment: Qt.AlignVCenter
        value: root.visualValue
        muted: root.muted
        trackHeight: root.trackHeight
        step: root.step
        onSliderMoved: newValue => root.sliderMoved(newValue)
    }

    SliderValueText {
        Layout.alignment: Qt.AlignVCenter
        value: root.clampedValue
        muted: root.muted
        textWidth: root.textWidth
        textSize: root.textSize
    }
}
