MAYBE TODOs
===============
* unbounded world (with camera centered on player)


MAJOR TODOs
===============
* proper state/screen manager (sometimes losing reference to intro popup, which breaks the game)
* add a pixel after each level
* player pixel budgets (remove pixel to get one back)
* only allow pixels connected to the main body 
* store pixelType on PixelSlot (brain, mover, armored, etc...)
* edit colors in the mesh editor
* path editor for motion/AI meshes
* submesh support


MINOR TODOs
===============
* add a fade-out timer for free pixels

BUGS
===============
* re-visit resetting an arena so they don't have to be re-created every time



DESIGN NOTES
===============
* players unlock larger editors as they progress (bigger enemies, too)
* sub-meshes should be limited to next editor size down (so 10x10 can hold 5x5 submeshes, which can hold 3x3 submeshes)
