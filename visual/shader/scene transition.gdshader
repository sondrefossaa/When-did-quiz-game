shader_type canvas_item;
uniform float progress : hint_range(0, 1) = 1.0;
uniform vec4 circle_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float dx = dFdx(UV.x);
	float dy = dFdy(UV.y);
	float aspect = dy / dx;
	vec2 diff = UV - center;
	diff.x *= aspect;
	float dist = length(diff);
	float radius = progress * 0.7; // Adjust 0.7 to control max circle size
	if (dist > radius) {
	COLOR = circle_color;
	} else {
	COLOR = vec4(0.0, 0.0, 0.0, 0.0); // Transparent
	}
}