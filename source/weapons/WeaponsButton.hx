package weapons   ;

import flixel.addons.effects.FlxTrail;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;
import utils.*;

/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
class WeaponsButton extends FlxSprite
{

	var nombre:String = "";
	var tipoArma:Int;
	
	var spriteOver:FlxSprite = null;
	var spriteOut:FlxSprite = null;
	
	var pathOver:String = "";
	var pathOut:String = "";
	
	var mira : FlxNapeSprite = null;
	
	var over:Bool = false;
	
	var _trail:FlxTrail;
	
	var offsetX:Int;
	var offsetY:Int;
	
	public function new( _tipoArma:Int, x:Int, y:Int) 	{
	
	
		super(x + 10, y + 10, null);
	
		offsetX = cast(Globales.globalPlayer.x - (x + 10), Int);
		offsetY = cast(Globales.globalPlayer.y - (y + 10),Int);
		
		setSprites(_tipoArma);
	
		spriteOut = new FlxSprite(this.x, this.y, pathOut);
		loadGraphicFromSprite(spriteOut);
	
		//_trail = new FlxTrail(this, AssetPaths.TRAIL_PATH, 10, 7, 0.4 , 0.05);
		//Globales.currentState.add(_trail);
				
		tipoArma = _tipoArma;
	
		nombre = getNombre(tipoArma);
	
		MouseEventManager.add(this, onClick, onClickUp, onMouseOver, onMouseOut);
	
	}
	
	function setSprites(tipo:Int):Void {
		
		if ( tipo == 0) {
			pathOut = AssetPaths.arma0;
			pathOver = AssetPaths.arma0Over;
		}else
		if ( tipo == 1) {
			pathOut = AssetPaths.arma1;
			pathOver = AssetPaths.arma1Over;
		}else
		if ( tipo == 2) {
			pathOut = AssetPaths.arma2;
			pathOver = AssetPaths.arma2Over;
		}else 
		if ( tipo == 3) {
			pathOut = AssetPaths.arma3;
			pathOver = AssetPaths.arma3Over;
		}else {
			pathOut = AssetPaths.arma3;
			pathOver = AssetPaths.arma3Over;			
		}
		
		
	}
	
	function getNombre( tipo:Int):String {
		
		var name:String="";
		
		if ( tipo == 1) {
			name = "DisparoNormal";
		}else
		if ( tipo == 2) {
			name = " ARMA DOS ";
		}
		
		return name;
		
	}
	
	function onClickUp(sprite:FlxSprite):Void {
		FlxG.log.add("click up arma: " + nombre);
	}
	
	function onClick(sprite:FlxSprite):Void	{
		
		
		
		if ( tipoArma == 0) {
			Globales.selectorArmas.changeWeapon(Globales.NO_WEAPON);
		}else
		if ( tipoArma == 1) {
			Globales.selectorArmas.changeWeapon(Globales.NORMAL_WEAPON);
		}else
		if ( tipoArma == 2) {
			Globales.selectorArmas.changeWeapon(Globales.MAGNET_WEAPON);
		}else
		if ( tipoArma == 5) {
			Globales.selectorArmas.changeWeapon(Globales.LINEARMAGNET_WEAPON);
		}
		
		
		Globales.selectorArmas.limpiar();
		Globales.selectorArmas = null;	
			
		
		
	}
	
	function onMouseOver(sprite:FlxSprite):Void {
		
		var _sprite = new FlxSprite(sprite.x, sprite.y, pathOver);
		loadGraphicFromSprite(_sprite);
		//spriteOver.loadGraphic(pathOver);
	}
	
	function onMouseOut(sprite:FlxSprite) :Void	{
		var _sprite = new FlxSprite(sprite.x, sprite.y, pathOut);
		loadGraphicFromSprite(_sprite);
	}
	
	public function updateWeaponPos():Void {
		this.x = cast(Globales.globalPlayer.x, Int) - offsetX;
		this.y = cast(Globales.globalPlayer.y, Int) - offsetY;
	}
	
	override public function draw():Void {
		
		super.draw();
		
		//if (spriteOver != null) spriteOver.draw();
		

	}
	
	
	
	override public function destroy():Void {
		
		if (_trail != null) {
			_trail.destroy();
			Globales.currentState.remove(_trail);
		}
		
		Globales.currentState.remove(this);
		
		super.destroy();
		
	}
}