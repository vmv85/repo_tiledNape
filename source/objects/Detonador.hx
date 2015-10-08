package objects;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import nape.phys.Body;
import utils.Callbacks;
import Type;
/**
 * ...
 * @author ...
 */
class Detonador extends ObjetoBase
{
	
	
	public function new(x:Float,y:Float, body:Body) 
	{
		super(x, y, body.userData.id);
		b = body;
		b.cbTypes.add(Callbacks.detonadorCallback);
		b.userData.object = this;
	
	}
	
	public function detonar():Void {
						
		for (bo in FlxNapeState.space.bodies) {
			if (this.id == bo.userData.id) {
				var o: PlataformaVertical = cast(bo.userData.object, PlataformaVertical);
				o.activate();
			}					
		}		
	}
	
}