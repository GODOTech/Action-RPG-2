shader_type canvas_item;
render_mode unshaded;

uniform float force = 0.26;
uniform float scale = 0.01;
uniform bool debug = false;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	if (debug) {
		COLOR = vec4(texture(TEXTURE, UV).a);
	} else {	
		float mask = texture( TEXTURE, UV).a;
		vec2 disp = normalize(UV) * force * mask * scale;
		COLOR = texture(screen_texture, SCREEN_UV - disp);
	}
}

