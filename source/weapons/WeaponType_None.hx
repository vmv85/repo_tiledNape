package weapons  ;

import flixel.FlxObject;
import flixel.FlxG;
import utils.Globales;
/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
class WeaponType_None extends WeaponBase
{	
	public function new() {	super();  set_name(Globales.NO_WEAPON); mira.visible = false; }
	
	override public function update() { super.update(); }
		
	override public function draw() { super.update(); }
		
}