package com.mesh
{
    public class PathAction
    {
        public static var MOVE:String = "move";
        public static var WAIT:String = "wait";
        public static var LOOP:String = "loop";
        public static var SPIN_RIGHT:String = "spin_right";
        public static var SPIN_LEFT:String = "spin_left";
        
        public var px:int;
        public var py:int;
        public var action:String;
        
        public function PathAction(startX:int, startY:int, startAction:String)
        {
            px = startX;
            py = startY;
            action = startAction;
        }
    }
}