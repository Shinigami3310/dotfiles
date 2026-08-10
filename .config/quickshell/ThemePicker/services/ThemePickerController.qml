pragma Singleton

import QtQuick
import "."
import "../theme"

// ThemePicker controller: separates logic (navigation, lifecycle,
// theme application) from the declarative UI. The UI stays "dumb"
// and only calls controller methods.
//
// Convention: the UI owns the fade animation (visual effect) and calls
// onFadeFinished(applyTheme) when it completes. The controller decides what to do.
QtObject {
    id: root

    // Reference to the UI element that controls visible/opacity.
    // Assigned from ThemePicker.qml.
    property var view: null

    // Current carousel index. Carousel binds to this property.
    property int currentIndex: 0

    property bool _isClosing: false

    // Key auto-repeat: blocks re-navigation for 80ms so scrolling
    // stays slow and predictable.
    property bool _navLocked: false

    function open() {
        if (!root.view)
            return;
        root._isClosing = false;
        root.view.visible = true;
        // Reset opacity in case a previous fadeOut left it at 0.
        root.view.contentRootItem.opacity = 1;
        root.view.contentRootItem.forceActiveFocus();
    }

    function close() {
        if (!root.view)
            return;
        root._isClosing = true;
        root.view.visible = false;
        Qt.quit();
    }

    // Starts the fade-out. applyTheme=true — apply the theme after the animation.
    function fadeOut(applyTheme) {
        if (root._isClosing)
            return; // guard against double Enter/Esc
        root._isClosing = true;
        root.view.fadeAnimation.applyTheme = applyTheme;
        root.view.fadeAnimation.start();
    }

    // Called from the UI after the fade animation completes.
    function onFadeFinished(applyTheme) {
        if (applyTheme) {
            const wallpaper = WallpaperService.wallpapers[root.currentIndex];
            // Disconnect the old subscription before re-subscribing to avoid
            // accumulating callbacks on repeated opens (crash risk on destroyed object).
            ThemeApplier.applied.disconnect(root.close);
            ThemeApplier.applied.connect(root.close);
            ThemeApplier.apply(wallpaper);
        } else {
            root.close();
        }
    }

    function navigate(step) {
        if (root._isClosing || root._navLocked)
            return;
        const next = root.currentIndex + step;
        if (next < 0 || next >= WallpaperService.wallpapers.length)
            return;
        root.currentIndex = next;
        root._navLocked = true;
        navTimer.start();
    }

    property Timer navTimer: Timer {
        interval: Configs.navRepeatDelay
        repeat: false
        onTriggered: root._navLocked = false
    }
}
