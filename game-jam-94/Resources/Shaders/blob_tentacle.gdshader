shader_type canvas_item;

//edge distortion
uniform sampler2D noise : repeat_enable;
uniform float wave_frequency : hint_range(0.0, 20.0) = 20.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_amplitude : hint_range(0.0, 0.05) = 0.025;
uniform float distortion_strength : hint_range(0.0, 0.1, 0.001) = 0.02;

//colour controls
uniform float colour_r : hint_range(0.0, 1.0, 0.1);
uniform float colour_g : hint_range(0.0, 1.0, 0.1);
uniform float colour_b : hint_range(0.0, 1.0, 0.1);



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
//edge distortion
	float noise_val = texture(noise, UV).r;
	vec2 distortion_offset = vec2(noise_val - 0.5) * 2.0 * distortion_strength;
	vec4 col = texture(TEXTURE, UV);
	vec2 offset = vec2(0.0);
	offset.x = sin(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
	offset.y = cos(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
	col = texture(TEXTURE, UV + offset + distortion_offset);
	COLOR = col;
	
//colour controls
	COLOR.xyz = vec3(colour_r, colour_g, colour_b);


}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
