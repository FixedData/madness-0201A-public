package states;

import openfl.display.BitmapData;
import flixel.system.FlxAssets.FlxShader;

class Test extends MusicBeatState
{

    var shader:Mask;

    var green:FlxSprite;

    override function create() {
        green = new FlxSprite().loadGraphic(Paths.image('madnessmenu/greenfun'));
        add(green);

        shader = new Mask(BitmapData.fromFile('assets/shared/images/madnessmenu/grid_funkin.png'));
        green.shader = shader;
        
        super.create();
    }

    override function update(elapsed:Float) {
        shader.update(elapsed);
        super.update(elapsed);
    }
}


//specifically made for the pause

class Mask extends FlxShader 
{

	@:glFragmentSource('
	#pragma header

	uniform float iTime;
    uniform sampler2D maskInput;
    uniform float speed;

	
	void main()
	{
		vec2 uv = openfl_TextureCoordv;
        vec4 ogTex = flixel_texture2D(bitmap, openfl_TextureCoordv);


        uv.x += iTime * speed;
        uv.y -= iTime * speed;

        uv = fract(uv);

        vec4 overlay = flixel_texture2D(maskInput, uv);

        ogTex.rgb = mix(ogTex.rgb,overlay.rgb,ogTex.a);

        if (overlay.a < 0.9) discard;

		gl_FragColor = ogTex;
		
	}

	')
	
	public function new(input:BitmapData)
	{
		super();
		this.iTime.value = [0,0];
        this.maskInput.input = input;
        this.speed.value = [0,0];
	}

	public function update(elapsed:Float) {
		this.iTime.value[0] += elapsed;
	}
}