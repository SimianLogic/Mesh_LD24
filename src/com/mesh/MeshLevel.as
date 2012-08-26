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
        
        public static var LEVEL_1:String = '{"id":1,"title":"introduction","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":9,"y":9,"brain":0,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":2,"c":"g","filled":1},{"x":2,"y":0,"c":"g","filled":1},{"x":1,"y":0,"c":"g","filled":1},{"x":-2,"y":0,"c":"g","filled":1},{"x":-1,"y":0,"c":"g","filled":1},{"x":0,"y":-1,"c":"g","filled":1},{"x":0,"y":-2,"c":"g","filled":1}]}]}';
        public static var LEVEL_2:String = '{"id":2,"title":"more pixels","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":2,"y":3,"brain":0,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":2,"c":"g","filled":1},{"x":0,"y":3,"c":"g","filled":1},{"x":0,"y":4,"c":"g","filled":1},{"x":0,"y":5,"c":"g","filled":1},{"x":0,"y":6,"c":"g","filled":1},{"x":0,"y":7,"c":"g","filled":1},{"x":0,"y":8,"c":"g","filled":1},{"x":0,"y":9,"c":"g","filled":1},{"x":0,"y":10,"c":"g","filled":1}]},{"x":15,"y":3,"brain":0,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":2,"c":"g","filled":1},{"x":0,"y":3,"c":"g","filled":1},{"x":0,"y":4,"c":"g","filled":1},{"x":0,"y":5,"c":"g","filled":1},{"x":0,"y":6,"c":"g","filled":1},{"x":0,"y":7,"c":"g","filled":1},{"x":0,"y":8,"c":"g","filled":1},{"x":0,"y":9,"c":"g","filled":1},{"x":0,"y":10,"c":"g","filled":1}]}]}';
        public static var LEVEL_3:String = '{"id":3,"title":"brain food","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":9,"y":9,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":-1,"c":"b","filled":1},{"x":0,"y":-2,"c":"b","filled":1},{"x":0,"y":-3,"c":"b","filled":1},{"x":0,"y":-4,"c":"b","filled":1},{"x":1,"y":-3,"c":"b","filled":1},{"x":-1,"y":-3,"c":"b","filled":1},{"x":-2,"y":-3,"c":"b","filled":1},{"x":2,"y":-3,"c":"b","filled":1},{"x":-3,"y":-3,"c":"b","filled":1},{"x":3,"y":-3,"c":"b","filled":1},{"x":-3,"y":-2,"c":"b","filled":1},{"x":3,"y":-2,"c":"b","filled":1},{"x":-3,"y":-1,"c":"b","filled":1},{"x":3,"y":-1,"c":"b","filled":1},{"x":-3,"y":0,"c":"b","filled":1},{"x":3,"y":0,"c":"b","filled":1},{"x":-3,"y":1,"c":"b","filled":1},{"x":3,"y":1,"c":"b","filled":1}]}]}';
        public static var LEVEL_4:String = '{"id":4,"title":"moving targets","pixelSize":24,"pixelWidth":18,"pixelHeight":18,"startX":9,"startY":16,"meshes":[{"x":2,"y":3,"brain":0,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":2,"c":"g","filled":1},{"x":0,"y":3,"c":"g","filled":1},{"x":0,"y":4,"c":"g","filled":1},{"x":0,"y":5,"c":"g","filled":1},{"x":0,"y":6,"c":"g","filled":1},{"x":0,"y":7,"c":"g","filled":1},{"x":0,"y":8,"c":"g","filled":1},{"x":0,"y":9,"c":"g","filled":1},{"x":0,"y":10,"c":"g","filled":1}]},{"x":15,"y":3,"brain":0,"slots":[{"x":0,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":2,"c":"g","filled":1},{"x":0,"y":3,"c":"g","filled":1},{"x":0,"y":4,"c":"g","filled":1},{"x":0,"y":5,"c":"g","filled":1},{"x":0,"y":6,"c":"g","filled":1},{"x":0,"y":7,"c":"g","filled":1},{"x":0,"y":8,"c":"g","filled":1},{"x":0,"y":9,"c":"g","filled":1},{"x":0,"y":10,"c":"g","filled":1}]},{"x":7,"y":8,"slots":[{"x":0,"y":0,"c":"b","filled":1},{"x":-1,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":-1,"c":"g","filled":1}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":1,"action":"move"},{"x":0,"y":2,"action":"move"},{"x":0,"y":3,"action":"move"},{"x":0,"y":4,"action":"move"},{"x":0,"y":5,"action":"move"}]}},{"x":11,"y":8,"slots":[{"x":0,"y":0,"c":"b","filled":1},{"x":1,"y":0,"c":"g","filled":1},{"x":0,"y":1,"c":"g","filled":1},{"x":0,"y":-1,"c":"g","filled":1}],"path":{"frameDelay":4,"actions":[{"x":0,"y":0,"action":"wait"},{"x":0,"y":-1,"action":"move"},{"x":0,"y":-2,"action":"move"},{"x":0,"y":-3,"action":"move"},{"x":0,"y":-4,"action":"move"},{"x":0,"y":-5,"action":"move"}]}}]}';
        
        public var id:int;
        public var title:String;
        
        public var startX:int;
        public var startY:int;
        
        //should maybe abstract these into small/medium/large boards?
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
                if(obj.hasOwnProperty("brain")) mesh.hasBrain = Boolean(obj["brain"]);
                
                for each(var slot:Object in obj["slots"])
                {                  
                    mesh.addSlot(new PixelSlot(slot["x"], slot["y"], colorFromC(slot["c"]), Boolean(slot["filled"])));
                }
                
                if(obj.hasOwnProperty("path"))
                {
                    var actions:Array = [];
                    for each(var action:Object in obj["path"]["actions"])
                    {
                        actions.push(new PathAction(action["x"], action["y"], action["action"]));                    
                    }
                    var path = new Path();
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