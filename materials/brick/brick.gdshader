shader_type canvas_item;

uniform sampler2D inside_gradient: source_color, filter_linear;
uniform float radius: hint_range(0.0, 20.0) = 10.0;
uniform float corner_thickness: hint_range(0.0, 30.0) = 15.0;

group_uniforms outline;
uniform vec4 outline_color: source_color;
uniform float outline_thickness: hint_range(0.0, 20.0) = 10.0;

group_uniforms shine;
uniform float shine_strength: hint_range(0.0, 3.0) = 1.0;
uniform float shine_thickness: hint_range(0.0, 40.0) = 20.0;
uniform float shine_progress: hint_range(0.0, 1.0);

vec3 box_sdfg(vec2 p, vec2 b) {
	vec2 w = abs(p)-b;
	vec2 s = vec2(p.x<0.0?-1.0:1.0,p.y<0.0?-1.0:1.0);
	float g = max(w.x,w.y);
	vec2  q = max(w,0.0);
	float l = length(q);
	return vec3((g>0.0)?l:g,
		s*((g>0.0)?q/l:((w.x>w.y)?vec2(1,0):vec2(0,1))));
}

varying vec2 v;

void vertex() {
	v = VERTEX * vec2(length(MODEL_MATRIX[0]), length(MODEL_MATRIX[1]));
}

void fragment() {
	vec2 s = v / UV;
	vec2 p = (UV - 0.5) * s;
	vec2 dpdx = dFdx(p), dpdy = dFdy(p);
	
	vec3 b = box_sdfg(p, 0.5 * s - radius);
	float dbdx = dot(dpdx, b.yz), dbdy = dot(dpdy, b.yz);
	
	float w = (abs(dbdx) + abs(dbdy)) * 1.5;
	
	float inner_mask = smoothstep(-w * 0.5, w * 0.5, -b.x + radius - outline_thickness);
	float outer_mask = smoothstep(0.0, w, -b.x + radius);
	float center = smoothstep(-w * 0.5, w * 0.5, -b.x + radius - outline_thickness - corner_thickness);
	
	const vec2 n_w = vec2(1.0, 0.0);
	const vec2 n_s = vec2(0.0, 1.0);
	const vec2 n_sw = vec2(sqrt(2.0), sqrt(2.0));
	const vec2 n_nw = vec2(sqrt(2.0), -sqrt(2.0));

	float d_w = dot(n_w, p);
	float d_s = dot(n_s, p);
	float d_sw = dot(n_sw, p);
	float d_nw = dot(n_nw, p);

	float w_w = fwidth(d_w);
	float w_s = fwidth(d_s);
	float w_sw = fwidth(d_sw);
	float w_nw = fwidth(d_nw);

	float m_right = smoothstep(-w_w, w_w, d_w);
	float m_down = smoothstep(-w_s, w_s, d_s);
	
	float t = (shine_progress - 0.5) * 1.2;
	float shine_mask = smoothstep(0.0, w_sw, shine_thickness - abs(d_sw - dot(n_sw, t * s)));
	
	float m_left_up = smoothstep(w_sw, -w_sw, d_sw - dot(n_sw, vec2(-s.x * 0.5, s.y * 0.5)));
	float m_left_down = smoothstep(w_nw, -w_nw, d_nw - dot(n_nw, vec2(-s.x * 0.5, -s.y * 0.5)));
	float m_right_down = smoothstep(-w_sw, w_sw, d_sw - dot(n_sw, vec2(s.x * 0.5, -s.y * 0.5)));
	float m_right_up = smoothstep(-w_nw, w_nw, d_nw - dot(n_nw, vec2(s.x * 0.5, s.y * 0.5)));
	
	float corner_left = (1.0 - m_right) * m_left_down * m_left_up * (1.0 - center);
	float corner_right = m_right * m_right_down * m_right_up * (1.0 - center);
	float corner_top = (1.0 - m_down) * (1.0 - m_left_down) * (1.0 - m_right_down) * (1.0 - center);
	float corner_bottom = m_down * (1.0 - m_left_up) * (1.0 - m_right_up) * (1.0 - center);
	
	vec4 c1 = texture(inside_gradient, vec2(UV.y, 0.0));
	c1.rgb -= corner_left * 0.3;
	c1.rgb -= corner_right * 0.3;
	c1.rgb -= corner_bottom * 0.4;
	c1.rgb += corner_top * 0.2;
	c1.rgb *= c1.a;
	
	vec4 c2 = outline_color;
	c2.a *= 1.0 - inner_mask;
	c2.rgb *= c2.a;
	
	vec4 c3 = c2 + c1 * (1.0 - c2.a);
	c3 *= outer_mask;
	
	c3 *= 1.0 + shine_mask * shine_strength;
	
	c3.rgb /= c3.a;
	COLOR *= c3;
}
