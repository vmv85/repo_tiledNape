package utils ;

import nape.callbacks.InteractionListener;
/**
 * ...
 * @author Santiago Gesualdo - Martin Villafañez
 */
class GameListeners
{
	
	public static var PersonajeConPiso:InteractionListener;
	public static var PersonajeConPisoEnd:InteractionListener;
	public static var PersonajeConPlataforma:InteractionListener;
	public static var PersonajeConPlataformaEnd:InteractionListener;
	public static var PersonajeConPlataformaTrepar:InteractionListener;
	
	public static var PersonajeConAgarre:InteractionListener;
	public static var PersonajeConAgarreEnd:InteractionListener;
	
	public static var BulletWithWorld:InteractionListener;
	public static var BulletLinearMagnetWithWorld:InteractionListener;
	public static var BulletMagnetWithBody:InteractionListener;	
	
	public static var MagnetWithObstaculoRectangular:InteractionListener;	
	public static var MagnetWithObstaculoRectangularOff:InteractionListener;	
	public static var DetonadorWithObjetoRectangular :InteractionListener;
	
}
