shader_type canvas_item; // Sprite flash effect

// flash color
uniform vec4 color : source_color = vec4(1.0);
// flash strength
uniform float flashState : hint_range(0,1) = 0.5;

void fragment() {
//get the original sprite
	vec4 pixelColor = texture(TEXTURE, UV);
// mix lets you say what color gets interpolated against what color,
// and how to mix those 2 
	COLOR = mix(pixelColor, color, flashState);
}

// Each uniform can be animated by an animator player or tween
// If several objects have the same material, it will animate them all
// so, make it local to scene