import QtQuick
import QtQuick.Effects
import "../../theme"

// Иконка слайдера. Fade-переключение нужно, чтобы резкая смена иконки
// (например Volume → VolumeMute) не «мигала» — плавность скрывает подмену.
Item {
    id: root

    property bool interactive: false
    property string iconName: ""
    property bool muted: false

    signal clicked

    property string displayedIcon: iconName

    SequentialAnimation {
        id: iconSwitchAnimation
        NumberAnimation {
            target: iconEffect
            property: "opacity"
            to: 0.0
            duration: Motion.morph
            easing.type: Motion.easeStandard
        }
        ScriptAction {
            script: root.displayedIcon = root.iconName
        }
        NumberAnimation {
            target: iconEffect
            property: "opacity"
            to: 1.0
            duration: Motion.morph
            easing.type: Motion.easeStandard
        }
    }

    Connections {
        target: root
        function onIconNameChanged() {
            if (iconEffect.opacity > 0) {
                iconSwitchAnimation.restart();
            } else {
                root.displayedIcon = root.iconName;
            }
        }
    }

    Image {
        id: iconImage
        anchors.fill: parent
        source: root.displayedIcon !== "" ? Paths.icon(root.displayedIcon) : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        sourceSize: Qt.size(width, height)
        visible: false
    }

    MultiEffect {
        id: iconEffect
        anchors.fill: iconImage
        source: iconImage
        colorization: 1.0
        colorizationColor: iconMouse.containsMouse ? ThemeColor.primary : ThemeColor.on_surface
        opacity: root.muted ? 0.5 : 1.0

        Behavior on colorizationColor {
            ColorAnimation {
                duration: Motion.fast
            }
        }
    }

    MouseArea {
        id: iconMouse
        anchors.fill: parent
        hoverEnabled: root.interactive
        enabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
    }
}