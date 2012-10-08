package com.mesh
{
    import flash.events.MouseEvent;

    public class MeshEditor extends Arena
    {
        public function MeshEditor(startPixelWidth:int, startPixelHeight:int, startPixelSize:int)
        {
            super(startPixelWidth, startPixelHeight, startPixelSize);
            this.addEventListener(MouseEvent.CLICK, handleClick);
            showTitleCard = false;
        }
        
        override public function play(level:MeshLevel, player:Mesh):void
        {
            super.play(level, player);
            dirty = true;
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
                currentPlayer.removeSlot(slot);
            }else{
                currentPlayer.addSlot(new PixelSlot(meshX, meshY, 0x0000ff, true));
            }
            dirty = true;
        }
        
        public var dirty:Boolean;
        override public function update(dt:int=0):void
        {
            super.update(dt);
            
            if(dirty)
            {
                currentPlayer.validate();
                for each(var pixelSlot:PixelSlot in currentPlayer.pixelSlots)
                {
                    pixelSlot.pixel.draw();
                    if(!pixelSlot.valid)
                    {
                        pixelSlot.pixel.invalidate();
                    }
                }
                dirty = false;
            }
        }
        
        private static var _arena:MeshLevel;
        public static function getEditorLevel(size:int):MeshLevel
        {
            if(_arena == null)
            {
                _arena = new MeshLevel();
                _arena.id = 0;
                _arena.title = "Mesh Editor";
                _arena.size = ArenaSize.byName(size + "x" + size);
                _arena.startX = (size-1)/2;
                _arena.startY = (size-1)/2;
            }
            
            return _arena;
        }

    }
}