package weapons  ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import flixel.addons.nape.FlxNapeSprite;
import nape.phys.BodyType;
import flixel.addons.nape.FlxNapeState;
import nape.space.Space;
import flixel.addons.effects.FlxTrail;
import utils.*;


/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
class WeaponType_Normal extends WeaponBase
{

	public function new():Void {
		super();
		
		set_name(Globales.NORMAL_WEAPON);
	}
	
	override public function shoot():Void {
		
		if (FlxG.mouse.justPressed) {
			if (puedeDisparar) {
				dispararBody();
				puedeDisparar = false;
			}else {
				puedeDisparar = true;	
			}			
		}	

	}
	
	public function dispararBody():Void {
		
		var deltaY:Float  = mira.y - posBody.y;
		var deltaX:Float = mira.x -  posBody.x;
		
		var angle:Float = Math.atan2(deltaY, deltaX);
		
		Globales.currentState.add(new BulletType_Normal(mira.x +mira.width * 0.5, mira.y +mira.height * 0.5, angle));
		
	}

}