package weapons  ;
import nape.phys.Material;
import utils.TextTimer;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import nape.geom.Geom;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Shape;
import flixel.util.FlxSpriteUtil;
import openfl.display.Graphics;
import utils.*;

/**
 * ...
 * @author asd
 */
class BulletType_Magnet extends FlxSprite
{

	var radio:Int;
	var gravityPoint:Body;
	
	
	 
	public var bodyBullet:Body = null;
	var shapeBullet:Circle = null;
	public var activo:Bool;
	var estiloLinea: LineStyle;

	/* 
	 *  Magnet Bullet:
	 *   Disparo constante mientras hace click
	 *   Se agrega en una posicion y dependiendo de la fuerza que tiene el magneto, atrae fuerte o despacio
	 * 
	 * */
	
	// COMMENT SANTI : el sprite debe ser el doble del radio del shape Circle.
	
	public function new( x : Int , y : Int , _radio:Int  ) :Void
	{
		super(x, y, AssetPaths.bullet_path);
		
		FlxG.log.add("creada magnet bullet");
		radio = _radio;
		
		
		
		
		
					
		bodyBullet = new Body(BodyType.KINEMATIC	, new Vec2(x, y));
		shapeBullet = new Circle(10, null, Material.steel());
		
		bodyBullet.shapes.add(shapeBullet);
		bodyBullet.userData.nombre = "magnet_bullet";		
		bodyBullet.cbTypes.add(Callbacks.bulletMagnetCallback);		
		bodyBullet.space = FlxNapeState.space;		
		
		gravityPoint = new Body();
		gravityPoint.shapes.add(new Circle(1));

		desactivar();
		
	}
	
	override public function update():Void{
			
		super.update();
		this.x = bodyBullet.position.x - this._halfWidth ;
		this.y = bodyBullet.position.y - this._halfHeight;
				
		if (activo) {
			dibujarCirculoRadio();
			magnetismo(bodyBullet, FlxG.elapsed);
		}
	}
	
	function dibujarCirculoRadio():Void	{
		FlxSpriteUtil.fill(Globales.canvas, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawCircle(Globales.canvas, bodyBullet.position.x  ,  bodyBullet.position.y, radio,
		FlxColor.FOREST_GREEN, Globales.estiloLinea) ;							
	}
	
	public function refreshPos(_x:Int, _y:Int, _radio:Int):Void {
		bodyBullet.position.set(new Vec2(_x - this._halfWidth, _y - this._halfHeight));
		if (_radio != radio) {
			radio = _radio;
		}		
	}
	
	public function activar() {
		activo = true;
		bodyBullet.space = FlxNapeState.space;
		this.visible = true;
	}
	
	public function desactivar() {
		activo = false;
		bodyBullet.space = null;
		FlxSpriteUtil.fill(Globales.canvas, FlxColor.TRANSPARENT);
		this.visible = false;
	}
		
	private function magnetismo(planet:Body, dt:Float):Void {
		
		// santi 
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

	override public function draw():Void {
		super.draw();		
	}
	
	override public function destroy():Void {
				
		super.destroy();
	}
	
	public function setRadioAtraccion(nradio:Int):Void	{
		radio = nradio;	
		FlxG.log.add(nradio);	
	}
	
}