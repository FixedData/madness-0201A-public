package shaders;
import flixel.system.FlxAssets.FlxShader;

//i like this shader
class NoiseShader extends FlxShader 
{

	@:isVar public var ratio(get,set):Float = 0;
	function set_ratio(value:Float):Float {
		this.ratioT.value = [value,value];
		return value;
	}

	function get_ratio():Float {
		return this.ratioT.value[0];
	}



	@:glFragmentSource('
	#pragma header

	uniform float iTime;
	uniform float ratioT;

	float noise2d(vec2 co){
	  return fract(sin(dot(co.xy ,vec2(1.0,73))) * 43758.5453);
	}
	
	void main()
	{
		vec2 uv = openfl_TextureCoordv;
		uv = uv*sin(iTime);
		vec3 col = vec3(noise2d(uv));

		vec4 c = flixel_texture2D(bitmap, (openfl_TextureCoordv.xy);

		gl_FragColor = vec4(mix(c.rgb,col,ratioT),c.a);
		
	}

	')
	
	public function new(ratio:Float = 0,vignette:Bool = false,pixelSize:Float = 1)
	{
		super();
		this.iTime.value = [0,0];
		this.ratioT.value = [ratio,ratio];
	}

	public function update(elapsed:Float) {
		this.iTime.value[0] += elapsed;
	}
}