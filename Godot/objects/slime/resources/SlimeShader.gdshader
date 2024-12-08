shader_type spatial;

group_uniforms Impact_Shape;
uniform vec3 _impact_origin = vec3(1.0, 0.0, 0.0);
uniform float _impact_frequency = 5.0;
uniform float _impact_density = 5.0;
uniform float _impact_amplitude = 0.1;
uniform float _impact_blend = 0;
uniform float _impact_radius = 1.1;
uniform float _impact_anim = 0.0;
uniform float _impact_duration = 5;

// === IMPACT ===

float _GetRippleOrigin(vec3 vert, vec3 orig) {
	// distance of each vertex from the origin
	return length(orig - vert);
}

float _FadeRipple(float orig, float blend, float radius) {
	// create a radius
	float b = clamp(blend, 0.0, radius);
	return smoothstep(b, -radius, orig);
}

float _ComputeRipple(vec3 vert, vec3 orig, float blend, float radius, float freq, float dens, float ampl, float anim) {
	// calculate the intensity of the impact
	float o = _GetRippleOrigin(vert, orig);
	float fade = max(1.0 - anim/_impact_duration, 0);
	float i = smoothstep(0.05, ampl, sin(anim * freq - o * dens) * ampl * fade*fade);
	return i * _FadeRipple(o, blend, radius);
}


void vertex() {

	// Local to World conversion to add impact ripple

	vec3 w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;


	float impact_ripple = 0.0;
	if (_impact_anim  > 0.001) {
		impact_ripple = _ComputeRipple(w_pos,
		_impact_origin,
		_impact_blend,
		_impact_radius,
		_impact_frequency,
		_impact_density,
		_impact_amplitude,
		_impact_anim);
	}

	VERTEX += NORMAL * impact_ripple;
}

/*void fragment() {
	ALPHA = 0.8;
	METALLIC = 0.5;

	ALBEDO = vec3(0.1,0.9,0.1);
}*/

group_uniforms Color;
uniform sampler2D matcap : source_color, hint_default_black;
uniform float metalness : hint_range(0.0,1.0) = 1.0;

uniform sampler2D albedo_texture: source_color, filter_nearest;

void fragment() {
	vec4 tex = texture(albedo_texture, UV);//texture sampling along UV:  		https://www.reddit.com/r/godot/comments/1944wmq/comment/khe5d2x/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	vec2 matcap_uv = (NORMAL.xy * vec2(0.5, -0.5) + vec2(0.5, 0.5));//matcap shader:		https://godotshaders.com/shader/view-matcap/
	ALBEDO = tex.rgb;
	ALBEDO *= mix(vec3(1.0), texture(matcap, matcap_uv).rgb, metalness);
}