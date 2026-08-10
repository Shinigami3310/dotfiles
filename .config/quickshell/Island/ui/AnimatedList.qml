import QtQuick
import "../shared/theme"

// Анимированный ListView. Переходы синхронизированы с Motion.morph, чтобы
// добавление/удаление элементов не «дёргало» список — иначе при частых
// обновлениях модели (Wi-Fi скан) список будет мигать.
ListView {
    id: root

    property real addOffset: -10

    clip: true
    boundsBehavior: Flickable.StopAtBounds

    add: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: Motion.morph
        }
        NumberAnimation {
            property: "y"
            from: root.addOffset
            duration: Motion.morph
            easing.type: Easing.OutQuart
        }
    }

    remove: Transition {
        NumberAnimation {
            property: "opacity"
            to: 0
            duration: Motion.morph
        }
    }

    addDisplaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: Motion.morph
            easing.type: Easing.OutQuart
        }
    }

    displaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: Motion.standard
            easing.type: Easing.OutQuart
        }
    }
}