shader_type canvas_item;

void fragment() {
	vec4 col = texture(TEXTURE,UV);
	float grey = (col.r + col.g + col.b) * 0.333;
	COLOR = vec4(grey, grey, grey, col.a);
}
