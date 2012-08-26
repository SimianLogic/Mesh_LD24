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
        
		public function MeshGame()
		{
//			var pixelWidth:int = 64;
//			var pixelHeight:int = 48;
//			var pixelSize:int = 9;
            var pixelWidth:int = 18;
            var pixelHeight:int = 18
            var pixelSize:int = 24;
            
            //this yields final dimensions of 450x450 -- 30,30,14
            //other possible dimensions: 45,45,9 / 50,50,8 / 75,75,5 / 90,90,4 / 150,150,2
            //smaller dimensions: 10,10,44 (TOO SMALL) / 18,18,24
            
            controller = Controller.getInstance(stage);
            
            Controller.registerAction("space",32);
            Controller.registerAction("esc", 27);
            
//            Controller.registerAction("spin",32); //spacebar
//            Controller.registerAction("spinLeft", 80);
//            Controller.registerAction("pause", 80);

			
			arena = new Arena(pixelWidth, pixelHeight, pixelSize);
			addChild(arena);
            arena.x = 15;
            arena.y = 15;
            
            player = new Mesh();
            
            player.addSlot(new PixelSlot(0, 0, 0x00ff00, true));
            player.addSlot(new PixelSlot(0, 1, 0x0000ff, true));
            player.addSlot(new PixelSlot(1, 0, 0x0000ff, true));
            player.addSlot(new PixelSlot(0, -1, 0x0000ff, true));
            player.addSlot(new PixelSlot(-1, 0, 0x0000ff, true));
            //sword form!
//            addSlot(new PixelSlot(-2, 0, 0x00ff00));
//            addSlot(new PixelSlot(-3, 0, 0x00ff00));
            
            
//            player.setBounds(0,0,pixelWidth, pixelHeight);
//            arena.addMesh(player);
            
            var level1:MeshLevel = MeshLevel.parse(MeshLevel.LEVEL_3);
            arena.play(level1, player);
            
			/*
			for(var i:int = 0; i < 25; i++)
			{
				var angle:Number = Math.random()*2*Math.PI;
				var p:Pixel = new Pixel(0xffffff, Math.floor(Math.random()*pixelWidth), Math.floor(Math.random()*pixelHeight),Math.cos(angle)*PIXEL_SPEED, Math.sin(angle)*PIXEL_SPEED); 
				
				arena.addPixel(p);
			}
			
            enemy = new Mesh(pixelSize, 12, 12);
            enemy.setBounds(0,0,pixelWidth, pixelHeight);
            arena.addMesh(enemy);
			
			var path:Path = new Path();
			path.frameDelay = 3;
			path.actions.push(new PathAction(0,1,PathAction.MOVE));
			path.actions.push(new PathAction(0,2,PathAction.MOVE));
			path.actions.push(new PathAction(0,3,PathAction.MOVE));
			path.actions.push(new PathAction(0,4,PathAction.MOVE));
			path.actions.push(new PathAction(-1,4,PathAction.MOVE));
			path.actions.push(new PathAction(-2,4,PathAction.MOVE));
			path.actions.push(new PathAction(-3,4,PathAction.MOVE));
			path.actions.push(new PathAction(-4,4,PathAction.MOVE));
			path.actions.push(new PathAction(-4,3,PathAction.MOVE));
			path.actions.push(new PathAction(-4,2,PathAction.MOVE));
			path.actions.push(new PathAction(-4,1,PathAction.MOVE));
			path.actions.push(new PathAction(-4,0,PathAction.MOVE));
			path.actions.push(new PathAction(-4,0,PathAction.MOVE));
			path.actions.push(new PathAction(-3,0,PathAction.MOVE));
			path.actions.push(new PathAction(-2,0,PathAction.MOVE));
			path.actions.push(new PathAction(-1,0,PathAction.MOVE));
			path.actions.push(new PathAction(0,0,PathAction.LOOP));
			enemy.path = path;
            */
            
			this.addEventListener(Event.ENTER_FRAME, update);	
		}
		
        private var osc:int = 0;
        private var oscDir:int = 1;
        private var maxOsc:int = 5;
		public function update(e:Event=null):void
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