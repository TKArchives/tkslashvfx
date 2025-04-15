shader_type canvas_item;

uniform float offset = 0.0;
uniform float weight_base = 0.6;
uniform float weight_effect = 1.0;
uniform vec4 color_base = vec4(1.0);
uniform vec4 color_effect = vec4(0.8);

void fragment() {
	vec2 uv = UV + vec2(1.0 - offset * 2.0, 0.0);
	bool is_base = uv.y < uv.x * weight_base && uv.x < 1.0;
	bool is_effect = uv.y < uv.x * weight_effect && uv.x < 1.0;
	COLOR = is_base ? color_base : is_effect ? color_effect : vec4(0.0);
}
