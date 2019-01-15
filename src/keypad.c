#include <libheart.h>
#include "cpu.h"
//0-F
u8 colorLock;
u8 speedLock;
u8 vsyncLock;

void Keypad()
{
	if(keyDown(KEY_A))
	{
		key[Chip8Adv->a_key] = 1;
	}else{
		key[Chip8Adv->a_key] = 0;
	}
	if(keyDown(KEY_B))
	{
		key[Chip8Adv->b_key] = 1;
	}else{
		key[Chip8Adv->b_key] = 0;
	}
	if(keyDown(KEY_UP))
	{
		key[Chip8Adv->up_key] = 1;
	}else{
		key[Chip8Adv->up_key] = 0;
	}
	if(keyDown(KEY_DOWN))
	{
		key[Chip8Adv->down_key] = 1;
	}else{
		key[Chip8Adv->down_key] = 0;
	}
	if(keyDown(KEY_LEFT))
	{
		key[Chip8Adv->left_key] = 1;
	}else{
		key[Chip8Adv->left_key] = 0;
	}
	if(keyDown(KEY_RIGHT))
	{
		key[Chip8Adv->right_key] = 1;
	}else{
		key[Chip8Adv->right_key] = 0;
	}
	if(keyDown(KEY_SELECT))
	{
		key[Chip8Adv->sel_key] = 1;
	}else{
		key[Chip8Adv->sel_key] = 0;
	}
	if(keyDown(KEY_START))
	{
		key[Chip8Adv->strt_key] = 1;
	}else{
		key[Chip8Adv->strt_key] = 0;
	}
}

void MiscKeys()
{
	if(keyDown(KEY_L))
	{
		if(keyDown(KEY_START))
		{
			if(keyDown(KEY_A)) //Exit
			{
				hrt_FXSetBlendMode(FX_MODE_BRIGHTEN);
				hrt_FXEnableBackdrop(0);
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_EZ4Exit();
			}
			if(!vsyncLock)
			{
				Chip8Adv->vsync++;
				if(Chip8Adv->vsync > 2)
				{
					Chip8Adv->vsync = 0;
				}
				vsyncLock = 1;
			}
		}else if(keyDown(KEY_SELECT)){
			if(!colorLock)
			{
				Chip8Adv->palette++;
				if(Chip8Adv->palette > 6)
				{
					Chip8Adv->palette = 0;
				}
				colorLock = 1;
			}
		}else if(keyDown(KEY_A)){
			if(!speedLock)
			{
				Chip8Adv->clockspeed++;
				if(Chip8Adv->clockspeed> 7)
				{
					Chip8Adv->clockspeed = 0;
				}
				speedLock = 1;
			}
		}else{
			vsyncLock = 0;
			colorLock = 0;
			speedLock = 0;
		}
	}
}