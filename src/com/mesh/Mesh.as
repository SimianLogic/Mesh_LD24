package com.mesh
{
    //Mesh is just a data container--it has no knowledge of pixel sizes... it's pixels will get
    //sized propery when they're added to an arena.
	
	public class Mesh implements IPixelController
	{
		
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
        
        public var markedForDeath:Boolean = false;
        public var hasBrain:Boolean = true;
		
		public var path:Path;
		
		public function Mesh() 
		{
			super();
			
			pixelSlots = [];

		}
        
        public function clear():void
        {
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                pixelSlot.pixel = null;
            }
        }
        
        public function reset(keepers:int):void
        {
            markedForDeath = false;
            var i:int = 0;
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                if(i < keepers)
                {
                    if(pixelSlot.pixel == null)
                    {
                        var pixel:Pixel = new Pixel();
                        pixel.controller = this;
                        pixelSlot.addPixel(pixel);
                    }
                }else{
                    if(pixelSlot.pixel != null)
                    {
                        pixelSlot.pixel.controller = null;
                        pixelSlot.pixel = null;
                    }
                }
                i++;
            }
        }
		
		public function update():void
		{
			if(path == null) return;
			
			path.update();
            
            if(!path.tookAction) return;
            
            //react to our various special actions!
			if(path.currentAction.action == PathAction.SPIN_LEFT) spinLeft();
			if(path.currentAction.action == PathAction.SPIN_RIGHT) spinRight();
		}
        
        public function setBounds(newMinX:int, newMinY:int, newMaxX:int, newMaxY:int):void
        {
            minX = newMinX;
            minY = newMinY;
            maxX = newMaxX;
            maxY = newMaxY;
        }
        
        //because we're pixel perfect, spinning only happens in 90-degree increments
        public function spinLeft():void
        {
            rotation--;
            if(rotation <= -4) rotation += 4;
            
            //x = -y, y = x
            var swap:int;
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                swap = pixelSlot.px;
                pixelSlot.px = pixelSlot.py;
                pixelSlot.py = -1*swap;
            }
            
            //could do this with a rotation as well, but until there's enough points to worry about this is easier
            computeBounds();
        }
        public function spinRight():void
        {
            rotation++;
            if(rotation >= 4) rotation -= 4;
            
            var swap:int;
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                swap = pixelSlot.px;
                pixelSlot.px =-1*pixelSlot.py;
                pixelSlot.py = swap;
            }
            
            //could do this with a rotation as well, but until there's enough points to worry about this is easier
            computeBounds();
        }
        public function resetSpin():void
        {
            while(rotation != 0)
            {
                spinRight();
            }
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
			
			if(path != null)
			{
				pixel.px += path.px;
				pixel.py += path.py;
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

//            if(extraPixels > 0 && pixelSlots[0].pixel != pixel)
//            {
//                extraPixels--;
//                return;
//            }
            
            //did we hit brain matter?
            if(pixelSlots[0].pixel == pixel && hasBrain)
            {
                markedForDeath = true;                
            }
            
            removePixel(pixel);
            newController.addPixel(pixel);
            
            var dir:Number = Math.random()*2*Math.PI;
            //kind of a gross dependency
            pixel.vx = Math.cos(dir)*MeshGame.PIXEL_SPEED;
            pixel.vy = Math.sin(dir)*MeshGame.PIXEL_SPEED;
            pixel.cooldown = MeshGame.PIXEL_COOLDOWN;
            pixel.maxCooldown = MeshGame.PIXEL_COOLDOWN;
            
            if(!hasBrain)
            {
                var alive:Boolean = false;
                for each(var pixelSlot:PixelSlot in pixelSlots)
                {
                    if(pixelSlot.pixel != null)
                    {
                        alive = true;
                        break;
                    }
                }
                if(!alive)
                {
                    markedForDeath = true;
                }
            }
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
            
           computeBounds();
        }
        
        public function computeBounds():void
        {
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
            
            //scooch us back in if we were out
            while(right + px  >= maxX) move(-1, 0);
            while(px + left < 0) move(1,0);
            while(top + py < 0) move(0,1);
            while(py + bottom >= maxY) move(0,-1);
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