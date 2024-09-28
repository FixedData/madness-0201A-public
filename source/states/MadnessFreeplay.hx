package states;

//pointless for now
class FPMeta extends FlxText 
{
    public var name:String;
    // public var 
}


class MadnessFreeplay extends MusicBeatState
{

    var textGroup:FlxTypedGroup<FPMeta>;
    var currentSel = 0;

    override function create() {

        Difficulty.resetList();

        var bg = new FlxSprite(Paths.image('madnessmenu/fp'));
        add(bg);
        bg.setGraphicSize(FlxG.width);
        bg.updateHitbox();

        textGroup = new FlxTypedGroup<FPMeta>();
        add(textGroup);
        for (k=>i in ['assassination','expurgation'])
        {
            var t = new FPMeta(0,0,FlxG.width,i,60);
            t.alignment = CENTER;
            t.name = i;
            t.font = 'Impact';
            t.screenCenter(Y);
            textGroup.add(t);
        }





        super.create();
    }


    override function update(elapsed:Float) {
        super.update(elapsed);
        if ((controls.UI_DOWN_P || controls.UI_UP_P)) 
        {
            changeSel(controls.UI_UP_P ? -1 : 1);
        }
    }

    function changeSel(sel:Int = 0)
    {

        currentSel = FlxMath.wrap(currentSel + sel,0,textGroup.length-1);

    }

    function confirmSel()
    {

    }

}