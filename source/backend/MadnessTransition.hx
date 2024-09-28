package backend;

import openfl.filters.ShaderFilter;
import shaders.MadnessTrans;
import flixel.util.FlxGradient;

class MadnessTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	var duration:Float;
	public function new(duration:Float, isTransIn:Bool)
	{
		this.duration = duration;
		this.isTransIn = isTransIn;
		super();
	}

	var shader:MadnessTrans;

	override function create()
	{
		var cam = FlxG.cameras.list[FlxG.cameras.list.length-1];
		cameras = [cam];

		shader = new MadnessTrans();
		shader.fade = isTransIn ? 0 : 1;
		if (cam.filters == null) cam.filters = [];
		cam.filters.push(new ShaderFilter(shader));

		FlxTween.tween(shader, {fade: isTransIn ? 1 : 0},duration,{onComplete: Void->{
			close();
			if(finishCallback != null) finishCallback();
			finishCallback = null;
		}});

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}