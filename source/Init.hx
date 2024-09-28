import states.MadnessMenu;
import flixel.FlxState;

class Init extends FlxState
{

    override function create() {

        Paths.clearStoredMemory();

		//we aint using the mod folder so 
		
		// #if LUA_ALLOWED
		// Mods.pushGlobalMods();
		// #end
		// Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		backend.Highscore.load();


        if(FlxG.save.data != null && FlxG.save.data.fullscreen)
        {
            FlxG.fullscreen = FlxG.save.data.fullscreen;
        }

		if (FlxG.save.data.weekCompleted != null)
		{
			states.StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}


		

		FlxG.signals.postUpdate.add(up);
        super.create();

		#if debug FlxG.sound.playMusic(Paths.music('freakyMenu'),0.3); #end
        FlxG.switchState(new #if !debug NGIntro #else MadnessMenu #end ());
    }


	var upTime:Float = 0;
	var interval = 10;
	function up()
	{
		//if trciyk 2.0 experience
		if (ClientPrefs.data.trickyExperience)
		{
			if (FlxG.state is PlayState)
			{
				upTime += FlxG.elapsed;
				if (upTime >= interval)
				{
					interval = FlxG.random.int(5,10);
					upTime = 0;
					Sys.sleep(FlxG.random.float(0.5,2));
	
				}
			}
		}


	}
}