package utils ;
import flixel.text.FlxTextField;
import nape.geom.Vec2;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Santiago Gesualdo
 */

// Clase que muestra texto en pantalla, por un tiempo determinado y se desvance
 
class TextTimer extends FlxTextField
{
	var timeAcum:Float = 0;	
	var timeMax:Float = 0;
	
	var dissapear:Bool;
	
	public function new( pos:Vec2, _text: String, timeAlive:Float, sizeText:Int, color:UInt ) {
		super(pos.x, pos.y, FlxG.height, _text, sizeText ,true);
		this.color = color;		
		this.timeMax = timeAlive;
		this.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.YELLOW, 2);
		this.dissapear = false;
		
	}
	
	override public function update():Void {
		
		super.update();
		
		if (dissapear) {
			if (alpha == 0) {
				this.kill();
				return;
			}else {
				this.alpha -= 0.01;
			}
		}else {
			timer();
		}

		
	}
	
	public function setTimeAlive(timeAlive:Float) {
		timeMax = timeAlive;
		alpha = 1;		
		dissapear = false;
	}
	
	function timer():Void	{
		if (timeAcum < timeMax) {
			timeAcum += FlxG.elapsed;
		}else {
			dissapear = true;
		}
	}
	
	
}