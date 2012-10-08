package com.mesh
{
	public class PixelSlot
	{
        public static const INVALID_DEPTH:int = 10000;
        public var depth:int = INVALID_DEPTH;
        public var valid:Boolean;
        
		public var pixel:Pixel; //can be null
		
        public var color:uint;
		public var px:int;
		public var py:int;
		
		public function PixelSlot(startX:int, startY:int, startColor:uint, startWithPixel:Boolean=false)
		{
			color = startColor;
            if(startWithPixel) addPixel(new Pixel());
			
			px = startX;
			py = startY;
		}
        
        public function addPixel(newPixel:Pixel):void
        {
            if(pixel != null) throw new Error("Already have a pixel!");
            
            pixel = newPixel;
            pixel.color = color;
            pixel.vx = 0;
            pixel.vy = 0;
            pixel.px = 0;
            pixel.py = 0;
            pixel.draw();
        }
	}
}