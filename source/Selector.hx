package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Ohmnivore
 */
class Selector extends FlxSprite
{
	private var still_setting:Bool = false;
	private var rect_begin:FlxPoint;
	private var rect_end:FlxPoint;
	
	private var line:LineStyle;
	private var fill:FillStyle;
	
	private var rect:FlxRect;
	
	public function new() 
	{
		super(0, 0);
		makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		
		rect_begin = new FlxPoint();
		rect_end = new FlxPoint();
		
		line = { };
		line.color = 0x99ff0000;
		line.thickness = 1;
		
		fill = { };
		fill.alpha = 0;
		fill.hasFill = false;
		
		rect = new FlxRect(0, 0, 0, 0);
	}
	
	override public function update():Void 
	{
		super.update();
		
		x = Reg.base.tileset.x;
		y = Reg.base.tileset.y;
		
		var begin_x:Float = rect_begin.x;
		if (rect_begin.x > rect_end.x)
			begin_x = rect_end.x;
		
		var begin_y:Float = rect_begin.y;
		if (rect_begin.y > rect_end.y)
			begin_y = rect_end.y;
		
		var rect_width:Float = Math.abs(rect_end.x - rect_begin.x);
		var rect_height:Float = Math.abs(rect_end.y - rect_begin.y);
		
		FlxSpriteUtil.fill(this, 0x00000000);
		FlxSpriteUtil.drawRect(this, begin_x, begin_y, rect_width, rect_height, 0x22ff0000, line, fill);
		rect.x = begin_x;
		rect.y = begin_y;
		rect.width = rect_width;
		rect.height = rect_height;
	}
	
	public function setFirstAnchor(X:Float, Y:Float, S:FlxSprite):Void
	{
		still_setting = true;
		rect_begin = getRelativePoints(X, Y, S);
	}
	
	public function setFinalAnchor(X:Float, Y:Float, S:FlxSprite):Void
	{
		if (still_setting)
			rect_end = getRelativePoints(X, Y, S);
		still_setting = false;
	}
	
	public function setMediumAnchor(X:Float, Y:Float, S:FlxSprite):Void
	{
		if (still_setting)
		{
			rect_end = getRelativePoints(X, Y, S);
		}
	}
	
	public function getRelativePoints(X:Float, Y:Float, S:FlxSprite):FlxPoint
	{
		var ret:FlxPoint = new FlxPoint();
		
		ret.set(Std.int(X / 16) * 16 + S.x % 16 - x,
			Std.int(Y / 16) * 16 + S.y % 16 - y);
		
		return ret;
	}
	
	public function getSelected():Array<Int>
	{
		var ret:Array<Int> = [];
		
		var y_count:Int = Std.int(rect.y / 16);
		var x_count:Int = Std.int(rect.x / 16);
		var x_limit:Int = Std.int((rect.x + rect.width) / 16);
		var y_limit:Int = Std.int((rect.y + rect.height) / 16);
		
		while (y_count < y_limit)
		{
			while (x_count < x_limit)
			{
				var index:Int = y_count * Std.int(Reg.base.tileset.width / 16);
				index += x_count;
				
				if (index >= 0 &&
					index < Std.int(Reg.base.tileset.width / 16) * Std.int(Reg.base.tileset.height / 16))
				{
					ret.push(index);
				}
				
				x_count++;
			}
			x_count = Std.int(rect.x / 16);
			
			y_count++;
		}
		
		return ret;
	}
	
}