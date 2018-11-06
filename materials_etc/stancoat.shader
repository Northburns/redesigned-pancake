shader_type canvas_item;

uniform sampler2D grain;

void fragment() {
    vec4 c = texture(TEXTURE, UV);

    if(c.r > 0.8 && c.g > 0.8 && c.b > 0.8) {
        COLOR.rgba = vec4(texture(grain, SCREEN_UV).rgb, c.a);
    } else {
        COLOR.rgba= c;
    }    
}
