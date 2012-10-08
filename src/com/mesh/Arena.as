package com.mesh
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	public class Arena extends Sprite implements IPixelController
	{
        public var PAUSED:Boolean = false;
        
		//should these be passed in & make a dirty arena? not sure if i'll re-use them
		public var boardColor:uint = 0x555555;
		public var strokeColor:uint = 0x111111;
		
		private var _pixelWidth:int;
		private var _pixelHeight:int;
		private var _pixelSize:int;
		private var _dirty:Boolean;
		
		public var pixels:Array;
        public var implode:Boolean = false;
		public var meshes:Array;
		public var collisionCheck:Array;
        
        public var active:Boolean = true;
		
		public function get pixelWidth():int { return _pixelWidth; }
		public function get pixelHeight():int { return _pixelHeight; }
		public function get pixelSize():int { return _pixelSize; }
		
		
		public function set pixelWidth(i:int):void
		{
			_pixelWidth = i;
			_dirty = true;
            
            collisionCheck = new Array(_pixelWidth * _pixelHeight);
		}
		public function set pixelHeight(i:int):void
		{
			_pixelHeight = i;
			_dirty = true;
            
            collisionCheck = new Array(_pixelWidth * _pixelHeight);
		}
		public function set pixelSize(i:int):void
		{
			_pixelSize = i;
			_dirty = true;
		}
		
		public function Arena(startPixelWidth:int, startPixelHeight:int, startPixelSize:int)
		{
			super();
			
			_pixelSize = startPixelSize;
			
			_pixelWidth = startPixelWidth;
			_pixelHeight = startPixelHeight;
			_dirty = true;
			
			draw();
			
			pixels = [];
            meshes = [];
            
			collisionCheck = new Array(pixelWidth*pixelHeight);
			resetCollisions();
		}
        
        public function localToPixel(hitX:int, hitY:int):Array
        {
            var x:int = Math.floor(hitX / (pixelSize + 1));
            var y:int = Math.floor(hitY / (pixelSize + 1));
            return [x,y];
        }
        
        public function empty():void
        {
            for(var i:int = 0; i < pixels.length; i++)
            {
                pixels[i].controller = null;
                removeChild(pixels[i]);
            }
            meshes = [];
            pixels = [];
        }
        
        public var currentLevel:MeshLevel;
        public var currentPlayer:Mesh;
        public var showTitleCard:Boolean = true;
        public function play(level:MeshLevel, player:Mesh):void
        {   
            implode = false;
            empty();
            
            currentLevel = level;
            currentPlayer = player;
           
            //may want to eventually limit to the first 5 pixelSlots only
            //but for now give them their whole mesh!
            player.reset(-1);
            
            var size:ArenaSize = level.size;
            var startWidth:int = size.pixelWidth;
            var startHeight:int = size.pixelHeight;
            
            var xOffset:int = 0;
            var yOffset:int = 0;
            
            //see if the player will fit, otherwise upgrade to the next size
            while(player.bottom + level.startY >= size.pixelHeight)
            {
                trace("UPGRADE");
                size = ArenaSize.nextSize(size);
                
                //a little wasteful to do this every time, but we don't even need it most of the time
                xOffset = (size.pixelWidth - startWidth)/2;
                yOffset = Math.min(size.pixelHeight - (player.bottom + level.startY), size.pixelHeight - startHeight)/2;
            }
            
            pixelSize = size.pixelSize;
            pixelWidth = size.pixelWidth;
            pixelHeight = size.pixelHeight;
            
            player.px = level.startX + xOffset;
            player.py = level.startY + yOffset;
            player.moveSpeed = size.moveSpeed;
            player.setBounds(0,0,pixelWidth, pixelHeight);
            
            //the update loop will add the pixels for us 
            meshes = [];
            var tm:Array = level.meshes;
            for each(var m:Mesh in tm)
            {
                addMesh(m);
                m.move(xOffset, yOffset);
            }
            
            addMesh(player);
            
            //because we PAUSE the game when we add a titleCard, update and draw are skipped
            //call them manually so we can see the level behind the titlecard!
            update();
            draw();
            
            //TODO: initialize UI, show a splash screen?
            if(showTitleCard)
            {
                var titleCard:LevelIntro = new LevelIntro();
                titleCard.tf.text = "level " + level.id + "\n" + level.title;
            
                stage.addChild(titleCard);
                PAUSED = true;
                stage.addEventListener("controller:space", function(event:Event=null):void {
                    titleCard.parent.removeChild(titleCard);
                    titleCard = null;
                    PAUSED = false;
                    event.currentTarget.removeEventListener(event.type, arguments.callee);
                }, false, 0, true);
            }
            stage.focus = stage;
        }
        
        public function restart():void
        {
            play(currentLevel, currentPlayer);
        }
		
		public function resetCollisions():void
		{
			for(var i:int = 0; i < collisionCheck.length; i++)
			{
				collisionCheck[i] ||= [];
				if(collisionCheck[i].length > 0) collisionCheck[i] = [];
			}
		}
		
		public function addMesh(mesh:Mesh):void
		{
            //needed to figure out what order to regenerate in if it regenerates
            mesh.validate();
            
			meshes.push(mesh);
            
            mesh.setBounds(0,0,pixelWidth, pixelHeight);
            
            var px:Array = mesh.pixels;
            for each(var pixel:Pixel in px)
            {
                addPixel(pixel);
            }
		}
        
        public function removeMesh(mesh:Mesh):void
        {
            if(meshes.indexOf(mesh) >= 0)
            {
                meshes.splice(meshes.indexOf(mesh), 1);    
            }
            var px:Array = mesh.pixels;
            for each(var pixel:Pixel in px)
            {
                pixel.controller = this;
                
                var dir:Number = Math.random()*2*Math.PI;
                //kind of a gross dependency
                pixel.vx = Math.cos(dir)*MeshGame.PIXEL_SPEED;
                pixel.vy = Math.sin(dir)*MeshGame.PIXEL_SPEED;
                pixel.cooldown = MeshGame.PIXEL_COOLDOWN;
                pixel.maxCooldown = MeshGame.PIXEL_COOLDOWN;
            }
            mesh.clear();
            
        }
		
        public function transferPixel(pixel:Pixel, newController:IPixelController):void
        {
            removePixel(pixel);
            newController.addPixel(pixel);
        }
		public function addPixel(pixel:Pixel):void
		{
			if(pixels.indexOf(pixel) == -1) pixels.push(pixel);
			addChild(pixel);
            
            //take control if they're a free pixel!
            if(pixel.controller == null)
            {
                pixel.controller = this;
                pixel.color = 0xffffff;
            }
            
            if(pixel.pixelSize != pixelSize)
            {
                pixel.pixelSize = pixelSize;
            }
            
            pixel.draw();
		}
		public function removePixel(pixel:Pixel):void
		{
			if(pixels.indexOf(pixel) >= 0)
			{
                if(pixel.controller == this) pixel.controller == null;
                
				pixels.splice(pixels.indexOf(pixel), 1);
				if(contains(pixel)) removeChild(pixel);
                pixel.cooldown = 0;
                pixel.transform.colorTransform = new ColorTransform();
			}else{
                trace("BAD PIXEL!");
            }
		}
		
        public var victoryQueued:Boolean = false;
		public function update(dt:int=0):void
		{
			resetCollisions();
            
            //go through our meshes and add any newly added pixels
            for each(var mesh:Mesh in meshes)
            {
                var mesh_pixels:Array = mesh.pixels;
                for each(var mp:Pixel in mesh_pixels)
                {
                    if(mp.parent != this)
                    {
                        addPixel(mp);
                    }
                }
				mesh.update();
            }

            for each(var pixel:Pixel in pixels)
            {
                if(pixel.controller == null)
                {
                    removePixel(pixel);
                    continue;
                }
                
                if(pixel.controller == this)
                {
                    if(implode)
                    {
                        currentPlayer.px = Math.round(currentPlayer.px);
                        currentPlayer.py = Math.round(currentPlayer.py);
                        
                        pixel.cooldown = 0;
                        pixel.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
                        
                        pixel.vx = 0;
                        pixel.vy = 0;
                    
                        var implodeSpeed:Number = 3.0;
                        pixel.px += (currentPlayer.px - pixel.px)/implodeSpeed;
                        pixel.py += (currentPlayer.py - pixel.py)/implodeSpeed;
                    }
                                        
                    pixel.cooldown--;
                    
                    if(pixel.cooldown >= 0)
                    {                       
                        if(pixel.controller == this)
                        {
                            var pct:Number = 1.0 - Number(pixel.cooldown) / pixel.maxCooldown;
                            pixel.transform.colorTransform = new ColorTransform(0,0,0,1,255,255*pct,255*pct,0);
                        }
                    }else if(pixel.cooldown >= -1*MeshGame.PIXEL_COOLDOWN){
                        pixel.transform.colorTransform = new ColorTransform(0,0,0,1,255,255,255,0);
                    }else if(pixel.cooldown >= -2*MeshGame.PIXEL_COOLDOWN){
                        //percent from -1 to -2... should probably make gray_cooldown a constant too
                        var grayPct:Number = -1*(pixel.cooldown + MeshGame.PIXEL_COOLDOWN) / MeshGame.PIXEL_COOLDOWN;
                        var grayVal:Number = 255 - 155*grayPct;
                        pixel.transform.colorTransform = new ColorTransform(0,0,0,1,grayVal, grayVal, grayVal,0);
                    }else{
                        //pixel expired!
                        removePixel(pixel);
                    }
                    
                    
                }   
                //figure out where the pixel is going
                pixel.controller.updatePixel(pixel);
                updatePixelLocation(pixel);
                
                
                //store where it is in case anything else wants the same spot
                collisionCheck[Math.round(pixel.px) + Math.round(pixel.py)*pixelWidth].push(pixel);                   
            }
            
			resolveCollisions();
            
            if(pixels.length == currentPlayer.pixels.length && !victoryQueued && active)
            {
                victoryQueued = true;
                setTimeout(showVictory, 250);       
            }
		}
        
        public function updatePixel(pixel:Pixel):void
        {
            pixel.px += pixel.vx;
            pixel.py += pixel.vy;
            
            if(pixel.px < 0)
            {
                pixel.px = 0;
                pixel.vx = pixel.vx * -1;
            }
            
            if(pixel.py < 0)
            {
                pixel.py = 0;
                pixel.vy = pixel.vy*-1;
            }
            
            if(pixel.px > pixelWidth - 1)
            {
                pixel.px = pixelWidth - 1;
                pixel.vx = pixel.vx*-1;
            }
            
            if(pixel.py > pixelHeight - 1)
            {
                pixel.py = pixelHeight - 1;
                pixel.vy = pixel.vy*-1;
            }
            
        }
        
        public function updatePixelLocation(pixel:Pixel):void
        {
            pixel.x = 1 + (pixelSize+1)*Math.round(pixel.px);
            pixel.y = 1 + (pixelSize+1)*Math.round(pixel.py);
        }
        		
		public function resolveCollisions():void
		{
            if(!active) return;
            
            var wounded:Array = [];
            
			for(var i:int = 0; i < collisionCheck.length; i++)
			{
				if(collisionCheck[i].length > 1)
				{
                    //TODO: see if we're self-colliding once I add sub-meshes
                    var j:int;
                    
                    //Possible Collison Results:
                    //  1) two particles destroy each other (different meshes)
                    //  2) a mesh particle absorbs a free particle
                    //  3) free particles ignore each other (ditto for same base mesh)
                    
                    var toBeAbsorbed:Array = [];
                    var wantsMAD:Array = [];   //mutually assured destruction!
                    var MADFodder:Array = [];
                    for each(var pixel:Pixel in collisionCheck[i])
                    {
                        
                        if(pixel.controller == this)
                        {
                            if(pixel.cooldown <= 0) toBeAbsorbed.push(pixel);
                        }else{
                            //add us to the MAD list if we're not in there already...
                            if(wantsMAD.indexOf(pixel.controller) == -1)
                            {
                                MADFodder.push(pixel);
                                wantsMAD.push(pixel.controller);
                            }
                        } 
                    }
                    
                    //only absorb the pixels if we have a single absorber (MESH) which can regen
                    if(wantsMAD.length == 1 && toBeAbsorbed.length > 0 && wantsMAD[0].hasRegen)
                    {
                        //mesh.absorbPixels
                        for each(var absorbedPixel:Pixel in toBeAbsorbed)
                        {
                            transferPixel(absorbedPixel, wantsMAD[0]);
                        }
                    }
                    
                    //MUTUALLY ASSURED DESTRUCTION!
                    if(wantsMAD.length >= 2)
                    {   
                        //for now, simply destroy EVERYTHING... later could adapt it to do 1:1 pixel annihilation, armor, etc...
                        for each(var deadPixel:Pixel in MADFodder)
                        {
                            deadPixel.controller.transferPixel(deadPixel, this);
                        }
                        
                        var dead:Array = [];
                        for each(var maybeDeadMesh:Mesh in meshes)
                        {  
                            wounded.push(maybeDeadMesh);
                            if(maybeDeadMesh.markedForDeath)
                            {
                                dead.push(maybeDeadMesh);
                            }
                        }
                        
                        for each(var deadMesh:Mesh in dead)
                        {
                            removeMesh(deadMesh);
                            if(deadMesh == currentPlayer)
                            {
                                //let the cooldown play, then let us start over
                                setTimeout(showGameOver, MeshGame.PIXEL_COOLDOWN * 17);
                            }
                        }
                        
                        //this only handles a board with all smart meshes--brainless meshes are never culled...
                        if(meshes.length == 1 && meshes[0] == currentPlayer)
                        {
                            trace("YOU WIN!");
                            setTimeout(function():void{ implode = true;}, MeshGame.PIXEL_COOLDOWN * 17);
                        }
                    }
                    
				}
			}
            
            for each(var mesh:Mesh in wounded)
            {
                //while we're in there see if we knocked anything else off
                var orphans:Array = mesh.getOrphanPixels();
                for each(var ps:PixelSlot in orphans)
                {
                    ps.pixel.controller.transferPixel(ps.pixel, this);
                }
            }
		}
        
        public var escapePopup:MovieClip;
        public function showGameOver():void
        {
            //return if we exited early
            if(stage == null) return;
            
            escapePopup ||= new GameOver();
            
            stage.addChild(escapePopup);
            PAUSED = true;
            stage.addEventListener("controller:space", resetHandler, false, 0, true);
            stage.addEventListener("controller:esc", menuHandler, false, 0, true);
        }
        
        public function resetHandler(event:Event):void
        {
            stage.removeChild(escapePopup);
            PAUSED = false;
            stage.removeEventListener("controller:space", resetHandler);
            stage.removeEventListener("controller:esc", menuHandler);
            dispatchEvent(new Event("restart"));
        }
        public function menuHandler(event:Event):void
        {
            stage.removeChild(escapePopup);
            PAUSED = false;
            stage.removeEventListener("controller:space", resetHandler);
            stage.removeEventListener("controller:esc", menuHandler);
            empty();
            dispatchEvent(new Event("menu"));
        }
        
        public var winPopup:MovieClip;
        public function showVictory():void
        {
            winPopup ||= new YouWin();
            
            stage.addChild(winPopup);
            PAUSED = true;
            stage.addEventListener("controller:space", nextHandler, false, 0, true);
            stage.addEventListener("controller:esc", winMenuHandler, false, 0, true);
        }
        
        public function nextHandler(event:Event):void
        {
            stage.removeChild(winPopup);
            PAUSED = false;
            stage.removeEventListener("controller:space", nextHandler);
            stage.removeEventListener("controller:esc", winMenuHandler);
            restart();
            dispatchEvent(new Event("nextLevel"));
        }
        public function winMenuHandler(event:Event):void
        {
            stage.removeChild(winPopup);
            PAUSED = false;
            stage.removeEventListener("controller:space", nextHandler);
            stage.removeEventListener("controller:esc", winMenuHandler);
            empty();
            dispatchEvent(new Event("menu"));
        }
        
		
		public function draw():void
		{
			graphics.lineStyle(1, strokeColor);
			graphics.beginFill(boardColor);
				
			var maxWidth:int = (pixelSize+1)*pixelWidth;
			var maxHeight:int = (pixelSize+1)*pixelHeight;
            
            trace("DRAWING ARENA: " + pixelWidth + "x" + pixelHeight);
			
			//add an extra pixel for every border line
			graphics.drawRect(0,0,maxWidth,maxHeight);			
			
			var i:int;
			for(i = 1; i < pixelWidth; i++)
			{
				graphics.moveTo((pixelSize+1)*i, 0);
				graphics.lineTo((pixelSize+1)*i, maxHeight);
			}
			for(i = 1; i < pixelHeight; i++)
			{
				graphics.moveTo(0, (pixelSize+1)*i);
				graphics.lineTo(maxWidth, (pixelSize+1)*i);
			}
		}
	}
}