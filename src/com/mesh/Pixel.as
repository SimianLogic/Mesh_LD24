package com.mesh
{
	import flash.display.Sprite;

	public class Pixel extends Sprite
	{
		public static var ID_DISPATCHER:int = 0;
		
		public var px:Number;
		public var py:Number;
		public var vx:Number;
		public var vy:Number;
		
		public var color:uint;
		public var pixelSize:int;
        public var cooldown:int; //frames of cooldown left
        public var maxCooldown:int; //total cooldown frames -- used to LERP the color
		
		public var controller:IPixelController;
		
		public function Pixel(size:int, _color:uint=0xffffff, _px:Number = 0, _py:Number = 0, _vx:Number = 0, _vy:Number = 0)
		{

			color = _color;
			px = _px;
			py = _py;
			vx = _vx;
			vy = _vy;
			pixelSize = size;
			
			paint();
		}
		
		public function paint():void
		{
            if(color == 0x00ff00) trace("GREEN");
            if(color == 0xffffff) trace("WHITE");

			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0,0,pixelSize,pixelSize);
		}
		
	}
}