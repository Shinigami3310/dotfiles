pragma Singleton
import QtQuick
import QtCore
import "../shared/theme"
import "MusicPlayer"

// Оркестратор музыкального плеера: состояние навигации + связка
// MpvEngine (mpv-процесс) и PlaylistRepository (сканирование папок).
// Вся низкоуровневая работа с mpv и FolderListModel — в MusicPlayer/.
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

    // Каталог музыки; при отсутствии системного каталога — fallback ~/Music.
    readonly property string musicDir: {
        const locations = StandardPaths.standardLocations(StandardPaths.MusicLocation);
        return (locations && locations.length > 0 && locations[0])
            ? locations[0]
            : (SharedPaths.homeDir + "/Music");
    }

    readonly property string currentPlaylistName: playlists[playlistIndex] ?? "No playlists"
    readonly property string currentTrackDisplay: tracks[trackIndex]?.cleanName ?? "No track"
    readonly property string socketPath: ServiceConfig.mpvSocketPath

    // MpvEngine инкапсулирует процессы; флаг _explicitStop — внутри него.
    readonly property MpvEngine engine: MpvEngine {
        socketPath: root.socketPath

        // Естественный конец трека (exitCode == 0 && isPlaying) → автопереход.
        onExited: root.next()
    }

    // PlaylistRepository сканирует папки и треки.
    readonly property PlaylistRepository repository: PlaylistRepository {
        active: root.active
        musicDir: root.musicDir
        selectedFolder: root.selectedFolder

        onPlaylistsReady: list => root.playlists = list
        onTracksReady: list => {
            root.tracks = list;
            if (list.length > 0 && root.trackIndex === 0 && !root.isPlaylistMode) {
                root.playCurrent();
            }
        }
    }

    // ---- Жизненный цикл ----

    function wakeUp() {
        active = true;
        if (!tracks.length && !isPlaying) {
            isPlaylistMode = true;
        }
    }

    function sleep() {
        active = false;
        isPlaying = false;
        engine.stopProcess();

        isPlaylistMode = true;
        tracks = [];
        selectedFolder = "";
        trackIndex = 0;
    }

    // ---- Управление воспроизведением ----

    function playStop() {
        if (!tracks.length)
            return;

        if (engine.isRunning) {
            engine.cyclePause();
            isPlaying = engine.isPlaying;
        } else {
            playCurrent();
        }
    }

    // Проиграть текущий трек индекса (без аргумента — текущий).
    function playCurrent() {
        if (!tracks.length || trackIndex < 0 || trackIndex >= tracks.length)
            return;

        // Полагаемся на filePath из FolderListModel (URL вида file://...).
        // decodeURIComponent может бросить исключение на «битых» путях —
        // поэтому защищаемся try/catch и не прерываем воспроизведение.
        let path;
        try {
            path = decodeURIComponent(tracks[trackIndex].filePath.replace(/^file:\/\//, ""));
        } catch (e) {
            console.warn(`[MusicPlayerService] Не удалось декодировать путь трека: ${e}`);
            return;
        }

        engine.playTrack(path);
        isPlaying = engine.isPlaying;
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

    // ---- Выбор плейлиста ----

    function confirmSelection() {
        if (!isPlaylistMode || !playlists[playlistIndex])
            return;

        engine.stopProcess();

        selectedFolder = `${musicDir}/${playlists[playlistIndex]}`;
        trackIndex = 0;
        isPlaylistMode = false;
    }

    function cancelSelection() {
        if (isPlaylistMode && tracks.length > 0) {
            isPlaylistMode = false;
        }
    }

    // ---- Внутренняя навигация ----

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
            playCurrent();
        }
    }
}