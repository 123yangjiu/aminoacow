shader_type canvas_item;

uniform float blue = 1.0;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	COLOR.b = blue;
}

void vertex(){
	VERTEX += vec2(0.0,0.0);
}