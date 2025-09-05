shader_type canvas_item;


void fragment(){
	//vec4 init_color = texture(TEXTURE,UV);
	vec2 flip_uv = vec2(1.0-UV.x,UV.y);
	COLOR = texture(TEXTURE,flip_uv);
}
