package weapons  ;

import flixel.addons.effects.FlxWaveSprite.WaveMode;
import flixel.FlxG;
import flixel.util.FlxColor;
import nape.geom.Vec2;
import utils.*;


/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
class WeaponType_Magnet extends WeaponBase
{

	var bullet : BulletType_Magnet;	
	var radioAtraccion:Int;
	var changeRadio:Int = 50;
	var debugText:TextTimer;

	
	public function new(){
		super();		
		set_name(Globales.MAGNET_WEAPON);
		radioAtraccion = 100;
	}
	
	override public function shoot():Void {
		
		if (FlxG.mouse.pressed) {
			activeMagnetism();
		}else {
			if (bullet!= null && bullet.activo) deactivateMagnetism();
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
	
	function deactivateMagnetism():Void	{
		
		if (bullet!=null) {
			bullet.desactivar();		
		}
		
	}
	
	function activeMagnetism():Void {
				
		if (bullet == null) {
			bullet = new BulletType_Magnet(cast(mira.x + mira.width, Int), cast(mira.y + mira.height, Int), radioAtraccion);
			Globales.currentState.add(bullet);
		}else {	
			if (!bullet.activo) {
				bullet.activar();
			}
			bullet.bodyBullet.position.x = puntero.x-10;
			bullet.bodyBullet.position.y = puntero.y-10;			
			bullet.refreshPos(cast(mira.x + mira.width, Int), cast(mira.y+ mira.height, Int), radioAtraccion);							
		}		
				
	}
	
	override public function destroy():Void {
		bullet.destroy();
		super.destroy();
	}
	
}