#include <libheart.h>
#include "cpu.h"
#include "lang.h"
#include "car.h"

u32 autosleeptimer;

char setLowerNibble(char orig, char nibble) {
    char res = orig;
    res &= 0xF0; // Clear out the lower nibble
    res |= (nibble & 0x0F); // OR in the desired mask
    return res;
}

char setUpperNibble(char orig, char nibble) {
    char res = orig;
    res &= 0x0F; // Clear out the upper nibble
    res |= ((nibble << 4) & 0xF0); // OR in the desired mask
    return res;
}

int main()
{
	hrt_Init();
	hrt_DSPSetBGMode(4);
	hrt_DSPEnableBG(2);
	hrt_DSPDisableForceBlank();
	DetectPogoshell();
	Initialize();
	hrt_FXSetBlendMode(FX_MODE_DARKEN);
	hrt_FXEnableBGTarget1(2);
	autosleeptimer = 0;
	while(1)
	{
		hrt_SleepF(Chip8Adv->vsync);
		if(Chip8Adv->autosleep > 0)
		{
			if(autosleeptimer >= gl_autosleep_times[Chip8Adv->autosleep])
			{
				hrt_Suspend();
				autosleeptimer = 0;
			}
		}
		tick();
		if(Chip8.drawFlag)
		{
			render();
		}
		Keypad();
		for(int i = 0; i < gl_clock_speeds[Chip8Adv->clockspeed]; i++)
		{
			emulateCycle();
		}
			if(keyDown(KEY_R))
			{
				if(keyDown(KEY_L))
				{
					for(int i=0;i<16;i++)
					{
						hrt_VblankIntrWait();
						hrt_SetFXLevel(i);
					}
					menu();
				}
			}
			if(!(KEY_ANY_PRESSED))
			{
				autosleeptimer++;
			}else{
				autosleeptimer=0;
			}
		}
	return 0;
}