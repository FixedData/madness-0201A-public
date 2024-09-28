package options;

import backend.MadnessTransition;
import flixel.FlxSubState;
import objects.AttachedSprite;
import states.MainMenuState;
import backend.StageData;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	var grpOptions:FlxTypedGroup<FlxText>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:String) {
		switch(label) {
			// case 'Note Colors':
			// 	openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
		}
	}


	var glow:AttachedSprite;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('madnessmenu/fp'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		glow = new AttachedSprite('madnessmenu/credits/glows');
        glow.copyAlpha = false;
        glow.alpha = 0.7;
        add(glow);        

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:FlxText = new FlxText(50,0,0,options[i].toUpperCase(), 60);
			optionText.font = 'Impact';
			optionText.screenCenter(Y);
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			optionText.ID = i;
			grpOptions.add(optionText);


			// var shadow = new FlxText(optionText.x - 10,optionText.y + 10,0,options[i].toUpperCase(), 60);
			// shadow.color = FlxColor.BLACK;
			// shadow.font = 'Impact';
			// insert(members.indexOf(grpOptions),shadow);


			
		}




		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function openSubState(SubState:FlxSubState) {
		if (SubState is BaseOptionsMenu || SubState is ControlsSubState || SubState is NotesSubState)
		{
			grpOptions.visible = false;
			glow.visible = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState() {
		grpOptions.visible = true;
		glow.visible = true;

		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('madness/beep'));
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new states.MadnessMenu());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(change:Int = 0) 
	{

		var prev = grpOptions.members[curSelected];
		prev.color = FlxColor.WHITE;

		curSelected = FlxMath.wrap(curSelected + change,0,options.length-1);

		var next = grpOptions.members[curSelected];
		next.color = FlxColor.RED;

		glow.sprTracker = next;
        glow.setGraphicSize(next.width + 25,next.height);
        glow.updateHitbox();
        glow.yAdd = (next.height - glow.height)/2;
        glow.xAdd = (next.width - glow.width)/2;
        glow.update(FlxG.elapsed);

		FlxG.sound.play(Paths.sound('madness/beep'));
	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}