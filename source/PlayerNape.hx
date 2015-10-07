package ;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.Contact;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.phys.Material;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeState;
import nape.space.Space;
import flash.events.MouseEvent;
import flash.events.Event;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import openfl.display.BitmapData;
import flixel.util.FlxColor;
import utils.*;
import utils.Callbacks;
import utils.GameListeners;
import weapons.*;
import weapons.BulletType_LinearMagnet;
import weapons.BulletType_Normal;



/**
 * ...
 * @author ...
 */
 
 // test
class PlayerNape extends FlxObject
{
	// Tiene 3 bodies, asi le podemos asignar diferentes comportamientos a cada uno
		
		// este se usa para chocar contra plataformas (rectangular)
		public var bodyIntermedio:Body;
		
		// este se usa para chocar contra el piso (circular)
		var bodyInferior:Body;	
		
		var sSuperior:Circle;
		var sIntermedio:Polygon;
		var sInferior:Circle;
		
		var currentSpace:Space;
		
		var w1:WeldJoint;
		var w2:WeldJoint;
		
		var offsetY:Int = 50;		
		var tocaPiso:Bool;
		var tocaPlataforma:Bool;
		
		var agarre:Bool;
		var trepar:Bool;
	
		var tocaPlataformaIzq:Bool;	
		var topeY:Float;
		var topeX:Float;
		
		var sprite:FlxSprite = null;
		
		var bodyInferiorCallback:CbType = new CbType();
		var bodyIntermedioCallback:CbType = new CbType();
		var bodySuperiorCallback:CbType = new CbType();
		var pisoCollisionType:CbType = new CbType();
		var maxHeigth:Float;
		
		var estadoActual:Int = 0;
		var estadoCorriendo:Int = 1;
		var estadoSaltando:Int = 2;
		var estadoSubiendoPlataforma:Int = 3;
		
		var currentAgarre:Body = null;
		
		var punteroBody:Body = null;
		var miraActiva:Bool = false;
		var puntero:Vec2 = new Vec2();
		var mira:FlxNapeSprite;
		
		private static inline var maxVelX:Int = 200;
		private static inline var jumpForce:Int = 1200;//ESTO
		
		public var currentWeapon:FlxObject = null;
		
		var stQuieto:Int = 0;
		var stCaminandoDerecha:Int = 1;
		var stCaminandoIzquierda:Int = 2;
		var stSaltandoDerecha:Int = 3;
		var stSaltandoIzquierda:Int = 4;
		var currentState:Int = 0;
		
		var text :FlxText = null;
		var debugText2 :FlxText = null;

	public function new(_x:Float, _y:Float, space : Space ) {
		
		super(_x,_y,50,50);
		
		text = new FlxText(200, this.x, this.y, "No Name Game");
		text.setFormat(null, 12, FlxColor.BLACK, "left");
		text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.WHITE, 1);
		
		text.addFormat(new FlxTextFormat(0xE6E600, false, false, 0xFF8000));
		Globales.currentState.add(text);
		
		currentSpace = space;
		
		var pos:Vec2 = new Vec2(_x,_y);

		createBodyInferior(pos);
		createBodyIntermedio(pos);
		
		currentWeapon = new WeaponType_None();
		

		maxHeigth = bodyInferior.bounds.height + bodyIntermedio.bounds.height + bodyInferior.bounds.height;
				
		declararCallbacks();
		
		declararJoint();
		
		//crearAnimacion();
		
		pos.dispose();
		
	}
	
	function crearAnimacion():Void	{
		
		
		sprite = new FlxSprite(x, y);
		sprite.loadGraphic(AssetPaths.PLAYER_ANIM, true, 20, 40, true);
		
		sprite.animation.add("caminandoIzquierda", [0, 1, 2, 3, 4, 5, 6, 7], 30, true);
		sprite.animation.add("caminandoDerecha",   [8, 9, 10, 11, 12, 13, 14, 15], 30, true);
		sprite.animation.add("saltandoIzquierda", [16, 17, 18,17], 15, false);
		sprite.animation.add("saltandoDerecha", [19, 20, 21, 20], 15, false);
		sprite.animation.add("quietoDerecha", [13], 30, true);
		sprite.animation.add("quietoIzquierda", [5], 30, true);
		
		sprite.animation.play("quietoDerecha", true);		
		
	}
	
	function createBodyInferior(pos:Vec2):Void{
		// Body Circular Inferior		
		
		bodyInferior = new Body(BodyType.DYNAMIC, pos );
		bodyInferior.userData.nombre = "playerBodyInferior";
		bodyInferior.allowRotation = true;
		
		sInferior= new Circle(width * 0.35, null , Material.wood());
		sInferior.userData.nombre = "playerShapeBodyInferior";
		sInferior.material = Material.steel();
		bodyInferior.shapes.add(sInferior);
		
		bodyInferior.cbTypes.add(Callbacks.bodyInferiorCallback);
		
		bodyInferior.space = currentSpace;		
		
	}
	
	function createBodyIntermedio(pos:Vec2):Void {
		
		bodyIntermedio = new Body(BodyType.DYNAMIC,  pos );
		bodyIntermedio.allowRotation = false;
		bodyIntermedio.userData.nombre = "playerBodyIntermedio";
		
		sIntermedio= new Polygon(Polygon.box(width*0.65,height*0.65,false), Material.sand());
		sIntermedio.userData.nombre = "playerShapeBodyIntermedio";
		bodyIntermedio.shapes.add(sIntermedio);
		
		bodyIntermedio.cbTypes.add(Callbacks.bodyIntermedioCallback);
		
		bodyIntermedio.space = currentSpace;
		Globales.globalPlayerBodyIntermedioPos = bodyIntermedio.position;
				
	}

	function declararJoint():Void {
		w2 = new WeldJoint(bodyIntermedio, bodyInferior, new Vec2(bodyIntermedio.localCOM.x, bodyIntermedio.localCOM.y+25), bodyInferior.localCOM, Math.PI/4);
		w2.stiff = true;
		w2.space = FlxNapeState.space;
		
	}
	
	function onOffJoints():Void 	{
		w2.active = !w2.active;
	}
	
	function declararCallbacks():Void {
			
		GameListeners.PersonajeConAgarre = new InteractionListener(
			CbEvent.ONGOING, InteractionType.SENSOR, Callbacks.bodyIntermedioCallback, Callbacks.agarreCallback,
			function OnPersonajeConAgarre(e:InteractionCallback):Void {
				
				var bodyPersonaje:Body = e.int1.castBody;
				var bodyPlataforma:Shape = e.int2.castShape;
				
				if (!agarre) {	
					if (bodyPersonaje.bounds.y < (bodyPlataforma.bounds.y + bodyPlataforma.bounds.height * 0.9)) {
						if (bodyPlataforma.bounds.x > bodyPersonaje.bounds.x){
						   
							tocaPlataformaIzq = true;
							agarre = true;
							
							topeX = bodyPersonaje.bounds.x + bodyPersonaje.bounds.width / 2;
							topeY = bodyPlataforma.bounds.y - bodyPersonaje.bounds.height - bodyInferior.bounds.height;

							bodyPersonaje.position.x -= 2;
							bodyPersonaje.velocity.x = 0;
						}
						else if (bodyPlataforma.bounds.x < bodyPersonaje.bounds.x){
							
							agarre = true;
							tocaPlataformaIzq = false;

							topeX = bodyPersonaje.bounds.x - bodyPersonaje.bounds.width / 2;
							topeY = bodyPlataforma.bounds.y - bodyPersonaje.bounds.height - bodyInferior.bounds.height;

							bodyPersonaje.position.x += 2;
						}
					}
				}
				
			}
		
		);
		
		GameListeners.PersonajeConAgarreEnd = new InteractionListener(
			CbEvent.END, InteractionType.SENSOR, Callbacks.bodyIntermedioCallback, Callbacks.agarreCallback,
			function OnPersonajeConAgarreEnd(e:InteractionCallback):Void {
				agarre = false;
			}		
		);
		
		//MARTIN
		
		
		
		
		GameListeners.PersonajeConPlataforma = new InteractionListener(
			CbEvent.ONGOING, InteractionType.COLLISION, Callbacks.bodyInferiorCallback, Callbacks.plataformaCallback,
			function OnPersonajeConPlataformaCollision(e:InteractionCallback):Void {
				tocaPlataforma = true;
			}		
		);
		
		GameListeners.PersonajeConPlataformaEnd = new InteractionListener(
			CbEvent.END, InteractionType.COLLISION, Callbacks.bodyInferiorCallback, Callbacks.plataformaCallback,
			function OnPersonajeConPlataformaCollisionEnd(e:InteractionCallback):Void {
				tocaPlataforma = false;
			}		
		);
		
		
		GameListeners.PersonajeConPiso = new InteractionListener(
		CbEvent.ONGOING, InteractionType.COLLISION,Callbacks.bodyInferiorCallback, Callbacks.pisoCallback, 
			function OnPersonajeConPisoCollision(e:InteractionCallback):Void{
				tocaPiso = true;	
			}
		);
		
		GameListeners.PersonajeConPisoEnd = new InteractionListener(
		CbEvent.END, InteractionType.COLLISION, Callbacks.bodyInferiorCallback, Callbacks.pisoCallback ,
			function OnPersonajeConPisoCollisionEnd(e:InteractionCallback):Void{
				tocaPiso = false;
			}
		);
		
		GameListeners.BulletWithWorld= new InteractionListener(
			CbEvent.BEGIN, InteractionType.COLLISION, Callbacks.bulletNormalCallback, Callbacks.escenarioCallback, 
			function OnBulletWithWorld(e:InteractionCallback):Void {
				var bodyBullet:Body = e.int1.castBody;
				var bullet:BulletType_Normal = cast(bodyBullet.userData.object, BulletType_Normal);
				
				
				/*e.arbiters.at(0).collisionArbiter.contacts.foreach(function(c:Contact) {
					FlxG.log.add(e.int1.castBody.userData.nombre + "- " + e.int2.castBody.userData.nombre +  " x: " + c.position.x +  " y: " + c.position.y);
				});			*/			
				
				bullet.destroy();				
			}
		);
		
		GameListeners.BulletMagnetWithBody = new InteractionListener( 
			CbEvent.BEGIN,InteractionType.COLLISION, Callbacks.bulletMagnetCallback, Callbacks.magnetObjectCallback,
			function OnBulletMagnetWithBody(e:InteractionCallback):Void {
				var bmagnet:Body = e.int1.castBody;
				var body:Body = e.int2.castBody;
				
				e.arbiters.at(0).collisionArbiter.contacts.foreach(function(c:Contact) {
					FlxG.log.add(e.int1.castBody.userData.nombre + "- " + e.int2.castBody.userData.nombre +  " x: " + c.position.x +  " y: " + c.position.y);
				});						
				
			}		
		);
		
		GameListeners.BulletLinearMagnetWithWorld = new InteractionListener(
			CbEvent.BEGIN, InteractionType.SENSOR, Callbacks.linearmagnetObjectCallback, Callbacks.escenarioCallback,
			function onBulletLinearMagnetWithWorld(e:InteractionCallback):Void {
				var blinearmagnet:Body = e.int1.castBody;
				var body:Body = e.int2.castBody;
				FlxG.log.add("linear magnet collide with world");
				var b: BulletType_LinearMagnet = cast(blinearmagnet.userData.object, BulletType_LinearMagnet);
				b.camp();				
			}
		);
		
		
				
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConPiso);
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConPisoEnd);
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConPlataforma);		
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConAgarre);
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConAgarreEnd);		
		FlxNapeState.space.listeners.add(GameListeners.PersonajeConPlataformaEnd);
		FlxNapeState.space.listeners.add(GameListeners.BulletWithWorld);
		FlxNapeState.space.listeners.add(GameListeners.BulletMagnetWithBody);
		FlxNapeState.space.listeners.add(GameListeners.BulletLinearMagnetWithWorld);
		
	}
	
	override public function update():Void {
		super.update();
		
		//actualizarEstados();
		text.text = cast(this.getMidpoint().x,Int) +"," + cast(this.getMidpoint().y,Int); 
		text.setPosition(this.getMidpoint().x , this.getMidpoint().y);
		
		if (sprite != null) {
			sprite.x = x; 
			sprite.y = y;			
		}
				
		this.x = bodyIntermedio.position.x;
		this.y = bodyIntermedio.position.y;
		
		if (currentWeapon != null)
			currentWeapon.update();
		
		eventos();
	}	
	
	public function setWeapon(weapon:FlxObject):Void {
		
		Globales.currentState.remove(currentWeapon);
		
		currentWeapon.destroy();		
		
		currentWeapon = weapon;
		
		Globales.currentState.add(currentWeapon);
		
		
	}
	
	function actualizarEstados():Void 	{
		
		if (currentState == stQuieto) {
			FlxG.log.add("stQuieto");
		}else
		if (currentState == stCaminandoDerecha) {
			FlxG.log.add("stCaminandoDerecha");
		}else
		if (currentState == stCaminandoIzquierda) {
			FlxG.log.add("stCaminandoIzquierda");
		}else
		if (currentState == stSaltandoDerecha) {
			FlxG.log.add("stSaltandoDerecha");
		}else
		if (currentState == stSaltandoIzquierda) {
			FlxG.log.add("stSaltandoIzquierda");
		}else 
			return;
		
		
	}
	
	function eventos():Void {
		
		movimientos();
		
		if (FlxG.keys.justPressed.M ) {
			onOffJoints();
		}
		
		if (FlxG.mouse.justReleasedMiddle) {
			if (Globales.selectorArmas == null) {
				Globales.selectorArmas = new WeaponManager(Std.int(this.x), Std.int(this.y), this);
				Globales.currentState.add(Globales.selectorArmas);
			}
			else {
				Globales.selectorArmas.limpiar();
				Globales.selectorArmas = null;
			}
		}

		
	}
	
	function subirPlataforma():Void {
		
		// para que no se pase cuando sube el punto de agarre
		var offsetTopeY = 10;
		
		/*FlxG.log.clear();
		FlxG.log.add(bodyIntermedio.bounds.y);
		FlxG.log.add(topeY + offsetTopeY);*/
		
		if ((bodyIntermedio.velocity.y != 0) && (bodyIntermedio.bounds.y < topeY + offsetTopeY)) {
			
			bodyIntermedio.velocity.y = 0;
			
			if (tocaPlataformaIzq) { bodyIntermedio.velocity.x = 100; }
			else { bodyIntermedio.velocity.x = -100; }
		}
		else if((bodyIntermedio.velocity.x != 0) && tocaPlataformaIzq && (bodyIntermedio.bounds.x > topeX)){
				
				bodyIntermedio.velocity.x = 0;
				tocaPlataformaIzq = trepar = agarre = false;
				bodyIntermedio.allowMovement = true;
		}
		else if((bodyIntermedio.velocity.x != 0) && !tocaPlataformaIzq && (bodyIntermedio.bounds.x < topeX)){
				
				bodyIntermedio.velocity.x = 0;
				trepar = agarre = false;
				bodyIntermedio.allowMovement = true;
		}
	}
	
	function movimientos():Void {
		
		
		if (!agarre) {// Sino esta trepando, se mueve 
			if(FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)	{
				if (tocaPiso || tocaPlataforma) { 
					bodyInferior.applyImpulse( new Vec2(bodyInferior.velocity.x , -jumpForce), bodyInferior.position );
				}
			}
			
			if(FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT){
				bodyInferior.applyImpulse( new Vec2( -50, 0));
				
				if (bodyInferior.velocity.x < -maxVelX) { bodyInferior.velocity.x = -maxVelX; }
			}
			else if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)	{
				bodyInferior.applyImpulse( new Vec2(50, 0));

				if (bodyInferior.velocity.x > maxVelX) { bodyInferior.velocity.x = maxVelX; }
			}
		}
		else {		
			if(!trepar){
				if(FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT){
					bodyInferior.applyImpulse( new Vec2( -100, 0));
					
					if (bodyInferior.velocity.x < -maxVelX) { bodyInferior.velocity.x = -maxVelX; }
				}
				else if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)	{
					bodyInferior.applyImpulse( new Vec2(100, 0));

					if (bodyInferior.velocity.x > maxVelX) { bodyInferior.velocity.x = maxVelX; }
				}
				
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) {
					
					trepar = true;
					bodyIntermedio.allowMovement = false;
					bodyIntermedio.velocity.y = -150;
				}
			}	
		}
			
		if (trepar) { subirPlataforma(); }
	
		calcularEstados();
		
		if (FlxG.keys.justPressed.M ) {
			onOffJoints();
		}
	}
	
	function calcularEstados():Void 	{
		
		
		
	}
		
	override public function draw():Void {
		
		super.draw();	
		
		if (sprite != null) {
			sprite.draw();
		}
		
		if (currentWeapon != null)
			currentWeapon.draw();
		
		
	}
	
	override public function destroy():Void {
		
		currentWeapon.destroy();
		
	}
}