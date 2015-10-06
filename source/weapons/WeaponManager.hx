package weapons  ;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;
import weapons.WeaponsButton;
import utils.Globales;

/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
 // TAREA: Prioridades a Grandes Rasgos (dispuesta a modificaciones):
 // TAREA: CONSTANTE. 1. Tipos de Arma, Mecanicas con Objeto
 // TAREA: CONSTANTE. 2. Pulir fisica del personaje.. NO PUEDE COLISIONAR CON LA MIRA.
 // TAREA: REDUCIR A UN BODY EL PERSONAJE.
 
 // ARMA 1: MAGNET.
 // ARMA 2: MAGNET LANZADO RECTOR.

 // TAREA: 1.3 Solucionar tema del objeto atraido que toca el magneto (joint posiblemente).

 // TAREA: Implementar algun enemigo.
 // TAREA: Implementar algun obstaculo.

 // TAREA: 2. Empezar a animar el personaje con sprites
 // TAREA: 3. Definir Level 0 o tutorial
 // TAREA: 4. Checkpoints del mapa y Menu Debug para prueba de niveles (para elegir en que checkPoint respawneas cuando moris)
 
class WeaponManager extends FlxSprite
{

	
	
	static inline var filas:Int = 3;
	static inline var columnas:Int = 3;
	static inline var espacioEntreX:Int = 2;
	static inline var espacioEntreY:Int = 5;
	static inline var sizeX:Int = 50;
	static inline var sizeY:Int = 50;

	var player:PlayerNape = null;
	
	var cambioDeArma:Bool = false;
	
	var currentArma: WeaponsButton = null ;
	var nextArma:WeaponsButton =null;
	
	public var armas:FlxTypedGroup<WeaponsButton> = new FlxTypedGroup<WeaponsButton>(8);
	
	public function new( x: Int , y: Int, _player:PlayerNape) :Void	{
		super(x, y, null);
		
		player = _player;
		
		var i:Int = 0;
		var j:Int = 0;
		var contadorArmas:Int =0;
		// tamaño de los contenedores 50x50
		
		FlxG.timeScale = 0.15;
		
		
		// aca creo la grilla de seleccion de arma
		var posInicialX:Int = x-75;
		var posInicialY:Int = y-175;
		
		for (i in 0...filas) {
			for (j in 0...columnas) {
				if (i == 1 && j == 1) {
					
				}else {
					var xBoton:Int = posInicialX + (i * sizeX);
					var yBoton:Int = posInicialY + (j * sizeY);
					//var offsetX:Int = player.x - xBoton;
					//var offsetY:Int = player.y - yBoton;
					var botonArma = new WeaponsButton(contadorArmas, xBoton, yBoton);// , offsetX, offsetY);
					armas.add(botonArma);					
				}	
				contadorArmas+= 1;				
			}			
		}
		
		Globales.currentState.add(armas);
		
	}
	
	public function changeWeapon(weaponName:String) {
		
		var weaponTo:FlxObject = null;
		
		if ( weaponName == "Weapon_None") {
			limpiar();
		}
		else
		if ( weaponName == "Weapon_Normal") {
			weaponTo = new WeaponType_Normal();
		}else 
		if ( weaponName == "Weapon_Magnet") {
			weaponTo = new WeaponType_Magnet();
		}else
		if ( weaponName == "Weapon_LinearMagnet") {
			FlxG.log.add("linearmagnet entra");
			weaponTo = new WeaponType_LinearMagnet();
		}else {
			FlxG.log.add(weaponName);
		}
		
		Globales.globalPlayer.setWeapon(weaponTo);
		//currentArma = weaponTo;
	}
	
	override public function update():Void {
		super.update();
		
		this.setPosition(player.x, player.y);
		
		for ( w in armas.members) {
			var we:WeaponsButton = cast(w, WeaponsButton);
			we.updateWeaponPos();			
		}
	}
	
	public function limpiar():Void {
		
		for ( w in armas.members) {
			var we:WeaponsButton = cast(w, WeaponsButton);
			MouseEventManager.remove(we);
			Globales.currentState.remove(we);
			we.destroy();
		}
		
		Globales.clear(armas.members);
		Globales.currentState.remove(armas);
		Globales.currentState.remove(this);
		
		FlxG.timeScale = 1;
		
	}
	
	override public function destroy():Void {
		Globales.currentState.remove(armas);
		Globales.clear(armas.members);
		Globales.selectorArmas = null;
	}
	
	
}