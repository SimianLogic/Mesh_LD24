package
{
	import com.mesh.Arena;
	import com.mesh.Controller;
	import com.mesh.Mesh;
	import com.mesh.MeshLevel;
	import com.mesh.Path;
	import com.mesh.PathAction;
	import com.mesh.Pixel;
	import com.mesh.PixelSlot;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width='640', height='480', backgroundColor='0xffffff', frameRate='30')]
	public class MeshGame extends Sprite
	{
		public var frame:int = 0;
        public var frameDelay:int = 4;
        
		public var arena:Arena;
        public var player:Mesh;
        public var enemy:Mesh;
        public var controller:Controller;
		
        public static var PIXEL_SPEED:Number = 0.25;
        public static var PIXEL_COOLDOWN:int = 60;
        
        public var currentLevel:int = 5;
        public var levels:Array;
        
        public var state:int;
        public static const MENU:int = 0;
        public static const GAME:int = 1;
		public function MeshGame()
		{
            //looking these up statically just to save time while tinkering
            levels = MeshLevel.levels;
            currentLevel = MeshLevel.START_LEVEL_INDEX;
           
            controller = Controller.getInstance(stage);
            
            Controller.registerAction("space",32);
            Controller.registerAction("esc", 27);
            
            showMenu();
           
            this.addEventListener(Event.ENTER_FRAME, update);		
		}
        
        public var menuSprite:MainMenu;
        public function showMenu():void
        {
            state = MENU;
            
            menuSprite ||= new MainMenu();
            addChild(menuSprite);
            
            menuSprite.tf.text = "level " + (currentLevel+1);
        }
        
        public function play():void
        {
            state = GAME;
            
            //this yields final dimensions of 450x450 -- 30,30,14
            //other possible dimensions: 45,45,9 / 50,50,8 / 75,75,5 / 90,90,4 / 150,150,2
            //smaller dimensions: 10,10,44 (TOO SMALL) / 18,18,24
            
            var level:MeshLevel = MeshLevel.parse(levels[currentLevel]);
            
            var pixelWidth:int = level.pixelWidth;
            var pixelHeight:int = level.pixelHeight;
            var pixelSize:int = level.pixelSize;
            
            if(arena)
            {
                arena.removeEventListener("nextLevel", nextLevelHandler);
                arena.removeEventListener("restart", nextLevelHandler);
                arena.removeEventListener("menu", menuHandler);
                if(contains(arena)) removeChild(arena);
                arena = null;
            }

            arena = new Arena(pixelWidth, pixelHeight, pixelSize);
            addChild(arena);
            arena.x = 15;
            arena.y = 15;
            
            arena.addEventListener("nextLevel", nextLevelHandler);
            arena.addEventListener("restart", restartHandler);
            arena.addEventListener("menu", menuHandler);
            
            player = new Mesh();
            
            player.addSlot(new PixelSlot(0, 0, 0x00ff00, true));
            player.addSlot(new PixelSlot(0, 1, 0x0000ff, true));
            player.addSlot(new PixelSlot(1, 0, 0x0000ff, true));
            player.addSlot(new PixelSlot(0, -1, 0x0000ff, true));
            player.addSlot(new PixelSlot(-1, 0, 0x0000ff, true));    

            trace("START " + currentLevel);
            trace(levels[currentLevel]);
            arena.play(level, player);
        }
        
        public function restartHandler(e:Event=null):void
        {
            play();
        }
        public function menuHandler(e:Event=null):void
        {
            removeChild(arena);
            showMenu();
        }
        public function nextLevelHandler(e:Event=null):void
        {
            currentLevel++;
            if(currentLevel >= levels.length) currentLevel = 0;
            play();
        }
		
        private var osc:int = 0;
        private var oscDir:int = 1;
        private var maxOsc:int = 5;
		public function update(e:Event=null):void
		{
            if(state == MENU) updateMenu();
            if(state == GAME) updateGame();
        }
        
        public function updateMenu():void
        {
            var input:Array = Controller.getUpdates();
            
            if(input[0].indexOf("left") >= 0)
            {
                currentLevel--;
                if(currentLevel < 0) currentLevel = levels.length - 1;
                menuSprite.tf.text = "level " + (currentLevel+1);
            }
            if(input[0].indexOf("right") >= 0)
            {
                currentLevel++;
                if(currentLevel > levels.length -1) currentLevel = 0;
                menuSprite.tf.text = "level " + (currentLevel+1);
            }
            
            if(input[0].indexOf("space") >= 0)
            {
                removeChild(menuSprite);
                play();
            }
        }
        
        public function updateGame():void
        {
            frame++;
            
            var h:int = 0;
            var v:int = 0;
            if(Controller.down)
            {
               v++;   
            }
            if(Controller.up)
            {
                v--;
            }
            if(Controller.left)
            {
                h--;   
            }
            if(Controller.right)
            {
                h++;
            }

            var input:Array = Controller.getUpdates();
            
//            if(Controller.isDown("spin")) player.spinRight();
//            if(Controller.isDown("spinLeft")) player.spinLeft();

            if(input[0].indexOf("spin") >= 0) player.spinRight();
            if(input[0].indexOf("spinLeft") >= 0) player.spinLeft();
            
            if(Math.abs(h) > 0 || Math.abs(v) > 0) player.move(h,v);
            
            arena.update();
		}
	}
}