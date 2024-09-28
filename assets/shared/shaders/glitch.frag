// Webcam Glitch
// By Leon Denise 08-06-2022
// Simple and handy glitch effect for digital screen



#pragma header


uniform float iTime;

uniform float lodValue;
uniform float thresholdValue;


uniform float isEnabled;
vec3 hash33(vec3 p3) // Dave Hoskins https://www.shadertoy.com/view/4djSRW
{
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy + p3.yxx)*p3.zyx);
}
vec2 hash21(float p)
{
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

void main()
{
    
    if (isEnabled == 1.0)
    {
        vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;

        vec2 uv = fragCoord/openfl_TextureSize.xy;
        
        // zoom out
    
        
        // animation
        float speed = 30.;
        float t = floor(iTime*speed);
        
        // randomness
        vec2 lod = openfl_TextureSize.xy/hash21(t)/lodValue;
        vec2 p = floor(uv*lod);
        vec3 rng = hash33(vec3(p,t));
        
        // displace uv
        vec2 offset = vec2(cos(rng.x*6.283),sin(rng.x*6.283))*rng.y;
        float fade = sin(fract(iTime*speed)*3.14);
        vec2 scale = 50. / openfl_TextureSize.xy;
        float threshold = step(thresholdValue, rng.z) ;
        uv += offset * threshold * fade * scale;
        
        // chromatic abberation
        vec2 rgb = 10./openfl_TextureSize.xy * fade * threshold;
        gl_FragColor.r = flixel_texture2D(bitmap, uv+rgb).r;
        gl_FragColor.g = flixel_texture2D(bitmap, uv).g;
        gl_FragColor.b = flixel_texture2D(bitmap, uv-rgb).b;
        gl_FragColor.a = 1.0;
        
        // crop
        gl_FragColor.rgb *= step(0.,uv.x) * step(uv.x,1.) * step(0.,uv.y) * step(uv.y,1.);
    }
    else
    {
        gl_FragColor = flixel_texture2D(bitmap,openfl_TextureCoordv);

    }

    
}