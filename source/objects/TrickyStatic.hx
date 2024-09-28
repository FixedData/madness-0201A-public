package objects;


class TrickyStatic extends FlxSprite
{
    public function new(x:Float = 0,y:Float = 0)
    {
        super(x,y);
        loadGraphic(Paths.image('madnessmenu/static'), true, 320, 180);
        animation.add('i', [0, 1, 2], 24, true);
        animation.play('i');
    }

    var fuck:Float = 0;

    override function update(elapsed:Float) {
        fuck+=elapsed * (Math.random() * 3);

        visible = Math.round(fuck) % 2 == 0; //make this actually more random looking later

        super.update(elapsed);
    }
}
