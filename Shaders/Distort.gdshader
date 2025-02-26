// Distotion
shader_type canvas_item;
//UV.x(horiz)= red (0=upper left , 1=upper right).
//UV.y(verti)= green (0=upper left , 1=lower left).


// A uniform is a kind of variable, and how we get info from the CPU to the shader.
// It cannot be manipulated in the shader, and is always the same for every pixel.
// "hint" sends a controller for this variable to the editor 
uniform float scale : hint_range(0.1, 10) = 1.0;
uniform float distort : hint_range(-1.0, 1.0) = 0.0;

// Called for every pixel the material is visible on.
void fragment() {
	vec2 distortedUV = UV;
	distortedUV.x += distortedUV.y * distort;

// "texture" just reads the image and re-draws it.
// (what to sample, where to sample it).
// multipling the UV by 2 makes the texture is sampled more densly,
// making it smaller.
// the bottom left of the sprite is now at the center( (0.5,0.5)*2.0=(1,1) )
	vec4 pixelColor = texture( TEXTURE, distortedUV * scale );
// so basically expands the area, without changing the actual size,
// and fills both axis with the last pixel color

// make the color what was already there
// the shader will draw whatever is asigned to the "COLOR" variable.
	COLOR = pixelColor;
}
