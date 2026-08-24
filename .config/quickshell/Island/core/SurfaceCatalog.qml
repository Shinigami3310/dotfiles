import QtQuick
import "../core"
import "../surfaces"

import "../features/AppLauncher"
import "../features/Bar"
import "../features/Battery"
import "../features/Calendar"
import "../features/ControlPanel"
import "../features/Eye"
import "../features/HomeClock"
import "../features/MusicPlayer"
import "../features/Selectors/"
import "../features/Sliders/"
import "../features/Strip/"

QtObject {
    readonly property Component appLauncher: Surface { feature: AppLauncher {} }
    readonly property Component bar: Surface { feature: Bar {} }
    readonly property Component batteryProfile: Surface { feature: Battery {} }
    readonly property Component bluetoothSelector: Surface { feature: BluetoothSelector {} }
    readonly property Component brightnessSlider: Surface { feature: Brightness {} }
    readonly property Component calendar: Surface { feature: Calendar {} }
    readonly property Component controlPanel: Surface { feature: ControlPanel {} }
    readonly property Component eyeReminder: Surface {
        feature: Eye {}
        canGoBack: false
    }
    readonly property Component homeClock: Surface {
        feature: HomeClock {}
        backTarget: SurfaceNames.strip
    }
    readonly property Component musicPlayer: Surface { feature: MusicPlayer {} }
    readonly property Component strip: Surface {
        feature: Strip {}
        canGoBack: false
    }
    readonly property Component volumeSlider: Surface { feature: Volume {} }
    readonly property Component wifiSelector: Surface { feature: WifiSelector {} }
}
