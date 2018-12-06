#include <libheart.h>
#include "mem.h"
#include "cpu.h"
#include "lang.h"

emu* Chip8Adv = (emu*)0xE000000;
void help();
void OtherSettings();
void DisplaySettings();

	u8 returns[3];
	u8 disploop;
	u8 arpos;

void menu()
{
	hrt_InitTiledText(2);
	hrt_DSPSetBGMode(0);
	hrt_ClearTiledText();
	hrt_DSPEnableBG(2);
	for(disploop = 0; disploop < 8; disploop++)
	{
		hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_main_menu_options[disploop]);
	}
	hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
	hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
	
	arpos = 0;
	for(int i=0;i<16;i++)
	{
		hrt_VblankIntrWait();
		hrt_SetFXLevel(16-i);
	}
	while(!(keyDown(KEY_B)))
	{
		hrt_VblankIntrWait();
		hrt_PrintOnTilemap(0, 7+arpos, "*");
		if(keyDown(KEY_DOWN))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(!(arpos > 5))
			{
				arpos++;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_DOWN))
			{
				hrt_VblankIntrWait();
			}
		}
		if(keyDown(KEY_UP))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(arpos > 0)
			{
				arpos--;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_UP))
			{
				hrt_VblankIntrWait();
			}
		}
		if(keyDown(KEY_A))
		{
			if(arpos == 1)
			{
				DisplaySettings();
			}
			if(arpos == 2)
			{
				OtherSettings();
			}
			if(arpos == 3)
			{
				help();
			}
			if(arpos == 4)
			{
				hrt_Suspend();
			}
			if(arpos == 5)
			{	
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				Initialize();
				break;
			}
			if(arpos == 6)
			{
				hrt_EZ4Exit();
			}
		}
	}
	hrt_FillScreen(0x0000);
	hrt_DSPSetBGMode(4);
	hrt_DSPEnableBG(2);
	hrt_DSPDisableForceBlank();
	render();
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
}

void help()
{
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 10; disploop++)
				{
					hrt_PrintOnTilemap(0, 2+disploop, (char*)gl_help_text[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				hrt_PrintOnTilemap(0, 0, (char*)gl_menu_titles[4]);
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
				while(!(keyDown(KEY_B)))
				{
					hrt_VblankIntrWait();
				}
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 8; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_main_menu_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
}

void OtherSettings()
{
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 5; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_other_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				hrt_PrintOnTilemap(0, 0, (char*)gl_menu_titles[2]);
				hrt_PrintOnTilemap(8, 7, (char*)gl_vsync_options[Chip8Adv->vsync]);
				hrt_PrintOnTilemap(15, 9, (char*)gl_cycles_frame_options[Chip8Adv->clockspeed]);
				hrt_PrintOnTilemap(15, 10, (char*)gl_vsync_options[Chip8Adv->palswap]);
				hrt_PrintOnTilemap(12, 8, (char*)gl_autosleep_options[Chip8Adv->autosleep]);
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
				while(!(keyDown(KEY_B)))
				{
					hrt_VblankIntrWait();
		hrt_PrintOnTilemap(0, 7+arpos, "*");
		if(keyDown(KEY_DOWN))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(!(arpos > 3))
			{
				arpos++;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_DOWN))
			{
				hrt_VblankIntrWait();
			}
		}
		if(keyDown(KEY_UP))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(arpos > 0)
			{
				arpos--;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_UP))
			{
				hrt_VblankIntrWait();
			}
				}
					if(keyDown(KEY_A))
					{
						if(arpos == 0)
						{
							Chip8Adv->vsync++;
							if(Chip8Adv->vsync > 2)
							{
								Chip8Adv->vsync = 0;
							}
							hrt_PrintOnTilemap(8, 7, (char*)gl_vsync_options[Chip8Adv->vsync]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 1)
						{
							Chip8Adv->autosleep++;
							if(Chip8Adv->autosleep > 4)
							{
								Chip8Adv->autosleep = 0;
							}
							hrt_PrintOnTilemap(12, 8, (char*)gl_autosleep_options[Chip8Adv->autosleep]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 2)
						{
							Chip8Adv->clockspeed++;
							if(Chip8Adv->clockspeed> 7)
							{
								Chip8Adv->clockspeed = 0;
							}
							hrt_PrintOnTilemap(15, 9, (char*)gl_cycles_frame_options[Chip8Adv->clockspeed]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 3)
						{
							Chip8Adv->palswap++;
							if(Chip8Adv->palswap > 1)
							{
								Chip8Adv->palswap = 0;
							}
							hrt_PrintOnTilemap(15, 10, (char*)gl_vsync_options[Chip8Adv->palswap]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 4)
						{
							break;
						}
					}
				}
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 8; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_main_menu_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
}

void DisplaySettings()
{
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 4; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_display_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				hrt_PrintOnTilemap(0, 0, (char*)gl_menu_titles[1]);
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
				while(!(keyDown(KEY_B)))
				{
		hrt_PrintOnTilemap(0, 7+arpos, "*");
		if(keyDown(KEY_DOWN))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(!(arpos > 2))
			{
				arpos++;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_DOWN))
			{
				hrt_VblankIntrWait();
			}
		}
		if(keyDown(KEY_UP))
		{
			hrt_PrintOnTilemap(0, 7+arpos, " ");
			if(arpos > 0)
			{
				arpos--;
			}
			hrt_PrintOnTilemap(0, 7+arpos, "*");
			while(keyDown(KEY_UP))
			{
				hrt_VblankIntrWait();
			}
				}
					if(keyDown(KEY_A))
					{
						if(arpos == 0)
						{
							Chip8Adv->palette++;
							if(Chip8Adv->palette > 7)
							{
								Chip8Adv->palette = 0;
							}
							hrt_PrintOnTilemap(10, 7, (char*)gl_palettes[Chip8Adv->palette]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 3)
						{
							break;
						}
					}
				}
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 8; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_main_menu_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(16-i);
				}
}

void RequestExit()
{
	hrt_InitTiledText(2);
	hrt_DSPSetBGMode(0);
	hrt_ClearTiledText();
	hrt_DSPEnableBG(2);
	hrt_PrintOnTilemap(0, 0, (char*)gl_request_ext);
	hrt_SleepF(60);
	hrt_EZ4Exit();
}