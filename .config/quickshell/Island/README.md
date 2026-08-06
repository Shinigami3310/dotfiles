# Island

Персональный пользовательский центр для **Quickshell 0.3** (Wayland, Hyprland), написанный на **QML (QtQuick 6.11)**.

«Остров» — компактный виджет в верхней части экрана, который раскрывается в набор взаимосвязанных поверхностей: домашние часы, панель, панель управления, календарь, лаунчер, музыкальный плеер, селекторы Wi-Fi/Bluetooth, OSD-слайдеры громкости и яркости, напоминание для глаз и таймер Pomodoro.

---

## Возможности

- 🏝 **Плавающий виджет-центр** с плавными cross-fade переходами между поверхностями.
- 🎛 **Панель управления**: Wi-Fi, Bluetooth, DND, ночной режим, громкость, яркость, ресурсы системы (CPU/RAM/GPU/Disk/Temp).
- 📅 **Календарь** с навигацией по месяцам.
- 🚀 **Лаунчер приложений** с поиском по `.desktop`-файлам.
- 🎵 **Музыкальный плеер** на базе `mpv` (плейлисты и треки из папки Музыки).
- 📶 **Селекторы Wi-Fi и Bluetooth** с подключением по клику.
- 🔆 **OSD-слайдеры** громкости и яркости, появляющиеся при изменении извне.
- 👀 **Eye-reminder** — напоминание делать перерыв каждые 10 минут.
- 🍅 **Pomodoro-таймер** с системными уведомлениями.
- 🎨 **Горячая перезагрузка темы** Material 3 из `~/.config/quickshell/colors.json`.

---

## Зависимости

Системные утилиты, которые вызывает Island (необходимы для работы сервисов):

| Утилита | Назначение |
|---|---|
| `wpctl` / `pactl` (PipeWire/PulseAudio) | громкость и мутинг |
| `brightnessctl` | яркость экрана |
| `nmcli` (NetworkManager) | Wi-Fi |
| `bluetoothctl` (bluez) | Bluetooth |
| `powerprofilesctl` (power-profiles-daemon) | профили питания |
| `hyprsunset` | ночной режим |
| `mpv` + `socat` | музыкальный плеер |
| `nvidia-smi` (опционально) | загрузка GPU |
| `notify-send` (libnotify) | уведомления Pomodoro |
| `kitty` (настраивается) | терминал для `.desktop` с `Terminal=true` |
| `qs` | внешние конфиги Quickshell (`NotificationCenter`, `PowerMenu`) |
| `quickshell` (0.3) | сам рантайм |

Модуль собран под **Hyprland** (использует `Quickshell.Hyprland` для воркспейсов и полноэкранного режима).

---

## Запуск

```sh
quickshell -c shell.qml
```

Тема загружается из `~/.config/quickshell/colors.json` (формат: `{"colors": { "surface": "#...", ... }}` — Material 3 токены). При изменении файла палитра перезагружается на лету.

---

## Структура проекта

```
shell.qml                 — точка входа: PanelWindow, IPC-обработчик, сервисы
core/                     — ядро навигации
  SurfaceHost.qml         — менеджер поверхностей (открыть/назад/закрыть, история, анимации)
  SurfaceBase.qml         — базовый класс поверхности (фокус, Esc, правый клик)
  SurfaceCatalog.qml      — реестр поверхностей (компоненты по имени)
  ListModelDiff.qml       — хелпер синхронизации ListModel (DRY)
  ActivityTracker.qml     — трекер активности retain/release (DRY)
surfaces/                 — тонкие обёртки: SurfaceBase + конкретная фича
features/                 — UI-компоненты (Bar, ControlPanel, MusicPlayer, Selectors, Sliders…)
services/                 — синглтон-сервисы состояния
services/integrations/    — синглтон-интеграции с системными утилитами
theme/                    — синглтоны: Theme, ThemeColor, Motion, Configs, Paths
assets/icons/             — статические иконки
```

---

## Как добавить новую поверхность

1. Создайте `features/MyFeature/MyFeature.qml` — UI-компонент.
2. Создайте `surfaces/MySurface.qml` на основе `SurfaceBase`:

   ```qml
   import "../core"
   import "../features/MyFeature"

   SurfaceBase {
       id: root
       surfaceName: "mySurface"
       implicitWidth: feature.implicitWidth
       implicitHeight: feature.implicitHeight
       MyFeature {
           id: feature
           onSurfaceRequested: name => root.surfaceRequested(name)
       }
   }
   ```

3. Зарегистрируйте поверхность в `core/SurfaceCatalog.qml`:

   ```qml
   readonly property Component mySurface: MySurface {}
   ```

4. Откройте её через `host.open("mySurface")` (или из фичи — сигналом `surfaceRequested`).

---

## Как добавить новый сервис

1. Создайте `services/integrations/MyService.qml` с `pragma Singleton`.
2. Зарегистрируйте в `services/integrations/qmldir`.
3. Используйте из UI напрямую (например `MyService.toggle()`), связи с поверхностями — через сигнал `surfaceRequested`, который слушает `shell.qml`.

---

## Конфигурация

Основные настройки вынесены в синглтоны:

- `theme/Paths.qml` — пути (домашняя директория, палитра, ассеты, внешние конфиги, терминал).
- `theme/Configs.qml` — масштабы hover/pressed.
- `theme/Motion.qml` — тайминги анимаций.
- Конфиги фич: `AppLauncherConfig`, `ControlPanelConfig`, `SelectorConfig`, `CalendarConfig`, `BatteryConfig`.

---

## Известные ограничения

- Полная завязка на **Hyprland** (воркспейсы, полноэкранный режим).
- Состояние поверхностей не кэшируется при переходах (исключение — музыкальный плеер, состояние хранится в `MusicPlayerService`).
- Абсолютные пути устранены, но внешние конфиги (`NotificationCenter`, `PowerMenu`) должны существовать в `~/.config/quickshell/`.