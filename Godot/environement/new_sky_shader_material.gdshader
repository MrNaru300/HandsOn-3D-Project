shader_type sky;

//sky shader tutorial https://youtu.be/SzNmHPr4vf8?si=K06f3wm2q8maL7bX

uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;
uniform sampler2D skyTexture;

void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	float col = clamp(EYEDIR.y/0.05,0.0,1.0);
	vec3 finalColor = mix(horizonColor,skyColor,col);
	COLOR  = texture(skyTexture,SKY_COORDS).rgb;
}
