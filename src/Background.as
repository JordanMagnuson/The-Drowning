package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	
	public class Background extends Entity
	{
		public var backdrop:Backdrop = new Backdrop(Assets.BACKGROUND, false, false);
		
		public function Background() 
		{
			super(0, 0, backdrop);
			layer = -10000;
		}
		
	}

}