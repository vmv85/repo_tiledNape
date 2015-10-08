package objects;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import nape.phys.Body;

/**
 * ...
 * @author ...
 */
class ObjetoBase extends FlxObject
{
	var b:Body;
	var magneticed:Bool;
	var tieneDetonador:Bool;
	var id:String;
	var linked_id:String;
	var activado: Bool;
	
	public function new(x:Float,y:Float, _id:String ) 
	{
		super(x, y);
		tieneDetonador = false;
		magneticed = false;		
		activado = false;
		id = _id;
	}
	
	// TAREA: no puedo activar el detonador
	
	public function activatedBehaviour():Void {}
	public function deactivateBehaviour():Void {}	

	public function activate():Void {
		FlxG.log.add("activated");
		activado = true;
	}
	
	public function deactivate():Void {
		activado = false;
	}
	
	override public function update():Void {
		
		super.update();
	}
	

	
}