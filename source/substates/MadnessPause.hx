package substates;

import objects.AttachedSprite;
import flixel.util.FlxStringUtil;
import states.Test.Mask;
import objects.TrickyStatic;
import shaders.NoiseShader;
import options.OptionsState;
import states.MadnessMenu;

using MadnessPause.HelpMe;

class MadnessPause extends MusicBeatSubstate
{
	var gridShader:Mask;
	var bg:FlxSprite;

	var uniScale:Float;
	var curSel:Int = 0;
	var options:FlxTypedGroup<FlxSprite>;
	var pausePortrait:FlxSprite;


    var pauseMusic:FlxSound;

	override function create()
	{


		var pauseString = FlxG.random.bool(5) ? "pauseOld" : "pauseNew";
        pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseString),true);
        pauseMusic.play();
        pauseMusic.volume = 0;
        FlxG.sound.list.add(pauseMusic);
        pauseMusic.fadeIn(1,0,0.1);
		if (pauseString == 'pauseOld')
        	pauseMusic.pitch = 0.75;

		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);
		bg.alpha = 0.3;

		var stc = new TrickyStatic();
		stc.setGraphicSize(FlxG.width);
		stc.updateHitbox();
		add(stc);
		stc.alpha = 0.2;

		var portraitName = getPausePortrait();

		pausePortrait = new FlxSprite(Paths.image('pause/chars/' + portraitName));
		pausePortrait.doSetGraphicSize(0, FlxG.height);
		pausePortrait.screenCenter(Y);
		pausePortrait.x = FlxG.width;
		add(pausePortrait);

		var fuckingOffset:Float = 0;
		if (portraitName == "bf")
			fuckingOffset = 50;
		FlxTween.tween(pausePortrait, {x: FlxG.width - pausePortrait.width + fuckingOffset}, 0.4, {ease: FlxEase.circOut});

		if (portraitName == 'bf')
		{
			pausePortrait.y += 100;
			pausePortrait.x -= 50;
			var pausePortrait1 = new FlxSprite(Paths.image('pause/chars/' + 'hank'));
			pausePortrait1.doSetGraphicSize(0, FlxG.height);
			pausePortrait1.screenCenter(Y);
			pausePortrait1.y += 100;
			pausePortrait1.x = FlxG.width + 50;
			insert(members.indexOf(pausePortrait),pausePortrait1);
			FlxTween.tween(pausePortrait1, {x: FlxG.width - pausePortrait1.width - 100}, 0.4, {ease: FlxEase.circOut});
		}

		var panel = new FlxSprite(-100).loadGraphic(Paths.image('pause/grad'));
		panel.doSetGraphicSize(0, FlxG.height);
		add(panel);

		uniScale = panel.scale.x;

		// used for the masking
		var panel2 = new AttachedSprite('pause/grad');
        panel2.sprTracker = panel;
		panel2.doSetGraphicSize(0, FlxG.height);
		add(panel2);
		panel2.shader = (gridShader = new Mask(Paths.image('pause/grid_funkin').bitmap));
		gridShader.speed.value = [0.05, 0.05];

		var panelEdge = new AttachedSprite('pause/Black');
        panelEdge.doSetGraphicSize(0, FlxG.height);
        panelEdge.sprTracker = panel;
        panelEdge.xAdd = 530 * panelEdge.scale.x;
		add(panelEdge);
		panelEdge.antialiasing = true;

		var topBar = new FlxSprite(0, -30).loadGraphic(Paths.image('pause/bar'));
		topBar.doSetGraphicSize(FlxG.width);
		topBar.screenCenter(X);
		add(topBar);

		var topBarEdge = new AttachedSprite();
        topBarEdge.makeGraphic(1, 1, FlxColor.RED);
		topBarEdge.scale.set(topBar.width, 5);
		topBarEdge.updateHitbox();
        topBarEdge.sprTracker = topBar;
        topBarEdge.yAdd = topBar.height - 2.5;
		add(topBarEdge);

		final time:String = FlxStringUtil.formatTime(Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset) / 1000);
		var timeText = new FlxText(0, 0, FlxG.width - 25, time, Std.int(topBar.height - 30) - 5);
		timeText.y = ((topBar.height - 30) - timeText.height) / 2;
		timeText.setFormat('Impact', timeText.size, FlxColor.RED, RIGHT);
		add(timeText);

		var songText = new FlxText(25, 0, 0, PlayState.SONG.song.toUpperCase(), Std.int(topBar.height - 30) - 5);
		songText.y = ((topBar.height - 30) - songText.height) / 2;
		songText.setFormat('Impact', songText.size, FlxColor.RED, LEFT);
		add(songText);

		var creditText = new FlxText(songText.x + songText.width, 0, 0, ('by: ' + getCredits()).toUpperCase(), Std.int(((topBar.height - 30) - 5) / 3));
		creditText.y = songText.y + songText.height - creditText.height - 15;
		creditText.setFormat('Impact', creditText.size, FlxColor.RED, LEFT);
		add(creditText);

		options = new FlxTypedGroup<FlxSprite>();
		add(options);

		gen();



        panel.x = -panel.width;
        FlxTween.tween(panel, {x: 0},0.2,{ease: FlxEase.circOut});

        for (i in [topBar,songText,creditText,timeText])
        {
            final prevY = i.y;
            i.y = -i.height;
            FlxTween.tween(i, {y: prevY},0.2,{startDelay: 0.1,ease: FlxEase.circOut});
        }

        
        // topBar.y = -topBar.height;
        // FlxTween.tween(topBar, {y: -30},0.2,{startDelay: 0.1,ease: FlxEase.circOut});


        // timeText.x = timeText.width;
        // FlxTween.tween(timeText, {x: 0},0.3,{startDelay: 0.2,ease: FlxEase.circOut});

        // songText.x = -songText.width;
        // FlxTween.tween(songText, {x: 25},0.3,{startDelay: 0.2,ease: FlxEase.circOut});
        
        // creditText.x = -creditText.width;
        // FlxTween.tween(creditText, {x: prevCreditX},0.3,{startDelay: 0.2,ease: FlxEase.circOut});




		super.create();

		changeSel();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function gen()
	{
		final tScale = uniScale * 0.9;
		final o = ['resume', 'restart', 'opt', 'exit'];
		for (k => i in o)
		{
			var t = new FlxSprite(75 + (k * 75), 100 + (k * 150));
			t.frames = Paths.getSparrowAtlas('pause/options');
			t.animation.addByPrefix('i', i + ' default');
			t.animation.addByPrefix('s', i + ' selected');
			t.animation.play('i');
			t.scale.set(tScale, tScale);
			t.updateHitbox();
			options.add(t);

            final tX = t.x;
            t.x = -t.width;
            FlxTween.tween(t, {x: tX},0.2, {ease: FlxEase.circOut,startDelay: 0.1 + (0.01 * k)});
		}
	}

	override function update(elapsed:Float)
	{

		gridShader.update(elapsed);
		super.update(elapsed);

		if (controls.UI_DOWN_P || controls.UI_UP_P)
			changeSel(controls.UI_DOWN_P ? 1 : -1);
		if (controls.ACCEPT)
			confirmSel();
	}

	function changeSel(sel:Int = 0)
	{
		// if (sel != 0)
			FlxG.sound.play(Paths.sound('madness/beep'));

		options.members[curSel].animation.play('i');

		curSel = FlxMath.wrap(curSel + sel, 0, options.length - 1);

		options.members[curSel].animation.play('s');
	}

	function confirmSel()
	{
		switch (curSel)
		{
			case 0:
				close();
			case 1:
				PauseSubState.restartSong();
			case 2:
				PlayState.instance.paused = true; // For lua
				PlayState.instance.vocals.volume = 0;
				MusicBeatState.switchState(new OptionsState());
				if (ClientPrefs.data.pauseMusic != 'None')
				{
					// FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
					// FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
					// FlxG.sound.music.time = pauseMusic.time;
				}
				OptionsState.onPlayState = true;
			case 3:
				#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;

				Mods.loadTopMod();

				MusicBeatState.switchState(new MadnessMenu());

				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
				FlxG.camera.followLerp = 0;
		}
	}

	function getCredits()
	{
		return switch (PlayState.SONG.song.toLowerCase())
		{
			case 'expurgation': 'jads and punkett';
			case 'madness': 'rozebud';
			case 'assassination': 'punkett';
			case _: 'uhhh idk';
		}
	}

	function getPausePortrait()
	{
		trace(PlayState.SONG.song.toLowerCase());
		return switch (PlayState.SONG.song.toLowerCase())
		{
			case 'expurgation': 'expurgation';
			case 'madness': '';
			case 'assassination': Conductor.songPosition / 1000 < 122 ? 'bf' : 'gruntfriend';
			case _: 'gruntfriend';
		}
	}

    override function close() {
        pauseMusic?.fadeTween?.cancel();
        pauseMusic?.destroy();
        super.close();
    }
}

class HelpMe
{
	public static function doSetGraphicSize(spr:FlxSprite, width:Float = 0, height:Float = 0)
	{
		spr.setGraphicSize(width, height);
		spr.updateHitbox();
		return spr;
	}
}
