pragma Singleton

import QtQuick
import "."
import "../theme"

// Контроллер ThemePicker: отделяет логику (навигация, жизненный цикл,
// применение темы) от декларативного UI. UI остаётся «глупым» и вызывает
// только методы контроллера.
//
// Соглашение: UI владеет fade-анимацией (визуальный эффект) и после её
// завершения зовёт onFadeFinished(applyTheme). Контроллер решает, что делать.
QtObject {
    id: root

    // Ссылка на UI-элемент, который управляет visible/opacity.
    // Назначается из ThemePicker.qml (property var view).
    property var view: null

    // Текущий индекс карусели. Carousel биндится на это свойство.
    property int currentIndex: 0

    property bool _isClosing: false

    // Автоповтор при зажатой клавише: блокирует повторную навигацию на 80мс,
    // чтобы листание было медленным и предсказуемым.
    property bool _navLocked: false

    function open() {
        if (!root.view)
            return;
        root._isClosing = false;
        root.view.visible = true;
        // Сбрасываем opacity на случай, если прошлый fadeOut оставил её в 0.
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

    // Запускает fade-out. applyTheme=true — после анимации применить тему.
    function fadeOut(applyTheme) {
        if (root._isClosing)
            return; // защита от двойного Enter/Esc
        root._isClosing = true;
        root.view.fadeAnimation.applyTheme = applyTheme;
        root.view.fadeAnimation.start();
    }

    // Вызывается из UI после завершения fade-анимации.
    function onFadeFinished(applyTheme) {
        if (applyTheme) {
            const wallpaper = WallpaperService.wallpapers[root.currentIndex];
            ThemeApplier.applied.connect(() => root.close());
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