#include <libheart.h>
#include "cpu.h"
#include "lang.h"
c8system Chip8;

u8* PogoROM;

	u8 memory[4096]; //RAM
	u16 videobuffer[64][128]; //video for ext
	u16 stack[16];
	u8 key[16];
	u8 Buffer[7680];
const unsigned char chip8_fontset[80] =
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

void draw_sprite(uint8_t x, uint8_t y, uint8_t n) {
    unsigned row = y, col = x;
    unsigned byte_index;
    unsigned bit_index;

    // set the collision flag to 0
    Chip8.V[0xF] = 0;
    for (byte_index = 0; byte_index < n; byte_index++) {
        u8 byte = memory[Chip8.I2 + byte_index];

        for (bit_index = 0; bit_index < 8; bit_index++) {
            // the value of the bit in the sprite
           u8 bit = (byte >> bit_index) & 0x1;
            // the value of the current pixel on the screen
            u8 *pixelp = &videobuffer[(row + byte_index) % 32]
                                  [(col + (7 - bit_index)) % 64];

            // if drawing to the screen would cause any pixel to be erased,
            // set the collision flag to 1
            if (bit == 1 && *pixelp ==1) Chip8.V[0xF] = 1;

            // draw this pixel by XOR
            *pixelp = *pixelp ^ bit;
        }
    }
}


void Initialize()
{
	hrt_SetBGPalEntry(0, 0x0000);
	hrt_SetBGPalEntry(1, 0xFFFF);
	Chip8.pc		= 0x200;		// Program counter starts at 0x200 (Start adress program)
	Chip8.opcode	= 0;			// Reset current opcode	
	Chip8.I2		= 0;			// Reset index register
	Chip8.sp		= 0;			// Reset stack pointer

	// Clear display
	memset(videobuffer,    0, sizeof(u16)  * (64*32));
	
	//Clear buffer
	for(int i = 0; i < 240*32; ++i)
		Buffer[i] = 0;

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

	hrt_SeedRNG(Chip8Adv->random_seed);
	
	if(pogoshell)
	{
		u32 *magptr=(u32*)0x08000000;
		u32 *fileptr;
		char *d;
		char *s=(char*)0x0203fc08;

		while(*magptr!=0xfab0babe && magptr < (u32*)0x0a000000){
			magptr+=0x8000/4;						//Find the filesys root
		}
		magptr+=2;
		fileptr=magptr;

		do s++; while(*s);							//Command name (pce.bin)
		s++;
		if(strncmp(s,"/rom/",5)==0) s+=5;
		while(1){
			s++;									//First Directory
			d=s;									//First Directory
			while(*s!='/' && *s){s++;}				//Argument (/directory/.../romfile.pce)
			if(!*s)
				break;
			*s=0;									//Terminate directory name.
			while(strcmp((char*)magptr,d)){			//find directory
				magptr+=10;
			}
			magptr = (u32*)((u8*)fileptr + magptr[9]);
		}
		while(strcmp((char*)magptr,d)){				//find file
			magptr+=10;
		}
		pogosize=magptr[8];							//file size
		
		//set ROM address
		PogoROM=(*(u8**)0x0203FBFC);
		
		//So it will try to detect roms when loading state
	}
	memcpy(&memory[0x200], &rom, MAX_GAME_SIZE);
	if(!(Chip8Adv->firstboot == 0))
	{
		Chip8Adv->firstboot = 0;
		Chip8Adv->a_b_keybinds = 0x01;
		Chip8Adv->up_down_keybinds = 0x23;
		Chip8Adv->left_right_keybinds = 0x45;
		Chip8Adv->sel_st_keybinds = 0x67;
		Chip8Adv->dblsize = 1;
		Chip8Adv->palswap = 0;
		Chip8Adv->palette = 0;
		Chip8Adv->brightness = 0;
		Chip8Adv->clockspeed = 5;
		Chip8Adv->vsync = 1;
		Chip8Adv->autosleep = 2;
	}
}

void emulateCycle()
{
	//Fetch
	Chip8.opcode = memory[Chip8.pc] << 8 | memory[Chip8.pc + 1];
    Chip8.x   = (Chip8.opcode >> 8) & 0x000F; // the lower 4 bits of the high byte
    Chip8.y   = (Chip8.opcode >> 4) & 0x000F; // the upper 4 bits of the low byte
    Chip8.n   = Chip8.opcode & 0x000F; // the lowest 4 bits
    Chip8.kk  = Chip8.opcode & 0x00FF; // the lowest 8 bits
    Chip8.nnn = Chip8.opcode & 0x0FFF; // the lowest 12 bits

	// Process opcode
	switch(Chip8.opcode & 0xF000)
	{	
		case 0x0000:
			switch(Chip8.kk) 
			{
				case 0x00E0: //00E0: CLS
					opCLS();
					Chip8.drawFlag = 1;
					Chip8.pc+=2;
					break;
				case 0x00EE: //00EE: RET
					 Chip8.pc = stack[--Chip8.sp];
					break;
				case 0x00FD: //00FD: EXIT
					RequestExit();
					break;
				case 0x00FE: //00FE: LOW
					Chip8.extscrmode = 0;
					Chip8.pc+=2;
					break;
				case 0x00FF: //00FF: HIGH
					Chip8.extscrmode = 1;
					Chip8.pc+=2;
					break;
				default:
					break;
			}
			switch(Chip8.y) 
			{
				case 0x000C: //Scroll Display Down
					opSCDWN(Chip8.n);
					Chip8.pc+=2;
					break;
				default:
					break;
			}
			break;
		case 0x1000: //1NNN: JP NNN
			op1NNN(Chip8.nnn);
			break;
		case 0x2000: //2NNN: CALL NNN
			stack[Chip8.sp] = Chip8.pc;
			stack[Chip8.sp++] = Chip8.pc + 2;
            Chip8.pc = Chip8.nnn;
			//opCall(Chip8.nnn);
			break;
		case 0x3000: //3NNN: SE Vx, byte
			opSE(Chip8.x, Chip8.kk);
			break;
		case 0x4000: //4NNN: SNE Vx, byte
			opSNE(Chip8.x, Chip8.kk);
			break;
		case 0x5000: //SE Vx, Vy
			opSE(Chip8.x, Chip8.y);
			break;
		case 0x6000: //LD Vx, byte
			opLDVB(Chip8.x, Chip8.kk);
            Chip8.pc += 2;
			break;
		case 0x7000: //ADD Vx, byte
			opADDVB(Chip8.x, Chip8.kk);
            Chip8.pc += 2;
			break;
		case 0x8000:
			switch(Chip8.n)
			{
				case 0x0000: // 0x8XY0: Sets VX to the value of VY
					opLDVB(Chip8.x, Chip8.V[Chip8.y]);
					break;
				case 0x0001: // 0x8XY1: Sets VX to "VX OR VY"
					opLDVB(Chip8.x, Chip8.V[Chip8.x] | Chip8.V[Chip8.y]);
					break;
				case 0x0002: // 0x8XY2: Sets VX to "VX AND VY"
					opLDVB(Chip8.x, Chip8.V[Chip8.x] & Chip8.V[Chip8.y]);
					break;
				case 0x0003: // 0x8XY3: Sets VX to "VX XOR VY"
					opLDVB(Chip8.x, Chip8.V[Chip8.x] ^ Chip8.V[Chip8.y]);
					break;
				case 0x0004: // 0x8XY4: Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't					
					Chip8.V[0xF] = ((int) Chip8.V[Chip8.x] + (int) Chip8.V[Chip8.y]) > 255 ? 1 : 0;
                    Chip8.V[Chip8.x] = Chip8.V[Chip8.x] + Chip8.V[Chip8.y];			
					break;
				case 0x0005: // 0x8XY5: VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't
                    Chip8.V[0xF] = (Chip8.V[Chip8.x] > Chip8.V[Chip8.y]) ? 1 : 0;
                    Chip8.V[Chip8.x] = Chip8.V[Chip8.x] - Chip8.V[Chip8.y];
					break;
				case 0x0006: // 0x8XY6: Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift
                    Chip8.V[0xF] = Chip8.V[Chip8.x] & 0x1;
                    Chip8.V[Chip8.x] = (Chip8.V[Chip8.x] >> 1);
					break;
				case 0x0007: // 0x8XY7: Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't
					Chip8.V[0xF] = (Chip8.V[Chip8.y] > Chip8.V[Chip8.x]) ? 1 : 0;
                    Chip8.V[Chip8.x] = Chip8.V[Chip8.y] - Chip8.V[Chip8.x];
					break;
				case 0x000E: // 0x8XYE: Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift
					Chip8.V[0xF] = (Chip8.V[Chip8.x] >> 7) & 0x1;
                    Chip8.V[Chip8.x] = (Chip8.V[Chip8.x] << 1);
					break;
				default:
					break;
			}
			Chip8.pc+=2;
			break;
		case 0x9000:
            switch (Chip8.n) {
                case 0x0:
                    opSNE(Chip8.x, Chip8.y);
                    break;
                default:
                    break;
            }
            break;
		case 0xA000: // ANNN: Sets I to the address NNN
            Chip8.I2 = Chip8.nnn;
            Chip8.pc += 2;
			break;
		case 0xB000: // BNNN: Jumps to the address NNN plus V0
			Chip8.pc = Chip8.nnn + Chip8.V[0];
			break;
		case 0xC000: // CXNN: Sets VX to a random number and NN
            Chip8.V[Chip8.x] = (hrt_CreateRNG() % 256) & Chip8.kk;
            Chip8.pc += 2;
			Chip8Adv->random_seed = Chip8.V[Chip8.x];
			break;
		case 0xD000:
			draw_sprite(Chip8.V[Chip8.x], Chip8.V[Chip8.y], Chip8.n);
            Chip8.pc += 2;
            Chip8.drawFlag = true;
			break;
		case 0xE000:
			switch(Chip8.kk)
			{
				case 0x009E: // EX9E: Skips the next instruction if the key stored in VX is pressed
					Chip8.pc += (key[Chip8.V[Chip8.x]]) ? 4 : 2;
					break;
				case 0x00A1: // EXA1: Skips the next instruction if the key stored in VX isn't pressed
					Chip8.pc += (!key[Chip8.V[Chip8.x]]) ? 4 : 2;
					break;
				default:
					break;
			}
			break;
		case 0xF000:
			switch(Chip8.kk)
			{
				case 0x0007: // FX07: Sets VX to the value of the delay timer
					opLDVB(Chip8.x, Chip8.DelayTimer);
					Chip8.pc += 2;
					break;
				case 0x000A: // FX0A: A key press is awaited, and then stored in VX		
                    while (true) {
                        for (int i = 0; i < 16; i++) {
                            if (key[i]) {
                                Chip8.V[Chip8.x] = i;
                                goto got_key_press;
                            }
                        }
                    }
                    got_key_press:
					Chip8.pc += 2;					
					break;
				case 0x0015: // FX15: Sets the delay timer to VX
					Chip8.DelayTimer = Chip8.V[Chip8.x];
					//opLDBV(Chip8.DelayTimer, Chip8.x);
					Chip8.pc += 2;
					break;
				case 0x0018: // FX18: Sets the sound timer to VX
					Chip8.SoundTimer = Chip8.V[Chip8.x];
					Chip8.pc += 2;
					break;
				case 0x001E: // FX1E: Adds VX to I
					Chip8.V[0xF] = (Chip8.I2 + Chip8.V[Chip8.x] > 0xfff) ? 1 : 0;
					Chip8.I2 = Chip8.I2 + Chip8.V[Chip8.x];
					Chip8.pc += 2;
					break;
				case 0x0029: // FX29: Sets I to the location of the sprite for the character in VX. Characters 0-F (in hexadecimal) are represented by a 4x5 font
					opLDFV(Chip8.x);
					Chip8.pc += 2;
					break;
				case 0x0030: //Fx30 - LD HF,Vx
					Chip8.I2 = 0x150+Chip8.V[Chip8.x]*10;
					Chip8.pc+=2;
					break;
				case 0x0033: // FX33: Stores the Binary-coded decimal representation of VX at the addresses I, I plus 1, and I plus 2
					memory[Chip8.I2]     = (Chip8.V[Chip8.x] % 1000) / 100 ;
					memory[Chip8.I2 + 1] = (Chip8.V[Chip8.x] % 100 ) / 10;
					memory[Chip8.I2 + 2] = (Chip8.V[Chip8.x] % 10);					
					Chip8.pc += 2;
					break;
				case 0x0055: // FX55: Stores V0 to VX in memory starting at address I					
					for (int i = 0; i <= Chip8.x; i++) { memory[Chip8.I2 + i] = Chip8.V[i]; }
					Chip8.I2 += Chip8.x + 1;
					Chip8.pc += 2;
					break;
				case 0x0065: // FX65: Fills V0 to VX with values from memory starting at address I					
					for (int i = 0; i <= Chip8.x; i++) {Chip8. V[i] = memory[Chip8.I2 + i]; }
						Chip8.I2 += Chip8.x + 1;
					Chip8.pc += 2;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
}

void tick()
{
	// Update timers
	if(Chip8.DelayTimer > 0)
		--Chip8.DelayTimer;
	if(Chip8.SoundTimer > 0)
	{
		--Chip8.SoundTimer;
		if(Chip8.SoundTimer == 1) {
			//printf("BEEP!\n");
		}
	}	
}

void render()
{
	int i;
	int i2;
	hrt_SetBGPalEntry(1, palettes[(Chip8Adv->palette)*2+((Chip8Adv->palswap) ? 1 : 0)]);
	hrt_SetBGPalEntry(2, palettes[(Chip8Adv->palette)*2+((Chip8Adv->palswap) ? 0 : 1)]);
	if(Chip8Adv->dblsize == 0)
	{
		hrt_AffineBG(2, 0, 256, 0, 0);
	}else{
		hrt_AffineBG(2, 0, 128, 15, -50);
	}
		for(i =0; i < 32; i++)
		{
			for( i2 = 0; i2 < 64; i2++)
			{
				Buffer[(i)*240+(i2+120-32)] = videobuffer[i][i2]+1;
			}
		}
	hrt_DMA_Copy(3, (u8*)Buffer, (u8*)0x6002DF0, 3800, 0x80000000);
	Chip8.drawFlag = 0;
}

void opSCDWN(u8 n)
{
	u32 nr, w, h;
	u8 *disp;
		if(Chip8.extscrmode == 0)
		{
			w = 64;
			h = 32;
			disp = &videobuffer[0][0];
		}else{
			w = 64;
			h = 32;
			disp = &videobuffer[0][0];
		}
				nr = n*w;
			memmove(disp + nr, disp, w*h - nr);
			memset(disp, 0, nr);
}

void opSCR(u8 n)
{
	u32 w, h;
	u8 *disp;
		if(Chip8.extscrmode == 0)
		{
			w = 64;
			h = 32;
			disp = &videobuffer[0][0];
		}else{
			//u8 linebuffer[128];
		}
                for (unsigned int i=0; i<h; i++)
                {
                  memmove(disp+4, disp, w-4);
                  memset(disp, 0, 4);
                  disp += w; // Next row
                }
}