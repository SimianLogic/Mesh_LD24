package com.mesh
{
    import flash.events.MouseEvent;

    public class MeshEditor extends Arena
    {
        public function MeshEditor(startPixelWidth:int, startPixelHeight:int, startPixelSize:int)
        {
            super(startPixelWidth, startPixelHeight, startPixelSize);
            this.addEventListener(MouseEvent.CLICK, handleClick);
        }
        
        public function handleClick(e:MouseEvent):void
        {
            var hit:Array = localToPixel(e.localX, e.localY);
            
            var meshX:int = hit[0] - currentPlayer.px;
            var meshY:int = hit[1] - currentPlayer.py;

            if(meshX == 0 && meshY == 0)
            {
                trace("CANNOT DELETE YOUR BRAIN!");
                return;
            }
            
            var slot:PixelSlot = currentPlayer.slotFor(meshX, meshY);
            
            if(slot)
            {
                //var index:int = currentPlayer.pixelSlots.indexOf(slot);
                trace("DELETING PIXELSLOT AT " + meshX + "," + meshY);
                currentPlayer.removeSlot(slot);
            }else{
                trace("ADDING PIXELSLOT AT " + meshX + "," + meshY);
                currentPlayer.addSlot(new PixelSlot(meshX, meshY, 0x0000ff, true));
            }
        }
        
        
        private static var _arena:MeshLevel;
        public static function get arena():MeshLevel
        {
            if(_arena == null)
            {
                _arena = new MeshLevel();
                _arena.id = 0;
                _arena.title = "Mesh Editor";
                _arena.size = ArenaSize.byName("9x9");
                _arena.startX = 4;
                _arena.startY = 4;
            }
            
            return _arena;
        }

    }
}