shader_type canvas_item;
//记录翻转状态
uniform float flip_progress;

void fragment(){
	//记录初始纹理
	vec4 color = texture(TEXTURE,UV);
	
	//计算翻转后的纹理
	vec2 flipped_uv = UV;
	if (flip_progress>0.0){
		//确定翻转过程曲线
		float flip_amount = abs(flip_progress -0.5)*2.0;
		
		//翻转
		flipped_uv.x = mix(UV.x,1.0-UV.x,flip_amount);
	}
	//应用纹理
	COLOR = texture(TEXTURE,flipped_uv);
	
	//plus效果
	if (flip_progress>0.0 && flip_progress <1.0){
		//修改透明度
		COLOR.a *=0.8;
	}
	COLOR.a = color.a;
}
