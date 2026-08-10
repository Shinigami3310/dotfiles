# Quickshell-экосистема

Персональный набор виджетов для **Quickshell 0.3** (Wayland, Hyprland), написанный на **QML (QtQuick 6.11)**.

Состоит из четырёх независимых подпроектов, объединённых общим слоем `shared/` (тема, анимации, пути, UI-примитивы):

| Подпроект | Назначение | Запуск |
|---|---|---|
| `Island` | Плавающий виджет-центр: часы, панель, панель управления, календарь, лаунчер, музыкальный плеер, селекторы Wi-Fi/Bluetooth, OSD-слайдеры, eye-reminder, Pomodoro | `quickshell -c Island` |
| `NotificationCenter` | Центр уведомлений: список, история, тосты | `quickshell -c NotificationCenter` |
| `PowerMenu` | Меню питания: блокировка, сон, перезагрузка, выключение | `quickshell -c PowerMenu` |
| `ThemePicker` | Переключение тем Material 3 и обоев | `quickshell -c ThemePicker` |

---

## Общий слой `shared/`

Общие тема, анимации, пути и UI-примитивы живут в `shared/` и переиспользуются всеми подпроектами. Специфика подпроекта — внутри подпроекта. Дублирование общего кода между подпроектами недопустимо (см. `.clinerules`).

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

Тема загружается из `~/.config/quickshell/colors.json` (формат: `{"colors": { "surface": "#...", ... }}` — токены Material 3). При изменении файла палитра перезагружается на лету.

---

## Структура репозитория

```
.clinerules               — единые инженерные правила
README.md                 — этот файл
colors.json               — палитра Material 3 (источник темы)
shared/                   — общий слой: тема, анимации, пути, UI-примитивы
Island/                   — подпроект «Остров»
  shell.qml               — точка входа: PanelWindow, IPC-обработчик, сервисы
  core/                   — ядро навигации (SurfaceHost, SurfaceBase, SurfaceCatalog, SurfaceNames)
  ui/                     — переиспользуемые примитивы (IconButton, Slider, ToggleSwitch, …)
  surfaces/               — тонкие обёртки: SurfaceBase + конкретная фича
  features/               — UI-компоненты (Bar, ControlPanel, MusicPlayer, Selectors, …)
  services/               — каталог синглтон-сервисов состояния и системных утилит
  theme/                  — синглтоны: Theme, ThemeColor, Motion, Paths
  assets/icons/           — статические иконки
NotificationCenter/       — подпроект «Центр уведомлений»
PowerMenu/                — подпроект «Меню питания»
ThemePicker/              — подпроект «Переключатель тем»
```

---

## Как добавить новую поверхность (Island)

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

## Как добавить новый сервис (Island)

1. Создайте `services/MyService.qml` с `pragma Singleton` (или обычный `QtObject`, если нужен инстанс — как `ModeController`).
2. Зарегистрируйте в `services/qmldir`.
3. Используйте из UI напрямую (например `MyService.toggle()`), связи с поверхностями — через сигнал `surfaceRequested`, который слушает `shell.qml`.

---

## Конфигурация

Основные настройки вынесены в синглтоны:

- `shared/theme/Paths.qml` — пути (домашняя директория, палитра, ассеты, внешние конфиги, терминал).
- `shared/theme/Theme.qml` — шрифт и масштабы hover/pressed.
- `shared/theme/Motion.qml` — тайминги анимаций.
- `shared/theme/ThemeColor.qml` — токены Material 3 с hot-reload.
- Конфиги фич: `AppLauncherConfig`, `ControlPanelConfig`, `SelectorConfig`, `CalendarConfig`, `BatteryConfig`.

---

## Известные ограничения

- Полная завязка на **Hyprland** (воркспейсы, полноэкранный режим).
- Состояние поверхностей не кэшируется при переходах (исключение — музыкальный плеер, состояние хранится в `MusicPlayerService`).
- Абсолютные пути устранены, но внешние конфиги (`NotificationCenter`, `PowerMenu`) должны существовать в `~/.config/quickshell/`.