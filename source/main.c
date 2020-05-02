#include <libheart.h>
u16 keys_pressed;
u16 keys_released;

int main(void)
{
	hrt_InitIRQ();
	hrt_EnableIRQ(IRQ_VBLANK);
	hrt_DSPSetBGMode(0);
	hrt_InitTextEngine(0);
	hrt_DSPDisableForceBlank();
	hrt_DSPEnableBG(0);
	do {
		hrt_VblankIntrWait();
	} while (1);
}