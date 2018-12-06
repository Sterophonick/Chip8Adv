#include <libheart.h>
#include "cpu.h"

char pogoshell_romname[32]; 	//keep track of rom name (for state saving, etc)
char pogoshell;
int pogosize=0;			//size of rom if starting from pogoshell


void DetectPogoshell()
{
	u32 temp=(u32)(*(u8**)0x0203FBFC);
	pogoshell=((temp & 0xFE000000) == 0x08000000)?1:0;
}