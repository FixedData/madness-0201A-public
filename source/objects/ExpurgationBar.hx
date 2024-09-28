package objects;



class ExpurgationBar extends FlxTypedSpriteGroup<FlxSprite>
{

    public var isFlipped:Bool = false;
    public var scaleNum:Float = 0.85;
    public final maxCount:Int = 82;

    var bgFill:FlxSprite;

    var tallies:FlxSpriteGroup;

    public var hpFrame:FlxSprite;

    var _count:Int = 0;
    public function new(x:Float = 0,y:Float = 0)
    {
        super(x,y);

        bgFill = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
        add(bgFill);

        tallies = new FlxSpriteGroup();
        tallies.antialiasing = ClientPrefs.data.antialiasing;
        add(tallies);

        hpFrame = new FlxSprite();
        hpFrame.loadGraphic(Paths.image("ui/hpBar"));
        add(hpFrame);


        resetScale();

    }

    // public function changeFrameAnim(anim:String,force:Bool = false)
    // {
    //     if (hpFrame.animation.curAnim != null && hpFrame.animation.curAnim.name != anim && hpFrame.animation.curAnim.finished)
    //     {
    //         hpFrame.animation.play(anim,force);
    //     }

    // }


    function clearTallies()
    {
        for (i in 0...tallies.length)
        {
            var tally = tallies.members[0];
			tallies.remove(tally, true);
			tally.destroy();
        }
    }

    function fillTallies()
    {
        clearTallies();
        final startPosX = getTallyPos()[0] * scaleNum;
        final startPosY = getTallyPos()[1] * scaleNum;
        for (i in 0...maxCount)
        {
            var tally = new FlxSprite(startPosX,startPosY).loadGraphic(Paths.image('ui/reg_bar'));
            tally.scale.set(scaleNum,scaleNum);
            tally.updateHitbox();
            tally.active = false;
            tally.x -= tally.width * i;
            tallies.add(tally);
        }
    }

    public function resetScale(?newScale:Float)
    {
        newScale ??= scaleNum;
        scaleNum = newScale;

        hpFrame.scale.set(scaleNum,scaleNum);
        hpFrame.updateHitbox();

        fillTallies();
        buildFill();
    }

    public function remapToCount(val:Float,min:Float,max:Float)
    {
        return Std.int(FlxMath.remapToRange(val,min,max,0,maxCount));
    }

    public function setCount(val:Int = 0)
    {
        val = Std.int(FlxMath.bound(val,0,maxCount));
        for (k=>i in tallies.members)
        {
            i.visible = k <= val;
        }

        _count = val;
    }

    function getTallyPos()
    {
        return [602,28];
    }

    function repositionTallies()
    {
        final startPosX = getTallyPos()[0] * scaleNum;
        final startPosY = getTallyPos()[1] * scaleNum;
        for (k=>i in tallies.members)
        {
            i.x = this.x + startPosX;
            i.y = this.y + startPosY;
            i.x += isFlipped ? -(i.width * k) :(i.width * k);
            i.flipX = isFlipped;
        }
    }


    public function setFlip(b:Bool)
    {
        isFlipped = b;
        hpFrame.flipX = isFlipped;
        repositionTallies();
        buildFill();
    }

    function buildFill()
    {
        bgFill.scale.set(582 * scaleNum,36 * scaleNum);
        bgFill.updateHitbox();

        bgFill.setPosition(
           27 * scaleNum,20 * scaleNum
        );
    }


}