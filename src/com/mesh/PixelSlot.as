package com.mesh
{
	public class PixelSlot
	{
		//keep a list of all our pixel slots, refill in order
		public static var ID_DISPATCHER:int = 0;
		
		public var pixel:Pixel; //can be null
		public var id:int;
		
        public var color:uint;
		public var px:int;
		public var py:int;
		
		public function PixelSlot(startX:int, startY:int, startColor:uint, startWithPixel:Boolean=false)
		{
			color = startColor;
            if(startWithPixel) addPixel(new Pixel());
			
			px = startX;
			py = startY;
			
			id = ID_DISPATCHER++;
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