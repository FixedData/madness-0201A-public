package shaders;

import flixel.graphics.tile.FlxGraphicsShader;



//too lazy to make this proper
//
class MadnessTrans extends FlxGraphicsShader
{
    @:isVar public var fade(get,set):Float = 0;
    @:noCompletion function set_fade(v:Float):Float
    {
        this.transPoint.value = [v,v];
        return v;
    }
    @:noCompletion function get_fade():Float
    {
        return this.transPoint.value[0];
    }

    //https://www.shadertoy.com/view/MffXWM
    @:glFragmentSource('
	#pragma header

    uniform float transPoint;
    
    void main()
    {
        // This is a uniform in my real program

		vec2 uv = openfl_TextureCoordv;
        float aspectRatio = openfl_TextureSize.x / openfl_TextureSize.y;
        vec2 uvOriginal = uv;
        vec2 uvCenter = (uv - 0.5) * 2.0;
        uv.x *= aspectRatio;
    
        uv = fract(uv * 10.0); // tiling factor
        uv -= 0.5; // shifts the 0.0 point to the middle of each tile
        uv *= 2.0; // changes the scale of each tile to -1 to 1
    

        // Edges-in grid
        float timing = (transPoint * 2.0 - 1.0) + min(length(uvCenter), 1.0);
        float value = step(timing, abs(uv.x)) + step(timing, abs(uv.y));
        
        
        vec4 to = vec4(0.0,0.0,0.0,1.0);
        vec4 from = flixel_texture2D(bitmap, uvOriginal);
        gl_FragColor = vec4(mix(from, to, min(value, 1.0)));
    }

	')


    public function new()
    {
        super();
        this.fade = 0;
    }
}