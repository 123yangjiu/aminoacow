shader_type canvas_item;

// 发光颜色
uniform vec4 glow_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);
// 发光强度
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.5;
// 边框厚度
uniform float outline_thickness : hint_range(0.0, 0.05) = 0.01;
// 边缘检测灵敏度
uniform float edge_sensitivity : hint_range(0.1, 1.0) = 0.3;

void fragment() {
    // 获取原始颜色
    vec4 original_color = texture(TEXTURE, UV);
    float original_alpha = original_color.a;
    
    // 初始化边缘检测变量
    float is_edge = 0.0;
    float max_alpha = 0.0;
    
    // 采样周围多个点来检测最外围边缘
    int samples = 16; // 采样点数
    for (int i = 0; i < samples; i++) {
        // 计算采样角度
        float angle = 6.28318530718 * float(i) / float(samples);
        
        // 计算采样方向
        vec2 dir = vec2(cos(angle), sin(angle));
        
        // 计算采样UV（使用不同的距离进行采样）
        vec2 sample_uv_close = UV + dir * outline_thickness * 0.5;
        vec2 sample_uv_far = UV + dir * outline_thickness * 2.0;
        
        // 采样
        float alpha_close = texture(TEXTURE, sample_uv_close).a;
        float alpha_far = texture(TEXTURE, sample_uv_far).a;
        
        // 检测边缘：当前像素不透明，但远处采样点透明
        if (original_alpha > edge_sensitivity && alpha_far < edge_sensitivity) {
            is_edge = 1.0;
            break;
        }
        
        // 记录最大alpha值
        max_alpha = max(max_alpha, alpha_far);
    }
    
    // 额外检查：如果所有远处采样点都不透明，则不是最外围边缘
    if (max_alpha > edge_sensitivity && original_alpha > edge_sensitivity) {
        is_edge = 0.0;
    }
    
    // 计算最终颜色
    vec4 final_color = original_color;
    
    // 如果是边缘，应用发光效果
    if (is_edge > 0.5) {
        // 计算发光强度（基于距离）
        float glow_strength = glow_intensity;
        
        // 应用发光颜色
        final_color.rgb = mix(original_color.rgb, glow_color.rgb, glow_strength);
        final_color.a = max(original_alpha, glow_color.a * glow_strength);
        
        // 添加发光效果
        final_color.rgb += glow_color.rgb * glow_strength * 0.5;
    }
    
    COLOR = final_color;
}