shader_type canvas_item;
uniform vec4 change_color:source_color;
uniform float health_range = 1.0;

void fragment(){
	vec4 init_color = texture(TEXTURE,UV);
	if (UV.y<1.0-health_range)
		COLOR = mix(init_color,change_color,init_color.a);
	//COLOR = vec4(1,1,1,1);
}