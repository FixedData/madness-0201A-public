package states;


import backend.Highscore;
import flixel.addons.display.FlxTiledSprite;
import options.OptionsState;
import flixel.math.FlxRect;
import openfl.display.BitmapData;
import flixel.input.mouse.FlxMouseEvent;
import flixel.addons.display.FlxBackdrop;
using states.MadnessMenu.SpriteHelper;


//really jank way of handling this
//couldve done way better but whatever
//yeah this sucks
enum Hovering {
    OPTIONS;
    ANYTHINGELSE;
}

class MadnessMenu extends MusicBeatState
{
    var hoverMode:Hovering = ANYTHINGELSE;

    public static var mouseGraphic:BitmapData = BitmapData.fromFile('assets/shared/images/madnessmenu/mouse.png');
    var uniScale:Float;

    var currentSel:Int = 0;
    var baseButtons:FlxTypedGroup<FlxSprite>;
    var optionsButton:FlxSprite;


    var circles:FlxSpriteGroup;

    var storyButton:FlxSprite;


    var storyDropDown:StorySubMenu;


    override function create() {
        

        Paths.sound("coming soon");
        FlxG.mouse.visible = true;
        FlxG.mouse.load(mouseGraphic,0.5);

        FlxG.camera.antialiasing = ClientPrefs.data.antialiasing;

        persistentUpdate = true;
        
        var back = new FlxSprite(Paths.image('madnessmenu/back'));
        back.setGraphicSize(FlxG.width);
        back.updateHitbox();
        back.screenCenter(Y);
        back.y += 100;
        add(back);

        uniScale = back.scale.x;

        var silh = new FlxBackdrop(Paths.image('madnessmenu/siloets'),X,20);
        silh.setScale(uniScale);
        silh.y = 300;
        silh.velocity.x = -50;
        silh.alpha = 0.3;
        add(silh);


        var fuck = [['hank','idle','100,300'],['gf','girlfriend','100,180'],['bf','bf','100,300']];
        final opt = FlxG.random.getObject(fuck);
        
        var pos = [];
        for (i in opt[2].split(',')) pos.push(Std.parseFloat(i));
        
        var char = new FlxAnimate(pos[0],pos[1],'assets/shared/images/madnessmenu/${opt[0]}');
        char.antialiasing = true;
        char.showPivot = false;
        char.anim.addBySymbol('i',opt[1],24,true);
        char.anim.play('i');
        char.scale.set(0.6,0.6);
        char.updateHitbox();
        add(char);

        
        storyDropDown = new StorySubMenu();
        add(storyDropDown);

        baseButtons = new FlxTypedGroup<FlxSprite>();
        add(baseButtons);

       

        storyButton = makeButton('storymode');
        storyButton.setPosition(1169 * uniScale,405 * uniScale);
        baseButtons.add(storyButton);

        storyDropDown.setPosition(storyButton.x + 40,storyButton.y - 320);
       

        var freeplayButton = makeButton('freeplay');
        freeplayButton.setPosition(storyButton.x + storyButton.width + 10,storyButton.y);
        baseButtons.add(freeplayButton);
        
        optionsButton = makeButton('options');
        optionsButton.setPosition(storyButton.x + storyButton.width + 10,760 * uniScale);
        add(optionsButton);

        var topBar = new FlxSprite(Paths.image('madnessmenu/top bar'));
        topBar.setScale(uniScale);
        add(topBar);

        new FlxTimer().start(FlxG.random.float(0.5,1.5),moveSquare,3);

        var bottomBar = new FlxSprite(Paths.image('madnessmenu/bottom bar'));
        bottomBar.setScale(uniScale);
        bottomBar.y = FlxG.height - bottomBar.height + 100;
        add(bottomBar);


        circles = new FlxSpriteGroup();
        add(circles);
        
        // var circle = new FlxSprite(181 * uniScale,167 * uniScale,Paths.image('madnessmenu/circle'));
        // circle.setScale(uniScale);
        // circle.alpha = 0.15;
        // add(circle);

        // var circle = new FlxSprite(1167 * uniScale,369 * uniScale,Paths.image('madnessmenu/circle'));
        // circle.setScale(uniScale * 2);
        // circle.alpha = 0.15;
        // add(circle);

        var scrollingNums = new FlxBackdrop(Paths.image('madnessmenu/numbers'),Y);
        scrollingNums.setScale(2);
        scrollingNums.x = FlxG.width - scrollingNums.width - 100;
        add(scrollingNums);
        scrollingNums.velocity.y = 75;
        scrollingNums.alpha = 0.15;

        var logo = new FlxSprite(0,86 * uniScale,Paths.image('madnessmenu/logo temp'));
        logo.setGraphicSize(820 * uniScale);
        logo.updateHitbox();
        logo.screenCenter(X);
        add(logo);


        //water mark shit from here


        var version = new FlxSprite(0,20,Paths.image('madnessmenu/version2'));
        version.setScale(uniScale);
        version.x = FlxG.width - version.width - 20;
        add(version);


        var ngPresents = new FlxSprite();
        ngPresents.frames = Paths.getSparrowAtlas('madnessmenu/ng');
        ngPresents.animation.addByPrefix('i','ng',24,false);
        ngPresents.animation.play('i');
        ngPresents.animation.finish(); //cheap
        ngPresents.animation.curAnim.curFrame = 0;

        ngPresents.setScale(uniScale - 0.1);
        add(ngPresents);
        ngPresents.x = FlxG.width - ngPresents.width - 20;
        ngPresents.y = FlxG.height - ngPresents.height - 20;
        FlxMouseEvent.add(ngPresents,(o)->{
            CoolUtil.browserLoad('https://www.newgrounds.com/collection/madness-day-2024');
        },null,(o)->o.animation.curAnim.curFrame = 1,(o)->o.animation.curAnim.curFrame = 0,false,true,false);

        var byDevsR = new FlxSprite(20).loadFrames('madnessmenu/created');
        byDevsR.animation.addByPrefix('i','created');
        byDevsR.animation.addByPrefix('vam','vam');
        byDevsR.animation.addByPrefix('grave','grave');
        byDevsR.animation.play('i');
        byDevsR.setScale(uniScale - 0.1);
        add(byDevsR);
        byDevsR.y = FlxG.height - byDevsR.height - 20;

        var graveBox = new FlxSprite(byDevsR.x,byDevsR.y + (23 * uniScale)).makeScaledGraphic(96*uniScale,36*uniScale);
        FlxMouseEvent.add(graveBox,(o)->{
            CoolUtil.browserLoad('https://x.com/konn_artist');
        },null,(o)->byDevsR.animation.play('grave'),(o)->byDevsR.animation.play('i'),false,true,false);

        
        var vamBox = new FlxSprite(byDevsR.x + (121 * uniScale),byDevsR.y + (23 * uniScale)).makeScaledGraphic(164*uniScale,36*uniScale);
        FlxMouseEvent.add(vamBox,(o)->{
            CoolUtil.browserLoad('https://x.com/vamazotz');
        },null,(o)->byDevsR.animation.play('vam'),(o)->byDevsR.animation.play('i'),false,true,false);


        

        Difficulty.resetList();
        var trophyKey = Highscore.getRating('expurgation',1) == 1.0 ? 'Trophy2' : 'trophy';

        var trophy = new FlxSprite().loadGraphic(Paths.image('madnessmenu/$trophyKey'));
        add(trophy);
        trophy.scale.set(0.4,0.4);
        trophy.updateHitbox();
        trophy.visible = FlxG.save.data.beatExpurgation;
        trophy.y = FlxG.height - trophy.height;
        trophy.screenCenter(X);

        if (trophyKey == 'Trophy2')
        {
            var anim = new FlxAnimate(300,90,'assets/shared/images/madnessmenu/gruny');
            anim.anim.addBySymbol('i','idle move',24);
            anim.anim.play('i');
            add(anim);
            anim.scale.set(0.5,0.5);
            anim.updateHitbox();
        }

        super.create();

        changeSel();


        //circle spawn stuff
        new FlxTimer().start(5,function(timer)
        {
            var circle = circles.recycle(FlxSprite);
            circle.setPosition(FlxG.random.int(200,900),FlxG.random.int(100,500));
            circle.loadGraphic(Paths.image('madnessmenu/circle'));
            circle.setScale(uniScale * 0.2);
            circle.antialiasing = ClientPrefs.data.antialiasing;
            circle.alpha = 0.08;
            circles.add(circle);
            var scaleTime = FlxG.random.float(7,12);
            FlxTween.tween(circle.scale,{x:2,y:2},scaleTime,{onComplete: function(_)
            {
                circle.kill();
            }});
            FlxTween.tween(circle,{alpha:0},scaleTime * 0.3,{ease:FlxEase.cubeIn,startDelay: scaleTime * 0.7});
            FlxTween.tween(circle,{alpha:0.15},1.4,{ease:FlxEase.cubeOut});

            timer.reset(FlxG.random.float(6,13));
        });

    }


    override function update(elapsed:Float) {
        super.update(elapsed);

        if ((controls.UI_LEFT_P || controls.UI_RIGHT_P) && hoverMode != OPTIONS) 
        {
            hoverMode = ANYTHINGELSE;
            
            if (!storyDropDown.open)
            changeSel(controls.UI_LEFT_P ? -1 : 1);
        }
        if (controls.ACCEPT)
            {
                
                
            if (storyDropDown.open)
                storyDropDown.confirm();
            else
                confirmSel();


            }
        if (controls.UI_DOWN_P || controls.UI_UP_P) 
        {
            if (storyDropDown.open)
                storyDropDown.changeSelection(controls.UI_DOWN ? 1 : -1);
            else
            {
                if (hoverMode == OPTIONS) hoverMode = ANYTHINGELSE;
                else hoverMode = OPTIONS;
                changeSel(0,true);
            
            }
            
        }

        if (FlxG.keys.justPressed.C) FlxG.switchState(new MadnessCredits());
            
            
        for (i in baseButtons)
        {
            final ID = baseButtons.members.indexOf(i);
            final isOver = FlxG.mouse.overlaps(i);
            if (isOver && (currentSel != ID || hoverMode == OPTIONS) && FlxG.mouse.justMoved && !storyDropDown.open) 
            {
                hoverMode = ANYTHINGELSE;
                changeSel(ID - currentSel);
            }
            if (isOver && FlxG.mouse.justPressed && !storyDropDown.open)
            {
                confirmSel();
            }
        }


        if ((controls.BACK || FlxG.mouse.justPressedRight) && storyDropDown.open)
        {
            closeStoryDropdown();

        }
        
        if (FlxG.mouse.overlaps(optionsButton) && hoverMode != OPTIONS && !storyDropDown.open)
        {
            hoverMode = OPTIONS;
            changeSel(0,true);
        }

        //shitty honestly shoudl rewrite but whatever
        if (FlxG.mouse.overlaps(optionsButton) && hoverMode == OPTIONS && !storyDropDown.open && FlxG.mouse.justPressed)
        {
            confirmSel();
        }

    }



    var dropdownCooldown:Bool = false;

    function closeStoryDropdown()
    {

        if (dropdownCooldown) return;
        dropdownCooldown = true;
        storyButton.animation.play("select");
       
        FlxTween.tween(storyDropDown,{y:storyButton.y - 320},0.4,{ease:FlxEase.cubeOut,onComplete:function(_)
        {
            dropdownCooldown = false;
            storyDropDown.open = false;

        }});

    }

    function moveSquare(?_)
    {
        var square = makeSquare();
        var initalX = 4 *uniScale;
        var squarePointX = FlxG.random.int(1,80);
        var squarePointY = FlxG.random.int(1,10);
        square.alpha = 0;
        //bad but whatever lol
        square.x = initalX + ((18 + 2) * squarePointX) * uniScale;
        square.y = ((18 + 2) * squarePointY) * uniScale;

        FlxTimer.wait(FlxG.random.float(1,3),()->{
            FlxTween.tween(square, {'scale.x': 1.25, 'scale.y': 1.25,alpha: 0.25},1, {ease: FlxEase.sineOut,onComplete: Void->{
                FlxTween.tween(square, {'scale.x': 1, 'scale.y': 1,alpha: 0},1, {ease: FlxEase.sineOut,onComplete: Void->{
                    moveSquare();
                    square.destroy();
                }});
            }});
        });
  
    }

    inline function makeSquare()
    {
        var size = Std.int(18*uniScale);
        var square = new FlxSprite().makeGraphic(size,size,FlxColor.RED);
        square.active = false;
        add(square);
        square.blend = ADD;
        return square;
    }

    function confirmSel()
    {


        FlxG.sound.play(Paths.sound('madness/select'));


        var button = hoverMode == OPTIONS ? optionsButton : baseButtons.members[currentSel];


        button.animation.play('confirm');

        if (hoverMode == OPTIONS)
        {
            MusicBeatState.switchState(new OptionsState());
            OptionsState.onPlayState = false;
            if (PlayState.SONG != null)
            {
                PlayState.SONG.arrowSkin = null;
                PlayState.SONG.splashSkin = null;
                PlayState.stageUI = 'normal';
            }
        }
        else {
            switch (currentSel)
            {
                case 0: openStoryDropdown(); //make this load into the specific song when we set that up
                case 1: MusicBeatState.switchState(new MadnessCredits());
            }
        }

    }
    




    function openStoryDropdown()
    {

        if (dropdownCooldown) return;
        dropdownCooldown = true;

        storyButton.animation.play("confirm");
        storyDropDown.open = true;

        FlxTween.tween(storyDropDown,{y:storyButton.y},0.4,{ease:FlxEase.cubeOut,onComplete: function(_)
        {
            dropdownCooldown = false;
        }});

    }

    var _prevSel:Int = 0;
    function changeSel(v:Int = 0,forceSound:Bool = false)
    {
        //if (v != 0 || forceSound) 
            FlxG.sound.play(Paths.sound('madness/beep'));

        for (i in baseButtons.members.concat([optionsButton]))
        {
            i.animation.play('i');
        }

        currentSel = FlxMath.wrap(currentSel + v,0,baseButtons.length-1);

        var obj = switch (hoverMode)
        {
            case OPTIONS: optionsButton;
            case ANYTHINGELSE: baseButtons.members[currentSel];
        }
        obj.animation.play('select');


    }

    function makeButton(path:String)
    {
        var spr = new FlxSprite();
        spr.frames = Paths.getSparrowAtlas("madnessmenu/" + path);
        spr.animation.addByPrefix('i',path + '0');
        spr.animation.addByPrefix('confirm',path + ' confirm');
        spr.animation.addByPrefix('select',path + ' select');
        spr.animation.play('i');
        spr.setScale(uniScale + 0.2);
        return spr;
    }
    
}





class StorySubMenu extends FlxSpriteGroup
{





    var topLineA:FlxTiledSprite;
    var topLineB:FlxTiledSprite;
    var lowLineA:FlxTiledSprite;
    var lowLineB:FlxTiledSprite;


    var options:Array<String> = ["HANK","???","COMING SOON"];

    public var curSelected:Int = 0;


    public var texts:FlxSpriteGroup;


    public var confirmed:Bool = false;
    public var open:Bool = false;


    var lTextCorner:FlxSprite;
    var rTextCorner:FlxSprite;

    public function new()
    {

        super();

        var buttonLine = new FlxSprite().loadGraphic(Paths.image("madnessmenu/button line"));
        add(buttonLine);

        texts = new FlxSpriteGroup();
        add(texts);
        for (i in 0...options.length)
        {

            var option = options[i];
            if (option == '???' && FlxG.save.data.beatExpurgation != null) {
                option = 'EXPURGATION';
                options[i] = 'EXPURGATION';
            }

            var text = new FlxText();
            text.setFormat(Paths.font("impact.ttf"),30,FlxColor.WHITE);
            text.updateHitbox();
            text.text = option;
            text.ID = i;
            text.x -= text.width * 1.2;

            //this sucks 
            switch (option)
            {
                case "HANK":
                    text.y = (82 * buttonLine.scale.y);

                case "???" | 'EXPURGATION':
                    text.y = (147 * buttonLine.scale.y);

                case "COMING SOON":
                    text.y = (261 * buttonLine.scale.y);


            }

            texts.add(text);

            lTextCorner = new FlxSprite().loadGraphic(Paths.image("madnessmenu/textCorners"));
            add(lTextCorner);
    
            rTextCorner = lTextCorner.clone();
            rTextCorner.flipX = true;
            add(rTextCorner);
    
            FlxMouseEvent.add(text,onClick,null,onHover,null,false,true,false);
    

        }


        //peak code
        topLineA = new FlxTiledSprite(Paths.image("madnessmenu/uselessRectangle"),1,1,true,false);
        topLineB = new FlxTiledSprite(Paths.image("madnessmenu/uselessRectangle"),1,1,true,false);
        lowLineA = new FlxTiledSprite(Paths.image("madnessmenu/uselessRectangle"),1,1,true,false);
        lowLineB = new FlxTiledSprite(Paths.image("madnessmenu/uselessRectangle"),1,1,true,false);
        add(topLineA);
        add(topLineB);
        add(lowLineA);
        add(lowLineB);


        changeSelection(0,false,false);

    }


    public function confirm()
    {

        if (confirmed || !open) return;
        FlxG.sound.play(Paths.sound('madness/select'));
        
        switch (options[curSelected])
        {
            case "HANK": 
                confirmed = true;
                loadSong('assassination');
                // MusicBeatState.switchState(new StoryMenuState());
            case 'EXPURGATION' | "???":

                #if !debug
                if (FlxG.save.data.beatAssasin == null) return;
                #end
                 
                confirmed = true;
                loadSong('expurgation');
                // MusicBeatState.switchState(new StoryMenuState());
            case "COMING SOON":
                FlxG.sound.play(Paths.sound("coming soon"));

                if (FlxG.random.bool(5))
                {
                    CoolUtil.browserLoad('https://c.tenor.com/I_JryQEIVu8AAAAd/tenor.gif');

                }

        }

    }

    function loadSong(name:String)
    {
        Difficulty.resetList();

        FlxG.state.persistentUpdate = false;
        var songLowercase:String = Paths.formatToSongPath(name);
        var poop:String = backend.Highscore.formatSong(songLowercase, 1);

        try
        {
            PlayState.SONG = backend.Song.loadFromJson(poop, songLowercase);
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = 1;

            // trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
        }
        catch(e:Dynamic)
        {
            trace('ERROR! $e');
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.state.update(FlxG.elapsed);
            return;
        }

        LoadingState.loadAndSwitchState(new PlayState());

    }



    var elapsedTime:Float = 0;
    var cornerSpeed:Float = 12;
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        var curTxt:FlxText = cast texts.members[curSelected];

        lTextCorner.x = FlxMath.lerp(lTextCorner.x,curTxt.x - lTextCorner.width,elapsed * cornerSpeed);
        lTextCorner.y = FlxMath.lerp(lTextCorner.y,curTxt.y,elapsed * cornerSpeed);
        
        rTextCorner.x = FlxMath.lerp(rTextCorner.x,curTxt.x + curTxt.width + lTextCorner.width,elapsed * cornerSpeed);
        rTextCorner.y = FlxMath.lerp(rTextCorner.y,curTxt.y,elapsed * cornerSpeed);


        topLineA.scrollX += elapsed * 16;
        topLineA.setPosition(lTextCorner.x + lTextCorner.width,lTextCorner.y);
        topLineA.width = rTextCorner.x - (lTextCorner.x + lTextCorner.width);

        lowLineA.scrollX -= elapsed * 12;
        lowLineA.setPosition(lTextCorner.x + lTextCorner.width,lTextCorner.y + lTextCorner.height - 1);
        lowLineA.width = rTextCorner.x - (lTextCorner.x + lTextCorner.width);

        elapsedTime+=elapsed * 1.5;
        curTxt.angle = ((curTxt.text == '???' || curTxt.text.toLowerCase() == 'expurgation') && Math.round(elapsedTime) % 2 == 0) ? FlxG.random.float(-3,3) : 0;
        

    }


    function onClick(text)
    {
        confirm();

    }

    function onHover(text)
    {
        if (!open || text.ID == curSelected || confirmed) return;
        changeSelection(text.ID,true);
    }


    public function changeSelection(change:Int = 0,?mouse:Bool = false,?playSound:Bool = true)
    {


        //if (v != 0 || forceSound) 
     
        curSelected = FlxMath.wrap(curSelected + change,0,options.length-1);

        if (mouse)
            curSelected = change;


        if (playSound)
        FlxG.sound.play(Paths.sound('madness/beep'));

        texts.forEach(function(spr)
        {
            spr.color = FlxColor.RED;
            spr.angle = 0;
        });

        var curTxt = texts.members[curSelected];

        curTxt.color = FlxColor.WHITE;

        //lTextCorner.setPosition(curTxt.x - lTextCorner.width,curTxt.y);
        //rTextCorner.setPosition(curTxt.x + curTxt.width + lTextCorner.width,curTxt.y);
        

    
    }

}



class SpriteHelper
{
    public static function setScale(spr:FlxSprite,scale:Float)
    {
        spr.scale.set(scale,scale);
        spr.updateHitbox();
        return spr;
    }

    public static function loadFrames(spr:FlxSprite,path:String)
    {
        spr.frames = Paths.getSparrowAtlas(path);
        return spr;
    }

    public static function makeScaledGraphic(spr:FlxSprite,w:Float,h:Float)
    {
        spr.makeGraphic(1,1);
        spr.scale.set(w,h);
        spr.updateHitbox();
        return spr;
    }


}