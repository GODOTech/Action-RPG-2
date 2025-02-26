shader_type canvas_item;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	COLOR = pixelColor;
	
	//COLOR.rgb = COLOR.rbg;
	COLOR.rgb = COLOR.grb;
	COLOR.rgb = COLOR.ggg;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
