shader_type canvas_item;

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// Fog density
uniform float density: hint_range( 0.0, 1.0 ) = 0.25;
// Fog speed
uniform vec2 speed = vec2(0.02, 0.01);

void fragment() {
// Make the fog slowly move
	vec2 uv = UV + speed * TIME;
// Sample the noise texture
	float noise = texture(noise_texture, uv).r;
// Convert the noise from the (0.0, 1.0) range to the (-1.0, 1.0) range
// and clamp it betwen 0.0 and 1.0 again
	float fog = clamp ( noise * 2.0 - 1.0, 0.0, 1.0 );

// Aply the noise texture
	COLOR.a *= fog * density ;
	
}
