package com.mesh
{
    public class ArenaSize
    {
        public var name:String;
        public var pixelSize:int;
        public var pixelWidth:int;
        public var pixelHeight:int;
        
        
        //should maybe abstract these into small/medium/large boards?
        //this yields final dimensions of 450x450 -- 30,30,14
        //other possible dimensions: 45,45,9 / 50,50,8 / 75,75,5 / 90,90,4 / 150,150,2
        //smaller dimensions: 9,9,49 / 10,10,44 / 18,18,24
        public function ArenaSize(name:String, pixelSize:int, pixelWidth:int, pixelHeight:int)
        {
            this.name = name;
            this.pixelSize = pixelSize;
            this.pixelWidth = pixelWidth;
            this.pixelHeight = pixelHeight;
        }
        
        public static var _9x9:ArenaSize;
        public static var _10x10:ArenaSize;
        public static var _18x18:ArenaSize;
        public static var _30x30:ArenaSize;
        public static var _45x45:ArenaSize;
        public static var _50x50:ArenaSize;
        public static var _75x75:ArenaSize;
        public static var _90x90:ArenaSize;
        public static var _150x150:ArenaSize;
        
        
        
        public static function nextSize(size:ArenaSize):ArenaSize
        {
            var which:int = SIZES.indexOf(size.name);
            if(which >= 0 && which < SIZES.length)
            {
                return byName(SIZES[which + 1]);
            }
            return null;
        }
        
        public static const SIZES:Array = ["9x9","10x10","18x18","30x30","45x45","50x50","75x75","90x90","150x150"];
        
        public static function byName(name:String):ArenaSize
        {
            trace("GET ARENA SIZE " + name);
            
            switch(name){
                case "9x9":
                    if(_9x9 == null) _9x9 = new ArenaSize("9x9", 49, 9, 9);
                    return _9x9;
                    break;
                case "10x10":
                    if(_10x10 == null) _10x10 = new ArenaSize("10x10", 44, 10, 10);
                    return _10x10;
                    break;
                case "18x18":
                    if(_18x18 == null) _18x18 = new ArenaSize("18x18", 24, 18, 18);
                    return _18x18;
                    break;
                case "30x30":
                    if(_30x30 == null) _30x30 = new ArenaSize("30x30", 14, 30, 30);
                    return _30x30;
                    break;
                case "45x45":
                    if(_45x45 == null) _45x45 = new ArenaSize("45x45", 9, 45, 45);
                    return _45x45;
                    break;
                case "50x50":
                    if(_50x50 == null) _50x50 = new ArenaSize("50x50", 8, 50, 50);
                    return _50x50;
                    break;
                case "75x75":
                    if(_75x75 == null) _75x75 = new ArenaSize("75x75", 5, 75, 75);
                    return _75x75;
                    break;
                case "90x90":
                    if(_90x90 == null) _90x90 = new ArenaSize("90x90", 4, 75, 75);
                    return _90x90;
                    break;
                case "150x150":
                    if(_150x150 == null) _150x150 = new ArenaSize("150x150", 2, 150, 150);
                    return _150x150;
                    break;
            }
            
            throw new Error("Unrecognized arena size: " + name);
            return null;
        }
        
        
        
    }
}