#include <libheart.h>
#include "mem.h"
#include "cpu.h"
#include "lang.h"

emu* Chip8Adv = (emu*)0xE000000;
void help();
void OtherSettings();
void DisplaySettings();
void drawclock();
void ControllerSettings();
void RemapButtons();

u8 updatevsync=0;

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
	for(register int i=0;i<16;i++)
	{
		hrt_VblankIntrWait();
		hrt_SetFXLevel(16-i);
	}
	while(!(keyDown(KEY_B)))
	{
		hrt_VblankIntrWait();
		drawclock();
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
			if(arpos == 0)
			{
				ControllerSettings();
			}
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
				hrt_FXSetBlendMode(FX_MODE_BRIGHTEN);
				hrt_FXEnableBackdrop(0);
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_EZ4Exit();
			}
		}
	}
	hrt_FillScreen(0x0000);
	hrt_DSPSetBGMode(4);
	hrt_DSPEnableBG(2);
	hrt_DSPDisableForceBlank();
	render();
	hrt_FXSetBlendMode(FX_MODE_DARKEN);
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
							updatevsync = 1;
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
				hrt_PrintOnTilemap(10, 7, (char*)gl_palettes[Chip8Adv->palette]);
				hrt_PrintOnTilemap(13, 8, (char*)gl_brightness_options[Chip8Adv->brightness]);
				hrt_PrintOnTilemap(14, 9, (char*)gl_vsync_options[Chip8Adv->dblsize]);
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
							if(Chip8Adv->palette > 6)
							{
								Chip8Adv->palette = 0;
							}
							hrt_PrintOnTilemap(10, 7, (char*)gl_palettes[Chip8Adv->palette]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 1)
						{
							Chip8Adv->brightness++;
							if(Chip8Adv->brightness > 4)
							{
								Chip8Adv->brightness = 0;
							}
							hrt_PrintOnTilemap(13, 8, (char*)gl_brightness_options[Chip8Adv->brightness]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 2)
						{
							updatevsync = 1;
							Chip8Adv->dblsize++;
							if(Chip8Adv->dblsize > 1)
							{
								Chip8Adv->dblsize = 0;
							}
							hrt_PrintOnTilemap(14, 9, (char*)gl_vsync_options[Chip8Adv->dblsize]);
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

void ControllerSettings()
{
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 2; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_controller_options[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				hrt_PrintOnTilemap(0, 0, (char*)gl_menu_titles[0]);
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
							RemapButtons();
						}
						if(arpos == 1)
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
				while(keyDown(KEY_A))
				{
					hrt_VblankIntrWait();
				}
	for(disploop = 0; disploop < 8; disploop++)
	{
		hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_main_menu_options[disploop]);
	}
	hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
	hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
	arpos = 0;
	for(register int i=0;i<16;i++)
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

void debugger()
{
	/*
	hrt_InitTiledText(2);
	hrt_DSPSetBGMode(0);
	hrt_ClearTiledText();
	hrt_DSPEnableBG(2);
	hrt_PrintOnTilemap(0, 0, "PC: %x", Chip8.pc);
	hrt_PrintOnTilemap(0, 1, "OP: %x", Chip8.opcode);
	while(1);
	*/
}

void drawclock()
{
    char str[30];
    char *s=str+20;
    int timer,mod;
	strcpy(str,"                    00:00:00");
	timer=hrt_GetRTCTime();
	mod=(timer>>4)&3;				//Hours.
	*(s++)=(mod+'0');
	mod=(timer&15);
	*(s++)=(mod+'0');
	s++;
	mod=(timer>>12)&15;				//Minutes.
	*(s++)=(mod+'0');
	mod=(timer>>8)&15;
	*(s++)=(mod+'0');
	s++;
	mod=(timer>>20)&15;				//Seconds.
	*(s++)=(mod+'0');
	mod=(timer>>16)&15;
	*(s++)=(mod+'0');
	hrt_PrintOnTilemap(2, 0, str);
}

void RemapButtons()
{
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 9; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_keypad_menu[disploop]);
				}
				hrt_PrintOnTilemap(0, 18, (char*)gl_credit_ln0);
				hrt_PrintOnTilemap(0, 19, (char*)gl_credit_ln1);
				hrt_PrintOnTilemap(0, 0, (char*)gl_menu_titles[5]);
				hrt_PrintOnTilemap(4, 7+0, (char*)gl_keypad_options[Chip8Adv->a_key]);
				hrt_PrintOnTilemap(4, 7+1, (char*)gl_keypad_options[Chip8Adv->b_key]);
				hrt_PrintOnTilemap(5, 7+2, (char*)gl_keypad_options[Chip8Adv->up_key]);
				hrt_PrintOnTilemap(7, 7+3, (char*)gl_keypad_options[Chip8Adv->down_key]);
				hrt_PrintOnTilemap(7, 7+4, (char*)gl_keypad_options[Chip8Adv->left_key]);
				hrt_PrintOnTilemap(8, 7+5, (char*)gl_keypad_options[Chip8Adv->right_key]);
				hrt_PrintOnTilemap(9, 7+6, (char*)gl_keypad_options[Chip8Adv->sel_key]);
				hrt_PrintOnTilemap(8, 7+7, (char*)gl_keypad_options[Chip8Adv->strt_key]);
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
			if(!(arpos > 8))
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
							Chip8Adv->a_key++;
							if(Chip8Adv->a_key > 0xF)
							{
								Chip8Adv->a_key = 0;
							}
							hrt_PrintOnTilemap(4, 7+arpos, (char*)gl_keypad_options[Chip8Adv->a_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 1)
						{
							Chip8Adv->b_key++;
							if(Chip8Adv->b_key > 0xF)
							{
								Chip8Adv->b_key = 0;
							}
							hrt_PrintOnTilemap(4, 7+arpos, (char*)gl_keypad_options[Chip8Adv->b_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 2)
						{
							Chip8Adv->up_key++;
							if(Chip8Adv->up_key > 0xF)
							{
								Chip8Adv->up_key = 0;
							}
							hrt_PrintOnTilemap(5, 7+arpos, (char*)gl_keypad_options[Chip8Adv->up_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 3)
						{
							Chip8Adv->down_key++;
							if(Chip8Adv->down_key > 0xF)
							{
								Chip8Adv->down_key = 0;
							}
							hrt_PrintOnTilemap(7, 7+arpos, (char*)gl_keypad_options[Chip8Adv->down_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 4)
						{
							Chip8Adv->left_key++;
							if(Chip8Adv->left_key > 0xF)
							{
								Chip8Adv->left_key = 0;
							}
							hrt_PrintOnTilemap(7, 7+arpos, (char*)gl_keypad_options[Chip8Adv->left_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 5)
						{
							Chip8Adv->right_key++;
							if(Chip8Adv->right_key > 0xF)
							{
								Chip8Adv->right_key = 0;
							}
							hrt_PrintOnTilemap(8, 7+arpos, (char*)gl_keypad_options[Chip8Adv->right_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 6)
						{
							Chip8Adv->sel_key++;
							if(Chip8Adv->sel_key > 0xF)
							{
								Chip8Adv->sel_key = 0;
							}
							hrt_PrintOnTilemap(9, 7+arpos, (char*)gl_keypad_options[Chip8Adv->sel_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 7)
						{
							Chip8Adv->strt_key++;
							if(Chip8Adv->strt_key > 0xF)
							{
								Chip8Adv->strt_key = 0;
							}
							hrt_PrintOnTilemap(8, 7+arpos, (char*)gl_keypad_options[Chip8Adv->strt_key]);
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
						}
						if(arpos == 8)
						{
							while(keyDown(KEY_A))
							{
								hrt_VblankIntrWait();
							}
							break;
						}
					}
				}
							while(keyDown(KEY_B))
							{
								hrt_VblankIntrWait();
							}
				arpos = 0;
				for(int i=0;i<16;i++)
				{
					hrt_VblankIntrWait();
					hrt_SetFXLevel(i);
				}
				hrt_ClearTiledText();
				for(disploop = 0; disploop < 2; disploop++)
				{
					hrt_PrintOnTilemap(1, 7+disploop, (char*)gl_controller_options[disploop]);
				}
}