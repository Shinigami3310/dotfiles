import QtQuick
import "../shared/theme"

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
            duration: Motion.durationMorph
        }
        NumberAnimation {
            property: "y"
            from: root.addOffset
            duration: Motion.durationMorph
            easing.type: Motion.curveMoveIn
        }
    }

    remove: Transition {
        NumberAnimation {
            property: "opacity"
            to: 0
            duration: Motion.durationMorph
        }
    }

    addDisplaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: Motion.durationMorph
            easing.type: Motion.curveMoveIn
        }
    }

    displaced: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: Motion.durationStandard
            easing.type: Motion.curveMoveIn
        }
    }
}
