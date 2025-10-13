shader_type canvas_item;

uniform float progress : hint_range(0, 1) = 1.0;
uniform float border_width = 8.0;
uniform vec4 border_color : source_color = vec4(1.0, 0.5, 0.2, 1.0);
uniform float radius = 40.0;

void fragment() {
    vec2 center = vec2(radius);
    vec2 pos = UV * TEXTURE_PIXEL_SIZE * TEXTURE_SIZE;

    // Calculate distance from center
    float dist = distance(pos, center);
    float angle = atan(pos.y - center.y, pos.x - center.x);

    // Adjust angle to start from top (-PI/2)
    angle = mod(angle + 3.14159 * 1.5, 6.28318);

    // Draw circle border
    if (dist > radius - border_width && dist < radius && angle < 6.28318 * progress) {
        COLOR = border_color;
    } else {
        discard;
    }
}