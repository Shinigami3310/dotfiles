import QtQuick
import QtCore
import Quickshell.Io

// Инкапсуляция работы с mpv: запуск процесса, socket-команды,
// различение ручной остановки (_explicitStop) и естественного завершения.
// Навигация по трекам (next/previous) остаётся за оркестратором.
QtObject {
    id: root

    signal exited

    property bool isPlaying: false
    readonly property bool isRunning: mpvProcess.running

    // Путь и команды
    property string socketPath: ""
    property string _currentTrackPath: ""

    // Рубим флаг между ручной остановкой и естественным концом трека
    property bool _explicitStop: false

    function playTrack(path: string) {
        if (!path)
            return;

        // При переключении трека останавливаем старый процесс
        if (mpvProcess.running)
            stopProcess();

        mpvProcess.command = ["mpv", "--no-video", "--no-terminal", `--input-ipc-server=${socketPath}`, "--", path];
        mpvProcess.running = true;
        root.isPlaying = true;
        root._currentTrackPath = path;
    }

    // Плей/пауза по socket (mpv протокол: "cycle pause")
    function cyclePause() {
        if (!mpvProcess.running)
            return;
        // socketPath — внутренняя константа сервиса, не пользовательский ввод,
        // конкатенация безопасна.
        pauseCommand.command = ["sh", "-c", `echo 'cycle pause' | socat - ${socketPath}`];
        pauseCommand.running = true;
        root.isPlaying = !root.isPlaying;
    }

    // Остановка mpv (используется при смене трека, sleep и т.п.)
    function stopProcess() {
        if (!mpvProcess.running)
            return;
        root._explicitStop = true;
        mpvProcess.running = false;
    }

    function stopAndReset() {
        stopProcess();
        root.isPlaying = false;
        root._currentTrackPath = "";
    }

    readonly property Process mpvProcess: Process {
        onExited: exitCode => {
            if (root._explicitStop) {
                root._explicitStop = false;
                return;
            }

            if (exitCode === 0 && root.isPlaying) {
                // Трек закончился естественным образом — сигнал оркестратору (next)
                root.isPlaying = false;
                root.exited();
            } else {
                if (exitCode !== 0)
                    console.warn(`[MusicPlayer] mpv завершился с кодом ${exitCode}`);
                root.isPlaying = false;
            }
        }
    }

    readonly property Process pauseCommand: Process {}
}