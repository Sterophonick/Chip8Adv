#include <libheart.h>
#include "cpu.h"

int pogoshell;
u32 pogotemp;

void DetectPogo()
{
	pogotemp=(u32)(*(u8**)0x0203FBFC);
	pogoshell=((pogotemp & 0xFE000000) == 0x08000000)?1:0;
}