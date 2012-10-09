package com.mesh
{
    import flash.utils.Dictionary;

    //Mesh is just a data container--it has no knowledge of pixel sizes... it's pixels will get
    //sized propery when they're added to an arena.
	
	public class Mesh implements IPixelController
	{
		
        public var valid:Boolean = true;
        
		//the first pixelSlot is always the root pixel
		public var pixelSlots:Array;
        public var extraPixels:int;
        
        public var px:Number = 0;
        public var py:Number = 0;
        
        //slow, so you know something is broken...
        public var moveSpeed:Number = 0.1;
        
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
        
        public var slotLeft:int;
        public var slotRight:int;
        public var slotTop:int;
        public var slotBottom:int;
        
        public var markedForDeath:Boolean = false;
        
        //special properties -- default values are intentional -- putting the commented line in the mesh's "specials" array will switch it to the non-default
        public var hasBrain:Boolean = true;  //zombie
        public var hasRegen:Boolean = false; //regen
		
		public var path:Path;
		
		public function Mesh() 
		{
			super();
			
			pixelSlots = [];

		}
        
        //traverses all PixelSlots and makes sure they're connected to the brain
        public function validate():void
        {
            if(!hasBrain) return;
            
            var island:Array = [];
            
            var root:PixelSlot = slotFor(0,0);
            root.depth = 0;
            root.valid = true;
            
            island.push(root);
            
            var depth:int = 1;
            var toCheck:Array = neighborsFor(root);
            var nextSet:Array = [];
            
            while(toCheck.length > 0)
            {
                var next:PixelSlot = toCheck.pop() as PixelSlot;
                next.depth = depth;
                next.valid = true;
                island.push(next);
                
                var n:Array = neighborsFor(next);
                for each(var ps:PixelSlot in n)
                {
                    if(island.indexOf(ps) == -1 && nextSet.indexOf(ps) == -1) nextSet.push(ps);                    
                }
                
                if(toCheck.length == 0)
                {
                    toCheck = nextSet;
                    nextSet = [];
                    depth++;
                }
            }
            
            //invalidate the bad eggs
            if(island.length == pixelSlots.length)
            {
                valid = true;   
            }else{
                valid = false;
                for each(var ps2:PixelSlot in pixelSlots)
                {
                    if(island.indexOf(ps2) == -1)
                    {
                        ps2.valid = false;
                        ps2.depth = PixelSlot.INVALID_DEPTH;
                    }
                }
            }
            
            pixelSlots = pixelSlots.sortOn("depth");
        }
        
        public function getOrphanPixels():Array
        {
            if(!hasBrain) return [];
            
            var root:PixelSlot = slotFor(0,0);
            //no need to check for breakage if the whole thing is busted
            if(root.pixel == null) return [];

            var island:Array = [];
            var empty:Array = [];
            island.push(root);
            
            var toCheck:Array = neighborsFor(root);
            
            //simpler loop, since we're unconcerned with depth...
            while(toCheck.length > 0)
            {
                var next:PixelSlot = toCheck.pop() as PixelSlot;

                if(next.pixel == null)
                {
                    empty.push(next);
                    //dead pixels don't have neighbors!
                }else{
                    island.push(next);
                    
                    var n:Array = neighborsFor(next);
                    for each(var ps:PixelSlot in n)
                    {
                        if(island.indexOf(ps) == -1 && empty.indexOf(ps) == -1) toCheck.push(ps);                    
                    }
                }
            }
            
            var found:Array = island.concat(empty);
            var orphans:Array = [];
            //cast out those that weren't found
            if(found.length != pixelSlots.length)
            {
                for each(var ps2:PixelSlot in pixelSlots)
                {
                    if(found.indexOf(ps2) == -1)
                    {
                        if(ps2.pixel != null) orphans.push(ps2);          
                    }
                }
            }
            return orphans;
        }
        
        public static function fromMesh(mesh:Mesh):Mesh
        {
            var ret:Mesh = new Mesh();
            for each(var pixelSlot:PixelSlot in mesh.pixelSlots)
            {
                ret.addSlot(new PixelSlot(pixelSlot.px, pixelSlot.py, pixelSlot.color, pixelSlot.pixel != null));
            }
            
            ret.hasBrain = mesh.hasBrain;
            ret.hasRegen = mesh.hasRegen;
            
            return ret;
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
            if(keepers == -1) keepers = pixelSlots.length;
            
            trace("RESET!");
            markedForDeath = false;
            var i:int = 0;
            for each(var pixelSlot:PixelSlot in pixelSlots)
            {
                if(!pixelSlot.valid) continue;
                
                if(i < keepers)
                {
                    if(pixelSlot.pixel == null)
                    {
                        var pixel:Pixel = new Pixel();
                        pixelSlot.addPixel(pixel);
                    }
                    
                    pixelSlot.pixel.controller = this;
                    
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
        
        public function moveAbsolute(dx:Number, dy:Number):void
        {
            //ASSUMES LEFT <= 0 and RIGHT >= 0
            px = Math.min(maxX-right-1, Math.max(minX - left, px + dx));
            //ASSUMES TOP <= 0 and BOTTOM >= 0
            py = Math.min(maxY-bottom-1, Math.max(minY - top, py + dy));
        }
        
        public function move(dx:Number, dy:Number):void
        {
            if(Math.abs(maxX - minX) == 0) throw new Error("You must call setBounds before moving a mesh!");
            
            if(!isNaN(moveSpeed))
            {
                dx = dx * moveSpeed;
                dy = dy * moveSpeed;
            }else{
                throw new Error("MOVESPEED IS NULL!");
            }
            
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
                if(pixelSlots.length == 5) trace("MARK PLAYER FOR DEATH");
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
            
            //if i'm a zombie, mark me for death when all my pixels are empty
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
                if(pixelSlot.pixel == null && pixelSlot.valid)
                {
                    pixel.controller = this;
                    pixelSlot.addPixel(pixel);
                    computeBounds();
                    return;
                }
            }
            
            extraPixels++;
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
            
            computeBounds();
        }
		
        public function slotFor(x:int, y:int):PixelSlot
        {
            for each(var ps:PixelSlot in pixelSlots)
            {
                if(ps.px == x && ps.py == y)
                {
                    return ps;
                }
            }
            return null;
        }
        
        public function neighborsFor(pixelSlot:PixelSlot):Array
        {
            var ret:Array = [];
            
            var x:int = pixelSlot.px;
            var y:int = pixelSlot.py;
            var neighborLeft:PixelSlot = slotFor(x-1,y);
            var neighborRight:PixelSlot = slotFor(x+1,y);
            var neighborTop:PixelSlot = slotFor(x,y-1);
            var neighborBottom:PixelSlot = slotFor(x,y+1);
            
            if(neighborLeft) ret.push(neighborLeft);
            if(neighborRight) ret.push(neighborRight);
            if(neighborTop) ret.push(neighborTop);
            if(neighborBottom) ret.push(neighborBottom);
            
            return ret;
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
            
            if(slot.pixel != null) 
            {
                slot.pixel.controller = this;
            }
            
            pixelSlots.push(slot);  
            computeSlotBounds();
        }
        
        public function removeSlot(slot:PixelSlot):void
        {
            if(slot.pixel != null)
            {
                removePixel(slot.pixel);
            }
            
            if(pixelSlots.indexOf(slot) >= 0)
            {
                pixelSlots.splice(pixelSlots.indexOf(slot), 1);
            }
            
           computeSlotBounds();
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
                if(ps.pixel == null) continue;
                
                left = Math.min(ps.px, left);
                right = Math.max(ps.px, right);
                top = Math.min(ps.py, top);
                bottom = Math.max(ps.py, bottom);
            }
            
            //scooch us back in if we were out
            while(right + px  >= maxX) moveAbsolute(-1, 0);
            while(px + left < 0) moveAbsolute(1,0);
            while(top + py < 0) moveAbsolute(0,1);
            while(py + bottom >= maxY) moveAbsolute(0,-1);
        }
        
        public function computeSlotBounds():void
        {
            slotLeft = 0;
            slotRight = 0;
            slotTop = 0;
            slotBottom = 0;
            for each(var ps:PixelSlot in pixelSlots)
            {
                slotLeft = Math.min(ps.px, slotLeft);
                slotRight = Math.max(ps.px, slotRight);
                slotTop = Math.min(ps.py, slotTop);
                slotBottom = Math.max(ps.py, slotBottom);
            }
            
            //no movement needed, these bounds are theoretical
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