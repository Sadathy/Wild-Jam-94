shader_type canvas_item;

//this shader makes the tentacle wiggle slightly 
//it might be temporary as i am planning on looking into if this would be better done with an animation

//edge distortion
uniform float wave_frequency : hint_range(0.0, 20.0) = 20.0;
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_amplitude : hint_range(0.0, 0.05) = 0.025;

//colour controls
uniform float colour_r : hint_range(0.0, 1.0, 0.1);
uniform float colour_g : hint_range(0.0, 1.0, 0.1);
uniform float colour_b : hint_range(0.0, 1.0, 0.1);


void fragment() {
	// Called for every pixel the material is visible on.
	
//edge distortion
	vec4 col = texture(TEXTURE, UV);
	vec2 offset = vec2(0.0);
	offset.x = sin(UV.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
	offset.y = 0.0;
	col = texture(TEXTURE, UV + offset);
	COLOR = col;
	
//colour controls
	COLOR.xyz = vec3(colour_r, colour_g, colour_b);


}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
