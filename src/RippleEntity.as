package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RippleEntity extends Entity
	{
		public var myImage:Image = new Image(Assets.HAND_CURSOR_OPEN);
		public var myBitmapData:BitmapData = FP.getBitmap(Assets.HAND_CURSOR_OPEN);
		public var displacedBitmapData:BitmapData = FP.getBitmap(Assets.HAND_CURSOR_OPEN);
		public var timeSinceLastShift:Number = 0;
		public var t:Number = 0;
		
		public function RippleEntity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, myImage);
			graphic = new Image(displacedBitmapData);
		}
		
		override public function added():void
		{
			Mouse.hide();
		}			
		
		override public function update():void 
		{
			x = FP.world.mouseX;
			y = FP.world.mouseY;
			
			t += FP.elapsed;
			timeSinceLastShift += FP.elapsed;
			if (timeSinceLastShift >= 0.1) {
				applyWaterEffect();
				timeSinceLastShift = 0;
			}
			
			super.update();
		}
		
		public function applyWaterEffect(chunkSize:Number = 1):void 
		{
			var displacedBitmapData:BitmapData = new BitmapData(myBitmapData.width, myBitmapData.height, true, 0);
			var offset:Number = 0;
			var lastOffset:Number = 0;
			var rect:Rectangle;
			var pt:Point;
			for (var i:int = 0; i < myBitmapData.height; i++) //Go through each row of pixels in mybitmapdata
			{
				offset = 0;
				if (y + i > Global.WATER_LINE) 
				{
					offset = getSinOffset(i, t);
				}
				//var offset:Number = getRandomOffset(lastOffset);
				rect = new Rectangle(0, i, myBitmapData.width, 1);
				pt = new Point(offset, i);
				displacedBitmapData.copyPixels(myBitmapData, rect, pt);
				lastOffset = offset;
			}
			//(graphic as Image).
			graphic = new Image(displacedBitmapData);
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