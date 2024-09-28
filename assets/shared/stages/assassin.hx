import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import substates.GameOverSubstate;
import flixel.FlxG;
import backend.ClientPrefs;
import psychlua.LuaUtils;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.util.FlxGradient;

var gradient;
var lightning;
var gruntBopper;
var red;


var contrastShader;
var contrastAmount:Float = 1;
var lastLightningStrike:Int = 0;

var boyfriendAnimSuffix = '';
var gfAnimSuffix = '';


var black;
var introAnim;
var introCanContinue:Bool = false;

var bfDeath;
var crater;

function onCreate()
{
    GameOverSubstate.characterName = 'hank-gameover';
    GameOverSubstate.loopSoundName = 'madness/gameover';
    GameOverSubstate.endSoundName = 'madness/gameover confirm';
    GameOverSubstate.deathSoundName = 'madness/dead';

    game.addCharacterToList('handHank',0);

    black = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
    black.scale.set(FlxG.width,FlxG.height);
    black.updateHitbox();
    add(black);
    black.cameras = [camOther];

    introAnim = new FlxSprite();
    introAnim.frames = Paths.getSparrowAtlas('ui/intro_assassination');
    introAnim.animation.addByPrefix('i','assassination',24,false);
    introAnim.screenCenter();
    add(introAnim);
    introAnim.cameras = [camOther];
    introAnim.animation.finishCallback = (f)->
    {
        introAnim.visible = false;
        introAnim.active = false;

        introCanContinue = true;
        game.skipCountdown = true;
        game.startCountdown();
        FlxTween.tween(black, {alpha: 0},4);

        var prevZoom = game.defaultCamZoom;
        FlxG.camera.zoom += 0.5;
        game.defaultCamZoom = FlxG.camera.zoom;
        FlxTween.num(FlxG.camera.zoom,prevZoom,4.5,{ease: FlxEase.sineOut},(f)->{
            FlxG.camera.zoom = f;
            game.defaultCamZoom = f;

        });

        game.isCameraOnForcedPos = true;
        game.camFollow.y += -500;
        FlxG.camera.snapToTarget();
        FlxTween.tween(game.camFollow, {y: game.camFollow.y + 500},4.5, {ease: FlxEase.sineOut,onComplete: Void->game.isCameraOnForcedPos=false});
    }

}

function onCreatePost()
{
    FlxG.camera.bgColor = FlxColor.BLACK;

    var bg = new FlxSprite(-699,35).loadGraphic(Paths.image('stages/1/foreground'));

    var sky = new FlxSprite(0,-750).loadGraphic(Paths.image('stages/1/sky'));
    addBehindGF(sky);

    gradient = FlxGradient.createGradientFlxSprite(1, 1080, [FlxColor.TRANSPARENT,FlxColor.RED]);
    gradient.scale.x = bg.width;
    gradient.updateHitbox();
    addBehindGF(gradient);
    gradient.alpha = 0.7;
    // gradient.blend = LuaUtils.blendModeFromString('multiply');

    lightning = new FlxSprite(1500,-1000);
    lightning.frames = Paths.getSparrowAtlas('stages/1/lightning');
    lightning.animation.addByPrefix('1','lightningt1',24,false);
    lightning.animation.addByPrefix('0','lightningt2',24,false);
    lightning.animation.play('0');
    addBehindGF(lightning);


    var bgRocks1 = new FlxSprite(3000,275).loadGraphic(Paths.image('stages/1/back right'));
    bgRocks1.scrollFactor.set(0.9,0.9);
    addBehindGF(bgRocks1);

    var bgRocks = new FlxSprite( -624,550 - 141).loadGraphic(Paths.image('stages/1/back_rocks'));
    bgRocks.scrollFactor.set(0.9,0.9);
    addBehindGF(bgRocks);

    var light = new FlxSprite(2150,350 + 75).loadGraphic(Paths.image('stages/1/farting2'));
    addBehindGF(light);

    addBehindGF(bg);

    crater = new FlxSprite(bg.x + 1050,bg.y + 1090,Paths.image('stages/1/crater'));
    crater.visible = false;
    addBehindGF(crater);


    var light2 = new FlxSprite(0,-750 + 35).loadGraphic(Paths.image('stages/1/farting'));
    addBehindGF(light2);

    gruntBopper = new FlxSprite(2450,700);
    gruntBopper.frames = Paths.getSparrowAtlas('stages/1/grunt');
    gruntBopper.animation.addByPrefix('1','gruntbop',24,false);
    gruntBopper.animation.play('1');
    addBehindGF(gruntBopper);

    bfDeath = new FlxSprite(dad.x - 605,dad.y + -3350);
    bfDeath.frames = Paths.getSparrowAtlas('stages/1/boygruntDeath');
    bfDeath.animation.addByPrefix('i','die',24,false);
    bfDeath.visible = false;
    add(bfDeath);

    for (i in [bg,sky,gradient,lightning,bgRocks,bgRocks1,light,light2,gruntBopper,bfDeath]) i.antialiasing = ClientPrefs.data.antialiasing;

    game.gf.alpha = 0.00001;


    //needs to be in camgame for the shader
    red = new FlxSprite().makeGraphic(1,1,FlxColor.RED);
    red.scale.set(3500,3500);
    red.updateHitbox();
    red.screenCenter();
    red.scrollFactor.set();
    add(red);
    red.alpha = 0;

    
    // boyfriend.visible = false;

    

    // var light2 = new FlxSprite().loadGraphic(Paths.image('stages/1/farting2'));
    // addBehindGF(light2);

    if (ClientPrefs.data.shaders)
    {
        contrastShader = game.createRuntimeShader("contrast");
        contrastShader.setFloat("contrast",contrastAmount);
        game.camGame.filters = [new ShaderFilter(contrastShader)];

    }

}

function onStartCountdown()
{
    if (!introCanContinue)
    {
        introAnim.animation.play('i');
        FlxG.sound.play(Paths.sound('madness/weekintro'));
    }


    return introCanContinue ? LuaUtils.Function_Continue : LuaUtils.Function_Stop;
}


function onUpdatePost(elapsed)
{

    gradient.alpha = FlxMath.lerp(gradient.alpha,0,0.1 * 60 * elapsed);

   


    contrastAmount = FlxMath.lerp(contrastAmount,1,60 * elapsed * 0.05);

    red.alpha = FlxMath.lerp(red.alpha,0,60 * elapsed * 0.05);
    if (ClientPrefs.data.shaders)
    {
        contrastShader.setFloat("contrast",contrastAmount);
    }

}

function onBeatHit()
{
    if (curBeat % 2 == 0) 
    {
        gradient.alpha = 0.5;

    }

    gruntBopper.animation.play('1');



    if (curBeat >= 36 && curBeat % 2 == 0 && FlxG.random.bool(15) && curBeat - lastLightningStrike > 20)
    {
        red.alpha = 0.3;
        contrastAmount = 9;

        lightning.x = FlxG.random.float(700,2000);
        lightning.animation.play((FlxG.random.bool(50) ? '0' : '1'));

        FlxG.sound.play(Paths.sound('madness/lightning'),0.5);

        lastLightningStrike = curBeat;
    }
}


function onEvent(ev,v1,v2,time)
{
    if (ev == '')
    {
        switch (v1)
        {
            case 'sword':
                boyfriendAnimSuffix = '-alt';
                boyfriend.blockIdle = true;
                boyfriend.playAnim('sword');
                boyfriend.atlas.anim.onComplete = ()->{
                    boyfriend.blockIdle = false;
                }
                boyfriend.idleSuffix = boyfriendAnimSuffix;

            case 'bfDies':
                dad.visible = false;
                bfDeath.visible = true;
                bfDeath.animation.play('i');
            case 'turnBlack':
                black.alpha = 1;
                crater.visible = true;
                game.playerBar.changeFrame('Gf');
            case 'lookUp':
                boyfriendAnimSuffix = '-up';
                boyfriend.idleSuffix = boyfriendAnimSuffix;
                FlxTween.tween(black, {alpha: 0},1);
                bfDeath.visible = false;
                game.gf.alpha = 1;
                // game.playerBar.visible = false;
                game.uiGroup.members[game.uiGroup.members.indexOf(game.playerBar) + 1].loadGraphic(Paths.image('ui/girlfriend'));

            case 'grabHank':
                
                gfAnimSuffix = '-alt';
                gf.idleSuffix = gfAnimSuffix;

                gf.alpha = 1;//temp
                gf.blockIdle = true;
                gf.playAnim('grab');
                gf.atlas.anim.onComplete = ()->
                {
                    gf.danceIdle = false;
                    gf.blockIdle = false;
                    gf.danceEveryNumBeats = 4;
                }


                //flxtimer sucks for this instead of using an anim callback but idc
                FlxTimer.wait(0.16,()->{
                    GameOverSubstate.characterName = 'handHank';
                    boyfriendAnimSuffix = '';

                    game.triggerEvent('Change Character','bf','handHank');
                    boyfriend.blockIdle = true;

                    // boyfriend.y += 200;
                    // game.boyfriendCameraOffset[1] += -250;
                    boyfriend.playAnim('grabbed');
                    boyfriend.atlas.anim.onComplete = ()->
                    {
                        boyfriend.blockIdle = false;
                        boyfriend.dance();
                        boyfriend.atlas.anim.onComplete = ()->{}
                    }
                });

            case 'hankDie':
                gf.stunned = true;
                gf.playAnim('end');
                gf.blockIdle = true;
                gf.heyTimer = 9999;

                game.boyfriend.blockIdle = true;
                new FlxTimer().start(0.2,Void->{
                    game.boyfriend.stunned = true;
                });
                boyfriend.playAnim('killed');

            case 'fadeOut':
                FlxTween.tween(black,{alpha: 1},2);




        }
    }
}


function goodNoteHitPre(note)
{
    note.animSuffix = boyfriendAnimSuffix;
}


function opponentNoteHitPre(note)
{
    if (note.gfNote)
    {
        note.animSuffix = gfAnimSuffix;
    }
}