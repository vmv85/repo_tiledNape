package weapons  ;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxSprite;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.shape.Circle;
import flixel.addons.nape.FlxNapeState;
import nape.phys.BodyType;
import nape.phys.Body;
import nape.geom.Vec2;
import flixel.FlxG;
import utils.*;
import utils.Callbacks;
import utils.Globales;
/**
 * ...
 * @author asd
 */

 
class BulletType_Normal extends FlxSprite
{

	// el sprite debe ser el doble del radio del shape Circle.
	
	var bodyBullet:Body = null;
	var shapeBullet:Circle = null;
	
	var startToDestroy:Bool = false;
	
	var collided:Bool;
	
	var timeToDestroy: Float = 10.0;
	var acumToDestroy:Float = 0.0;

	
	public function new(x:Float = 0, y:Float = 0, angle:Float)	{
		
		super(x, y, AssetPaths.bullet_path);		
		
		collided = false;
		
		bodyBullet = new Body(BodyType.DYNAMIC, new Vec2(x,y));
		shapeBullet = new Circle(10);
		bodyBullet.shapes.add(shapeBullet);
		
		bodyBullet.velocity.x = Math.cos(angle) * 200 ;
		bodyBullet.velocity.y = Math.sin(angle) * 200 ;

		bodyBullet.space = FlxNapeState.space;
		bodyBullet.userData.object = this;
		bodyBullet.userData.nombre = "normal bullet";
		bodyBullet.cbTypes.add(Callbacks.magnetObjectCallback);
		Globales.bodyList_typeMagnet.add(bodyBullet);
		bodyBullet.cbTypes.add(Callbacks.bulletNormalCallback);
	
	}

	override public function destroy() {
		
		Globales.bodyList_typeMagnet.remove(bodyBullet);
		FlxNapeState.space.bodies.remove(bodyBullet);
		super.destroy();
		
	}
	
	
	override public function update() {
		super.update();
		
		// se adapta el sprite al body
		this.x = bodyBullet.position.x - this._halfWidth ;
		this.y = bodyBullet.position.y - this._halfHeight;
		

		
		if (bodyBullet.position.x > FlxG.worldBounds.width || bodyBullet.position.y > FlxG.worldBounds.height || this.x < 0 || this.y < 0 ){ //|| bodyBullet.isSleeping ) {
			this.destroy();
		}
	
	}
}
	
	
	
