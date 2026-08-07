#version 440

// Трапеционная маска ShaderEffect (source = Image, PreserveAspectCrop).
// topInset — доля ширины, отсекаемая в ВЕРХНЕМ углу с каждой стороны; линейно
// убывает к низу: inset(y) = topInset * (1 - y). Нижний край широкий.
// Пиксели за пределами трапеции → прозрачные (alpha 0), тем самым маскируют картинку.
// (Буквальный 45° над wide‑картинкой вырожден → topInset берётся из конфига.)

uniform sampler2D source;
uniform float topInset;
in vec2 qt_TexCoord0;                    // 0..1, задаётся дефолтным vertex‑шейдером Qt
layout(location = 0) out vec4 fragColor;

void main() {
    float inset = topInset * (1.0 - qt_TexCoord0.y);
    if (qt_TexCoord0.x < inset || qt_TexCoord0.x > 1.0 - inset)
        fragColor = vec4(0.0);
    else
        fragColor = texture(source, qt_TexCoord0);
}
