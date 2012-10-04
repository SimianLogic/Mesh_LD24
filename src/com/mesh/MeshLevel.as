package com.mesh
{
    import com.adobe.serialization.json.JSON;
    
    import flash.display.FrameLabel;

    public class MeshLevel
    {
        /* JSON FORMAT
         *      id
         *      title
         *      pixelSize: pixelSize
         *      pixelWidth: pixelWidth
         *      pixelHeight: pixelHeight
         *      startX: (player spawn)
         *      startY: (player spawn)
         *      meshes (array of meshes)
         *          x: px
         *          y: py
         *          slots:(array of slots)
         *              x:px
         *              y:py
         *              c:color (string)
         *              filled: 0/1 (start filled or not?)
         *          path:  -- OPTIONAL (if it's not moving, will use the default (0,0) path
         *              frameDelay:(how often to step through the path)
         *              actions:(array of path actions) 
         *                  x:px
         *                  y:py
         *                  action:string
         *
        */
        
        public static var LEVEL_1:String = '{"id":1,"title":"introduction","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":9,"y":9,"specials":["zombie"],"slots":[{"x":0,"y":0},{"x":0,"y":1},{"x":1,"y":0},{"x":-1,"y":0},{"x":0,"y":-1}]}]}';
        public static var LEVEL_2:String = '{"id":2,"title":"more pixels","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":2,"y":5,"specials":["zombie"],"slots":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3},{"x":0,"y":4},{"x":0,"y":5},{"x":0,"y":6}]},{"x":15,"y":5,"specials":["zombie"],"slots":[{"x":0,"y":0},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3},{"x":0,"y":4},{"x":0,"y":5},{"x":0,"y":6}]}]}';
        public static var LEVEL_3:String = '{"id":3,"title":"brain food","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":9,"y":9,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":-1},{"x":0,"y":-2},{"x":0,"y":-3},{"x":0,"y":-4},{"x":1,"y":-3},{"x":-1,"y":-3},{"x":-2,"y":-3},{"x":2,"y":-3},{"x":-3,"y":-3},{"x":3,"y":-3},{"x":-3,"y":-2},{"x":3,"y":-2},{"x":-3,"y":-1},{"x":3,"y":-1},{"x":-3,"y":0},{"x":3,"y":0},{"x":-3,"y":1},{"x":3,"y":1}]}]}';
        public static var LEVEL_4:String = '{"id":4,"title":"moving targets","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":7,"y":8,"slots":[{"x":0,"y":0,"c":"g"},{"x":-1,"y":0},{"x":0,"y":1},{"x":0,"y":-1}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3},{"x":0,"y":4},{"x":0,"y":5}]}},{"x":11,"y":8,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":0,"y":1},{"x":0,"y":-1}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":-1},{"x":0,"y":-2},{"x":0,"y":-3},{"x":0,"y":-4},{"x":0,"y":-5}]}}]}';
        public static var LEVEL_5:String = '{"id":5,"title":"rotator","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":9,"y":5,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0},{"x":2,"y":0},{"x":-2,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":5,"y":0,"action":"spin_right"},{"x":5,"y":1},{"x":5,"y":2},{"x":5,"y":3},{"x":5,"y":4},{"x":5,"y":5},{"x":5,"y":5,"action":"spin_right"},{"x":4,"y":5},{"x":3,"y":5},{"x":2,"y":5},{"x":1,"y":5},{"x":0,"y":5},{"x":-1,"y":5},{"x":-2,"y":5},{"x":-3,"y":5},{"x":-4,"y":5},{"x":-5,"y":5},{"x":-5,"y":5,"action":"spin_right"},{"x":-5,"y":4},{"x":-5,"y":3},{"x":-5,"y":2},{"x":-5,"y":1},{"x":-5,"y":0},{"x":-5,"y":0,"action":"spin_right"},{"x":-4,"y":0},{"x":-3,"y":0},{"x":-2,"y":0},{"x":-1,"y":0},{"x":0,"y":0,"action":"loop"}]}}]}';
        public static var LEVEL_6:String = '{"id":6,"title":"the gauntlet","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":1,"y":0,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0},{"x":9,"y":0},{"x":10,"y":0},{"x":11,"y":0},{"x":12,"y":0},{"x":13,"y":0},{"x":14,"y":0},{"x":15,"y":0}]}},{"x":1,"y":2,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0},{"x":9,"y":0},{"x":10,"y":0},{"x":11,"y":0},{"x":12,"y":0},{"x":13,"y":0},{"x":14,"y":0},{"x":15,"y":0}]}},{"x":1,"y":4,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0},{"x":9,"y":0},{"x":10,"y":0},{"x":11,"y":0},{"x":12,"y":0},{"x":13,"y":0},{"x":14,"y":0},{"x":15,"y":0}]}},{"x":1,"y":6,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0},{"x":9,"y":0},{"x":10,"y":0},{"x":11,"y":0},{"x":12,"y":0},{"x":13,"y":0},{"x":14,"y":0},{"x":15,"y":0}]}},{"x":1,"y":8,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0},{"x":9,"y":0},{"x":10,"y":0},{"x":11,"y":0},{"x":12,"y":0},{"x":13,"y":0},{"x":14,"y":0},{"x":15,"y":0}]}},{"x":16,"y":1,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":-1,"y":0},{"x":-2,"y":0},{"x":-3,"y":0},{"x":-4,"y":0},{"x":-5,"y":0},{"x":-6,"y":0},{"x":-7,"y":0},{"x":-8,"y":0},{"x":-9,"y":0},{"x":-10,"y":0},{"x":-11,"y":0},{"x":-12,"y":0},{"x":-13,"y":0},{"x":-14,"y":0},{"x":-15,"y":0}]}},{"x":16,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":-1,"y":0},{"x":-2,"y":0},{"x":-3,"y":0},{"x":-4,"y":0},{"x":-5,"y":0},{"x":-6,"y":0},{"x":-7,"y":0},{"x":-8,"y":0},{"x":-9,"y":0},{"x":-10,"y":0},{"x":-11,"y":0},{"x":-12,"y":0},{"x":-13,"y":0},{"x":-14,"y":0},{"x":-15,"y":0}]}},{"x":16,"y":5,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":-1,"y":0},{"x":-2,"y":0},{"x":-3,"y":0},{"x":-4,"y":0},{"x":-5,"y":0},{"x":-6,"y":0},{"x":-7,"y":0},{"x":-8,"y":0},{"x":-9,"y":0},{"x":-10,"y":0},{"x":-11,"y":0},{"x":-12,"y":0},{"x":-13,"y":0},{"x":-14,"y":0},{"x":-15,"y":0}]}},{"x":16,"y":7,"slots":[{"x":0,"y":0,"c":"g"},{"x":1,"y":0},{"x":-1,"y":0}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":-1,"y":0},{"x":-2,"y":0},{"x":-3,"y":0},{"x":-4,"y":0},{"x":-5,"y":0},{"x":-6,"y":0},{"x":-7,"y":0},{"x":-8,"y":0},{"x":-9,"y":0},{"x":-10,"y":0},{"x":-11,"y":0},{"x":-12,"y":0},{"x":-13,"y":0},{"x":-14,"y":0},{"x":-15,"y":0}]}}]}';
        public static var LEVEL_7:String = '{"id":7,"title":"eagle","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":8,"y":1,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":-1,"y":1},{"x":-1,"y":0},{"x":-2,"y":0},{"x":-3,"y":0},{"x":-4,"y":0},{"x":-5,"y":0},{"x":-6,"y":0},{"x":-7,"y":0},{"x":-8,"y":0}]},{"x":9,"y":1,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":1,"y":1},{"x":1,"y":0},{"x":2,"y":0},{"x":3,"y":0},{"x":4,"y":0},{"x":5,"y":0},{"x":6,"y":0},{"x":7,"y":0},{"x":8,"y":0}]},{"x":1,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":3,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":5,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":12,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":14,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":16,"y":3,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}},{"x":7,"y":4,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]},{"x":8,"y":4,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]},{"x":9,"y":4,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]},{"x":10,"y":4,"slots":[{"x":0,"y":0,"c":"g"},{"x":0,"y":1},{"x":0,"y":2},{"x":0,"y":3}]}]}';
        public static function get levels():Array { return[LEVEL_1,LEVEL_2,LEVEL_3,LEVEL_4,LEVEL_5,LEVEL_6,LEVEL_7];}
        
        //convenience just so i only need to edit one file while working on levels
        public static var START_LEVEL_INDEX:int = 0;
        
        
        public var id:int;
        public var title:String;
        
        public var startX:int;
        public var startY:int;
        
        public var pixelSize:int;
        public var pixelWidth:int;
        public var pixelHeight:int; 
        
        public var meshObject:Object;
        
        public function MeshLevel()
        {
            //preferred way to create a MeshLevel is MeshLevel.parse(json);
        }
        
        public static function parse(json:String):MeshLevel
        {
            var data:Object = JSON.decode(json);
            var level:MeshLevel = new MeshLevel();
            
            var primitives:Array = ["id","title","startX","startY","pixelSize","pixelWidth","pixelHeight"];
            for each(var key:String in primitives)
            {
                level[key] = data[key];
            }
            
            level.meshObject = data["meshes"];
            
            return level;
        }
        
        //should always store this variable--it generates new isntances every time
        public function get meshes():Array
        {
            if(meshObject == null) return [];
            var ret:Array = [];
            for each(var obj:Object in meshObject)
            {
                var mesh:Mesh = new Mesh();
                if(obj["x"]) mesh.px = obj["x"];
                if(obj["y"]) mesh.py = obj["y"];
                
                //special property processing
                //zombie => hasBrain:false
                //regen => hasRegen:true
                if(obj.hasOwnProperty("specials"))
                {
                 if(obj["specials"].indexOf("zombie") >= 0) mesh.hasBrain = false;
                 if(obj["specials"].indexOf("regen") >= 0)  mesh.hasRegen = true;
                }
                
                for each(var slot:Object in obj["slots"])
                {
                    //default value is filled:true
                    var f:Boolean = true;
                    if(slot.hasOwnProperty("filled"))
                    {
                        f = Boolean(slot["filled"]);
                    }
                    mesh.addSlot(new PixelSlot(slot["x"], slot["y"], colorFromC(slot["c"]), f));
                }
                
                if(obj.hasOwnProperty("path"))
                {
                    var actions:Array = [];
                    for each(var action:Object in obj["path"]["actions"])
                    {
                        actions.push(new PathAction(action["x"], action["y"], action["action"]));                    
                    }
                    var path:Path = new Path();
                    path.actions = actions;
                    path.frameDelay = obj["path"]["frameDelay"];
                    mesh.path = path;
                }
                 
                ret.push(mesh);
            }
            
            return ret;
        }
        
        public static function colorFromC(c:String):uint
        {
            //default color
            if(c == null) return 0x0000ff;
            
            switch(c){
                case "g":
                    return 0x00ff00;
                    break;
                case "b":
                    return 0x0000ff;
                    break;
                case "r":
                    return 0xff0000;
                    break;   
            }
            return 0xffffff;
        }
        
        
    }
}