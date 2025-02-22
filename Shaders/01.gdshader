shader_type canvas_item;



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}


//shader_type spatial;
//render_mode unshaded;
//
//uniform vec2 resolution : hint_range(0,1024);
//uniform float time : hint_range(0,10);
//uniform float strength : hint_range(0,1);
//
//void fragment()
//{
    //vec2 uv = UV;
    //vec2 distortedUV = uv + vec2(sin(uv.y * 10.0 + time) * 0.01 * strength, cos(uv.x * 10.0 + time) * 0.01 * strength);
    //vec4 col = texture(TEXTURE, distortedUV);
    //ALBEDO = col.rgb;
//}

//void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    //vec2 uv = fragCoord/iResolution.xy;
    //vec2 normal = (texture(iChannel0, uv).rg-.5)*vec2(1.,-1.)/15.;
    //vec4 fire = texture(iChannel2, uv);
    //vec4 distorted = texture(iChannel1, uv+normal);
    //fragColor = distorted;
//}
