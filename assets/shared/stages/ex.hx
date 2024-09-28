import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxTiledSprite;
import flixel.effects.particles.FlxEmitter;
import flxanimate.FlxAnimate;
import openfl.filters.ShaderFilter;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import objects.Character;
import flixel.group.FlxSpriteGroup;
import hxvlc.flixel.FlxVideoSprite;
import substates.GameOverSubstate;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import backend.Paths;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import backend.ClientPrefs;
import psychlua.LuaUtils;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.util.FlxGradient;

var introHasPlayed = false;
var bgShader;
var fireballs;
var bgVideo;
var rockL;
var rockR;
var exUI;
var dadRockGroup = [];

// temp if smokety wants to do smth more cool
var tempGradient;
var gradBeat:Bool = false;
var trickyStatic;
var text;
var staticTimer:FlxTimer;
var glitch;
var ground:FlxSprite;
var ground2:FlxSprite;
var contrastShader = game.createRuntimeShader('contrast');
var glowShader;
var glowThing:FlxSprite;
var doStatic:Bool = true;
var doDistractions:Bool = true;
var distractionCooldown:Float = 6;
var distractionCooldownTimer:FlxTimer;
var distractions;
var distractionChance:Float = 4;

var trickyLinesSing:Array<String> = [
	"SUFFER", "INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE",
	"MISJUDGED"
];

var screamTxt;
var darkened:Bool = false;
var laser:FlxTiledSprite;
var particleEmitter;
var gremlinHealthCap:Float = 1.8;
var gremlin:FlxAnimate;

var baseOppPos = [];


function getRock(x:Float,y:Float,rockName:String)
{
	var b = new FlxSprite(x,y);
	b.frames = Paths.getSparrowAtlas('stages/ex/rocks');
	b.animation.addByPrefix('i',rockName);
	b.animation.play('i');
	b.active = false;
	return b;

}

function onCreate()
{
	GameOverSubstate.deathSoundName = 'madness/exGameover';
	GameOverSubstate.loopSoundName = 'madness/gameover';
	GameOverSubstate.characterName = 'exbg';
	GameOverSubstate.endSoundName = 'madness/gameover confirm';

	FlxG.camera.bgColor = FlxColor.BLACK;
	FlxG.camera.antialiasing = ClientPrefs.data.antialiasing;
}

function onCreatePost()
{


    Paths.sound("healthPunch");
	staticTimer = new FlxTimer();
	distractionCooldownTimer = new FlxTimer();
	// not needed no more tbh
	var sky = new FlxSprite(0, 0).makeGraphic(1, 1);
	addBehindGF(sky);

	if (ClientPrefs.data.lowQuality)
	{
		sky.loadGraphic(Paths.image('stages/ex/sky'));
	}
	else
	{
		bgVideo = new FlxVideoSprite();
		bgVideo.bitmap.onFormatSetup.add(() ->
		{
			bgVideo.setGraphicSize(3892);
			bgVideo.updateHitbox();
		});
	
		if (bgVideo.load(Paths.video('expurgCloudsComp'), [':input-repeat=65535', ':no-audio']))
		{
			FlxTimer.wait(0.01, () -> bgVideo.play());
		}
	}



	addBehindGF(bgVideo);

	laser = new FlxTiledSprite(Paths.image("stages/ex/laser"), 947, 4000);
	laser.x = 1100;
	laser.y = -1000;
	laser.scrollFactor.set(0.6, 0.6);
	laser.visible = false;
	addBehindGF(laser);

	fireballs = new FlxSpriteGroup();
	addBehindGF(fireballs);

	screamTxt = new FlxText(sky.x + 3892, sky.y + 600, 0, 'HAAAAAAAAAAAAAAAAAAAAAAANK', 200);
	screamTxt.scale.set(3, 3);
	screamTxt.updateHitbox();
	screamTxt.font = 'Impact';
	addBehindGF(screamTxt);

	rockL = getRock(sky.x + 326, sky.y + 970,'rock_1');
	rockL.scrollFactor.set(0.9, 0.9);
	addBehindGF(rockL);

	rockR = getRock(sky.x + 2214, sky.y + 581,'rock_2');
	rockR.scrollFactor.set(0.9, 0.9);
	addBehindGF(rockR);

	ground = getRock(sky.x + 170, sky.y + 935,'ground_tricky');
	addBehindGF(ground);

	dadRockGroup.push(ground);
	dadRockGroup.push(dad);

	tempGradient = FlxGradient.createGradientFlxSprite(1, 1080, [FlxColor.TRANSPARENT, FlxColor.RED]);
	tempGradient.x = ground.x;
	tempGradient.y = ground.y - 300;
	tempGradient.scale.x = ground.width;
	tempGradient.alpha = 0.2;
	tempGradient.updateHitbox();
	addBehindBF(tempGradient);
	tempGradient.blend = BlendMode.ADD;
	tempGradient.active = false;

	particleEmitter = new FlxEmitter();
	particleEmitter.loadParticles(Paths.image('stages/ex/particle'), 150, 1, false);
	particleEmitter.width = 3000;
	particleEmitter.x = 600;
	particleEmitter.y = 1800;
	particleEmitter.alpha.set(1, 1, 0, 0);
	particleEmitter.lifespan.set(5, 10);
	particleEmitter.launchMode = FlxEmitterMode.SQUARE;
	particleEmitter.velocity.set(0, -700, 0, -1300, 0, -1500, 0, -1700);
	particleEmitter.scale.set(1, 1, 1, 1, 0.5, 0.5, 1, 1);
	particleEmitter.launchAngle.set(-90, -90);
	addBehindBF(particleEmitter);
	particleEmitter.start(false);
	
	if (ClientPrefs.data.lowQuality)
	{
		particleEmitter.maxSize = 10;
	}

	glowThing = new FlxSprite().makeGraphic(1000, 400, FlxColor.TRANSPARENT);
	glowThing.setGraphicSize(3000, 800);
	glowThing.updateHitbox();
	glowThing.setPosition(600, 1200);
	glowThing.blend = BlendMode.ADD;
	glowThing.visible = false;
	addBehindBF(glowThing);

	ground2 = getRock(sky.x + 444, sky.y + 1400,'ground_bf');
	addBehindBF(ground2);

	game.uiGroup.visible = false;
	game.uiGroup.active = false;

	var scoreTxt = game.scoreTxt;
	game.uiGroup.remove(scoreTxt);

	scoreTxt.visible = true;

	exUI = new FlxSpriteGroup();
	insert(game.members.indexOf(uiGroup), exUI);
	exUI.cameras = [camHUD];

	exUI.add(game.exBar);

	exUI.add(game.iconP1);
	exUI.add(game.iconP2);

	exUI.add(scoreTxt);

	scoreTxt.y += ClientPrefs.data.downScroll ? 60 : -40;

	game.iconP1.setPosition(850, ClientPrefs.data.downScroll ? -10 : 600);
	game.iconP2.setPosition(280, ClientPrefs.data.downScroll ? -15 : 585);
	var cameraFrame = new FlxSprite(2.5, 0, Paths.image('ui/camera things'));
	cameraFrame.antialiasing = ClientPrefs.data.antialiasing;
	cameraFrame.setGraphicSize(FlxG.width - 5);
	cameraFrame.updateHitbox();
	cameraFrame.y = FlxG.height - cameraFrame.height - 5;
	exUI.add(cameraFrame);

	var cameraFrame = new FlxSprite(2.5, 5, Paths.image('ui/camera things'));
	cameraFrame.antialiasing = ClientPrefs.data.antialiasing;
	cameraFrame.setGraphicSize(FlxG.width - 5);
	cameraFrame.updateHitbox();
	cameraFrame.flipY = true;
	exUI.add(cameraFrame);

	var recording = new FlxSprite();
	recording.frames = Paths.getSparrowAtlas('ui/recording');
	recording.animation.addByPrefix('i', 'rec instance 1', 24);
	recording.animation.play('i');
	recording.scale.set(cameraFrame.scale.x, cameraFrame.scale.x);
	recording.updateHitbox();
	exUI.add(recording);
	recording.y = cameraFrame.y + (14 * cameraFrame.scale.x) + 5;
	recording.x = 2.5 + (14 * cameraFrame.scale.x) + 5;

	game.cameraZoomMult = 1.1;
	game.camZooming = true;

	trickyStatic = new FlxSprite();
	trickyStatic.loadGraphic(Paths.image('madnessmenu/static'), true, 320, 180);
	trickyStatic.setGraphicSize(FlxG.width);
	trickyStatic.updateHitbox();
	trickyStatic.alpha = 0.6;
	trickyStatic.animation.add('i', [0, 1, 2], 24, true);
	trickyStatic.animation.play('i');
	trickyStatic.cameras = [camHUD];
	addBehindGF(trickyStatic);
	trickyStatic.visible = false;

	text = new FlxText();
	text.setFormat("Impact", 128, FlxColor.RED);
	text.bold = true;
	addBehindBF(text);

	Paths.sound("staticSound");

	if (ClientPrefs.data.shaders)
	{
	

		glitch = game.createRuntimeShader("glitch");
		glitch.setFloat("iTime", 10);
		glitch.setFloat("thresholdValue", 0.9);
		glitch.setFloat("lodValue", 200);

		camGame.filters = [new ShaderFilter(glitch)];

		glowShader = game.createRuntimeShader("wave");
		glowThing.shader = glowShader;

        contrastShader.setFloat('contrast', 1);
		camGame.filters.push(new ShaderFilter(contrastShader));
	}

	distractions = new FlxSpriteGroup();
	distractions.cameras = [camHUD];
	add(distractions);

	// to cache shit ig no idea how animate works with caching
	var distractionSign = new FlxAnimate();
	Paths.loadAnimateAtlas(distractionSign, "stages/ex/sign");
	// distractionSign.anim.addBySymbol("1","distraction1",24,false,887,723);
	// distractionSign.anim.addBySymbol("2","distraction2",24,false,1682,382);
	// distractionSign.anim.addBySymbol("3","distraction3",24,false,1222,273);
	// distractionSign.anim.addBySymbol("4","distraction4",24,false,1244,-717);
	// distractionSign.cameras = [camHUD];
	// distractionSign.visible = false;

	dad.preAnimationCallback = function(data:AnimationCallData)
	{
		if (data.AnimName == "idle" && darkened)
		{
			data.AnimName = "ending";
		}
	}

	gremlin = new FlxAnimate();

    gremlin.scale.set(0.75,0.75);
	Paths.loadAnimateAtlas(gremlin, "stages/ex/healthGremlin");
	gremlin.anim.addBySymbol("gremlin", "Health Gremlin", 20, false);
	gremlin.cameras = [camHUD];
	gremlin.visible = false;
	add(gremlin);

	// i got too lazy to write this fancy
	if (ClientPrefs.data.downScroll)
	{
		gremlin.flipY = true;
		gremlin.setPosition(630, 120);
	}
	else
	{
		gremlin.setPosition(630, 340);
	}
}

function onPause()
{
	if (bgVideo != null)
	{
		bgVideo.pause();
		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(bgVideo.resume))
				FlxG.signals.focusGained.remove(bgVideo.resume);
			if (FlxG.signals.focusLost.has(bgVideo.pause))
				FlxG.signals.focusLost.remove(bgVideo.pause);
		}
	}
}

game.updateIconsPosition = function()
{
	// nothing. fuck you
}

function onResume()
{
	if (bgVideo != null)
	{
		bgVideo.resume();
		if (FlxG.autoPause)
		{
			if (!FlxG.signals.focusGained.has(bgVideo.resume))
				FlxG.signals.focusGained.add(bgVideo.resume);
			if (!FlxG.signals.focusLost.has(bgVideo.pause))
				FlxG.signals.focusLost.add(bgVideo.pause);
		}
	}
}

function onStartCountdown()
{
	if (!introHasPlayed)
	{
		dad.visible = false;

		Paths.sound('madness/Trickyspawn');
		Paths.sound('madness/TrickyGlitch');
		FlxTimer.wait(0.5, () ->
		{
			FlxG.sound.play(Paths.sound('madness/Trickyspawn'));

			dad.visible = true;
			dad.playAnim('intro');

			FlxTimer.wait(0.7, () -> FlxG.sound.play(Paths.sound('madness/TrickyGlitch')));

			dad.animation.finishCallback = (f) ->
			{
				if (f == 'intro' && !introHasPlayed)
				{
					dad.dance();
					introHasPlayed = true;

					game.skipCountdown = true;
					game.startCountdown();

					game.playerStrums.forEach((f) ->
					{
						if (f.alpha == 1.0)
						{
							f.alpha = 0;
							var isDown = ClientPrefs.data.downScroll;
							f.y += isDown ? 20 : -20;
							FlxTween.tween(f, {alpha: 1, y: isDown ? f.y - 20 : f.y + 20}, 0.4, {ease: FlxEase.cubeOut});
						}
					});


					for (i in game.opponentStrums)
					{
						baseOppPos.push([i.x,i.y]);
						//breaks offsets?
						// FlxTween.shake(i,0.05,1,FlxAxes.XY,{type: 4});
					}
			
				}
			}
		});
	}

	return introHasPlayed ? LuaUtils.Function_Continue : LuaUtils.Function_Stop;
}

function spawnFireball()
{
	var speedRatio = FlxG.random.float(0.4, 1);
	var fireball = fireballs.recycle(FlxSprite);
	fireball.frames = Paths.getSparrowAtlas("stages/ex/fireball");
	fireball.animation.addByPrefix("fuck", "fire ball", 14 + (6 * speedRatio), true);
	fireball.animation.play("fuck");
	fireball.scrollFactor.set(0.3 + (0.3 * speedRatio), 0.3 + (0.3 * speedRatio));
	fireball.scale.set(0.2 + speedRatio, 0.2 + speedRatio);
	fireball.updateHitbox();
	fireballs.add(fireball);

	fireball.setPosition(FlxG.random.float(1900, 3500), -400);

	fireball.color = FlxColor.fromHSB(0, 1, speedRatio);

	var speed = 700 * speedRatio;

	fireball.velocity.set(-speed, speed);
}

var gremlinRunning:Bool = false;

function gremlinHit()
{
	if (gremlinRunning)
		return;

	gremlinRunning = true;
	//for somereason hes like centered for a frame???
	new FlxTimer().start(0.1,Void->
	{
		gremlin.visible = true;
	});

	gremlin.anim.play("gremlin");
	var prevPos = game.exBar.getPosition();
	// whoever looks at this forgive me
	new FlxTimer().start(1.1, function()
	{
			game.health -= 1;
			FlxTween.tween(game.exBar,{x:game.exBar.x + 50},0.2,{onComplete:function(_)
			{
				FlxTween.tween(game.exBar,{x:game.exBar.x - 50},0.2);
			}});

            FlxG.sound.play(Paths.sound("healthPunch"));
	});

	new FlxTimer().start(1.5, function()
	{
		gremlinRunning = false;
	});
}

var dick:Float = 0;
var glitchTime:Float = 0;
var glitchMult:Float = 1;
var glowTime:Float = 0;

function onUpdatePost(elapsed)
{

	for (i in 0...baseOppPos.length)
	{
		game.opponentStrums.members[i].x = baseOppPos[i][0] + FlxG.random.int(-3,3);
		game.opponentStrums.members[i].y = baseOppPos[i][1] + FlxG.random.int(-3,3);

	}

	dick += elapsed * 2;

	if (ClientPrefs.data.shaders)
	{
		glitchTime += elapsed * glitchMult;

		glowTime += elapsed;

		glowShader.setFloat("time", glowTime);
		glitch.setFloat("iTime", glitchTime);
	}

	rockL.y += Math.sin(dick) * 0.2;
	rockL.x += Math.cos(dick) * 0.2;
	rockL.angle = Math.cos(dick);

	rockR.y += Math.cos(dick) * 0.1;
	rockR.x += Math.sin(dick) * 0.1;
	rockR.angle = Math.sin(dick) * 0.25;

	for (i in dadRockGroup)
	{
		i.y += Math.sin(dick) * 0.1;
		i.x += Math.cos(dick) * 0.1;
	}

	tempGradient.alpha = FlxMath.lerp(tempGradient.alpha, 0.1, 0.1 * 60 * elapsed);

	fireballs.forEachAlive(function(spr)
	{
		// genius level cleanup
		if (spr.y > 2300)
		{
			spr.kill();
		}
	});

	text.angle = FlxG.random.int(-5, 5);
	trickyStatic.alpha = FlxG.random.float(0.2, 0.4);
}

var activeDistractions:Int = 0;

function distractionShit()
{
	if (distractionCooldownTimer.active || activeDistractions == 2)
		return;

	var distractionSign = distractions.recycle(FlxAnimate);
	Paths.loadAnimateAtlas(distractionSign, "stages/ex/sign");
	distractionSign.scale.set(0.7, 0.7);
	distractionSign.updateHitbox();
	distractionSign.setPosition(1280 * (1 - distractionSign.scale.x), 720 * (1 - distractionSign.scale.y));
	distractionSign.anim.addBySymbol("1", "distraction1", 24, false, 887 * distractionSign.scale.x, 1223 * distractionSign.scale.y);
	distractionSign.anim.addBySymbol("2", "distraction2", 24, false, 1982 * distractionSign.scale.x, -202 * distractionSign.scale.y);
	distractionSign.anim.addBySymbol("3", "distraction3", 24, false, 1222 * distractionSign.scale.x, 273 * distractionSign.scale.y);
	distractionSign.anim.addBySymbol("4", "distraction4", 24, false, 1244 * distractionSign.scale.x, -1217 * distractionSign.scale.y);
	distractionSign.cameras = [camHUD];

	distractionSign.visible = false;
	distractions.add(distractionSign);
	activeDistractions++;
	distractionCooldownTimer.start(distractionCooldown);
	distractionSign.visible = true;
	distractionSign.anim.play("" + FlxG.random.int(1, 4), true);
	distractionSign.anim.onComplete = function()
	{
		distractionSign.kill();
		activeDistractions--;
	}
}

function onBeatHit()
{

	if (gradBeat && curBeat % 2 == 0)
	{
		tempGradient.alpha += 0.25;
	}

	if (FlxG.random.bool(15))
	{
		spawnFireball();
	}

	if (FlxG.random.bool(10) && doStatic)
	{
		staticShit();
	}

	if (ClientPrefs.data.unfairGimmicks)
	{
		if (FlxG.random.bool(distractionChance) && doDistractions)
		{
			distractionShit();
		}

		if (game.health > gremlinHealthCap && FlxG.random.bool(10))
		{
			gremlinHit();
		}
	}
}

var screaming:Bool = false;

function opponentNoteHitPre(note)
{
	if (screaming)
		note.noAnimation = true;
}

function onEvent(ev, v1, v2, time)
{
	switch (ev)
	{
		// case 'Add Camera Zoom':
		//     tempGradient.alpha += 0.5;

		case '':
			switch (v1)
			{
				case 'flashGradBeat':
					gradBeat = !gradBeat;

				case 'flashGrad':
					tempGradient.alpha += 0.5;
				case 'hankScream':
					FlxG.camera.shake(0.025, 1);
					screaming = true;
					dad.playAnim('hank', true);
					dad.blockIdle = true;
					FlxTween.tween(screamTxt, {x: -screamTxt.width - 8000}, 1, {
						onComplete: Void ->
						{
							screamTxt.visible = false;
							screamTxt.active = false;
							screaming = false;
							laser.visible = true;
							FlxG.camera.flash(FlxColor.RED, 0.25);
						}
					});

					if (ClientPrefs.data.shaders)
					{
						FlxTween.num(1, 2, 1, {onComplete: Void -> contrastShader.setFloat('contrast', 1.2)}, (f) ->
						{
							contrastShader.setFloat('contrast', f);
						});
					}

				case "Darken Stage":
					particleEmitter.velocity.set(0, -700 / 4, 0, -1300 / 4, 0, -1500 / 4, 0, -1700 / 4);
					particleEmitter.forEachAlive((f) ->
					{
						f.velocity.y = f.velocity.y / 4;
					});

					darkened = true;
					laser.visible = true;
					game.camGame.flash(FlxColor.WHITE, 0.6);
					boyfriend.color = FlxColor.BLACK;
					ground.color = FlxColor.BLACK;
					ground2.color = FlxColor.BLACK;
					rockL.color = FlxColor.BLACK;
					rockR.color = FlxColor.BLACK;
					tempGradient.visible = false;
					glowThing.visible = true;
					doStatic = false;
					FlxTween.tween(camHUD, {alpha: 0}, 1.2, {startDelay: 1.2});
					glitchMult = 1;

				case "End Shit":
					doDistractions = false;

					// too lazy to make a black square lol

					if (ClientPrefs.data.shaders)
					{
						glitch.setFloat("isEnabled", 1.0);
						FlxTween.num(200, 20, 1.4, {}, function(value)
						{
							glitch.setFloat("lodValue", value);
						});

						FlxTween.num(1, 3, 1.4, {}, function(value)
						{
							glitchMult = value;
						});

						FlxTween.num(0.9, 0.2, 1.4, {}, function(value)
						{
							glitch.setFloat("thresholdValue", value);
						});
					}
					new FlxTimer().start(1.4, function(_)
					{
						game.camGame.flash(FlxColor.BLACK, 1000);
					});

				case "Glitch Active":
					if (!ClientPrefs.data.shaders)
						return;
					glitch.setFloat("isEnabled", Std.parseFloat(v2));
				case "Glitch LOD":
					if (!ClientPrefs.data.shaders)
						return;
					glitch.setFloat("lodValue", Std.parseFloat(v2));
				case "Glitch Time":
					if (!ClientPrefs.data.shaders)
						return;
					glitchTime = Std.parseFloat(v2);
				case "Glitch Time Mult":
					if (!ClientPrefs.data.shaders)
						return;
					glitchMult = Std.parseFloat(v2);
				case "Glitch Pulse":
					if (!ClientPrefs.data.shaders)
						return;
					glitchTime = Std.parseFloat(v2);
					glitch.setFloat("isEnabled", 1.0);
				case "Distraction Chance":
					distractionChance = Std.parseFloat(v2);
				case "Distraction Cooldown":
					distractionCooldown = Std.parseFloat(v2);
			}
	}
}

// thanks kade
function staticShit()
{
	if (staticTimer.active)
		return;

	FlxG.sound.play(Paths.sound("staticSound"));
	trickyStatic.visible = true;
	text.visible = true;

	text.text = trickyLinesSing[FlxG.random.int(0, trickyLinesSing.length - 1)];

	text.setPosition(FlxG.random.float(dad.x - 100, dad.x + 220), FlxG.random.float(dad.y + 80, dad.y + 300));

	staticTimer.start(FlxG.random.float(0.3, 0.5), function(tmr)
	{
		trickyStatic.visible = false;
		text.visible = false;
	});
}

function onSectionHit()
{
	// game.cameraZoomMult = mustHitSection ? 1 : 1.1;
}

var oldScroll = [];

function onGameOver()
{
	oldScroll = [FlxG.camera.scroll.x, FlxG.camera.scroll.y];
}

function onGameOverStart()
{
	var dad = game.dad;
	game.remove(dad);
	FlxG.state.subState.add(dad);
	dad.x -= oldScroll[0];
	dad.y -= oldScroll[1];
	dad.playAnim('kill');
	dad.animation.finishCallback = (s) ->
	{
		dad.visible = false;
	}
}
