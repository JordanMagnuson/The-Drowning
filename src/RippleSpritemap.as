package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * Extends FP's Image class, and create an image with a "ripple" effect when underwater.
	 */
	public class RippleSpritemap extends Spritemap
	{
		
		public var originalBitmapData:BitmapData = null;
		public var underwaterBitmapData:BitmapData = null;
		public var t:Number = 0;
		
		public function RippleSpritemap(source:*, frameWidth:uint = 0, frameHeight:uint = 0, callback:Function = null, underwaterSource:* = null)
		{
			super(source, frameWidth, frameHeight, callback)
			originalBitmapData = _source;
			if (underwaterSource)
				underwaterBitmapData = FP.getBitmap(underwaterSource);
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void
		{
			t += FP.elapsed;
			applyRippleEffect();
			super.render(target, point, camera);
		}
		
		public function applyRippleEffect():void
		{
			var displacedBitmapData:BitmapData = new BitmapData(originalBitmapData.width, originalBitmapData.height, true, 0);
			var bitmapToCopy:BitmapData;
			var offset:Number = 0;
			var lastOffset:Number = 0;
			var rect:Rectangle;
			var pt:Point;
			var waterLine:Number = getWaterline();
			//var waterLine:Number = Global.floatController.u(_point.x + originX);
			
			for (var i:int = 0; i < originalBitmapData.height; i++) //Go through each row of pixels in originalBitmapData
			{
				offset = 0;
				bitmapToCopy = originalBitmapData;
				if ((_point.y) + i > waterLine) 
				{
					// If we're below the water line, offset this line of pixels, and apply alpha data.
					offset = getSinOffset(i, t);
					if (underwaterBitmapData)
						bitmapToCopy = underwaterBitmapData;
				}
				//var offset:Number = getRandomOffset(lastOffset);
				rect = new Rectangle(0, i, originalBitmapData.width, 1);
				pt = new Point(offset, i);
				displacedBitmapData.copyPixels(bitmapToCopy, rect, pt, null, null, false);
				lastOffset = offset;
			}
			
			_source = displacedBitmapData;
			updateBuffer();
		}
		
		public function getWaterline():Number 
		{
			var waterLine:Number = 0;
			if (Global.globalPerson is PersonFloating || Global.globalPerson is PersonGasping)
			{
				//trace('yes global floater');
				waterLine = Global.globalPerson.y;
			}
			else
			{
				//trace('no global floater');
				waterLine = Global.floatController.u(_point.x);
			}
			return waterLine;
		}
		
		/**
		 * Creates an offset based on a sine wave.
		 **/
		public function getSinOffset(x:Number, t:Number):Number 
		{
			var offset:Number;
			offset = Math.sin(x/2 - 10*t); // These coeficients can be altered to taste.
			offset = Math.round(offset);
			return offset;
		}
		
		/**
		 * Creates a random offset... can be used instead of the sine wave offset.
		 */
		public function getRandomOffset(lastOffset:Number):Number 
		{
			var offset:Number;
			offset = lastOffset + FP.choose(0, -1, 1);
			offset = FP.clamp(offset, -1, 1);
			return offset;
		}		
		
	}

}