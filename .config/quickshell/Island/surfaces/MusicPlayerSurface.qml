import "../core"
import "../features/MusicPlayer"

SurfaceBase {
    surfaceName: "musicPlayer"
    implicitWidth: music.implicitWidth
    implicitHeight: music.implicitHeight
    MusicPlayer {
        id: music
        anchors.centerIn: parent
    }
}
