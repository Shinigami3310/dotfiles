import QtQuick
import QtQuick.Effects
import QtQuick.Window // Imported for Screen
import "../shared/theme"
import "../theme"

Item {
    id: root
    smooth: true

    property url source: ""
    property string label: ""

    signal activated

    implicitWidth: Configs.buttonWidth
    implicitHeight: Configs.buttonHeight

    activeFocusOnTab: true

    readonly property bool hovered: hoverHandler.hovered
    readonly property bool pressed: tapHandler.pressed
    readonly property bool isActive: root.activeFocus || root.pressed || root.hovered

    // Resolution tied to the screen (with DPI), not to the button size:
    // when the button scales (hover/press) the icon stays sharp.
    readonly property real _effectiveSourceSize: Math.ceil(Math.max(Screen.width * Screen.devicePixelRatio, 1))

    function targetScale() {
        if (pressed) return Configs.scalePressed;
        if (hovered || activeFocus) return Configs.scaleHover;
        return 1.0;
    }

    scale: targetScale()

    Behavior on scale {
        NumberAnimation {
            duration: Motion.fast
            easing.type: Motion.easeOutCubic
        }
    }

    Rectangle {
        id: cardBody
        anchors.centerIn: parent
        width: Configs.buttonBodySize
        height: Configs.buttonBodySize
        radius: Configs.buttonRadius
        antialiasing: true

        readonly property color baseColor: root.isActive ? ThemeColor.surface_container_high : ThemeColor.surface_container
        color: Qt.alpha(baseColor, Configs.buttonAlpha)

        border.width: root.isActive ? Configs.buttonBorderWidthActive : Configs.buttonBorderWidth
        border.color: (root.pressed || root.activeFocus) ? ThemeColor.primary : ThemeColor.outline_variant

        Behavior on color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeOutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: Motion.fast
                easing.type: Motion.easeOutCubic
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: Configs.buttonSpacing

            // Wrapper reserves layout space; the Image stays hidden but
            // MultiEffect samples it. Without this wrapper the Column
            // would collapse and the icon would overlap the label.
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Configs.buttonIconSize
                height: Configs.buttonIconSize

                Image {
                    id: iconImage
                    anchors.fill: parent
                    source: root.source
                    visible: false
                    asynchronous: true
                    cache: true
                    smooth: true
                    mipmap: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: root._effectiveSourceSize
                    sourceSize.height: root._effectiveSourceSize

                    // Hide the icon if the source is empty or fails to load,
                    // so a broken file does not show a blank/error placeholder.
                    onStatusChanged: {
                        if (status === Image.Error)
                            visible = false;
                    }
                }

                MultiEffect {
                    anchors.fill: parent
                    source: iconImage
                    colorization: 1.0
                    colorizationColor: root.isActive ? ThemeColor.primary : ThemeColor.on_surface

                    paddingRect: Qt.rect(0, 0, width, height)
                    autoPaddingEnabled: false

                    // Render at 2x so the button's hover/press scale transform
                    // doesn't rasterize the icon (matches test/WallpaperCard pattern).
                    layer.enabled: true
                    layer.textureSize: Qt.size(Configs.buttonIconSize * 2, Configs.buttonIconSize * 2)
                    layer.smooth: true

                    Behavior on colorizationColor {
                        ColorAnimation {
                            duration: Motion.fast
                            easing.type: Motion.easeOutCubic
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.label
                color: root.isActive ? ThemeColor.primary : ThemeColor.on_surface
                font.pixelSize: Configs.buttonFontSize
                font.weight: Font.Medium
                font.family: Configs.buttonFontFamily

                Behavior on color {
                    ColorAnimation {
                        duration: Motion.fast
                        easing.type: Motion.easeOutCubic
                    }
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.activated();
            event.accepted = true;
        }
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton
        onTapped: root.activated()
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }
}