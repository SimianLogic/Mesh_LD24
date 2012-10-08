package com.mesh
{
	import flash.display.Sprite;

	public class Pixel extends Sprite
	{
		public var px:Number;
		public var py:Number;
		public var vx:Number;
		public var vy:Number;
		
		public var color:uint;
		public var pixelSize:int = 1; //gets overridden when added to a display
        public var cooldown:int; //frames of cooldown left
        public var maxCooldown:int; //total cooldown frames -- used to LERP the color
		
		public var controller:IPixelController;
		
		public function Pixel(_color:uint=0xffffff, _px:Number = 0, _py:Number = 0, _vx:Number = 0, _vy:Number = 0)
		{

			color = _color;
			px = _px;
			py = _py;
			vx = _vx;
			vy = _vy;
			
            mouseEnabled = false;
            
			draw();
		}
        
        public function round():void
        {
            px = Math.round(px);
            py = Math.round(py);
        }
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0,0,pixelSize,pixelSize);
		}
        
        public function invalidate():void
        {
            graphics.lineStyle(2,0xff0000);
            graphics.moveTo(0,0);
            graphics.lineTo(pixelSize, pixelSize);
            graphics.moveTo(pixelSize, 0);
            graphics.lineTo(0,pixelSize);
        }
		
	}
}