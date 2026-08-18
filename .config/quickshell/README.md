# Quickshell-экосистема

Персональный набор виджетов для **Quickshell 0.3** (Wayland, Hyprland), написанный на **QML (QtQuick 6.11)**.

Состоит из четырёх независимых подпроектов, объединённых общим слоем `shared/` (тема, анимации, пути, UI-примитивы):

| Подпроект | Назначение | Запуск |
|---|---|---|
| `Island` | Плавающий виджет-центр: часы, панель, панель управления, календарь, лаунчер, музыкальный плеер, селекторы Wi-Fi/Bluetooth, OSD-слайдеры, eye-reminder, Pomodoro | `quickshell -c Island` |
| `NotificationCenter` | Центр уведомлений: список, история, тосты | `quickshell -c NotificationCenter` |
| `PowerMenu` | Меню питания: блокировка, сон, перезагрузка, выключение | `quickshell -c PowerMenu` |
| `ThemePicker` | Переключение тем Material 3 и обоев | `quickshell -c ThemePicker` |

Каждый подпроект инкапсулирован и работает независимо; общий слой подключается через симлинк `shared/ → ../shared` внутри подпроекта (Quickshell не разрешает импорты за пределы корня конфига, поэтому симлинк обязателен).

---

## Общий слой `shared/`

| Модуль | Назначение |
|---|---|
| `shared/theme/ThemeColor.qml` | Токены Material 3 из `colors.json` с hot-reload (единый источник цветов) |
| `shared/theme/Motion.qml` | Тайминги и easing анимаций (единый источник, `mult` для глоб. замедления) |
| `shared/theme/Theme.qml` | Шрифт и масштабы hover/pressed |
| `shared/theme/SharedPaths.qml` | Резолв путей: `env() → XDG → дефолт` (без захардкоженных `/home/user`) |

Правила: никакого дублирования темы/анимаций/путей между подпроектами; специфика подпроекта — внутри подпроекта (см. `.clinerules`).

---

## Зависимости

Системные утилиты, которые вызывают подпроекты (необходимы для работы сервисов):

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
| `qs` | внешние конфиги Quickshell |
| `quickshell` (0.3) | сам рантайм |

Экосистема собрана под **Hyprland** (использует `Quickshell.Hyprland` для воркспейсов и полноэкранного режима).

---

## Тема

Тема загружается из `~/.config/quickshell/colors.json` (формат: `{"colors": { "surface": "#...", ... }}` — токены Material 3). При изменении файла палитра перезагружается на лету. Пути к палитре берутся через `SharedPaths` (env `PALETTE_PATH` → `$XDG_CONFIG_HOME/quickshell/colors.json`).

---

## Структура репозитория

```
.clinerules                 — единые инженерные правила
README.md                   — этот файл
colors.json                 — палитра Material 3 (источник темы)
shared/theme/               — общий слой: ThemeColor, Motion, Theme, SharedPaths
Island/                     — подпроект «Остров»
  shell.qml                 — точка входа: PanelWindow, IPC-обработчик, сервисы
  core/                     — ядро навигации (SurfaceHost, SurfaceBase, SurfaceCatalog, SurfaceNames)
  ui/                       — переиспользуемые примитивы (IconButton, Slider, ToggleSwitch, Pressable, …)
  surfaces/                 — тонкие обёртки: SurfaceBase + конкретная фича
  features/                 — UI-компоненты (Bar, ControlPanel, MusicPlayer, Selectors, Eye, HomeClock, …)
  services/                 — каталог синглтон-сервисов
  services/MusicPlayer/     — MpvEngine + PlaylistRepository (логика mpv/сканов)
  services/Bluetooth/       — BluetoothScanner + BluetoothProcesses (логика bluetooth)
  services/helpers/         — ListModelDiff и др.
  services/scripts/         — вспомогательные shell-скрипты
  theme/                    — только специфичный Paths.qml (icon, scripts, appDirs)
  assets/icons/             — статические иконки
  shared → ../shared        — симлинк общего слоя
NotificationCenter/         — подпроект «Центр уведомлений»
  config/                   — Settings, Constants (Theme/Colors из shared), Colors
  services/                 — NotificationService, NotificationRouter, NotificationStore, NotificationModel
  ui/                       — center/common/toasts
  shared → ../shared        — симлинк
PowerMenu/                  — подпроект «Меню питания»
  theme/                    — только специфичный Configs.qml
  ui/                       — PowerMenuWindow, ActionButton
  shared → ../shared        — симлинк
ThemePicker/                — подпроект «Переключатель тем»
  theme/                    — только специфичный Configs.qml
  services/                 — ThemeApplier, ThemePickerController, WallpaperService
  ui/                       — Carousel, WallpaperCard
  shared → ../shared        — симлинк
```

---

## Как добавить новую поверхность (Island)

1. Создайте `features/MyFeature/MyFeature.qml` — UI-компонент (+ `MyFeatureConfig.qml` + `qmldir`, объявление и типа, и singleton).
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

## Как добавить новый сервис (Island)

1. Создайте `services/MyService.qml` с `pragma Singleton` (или обычный `QtObject`, если нужен инстанс — как `ModeController`).
2. Если сервис сложный — разбейте на подпапку `services/MyService/` (по образцу `MusicPlayer/`, `Bluetooth/`) и зарегистрируйте в `services/qmldir`.
3. Зарегистрируйте в `services/qmldir`.
4. Используйте из UI напрямую (например `MyService.toggle()`), связи с поверхностями — через сигнал `surfaceRequested`, который слушает `shell.qml`.

---

## Конфигурация

Основные настройки вынесены в синглтоны:

- `shared/theme/*` — тема (цвета, анимации, шрифт, пути).
- `Island/services/ServiceConfig.qml` — тайминги сервисов Island.
- Конфиги фич: `AppLauncherConfig`, `ControlPanelConfig`, `SelectorConfig`, `CalendarConfig`, `BatteryConfig`, `EyeConfig`, `HomeClockConfig`, `MusicPlayerConfig`.

---

## Известные ограничения

- Полная завязка на **Hyprland** (воркспейсы, полноэкранный режим).
- Состояние поверхностей не кэшируется при переходах (исключение — музыкальный плеер, состояние хранится в `MusicPlayerService`).
- Абсолютные пути устранены, но внешние конфиги (`NotificationCenter`, `PowerMenu`) должны существовать в `~/.config/quickshell/`.