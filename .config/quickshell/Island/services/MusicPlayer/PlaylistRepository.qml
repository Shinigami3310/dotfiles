import QtQuick
import Qt.labs.folderlistmodel

// Чтение плейлистов (папок) и треков из музыкальной директории.
// Отдаёт готовые массивы: playlists (имена папок),
// tracks (fileName, cleanName, filePath).
// Не содержит бизнес-логики воспроизведения — только сканирование.
QtObject {
    id: root

    signal playlistsReady(var list)
    signal tracksReady(var list)

    property bool active: false
    property string musicDir: ""
    property string selectedFolder: ""

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
                root.playlistsReady(list);
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
                root.tracksReady(list);
            }
        }
    }
}