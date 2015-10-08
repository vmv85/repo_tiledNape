package objects;
import flixel.FlxG;
import flixel.FlxSprite;
import nape.phys.Body;

/**
 * ...
 * @author ...
 */
class PlataformaVertical extends ObjetoBase
{
	
	public function new(x:Float,y:Float,body:Body) 
	{
		super(x, y,body.userData.id);		
		b = body;	
		b.userData.object = this;
	}
	
	override public function update():Void {
		
		
		if (activado) {
			behaviour();
		}
		
		super.update();
	}
	
	function behaviour():Void {
		FlxG.log.add("plataforma activada");
		this.b.position.y += 100*FlxG.elapsed;	
	}
		
}