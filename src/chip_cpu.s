.global op_table

.arm
_00E0: //CLS
	push {r0-r3}
	ldr r0,=videobuffer
	ldr r1,=#0
	ldr r2,=#0
	ldr r3,=#4096
__00E0:
	add r1,r1,#1
	strh r2,[r0,r1]
	cmp r1,r3
	bne __00E0
	pop {r0-r3}
	bx lr