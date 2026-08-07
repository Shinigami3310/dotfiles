import QtQuick 6.0
import qs.config           // Theme.overlayColor

// Затемнённый полупрозный фон overlay. Цвет/альфа — из конфига, без хардкода (правило §2).
Rectangle { color: Theme.overlayColor }
