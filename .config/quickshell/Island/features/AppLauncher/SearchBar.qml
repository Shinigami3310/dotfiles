import QtQuick
import "../../theme"

FocusScope {
    id: root

    implicitHeight: AppLauncherConfig.searchBarHeight
    focus: true

    property alias text: input.text

    signal upPressed
    signal downPressed
    signal enterPressed
    signal escapePressed

    function forceFocus() {
        input.forceActiveFocus();
    }

    Rectangle {
        anchors.fill: parent
        radius: AppLauncherConfig.searchBarRadius
        color: ThemeColor.surface
        border {
            color: input.activeFocus ? ThemeColor.primary : "transparent"
            width: AppLauncherConfig.searchBarBorderWidth
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeStandard
            }
        }

        Row {
            anchors {
                fill: parent
                leftMargin: AppLauncherConfig.searchBarHorizontalPadding
                rightMargin: AppLauncherConfig.searchBarHorizontalPadding
            }
            spacing: AppLauncherConfig.searchBarSpacing

            Text {
                id: searchIcon
                anchors.verticalCenter: parent.verticalCenter
                text: "🔍"
                font.pixelSize: AppLauncherConfig.searchIconSize
                color: input.activeFocus ? ThemeColor.primary : ThemeColor.on_surface
            }

            TextInput {
                id: input
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - searchIcon.width - parent.spacing
                focus: true
                clip: true

                font {
                    family: Theme.font
                    pixelSize: AppLauncherConfig.searchInputSize
                }
                color: ThemeColor.on_surface
                selectionColor: ThemeColor.primary
                selectedTextColor: ThemeColor.on_primary

                Keys.onUpPressed: root.upPressed()
                Keys.onDownPressed: root.downPressed()
                Keys.onReturnPressed: root.enterPressed()
                Keys.onEscapePressed: {
                    if (input.text !== "")
                        input.text = "";
                    else
                        root.escapePressed();
                }
            }
        }
    }
}
