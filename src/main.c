#include <libheart.h>
#include "cpu.h"
#include "ibm.h"

int main()
{
	hrt_Init();
	hrt_DSPSetBGMode(4);
	hrt_DSPEnableBG(2);
	hrt_DSPDisableForceBlank();
	Initialize();
	while(1)
	{
		hrt_VblankIntrWait();
		if(Chip8.drawFlag)
		{
			render();
		}
		for(int i = 0; i < 20; i++)
		{
			Keypad();
			emulateCycle();
		}
			if(keyDown(KEY_R))
			{
				if(keyDown(KEY_L)) menu();
			}
		}
	return 0;
}