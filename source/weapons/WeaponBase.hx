package  weapons;

import flixel.FlxObject;
import flixel.FlxSprite;
import nape.phys.Body;
import nape.phys.BodyType;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeState;
import nape.geom.Vec2;
import nape.shape.Circle;
import utils.*;


/**
 * ...
 * @author asd
 */
class WeaponBase extends FlxObject
{
	
	var name:String;
	var punteroBody:Body;
	var puntero:Vec2 = new Vec2();
	
	var posBody:Vec2 = new Vec2();
	var punteroCircular:Circle;
	var mira:FlxSprite ;
	var puedeDisparar:Bool = false;
	
	var count:Int = 0;

	var weaponManagerOn:Bool = false;
	var listo:Bool = false;
	
	public function get_name():String { return name; }
	public function set_name(_name):Void { name = _name; }
	public function get_mira():FlxSprite {return mira;}	
	public function set_mira(_mira:FlxSprite) {mira = _mira;}
	
	public function new(){
		super(0, 0, 0, 0);		
		
		posBody =Globales.globalPlayerBodyIntermedioPos;
		
		agregarMira();		
	}
	
	
	function agregarMira():Void {
		
		// crea body de la Mira
		punteroCircular= new Circle(10);
		punteroCircular.sensorEnabled = true;		
		
		punteroBody = new Body(BodyType.STATIC, new Vec2(posBody.x, posBody.y-50));
		punteroBody.userData.nombre = "mira";	
		punteroBody.shapes.add(punteroCircular);
		//punteroBody.space = FlxNapeState.space;
	
		ajustarPuntero();	
		
		// En ajustar puntero, se deja liso el vector "puntero" para el sprite "mira"
		mira = new FlxSprite(puntero.x - 10, puntero.y - 10, AssetPaths.MIRA_IMAGE_PATH);
		Globales.currentState.add(mira);		

	}
	
	function ajustarPuntero():Void {
		
		var slingx:Int = cast(posBody.x,Int);
		var slingy:Int = cast(posBody.y,Int);
		var slingr:Int = 75;
		
		var potencia_tiro:Float = 10;
		var shootAngle:Float = 0;
		var shootRadians:Float = 0;		
		
		var distanceX:Float=puntero.x-slingx;
		var distanceY:Float=puntero.y-slingy;
					
		if (distanceX*distanceX+distanceY*distanceY>slingr*slingr) {
			shootRadians=Math.atan2(distanceY,distanceX);
			shootAngle = shootRadians * (180 / Math.PI);
			//FlxG.log.add("Radians mira: " + shootAngle);
			puntero.x=slingx+slingr*Math.cos(shootRadians);
			puntero.y=slingy+slingr*Math.sin(shootRadians);			
		}
						
		/* Actualizamos posiciones */
			if (mira != null)
				mira.setPosition(puntero.x -10, puntero.y -10);	
	}
		
	public function limpiar():Void {
			
		for ( b in FlxNapeState.space.bodies) {
			var body:Body = b;
			if (body.userData.nombre == "mira") {
				FlxNapeState.space.bodies.remove(body);
				punteroBody = null;
			}			
		}

		mira.destroy();

	}
	
	public function shoot() {}
	
	override public function update():Void {
		// bandera para que no ejecute la primer vuelta
		if (mira.visible) {
			if (listo) {
				if (Globales.selectorArmas == null) {
					
					// Cuando Mueve Mouse
					puntero.x = FlxG.mouse.x;
					puntero.y = FlxG.mouse.y;
					
					ajustarPuntero();
					
					shoot();
				}			
			}
			
			listo = true;	
		}
	}
	
	override public function draw():Void {
		//if (mira.visible)
			mira.draw();
	}
	
	override public function destroy():Void {
		limpiar();
		super.destroy();
	}
	
}