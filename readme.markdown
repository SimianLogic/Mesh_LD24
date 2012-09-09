MAYBE TODOs
===============
* unbounded world (with camera centered on player)


MAJOR TODOs
===============
* mesh editor, add a pixel after each level
* path editor for motion/AI meshes
* submesh support


MINOR TODOs
===============
* de-couple move speed from resolution so moving doesn't feel so fast (make loc a float)
* make sure resolution-independence still works ok (just change a level)
* create constants/names for each board resolution
* add a flag to Mesh for whether it can regenerate (most enemies shouldn't)

BUGS
===============
* re-visit resetting an arena so they don't have to be re-created every time
* lock out player input when a popup is showing