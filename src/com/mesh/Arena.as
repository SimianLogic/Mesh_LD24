package com.mesh
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	
	public class Arena extends Sprite implements IPixelController
	{
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
		
		public function get pixelWidth():int { return _pixelWidth; }
		public function get pixelHeight():int { return _pixelHeight; }
		public function get pixelSize():int { return _pixelSize; }
		
		
		public function set pixelWidth(i:int):void
		{
			_pixelWidth = i;
			_dirty = true;
		}
		public function set pixelHeight(i:int):void
		{
			_pixelHeight = i;
			_dirty = true;
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
        
        public function empty():void
        {
            trace("EMPTY");
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
        public function play(level:MeshLevel, player:Mesh):void
        {   
            implode = false;
            empty();
            
            currentLevel = level;
            currentPlayer = player;
            
            pixelSize = level.pixelSize;
            pixelWidth = level.pixelWidth;
            pixelHeight = level.pixelHeight;
            
            player.reset(5); //keep your first 5 pixelSlots only!
            player.px = level.startX;
            player.py = level.startY;
            player.setBounds(0,0,pixelWidth, pixelHeight);
            
            //the update loop will add the pixels for us 
            meshes = [];
            var tm:Array = level.meshes;
            for each(var m:Mesh in tm)
            {
                addMesh(m);
            }
            
            addMesh(player);
            
            
            //TODO: initialize UI, show a splash screen?
            var titleCard:LevelIntro = new LevelIntro();
            titleCard.tf.text = "level " + level.id + "\n" + level.title;
            
            stage.addChild(titleCard);
            stage.addEventListener("controller:space", function(event:Event=null):void {
                titleCard.parent.removeChild(titleCard);
                titleCard = null;
                event.currentTarget.removeEventListener(event.type, arguments.callee);
            }, false, 0, true);
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
				pixels.splice(pixels.indexOf(pixel), 1);
				removeChild(pixel);
                pixel.cooldown = 0;
                pixel.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
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
                if(implode && pixel.controller == this)
                {
                    pixel.cooldown = 0;
                    pixel.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
                    pixel.round();
                    if(pixel.px > currentPlayer.px) pixel.px--;
                    if(pixel.py > currentPlayer.py) pixel.py--;
                    if(pixel.px < currentPlayer.px) pixel.px++;
                    if(pixel.py < currentPlayer.py) pixel.py++;
                    
                }else{
                
                    //figure out where the pixel is going
                    pixel.controller.updatePixel(pixel);
                    
                    if(pixel.cooldown > 0)
                    {
                        pixel.cooldown--;
                        
                        if(pixel.controller == this)
                        {
                            var pct:Number = 1.0 - Number(pixel.cooldown) / pixel.maxCooldown;
                            pixel.transform.colorTransform = new ColorTransform(0,0,0,1,255,255*pct,255*pct,0);
                        }
                    }
                }   
                
                updatePixelLocation(pixel);
                
                //store where it is in case anything else wants the same spot
                collisionCheck[Math.round(pixel.px) + Math.round(pixel.py)*pixelWidth].push(pixel);                   
            }
            
			resolveCollisions();
            
            if(pixels.length == currentPlayer.pixels.length && !victoryQueued)
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
                            if(pixel.cooldown == 0) toBeAbsorbed.push(pixel);
                        }else{
                            //add us to the MAD list if we're not in there already...
                            if(wantsMAD.indexOf(pixel.controller) == -1)
                            {
                                MADFodder.push(pixel);
                                wantsMAD.push(pixel.controller);
                            }
                        } 
                    }
                    
                    if(wantsMAD.length) trace("MAD: " + wantsMAD.length + "   TBA: " + toBeAbsorbed.length);
                    //only absorb the pixels if we have a single absorber (MESH) which has a brain
                    if(wantsMAD.length == 1 && toBeAbsorbed.length > 0 && wantsMAD[0].hasBrain)
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
                        //for now, simply destroy EVERYTHING... later could adapt it to do 1:1 pixel annihilation
                        for each(var deadPixel:Pixel in MADFodder)
                        {
                            deadPixel.controller.transferPixel(deadPixel, this);
                        }
                        
                        for each(var maybeDeadMesh:Mesh in meshes)
                        {
                            if(maybeDeadMesh.markedForDeath)
                            {
                                removeMesh(maybeDeadMesh);
                                if(maybeDeadMesh == currentPlayer)
                                {
                                    //let the cooldown play, then let us start over
                                    setTimeout(showGameOver, MeshGame.PIXEL_COOLDOWN * 17);
                                }
                            }
                        }
                        
                        //this only handles a board with all smart meshes--brainless meshes are never culled...
                        if(meshes.length == 1 && meshes[0] == currentPlayer)
                        {
                            trace("YOU WIN!");
                            setTimeout(function():void{ implode = true; }, MeshGame.PIXEL_COOLDOWN * 17);
                        }
                    }
                    
				}
			}
		}
        
        public var escapePopup:MovieClip;
        public function showGameOver():void
        {
            escapePopup ||= new GameOver();
            
            stage.addChild(escapePopup);
            stage.addEventListener("controller:space", resetHandler, false, 0, true);
            stage.addEventListener("controller:esc", menuHandler, false, 0, true);
        }
        
        public function resetHandler(event:Event):void
        {
            stage.removeChild(escapePopup);
            stage.removeEventListener("controller:space", resetHandler);
            stage.removeEventListener("controller:esc", menuHandler);
            dispatchEvent(new Event("restart"));
        }
        public function menuHandler(event:Event):void
        {
            stage.removeChild(escapePopup);
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
            stage.addEventListener("controller:space", nextHandler, false, 0, true);
            stage.addEventListener("controller:esc", winMenuHandler, false, 0, true);
        }
        
        public function nextHandler(event:Event):void
        {
            stage.removeChild(winPopup);
            stage.removeEventListener("controller:space", nextHandler);
            stage.removeEventListener("controller:esc", winMenuHandler);
            restart();
            dispatchEvent(new Event("nextLevel"));
        }
        public function winMenuHandler(event:Event):void
        {
            stage.removeChild(winPopup);
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