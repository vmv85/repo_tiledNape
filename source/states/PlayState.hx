package states;

import flixel.FlxG;
import flixel.util.FlxColor;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.dynamics.InteractionFilter;
import nape.geom.Mat23;
import nape.shape.Circle;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import objects.Detonador;
import objects.ObstaculoCuadrado;
import objects.PlataformaVertical;
import utils.Callbacks;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.geom.Vec2;
import nape.phys.Material;
import nape.shape.ShapeList;
import openfl.display.BitmapData;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import flixel.system.debug.LogStyle;
import nape.phys.BodyList;
import utils.*;
import weapons.*;





class PlayState extends FlxNapeState
{
	  
	 var char: FlxNapeSprite;
	 var terreno: FlxNapeSprite;
	 var polygonBody :Body;
	 var offsetNapeBody:Int = 80;
	 var playerMultiBody:PlayerNape;
	
	 var tocaPiso:Bool = false;
	
	 var clearTraceMax:Float = 20.0;
	 var clearTraceAcum:Float = 0.0;
	 
	

	/* assets */

	public var paused = false;
	
	override public function create():Void	{
		super.create();
		
		//FlxG.log.redirectTraces = false;
		
		napeDebugEnabled = true;
		FlxNapeState.debug.thickness = 4.0;	
		Globales.currentState = this;
		
		FlxNapeState.space.gravity = new Vec2(Globales.gravityX, Globales.gravityY);
		
		var bodyList_Magnet:BodyList = new BodyList();
		Globales.bodyList_typeMagnet = bodyList_Magnet;
		
		var tiledmap: TiledMap = new TiledMap( AssetPaths.LEVEL1_TMX_PATH);
		FlxG.log.add( "level size : " + tiledmap.fullWidth + "x" + tiledmap.fullHeight);
		
		FlxG.camera.setBounds(0, 0, tiledmap.fullWidth, tiledmap.fullHeight);
		FlxG.worldBounds.set(0, 0, tiledmap.fullWidth, tiledmap.fullHeight);
		
		var entities =  tiledmap.getObjectGroup("entities");
		
		for (o in entities.objects)
		{
			var bt:BodyType = o.type == "dynamic"?BodyType.DYNAMIC:BodyType.STATIC;	

			switch(o.objectType)
			{
				case TiledObject.POLYGON:
					crearObjetoPoligonal(o);
				case TiledObject.POLYLINE:
					playerMultiBody = new PlayerNape(o.x, o.y, FlxNapeState.space);
					Globales.globalPlayer = playerMultiBody;
				case TiledObject.RECTANGLE:
					crearObjectoRectangular(o);
				case TiledObject.ELLIPSE:
					crearObjetoElipse(o);
			}
		}

		FlxG.camera.follow(playerMultiBody);
		add(playerMultiBody);
		

		
		var sprBackground:FlxSprite = new FlxSprite(0, 0, AssetPaths.LEVEL1_BACKGROUND_PATH);
		add(sprBackground);
		
		Globales.canvas = new FlxSprite();
		Globales.canvas.makeGraphic(cast(FlxG.worldBounds.width, Int), cast(FlxG.worldBounds.height, Int), FlxColor.TRANSPARENT, true);
		Globales.canvas.alpha = 0.3;
		add(Globales.canvas);

		FlxNapeState.space.gravity.y = 200;
		var sprTerreno: FlxSprite = new FlxSprite(0, 0 , AssetPaths.LEVEL1_TERRAIN_PATH);
		add(sprTerreno);
	}
	
	function crearObjetoElipse(o:TiledObject):Void	{
		
		var shapeCircular:Circle = new Circle(o.width * 0.5);
		
		var bt:BodyType = o.custom.get("bodyType") == "dynamic"?BodyType.DYNAMIC:BodyType.STATIC;	
		var bodyCircular:Body = new Body(bt, new Vec2(o.x + o.width*.5, o.y+o.height*.5));	
		
		bodyCircular.userData.id = cast(o.xmlData.att.id, String);
		
		if (o.name == "circuloAgarre") {
			shapeCircular.sensorEnabled = true;
			shapeCircular.cbTypes.add(Callbacks.agarreCallback);
		}else if (o.name == "bola") {
			Globales.bodyList_typeMagnet.add(bodyCircular);
			bodyCircular.cbTypes.add(Callbacks.magnetObjectCallback);
		}

		bodyCircular.shapes.add(shapeCircular);
		
		// Asignamos userData desde Tiled
		if  (o.custom.contains("userDataBody")) {
			bodyCircular.userData.nombre = o.custom.get("userDataBody");
		}
		
		if (o.custom.contains("userDataShape")) {
			shapeCircular.userData.nombre = o.custom.get("userDataShape");
		}
		
		if (o.custom.contains("material")) {
			bodyCircular.setShapeMaterials( getMaterial(o.custom.get("material")));
		}
		
		if (o.custom.contains("puedeRotar")) {
			switch(o.custom.get("puedeRotar")) {
				case "0": bodyCircular.allowRotation = false;
				case "1": bodyCircular.allowRotation = true;				
			}
		}
				
		if (o.custom.contains("magnet")) {
			switch(o.custom.get("magnet")) {
				case "1": Globales.bodyList_typeMagnet.add(bodyCircular);
			}
		}
		
		bodyCircular.space = FlxNapeState.space;	
		
		
	}
	
	function crearObjectoRectangular(o:TiledObject):Void {
		
		
		//trace("crearRectangulo size: " + o.width + "x" + o.height + "- x e y : " + o.x +","+ o.y);
		var rectangleWidth:Int = cast(o.width, Int);
		var rectangleHeigth:Int = cast(o.height, Int);
		
		var bt:BodyType = BodyType.STATIC;
		
		if (o.custom.get("bodyType") == "dynamic") {
			bt = BodyType.DYNAMIC;
		}else if (o.custom.get("bodyType") == "static") {
			bt = BodyType.STATIC;
		}else if (o.custom.get("bodyType") == "kinematic") {
			bt = BodyType.KINEMATIC;
		}

		var rectangularBody:Body = new Body(bt, new Vec2(o.x, o.y));	
		rectangularBody.userData.id = cast(o.xmlData.att.id, String);
			
		var rectangularShape:Polygon = new Polygon(Polygon.rect(0, 0, rectangleWidth, rectangleHeigth));
		rectangularBody.shapes.add(rectangularShape);
		
		// Asignamos userData desde Tiled
		if  (o.custom.contains("userDataBody")) {
			rectangularBody.userData.nombre = o.custom.get("userDataBody");
		}
		
		if (o.custom.contains("userDataShape")) {
			rectangularShape.userData.nombre = o.custom.get("userDataShape");
		}
		
		if (o.custom.contains("material")) {
			rectangularBody.setShapeMaterials( getMaterial(o.custom.get("material")));
		}
		
		if (o.custom.contains("id_object")) {
			// id object para relacionarlo con otro object
			rectangularBody.userData.id_object = o.custom.get("id_object");
		}
		
		if (o.custom.contains("puedeRotar")) {
			switch(o.custom.get("puedeRotar")) {
				case "0": rectangularBody.allowRotation = false;
				case "1": rectangularBody.allowRotation = true;				
			}
		}
		
		rectangularBody.space = FlxNapeState.space;	
		
		if (o.name == "plataformaVertical" ) {
			rectangularBody.cbTypes.add(Callbacks.escenarioCallback);
			var pv = new PlataformaVertical(o.x, o.y, rectangularBody);	
		}else if (o.name == "obstaculoCuadrado") {
			var oc = new ObstaculoCuadrado(o.x, o.y, rectangularBody);
		}else if (o.name == "detonador") {
			var d = new Detonador(o.x, o.y, rectangularBody);
		}
		
		if (o.custom.contains("magnet")) {
			switch(o.custom.get("magnet")) {
				case "1": Globales.bodyList_typeMagnet.add(rectangularBody);
			}
		}
		
		/*if (o.custom.contains("image")) {
			AsignarImagen(o, rectangularBody);
		}
		else {
			
		}*/
		
	}
	
	function crearObjetoPoligonal(o:TiledObject):Void {
		var polygonVertices = new Array<Vec2>();
		
		for(p in o.points)
		{
			polygonVertices.push(new Vec2(p.x, p.y));
		}
		
		// Declaramos el body Polygono
		polygonBody = new Body(null, Vec2.get(o.x, o.y ));
		// Seteamos el id y lo guardamos en el userData
		polygonBody.userData.id = cast(o.xmlData.att.id,String);
		
		// Segun la propiedad que le pasamos desde Tiled, puede ser o Dynamic o Static
		polygonBody.type = o.custom.get("bodyType") == "dynamic"?BodyType.DYNAMIC:BodyType.STATIC;
		// Agregamos la shape que nos trae desde Tiled
		polygonBody.shapes.add(new Polygon(polygonVertices));
	
		
		// Asignamos userData desde Tiled
		if ( (o.custom.contains("userDataBody")) && (o.custom.contains("userDataShape")) ) {
			polygonBody.shapes.at(0).userData.nombre = o.custom.get("userDataShape");
			polygonBody.userData.nombre = o.custom.get("userDataBody");
		}
		
		// Le asignamos un material por defecto : STEEL
		polygonBody.setShapeMaterials(nape.phys.Material.steel());
		
		// Si hay material desde Tiled, pisamos el anterior
		if (o.custom.contains("material")) {
			polygonBody.setShapeMaterials( getMaterial(o.custom.get("material")));
		}		
		
		// Si admite rotacion
		if (o.custom.contains("puedeRotar")) {
			switch(o.custom.get("puedeRotar")) {
				case "0": polygonBody.allowRotation = false;
				case "1": polygonBody.allowRotation = true;				
			}
		}
			
		
		// Para los tipos de colision asignamos INTERACTOR AL CBTYPE
		if (o.name == "piso") {
			polygonBody.cbTypes.add( Callbacks.pisoCallback );
			polygonBody.cbTypes.add( Callbacks.escenarioCallback);
		}
		else if (o.name == "caja") {
			 polygonBody.cbTypes.add( Callbacks.cajaCallback );
		}
		
		if (o.custom.contains("magnet")) {
			switch(o.custom.get("magnet")) {
				case "1": Globales.bodyList_typeMagnet.add(polygonBody);
			}
		}
				
		// Si tiene la propiedad 'image' le asignamos al cuerpo
			// Asignar imagen crea un FlxNapeSprite, que ya se agrega al espacio
			// Sino, le asignamos manualmente el espacio
		if (o.custom.contains("image")) {
			AsignarImagen(o, polygonBody);
		}
		else {
			polygonBody.space = FlxNapeState.space;	
		}
		
	}
	
	function AsignarImagen(o:TiledObject, b:Body) {
		var spr:FlxNapeSprite = new FlxNapeSprite(o.x, o.y, o.custom.get("image"), false, false);
		spr.addPremadeBody(b);
		add(spr);
	}
	
	function getMaterial(m:String):Dynamic	{
				
		var mat= Material.steel();
		
		// por defecto sino tiene nada, le asigna STEEL
		
		if (m == "madera") {
			mat = Material.wood();
		}else if (m == "arena") {
			mat = Material.sand();
		}else if (m == "goma") {
			mat = Material.rubber();
		}else if (m == "hielo") {
			mat = Material.ice();
		}else if (m == "vidrio") {
			mat = Material.glass();
		}
		
		return mat;
		
	}

	override public function destroy():Void	{
		
		limpiarCosas();
		super.destroy();
		
	}

	override public function update():Void	{
		
		super.update();	
				
		controlarEventos();		
		
		LimpiarLog();
				
		if (FlxG.keys.justPressed.P) {
			paused = !paused;
		}
		
	}	
	
	function controlarEventos() {
		
		if (FlxG.keys.justPressed.N) {
			// Muestra/Esconde el debug de nape
			napeDebugEnabled = !napeDebugEnabled;
			if (napeDebugEnabled)
				FlxNapeState.debug.thickness = 4.0;	
		}
		
		if (FlxG.keys.justPressed.R) {
			// Resetea el state
			FlxG.resetState();
			limpiarCosas();
		}
		
		if (FlxG.keys.justPressed.B) {
			FlxNapeState.debug.drawBodyDetail = !FlxNapeState.debug.drawBodyDetail;
		}
	}
	
	function limpiarCosas():Void{
		
		// Variables globales
		Globales.currentState = null;
		Globales.globalPlayer = null;
		Globales.selectorArmas = null;
		
		// Listas globales
		if (Globales.bodyList_typeMagnet != null)
			Globales.bodyList_typeMagnet.clear();
		
	}
	
	function LimpiarLog():Void {
		if (clearTraceAcum < clearTraceMax) {
			clearTraceAcum += FlxG.elapsed;
		}else {
			FlxG.log.add("limpiar");
			clearTraceAcum = 0;
			FlxG.log.clear();
		}
	}
	
	override public function draw():Void {
		
		super.draw();
		
		
	}
		
}