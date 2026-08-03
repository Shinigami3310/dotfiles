import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services/integrations"

Rectangle {
    id: root

    width: 340
    implicitHeight: mainLayout.implicitHeight + (mainLayout.anchors.margins * 2)
    implicitWidth: 340

    color: Theme.surface
    radius: 16

    border.color: Theme.panelBorder
    border.width: 1

    signal closeRequested

    focus: true

    Component.onCompleted: {
        MusicPlayerService.wake();
    }

    Keys.onSpacePressed: event => {
        controls.triggerPlay();
        event.accepted = true;
    }
    Keys.onLeftPressed: event => {
        controls.triggerPrevious();
        event.accepted = true;
    }
    Keys.onRightPressed: event => {
        controls.triggerNext();
        event.accepted = true;
    }

    ColumnLayout {
        id: mainLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 16
        spacing: 10

        MusicPlayerHeader {
            Layout.fillWidth: true
        }

        MusicPlayerSlider {
            Layout.fillWidth: true
        }

        MusicPlayerControls {
            id: controls
            Layout.fillWidth: true
            onCloseRequested: root.closeRequested()
        }

        MusicPlayerMenu {
            Layout.fillWidth: true
        }
    }
}
