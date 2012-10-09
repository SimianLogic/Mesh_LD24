package
{
	import com.mesh.Arena;
	import com.mesh.Controller;
	import com.mesh.Mesh;
	import com.mesh.MeshEditor;
	import com.mesh.MeshLevel;
	import com.mesh.PixelSlot;
	import com.simianlogic.managers.DataManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width='640', height='480', backgroundColor='0xffffff', frameRate='30')]
	public class MeshGame extends Sprite
	{
        public static var SHARED_OBJECT_KEY:String = "mesh_so";
        public static var DEFAULT_DATA_KEYS:Array = ["player"];
        public static var DEFAULT_DATA_VALUES:Array = [{"specials":["regen"],"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":1,"y":0},{"x":-1,"y":0},{"x":0,"y":-1}]}];
        
		public var frame:int = 0;
        public var frameDelay:int = 4;
        
        //current, active arena and current, active player
		public var arena:Arena;
        public var player:Mesh;
        
        //arena used for upgrading, and the player's design for their mesh
        public var upgradeArena:MeshEditor;        
        public var upgradePlayer:Mesh;

        public var controller:Controller;
		
        public static var PIXEL_SPEED:Number = 0.25;
        public static var PIXEL_COOLDOWN:int = 60;
        
        public var currentLevel:int = 0;
        public var levels:Array;
        
        public var state:int;
        public static const MENU:int = 0;
        public static const GAME:int = 1;
        public static const UPGRADE:int = 2;
        
		public function MeshGame()
		{
            //looking these up statically just to save time while tinkering
            levels = MeshLevel.levels;
            currentLevel = MeshLevel.START_LEVEL_INDEX;
           
            controller = Controller.getInstance(stage);
            
            Controller.registerAction("space",32);
            Controller.registerAction("esc", 27);
            Controller.registerAction("upgrade", 85);
            
            var dm:DataManager = DataManager.getInstance(SHARED_OBJECT_KEY, DEFAULT_DATA_KEYS, DEFAULT_DATA_VALUES);
            
            var playerObject:Object = DataManager.getStat("player");
            upgradePlayer = Mesh.fromObject(playerObject);
            
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
        
        public function upgrade():void
        {
            state = UPGRADE;
                        
            var pixelWidth:int = 9;
            var pixelHeight:int = 9;
            var pixelSize:int = 49;
            
            //no reason to dispose of upgradeArena each time...it's data can only change while upgrading
            if(upgradeArena == null)
            {
                upgradeArena = new MeshEditor(pixelWidth, pixelHeight, pixelSize);
                upgradeArena.x = 15;
                upgradeArena.y = 15;
                upgradeArena.active = false;
            }
                
            addChild(upgradeArena);
            
            upgradeArena.play(MeshEditor.getEditorLevel(5), upgradePlayer);
        }
        
        public function disposeOfArena(old_arena:Arena):void
        {
            if(old_arena)
            {
                old_arena.removeEventListener("nextLevel", nextLevelHandler);
                old_arena.removeEventListener("restart", nextLevelHandler);
                old_arena.removeEventListener("menu", menuHandler);
                if(contains(old_arena)) removeChild(old_arena);
                old_arena = null;
            }
        }
        
        public function play():void
        {
            state = GAME;
            
            var level:MeshLevel = MeshLevel.parse(levels[currentLevel]);
            
            var pixelWidth:int = level.size.pixelWidth;
            var pixelHeight:int = level.size.pixelHeight;
            var pixelSize:int = level.size.pixelSize;
            
            disposeOfArena(arena);

            arena = new Arena(pixelWidth, pixelHeight, pixelSize);
            addChild(arena);
            arena.x = 15;
            arena.y = 15;
            
            arena.addEventListener("nextLevel", nextLevelHandler);
            arena.addEventListener("restart", restartHandler);
            arena.addEventListener("menu", menuHandler);
            
            player = Mesh.fromMesh(upgradePlayer);
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
            if(state == UPGRADE) updateUpgrade();
        }
        
        public function updateUpgrade():void
        {
            var input:Array = Controller.getUpdates();
            if(input[0].indexOf("esc") >= 0)
            {
                if(contains(upgradeArena))
                {
                    removeChild(upgradeArena);
                    showMenu();
                }
            }
            
            upgradeArena.update();
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
            
            if(input[0].indexOf("upgrade") >= 0)
            {
                removeChild(menuSprite);
                upgrade();
            }
        }
        
        public function updateGame():void
        {
            var input:Array = Controller.getUpdates();
            if(input[0].indexOf("esc") >= 0)
            {
                trace("SHOW MENU");
                removeChild(arena);
                showMenu();
            }
            
            if(arena.PAUSED) return;

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

            if(input[0].indexOf("spin") >= 0) player.spinRight();
            if(input[0].indexOf("spinLeft") >= 0) player.spinLeft();
            
            //player knows its own velocity!
            if(Math.abs(h) > 0 || Math.abs(v) > 0) player.move(h,v);
            
            arena.update();
		}
	}
}