shader_type canvas_item;

uniform vec2 node_size;

void fragment() {
	vec2 p = UV - 0.5;
	vec2 dpdx = dFdx(p), dpdy = dFdy(p);
	float l = length(p);
	vec2 gl = p / l;
	float dsdx = dot(dpdx, gl), dsdy = dot(dpdy, gl);
	float w = sqrt(dsdx * dsdx + dsdy * dsdy) * 2.0; // blur
	COLOR.a *= smoothstep(0.0, -w, l - 0.5);
}

