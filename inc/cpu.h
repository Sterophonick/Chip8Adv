#include <stdbool.h>

typedef struct
{
	//Main CPU
	u8 V[16]; //General purpose registers
	u8 DelayTimer; 
	u8 SoundTimer;
	u16 I2; //Index register
	u16 pc; //Program Counter
	u16 sp; //Stack Pointer
	//Emulator things
	u16 opcode; //opcode for execution
	u8 drawFlag;
	u8 hp_48_flags[8];
	
	//bits
	u8 x; //the lower 4 bits of the high byte
	u8 y; //the upper 4 bits of the low byte
	u8 n; //the lowest 4 bits
	u8 kk; //the lowest 8 bits
	u16 nnn; //the lowest 12 bits
	
	//Display
	u8 scy;
	u8 scx;
	u8 extscrmode;
}c8system;

extern c8system Chip8;
extern void Initialize();
extern void emulateCycle();
extern void Keypad();
extern void render();
extern const unsigned char rom[];
extern u8 memory[4096]; //RAM
extern u8 videobuffer[64*128]; //video before it gets copied to RAM
extern u16 stack[16];
extern u8 key[16];
extern void tick();

#define MAX_GAME_SIZE (0x1000 - 0x200)

typedef struct
{
	u8 random_seed;
	u8 a_key;
	u8 b_key;
	u8 up_key;
	u8 down_key;
	u8 left_key;
	u8 right_key;
	u8 sel_key;
	u8 strt_key;
	u8 brightness;
	u8 palette;
	u8 palswap;
	u8 dblsize;
	u8 clockspeed;
	u8 vsync;
	u8 autosleep;
	u8 firstboot;
}emu;
extern emu* Chip8Adv;

extern char setLowerNibble(char orig, char nibble);
extern char setUpperNibble(char orig, char nibble);

extern void opCLS();
extern void op1NNN(u16 nnn);
extern void opLDVB(u8 reg, u8 byte);
extern void opADDVB(u8 reg, u8 byte);
extern void opSE(u8 reg, u8 byte);
extern void opSNE(u8 reg, u8 byte);
extern void opLDBV(u8 byte, u8 reg);
extern void opLDVM(u8 reg, u16 addr);
extern void opLDHV(u8 src, u16 dst);
extern void opLDFV(u8 reg);
extern void opCALL(u16 addr);
extern void opSCDWN(u8 n);
extern void opSETI(u16 value);
extern void opSETPC(u16 value);
extern void opADDPC(u16 value);
extern void opSETDT(u8 value);

extern void menu();
extern void RequestExit();

extern void debugger();

extern u32 autosleeptimer;

extern void DetectPogo();
extern int pogoshell;
extern u32 pogotemp;

extern u8 updatevsync;
extern void MiscKeys();