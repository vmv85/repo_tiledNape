package utils  ;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil.LineStyle;
import nape.geom.Vec2;
import nape.phys.BodyList;
import flixel.FlxG;
import openfl.display.Graphics;
import weapons.*;

/**
 * ...
 * @author ...
 */
class Globales
{
	public static var currentState:FlxNapeState = null;
	
	public static var gravityX : Int =  0;
	public static var gravityY : Int =  -20;
	
	public static var canvas:FlxSprite = null;
	public static var estiloLinea:LineStyle = { color: 0xFFFFFFFF, thickness: 3 };
	
	public static var globalPlayer:PlayerNape = null;
	public static var globalPlayerBodyIntermedioPos:Vec2 = null;
	public static var selectorArmas:WeaponManager = null;
	public static var globalTimeScale:Float = 1;
	
	public static var NO_WEAPON:String = "Weapon_None";
	public static var NORMAL_WEAPON:String = "Weapon_Normal";
	public static var MAGNET_WEAPON:String = "Weapon_Magnet";
	public static var LINEARMAGNET_WEAPON:String = "Weapon_LinearMagnet";	
	
	public static var bodyList_typeMagnet:BodyList = null;
	
	public static inline function clear(arr:Array<Dynamic>){
        #if (cpp||php)
        arr.splice(0,arr.length);           
		#else
        untyped arr.length = 0;
        #end
    }
		
}