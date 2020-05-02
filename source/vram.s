emuDrawScreen:

//r0: x
//r1: y
//r2: n
emuDrawSprite:
	and r0, #0xff
	and r1, #0xff
	and r2, #0xff