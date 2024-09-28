#pragma header

uniform float contrast;

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    //contrast
    color.rgb = ((color.rgb - 0.5) * max(contrast, 0.0)) + 0.5;

    gl_FragColor = color;

}