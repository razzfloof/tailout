// 2D SDF directional soft shadow overlay
// vilmt 29.04.2026

shader_type canvas_item;

uniform float softness: hint_range(0.001, 0.5) = 0.1;
uniform float angle: hint_range(-180.0, 180.0, 1.0) = 0.0;
uniform float max_distance: hint_range(0.0, 1000.0) = 100.0;

void fragment() {
	float theta = radians(angle);
	vec2 ray_direction = vec2(cos(theta), sin(theta));
	vec2 ray_origin = screen_uv_to_sdf(SCREEN_UV);
	
	float shadow = 0.0, cumulative_distance = 0.0001;
	
	for (int i = 0; i < 30 && cumulative_distance < max_distance; i++) {
		float signed_distance = texture_sdf(ray_origin + cumulative_distance * ray_direction);
		
		float fade = 1.0 - cumulative_distance / max_distance;
		float penumbra = 1.0 - max(0.0, signed_distance) / (softness * cumulative_distance);
		shadow = max(shadow, fade * penumbra);
		
		if (signed_distance <= 0.0) break;
		
		cumulative_distance += signed_distance;
	}
	
	COLOR.a *= shadow;
}
