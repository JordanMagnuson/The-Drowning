package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RippleImage extends Image
	{
		
		public var originalBitmapData:BitmapData;
		public var displacedBitmapData:BitmapData;
		public var underwaterOverlay:BitmapData;
		public var t:Number = 0;
		import net.flashpunk.FP;
		
		public function RippleImage(source:*, clipRect:Rectangle = null) 
		{
			super(source, clipRect);
			originalBitmapData = _source;
			underwaterOverlay = FP.getBitmap(Assets.UNDERWATER_OVERLAY);
		}
		
		/** @private Renders the image. */
		override public function render(target:BitmapData, point:Point, camera:Point):void
		{
			t += FP.elapsed;
			applyRippleEffect();
			super.render(target, point, camera);
		}
		
		public function applyRippleEffect():void
		{
			var displacedBitmapData:BitmapData = new BitmapData(originalBitmapData.width, originalBitmapData.height, true, 0);
			var alphaBitmapData:BitmapData;
			var offset:Number = 0;
			var lastOffset:Number = 0;
			var rect:Rectangle;
			var pt:Point;
			
			for (var i:int = 0; i < originalBitmapData.height; i++) //Go through each row of pixels in mybitmapdata
			{
				trace("y: " + _point.y);
				offset = 0;
				alphaBitmapData = null;
				if (_point.y + i > Global.WATER_LINE) 
				{
					offset = getSinOffset(i, t);
					alphaBitmapData = underwaterOverlay;
				}
				//var offset:Number = getRandomOffset(lastOffset);
				rect = new Rectangle(0, i, originalBitmapData.width, 1);
				pt = new Point(offset, i);
				displacedBitmapData.copyPixels(originalBitmapData, rect, pt, alphaBitmapData, null, true);
				lastOffset = offset;
			}
			
			_source = displacedBitmapData;
			updateBuffer();
		}
		
		public function getSinOffset(x:Number, t:Number):Number 
		{
			var offset:Number;
			offset = Math.sin(x/2 - 10*t);
			offset = Math.round(offset);
			return offset;
		}
		
		public function getRandomOffset(lastOffset:Number):Number {
			var offset:Number;
			offset = lastOffset + FP.choose(0, -1, 1);
			offset = FP.clamp(offset, -1, 1);
			return offset;
		}		
		
	}

}