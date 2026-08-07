pragma Singleton
import QtQuick

QtObject {
    readonly property string locale: "en_US"

    readonly property int paddingX: 20
    readonly property int paddingY: 16
    readonly property int layoutSpacing: 10

    readonly property int headerHeight: 28
    readonly property int headerNavMargin: 24
    readonly property int titleTextSize: 14

    readonly property int weekdaySpacing: 4
    readonly property int weekdayCellWidth: 30
    readonly property int weekdayTextSize: 12
    readonly property var daysOfWeek: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

    readonly property int gridColumns: 7
    readonly property int gridRowSpacing: 4
    readonly property int gridColumnSpacing: 4
    readonly property int totalCells: 42

    readonly property int cellSize: 30
    readonly property int cellRadius: 8
    readonly property int cellBorderWidth: 1
    readonly property int cellTextSize: 12
    readonly property real pastDayOpacity: 0.5

    readonly property int navBtnSize: 20
    readonly property int navBtnTextSize: 20
    readonly property real navBtnHoverScale: 1.2
}
