shader_type canvas_item;

uniform float speed : hint_range(0.0, 5.0) = 1.5;
uniform float cutoff : hint_range(0.01, 1.0) = 0.1;
uniform float smoothness : hint_range(0.001, 0.2) = 0.02;
uniform float fluid_cohesion : hint_range(5.0, 30.0) = 14.0;
uniform int number_of_blobs = 4;

//physics variables
uniform vec2 blob_velocity = vec2(0.0, 0.0);
uniform float velocity_pull : hint_range(0.0, 1.0) = 0.8;
uniform float movement_activity : hint_range(0.0, 5.0) = 4.0;

//colour controls
uniform float colour_r : hint_range(0.0, 1.0);
uniform float colour_g : hint_range(0.0, 1.0);
uniform float colour_b : hint_range(0.0, 1.0);


void fragment() {
    vec2 uv = UV - vec2(0.5);
    	
	//directional drag
	vec2 direction = blob_velocity * velocity_pull;
	
	//size of the base for the blobs
    float base = exp(-length(uv + direction * 0.15) * fluid_cohesion) * 50.0;
	    
	//generates offset for each blob so they dont overlap
    for (int i = 1; i <= number_of_blobs; i++) {
        float offset = float(i) * 23.45; 

	//blob movement speeds up with blob's velocity. first brackets is stationary movement, second is when moving
	float dynamic_time = (TIME * speed * 0.6) + (TIME * length(blob_velocity) * 4.0) + offset;

	//how far the blobs can go from the middle, first number is when its stationary, second when its moving
	float radius = mix(0.2, 0.27, clamp(length(blob_velocity) * 3.0, 0.0, 1.0));
     
	//sets each blobs orbit
        vec2 orbit = vec2(
            sin(dynamic_time * 0.7 + cos(dynamic_time * 0.4)),
            cos(dynamic_time * 0.5 + sin(dynamic_time * 0.8))
        ) * radius; 
	
	//pushes the blobs to create a trail the oposite way to where it's going
 	vec2 final_pos = orbit - direction;
              
        
	// Each  blob is 30% smaller than the last
	float blob_scale = 3.0 - (float(i) * 0.3); 
	 base += exp(-length(uv - final_pos) * fluid_cohesion) * blob_scale;
    }

    //make edges sharp
    float mask = smoothstep(0.15, 0.17, base);
    
	//colour controls
    COLOR = vec4(colour_r, colour_g, colour_b, mask);
	
}