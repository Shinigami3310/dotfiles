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
| `SurfaceNames.qml` | Синглтон-реестр имён поверхностей и списка `nonFocusSurfaces`. Сервисы и фичи не хардкодят строки. |
| `Island.qml` | Визуальный контейнер (скруглённый прямоугольник) с анимированным ресайзом. |

### 2. Переиспользуемые примитивы (`ui/`)

Атомарные UI-компоненты, не зависящие от фич:

| Компонент | Назначение |
|---|---|
| `ui/IconButton` | Единая иконка-кнопка (Image + MultiEffect + Tap/Hover). Параметры: `iconName`, `active`, `showBackground`, `enableRightClick`. |
| `ui/Slider` | Композиция `SliderIcon` (fade-переключение иконки), `SliderTrack` (drag/wheel/клик), `SliderValueText` (процент). |
| `ui/ToggleSwitch` | Переключатель. |
| `ui/HSpacer` | Распорка `Layout.fillWidth` — заменяет повторяющиеся `Item { Layout.fillWidth: true }`. |
| `ui/AnimatedList` | Анимированный `ListView` (add/remove/displaced-переходы) — общий для `BaseSelector` и `AppList`. |
| `ui/UiConfig` | Синглтон размеров/масштабов примитивов. |

### 3. Поверхности (`surfaces/`)

Тонкие обёртки: **`SurfaceBase { … }` + конкретная фича**. Каждая поверхность:
- задаёт `surfaceName`;
- проксирует `surfaceRequested` от фичи наверх;
- задаёт `implicitWidth/Height` из фичи.

### 4. Фичи (`features/`)

UI-компоненты. Композиция из `ui/`-примитивов и собственных атомов:

- `Bar` = `Workspaces` + `Clock` + `RightActions`.
- `ControlPanel` = `TopPanel` (Wifi/Bluetooth/DND/NightMode) + `VolumeSliderRow` + `BrightnessSliderRow` + `ResourceRow`.
- `Selectors` (`WifiSelector`, `BluetoothSelector`) = общий `BaseSelector` + делегат `SelectorItemCard` + `PasswordField` (ввод пароля).
- `Sliders` (`Volume`, `Brightness`) = общий `OsdSliderPanel` поверх `ui/Slider`.
- `MusicPlayer` = `PlaybackView` + `PlaylistView` (переключение зависит от `MusicPlayerService.isPlaylistMode`).
- `AppLauncher` = `SearchBar` + `AppList` + `AppItem`.
- `Calendar` = `MonthHeader` (навигация по месяцам) + грид `DayCell`.
- `Battery` = `BatteryMeter` (рамка+fill) + ряд `ProfileButton`.

### 5. Сервисы (`services/`)

Все сервисы — синглтоны (`pragma Singleton`), изолирующие системные вызовы от UI. Единый плоский каталог, один `qmldir`. Исключение — `ModeController` (инстансный, нужен `host`).

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
| `EyeReminderService` | чистый `Timer` |

**Засыпание на простое:** `SystemStatsService` и `BatteryService` держат процессы/таймеры активными только пока `retain()` удерживает сервис (при открытой используемой поверхности); при `release()` останавливаются.

Сервисы, инициирующие показ OSD/поверхности, эмитят сигнал `surfaceRequested`, который ловит `shell.qml` и вызывает `host.open()`. Имена поверхностей берутся из `SurfaceNames`.

Под-папки: `services/helpers/` — утилиты сервисов (`ListModelDiff`); `services/scripts/` — вынесенные inline bash/awk скрипты (путь — `Paths.scriptsDir`).

### 6. Тема (`theme/`)

Синглтоны:
- `ThemeColor` — Material 3 токены из `~/.config/quickshell/colors.json` (`FileView` + hot-reload). Дефолтная палитра + `try/catch` — при отсутствии/битом файле интерфейс не становится прозрачным.
- `Theme` — шрифт и единые масштабы hover/pressed (бывший `Configs`).
- `Motion` — тайминги анимаций.
- `Paths` — централизованные пути (home, палитра, ассеты, скрипты, внешние конфиги, терминал) + `Paths.icon(name)`/`Paths.scriptsDir`.

---

## Потоки данных

### Открытие поверхности (UI → Host)
```
Фича (Bar.RightActions)
  └ signal surfaceRequested(SurfaceNames.controlPanel)
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
                  → signal surfaceRequested(SurfaceNames.volumeSlider)
                      → shell.qml Connections → host.open("volumeSlider")
```

### Тема (загрузка и горячая перезагрузка)
```
старт → FileView.onLoadedChanged → updateColors()
  → ThemeColor.parsedColors = json.colors (из colors.json)

colors.json изменён → FileView.onFileChanged → updateColors()
  → все привязки color автоматически пересчитаны (reactive)
  → при ошибке JSON — warn, остаётся предыдущая палитра
```

---

## Ключевые решения рефакторинга

1. **`ListModelDiff`** — единственная реализация sync-логики ListModel (Wifi/Bluetooth/App). Убрано тройное дублирование.
2. **`Paths`** — устранены абсолютные пути и хардкод пользователя, внешние конфиги и терминал конфигурируемы.
3. **Безопасный запуск приложений** — `AppService.launchApp` разбирает `Exec` на argv (без `sh -c`-инъекций).
4. **Валидация поверхностей** — `SurfaceHost.open()` проверяет наличие `enter/exit` до перехода (предотвращает runtime-краши).
5. **Единые UI-примитивы (`ui/`)** — 4 иконки-кнопки и 2 слайдера сведены к одному `IconButton`/`Slider`; распорки — `HSpacer`.
6. **Сервисы-синглтоны со сном** — одна парадигма сервисов + retain/release для ресурсоёмких.
7. **`SurfaceNames`** — имена поверхностей централизованы, сервисы не знают UI-строк.
8. **Устойчивая тема** — дефолтная палитра, `try/catch`, единый путь парсинга.

---

## Диаграмма зависимостей

```
UI (features/surfaces)
   │ использует примитивы ui/ и синглтоны сервисов
   ▼
ui/ (IconButton, Slider, ToggleSwitch, HSpacer)
   ▼
services (все синглтоны, один qmldir)
   │ дёргают CLI (массивами argv, без sh -c где возможно)
   ▼
системные утилиты (wpctl, nmcli, bluetoothctl…)

core (SurfaceHost/SurfaceNames)
   ▲ управляет навигацией
   │
UI (surfaces) — наследует SurfaceBase
```

Зависимости направлены **сверху вниз**: UI → ui/ → сервисы → системные утилиты. Ядро не знает о конкретных фичах (только реестр имён в `SurfaceCatalog`/`SurfaceNames`).

---

## Расширяемость

- **Новая поверхность**: 2 файла (feature + surface) + строка в `SurfaceCatalog` + константа в `SurfaceNames` (+ README-инструкция).
- **Новый сервис**: 1 синглтон + строка в `qmldir` + (опционально) сигнал `surfaceRequested`, обрабатываемый в `shell.qml`.
- **Новая внешняя утилита**: замена в конкретном сервисе не затрагивает UI.
- **Новый WM**: потребует абстракции над `Quickshell.Hyprland` (воркспейсы, fullscreen) — известное ограничение.