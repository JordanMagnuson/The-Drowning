package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.ColorTween;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BloodOverlay extends Entity
	{
		public static const TWEEN_DURATION:Number = 2;
		
		public var canvas:Canvas = new Canvas(FP.width, FP.height);
		public var colorTween:ColorTween;
		
		public function BloodOverlay() 
		{
			canvas.fill(new Rectangle(0, 0, FP.width, FP.height), Colors.BLOOD_RED, 1);
			canvas.alpha = 0;
			super(0, 0, canvas);
			layer = -2000;	
			
			colorTween = new ColorTween();
			colorTween.alpha = 0;
		}
		
		override public function added():void
		{
			addTween(colorTween);
		}
		
		override public function update():void
		{
			//trace('alpha: ' + canvas.alpha);
			//canvas.alpha = colorTween.alpha;
			var bloodAlpha:Number = 1 - (Global.globalPerson.health / Global.BASE_HEALTH);
			bloodAlpha = FP.scale(bloodAlpha, 0, 1, 0, MAX_BLOOD_ALPHA);
			canvas.alpha = bloodAlpha;
			super.update();
		}
		
		//public function updateAlpha():void
		//{
			//trace('update alpha');
			//var newAlpha:Number = Math.pow(Global.peopleKilled, 0.9) / 10;
			//var newAlpha:Number = Global.globalPerson.health / 100;
			//trace("new alpha: " + newAlpha);
			//colorTween.tween(TWEEN_DURATION, Colors.WHITE, Colors.WHITE, canvas.alpha, newAlpha);
		//}
		
	}

}