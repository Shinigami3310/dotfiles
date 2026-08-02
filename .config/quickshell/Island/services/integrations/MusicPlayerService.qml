pragma Singleton
import QtQuick
import QtMultimedia
import QtCore
import Qt.labs.folderlistmodel

Item {
    id: root

    readonly property string musicRootPath: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string coversPath: musicRootPath + "/MusicCover"

    property var playlistNames: []
    property string currentPlaylistName: ""

    property var playlist: []
    property int currentIndex: -1

    // State
    readonly property alias currentTrackUrl: mediaPlayer.source
    readonly property alias duration: mediaPlayer.duration
    readonly property alias position: mediaPlayer.position
    readonly property alias playbackState: mediaPlayer.playbackState
    readonly property bool isPlaying: playbackState === MediaPlayer.PlayingState

    property alias repeatTrack: appSettings.repeatTrack

    signal trackChanged(string title, string artist, string album, string cover)

    Settings {
        id: appSettings
        category: "MusicPlayer"

        property string currentPlaylistName: ""
        property string currentTrack: ""
        property bool repeatTrack: false
    }

    MediaPlayer {
        id: mediaPlayer

        audioOutput: AudioOutput {
            volume: 1.0
        }

        onMediaStatusChanged: {
            if (mediaStatus === MediaPlayer.EndOfMedia) {
                if (root.repeatTrack) {
                    mediaPlayer.seek(0);
                    mediaPlayer.play();
                } else {
                    root.next();
                }
            }
        }

        onMetaDataChanged: {
            const meta = mediaPlayer.metaData;
            const currentItem = root.playlist[root.currentIndex] || {};

            const title = meta.stringValue(MediaMetaData.Title) || currentItem.name || "Неизвестный трек";
            const artist = meta.stringValue(MediaMetaData.Author) || meta.stringValue(MediaMetaData.ContributingArtist) || "Неизвестный исполнитель";
            const album = meta.stringValue(MediaMetaData.AlbumTitle) || meta.stringValue(MediaMetaData.Album) || "";

            // Обложка: метаданные -> папка MusicCover -> fallback
            let cover = meta.coverArtUrl ? meta.coverArtUrl.toString() : "";
            if (!cover && currentItem.name) {
                cover = Qt.resolvedUrl(`${root.coversPath}/${currentItem.name}.png`);
            }

            root.trackChanged(title, artist, album, cover);
        }
    }

    // Сканирование плейлистов (папок в ~/Music)
    FolderListModel {
        id: playlistsModel
        folder: root.musicRootPath
        showDirs: true
        showFiles: false
        showDotAndDotDot: false

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                let names = [];
                for (let i = 0; i < count; i++) {
                    let dirName = get(i, "fileName");
                    // Исключаем папку обложек
                    if (dirName !== "MusicCover") {
                        names.push(dirName);
                    }
                }
                root.playlistNames = names;

                // Восстановление сохраненного плейлиста или fallback на первый
                if (appSettings.currentPlaylistName && names.includes(appSettings.currentPlaylistName)) {
                    root.currentPlaylistName = appSettings.currentPlaylistName;
                } else if (names.length > 0) {
                    root.currentPlaylistName = names[0];
                } else {
                    root.currentPlaylistName = "";
                }

                tracksModel.folder = root.currentPlaylistName ? (root.musicRootPath + "/" + root.currentPlaylistName) : "";
            }
        }
    }

    // Сканирование треков в выбранном плейлисте
    FolderListModel {
        id: tracksModel
        showDirs: false
        showFiles: true
        nameFilters: ["*.mp3", "*.flac", "*.wav", "*.m4a", "*.ogg"]

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                let items = [];
                for (let i = 0; i < count; i++) {
                    let fileName = get(i, "fileName");
                    let fileUrl = get(i, "fileUrl").toString();

                    items.push({
                        path: fileUrl,
                        name: fileName.replace(/\.[^/.]+$/, "")
                    });
                }
                root.playlist = items;

                // Восстановление трека или fallback на самый первый
                if (root.playlist.length > 0) {
                    let idx = root.playlist.findIndex(t => t.path === appSettings.currentTrack);
                    root.loadTrack(idx >= 0 ? idx : 0, false);
                } else {
                    root.clearPlayer();
                }
            }
        }
    }

    // Public Controls
    function play() {
        if (!playlist.length)
            return;
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
        if (!playlist.length)
            return;
        loadTrack((currentIndex + 1) % playlist.length, true);
    }

    function previous() {
        if (!playlist.length)
            return;
        const newIdx = (currentIndex <= 0) ? (playlist.length - 1) : (currentIndex - 1);
        loadTrack(newIdx, true);
    }

    function toggleRepeat() {
        appSettings.repeatTrack = !appSettings.repeatTrack;
    }

    function setPlaylist(name, autoPlay = false) {
        if (!playlistNames.includes(name))
            return;
        stop();
        currentPlaylistName = name;
        appSettings.currentPlaylistName = name;
        tracksModel.folder = root.musicRootPath + "/" + name;
        if (autoPlay) {
            // Воспроизведение запустится после загрузки tracksModel
            let connection = tracksModel.onStatusChanged.connect(() => {
                if (tracksModel.status === FolderListModel.Ready) {
                    play();
                    tracksModel.onStatusChanged.disconnect(connection);
                }
            });
        }
    }

    function seek(ms) {
        mediaPlayer.seek(ms);
    }

    function formatTime(ms) {
        if (isNaN(ms) || ms <= 0)
            return "00:00";
        const totalSec = Math.floor(ms / 1000);
        const m = Math.floor(totalSec / 60).toString().padStart(2, '0');
        const s = (totalSec % 60).toString().padStart(2, '0');
        return `${m}:${s}`;
    }

    function loadTrack(index, autoPlay = true) {
        if (index < 0 || index >= playlist.length) {
            stop();
            return;
        }
        currentIndex = index;
        mediaPlayer.source = playlist[index].path;
        appSettings.currentTrack = playlist[index].path;
        if (autoPlay)
            mediaPlayer.play();
    }

    function clearPlayer() {
        mediaPlayer.source = "";
        currentIndex = -1;
    }
}
