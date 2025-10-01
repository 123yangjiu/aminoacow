shader_type canvas_item;
uniform vec4 outline_color:source_color;
uniform float outline_size = 1.0;

void fragment(){
	vec4 init_color = texture(TEXTURE,UV);
	vec2 uv_up = UV + vec2(0,0);
	COLOR = texture(TEXTURE,uv_up);
}