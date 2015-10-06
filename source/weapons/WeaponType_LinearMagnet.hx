package weapons  ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Circle;
import flixel.addons.nape.FlxNapeSprite;
import nape.phys.BodyType;
import flixel.addons.nape.FlxNapeState;
import nape.space.Space;
import flixel.addons.effects.FlxTrail;
import utils.*;
import utils.Globales;


/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */

/* 
 * Weapon Linear Magnet
 * - Disparo recto, sin gravedad, y cuando toca algo, se detiene y atrae con magnetismo
 * - Puede chocar con el escenario solamente (ver)
 * */
 
 
class WeaponType_LinearMagnet extends WeaponBase
{

	var radioAtraccion:Int ;
	var changedRadio:Bool;
	var changeRadio:Int = 50;
	var bullet:BulletType_LinearMagnet;
	var debugText:TextTimer;
	
	public function new():Void {
		super();
		
		radioAtraccion = 200;
		changedRadio = false;
		
		set_name(Globales.LINEARMAGNET_WEAPON);
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
		
		if (FlxG.mouse.wheel != 0) {
			if (FlxG.mouse.wheel > 0) {
				radioAtraccion += changeRadio;
			}else {
				if (radioAtraccion - changeRadio > 0) {
					radioAtraccion -= changeRadio;	
				}
			}	
			activateDebugText();
		}

	}
	
	function activateDebugText():Void{
		if (debugText == null) {
			debugText = new TextTimer(new Vec2(mira.x, mira.y+20), "RadioAtraccion: " + radioAtraccion, 1.0, 14, FlxColor.WHITE);	
			Globales.currentState.add(debugText);
		}else {
			debugText.setPosition(mira.x, mira.y+20);
			debugText.text = "RadioAtraccion: " + radioAtraccion;			
			debugText.setTimeAlive(1.0);
			debugText.revive();						
		}	
	}
	
	public function dispararBody():Void {
		
		var deltaY:Float  = mira.y - posBody.y;
		var deltaX:Float = mira.x -  posBody.x;
		
		var angle:Float = Math.atan2(deltaY, deltaX);
		
		bullet = new BulletType_LinearMagnet(mira.x +mira.width * 0.5, mira.y +mira.height * 0.5, angle, radioAtraccion);
		
		Globales.currentState.add(bullet);
		
	}
	
	override public function destroy():Void {
	
		//bullet.destroy();
		super.destroy();	
	}

}