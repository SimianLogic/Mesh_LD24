MAYBE TODOs
===============
* unbounded world (with camera centered on player)


MAJOR TODOs
===============
* proper state/screen manager (sometimes losing reference to intro popup, which breaks the game)
* player pixel budgets (remove pixel to get one back)
* store pixelType on PixelSlot (brain, mover, armored, etc...)
* edit colors in the mesh editor
* path editor for motion/AI meshes
* submesh support
* don't allow player to save mesh unless it's valid


MINOR TODOs
===============

BUGS
===============


DESIGN NOTES
===============
* players unlock larger editors as they progress (bigger enemies, too)
* sub-meshes should be limited to next editor size down (so 10x10 can hold 5x5 submeshes, which can hold 3x3 submeshes)
