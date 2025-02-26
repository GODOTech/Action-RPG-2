
shader_type canvas_item;

// this were changed
//uniform sampler2D depth_texture : hint_depth_texture;
//uniform sampler2D normal_roughness_texture : hint_normal_roughness_texture;

//hint_albedo is now source_color.
//hint_color is now source_color.

// This is to replace SCREEN_TEXTURE
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D distortionTexture;

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	vec4 screenColor = texture(screen_texture, distortedUV);
	COLOR = textureLod(screen_texture, distortedUV, 0.0);
}




//shader_type canvas_item;
//
//// This is to replace SCREEN_TEXTURE
//uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
//uniform sampler2D distortionTexture;
//
//void fragment() {
	//vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	//vec4 screenColor = texture(screen_texture, distortedUV);
	//COLOR = textureLod(screen_texture, distortedUV, 0.0);
//}
