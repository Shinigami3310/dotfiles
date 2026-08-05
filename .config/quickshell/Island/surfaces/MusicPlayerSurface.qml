import "../core"
import "../features/MusicPlayer"

SurfaceBase {
    id: root
    surfaceName: "musicPlayer"
    implicitWidth: music.implicitWidth
    implicitHeight: music.implicitHeight
    MusicPlayer {
        id: music
        onCloseRequested: root.closeRequested()
    }
}
