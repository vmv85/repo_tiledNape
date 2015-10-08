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
		
		if (b.userData.id_object != null) {
			this.linked_id = b.userData.id_object;
		}
	
	}
	
	public function detonar():Void {
						
		for (bo in FlxNapeState.space.bodies) {
			if (this.linked_id == bo.userData.id) {
				var o: PlataformaVertical = cast(bo.userData.object, PlataformaVertical);
				FlxG.log.add("lo encuentra y lo activa");
				o.activate();
			}					
		}		
	}
	
}