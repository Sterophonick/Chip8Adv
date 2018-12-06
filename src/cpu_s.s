.global Chip8
.global Chip8Adv
.global memory
.global videobuffer
.global stack
.global key

.global draw_sprite
.global memset

//Instructions to speed up the emulator (It did by quite a bit, but it could be better :P)
.global opCLS
.global op1NNN
.global opLDVB
.global opADDVB
.global opSE
.global opSNE
.global opLDBV
.global opLDFV
.global opCALL

V0 = 0
V1 = 1
V2 = 2
V3 = 3 
V4 = 4
V5 = 5
V6 = 6
V7 = 7
V8 = 8
V9 = 9
VA = 10
VB = 11
VC = 12
VD = 13
VE = 14
VF = 15
DelayTimer = 16
SoundTimer = 17
I2 = 18
C_pc = 20
C_SP = 22

opCLS:
	push {r0-r3}
	ldr r0,=videobuffer
	ldr r1,=#0
	ldr r2,=#0
	ldr r3,=#4096
_opCLS:
	add r1,r1,#1
	strh r2,[r0,r1]
	cmp r1,r3
	bne _opCLS
	pop {r0-r3}
	bx lr
	
//r0: Chip8.nnn
op1NNN: //JP NNN
	push {r1-r2}
	ldr r1,=Chip8
	mov r2,r0
	strh r2,[r1,#C_pc]
	pop {r1-r2}
	bx lr
	
//r0: Reg1
//r1: byte
//Chip8.V[Chip8.x] = Chip8.kk
opLDVB:
	push {r2-r3}
	ldr r2,=Chip8
	ldrb r3,[r2,r0]
	mov r3,r1
	strb r3,[r2,r0]
	pop {r2-r3}
	bx lr
	
//r0: Reg1
//r1: byte
//Chip8.V[Chip8.x] += Chip8.kk
opADDVB:
	push {r2-r3}
	ldr r2,=Chip8
	ldrb r3,[r2,r0]
	add r3,r3,r1
	strb r3,[r2,r0]
	pop {r2-r3}
	bx lr
	
//r0: reg1
//r1: value
//Chip8.pc += (Chip8.V[Chip8.x] == Chip8.kk) ? 4 : 2
opSE:
	push {r2-r4}
	ldr r2,=Chip8
	ldrb r3,[r2,r0]
	ldrh r4,[r2,#C_pc]
	cmp r1,r3
	addeq r4,r4,#4
	addne r4,r4,#2
	strh r4,[r2,#C_pc]
	pop {r2-r4}
	bx lr
	
//r0: reg1
//r1: value
//Chip8.pc += (Chip8.V[Chip8.x] != Chip8.kk) ? 4 : 2
opSNE:
	push {r2-r4}
	ldr r2,=Chip8
	ldrb r3,[r2,r0]
	ldrh r4,[r2,#C_pc]
	cmp r1,r3
	addeq r4,r4,#2
	addne r4,r4,#4
	strh r4,[r2,#C_pc]
	pop {r2-r4}
	bx lr
	
//r0: byte
//r1: reg1
//Chip8.DelayTimer = Chip8.V[Chip8.x]
opLDBV:
	push {r2-r4}
	ldr r2,=Chip8
	ldrb r3,[r2,r1]
	mov r4,r3
	strb r4,[r2,r1]
	pop {r2-r4}
	bx lr

//r0 reg1
//Chip8.I2 = 5 * Chip8.V[Chip8.x];
opLDFV:
	push {r1-r4}
	ldr r1,=Chip8
	ldrh r2,[r1,#I2]
	ldrh r3,[r1,r0]
	mov r4,#5
	mul r2,r3,r4
	strh r2,[r1,#I2]
	pop {r1-r4}
	bx lr
	
//r0: addr
			//stack[Chip8.sp] = Chip8.pc;
			//stack[Chip8.sp++] = Chip8.pc + 2;
			// Chip8.pc = addr
opCALL:
	push {r1-r3}
	ldr r1,=Chip8
	ldrh r2,[r1,#C_SP]
	ldrh r3,[r1,#C_pc]
	ldr r1,=stack
	strh r3,[r1,r2]
	add r3,r3,#2
	add r2,r2,#1
	strh r3,[r1,r2]
	mov r3,r0
	strh r3,[r1,#C_pc]
	pop {r1-r3}
	bx lr
	