// grayscale/recolor Image (doesn't affect the empty pixels)
shader_type canvas_item;

//color to apply
uniform vec4 color : source_color = vec4(1.0) ;

void fragment(){
// original image
	vec4 pixelColor = texture(TEXTURE, UV);

	float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;

	vec4 grayScale = vec4(brightness, brightness, brightness, pixelColor.a);
	COLOR = grayScale * color;
}