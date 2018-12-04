#include <libheart.h>
#include "cpu.h"
c8system Chip8 HRT_EWRAM_DATA;

#define ROM_SIZE 1775

	u8 memory[4096] HRT_EWRAM_DATA; //RAM
	u16 videobuffer[64*32] HRT_EWRAM_DATA; //video before it gets copied to RAM
	u16 stack[16] HRT_EWRAM_DATA;
	u8 key[16] HRT_EWRAM_DATA;
	u8 Buffer[38400] HRT_EWRAM_DATA;
unsigned char chip8_fontset[80] =
{ 
    0xF0, 0x90, 0x90, 0x90, 0xF0, //0
    0x20, 0x60, 0x20, 0x20, 0x70, //1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, //2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, //3
    0x90, 0x90, 0xF0, 0x10, 0x10, //4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, //5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, //6
    0xF0, 0x10, 0x20, 0x40, 0x40, //7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, //8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, //9
    0xF0, 0x90, 0xF0, 0x90, 0x90, //A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, //B
    0xF0, 0x80, 0x80, 0x80, 0xF0, //C
    0xE0, 0x90, 0x90, 0x90, 0xE0, //D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, //E
    0xF0, 0x80, 0xF0, 0x80, 0x80  //F
};


void Initialize()
{
	hrt_SetBGPalEntry(0, 0x0000);
	hrt_SetBGPalEntry(1, 0xFFFF);
	Chip8.pc		= 0x200;		// Program counter starts at 0x200 (Start adress program)
	Chip8.opcode	= 0;			// Reset current opcode	
	Chip8.I2		= 0;			// Reset index register
	Chip8.sp		= 0;			// Reset stack pointer

	// Clear display
	for(int i = 0; i < 2048; ++i)
		videobuffer[i] = 0;

	// Clear stack
	for(int i = 0; i < 16; ++i)
		stack[i] = 0;

	for(int i = 0; i < 16; ++i)
		key[i] = Chip8.V[i] = 0;

	// Clear memory
	for(int i = 0; i < 4096; ++i)
		memory[i] = 0;
					
	// Load fontset
	for(int i = 0; i < 80; ++i)
		memory[i] = chip8_fontset[i];		

	// Reset timers
	Chip8.DelayTimer = 0;
	Chip8.SoundTimer = 0;

	// Clear screen once
	Chip8.drawFlag = true;

	srand (time(NULL));
	if((4096-512) > ROM_SIZE)
	{
		for(int i = 0; i < ROM_SIZE; i++)
		{
			memory[i + 512] = rom[i];
		}
	}
}

void emulateCycle()
{
	//Fetch
	Chip8.opcode = memory[Chip8.pc] << 8 | memory[Chip8.pc + 1];
	// Process opcode
	switch(Chip8.opcode & 0xF000)
	{	
		case 0x0000:
			switch(Chip8.opcode & 0x0000) 
			{
				case 0x0000: //00E0: CLS
					for(int i = 0;i < 2048; i++)
					{
						videobuffer[i] = 0;
					}
					Chip8.drawFlag = 1;
					Chip8.pc+=2;
					break;
				case 0x000E: //00EE: RET
					Chip8.sp--;
					Chip8.pc = stack[Chip8.sp];
					Chip8.pc+=2;
					break;
				default:
					break;
			}
			break;
		case 0x1000: //1NNN: JP NNN
			Chip8.pc = Chip8.opcode & 0x0FFF;
			break;
		case 0x2000: //2NNN: CALL NNN
			stack[Chip8.sp] = Chip8.pc;
			Chip8.sp++;
			Chip8.pc = Chip8.opcode & 0x0FFF;
			break;
		case 0x3000: //3NNN: SE Vx, byte
			if(Chip8.V[(Chip8.opcode & 0x0F00) >> 8] == (Chip8.opcode & 0x00FF))
				Chip8.pc += 4;
			else
				Chip8.pc += 2;
			break;
		case 0x4000: //4NNN: SNE Vx, byte
			if(Chip8.V[(Chip8.opcode & 0x0F00) >> 8] != (Chip8.opcode & 0x00FF))
				Chip8.pc += 4;
			else
				Chip8.pc += 2;
			break;
		case 0x5000: //SE Vx, Vy
			if(Chip8.V[(Chip8.opcode & 0x0F00) >> 8] == Chip8.V[(Chip8.opcode & 0x00F0) >> 4])
				Chip8.pc += 4;
			else
				Chip8.pc += 2;
			break;
		case 0x6000: //LD Vx, byte
			Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = Chip8.opcode & 0x00FF;
			Chip8.pc+=2;
			break;
		case 0x7000: //ADD Vx, byte
			Chip8.V[(Chip8.opcode & 0x0F00) >> 8] += Chip8.opcode & 0x00FF;
			Chip8.pc+=2;
			break;
		case 0x8000:
			switch(Chip8.opcode & 0x000F)
			{
				case 0x0000: // 0x8XY0: Sets VX to the value of VY
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;
					break;
				case 0x0001: // 0x8XY1: Sets VX to "VX OR VY"
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] |= Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;
					break;
				case 0x0002: // 0x8XY2: Sets VX to "VX AND VY"
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] &= Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;
					break;
				case 0x0003: // 0x8XY3: Sets VX to "VX XOR VY"
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] ^= Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;
					break;
				case 0x0004: // 0x8XY4: Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't					
					if(Chip8.V[(Chip8.opcode & 0x00F0) >> 4] > (0xFF - Chip8.V[(Chip8.opcode & 0x0F00) >> 8])) 
						Chip8.V[0xF] = 1; //carry
					else 
						Chip8.V[0xF] = 0;					
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] += Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;					
					break;
				case 0x0005: // 0x8XY5: VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't
					if(Chip8.V[(Chip8.opcode & 0x00F0) >> 4] > Chip8.V[(Chip8.opcode & 0x0F00) >> 8]) 
						Chip8.V[0xF] = 0; // there is a borrow
					else 
						Chip8.V[0xF] = 1;					
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] -= Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
					Chip8.pc += 2;
					break;
				case 0x0006: // 0x8XY6: Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift
					Chip8.V[0xF] = Chip8.V[(Chip8.opcode & 0x0F00) >> 8] & 0x1;
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] >>= 1;
					Chip8.pc += 2;
					break;
				case 0x0007: // 0x8XY7: Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't
					if(Chip8.V[(Chip8.opcode & 0x0F00) >> 8] > Chip8.V[(Chip8.opcode & 0x00F0) >> 4])	// VY-VX
						Chip8.V[0xF] = 0; // there is a borrow
					else
						Chip8.V[0xF] = 1;
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = Chip8.V[(Chip8.opcode & 0x00F0) >> 4] - Chip8.V[(Chip8.opcode & 0x0F00) >> 8];				
					Chip8.pc += 2;
					break;
				case 0x000E: // 0x8XYE: Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift
					Chip8.V[0xF] = Chip8.V[(Chip8.opcode & 0x0F00) >> 8] >> 7;
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] <<= 1;
					Chip8.pc += 2;
					break;
				default:
					break;
			}
			break;
		case 0x9000:
			if(Chip8.V[(Chip8.opcode & 0x0F00) >> 8] != Chip8.V[(Chip8.opcode & 0x00F0) >> 4])
				Chip8.pc += 4;
			else
				Chip8.pc += 2;
			break;
		case 0xA000: // ANNN: Sets I to the address NNN
			Chip8.I2 = Chip8.opcode & 0x0FFF;
			Chip8.pc += 2;
			break;
		case 0xB000: // BNNN: Jumps to the address NNN plus V0
			Chip8.pc = (Chip8.opcode & 0x0FFF) + Chip8.V[0];
			break;
		case 0xC000: // CXNN: Sets VX to a random number and NN
			Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = (rand() % 0xFF) & (Chip8.opcode & 0x00FF);
			Chip8.pc += 2;
			break;
		case 0xD000: // DXYN: Draws a sprite at coordinate (VX, VY) that has a width of 8 pixels and a height of N pixels. 
					 // Each row of 8 pixels is read as bit-coded starting from memory location I; 
					 // I value doesn't change after the execution of this instruction. 
					 // VF is set to 1 if any screen pixels are flipped from set to unset when the sprite is drawn, 
					 // and to 0 if that doesn't happen
		{
			unsigned short x = Chip8.V[(Chip8.opcode & 0x0F00) >> 8];
			unsigned short y = Chip8.V[(Chip8.opcode & 0x00F0) >> 4];
			unsigned short height = Chip8.opcode & 0x000F;
			unsigned short pixel;

			Chip8.V[0xF] = 0;
			for (int yline = 0; yline < height; yline++)
			{
				pixel = memory[Chip8.I2 + yline];
				for(int xline = 0; xline < 8; xline++)
				{
					if((pixel & (0x80 >> xline)) != 0)
					{
						if(videobuffer[(x + xline + ((y + yline) * 64))] == 1)
						{
							Chip8.V[0xF] = 1;                                    
						}
						videobuffer[x + xline + ((y + yline) * 64)] ^= 1;
					}
				}
			}
						
			Chip8.drawFlag = 1;			
			Chip8.pc += 2;
		}
		break;
		case 0xE000:
			switch(Chip8.opcode & 0x00FF)
			{
				case 0x009E: // EX9E: Skips the next instruction if the key stored in VX is pressed
					if(key[Chip8.V[(Chip8.opcode & 0x0F00) >> 8]] != 0)
						Chip8.pc += 4;
					else
						Chip8.pc += 2;
					break;
				case 0x00A1: // EXA1: Skips the next instruction if the key stored in VX isn't pressed
					if(key[Chip8.V[(Chip8.opcode & 0x0F00) >> 8]] == 0)
						Chip8.pc += 4;
					else
						Chip8.pc += 2;
					break;
				default:
					break;
			}
			break;
		case 0xF000:
			switch(Chip8.opcode & 0x00FF)
			{
				case 0x0007: // FX07: Sets VX to the value of the delay timer
					Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = Chip8.DelayTimer;
					Chip8.pc += 2;
					break;
		case 0x000A: // FX0A: A key press is awaited, and then stored in VX		
			{
				bool keyPress = false;
				for(int i = 0; i < 16; ++i)
				{
					if(key[i] != 0)
					{
						Chip8.V[(Chip8.opcode & 0x0F00) >> 8] = i;
						keyPress = true;
					}
				}
					// If we didn't received a keypress, skip this cycle and try again.
				if(!(keyPress))						
					return;
				Chip8.pc += 2;					
			}
			break;
		case 0x0015: // FX15: Sets the delay timer to VX
				Chip8.DelayTimer = Chip8.V[(Chip8.opcode & 0x0F00) >> 8];
				Chip8.pc += 2;
				break;
			}
			break;
		case 0x0018: // FX18: Sets the sound timer to VX
				Chip8.SoundTimer = Chip8.V[(Chip8.opcode & 0x0F00) >> 8];
					Chip8.pc += 2;
				break;
		case 0x001E: // FX1E: Adds VX to I
					if(Chip8.I2 + Chip8.V[(Chip8.opcode & 0x0F00) >> 8] > 0xFFF)	// VF is set to 1 when range overflow (I+VX>0xFFF), and 0 when there isn't.
						Chip8.V[0xF] = 1;
					else
						Chip8.V[0xF] = 0;
					Chip8.I2 += Chip8.V[(Chip8.opcode & 0x0F00) >> 8];
					Chip8.pc += 2;
				break;
		case 0x0029: // FX29: Sets I to the location of the sprite for the character in VX. Characters 0-F (in hexadecimal) are represented by a 4x5 font
					Chip8.I2 = Chip8.V[(Chip8.opcode & 0x0F00) >> 8] * 0x5;
					Chip8.pc += 2;
				break;
				case 0x0033: // FX33: Stores the Binary-coded decimal representation of VX at the addresses I, I plus 1, and I plus 2
					memory[Chip8.I2]     = Chip8.V[(Chip8.opcode & 0x0F00) >> 8] / 100;
					memory[Chip8.I2 + 1] = (Chip8.V[(Chip8.opcode & 0x0F00) >> 8] / 10) % 10;
					memory[Chip8.I2 + 2] = (Chip8.V[(Chip8.opcode & 0x0F00) >> 8] % 100) % 10;					
					Chip8.pc += 2;
				break;

				case 0x0055: // FX55: Stores V0 to VX in memory starting at address I					
					for (int i = 0; i <= ((Chip8.opcode & 0x0F00) >> 8); ++i)
						memory[Chip8.I2 + i] = Chip8.V[i];	

					// On the original interpreter, when the operation is done, I = I + X + 1.
					Chip8.I2 += ((Chip8.opcode & 0x0F00) >> 8) + 1;
					Chip8.pc += 2;
				break;

				case 0x0065: // FX65: Fills V0 to VX with values from memory starting at address I					
					for (int i = 0; i <= ((Chip8.opcode & 0x0F00) >> 8); ++i)
						Chip8.V[i] = memory[Chip8.I2 + i];			

					// On the original interpreter, when the operation is done, I = I + X + 1.
					Chip8.I2 += ((Chip8.opcode & 0x0F00) >> 8) + 1;
					Chip8.pc += 2;
					break;

				default:
					break;
	}
	// Update timers
	if(Chip8.DelayTimer > 0)
		Chip8.DelayTimer--;
	if(Chip8.SoundTimer > 0)
	{
		if(Chip8.SoundTimer == 1)
		//printf("BEEP!\n");
		Chip8.SoundTimer--;
	}	
}

void render()
{
	hrt_SetBGPalEntry(1, 0x0000);
	hrt_SetBGPalEntry(2, 0xFFFF);
	for(int i =0; i < 32; i++)
	{
		for(int i2 = 0; i2 < 64; i2++)
		{
			Buffer[(i+80-16)*240+(i2+120-32)] = videobuffer[i*64+i2]+1;
		}
	}
	hrt_DMA_Copy(3, (u8*)Buffer, (u8*)VRAM, 240*160, 0x80000000);
		hrt_DSPSetBGMode(4);
	hrt_DSPEnableBG(2);
	hrt_DSPDisableForceBlank();
}
