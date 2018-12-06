#include <libheart.h>
#include "cpu.h"
//0-F
u8 keyA = 0;
u8 keyB = 1;
u8 keyUp = 5;
u8 key_Down = 8;
u8 keyLeft = 7;
u8 keyRight = 9;
u8 keySel = 6;
u8 keyStart = 0xA;

void Keypad()
{
	if(keyDown(KEY_A))
	{
		key[keyA] = 1;
	}else{
		key[keyA] = 0;
	}
	if(keyDown(KEY_B))
	{
		key[keyB] = 1;
	}else{
		key[keyB] = 0;
	}
	if(keyDown(KEY_UP))
	{
		key[keyUp] = 1;
	}else{
		key[keyUp] = 0;
	}
	if(keyDown(KEY_DOWN))
	{
		key[key_Down] = 1;
	}else{
		key[key_Down] = 0;
	}
	if(keyDown(KEY_LEFT))
	{
		key[keyLeft] = 1;
	}else{
		key[keyLeft] = 0;
	}
	if(keyDown(KEY_RIGHT))
	{
		key[keyRight] = 1;
	}else{
		key[keyRight] = 0;
	}
	if(keyDown(KEY_SELECT))
	{
		key[keySel] = 1;
	}else{
		key[keySel] = 0;
	}
	if(keyDown(KEY_START))
	{
		key[keyStart] = 1;
	}else{
		key[keyStart] = 0;
	}
}

void MiscKeys()
{
	
}