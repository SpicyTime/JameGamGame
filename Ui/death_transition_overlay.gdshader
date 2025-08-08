shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0);

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);

	vec2 uv = UV - 0.5;
	uv.x *= 1.7778; // adjust for aspect ratio if needed
	float d = length(uv);

	float a = d * 4.0 * progress;

	// If progress is 1, fully black and opaque
	if (progress >= 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		COLOR = vec4(vec3(0.0), a);
	}
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
