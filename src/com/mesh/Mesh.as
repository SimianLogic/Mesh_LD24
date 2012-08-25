package com.mesh
{
	
	public class Mesh implements IPixelController
	{
		//public var controller
		
		public var pixelSize:int;
		
		//the first pixelSlot is always the root pixel
		public var pixelSlots:Array;
        public var extraPixels:int;
        
        public var px:int;
        public var py:int;
        
        public var rotation:int;
        
        public var minX:int;
        public var minY:int;
        public var maxX:int;
        public var maxY:int;
        
        //might be easier to just make this a rect? will see if I need to run intersects
        public var left:int;
        public var right:int;
        public var top:int;
        public var bottom:int;
		
		public function Mesh(startPixelSize:int, startX:int=0, startY:int=0) 
		{
			super();
            
            px = startX;
            py = startY;
			
			pixelSize = startPixelSize;
			
			pixelSlots = [];
            
            addSlot(new PixelSlot(0, 0, 0x0000ff, new Pixel(pixelSize)));
            addSlot(new PixelSlot(0, 1, 0x00ff00, new Pixel(pixelSize)));
            addSlot(new PixelSlot(1, 0, 0x00ff00));
            addSlot(new PixelSlot(0, -1, 0x00ff00));
            addSlot(new PixelSlot(-1, 0, 0x00ff00));
		}
        
        public function setBounds(newMinX:int, newMinY:int, newMaxX:int, newMaxY:int):void
        {
            minX = newMinX;
            minY = newMinY;
            maxX = newMaxX;
            maxY = newMaxY;
        }
        
        public function slotForPixel(pixel:Pixel):PixelSlot
        {
            //TODO: maybe PixelSlot should be the controller? or have a dictionary of pixel->PixelSlot?
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                if(pixelSlot.pixel == pixel)
                {
                    return pixelSlot;
                }
            }
            return null;
        }
        
        public function updatePixel(pixel:Pixel):void
        {
            var pixelSlot:PixelSlot = slotForPixel(pixel);
            if(pixelSlot != null)
            {
                pixel.px = this.px + pixelSlot.px;
                pixel.py = this.py + pixelSlot.py;
            }
        }
        
        public function move(dx:int, dy:int):void
        {
            if(Math.abs(maxX - minX) == 0) throw new Error("You must call setBounds before moving a mesh!");
            
            //ASSUMES LEFT <= 0 and RIGHT >= 0
            px = Math.min(maxX-right-1, Math.max(minX - left, px + dx));
            //ASSUMES TOP <= 0 and BOTTOM >= 0
            py = Math.min(maxY-bottom-1, Math.max(minY - top, py + dy));
        }
        
        //KABOOM!
        public function transferPixel(pixel:Pixel, newController:IPixelController):void
        {
            if(pixel.controller != this) throw new Error ("t'was not my pixel to transfer!");
            removePixel(pixel);
            newController.addPixel(pixel);
            
            var dir:Number = Math.random()*2*Math.PI;
            //kind of a gross dependency
            pixel.vx = Math.cos(dir)*MeshGame.PIXEL_SPEED;
            pixel.vy = Math.sin(dir)*MeshGame.PIXEL_SPEED;
            pixel.cooldown = MeshGame.PIXEL_COOLDOWN;
            pixel.maxCooldown = MeshGame.PIXEL_COOLDOWN;
        }
               
        public function addPixel(pixel:Pixel):void
        {
            var gotcha:Boolean = false;
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                if(pixelSlot.pixel == null)
                {
                    pixel.controller = this;
                    pixelSlot.addPixel(pixel);
                    return;
                }
            }
            
            extraPixels++;
            trace("NOW CARRYING " + extraPixels);
        }
        
        public function removePixel(pixel:Pixel):void
        {
            var pixelSlot:PixelSlot = slotForPixel(pixel);
            if(pixelSlot != null)
            {
                pixelSlot.pixel = null;
                pixel.controller = null;
            }else{
                throw new Error("You can't take what I don't have!");
            }
        }
		
        public function addSlot(slot:PixelSlot):void
        {
            for each(var ps:PixelSlot in pixelSlots)
            {
               if(ps.px == slot.px && ps.py == slot.py)
               {
                   throw new Error("That pixel slot has already been filled!");
                   return;
               }
            }
            
            left = Math.min(slot.px, left);
            right = Math.max(slot.px, right);
            top = Math.min(slot.py, top);
            bottom = Math.max(slot.py, bottom);
            
            if(slot.pixel != null) slot.pixel.controller = this;
            pixelSlots.push(slot);    
        }
        
        public function removeSlot(slot:PixelSlot):void
        {
            if(pixelSlots.indexOf(slot) >= 0)
            {
                pixelSlots.splice(pixelSlots.indexOf(slot), 1);
            }
            
            if(slot.pixel != null) slot.pixel.controller = null;
            
            left = 0;
            right = 0;
            top = 0;
            bottom = 0;
            for each(var ps:PixelSlot in pixelSlots)
            {
                left = Math.min(ps.px, left);
                right = Math.max(ps.px, right);
                top = Math.min(ps.py, top);
                bottom = Math.max(ps.py, bottom);
            }

        }
        
		public function get pixels():Array
		{
			var ret:Array = [];
			for(var i:int = 0; i < pixelSlots.length; i++)
			{
				if(pixelSlots[i].pixel != null) ret.push(pixelSlots[i].pixel);
			}
			return ret;
		}
	}
}