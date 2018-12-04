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
}c8system;

extern c8system Chip8;
extern void Initialize();
extern void emulateCycle();
extern void Keypad();
extern void render();
extern const unsigned char rom[];
extern u8 memory[4096]; //RAM
extern u16 videobuffer[64*32]; //video before it gets copied to RAM
extern u16 stack[16];
extern u8 key[16];