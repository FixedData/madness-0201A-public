package objects;



class MadnessCheckbox extends FlxSprite
{
    var insideRed:FlxSprite;
    var black:FlxSprite;
    public var sprTracker:FlxSprite;
	public var daValue(default, set):Bool;
	public var copyAlpha:Bool = true;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

        makeGraphic(60,60,FlxColor.WHITE);

        black = new FlxSprite().makeGraphic(50,50,FlxColor.BLACK);
        insideRed = new FlxSprite().makeGraphic(45,45,FlxColor.WHITE);

		updateHitbox();
		daValue = checked;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyAlpha) 
            {
				alpha = sprTracker.alpha;
			}
		}
        copyPrimeVals(insideRed);
        copyPrimeVals(black);
        black.x = this.x + 5 * scale.x;
        black.y = this.y + 5 * scale.y;
        insideRed.x = black.x + 2.5 * scale.x;
        insideRed.y = black.y + 2.5 * scale.y;
        insideRed.color = color;

		super.update(elapsed);
	}



    function copyPrimeVals(obj:FlxSprite)
    {
        obj.alpha = alpha;
        obj.visible = visible;
        obj.scale.set(scale.x,scale.x);
        obj.updateHitbox();
    }

	private function set_daValue(check:Bool):Bool {
		if(check) 
        {
            color = FlxColor.RED;
		} 
        else
        {
            color = FlxColor.WHITE;
		}
		return check;
	}

    override function draw() {

        super.draw();

        if (visible && alpha != 0.0)
        {
            black.draw();
            insideRed.draw();
        }
    }


}