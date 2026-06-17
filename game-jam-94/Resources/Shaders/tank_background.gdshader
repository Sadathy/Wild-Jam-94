shader_type canvas_item;

uniform float blend_amount : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float height_map_scale : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D heightmap : repeat_enable; 
uniform sampler2D noise_texture : repeat_enable;

void fragment() {
	
	
	float depth = texture(heightmap, UV / height_map_scale).r;
	vec4 tex1 = texture(texture1, UV);
	vec4 tex2 = texture(texture2, UV);
	vec4 noise = texture(noise_texture, UV);
	
float blend = step(blend_amount, depth);
	vec4 blended_color = mix(tex2, tex1, blend);
	
	COLOR = blended_color * noise;
}