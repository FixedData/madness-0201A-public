import states.MadnessMenu;
import flixel.FlxState;

class NGIntro extends FlxState
{

    var waveCount:Int = 0;
    var ng:FlxSprite;
    var snd:FlxSound;
    override function create() 
    {
        FlxG.mouse.visible = false;
        Main.fpsVar.visible = false; 
        FlxG.camera.bgColor = FlxColor.BLACK;

        ng = new FlxSprite();
        ng.frames = Paths.getSparrowAtlas('ng');
        ng.animation.addByPrefix('i','ng',24,false);
        ng.scale.set(0.75,0.75);
        ng.updateHitbox();
        ng.screenCenter();
        ng.antialiasing = ClientPrefs.data.antialiasing;
        ng.animation.finishCallback = (f)->
        {
            if (waveCount < 3) {
                ng.animation.play('i');
                waveCount++;
            }
            else
            {
                waveCount = 0;
                ng.animation.play('i');

                FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 1},1,{onComplete: leave});
            }

        }
        ng.alpha = 0.0001;
        add(ng);

        super.create();


        FlxTimer.wait(1,init);
    }

    function init()
    {
        ng.alpha = 1;
        ng.animation.play('i');
        snd = FlxG.sound.play(Paths.sound('madness/ngsplas'));
        snd.autoDestroy = true;
        snd.persist = true;
    }

    function leave(?_)
    {
        FlxG.switchState(new MadnessMenu());
    }

    override function update(elapsed:Float) 
    {
        if (ng.animation.curAnim != null && Controls.instance.ACCEPT)
        {
            snd?.stop();
            snd?.destroy();
            ng.visible = false;
            FlxTimer.wait(0.4,()->leave());

        }
        super.update(elapsed);
    }

    override function startOutro(onOutroComplete:() -> Void) 
    {
        FlxG.mouse.visible = true;
        FlxG.mouse.load(MadnessMenu.mouseGraphic,0.5);
        Main.fpsVar.visible = ClientPrefs.data.showFPS;
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.3);
        super.startOutro(onOutroComplete);
    }
}