shader_type canvas_item;

uniform bool enable = false;

void fragment() {
	if (enable) {
		COLOR = vec4(1.0);
	}
}
