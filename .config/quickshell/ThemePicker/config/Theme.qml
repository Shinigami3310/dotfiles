// ThemePicker — единый источник истины для всех констант UI/поведения.
// Почему singleton.qml, а не theme.json: не нужен парсер, сразу работает
// как Theme.<prop> через `import qs.config`, LSP‑подсветка и типизация.
// Ни одна константа/цвет/коэффициент НЕ хардкодится в UI‑файлах (.clinerules §2).

pragma Singleton
import QtQuick 6.11

QtObject {
    // --- Источник данных ---
    // Относительно $HOME; раскрывается в WallpaperLoader через `sh -c` (тильда в
    // строках QML не раскрывается, а $HOME в sh — да).
    readonly property string wallpaperDir: "Pictures/Wallpapers"
    readonly property var validExtensions: ["jpg", "jpeg", "png", "webp"]
    readonly property int scanDebounceMs: 300          // защита от каскадов при массовом add/remove
    readonly property bool wrapAround: true            // зацикливание индекса на концах

    // --- Размеры / геометрия ---
    readonly property real imageHeightRatio: 0.33      // высота картинки ≈ 1/3 экрана
    readonly property real trapezoidAngleDeg: 45.0     // желаемый угол боков (информативно; см. ниже)
    readonly property real trapezoidInset: 0.08       // доля ширины, отсекаемая в верхнем углу с
                                                       // каждой стороны. Буквальный 45° над wide‑картинкой
                                                       // (tan45·h/w≈0.56) вырождается — параметризуем
                                                       // коэффициентом, а не углом.

    // --- UI layout (без магических чисел в компонентах) ---
    readonly property real imageAspectRatio: 1.777     // 16:9 — типичное обои
    readonly property int navButtonSize: 48
    readonly property int carouselGap: 24
    readonly property int carouselPadding: 48

    // --- Масштабы карусели (центр > соседи) ---
    readonly property real centerScale: 1.15
    readonly property real nearScale: 0.92             // для visiblePoolSize >= 5 (ближние соседи)
    readonly property real sideScale: 0.82             // для visiblePoolSize >= 5 (дальние соседи)
    readonly property int visiblePoolSize: 3           // 3 = центр + левый + правый сосед

    // --- Анимация ---
    readonly property int fadeDurationMs: 220
    readonly property int scaleDurationMs: 320

    // --- Оформление оверлея / тема ---
    readonly property color overlayColor: "#4D000000"        // ~30% затемнение фона
    readonly property color highlightColor: "#FFFFFFFF"      // обводка выбранной трапеции
    readonly property real highlightWidth: 2.0
    readonly property color imagePlaceholderColor: "#333333"  // пока async‑картинка грузится

    // --- Скрипты ---
    // set-theme лежит в корне конфига и принимает $1 = basename файла (см. set-theme),
    // поэтому передаём имя, а не полный путь.
    readonly property string applyScript: "set-theme"
    readonly property string applyBy: "name"
}
