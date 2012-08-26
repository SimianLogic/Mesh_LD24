package com.mesh
{
    public class Path
    {
        //a path is used for AI enemies as well as sub-meshes
        //each point must be a manhattan distance of 1 or less (you can stack)
        
        //Paths act as oscillators--you'll proceed from actionIndex 0 to actionIndex X and then back down from actionIndex X to actionIndex 0
        //  UNLESS: the final actionIndex is a "loop" action and shares the same coordinates as the first actionIndex 
		
        public var frame:int;
		public var frameDelay:int = 1; //1 = no delay
		
		public var actionIndex:int;
        public var actionDirection:int = 1;
        public var actions:Array;
        
        public function Path()
        {
            actions = [new PathAction(0,0, PathAction.WAIT)];
        }
        
        public function get px():int { return actions[actionIndex].px };
        public function get py():int { return actions[actionIndex].py };
		public function get currentAction():PathAction { return actions[actionIndex]; }
        
        public function update():void
        {
			frame++;
            
            if(frame % frameDelay == 0 && actions.length > 1)
            {
                actionIndex += actionDirection;
				if(actionIndex == 0 && actionDirection == -1)
				{
                    trace("Go up!");
					actionDirection = 1;
				}
				
                if(actionIndex == actions.length - 1 && actionDirection == 1)
                {
                    if(actions[actions.length -1].action == "loop" && actions[actions.length -1].px == actions[0].px && actions[actions.length -1].py == actions[0].py)
                    {
                        //loops!
                        trace("LOOP!");
                        actionIndex = 0;
                    }else{
                        //oscillate
                        trace("Go down!");
                        actionDirection = -1                        
                    }
                }
            }
        }
    }
}