package objects;
import flixel.FlxSprite;
import flixel.system.debug.Console.Command;
import nape.phys.Body;
import nape.callbacks.Callback;
import utils.Callbacks;
import utils.Globales;
import nape.phys.BodyType;
/**
 * ...
 * @author ...
 */
class ObstaculoCuadrado extends ObjetoBase
{


	public function new(x:Float,y:Float,body:Body) 
	{
		super(x, y,body.userData.id);
		b = body;
		b.mass = 100;
		b.cbTypes.add(Callbacks.objetoRectangularCallback);
		b.userData.object = this;
		
		magneticed = false;
		
		// Propiedad magnetisable
		Globales.bodyList_typeMagnet.add(b);
		
	}
	
	public function isMagneticed():Bool {
		return magneticed;
	}
	
	public function allowRotation(flag:Bool) {
		b.allowRotation = flag;
		magneticed = flag;
	}
	
}