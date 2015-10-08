package weapons  ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Geom;
import nape.shape.Circle;
import flixel.addons.nape.FlxNapeState;
import nape.phys.BodyType;
import nape.phys.Body;
import nape.geom.Vec2;
import flixel.FlxG;
import utils.*;
import utils.AssetPaths;
import utils.Callbacks;
/**
 * ...
 * @author asd
 */

 
class BulletType_LinearMagnet extends FlxSprite
{

	// el sprite debe ser el doble del radio del shape Circle.
	
	var bodyBullet:Body = null;
	var shapeBullet:Circle = null;
	var gravityPoint:Body;
	
	var auxSprite:FlxSprite;
	
	var startToDestroy:Bool = false;
	
	var collided:Bool;
	
	var timeToDestroy: Float = 5.0;
	var acumToDestroy:Float = 0.0;
	var radio:Float;
	var debugText:TextTimer;
	
	
	public function new(x:Float = 0, y:Float = 0, angle:Float, _radio:Float)	{
		
		super(x, y, AssetPaths.bullet_path);
		
		radio = _radio;	
	
		auxSprite = null;
		
		collided = false;
		bodyBullet = new Body(BodyType.KINEMATIC, new Vec2(x,y));
		shapeBullet = new Circle(10);
		shapeBullet.sensorEnabled = true; 
		bodyBullet.shapes.add(shapeBullet);
		
		
		bodyBullet.velocity.x = Math.cos(angle) * 200 ;
		bodyBullet.velocity.y = Math.sin(angle) * 200 ;
		
		bodyBullet.userData.object = this;
		bodyBullet.userData.nombre = "linear magnet bullet";
		bodyBullet.cbTypes.add(Callbacks.linearmagnetObjectCallback);
		bodyBullet.space = FlxNapeState.space;
		
		gravityPoint = new Body();
		gravityPoint.shapes.add(new Circle(1));
		
		//FlxG.log.add( "linearmagnetcb count : " + Callbacks.linearmagnetObjectCallback.interactors.length + " esceneario: "  + Callbacks.escenarioCallback.interactors.length);
	
	}
		
	public function camp() {
		collided = true;	
		
		var x:Float = bodyBullet.position.x;
		var y:Float = bodyBullet.position.y;
		
		FlxNapeState.space.bodies.remove(bodyBullet);		
		
		bodyBullet = new Body(BodyType.STATIC, new Vec2(x, y));
		shapeBullet.sensorEnabled = false;
		bodyBullet.shapes.add(shapeBullet);
		bodyBullet.space = FlxNapeState.space;
	
		
	}

	override public function destroy() {		
		FlxNapeState.space.bodies.remove(bodyBullet);
		FlxSpriteUtil.fill(Globales.canvas, FlxColor.TRANSPARENT);
		super.destroy();		
	}
	
	public function setRadioAtraccion(nradio:Int):Void	{
		radio = nradio;	
		
		if (debugText == null) {
			debugText = new TextTimer(new Vec2(this.x, this.y), "RadioAtraccion: " + radio, 1.0, 14, FlxColor.WHITE);	
			Globales.currentState.add(debugText);
		}else {
			debugText.setPosition(this.x, this.y);
			debugText.text = "RadioAtraccion: " + radio;			
			debugText.setTimeAlive(1.0);
			debugText.revive();						
		}		
	}
	
	override public function update() {
		super.update();

		// se adapta el sprite al body
		this.x = bodyBullet.position.x - this._halfWidth ;
		this.y = bodyBullet.position.y - this._halfHeight;
		
		if (bodyBullet.position.x > FlxG.worldBounds.width || bodyBullet.position.y > FlxG.worldBounds.height || this.x < 0 || this.y < 0 ){ //|| bodyBullet.isSleeping ) {
			this.destroy();
		}			
		
		if (collided) {
			if (acumToDestroy < timeToDestroy) {
				//Timer luego de colisionar
				acumToDestroy += FlxG.elapsed;
				dibujarCirculoRadio();
				magnetismo(bodyBullet, FlxG.elapsed);				
			}else {
				this.destroy();
			}
		}
	}
	
	function dibujarCirculoRadio():Void	{
		if (auxSprite == null) {
			auxSprite = FlxSpriteUtil.drawCircle(Globales.canvas, bodyBullet.position.x  ,  bodyBullet.position.y, radio,	
			FlxColor.FOREST_GREEN, Globales.estiloLinea) ;
		}		
	}
	
	function magnetismo(planet:Body, dt:Float) {

	
		if ( Globales.bodyList_typeMagnet != null && Globales.bodyList_typeMagnet.length > 0) {
				var closestA = Vec2.get();
				var closestB = Vec2.get();
					
				// santi: Cambie FlxNapeState.space.liveBodies por una lista de Bodys magnet, consumia mucha performance
				// va a ser un objeto que se declara en el playState
				for (body in Globales.bodyList_typeMagnet) {
					
						
							gravityPoint.position.set(body.position);
							var distance = Geom.distanceBody(planet, gravityPoint, closestA, closestB);
							
							// Cut gravity off, well before distance threshold.
							if (distance > radio) {
								continue;
							}
				 
							// Gravitational force.
							var force = closestA.sub(body.position, true);
				 
							// We don't use a true description of gravity, as it doesn't 'play' as nice.
							force.length = body.mass * 1e6 / (distance * distance) ;
				 
							// Impulse to be applied = force * deltaTime
							body.applyImpulse(
								/*impulse*/ force.muleq(dt),
								/*position*/ null, // implies body.position
								/*sleepable*/ true
							);
						
							
				}
				closestA.dispose();
				closestB.dispose();
			}
			
	}
	
}
	
	
	
