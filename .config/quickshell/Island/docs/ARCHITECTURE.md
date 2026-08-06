# Архитектура Island

Документ описывает архитектуру проекта после рефакторинга, цели и связи между слоями.

---

## Обзор

**Island** — shell-центр поверх Wayland (Hyprland) на Quickshell 0.3 / QtQuick 6.11. Это **один оверлейный `PanelWindow`**, в котором живая «поверхность» (текущий UI) размещена в скруглённом контейнере `Island`. Навигация между поверхностями обслуживается `SurfaceHost`.

```
┌───────────────────────────────────────────────┐
│ shell.qml (PanelWindow, Overlay, Ignore)      │
│  ├─ ModeController   — реакция на fullscreen  │
│  ├─ SurfaceCatalog   — реестр поверхностей    │
│  ├─ Island (контейнер)                       │
│  │   └─ SurfaceHost — менеджер навигации      │
│  │       └─ [текущая SurfaceBase]             │
│  ├─ IpcHandler      — внешний IPC (openSurface)│
│  └─ Connections     — сигналы сервисов → host │
└───────────────────────────────────────────────┘
```

---

## Слои

### 1. Ядро (`core/`)

| Файл | Назначение |
|---|---|
| `SurfaceBase.qml` | Абстрактный базовый класс поверхности: `surfaceName`, `active`, `canGoBack`, сигналы `surfaceRequested/backRequested/closeRequested`, обработка Esc и правого клика, `enter()/exit()`. |
| `SurfaceHost.qml` | Менеджер поверхностей: `open(name)`, `back()`, `close()`, стек `history`, cross-fade анимации (outgoing/pending), флаг `busy` против гонок. Валидирует, что поверхность реализует `enter/exit`. |
| `SurfaceCatalog.qml` | Реестр `Component` по имени. Единственное место регистрации новых поверхностей. |
| `Island.qml` | Визуальный контейнер (скруглённый прямоугольник) с анимированным ресайзом. |
| `ListModelDiff.qml` | Утилита синхронизации `ListModel` с массивом по ключу (remove/move/insert/update property). Устраняет дублирование в Wifi/Bluetooth/App сервисах. |

### 2. Поверхности (`surfaces/`)

Тонкие обёртки: **`SurfaceBase { … }` + конкретная фича**. Каждая поверхность:
- задаёт `surfaceName`;
- проксирует `surfaceRequested` от фичи наверх;
- задаёт `implicitWidth/Height` из фичи.

Пример: `BarSurface` оборачивает `Bar`, `WifiSelectorSurface` оборачивает `WifiSelector`.

### 3. Фичи (`features/`)

UI-компоненты. Композиция, а не наследование:

- `Bar` = `Workspaces` + `Clock` + `RightActions`.
- `ControlPanel` = `TopPanel` (Wifi/Bluetooth/DND/NightMode) + `VolumeSliderRow` + `BrightnessSliderRow` + `ResourceRow`.
- `Selectors` (`WifiSelector`, `BluetoothSelector`) = общий `BaseSelector` + делегат `SelectorItemCard`.
- `Sliders` (`Volume`, `Brightness`) = общий `OsdSliderPanel` + `Slider`.
- `MusicPlayer` = `PlaybackView` + `PlaylistView` (переключение зависит от `MusicPlayerService.isPlaylistMode`).
- `AppLauncher` = `SearchBar` + `AppList` + `AppItem`.

### 4. Сервисы (`services/`, `services/integrations/`)

Синглтоны (`pragma Singleton`), изолирующие системные вызовы от UI:

| Сервис | Системные вызовы |
|---|---|
| `AudioService` | `wpctl`, `pactl subscribe` |
| `BrightnessService` | `brightnessctl`, `udevadm monitor` |
| `WifiService` | `nmcli` |
| `BluetoothService` | `bluetoothctl` |
| `BatteryService` | `/sys/class/power_supply`, `powerprofilesctl` |
| `NightModeService` | `hyprsunset`, `pgrep` |
| `DndService` | `qs -c NotificationCenter …` |
| `PowerService` | `qs -c PowerMenu` |
| `SystemStatsService` | `/proc/stat`, `/proc/meminfo`, `df`, `nvidia-smi`, `thermal_zone` |
| `AppService` | `find`/`gawk` по `.desktop`, безопасный запуск массивом argv |
| `MusicPlayerService` | `mpv` (socat IPC), `FolderListModel` |
| `CalendarService` | чистая логика календаря (`SystemClock`) |
| `WorkspaceService` | `Quickshell.Hyprland` |
| `ModeController` | `Hyprland.focusedWorkspace.hasFullscreen` |
| `EyeReminderService` | чистый `Timer` |

Сервисы, инициирующие показ OSD/поверхности, эмитят сигнал `surfaceRequested`, который ловит `shell.qml` и вызывает `host.open()`. Это развязывает сервисы от навигации.

### 5. Тема (`theme/`)

Синглтоны:
- `ThemeColor` — Material 3 токены из `~/.config/quickshell/colors.json` (`FileView` + hot-reload).
- `Theme` — шрифт.
- `Motion` — тайминги анимаций.
- `Configs` — общие масштабы.
- `Paths` — централизованные пути (home, палитра, ассеты, внешние конфиги, терминал).

---

## Потоки данных

### Открытие поверхности (UI → Host)
```
Фича (Bar.RightActions)
  └ signal surfaceRequested("controlPanel")
      └ SurfaceBase.surfaceRequested
          └ SurfaceHost.open("controlPanel")
              ├ history.push(currentName)
              ├ component = catalog["controlPanel"]
              ├ pendingItem = component.createObject(...)
              ├ валидация enter/exit
              └ cross-fade: outgoing.exit → destroy → current = pending → enter
```

### Показ OSD (система → UI)
```
wpctl change volume
  → pactl subscribe (eventListener)
      → debounceTimer
          → volProc (wpctl get-volume)
              → AudioService.volume/muted обновлены
                  → signal surfaceRequested("volumeSlider")
                      → shell.qml Connections → host.open("volumeSlider")
```

### Тема (горячая перезагрузка)
```
colors.json изменён
  → FileView.onFileChanged → reload() → updateColors()
      → ThemeColor.parsedColors обновлён
          → все привязки color автоматически пересчитаны (reactive)
```

---

## Ключевые решения рефакторинга

1. **`ListModelDiff`** — единственная реализация sync-логики ListModel (Wifi/Bluetooth/App). Убрано тройное дублирование.
2. **`Paths`** — устранены абсолютные пути и хардкод пользователя (`/home/Rostislav/...`), внешние конфиги и терминал конфигурируемы.
3. **Безопасный запуск приложений** — `AppService.launchApp` разбирает `Exec` на argv (без `sh -c`-инъекций).
4. **Валидация поверхностей** — `SurfaceHost.open()` проверяет наличие `enter/exit` до перехода (предотвращает runtime-краши).
5. **Обработка ошибок** — `onExited` с `console.warn` при ненулевых кодах в Audio/Brightness/SystemStats.
6. **`SystemStatsService`** — разбит монолитный `while true` bash-цикл на событийную модель: разовый init (disk/gpu/temp-path) + периодический опрос CPU/RAM/Temp отдельными процессами.

---

## Диаграмма зависимостей

```
UI (features/surfaces)
   │ использует синглтоны
   ▼
services + services/integrations
   │ дёргают CLI (массивами argv, без sh -c где возможно)
   ▼
системные утилиты (wpctl, nmcli, bluetoothctl…)

core (SurfaceHost/ListModelDiff)
   ▲ управляет навигацией и переиспользуемыми утилитами
   │
UI (surfaces) — наследует SurfaceBase
```

Зависимости направлены **сверху вниз**: UI → сервисы → системные утилиты. Ядро не знает о конкретных фичах (только реестр имён в `SurfaceCatalog`).

---

## Расширяемость

- **Новая поверхность**: 2 файла (feature + surface) + строка в `SurfaceCatalog` (+ README-инструкция).
- **Новый сервис**: 1 синглтон + строка в `qmldir` + (опционально) сигнал `surfaceRequested`, обрабатываемый в `shell.qml`.
- **Новая внешняя утилита**: замена в конкретном сервисе не затрагивает UI.
- **Новый WM**: потребует абстракции над `Quickshell.Hyprland` (воркспейсы, fullscreen) — известное ограничение.