pragma Singleton

import QtQuick
import "."
import "../shared/theme"
import "../theme"

QtObject {
    id: root

    property var contentRootItem: null
    property var fadeAnimation: null
    property var enterAnimation: null

    property int currentIndex: 0

    property bool _isClosing: false
    property bool _navLocked: false

    Component.onCompleted: ThemeApplier.applied.connect(root.onApplied);

    function onApplied() {
        root.close();
    }

    function open() {
        root._isClosing = false;
        root.contentRootItem.forceActiveFocus();
        root.enterAnimation.start();
    }

    function close() {
        root._isClosing = true;
        Qt.quit();
    }

    function fadeOut(applyTheme) {
        if (root._isClosing)
            return;
        root._isClosing = true;
        root.fadeAnimation.applyTheme = applyTheme;
        root.fadeAnimation.start();
    }

    function onFadeFinished(applyTheme) {
        if (!applyTheme) {
            root.close();
            return;
        }
        ThemeApplier.apply(WallpaperService.wallpapers[root.currentIndex]);
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
