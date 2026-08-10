pragma Singleton
import QtQuick
import QtCore
import Qt.labs.folderlistmodel
import Quickshell.Io

QtObject {
    id: root

    property bool active: false
    property bool isPlaylistMode: true
    property bool isPlaying: false

    property int playlistIndex: 0
    property int trackIndex: 0

    property var playlists: []
    property var tracks: []
    property string selectedFolder: ""

    readonly property string musicDir: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string currentPlaylistName: playlists[playlistIndex] ?? "No playlists"
    readonly property string currentTrackDisplay: tracks[trackIndex]?.cleanName ?? "No track"
    readonly property string socketPath: ServiceConfig.mpvSocketPath

    property bool _explicitStop: false

    function wakeUp() {
        active = true;
        if (!tracks.length && !isPlaying) {
            isPlaylistMode = true;
        }
    }

    function sleep() {
        active = false;
        isPlaying = false;

        if (mpvProcess.running) {
            _explicitStop = true;
            mpvProcess.running = false;
        }

        isPlaylistMode = true;
        tracks = [];
        selectedFolder = "";
        trackIndex = 0;
    }

    function playStop() {
        if (!tracks.length)
            return;

        if (mpvProcess.running) {
            if (!mpvCommand.running) {
                // socketPath — фиксированная константа, не пользовательский ввод,
                // поэтому конкатенация безопасна.
                mpvCommand.command = ["sh", "-c", `echo 'cycle pause' | socat - ${socketPath}`];
                mpvCommand.running = true;
                isPlaying = !isPlaying;
            }
        } else {
            _playCurrentTrack();
        }
    }

    function togglePlaylistMode() {
        isPlaylistMode = true;
    }

    function next() {
        _navigate(1);
    }
    function previous() {
        _navigate(-1);
    }

    function confirmSelection() {
        if (!isPlaylistMode || !playlists[playlistIndex])
            return;

        if (mpvProcess.running) {
            _explicitStop = true;
            mpvProcess.running = false;
        }

        selectedFolder = `${musicDir}/${playlists[playlistIndex]}`;
        trackIndex = 0;
        isPlaylistMode = false;
    }

    function cancelSelection() {
        if (isPlaylistMode && tracks.length > 0) {
            isPlaylistMode = false;
        }
    }

    function _navigate(step: int) {
        const list = isPlaylistMode ? playlists : tracks;
        if (!list.length)
            return;

        const currentIndex = isPlaylistMode ? playlistIndex : trackIndex;
        const newIndex = (currentIndex + step + list.length) % list.length;

        if (isPlaylistMode) {
            playlistIndex = newIndex;
        } else {
            trackIndex = newIndex;
            _playCurrentTrack();
        }
    }

    function _playCurrentTrack() {
        if (!tracks.length || trackIndex < 0 || trackIndex >= tracks.length)
            return;

        const safePath = decodeURIComponent(tracks[trackIndex].filePath.replace(/^file:\/\//, ""));

        if (mpvProcess.running) {
            root._explicitStop = true;
            mpvProcess.running = false;
        }

        mpvProcess.command = ["mpv", "--no-video", "--no-terminal", `--input-ipc-server=${socketPath}`, "--", safePath];
        mpvProcess.running = true;
        isPlaying = true;
    }

    readonly property Process mpvProcess: Process {
        onExited: exitCode => {
            if (root._explicitStop) {
                root._explicitStop = false;
                return;
            }

            if (root.isPlaying && exitCode === 0) {
                root.next();
            } else {
                if (exitCode !== 0)
                    console.warn(`[MusicPlayerService] mpv завершился с кодом ${exitCode}`);
                root.isPlaying = false;
            }
        }
    }

    readonly property Process mpvCommand: Process {}

    readonly property FolderListModel playlistScanner: FolderListModel {
        folder: root.active ? root.musicDir : ""
        showFiles: false
        showDirs: true
        showDotAndDotDot: false

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                const list = new Array(count);
                for (let i = 0; i < count; i++) {
                    list[i] = get(i, "fileName");
                }
                root.playlists = list;
            }
        }
    }

    readonly property FolderListModel trackScanner: FolderListModel {
        folder: (root.active && root.selectedFolder) ? root.selectedFolder : ""
        showDirs: false
        showDotAndDotDot: false
        nameFilters: ["*.mp3", "*.wav", "*.flac"]
        sortField: FolderListModel.Name

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                const list = new Array(count);
                for (let i = 0; i < count; i++) {
                    const fileName = get(i, "fileName");
                    const dotIdx = fileName.lastIndexOf('.');

                    list[i] = {
                        fileName: fileName,
                        cleanName: dotIdx > 0 ? fileName.substring(0, dotIdx) : fileName,
                        filePath: String(get(i, "filePath"))
                    };
                }
                root.tracks = list;

                if (list.length > 0 && root.trackIndex === 0 && !root.isPlaylistMode) {
                    root._playCurrentTrack();
                }
            }
        }
    }
}
