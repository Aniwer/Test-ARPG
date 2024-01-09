shader_type canvas_item;

// like '@export'
uniform bool active = false;

void fragment() {
	// (current texture and here is sprite2D, coordinate)
	vec4 previous_color = texture(TEXTURE, UV);
	// (R, G, B, Transparency)
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
	vec4 new_color = previous_color;
	if (active == true) {
		new_color = white_color;
	}
	COLOR = new_color;
}