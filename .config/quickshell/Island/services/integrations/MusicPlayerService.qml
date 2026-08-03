pragma Singleton
import QtQml
import QtMultimedia
import QtCore
import Qt.labs.folderlistmodel

QtObject {
    id: root

    readonly property string musicRootPath: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string coversPath: musicRootPath + "/Cover"

    // ==========================================
    // СОСТОЯНИЕ ПЛЕЕРА И ПЛЕЙЛИСТОВ
    // ==========================================
    property var playlistNames: []
    property string currentPlaylistName: ""
    property var playlist: []
    property int currentIndex: -1

    property bool isSleeping: false
    property bool pendingPlay: false

    // ==========================================
    // ДАННЫЕ UI (ДЛЯ БИНДИНГОВ)
    // ==========================================
    property string trackTitle: "Playlist empty"
    property string trackArtist: ""
    property string trackCover: ""

    // ==========================================
    // АЛИАСЫ СОСТОЯНИЯ
    // ==========================================
    readonly property alias currentTrackUrl: mediaPlayer.source
    readonly property alias duration: mediaPlayer.duration
    readonly property alias position: mediaPlayer.position
    readonly property alias playbackState: mediaPlayer.playbackState
    readonly property bool isPlaying: playbackState === MediaPlayer.PlayingState
    property alias repeatTrack: appSettings.repeatTrack

    // ==========================================
    // КОМПОНЕНТЫ
    // ==========================================
    property Settings appSettings: Settings {
        id: appSettings
        category: "MusicPlayer"
        location: "Config.ini"
        property string currentPlaylistName: ""
        property string currentTrack: ""
        property bool repeatTrack: false
    }

    property MediaDevices mediaDevices: MediaDevices {
        id: mediaDevices
        onAudioOutputsChanged: audioOutput.device = mediaDevices.defaultAudioOutput
    }

    property MediaPlayer mediaPlayer: MediaPlayer {
        id: mediaPlayer

        audioOutput: AudioOutput {
            id: audioOutput
            volume: 1.0
            device: mediaDevices.defaultAudioOutput
        }

        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia) {
                root.repeatTrack ? (root.seek(0), root.play()) : root.next();
            }
        }

        onMetaDataChanged: {
            if (root.isSleeping)
                return;

            const meta = mediaPlayer.metaData;
            const currentItem = root.playlist[root.currentIndex] || {};

            // Исполнитель может лежать в разных ключах в зависимости от бэкенда (GStreamer)
            let metaAuthor = meta.stringValue(MediaMetaData.Author) || meta.stringValue(MediaMetaData.LeadPerformer) || meta.stringValue(MediaMetaData.ContributingArtist);

            root.trackTitle = meta.stringValue(MediaMetaData.Title) || currentItem.name || (root.playlist.length ? "Unknown Track" : "Playlist empty");

            root.trackArtist = metaAuthor || currentItem.artist || "";

            root.trackCover = currentItem.originalName ? (root.coversPath + "/" + currentItem.originalName + ".png") : "";
        }
    }

    // ==========================================
    // ФАЙЛОВЫЕ МОДЕЛИ
    // ==========================================
    property FolderListModel playlistsModel: FolderListModel {
        id: playlistsModel
        folder: root.isSleeping ? "" : root.musicRootPath
        showDirs: true
        showFiles: false
        showDotAndDotDot: false

        onStatusChanged: {
            if (status === FolderListModel.Ready && !root.isSleeping) {
                let names = [];
                for (let i = 0; i < count; i++) {
                    const dirName = get(i, "fileName");
                    if (dirName !== "Cover")
                        names.push(dirName);
                }
                root.playlistNames = names;

                const saved = appSettings.currentPlaylistName;
                root.currentPlaylistName = names.includes(saved) ? saved : (names.length ? names[0] : "");
                appSettings.currentPlaylistName = root.currentPlaylistName;

                tracksModel.folder = root.currentPlaylistName ? (root.musicRootPath + "/" + root.currentPlaylistName) : "";
            }
        }
    }

    property FolderListModel tracksModel: FolderListModel {
        id: tracksModel
        showDirs: false
        showFiles: true
        nameFilters: ["*.mp3", "*.flac", "*.wav", "*.m4a", "*.ogg"]

        onStatusChanged: {
            if (status === FolderListModel.Ready && !root.isSleeping) {
                let items = [];
                for (let i = 0; i < count; i++) {
                    const fileName = get(i, "fileName");
                    const lastDot = fileName.lastIndexOf('.');
                    const baseName = lastDot > 0 ? fileName.substring(0, lastDot) : fileName;

                    items.push({
                        path: get(i, "fileUrl").toString(),
                        originalName: baseName,
                        artist: ""      // артист берётся только из метаданных
                        ,
                        name: baseName
                    });
                }

                root.playlist = items;

                if (root.pendingPlay && root.playlist.length > 0) {
                    root.pendingPlay = false;
                    root.play();
                } else if (items.length > 0) {
                    const idx = items.findIndex(t => t.path === appSettings.currentTrack);
                    root.loadTrack(Math.max(0, idx), false);
                } else {
                    root.clearPlayer();
                }
            }
        }
    }

    // ==========================================
    // ЛОГИКА СНА (ЭКОНОМИЯ РЕСУРСОВ)
    // ==========================================
    function sleep() {
        if (isSleeping)
            return;
        stop();
        mediaPlayer.source = "";
        playlistsModel.folder = "";
        tracksModel.folder = "";
        isSleeping = true;
    }

    function wake() {
        if (!isSleeping)
            return;
        isSleeping = false;
        playlistsModel.folder = musicRootPath;
        if (currentPlaylistName) {
            tracksModel.folder = musicRootPath + "/" + currentPlaylistName;
        }
    }

    function toggleSleep() {
        isSleeping ? wake() : sleep();
    }

    // ==========================================
    // УПРАВЛЕНИЕ ВОСПРОИЗВЕДЕНИЕМ
    // ==========================================
    function play() {
        if (isSleeping)
            wake();
        if (!playlist.length) {
            pendingPlay = true;
            return;
        }
        pendingPlay = false;

        if (currentIndex === -1)
            loadTrack(0, false);
        mediaPlayer.play();
    }

    function pause() {
        mediaPlayer.pause();
    }

    function togglePlay() {
        isPlaying ? pause() : play();
    }

    function stop() {
        mediaPlayer.stop();
    }

    function next() {
        if (isSleeping)
            wake();
        if (!playlist.length) {
            pendingPlay = true;
            return;
        }
        pendingPlay = false;

        const nextIdx = (currentIndex + 1) % playlist.length;
        playlist.length === 1 ? (seek(0), play()) : loadTrack(nextIdx, true);
    }

    function previous() {
        if (isSleeping)
            wake();
        if (!playlist.length) {
            pendingPlay = true;
            return;
        }
        pendingPlay = false;

        const prevIdx = (currentIndex - 1 + playlist.length) % playlist.length;
        playlist.length === 1 ? (seek(0), play()) : loadTrack(prevIdx, true);
    }

    function toggleRepeat() {
        appSettings.repeatTrack = !appSettings.repeatTrack;
    }

    function setPlaylist(name, autoPlay = false) {
        if (isSleeping)
            wake();
        if (!playlistNames.includes(name))
            return;
        stop();
        appSettings.currentPlaylistName = name;
        currentPlaylistName = name;
        tracksModel.folder = musicRootPath + "/" + name;

        if (autoPlay) {
            if (tracksModel.status === FolderListModel.Ready) {
                play();
            } else {
                pendingPlay = true;
            }
        }
    }

    function loadTrack(index, autoPlay = true) {
        if (isSleeping)
            wake();
        if (index < 0 || index >= playlist.length) {
            stop();
            return;
        }

        if (currentIndex !== index || mediaPlayer.source !== playlist[index].path) {
            mediaPlayer.stop();
        }

        currentIndex = index;
        const item = playlist[index];

        trackTitle = item.name;
        trackArtist = item.artist;
        trackCover = coversPath + "/" + item.originalName + ".png";

        appSettings.currentTrack = item.path;
        mediaPlayer.source = item.path;

        if (autoPlay)
            mediaPlayer.play();
    }

    function clearPlayer() {
        mediaPlayer.source = "";
        currentIndex = -1;
        trackTitle = "Playlist empty";
        trackArtist = "";
        trackCover = "";
    }

    // ==========================================
    // УТИЛИТЫ
    // ==========================================
    function seek(ms) {
        if (isSleeping)
            return;
        mediaPlayer.position = Math.max(0, Math.min(ms, mediaPlayer.duration));
    }

    function formatTime(ms) {
        if (isNaN(ms) || ms <= 0)
            return "00:00";
        const sec = Math.floor(ms / 1000);
        const m = String(Math.floor(sec / 60)).padStart(2, '0');
        const s = String(sec % 60).padStart(2, '0');
        return `${m}:${s}`;
    }
}
