; Pokemon Mini BIOS
; TODO: fix instruction sizes
; add .db's at end

	.macro	unknownCFFE
		.db	0xCF,0xFE
	.endm
	.macro	unknownCFF3
		.db	0xCF,0xF3
	.endm
	.macro	unknownCFDA
		.db	0xCF,0xDA
	.endm
	.macro	unknownCEAE
		.db	0xCE,0xAE
	.endm
	.macro	unknownCECC
		.db	0xCE,0xCC
	.endm


	.equ	ram_vector		0x1FFD

	;int		$22		; power	off	(need reset)
	;int		$26		; power	off
	;int		$27			; power	off
	;int			$2F			; power	off
	;int			$30			; power	off
	;int		$13			; reset?


	.dw	reset				; $00	2102
	.dw	reset2				; $01
	.dw	reset2				; $02

	; 14
	.dw	int03_2108			; $03
	.dw	int04_210E			; $04
	.dw	int05_2114			; $05
	.dw	int06_211A			; $06
	.dw	int07_2120			; $07
	.dw	int08_2126			; $08
	.dw	int09_212C			; $09
	.dw	int0A_2132			; $0A
	.dw	int0B_2138			; $0B
	.dw	int0C_213E			; $0C
	.dw	int0D_2144			; $0D
	.dw	int0E_214A			; $0E
	.dw	int0F_2150			; $0F
	.dw	int10_2156			; $10

	.dw	reset2				; $11
	.dw	reset2				; $12

	.dw	int13				; $13

	; 12
	.dw	int14_219E			; $14

	.dw	int15_215C			; $15	hmm!
	.dw	int16_2162			; $16
	.dw	int17_2168			; $17
	.dw	int18_216E			; $18
	.dw	int19_2174			; $19
	.dw	int1A_217A			; $1A
	.dw	int1B_2180			; $1B
	.dw	int1C_2186			; $1C
	.dw	int1D_218C			; $1D
	.dw	int1E_2192			; $1E
	.dw	int1F_2198			; $1F

	.dw	0xFFF1				; $20

	.dw	int_suspend			; $21
	.dw	int22				; $22
	.dw	int23				; $23
	.dw	int_shutdown		; $24
	.dw	int25_display_off1	; $25

	.dw	int26				; $26
	.dw	int27				; $27
	.dw	int28				; $28
	.dw	int29				; $29

	.dw	int_set_contrast	; $2A
	.dw	int2B				; $2B	call	init_display2
	.dw	int_init_display	; $2C
	.dw	int_display_off		; $2D

	.dw	int2E				; $2E

	.dw	int2F				; $2F
	.dw	int30				; $30
	.dw	int31				; $31

	.dw	int32				; $32
	.dw	int33				; $33

	.dw	int34				; $34	flash ???
	.dw	int35				; $35	flash_???

	.dw	int36				; $36
	.dw	int37				; $37
	.dw	int38				; $38

	.dw	int_fast_speed		; $39
	.dw	int_slow_speed		; $3A
	.dw	int3B				; $3B	call  @00000AF2
	.dw	int3C				; $3C	flash0B05
	.dw	int3D				; $3D	testb  [nn+$53], $02
	.dw	int3E				; $3E

	.dw	lcd_set_trace		; $3F
	.dw	lcd_get_trace		; $40

	.dw	test_2001_bit3		; $41

	.dw	flash_read_ids-1	; $42
	.dw	flash_reset-1		; $43
	.dw	flash_program_byte	; $44
	.dw	flash_erase_sector	; $45
	.dw	flash_cmd_D0-1		; $46
	.dw	flash_0507-1		; $47
	.dw	flash_cmd_C9		; $48
	.dw	flash_cmd_C0-1		; $49
	.dw	flash053A			; $4A

	.dw	0x0000				; $4B
	.dw	x2_bit2_loop		; $4C

	.org	0x009A
reset:
	movx  hl, $00																;		  CE C5	00
	movw  nn, $2000																; 009D	  B4 20
	movb  [nn+$08],	$02															; 009F	  DD 08	02
	orb	 [nn+$08], $01															; 00A2	  D9 08	01
	movb  [nn+$00],	$7C															; 00A5	  DD 00	7C
	movb  [nn+$02],	$00															; 00A8	  DD 02	00

	.org	0x00AB
reset2:
	movb  flags, $C0															;		  9F C0
	movw  sp, $2000																; 00AD	  CF 6E	00 20
	call  initregs																; 00B1	  F2 C5	00
	movb  [nn+$80],	a															; 00B4	  78 80
	call  set_fast_speed														; 00B6	  F2 FA	09
	noidea $01																	; 00B9	  CE C4	01
	jmpb @000000BE		; huh?													; 00BC	  F1 01
	movb  a, [nn+$52]															; 00BE	  44 52
	movb  [$14E1], a															; 00C0	  CE D4	E1 14
	orb	 [nn+$00], $03															; 00C4	  D9 00	03
	movb  [nn+$01],	$30															; 00C7	  DD 01	30
	orb	 [nn+$02], $C0															; 00CA	  D9 02	C0
	call  init_io																; 00CD	  F2 BA	00
	movb  [nn+$80],	$02															; 00D0	  DD 80	02
	movb  [nn+$81],	$09															; 00D3	  DD 81	09
	movw  x1, $1830																; 00D6	  C6 30	18
	movw [$2082],x1																; 00D9	  BE 82	20
	movb  [nn+$84],	$00															; 00DC	  DD 84	00
	movb  [nn+$85],	b															; 00DF	  79 85
	movb  [nn+$86],	b															; 00E1	  79 86
	movb  [nn+$87],	b															; 00E3	  79 87
	movb  [nn+$88],	b															; 00E5	  79 88
	movb  [nn+$89],	b															; 00E7	  79 89
	call  @00000B08																; 00E9	  F2 1D	0A
	call  delay_07CB															; 00EC	  F2 DC	0A
	movb  [nn+$28],	$02															; 00EF	  DD 28	02
	movb  flags, $80															; 00F2	  9F 80
	movb  [nn+$FE],	$E3															; 00F4	  DD FE	E3
	movb  h, $B0																; 00F7	  B3 B0
loop_from_B0_to_B8:
	movb  b, $60																; 00F9	  B1 60
	movb  [nn+$FE],	h															; 00FB	  7B FE
	movb  [nn+$FE],	$10															; 00FD	  DD FE	10
	movb  [nn+$FE],	$00															; 0100	  DD FE	00
clear_96_vertical_lines:
	movb  [nn+$FF],	$00															; 0103	  DD FF	00
	jdbnz  @00000103															; 0106	  F5 FC

	incb  h																		; 0108	  83
	cmpb  h, $B8																; 0109	  CE BE	B8
	jnzb	 @000000F9																; 010C	  E7 EC

	call  some_other_label														; 010E	  F2 0C	07
	xorb  a, a																	; 0111	  38
	call  init_display1															; 0112	  F2 6A	07
	call  decode_picture														; 0115	  F2 B5	0C

	testb  [nn+$53], $02														; 0118	  DC 53	02
	jzb	@00000120																; 011B	  E6 04
	jmpw reset3																	; 011D	  F3 87	0C
	orb	 [nn+$10], $10															; 0120	  D9 10	10
	movb  b, $32																; 0123	  B1 32
	jdbnz  @00000125															; 0125	  F5 FF
	andb  [nn+$10],	$EF															; 0127	  D8 10	EF
	testb  [nn+$10], $20														; 012A	  DC 10	20
	jzb	@00000132																; 012D	  E6 04
	call  @00000D87																; 012F	  F2 56	0C
	jmpw flash_05CF																; 0132	  F3 9B	04

	.org	0x135
nintendo_check:
	movw  sp, $2000																; 0135	  CF 6E	00 20
	movb  b, $08																; 0139	  B1 08
	movw  x1, $21A4		; check	if N of	NINTENDO can be	read					; 013B	  C6 A4	21
	movw  x2, $0E1A																; 013E	  C7 1A	0E
	movb  a, [x1]																; 0141	  46
	cmpb  a, [x2]																; 0142	  37
	jnz	 reset3			; nope!													; 0143	  EF 61	0C
	incw  x1																	; 0146	  92
	incw  x2																	; 0147	  93
	jdbnz  @00000141		; keep checking										; 0148	  F5 F8

	xorb  a, a																	; 014A	  38
	movb  [nn+$80],	a		; $00												; 014B	  78 80
	movb  [nn+$81],	$07															; 014D	  DD 81	07
	movb  [nn+$82],	a		; $00												; 0150	  78 82
	movb  [nn+$83],	a		; $00												; 0152	  78 83
	andb  [nn+$01],	$EF															; 0154	  D8 01	EF
	call  initregs																; 0157	  F0 20
	movb  h, [$14E1]		; $79												; 0159	  CE D3	E1 14
	movb  l, [$14E0]		; $85												; 015D	  CE D2	E0 14

	movw  x1, $1000		; clear	ram												; 0161	  C6 00	10
	movb  [x1],	a																; 0164	  60
	incw  x1																	; 0165	  92
	cmpw  x1, $2000																; 0166	  D6 00	20
	jnzb	 @00000164																; 0169	  E7 FA

	movw  x1, ba																; 016B	  CF E8
	movb  n, a																	; 016D	  CE C2
	movw  ba, hl																; 016F	  CF E1
	movw  hl, x1																; 0171	  CF E6
	andb  flags, $C0															; 0173	  9C C0
	jmp	 @00002102			; jump to user code	!!!!							; 0175	  F3 8B	1F

;-----------------------------------------------------------------------------

	.org	0x178
initregs:
	movw  nn, $2000																;		  B4 20
	xorb  a, a																	; 017A	  38
	movb  b, a																	; 017B	  48
	movx  hl, a																	; 017C	  CE CD
	movx  x1, a																	; 017E	  CE CE
	movx  x2, a																	; 0180	  CE CF
	movw  hl, ba																; 0182	  CF E4
	movw  x1, ba																; 0184	  CF E8
	movw  x2, ba																; 0186	  CF EC
	ret																			; 0188	  F8

init_io:
	movb  b, $00																;		  B1 00
	movb  [nn+$10],	$08															; 018B	  DD 10	08
	andb  [nn+$19],	$CF															; 018E	  D8 19	CF
	movb  [nn+$20],	b															; 0191	  79 20
	movb  [nn+$21],	$30															; 0193	  DD 21	30
	movb  [nn+$22],	$02															; 0196	  DD 22	02
	movb  [nn+$23],	b															; 0199	  79 23
	movb  [nn+$24],	$02															; 019B	  DD 24	02
	movb  [nn+$25],	b															; 019E	  79 25
	movb  [nn+$26],	b															; 01A0	  79 26
	movb  [nn+$40],	b															; 01A2	  79 40
	movb  [nn+$44],	b															; 01A4	  79 44
	movb  [nn+$50],	$FF															; 01A6	  DD 50	FF
	movb  [nn+$51],	b															; 01A9	  79 51
	movb  a, [nn+$54]															; 01AB	  44 54
	andb  a, $F8																; 01AD	  22 F8
	orb	 a,	$01																	; 01AF	  2A 01
	movb  [nn+$54],	a															; 01B1	  78 54
	movb  [nn+$55],	$01															; 01B3	  DD 55	01
	orb	 [nn+$60], $0C															; 01B6	  D9 60	0C
	andb  [nn+$61],	$FB															; 01B9	  D8 61	FB
	orb	 [nn+$61], $08															; 01BC	  D9 61	08
	orb	 [nn+$61], $04															; 01BF	  D9 61	04
	movb  [nn+$61],	$20															; 01C2	  DD 61	20
	movb  [nn+$60],	$32															; 01C5	  DD 60	32
	movb  [nn+$62],	b															; 01C8	  79 62
	movb  [nn+$70],	b															; 01CA	  79 70
	movb  [nn+$71],	b															; 01CC	  79 71
	ret																			; 01CE	  F8

;-----------------------------------------------------------------------------

	.org	0x1CF
int03_2108:
	pushx  hl																	; 01CF	  A5
	pushb  n																	; 01D0	  A4
	movx  hl, $00																; 01D1	  CE C5	00
	movw  nn, $2000																; 01D4	  B4 20
	testb  [nn+$01], $20														; 01D6	  DC 01	20
	callzb  @00000257															; 01D9	  E2 7D
	popb  n																		; 01DB	  AC
	popx  hl																	; 01DC	  AD
	jmp	 @00002108																; 01DD	  F3 29	1F

int04_210E:
	pushx  hl																	; 01E0	  A5
	pushb  n																	; 01E1	  A4
	movx  hl, $00																; 01E2	  CE C5	00
	movw  nn, $2000																; 01E5	  B4 20
	testb  [nn+$01], $20														; 01E7	  DC 01	20
	callzb  @00000257															; 01EA	  E2 6C
	popb  n																		; 01EC	  AC
	popx  hl																	; 01ED	  AD
	jmp	 @0000210E																; 01EE	  F3 1E	1F

int05_2114:
	pushx  hl																	; 01F1	  A5
	pushb  n																	; 01F2	  A4
	movx  hl, $00																; 01F3	  CE C5	00
	movw  nn, $2000																; 01F6	  B4 20
	testb  [nn+$01], $20														; 01F8	  DC 01	20
	callzb  @00000257															; 01FB	  E2 5B
	popb  n																		; 01FD	  AC
	popx  hl																	; 01FE	  AD
	jmp	 @00002114																; 01FF	  F3 13	1F

int06_211A:
	pushx  hl																	; 0202	  A5
	pushb  n																	; 0203	  A4
	movx  hl, $00																; 0204	  CE C5	00
	movw  nn, $2000																; 0207	  B4 20
	testb  [nn+$01], $20														; 0209	  DC 01	20
	callzb  @00000257															; 020C	  E2 4A
	popb  n																		; 020E	  AC
	popx  hl																	; 020F	  AD
	jmp	 @0000211A																; 0210	  F3 08	1F

int07_2120:
	pushx  hl																	; 0213	  A5
	pushb  n																	; 0214	  A4
	movx  hl, $00																; 0215	  CE C5	00
	movw  nn, $2000																; 0218	  B4 20
	testb  [nn+$01], $20														; 021A	  DC 01	20
	callzb  @00000257															; 021D	  E2 39
	popb  n																		; 021F	  AC
	popx  hl																	; 0220	  AD
	jmp	 @00002120																; 0221	  F3 FD	1E

int08_2126:
	pushx  hl																	; 0224	  A5
	pushb  n																	; 0225	  A4
	movx  hl, $00																; 0226	  CE C5	00
	movw  nn, $2000																; 0229	  B4 20
	testb  [nn+$01], $20														; 022B	  DC 01	20
	callzb  @00000257															; 022E	  E2 28
	popb  n																		; 0230	  AC
	popx  hl																	; 0231	  AD
	jmp	 @00002126																; 0232	  F3 F2	1E

int09_212C:
	pushx  hl																	; 0235	  A5
	pushb  n																	; 0236	  A4
	movx  hl, $00																; 0237	  CE C5	00
	movw  nn, $2000																; 023A	  B4 20
	testb  [nn+$01], $20														; 023C	  DC 01	20
	callzb  @00000257															; 023F	  E2 17
	popb  n																		; 0241	  AC
	popx  hl																	; 0242	  AD
	jmp	 @0000212C																; 0243	  F3 E7	1E

int0A_2132:
	pushx  hl																	; 0246	  A5
	pushb  n																	; 0247	  A4
	movx  hl, $00																; 0248	  CE C5	00
	movw  nn, $2000																; 024B	  B4 20
	testb  [nn+$01], $20														; 024D	  DC 01	20
	callzb  @00000257															; 0250	  E2 06
	popb  n																		; 0252	  AC
	popx  hl																	; 0253	  AD
	jmp	 @00002132																; 0254	  F3 DC	1E

	jmp	 intstuff2																; 0257	  F3 25	01

int0B_2138:
	pushx  hl																	; 025A	  A5
	pushb  n																	; 025B	  A4
	movx  hl, $00																; 025C	  CE C5	00
	movw  nn, $2000																; 025F	  B4 20
	testb  [nn+$01], $20														; 0261	  DC 01	20
	callzb  @00000257															; 0264	  E2 F2
	popb  n																		; 0266	  AC
	popx  hl																	; 0267	  AD
	jmp	 @00002138																; 0268	  F3 CE	1E

	.org	0x26B
int0C_213E:
	pushx  hl																	; 026B	  A5
	pushb  n																	; 026C	  A4
	movx  hl, $00																; 026D	  CE C5	00
	movw  nn, $2000																; 0270	  B4 20
	testb  [nn+$01], $20														; 0272	  DC 01	20
	callzb  @00000257															; 0275	  E2 E1
	popb  n																		; 0277	  AC
	popx  hl																	; 0278	  AD
	jmp	 @0000213E																; 0279	  F3 C3	1E

int0D_2144:
	pushx  hl																	; 027C	  A5
	pushb  n																	; 027D	  A4
	movx  hl, $00																; 027E	  CE C5	00
	movw  nn, $2000																; 0281	  B4 20
	testb  [nn+$01], $20														; 0283	  DC 01	20
	callzb  @00000257															; 0286	  E2 D0
	popb  n																		; 0288	  AC
	popx  hl																	; 0289	  AD
	jmp	 @00002144																; 028A	  F3 B8	1E

int0E_214A:
	pushx  hl																	; 028D	  A5
	pushb  n																	; 028E	  A4
	movx  hl, $00																; 028F	  CE C5	00
	movw  nn, $2000																; 0292	  B4 20
	testb  [nn+$01], $20														; 0294	  DC 01	20
	callzb  @00000257															; 0297	  E2 BF
	popb  n																		; 0299	  AC
	popx  hl																	; 029A	  AD
	jmp	 @0000214A																; 029B	  F3 AD	1E

int0F_2150:
	pushx  hl																	; 029E	  A5
	pushb  n																	; 029F	  A4
	movx  hl, $00																; 02A0	  CE C5	00
	movw  nn, $2000																; 02A3	  B4 20
	testb  [nn+$01], $20														; 02A5	  DC 01	20
	callzb  @00000257															; 02A8	  E2 AE
	popb  n																		; 02AA	  AC
	popx  hl																	; 02AB	  AD
	jmp	 @00002150																; 02AC	  F3 A2	1E

int10_2156:
	pushx  hl																	; 02AF	  A5
	pushb  n																	; 02B0	  A4
	movx  hl, $00																; 02B1	  CE C5	00
	movw  nn, $2000																; 02B4	  B4 20
	testb  [nn+$01], $20														; 02B6	  DC 01	20
	callzb  @00000257															; 02B9	  E2 9D
	popb  n																		; 02BB	  AC
	popx  hl																	; 02BC	  AD
	jmp	 @00002156																; 02BD	  F3 97	1E

int14_219E:
	pushx  hl																	; 02C0	  A5
	pushb  n																	; 02C1	  A4
	movx  hl, $00																; 02C2	  CE C5	00
	movw  nn, $2000																; 02C5	  B4 20
	testb  [nn+$01], $20														; 02C7	  DC 01	20
	callzb  @00000257															; 02CA	  E2 8C
	popb  n																		; 02CC	  AC
	popx  hl																	; 02CD	  AD
	jmp	 @0000219E																; 02CE	  F3 CE	1E

int16_2162:
	pushx  hl																	; 02D1	  A5
	pushb  n																	; 02D2	  A4
	movx  hl, $00																; 02D3	  CE C5	00
	movw  nn, $2000																; 02D6	  B4 20
	testb  [nn+$01], $20														; 02D8	  DC 01	20
	callzb  intstuff1															; 02DB	  E2 7D
	popb  n																		; 02DD	  AC
	popx  hl																	; 02DE	  AD
	jmp	 @00002162																; 02DF	  F3 81	1E

int17_2168:
	pushx  hl																	; 02E2	  A5
	pushb  n																	; 02E3	  A4
	movx  hl, $00																; 02E4	  CE C5	00
	movw  nn, $2000																; 02E7	  B4 20
	testb  [nn+$01], $20														; 02E9	  DC 01	20
	callzb  intstuff1															; 02EC	  E2 6C
	popb  n																		; 02EE	  AC
	popx  hl																	; 02EF	  AD
	jmp	 @00002168																; 02F0	  F3 76	1E

	.org	0x2F3
int18_216E:
	pushx  hl																	; 02F3	  A5
	pushb  n																	; 02F4	  A4
	movx  hl, $00																; 02F5	  CE C5	00
	movw  nn, $2000																; 02F8	  B4 20
	testb  [nn+$01], $20														; 02FA	  DC 01	20
	callzb  intstuff1															; 02FD	  E2 5B
	popb  n																		; 02FF	  AC
	popx  hl																	; 0300	  AD
	jmp	 @0000216E																; 0301	  F3 6B	1E

int19_2174:
	pushx  hl																	; 0304	  A5
	pushb  n																	; 0305	  A4
	movx  hl, $00																; 0306	  CE C5	00
	movw  nn, $2000																; 0309	  B4 20
	testb  [nn+$01], $20														; 030B	  DC 01	20
	callzb  intstuff1															; 030E	  E2 4A
	popb  n																		; 0310	  AC
	popx  hl																	; 0311	  AD
	jmp	 @00002174																; 0312	  F3 60	1E

int1A_217A:
	pushx  hl																	; 0315	  A5
	pushb  n																	; 0316	  A4
	movx  hl, $00																; 0317	  CE C5	00
	movw  nn, $2000																; 031A	  B4 20
	testb  [nn+$01], $20														; 031C	  DC 01	20
	callzb  intstuff1															; 031F	  E2 39
	popb  n																		; 0321	  AC
	popx  hl																	; 0322	  AD
	jmp	 @0000217A																; 0323	  F3 55	1E

int1B_2180:
	pushx  hl																	; 0326	  A5
	pushb  n																	; 0327	  A4
	movx  hl, $00																; 0328	  CE C5	00
	movw  nn, $2000																; 032B	  B4 20
	testb  [nn+$01], $20														; 032D	  DC 01	20
	callzb  intstuff1															; 0330	  E2 28
	popb  n																		; 0332	  AC
	popx  hl																	; 0333	  AD
	jmp	 @00002180																; 0334	  F3 4A	1E

int1C_2186:
	pushx  hl																	; 0337	  A5
	pushb  n																	; 0338	  A4
	movx  hl, $00																; 0339	  CE C5	00
	movw  nn, $2000																; 033C	  B4 20
	testb  [nn+$01], $20														; 033E	  DC 01	20
	callzb  intstuff1															; 0341	  E2 17
	popb  n																		; 0343	  AC
	popx  hl																	; 0344	  AD
	jmp	 @00002186																; 0345	  F3 3F	1E

	.org	0x348
int1D_218C:
	pushx  hl																	; 0348	  A5
	pushb  n																	; 0349	  A4
	movx  hl, $00																; 034A	  CE C5	00
	movw  nn, $2000																; 034D	  B4 20
	testb  [nn+$01], $20														; 034F	  DC 01	20
	callzb  intstuff1															; 0352	  E2 06
	popb  n																		; 0354	  AC
	popx  hl																	; 0355	  AD
	jmp	 @0000218C																; 0356	  F3 34	1E

intstuff1:
	jmp	 @0000037E																; 0359	  F3 23	00

int1E_2192:
	pushx  hl																	; 035C	  A5
	pushb  n																	; 035D	  A4
	movx  hl, $00																; 035E	  CE C5	00
	movw  nn, $2000																; 0361	  B4 20
	testb  [nn+$01], $20														; 0363	  DC 01	20
	callzb  intstuff1															; 0366	  E2 F2
	popb  n																		; 0368	  AC
	popx  hl																	; 0369	  AD
	jmp	 @00002192																; 036A	  F3 26	1E

int1F_2198:
	pushx  hl																	; 036D	  A5
	pushb  n																	; 036E	  A4
	movx  hl, $00																; 036F	  CE C5	00
	movw  nn, $2000																; 0372	  B4 20
	testb  [nn+$01], $20														; 0374	  DC 01	20
	callzb  intstuff1															; 0377	  E2 E1
	popb  n																		; 0379	  AC
	popx  hl																	; 037A	  AD
	jmp	 @00002198																; 037B	  F3 1B	1E

;-----------------------------------------------------------------------------

	.org	0x037E
intstuff2:

	testb  [nn+$02], $08														; 037E	  DC 02	08
	jnzb	 already_fast0															; 0381	  E7 08
	pushb  flags																; 0383	  A7
	movb  flags, $C0															; 0384	  9F C0
	call  set_fast_speed														; 0386	  F2 2A	07
	popb  flags																	; 0389	  AF
already_fast0:

	testb  [nn+$71], $04														; 038A	  DC 71	04
	jzb	@000003A2																; 038D	  E6 14
	testb  [nn+$02], $40														; 038F	  DC 02	40
	jzb	@000003A2																; 0392	  E6 0F
	pushb  flags																; 0394	  A7
	movb  flags, $C0															; 0395	  9F C0
	call  @00000B08																; 0397	  F2 6F	07
	testb  [nn+$01], $40														; 039A	  DC 01	40
	jzb	@000003A1																; 039D	  E6 03
	call  flash0418																; 039F	  F0 78
	popb  flags																	; 03A1	  AF

	testb  [nn+$01], $80														; 03A2	  DC 01	80
	jzb	@000003B0																; 03A5	  E6 0A
	addw sp,3																	; 03a7	  cf 68	03 00
	popb  n																		; 03AB	  AC
	popx  hl																	; 03AC	  AD
	jmp	 ram_vector																; 03AD	  F3 4E	1C
	pushb  flags																; 03B0	  A7
	movb  flags, $C0															; 03B1	  9F C0
	call  flash0418																; 03B3	  F0 64
	orb	 [nn+$01], $20															; 03B5	  D9 01	20
	popb  flags																	; 03B8	  AF
	ret																			; 03B9	  F8

int15_215C:
	pushx  hl																	; 03BA	  A5
	pushb  n																	; 03BB	  A4
	movx  hl, $00																; 03BC	  CE C5	00
	movw  nn, $2000																; 03BF	  B4 20
	testb  [nn+$01], $20	; test bit 5										; 03C1	  DC 01	20
	jnzb	 @00000413																; 03C4	  E7 4E
	testb  [nn+$01], $10	; test bit 4										; 03C6	  DC 01	10
	jnz	 reset2																	; 03C9	  EF E0	FC

	testb  [nn+$02], $08	; test bit 3										; 03CC	  DC 02	08
	jnzb	 already_fast1															; 03CF	  E7 08
	pushb  flags																; 03D1	  A7
	movb  flags, $C0															; 03D2	  9F C0
	call  set_fast_speed														; 03D4	  F2 DC	06
	popb  flags																	; 03D7	  AF
already_fast1:

	testb  [nn+$71], $04														; 03D8	  DC 71	04
	jzb	@000003F0																; 03DB	  E6 14
	testb  [nn+$02], $40														; 03DD	  DC 02	40
	jzb	@000003F0																; 03E0	  E6 0F
	pushb  flags																; 03E2	  A7
	movb  flags, $C0															; 03E3	  9F C0
	call  @00000B08																; 03E5	  F2 21	07
	testb  [nn+$01], $40														; 03E8	  DC 01	40
	jzb	@000003EF																; 03EB	  E6 03
	call  flash0418																; 03ED	  F0 2A
	popb  flags																	; 03EF	  AF
	testb  [nn+$01], $80														; 03F0	  DC 01	80
	jzb	@000003FF																; 03F3	  E6 0B
	testb  [nn+$02], $20														; 03F5	  DC 02	20
	jnzb	 @0000040D																; 03F8	  E7 14
	popb  n																		; 03FA	  AC
	popx  hl																	; 03FB	  AD
	jmp	 ram_vector																; 03FC	  F3 FF	1B

	pushb  flags																; 03FF	  A7
	movb  flags, $C0															; 0400	  9F C0
	call  flash0418																; 0402	  F0 15
	orb	 [nn+$01], $20															; 0404	  D9 01	20
	popb  flags																	; 0407	  AF
	testb  [nn+$02], $20														; 0408	  DC 02	20
	jzb	@00000413																; 040B	  E6 07
	movb  [nn+$29],	$80															; 040D	  DD 29	80
	popb  n																		; 0410	  AC
	popx  hl																	; 0411	  AD
	reti																		; 0412	  F9
	popb  n																		; 0413	  AC
	popx  hl																	; 0414	  AD
	jmp	 @0000215C																; 0415	  F3 45	1D

;-----------------------------------------------------------------------------

	.org	0x0418
flash0418:
	pushxxx																		;		  A6
	pushw  ba																	; 0419	  A0
	pushw  hl																	; 041A	  A1

	testb  [nn+$01], $08														; 041B	  DC 01	08
	jnzb	 @00000429																; 041E	  E7 0A
	testb  [nn+$01], $01														; 0420	  DC 01	01
	jzb	@0000043A																; 0423	  E6 16
	movb  l, $00																; 0425	  B2 00
	jmpb int13																	; 0427	  F1 06

	movb  l, [nn+$01]															; 0429	  54 01
	ANDB L,7																	; 042B	  CE B1	07
	movx  x1, $07																; 042E	  CE C6	07
	movb  a, $00																; 0431	  B0 00
	call  flash_0507															; 0433	  F2 D2	00
	movb  a, l																	; 0436	  42
	call  flash053B																; 0437	  F2 02	01

	popw  hl																	; 043A	  A9
	popw  ba																	; 043B	  A8
	popxxx																		; 043C	  AE
	ret																			; 043D	  F8

int13:
	pushx  hl																	; 043E	  A5
	pushb  n																	; 043F	  A4
	movx  hl, $00																; 0440	  CE C5	00
	movw  nn, $2000																; 0443	  B4 20
	testb  [nn+$01], $30														; 0445	  DC 01	30
	jnz	 reset2																	; 0448	  EF 61	FC

	testb  [nn+$02], $08		; test speed									; 044B	  DC 02	08
	jnzb	 already_fast2															; 044E	  E7 08
	pushb  flags																; 0450	  A7
	movb  flags, $C0															; 0451	  9F C0
	call  set_fast_speed														; 0453	  F2 5D	06
	popb  flags																	; 0456	  AF
already_fast2:

	testb  [nn+$01], $80														; 0457	  DC 01	80
	jzb	@00000461																; 045A	  E6 06
	testb  [nn+$01], $40														; 045C	  DC 01	40
	jzb	@00000464																; 045F	  E6 04
	jmp	 int_shutdown															; 0461	  F3 3A	03
	testb  [nn+$71], $04														; 0464	  DC 71	04
	jzb	@00000475																; 0467	  E6 0D
	testb  [nn+$02], $40														; 0469	  DC 02	40
	jzb	@00000475																; 046C	  E6 08
	pushb  flags																; 046E	  A7
	movb  flags, $C0															; 046F	  9F C0
	call  @00000B08																; 0471	  F2 95	06
	popb  flags																	; 0474	  AF
	popb  n																		; 0475	  AC
	popx  hl																	; 0476	  AD
	jmp	 ram_vector																; 0477	  F3 84	1B

;-----------------------------------------------------------------------------

	.org	0x047A
	popb  flags																	; 047A	  AF
flash_read_ids:
	pushb  flags																;		  A7
	movb  flags, $C0															; 047C	  9F C0
	pushx  hl																	; 047E	  A5
	pushw  hl																	; 047F	  A1
	call  flash_begin_cmd														; 0480	  F2 0D	01
; read cartridge chip ID
	movw  hl, $5555																; 0483	  C5 55	55
	movb  [hl],	$90		; read silicon ID										; 0486	  B5 90
	movb  b, [$2100]		; manufacturer code		$BF	SST						; 0488	  CE D1	00 21
	movb  a, [$2101]		; device code		SST39LF/VF016 0001H	D9H			; 048C	  CE D0	01 21
	popw  hl																	; 0490	  A9
	popx  hl																	; 0491	  AD
	reti																		; 0492	  F9

	popb  flags																	; 0493	  AF
flash_reset:
	pushb  flags																;		  A7
	movb  flags, $C0															; 0495	  9F C0
	pushx  hl																	; 0497	  A5
	pushw  hl																	; 0498	  A1
	call  flash_begin_cmd														; 0499	  F2 F4	00
	movw  hl, $5555																; 049C	  C5 55	55
	movb  [hl],	$F0		; reset/read											; 049F	  B5 F0
	popw  hl																	; 04A1	  A9
	popx  hl																	; 04A2	  AD
	reti																		; 04A3	  F9

flash_program_byte:
	popb  flags																	; 04A4	  AF
	pushb  flags																; 04A5	  A7
	movb  flags, $C0															; 04A6	  9F C0
	pushx  hl																	; 04A8	  A5
	pushw  hl																	; 04A9	  A1
	call  flash_begin_cmd													   ; 04AA	 F2	E3 00
	movw  hl, $5555																; 04AD	  C5 55	55
	movb  [hl],	$A0		; byte program											; 04B0	  B5 A0
	movb  [x1],	a																; 04B2	  60
	movb  h, $08																; 04B3	  B3 08
;loop
	decb  h																		; 04B5	  8B
	jnzb	 @000004BC																; 04B6	  E7 05
	movb  a, $FF																; 04B8	  B0 FF
	jmpb @000004C5																; 04BA	  F1 0A

	movb  b, [x1]		; check	twice...										; 04BC	  4E
	cmpb  a, b																	; 04BD	  31
	jnzb	 @000004B5																; 04BE	  E7 F6
	movb  b, [x1]																; 04C0	  4E
	cmpb  a, b																	; 04C1	  31
	jnzb	 @000004B5																; 04C2	  E7 F2
;
	xorb  a, a																	; 04C4	  38
	popw  hl																	; 04C5	  A9
	popx  hl																	; 04C6	  AD
	reti																		; 04C7	  F9

;sector	erase. x1 =	sector
flash_erase_sector:
	movb  flags, $C0															; 04C8	  9F C0
	pushx  hl																	; 04CA	  A5
	pushw  hl																	; 04CB	  A1
	call  flash_begin_cmd														; 04CC	  F2 C1	00
	movw  hl, $5555																; 04CF	  C5 55	55
	movb  [hl],	$80		; ...													; 04D2	  B5 80
	movb  [hl],	$AA		; ...													; 04D4	  B5 AA
	movw  hl, $2AAA																; 04D6	  C5 AA	2A
	movb  [hl],	$55		; ...													; 04D9	  B5 55
	movb  [x1],	$30		; sector erase											; 04DB	  B6 30
	movb  a, $FF																; 04DD	  B0 FF
	movw  hl, $1389	; wait count												; 04DF	  C5 89	13
	decw  hl																	; 04E2	  99
	jnzb	 @000004E9																; 04E3	  E7 05
	movb  a, $FF		; erase	error											; 04E5	  B0 FF
	jmpb @000004F2		; go to	end												; 04E7	  F1 0A
;check if one
	movb  b, [x1]																; 04E9	  4E
	cmpb  a, b																	; 04EA	  31
	jnzb	 @000004E2																; 04EB	  E7 F6
	movb  b, [x1]																; 04ED	  4E
	cmpb  a, b																	; 04EE	  31
	jnzb	 @000004E2																; 04EF	  E7 F2
	xorb  a, a																	; 04F1	  38
	popw  hl																	; 04F2	  A9
	popx  hl																	; 04F3	  AD
	reti																		; 04F4	  F9

	popb  flags																	; 04F5	  AF
flash_cmd_D0:
	pushb  flags																;		  A7
	movb  flags, $C0				; disable interrupts ?						; 04F7	  9F C0
	pushx  hl																	; 04F9	  A5
	pushw  hl																	; 04FA	  A1
	call  flash_begin_cmd														; 04FB	  F2 92	00
	movw  hl, $5555																; 04FE	  C5 55	55
	movb  [hl],	$D0				; !!!											; 0501	  B5 D0
	popw  hl																	; 0503	  A9
	popx  hl																	; 0504	  AD
	reti																		; 0505	  F9

;-----------------------------------------------------------------------------

	.org	0x0506
	popb  flags																	; 0506	  AF
flash_0507:
;params: x1=7,a=0
	pushb  flags																;		  A7
	movb  flags, $C0															; 0508	  9F C0
	call  flash_cmd_D0															; 050A	  F2 EA	FF
	pushw  x1																	; 050D	  A2
	movw  x1, $FFFF																; 050E	  C6 FF	FF
	movb  [x1],	a																; 0511	  60
	popw  x1																	; 0512	  AA
	call  flash_reset															; 0513	  F2 7F	FF
	reti																		; 0516	  F9

	.org	0x0517
flash_cmd_C9:
	popb  flags																	; 0517	  AF
	pushb  flags																; 0518	  A7
	movb  flags, $C0															; 0519	  9F C0
	pushx  hl																	; 051B	  A5
	pushw  hl																	; 051C	  A1
	call  flash_begin_cmd														; 051D	  F2 70	00
	movw  hl, $5555																; 0520	  C5 55	55
	movb  [hl],	$C9			; !!!												; 0523	  B5 C9
	movb  [hl],	a																; 0525	  68
	popw  hl																	; 0526	  A9
	popx  hl																	; 0527	  AD
	reti																		; 0528	  F9

	popb  flags																	; 0529	  AF
flash_cmd_C0:
	pushb  flags																;		  A7
	movb  flags, $C0															; 052B	  9F C0
	pushx  hl																	; 052D	  A5
	pushw  hl																	; 052E	  A1
	call  flash_begin_cmd														; 052F	  F2 5E	00
	movw  hl, $5555																; 0532	  C5 55	55
	movb  [hl],	$C0			; !!!												; 0535	  B5 C0
	popw  hl																	; 0537	  A9
	popx  hl																	; 0538	  AD
	reti																		; 0539	  F9

flash053A:
	popb  flags																	; 053A	  AF
flash053B:
	pushb  flags																; 053B	  A7
	movb  flags, $C0															; 053C	  9F C0
	pushxxx																		; 053E	  A6
	pushw  x1																	; 053F	  A2
	pushw  x2																	; 0540	  A3
	pushw  hl																	; 0541	  A1
	movb  l, $60																; 0542	  B2 60
	mul	l,a																		; 0544	  ce d8
	movw  x1, $1048																; 0546	  C6 48	10
	addw x1,hl																	; 0549	  cf 41
	movx  x1, $04																; 054B	  CE C6	04
	movb  a, [x1]																; 054E	  46
	cmpb  a, $08																; 054F	  32 08
	jncb	 @00000556																; 0551	  E5 04
	call  @00000518																; 0553	  F2 C3	FF
	subw sp,8																	; 0556	  cf 6a	08 00
	movx  x2, $00																; 055A	  CE C7	00
	unknownCFFE																	; 055D	  CF FE

; copy 8 bytes
	movb  l, $00																; 055F	  B2 00
	ldb	a,[x1+l]																; 0561	  ce 42
	ldb	[x2+l],a																; 0563	  ce 47
	incb  l																		; 0565	  82
	cmpb  l, $08																; 0566	  CE BD	08
	jnzb	 @00000561																; 0569	  E7 F7

;
	call  flash_cmd_D0															; 056B	  F2 89	FF
	movb  a, $03																; 056E	  B0 03
	movw  x1, $FFFF																; 0570	  C6 FF	FF

; loop $3FFFF..$23FFFF (increments of $40000 = 8 times)
	movx  x1, a																	; 0573	  CE CE
	movb  b, [x2]																; 0575	  4F
	cmpb  b, $08																; 0576	  CE BC	08
	jcb	@0000057D																; 0579	  E4 03
	movb  b, $08																; 057B	  B1 08
	movb  [x1],	b																; 057D	  61
	incw  x2																	; 057E	  93
	addb a,4																	; 057f	  02 04
	cmpb  a, $23																; 0581	  32 23
	jnzb	 @00000573																; 0583	  E7 EF

;
	call  flash_reset															; 0585	  F2 0D	FF
	unknownCFF3																	; 0588	  CF F3
	popw  hl																	; 058A	  A9
	popw  x2																	; 058B	  AB
	popw  x1																	; 058C	  AA
	popxxx																		; 058D	  AE
	reti																		; 058E	  F9


flash_begin_cmd:
	movx  hl, $00																;		  CE C5	00
	movw  hl, $5555																; 0592	  C5 55	55
	movb  [hl],	$AA																; 0595	  B5 AA
	movw  hl, $2AAA																; 0597	  C5 AA	2A
	movb  [hl],	$55																; 059A	  B5 55
	ret																			; 059C	  F8


	.org	0x059D
; returns z	and	a
flash_detect:
	movb  b, [$5555]		; save values										;		  CE D1	55 55
	movb  a, [$2AAA]															; 05A1	  CE D0	AA 2A
	pushw  ba																	; 05A5	  A0
	movb  a, $FF																; 05A6	  B0 FF
	movb  [$2AAA], a															; 05A8	  CE D4	AA 2A
	movb  [$2AAA], a															; 05AC	  CE D4	AA 2A
	call  flash_reset															; 05B0	  F2 E2	FE
	call  flash_cmd_C0															; 05B3	  F2 75	FF
	call  flash_read_ids		; read ID codes									; 05B6	  F2 C3	FE
	call  flash_reset															; 05B9	  F2 D9	FE
	cmpw  ba, $BFD9																; 05BC	  D4 D9	BF
	popw  ba																	; 05BF	  A8
	jz	@000005CA																; 05C0	  E6 09
	movb  [$5555], b		; restore values if	not	flash						; 05C2	  CE D5	55 55
	movb  [$2AAA], a															; 05C6	  CE D4	AA 2A
	movb  a, [$2AAA]															; 05CA	  CE D0	AA 2A
	ret																			; 05CE	  F8

	.org	0x05CF
flash_05CF:
	call  flash_detect															;		  F2 CC	FF
	jnzb	 @00000601			; not a	flash?										; 05D2	  E7 2E
	pushxxx																		; 05D4	  A6
	movx  x1, $07																; 05D5	  CE C6	07
	movb  a, $00																; 05D8	  B0 00
	call  flash_0507															; 05DA	  F2 2B	FF
	movx  x1, $04																; 05DD	  CE C6	04
	movw  x1, $1300																; 05E0	  C6 00	13
	movb  a, [x1]			; [$41300] ?										; 05E3	  46
	popxxx																		; 05E4	  AE

	testb  a, $02			; bit 1	?											; 05E5	  96 02
	jnzb	 @000005F6																; 05E7	  E7 0E
	noidea $08																	; 05E9	  CE C4	08
	;call  @FFFF9400																; 05EC	  F2 12	8E
	call -0x6C00
	movb  [$14E0], a															; 05EF	  CE D4	E0 14
	jmp	 nintendo_check															; 05F3	  F3 40	FB

	testb  a, $01			; bit 0	?											; 05F6	  96 01
	jnzb	 @0000060A																; 05F8	  E7 11
	xorb  a, a																	; 05FA	  38
	call  flash053B																; 05FB	  F2 3E	FF
	orb	 [nn+$01], $01															; 05FE	  D9 01	01
	movb  a, $FF																; 0601	  B0 FF
	movb  [$14E0], a															; 0603	  CE D4	E0 14
	jmp	 nintendo_check															; 0607	  F3 2C	FB

;fill 240 zero bytes
	movw  x1, $19D0																; 060A	  C6 D0	19
	xorb  a, a																	; 060D	  38
	movb  [x1],	a																; 060E	  60
	incw  x1																	; 060F	  92
	cmpw  x1, $1C10																; 0610	  D6 10	1C
	jnzb	 @0000060E																; 0613	  E7 FA

	pushxxx																		; 0615	  A6
	movb  a, $04																; 0616	  B0 04
	movx  x1, a																	; 0618	  CE CE
	movx  x2, a																	; 061A	  CE CF
	xorb  a, a																	; 061C	  38
	movb  [$14E2], a															; 061D	  CE D4	E2 14
	movb  [$14E3], a															 ; 0621	   CE D4 E3	14
	movw  hl, $14E4																; 0625	  C5 E4	14
	movw [$1524],HL																; 0628	  BD 24	15
	movw  hl, $19D0																; 062B	  C5 D0	19
	movw [$1526],HL																; 062E	  BD 26	15
	movw  x2, $1050																; 0631	  C7 50	10
	movb  a, [x2]																; 0634	  47
	orb	 a,	a																	; 0635	  28
	jz	@000006BA																; 0636	  EE 82	00
	cmpb  a, $FF																; 0639	  32 FF
	jz	@000006BA																; 063B	  EE 7D	00
	cmpb  a, $FE																; 063E	  32 FE
	jz	@00000688																; 0640	  E6 47
	movw  x1, x2																; 0642	  CF EB
	incw  x1																	; 0644	  92
	movb  a, [x1]																; 0645	  46
	testb  a, $80																; 0646	  96 80
	jnzb	 @00000657																; 0648	  E7 0E
	xorb  a, a																	; 064A	  38
	decw  x1																	; 064B	  9A
	call  @000004A5																; 064C	  F2 57	FE
	orb	 a,	a																	; 064F	  28
	jz	@000006BA																; 0650	  EE 68	00
	popxxx																		; 0653	  AE
	jmp	 reset3																	; 0654	  F3 50	07

	.org	0x0657

	movb  l, $00																; 0657	  B2 00
	movw  ba, x1																; 0659	  CF E2
	addw ba,$000f																; 065b	  c0
	pushw  ba																	; 065E	  A0
	movb  a, [x1]																; 065F	  46
	movb  b, $80																; 0660	  B1 80
	testb  a, b																	; 0662	  94
	jz	@00000677																; 0663	  E6 13
	incb  l																		; 0665	  82
	shrb b																		; 0666	  ce 8d
	jnzb	 @00000662																; 0668	  E7 F9
	incw  x1																	; 066A	  92
	popw  ba																	; 066B	  A8
	pushw  ba																	; 066C	  A0
	cmpw ba,x1																	; 066D	  CF 1A
	jnzb	 @00000675																; 066F	  E7 05
	movb  b, $80																; 0671	  B1 80
	jmpb @00000677																; 0673	  F1 03

	jmpb @0000065F																; 0675	  F1 E9

	rol	b																		; 0677	  CE 95
	cmpb  b, $01																; 0679	  CE BC	01
	jnzb	 @0000067F																; 067C	  E7 02
	decw  x1																	; 067E	  9A
	not	b																		; 067F	  CE A1
	movb  a, [x1]																; 0681	  46
	andb  a, b																	; 0682	  21
	movb  h, a																	; 0683	  58
	popw  ba																	; 0684	  A8
	movb  b, h																	; 0685	  4B
	decb  l																		; 0686	  8A
	movb  a, l																	; 0687	  42
	pushw  ba																	; 0688	  A0
	movb  a, [$14E2]															; 0689	  CE D0	E2 14
	incb  a																		; 068D	  80
	movb  [$14E2], a															; 068E	  CE D4	E2 14
	movw HL,[$1524]																; 0692	  B9 24	15
	movb  a, [$14E3]															; 0695	  CE D0	E3 14
	movb  [hl],	a																; 0699	  68
	incw  hl																	; 069A	  91
	popw  ba																	; 069B	  A8
	movb  [hl],	a																; 069C	  68
	incw  hl																	; 069D	  91
	movb  [hl],	b																; 069E	  69
	incw  hl																	; 069F	  91
	ldw [hl],x1																	; 06A0	  CF C6
	addw hl,5																	; 06a2	  c1 05	00
	movw [$1524],hl																; 06a5	  bd 24	15
	movw hl,[$1526]																; 06a8	  b9 26	15
	movw  x1, x2																; 06AB	  CF EB
	movb  b, $48																; 06AD	  B1 48
	subw  x1, $0050																; 06AF	  D2 50	00
	movb  [hl],	[x1]															; 06B2	  6E
	incw  hl																	; 06B3	  91
	incw  x1																	; 06B4	  92
	jdbnz  @000006B2															; 06B5	  F5 FC
	movw [$1526],HL																; 06B7	  BD 26	15
	addw x2,$60																	; 06ba	  c3 60	00
	movb  a, [$14E3]															; 06BD	  CE D0	E3 14
	incb  a																		; 06C1	  80
	movb  [$14E3], a															; 06C2	  CE D4	E3 14
	cmpb  a, $08																; 06C6	  32 08
	jnz	 @00000634																; 06C8	  EF 6A	FF
	popxxx																		; 06CB	  AE
	movb  a, [$14E2]															; 06CC	  CE D0	E2 14
	orb	 a,	a																	; 06D0	  28
	jnzb	 @000006D6																; 06D1	  E7 04
	jmp	 reset3																	; 06D3	  F3 D1	06
	orb	 [nn+$01], $08															; 06D6	  D9 01	08
	jmp	 @00000C0E																; 06D9	  F3 33	05
	shl	a																		; 06DC	  CE 84
	shl	a																		; 06DE	  CE 84
	shl	a																		; 06E0	  CE 84
	movb  b, $00																; 06E2	  B1 00
	movw  x2, $14E4																; 06E4	  C7 E4	14
	LDB	A,L																		; 06E7	  CF 42
	movb  h, [x2]																; 06E9	  5F
	incw  x2																	; 06EA	  93
	movb  b, [x2]																; 06EB	  4F
	movb  [$14E0], b															; 06EC	  CE D5	E0 14
	cmpb  b, $FE																; 06F0	  CE BC	FE
	jz	@00000706																; 06F3	  E6 12
	incw  x2																	; 06F5	  93
	movb  a, [x2]																; 06F6	  47
	incw  x2																	; 06F7	  93
	unknownCFDA																	; 06F8	  CF DA
	pushxxx																		; 06FA	  A6
	movx  x1, $04																; 06FB	  CE C6	04
	call  @000004A5																; 06FE	  F2 A5	FD
	popxxx																		; 0701	  AE
	orb	 a,	a																	; 0702	  28
	jnz	 reset3																	; 0703	  EF A1	06
	movb  b, [nn+$01]															; 0706	  4C 01
	movb  a, h																	; 0708	  43
	orb	 a,	b																	; 0709	  29
	movb  [nn+$01],	a															; 070A	  78 01
	movb  a, h																	; 070C	  43
	call  flash053B																; 070D	  F2 2C	FE
	jmp	 nintendo_check															; 0710	  F3 23	FA

;-----------------------------------------------------------------------------

	.org	0x0713
int_suspend:
	pushx  hl																	; 0713	  A5
	pushb  n																	; 0714	  A4
	movb  flags, $C0															; 0715	  9F C0
	call  set_io_base															; 0717	  F2 AB	04
	orb	 [nn+$02], $20															; 071A	  D9 02	20
	movb  a, [nn+$80]															; 071D	  44 80
	pushw  ba																	; 071F	  A0
	movb  b, [nn+$50]															; 0720	  4C 50
	movb  a, [nn+$21]															; 0722	  44 21
	andb  a, $0C																; 0724	  22 0C
	pushw  ba																	; 0726	  A0
	movb  b, [nn+$23]															; 0727	  4C 23
	movb  a, [nn+$24]															; 0729	  44 24
	pushw  ba																	; 072B	  A0
	movb  b, [nn+$25]															; 072C	  4C 25
	movb  a, [nn+$26]															; 072E	  44 26
	pushw  ba																	; 0730	  A0
	movb  [nn+$50],	$80															; 0731	  DD 50	80
	movb  [nn+$54],	$01															; 0734	  DD 54	01
	movb  [nn+$23],	$00															; 0737	  DD 23	00
	movb  [nn+$24],	$00															; 073A	  DD 24	00
	movb  [nn+$25],	$80															; 073D	  DD 25	80
	movb  [nn+$26],	$00															; 0740	  DD 26	00
	orb	 [nn+$21], $0C															; 0743	  D9 21	0C
	call  delay_07CB															; 0746	  F2 82	04
	movb  [nn+$29],	$80															; 0749	  DD 29	80
	movb  a, $80																; 074C	  B0 80
	call  display_off1															; 074E	  F2 70	00
	call  init_display2															; 0751	  F2 06	01
	andb  [nn+$02],	$DF															; 0754	  D8 02	DF
	popw  ba																	; 0757	  A8
	movb  [nn+$26],	a															; 0758	  78 26
	movb  [nn+$25],	b															; 075A	  79 25
	popw  ba																	; 075C	  A8
	movb  [nn+$23],	b															; 075D	  79 23
	testb  [nn+$01], $40														; 075F	  DC 01	40
	jz	@00000766																; 0762	  E6 03
	orb	 a,	$02																	; 0764	  2A 02
	movb  [nn+$24],	a															; 0766	  78 24
	popb  a																		; 0768	  CF B4
	movb  b, [nn+$21]															; 076A	  4C 21
	andb b,$F3																	; 076c	  ce b0	f3
	orb	a,b																		; 076f	  29
	ldb	[nn+$21],a																; 0770	  78 21
	popb  b																		; 0772	  CF B5
	movb  [nn+$50],	b															; 0774	  79 50
	popw  ba																	; 0776	  A8
	movb  [nn+$80],	a															; 0777	  78 80
	popb  n																		; 0779	  AC
	popx  hl																	; 077A	  AD
	reti																		; 077B	  F9

int22:
	pushx  hl																	; 077C	  A5
	pushb  n																	; 077D	  A4
	movb  flags, $C0															; 077E	  9F C0
	call  set_io_base															; 0780	  F2 42	04
	movb  a, $40																; 0783	  B0 40
	call  display_off1															; 0785	  F2 39	00
	popb  n																		; 0788	  AC
	popx  hl																	; 0789	  AD
	reti																		; 078A	  F9
	
	.org	0x78B
int23:
	pushx  hl																	; 078B	  A5
	pushb  n																	; 078C	  A4
	movb  flags, $C0															; 078D	  9F C0
	call  set_io_base															; 078F	  F2 33	04
	andb  [nn+$80],	$F7															; 0792	  D8 80	F7
	movb  a, $40																; 0795	  B0 40
	call  @000007C3																; 0797	  F2 2A	00
	popb  n																		; 079A	  AC
	popx  hl																	; 079B	  AD
	reti																		; 079C	  F9

int_shutdown:
	movb  flags, $C0															; 079D	  9F C0
	movw  sp, $2000																; 079F	  CF 6E	00 20
	call  set_io_base															; 07A3	  F2 1F	04
	call  init_io																; 07A6	  F2 E1	F9
	movb  flags, $C0															; 07A9	  9F C0
	movb  [nn+$01],	$90															; 07AB	  DD 01	90
	jmp	 @00000731																; 07AE	  F3 81	FF

int25_display_off1:
	pushx  hl																	; 07B1	  A5
	pushb  n																	; 07B2	  A4
	call  set_io_base															; 07B3	  F2 0F	04
	movb  flags, $C0															; 07B6	  9F C0
	movb  a, $40																; 07B8	  B0 40
	call  display_off1															; 07BA	  F2 04	00
	popb  n																		; 07BD	  AC
	popx  hl																	; 07BE	  AD
	reti																		; 07BF	  F9

	.org	0x7C0
; a	= flags?
display_off1:
	call  display_off0															; 07C0	  F2 14	01
	testb  [nn+$01], $80														; 07C3	  DC 01	80
	jz	@000007CD																; 07C6	  E6 06
	testb  [nn+$01], $40														; 07C8	  DC 01	40
	jz	@000007D3																; 07CB	  E6 07
	orb	 [nn+$24], $02															; 07CD	  D9 24	02
	orb	 [nn+$21], $30															; 07D0	  D9 21	30
	andb  [nn+$51],	$FD															; 07D3	  D8 51	FD
	movb  [nn+$55],	$01															; 07D6	  DD 55	01
	andb  [nn+$01],	$DF															; 07D9	  D8 01	DF
	call  @00000AF5																; 07DC	  F2 17	03
	call  @00000AD9																; 07DF	  F2 F8	02
	movb  flags, a																; 07E2	  CE C3
	unknownCEAE																	; 07E4	  CE AE
	movb  flags, $C0															; 07E6	  9F C0
	ret																			; 07E8	  F8

int26:
	popb  flags																	; 07E9	  AF
	shl	a																		; 07EA	  CE 84
	shl	a																		; 07EC	  CE 84
	pushx  hl																	; 07EE	  A5
	pushw  hl																	; 07EF	  A1
	movx  hl, $00																; 07F0	  CE C5	00
	movw  hl, $2000																; 07F3	  C5 00	20
	and	[hl], $03																; 07F6	  CE 25	03
	or [hl], a																	; 07F9	  CE 2C
	popw  hl																	; 07FB	  A9
	popx  hl																	; 07FC	  AD
	call  int29b																; 07FD	  F2 23	00
	jmpb @00000831																; 0800	  F1 30

int27:
	call  int29b																; 0802	  F2 1E	00
	popb  flags																	; 0805	  AF
	pushb  flags																; 0806	  A7
	jz	@00000812																; 0807	  E6 0A
	cmpb  a, $3F																; 0809	  32 3F
	jz	@00000815																; 080B	  E6 09
	incb  a																		; 080D	  80
	call  @000007EA																; 080E	  F0 DB
	xorb  a, a																	; 0810	  38
	reti																		; 0811	  F9

	orb	 a,	a																	; 0812	  28
	jnzb	 @00000818																; 0813	  E7 04
	movb  a, $FF																; 0815	  B0 FF
	reti																		; 0817	  F9

	decb  a																		; 0818	  88
	jmpb @0000080E																; 0819	  F1 F4
int28:
	popb  flags																	; 081B	  AF
some_other_label:
	call  int29b																; 081C	  F2 04	00
	jmpb @00000831																; 081F	  F1 11
int29:
	popb  flags																	; 0821	  AF
int29b:
	pushx  hl																	; 0822	  A5
	pushb  n																	; 0823	  A4
	call  set_io_base															; 0824	  F2 9E	03
	movb  a, [nn+$00]															; 0827	  44 00
	shrb a																		; 0829	  ce 8c
	shrb a																		; 082b	  ce 8c
	popb  n																		; 082D	  AC
	popx  hl																	; 082E	  AD
	ret																			; 082F	  F8

; a	= contrast
int_set_contrast:
	popb  flags																	; 0830	  AF
	pushx  hl																	; 0831	  A5
	pushb  n																	; 0832	  A4
	call  set_io_base															; 0833	  F2 8F	03
	movb  b, a																	; 0836	  48
	testb  [nn+$80], $08														; 0837	  DC 80	08
	movb  a, flags																; 083A	  CE C1
	andb  [nn+$80],	$F7															; 083C	  D8 80	F7
	movb  [nn+$FE],	$81		; contrast											; 083F	  DD FE	81
	movb  [nn+$FE],	b															; 0842	  79 FE
	movb  flags, a																; 0844	  CE C3
	jz	@0000084B																; 0846	  E6 04
	orb	 [nn+$80], $08															; 0848	  D9 80	08
	popb  n																		; 084B	  AC
	popx  hl																	; 084C	  AD
	ret																			; 084D	  F8

	.org	0x84E
int2B:
	popb  flags																	; 084E	  AF
	pushx  hl																	; 084F	  A5
	pushb  n																	; 0850	  A4
	call  set_io_base															; 0851	  F2 71	03
	call  init_display2															; 0854	  F0 04
	popb  n																		; 0856	  AC
	popx  hl																	; 0857	  AD
	ret																			; 0858	  F8

init_display2:
	pushb  flags																; 0859	  A7
	movb  flags, $C0															; 085A	  9F C0
	testb  [nn+$02], $04														; 085C	  DC 02	04
	jz	@00000866																; 085F	  E6 06
	orb	 [nn+$02], $10															; 0861	  D9 02	10
	jmpb @00000869																; 0864	  F1 04
	andb  [nn+$02],	$EF															; 0866	  D8 02	EF
	orb	 [nn+$81], $01															; 0869	  D9 81	01
	xorb  a, a																	; 086C	  38
	call  init_display1															; 086D	  F2 0F	00
	reti																		; 0870	  F9

int_init_display:
	popb  flags																	; 0871	  AF
	pushx  hl																	; 0872	  A5
	pushb  n																	; 0873	  A4
	call  set_io_base															; 0874	  F2 4E	03
	call  init_display0															; 0877	  F0 04
	popb  n																		; 0879	  AC
	popx  hl																	; 087A	  AD
	ret																			; 087B	  F8

init_display0:
	movb  a, $FF																; 087C	  B0 FF
init_display1:
	pushb  flags																; 087E	  A7
	movb  flags, $C0															; 087F	  9F C0
	testb  [nn+$81], $01														; 0881	  DC 81	01
	jnzb	 display_not_yet_enabled												; 0884	  E7 02
	reti																		; 0886	  F9

display_not_yet_enabled:
	pushw  hl																	; 0887	  A1
	movw  hl, $20FE																; 0888	  C5 FE	20
	movb  b, [nn+$80]															; 088B	  4C 80
	andb  [nn+$80],	$F7															; 088D	  D8 80	F7
	movb  [hl],	$E3		; ???													; 0890	  B5 E3
	movb  [hl],	$A4		; don't	turn all pixels	on								; 0892	  B5 A4
	movb  [hl],	$AD		; ???													; 0894	  B5 AD
	movb  [hl],	$02		; ^^^ /	set	column LSB									; 0896	  B5 02
	movb  [hl],	$EE		; ???													; 0898	  B5 EE
	movb  [hl],	$40		; ^^^ /	set	initial	display	line						; 089A	  B5 40
	movb  [hl],	$A2		; disable icon row										; 089C	  B5 A2
	movb  [hl],	$A0		; column address $00 is	mapped to SEG0					; 089E	  B5 A0
	movb  [hl],	$C0		; set COM output scan direction							; 08A0	  B5 C0
	movb  [hl],	$A6		; don't	invert											; 08A2	  B5 A6
	movb  [hl],	$2F		; turn on internal voltage booster & regulator,			; 08A4	  B5 2F
										; turn on the output op-amp	buffer
	orb	 a,	a																	; 08A6	  28
	jnzb	 @000008C5																; 08A7	  E7 1D
	pushw  x1																	; 08A9	  A2

	testb  [nn+$02], $08	; test speed										; 08AA	  DC 02	08
	jnzb	 @000008B6																; 08AD	  E7 08
	movb  a, $01																; 08AF	  B0 01
	movw  x1, $0592																; 08B1	  C6 92	05
	jmpb @000008BB																; 08B4	  F1 06
	movb  a, $02																; 08B6	  B0 02

	movw  x1, $55C4																; 08B8	  C6 C4	55
	decw  x1																	; 08BB	  9A
	jnzb	 @000008BB																; 08BC	  E7 FE
	movw  x1, $FFFF																; 08BE	  C6 FF	FF
	decb  a																		; 08C1	  88
	jnzb	 @000008BB																; 08C2	  E7 F8
	popw  x1																	; 08C4	  AA

	movb  [hl],	$AF		; turn on display										; 08C5	  B5 AF
	movb  [nn+$80],	b															; 08C7	  79 80
	popw  hl																	; 08C9	  A9
	reti																		; 08CA	  F9

int_display_off:
	popb  flags																	; 08CB	  AF
	pushx  hl																	; 08CC	  A5
	pushb  n																	; 08CD	  A4
	call  set_io_base															; 08CE	  F2 F4	02
	call  display_off0															; 08D1	  F0 04
	popb  n																		; 08D3	  AC
	popx  hl																	; 08D4	  AD
	ret																			; 08D5	  F8

display_off0:
	pushb  flags																; 08D6	  A7
	movb  flags, $C0															; 08D7	  9F C0
	andb  [nn+$80],	$F7															; 08D9	  D8 80	F7
	movb  [nn+$FE],	$AE	; turn off display										; 08DC	  DD FE	AE
	movb  [nn+$FE],	$AC	; ???													; 08DF	  DD FE	AC
	movb  [nn+$FE],	$28	; turn off voltage booster / op-amp	buffer				; 08E2	  DD FE	28
	movb  [nn+$FE],	$A5	; all pixels on											; 08E5	  DD FE	A5
	andb  [nn+$81],	$FE															; 08E8	  D8 81	FE
	reti																		; 08EB	  F9

	.org	0x08EC
int2E:
	pushx  hl																	; 08EC	  A5
	pushb  n																	; 08ED	  A4
	call  set_io_base															; 08EE	  F2 D4	02
	movb  flags, $C0															; 08F1	  9F C0
	testb  [nn+$01], $80														; 08F3	  DC 01	80
	jnzb	 @00000901																; 08F6	  E7 0A
	orb	 [nn+$01], $80															; 08F8	  D9 01	80
	orb	 [nn+$01], $40															; 08FB	  D9 01	40
	andb  [nn+$01],	$DF															; 08FE	  D8 01	DF
	popb  n																		; 0901	  AC
	popx  hl																	; 0902	  AD
	reti																		; 0903	  F9

int2F:
	pushx  hl																	; 0904	  A5
	pushb  n																	; 0905	  A4
	call  @00000939																; 0906	  F2 31	00
	movb  [nn+$55],	$01															; 0909	  DD 55	01
	andb  [nn+$51],	$FD															; 090C	  D8 51	FD
	movb  flags, $C0															; 090F	  9F C0
	orb	 [nn+$21], $30															; 0911	  D9 21	30
	orb	 [nn+$24], $02															; 0914	  D9 24	02
	orb	 [nn+$01], $20															; 0917	  D9 01	20
	andb  [nn+$01],	$BF															; 091A	  D8 01	BF
	andb  [nn+$01],	$7F															; 091D	  D8 01	7F
	popb  n																		; 0920	  AC
	popx  hl																	; 0921	  AD
	reti																		; 0922	  F9

	.org	0x923
int30:
	pushx  hl																	; 0923	  A5
	pushb  n																	; 0924	  A4
	call  @00000939																; 0925	  F2 12	00
	andb  [nn+$24],	$FD															; 0928	  D8 24	FD
	popb  n																		; 092B	  AC
	popx  hl																	; 092C	  AD
	reti																		; 092D	  F9

int31:
	pushx  hl																	; 092E	  A5
	pushb  n																	; 092F	  A4
	call  @00000939																; 0930	  F2 07	00
	orb	 [nn+$24], $02															; 0933	  D9 24	02
	popb  n																		; 0936	  AC
	popx  hl																	; 0937	  AD
	reti																		; 0938	  F9

	call  set_io_base															; 0939	  F2 89	02
	testb  [nn+$01], $40														; 093C	  DC 01	40
	jnzb	 @00000948																; 093F	  E7 08
	addw sp,3																	; 0941	  cf 68	03 00
	popb  n																		; 0945	  AC
	popx  hl																	; 0946	  AD
	reti																		; 0947	  F9

	ret																			; 0948	  F8

int32:
	pushx  hl																	; 0949	  A5
	pushb  n																	; 094A	  A4
	call  set_io_base															; 094B	  F2 77	02
	movb  flags, $C0															; 094E	  9F C0
	testb  [nn+$01], $80														; 0950	  DC 01	80
	jnzb	 @0000095E																; 0953	  E7 0A
	andb  [nn+$24],	$FD															; 0955	  D8 24	FD
	orb	 [nn+$01], $80															; 0958	  D9 01	80
	andb  [nn+$01],	$DF															; 095B	  D8 01	DF

	popb  n																		; 095E	  AC
	popx  hl																	; 095F	  AD
	reti																		; 0960	  F9

int33:
	pushx  hl																	; 0961	  A5
	pushb  n																	; 0962	  A4
	call  @00000A1A																; 0963	  F2 B5	00
	movb  [nn+$55],	$01															; 0966	  DD 55	01
	andb  [nn+$51],	$FD															; 0969	  D8 51	FD
	movb  flags, $C0															; 096C	  9F C0
	orb	 [nn+$21], $30															; 096E	  D9 21	30
	orb	 [nn+$24], $02															; 0971	  D9 24	02
	orb	 [nn+$01], $20															; 0974	  D9 01	20
	andb  [nn+$01],	$7F															; 0977	  D8 01	7F
	popb  n																		; 097A	  AC
	popx  hl																	; 097B	  AD
	reti																		; 097C	  F9

int34:
	pushx  hl																	; 097D	  A5
	pushb  n																	; 097E	  A4
	movb  flags, $C0															; 097F	  9F C0
	call  @00000A1A																; 0981	  F2 97	00
	pushw  x1																	; 0984	  A2
	pushw  hl																	; 0985	  A1
	testb  [nn+$53], $02														; 0986	  DC 53	02
	jz	@0000098F																; 0989	  E6 05
	movb  a, $01																; 098B	  B0 01
	jmpb @000009DF																; 098D	  F1 51
	movb  b, [nn+$80]			; save LCD config								; 098F	  4C 80
	movb  [nn+$80],	$00		; turn off display etc								; 0991	  DD 80	00

	movb  a, [nn+$71]															; 0994	  44 71
	pushw  ba																	; 0996	  A0
	call  @00000B08																; 0997	  F2 6F	01
	call  delay_07CB															; 099A	  F2 2E	02
	movb  [nn+$28],	$02															; 099D	  DD 28	02
	call  @00000A2F																; 09A0	  F2 8D	00
	jnzb	 @000009AC																; 09A3	  E7 08
	testb  [nn+$01], $08														; 09A5	  DC 01	08
	jnzb	 @000009D8																; 09A8	  E7 2F
	jmpb @000009D1																; 09AA	  F1 26
	testb  [nn+$01], $08														; 09AC	  DC 01	08
	jz	@000009D8																; 09AF	  E6 28
	movb  a, [nn+$01]															; 09B1	  44 01
	andb  a, $07																; 09B3	  22 07
	movb  l, $60																; 09B5	  B2 60
	mul	l,a																		; 09b7	  ce d8
	movw  x1, $1050																; 09b9	  c6 50	10
	addw x1,hl																	; 09bc	  cf 41
	pushxxx																		; 09BE	  A6
	movx  x1, $04																; 09BF	  CE C6	04
	movb  b, [x1]																; 09C2	  4E
	popxxx																		; 09C3	  AE
	cmpb  b, $00																; 09C4	  CE BC	00
	jz	@000009D8																; 09C7	  E6 10
	cmpb  b, $FF																; 09C9	  CE BC	FF
	jz	@000009D8																; 09CC	  E6 0B
	call  flash053B																; 09CE	  F2 6B	FB
	orb	 [nn+$02], $40															; 09D1	  D9 02	40
	popw  ba																	; 09D4	  A8
	xorb  a, a																	; 09D5	  38
	jmpb @000009DD																; 09D6	  F1 06
	popw  ba																	; 09D8	  A8
	movb  [nn+$71],	a															; 09D9	  78 71
	movb  a, $02																; 09DB	  B0 02

	movb  [nn+$80],	b			; restore LCD config							; 09DD	  79 80
	popw  hl																	; 09DF	  A9
	popw  x1																	; 09E0	  AA
	popb  n																		; 09E1	  AC
	popx  hl																	; 09E2	  AD
	reti																		; 09E3	  F9

	.org	0x9E4
int35:
	pushx  hl																	; 09E4	  A5
	pushb  n																	; 09E5	  A4
	movb  flags, $C0															; 09E6	  9F C0
	call  @00000A1A																; 09E8	  F2 30	00
	movb  b, [nn+$80]															; 09EB	  4C 80
	movb  [nn+$80],	$00															; 09ED	  DD 80	00
	pushb  b																	; 09F0	  CF B1
	pushw  x1																	; 09F2	  A2
	pushw  hl																	; 09F3	  A1
	testb  [nn+$53], $02														; 09F4	  DC 53	02
	jz	@000009FD																; 09F7	  E6 05
	movb  a, $01																; 09F9	  B0 01
	jmpb @00000A11																; 09FB	  F1 15
	call  flash0B05																; 09FD	  F2 06	01
	call  @00000A2F																; 0A00	  F2 2D	00
	jz	@00000A11																; 0A03	  E6 0D
	pushxxx																		; 0A05	  A6
	movx  x1, $07																; 0A06	  CE C6	07
	movb  a, $01																; 0A09	  B0 01
	call  flash_0507															; 0A0B	  F2 FA	FA
	popxxx																		; 0A0E	  AE
	movb  a, $FF																; 0A0F	  B0 FF
	popw  hl																	; 0A11	  A9
	popw  x1																	; 0A12	  AA
	popb  b																		; 0A13	  CF B5
	movb  [nn+$80],	b															; 0A15	  79 80
	popb  n																		; 0A17	  AC
	popx  hl																	; 0A18	  AD
	reti																		; 0A19	  F9

	call  set_io_base															; 0A1A	  F2 A8	01
	testb  [nn+$01], $80														; 0A1D	  DC 01	80
	jz	@00000A27																; 0A20	  E6 06
	testb  [nn+$01], $40														; 0A22	  DC 01	40
	jz	@00000A2E																; 0A25	  E6 08
	addw sp,3																	; 0a27	  cf 68	03 00
	popb  n																		; 0A2B	  AC
	popx  hl																	; 0A2C	  AD
	reti																		; 0A2D	  F9

	ret																			; 0A2E	  F8

	.org	0x0A2F
;
	call  flash_detect														    ; 0A2F	 F2	6C FB
	jnzb	 @00000A4D																; 0A32	  E7 1A
	pushxxx																		; 0A34	  A6
	movx  x1, $07																; 0A35	  CE C6	07
	movb  a, $00																; 0A38	  B0 00
	call  flash_0507															; 0A3A	  F2 CB	FA
	movx  x1, $04																; 0A3D	  CE C6	04
	movw  x1, $1300																; 0A40	  C6 00	13
	movb  a, [x1]																; 0A43	  46
	popxxx																		; 0A44	  AE
	testb  a, $01																; 0A45	  96 01
	jnzb	 @00000A4E																; 0A47	  E7 06
	xorb  a, a																	; 0A49	  38
	call  flash053B																; 0A4A	  F2 EF	FA
	xorb  a, a																	; 0A4D	  38
	ret																			; 0A4E	  F8

int36:
	popb  flags																	; 0A4F	  AF
	pushx  hl																	; 0A50	  A5
	pushb  n																	; 0A51	  A4
	call  set_io_base															; 0A52	  F2 70	01
	bcdx  a																		; 0A55	  F6
	andb  a, $30																; 0A56	  22 30
	pushb  flags																; 0A58	  A7
	movb  flags, $C0															; 0A59	  9F C0
	movb  b, [nn+$21]															; 0A5B	  4C 21
	andb B,$CF																	; 0A5D	  CE B0	CF
	orb	a,b																		; 0a60	  29
	movb  [nn+$21],	a															; 0A61	  78 21
	popb  flags																	; 0A63	  AF
	movb  [nn+$55],	$01															; 0A64	  DD 55	01
	andb  [nn+$51],	$FD															; 0A67	  D8 51	FD
	call  delay_07CB															; 0A6A	  F2 5E	01
	movb  [nn+$28],	$02															; 0A6D	  DD 28	02
	orb	 [nn+$24], $02															; 0A70	  D9 24	02
	popb  n																		; 0A73	  AC
	popx  hl																	; 0A74	  AD
	ret																			; 0A75	  F8

int37:
	pushx  hl																	; 0A76	  A5
	pushb  n																	; 0A77	  A4
	call  set_io_base															; 0A78	  F2 4A	01
	andb  [nn+$24],	$FD															; 0A7B	  D8 24	FD
	popb  n																		; 0A7E	  AC
	popx  hl																	; 0A7F	  AD
	reti																		; 0A80	  F9

	.org	0x0A81
int38:
	popb  flags																	; 0A81	  AF
	pushx  hl																	; 0A82	  A5
	pushb  n																	; 0A83	  A4
	pushw  ba																	; 0A84	  A0
	call  set_io_base															; 0A85	  F2 3D	01
	movb  a, flags																; 0A88	  CE C1
	shrb a																		; 0A8A	  CE 8C
	shrb a																		; 0A8C	  CE 8C
	andb  a, $30																; 0A8E	  22 30
	movb  b, [nn+$21]															; 0A90	  4C 21
	andb b,$30																	; 0A92	  CE B0	30
	cmpb  a, b																	; 0A95	  31
	xorb  flags, $01															; 0A96	  9E 01
	jz	@00000AA2																; 0A98	  E6 09
	testb  [nn+$28], $02														; 0A9A	  DC 28	02
	jz	@00000AA2																; 0A9D	  E6 04
	movb  [nn+$28],	$02															; 0A9F	  DD 28	02
	popw  ba																	; 0AA2	  A8
	popb  n																		; 0AA3	  AC
	popx  hl																	; 0AA4	  AD
	ret																			; 0AA5	  F8

	.org	0x0AA6
int_fast_speed:
	pushx  hl																	; 0AA6	  A5
	pushb  n																	; 0AA7	  A4
	call  set_io_base															; 0AA8	  F2 1A	01
	movb  flags, $C0															; 0AAB	  9F C0
	call  set_fast_speed														; 0AAD	  F0 04
	popb  n																		; 0AAF	  AC
	popx  hl																	; 0AB0	  AD
	reti																		; 0AB1	  F9

set_fast_speed:
	pushw  x1																	;		  A2
	andb  [nn+$02],	$FE	; clear	bit	0											; 0AB3	  D8 02	FE
	movw  x1, $0014		; wait a bit											; 0AB6	  C6 14	00
	decw  x1																	; 0AB9	  9A
	jnzb	 @00000AB9																; 0ABA	  E7 FE
	orb	 [nn+$02], $04		; set bit 2											; 0ABC	  D9 02	04
	movw  x1, $0199		; wait a bit											; 0ABF	  C6 99	01
	decw  x1																	; 0AC2	  9A
	jnzb	 @00000AC2																; 0AC3	  E7 FE
	orb	 [nn+$02], $08		; set bit 3											; 0AC5	  D9 02	08
	orb	 [nn+$02], $10		; set bit 4											; 0AC8	  D9 02	10
	popw  x1																	; 0ACB	  AA
	ret																			; 0ACC	  F8

int_slow_speed:
	pushx  hl																	; 0ACD	  A5
	pushb  n																	; 0ACE	  A4
	call  set_io_base															; 0ACF	  F2 F3	00
	movb  flags, $C0															; 0AD2	  9F C0
	call  @00000AD9																; 0AD4	  F0 04
	popb  n																		; 0AD6	  AC
	popx  hl																	; 0AD7	  AD
	reti																		; 0AD8	  F9

	andb  [nn+$02],	$EF															; 0AD9	  D8 02	EF
	andb  [nn+$02],	$F7	; slow speed											; 0ADC	  D8 02	F7
	andb  [nn+$02],	$FB															; 0ADF	  D8 02	FB
	orb	 [nn+$02], $01															; 0AE2	  D9 02	01
	ret																			; 0AE5	  F8

int3B:
	pushx  hl																	; 0AE6	  A5
	pushb  n																	; 0AE7	  A4
	call  set_io_base															; 0AE8	  F2 DA	00
	movb  flags, $C0															; 0AEB	  9F C0
	call  @00000AF2																; 0AED	  F0 04
	popb  n																		; 0AEF	  AC
	popx  hl																	; 0AF0	  AD
	reti																		; 0AF1	  F9

	andb  [nn+$02],	$BF															; 0AF2	  D8 02	BF
	orb	 [nn+$71], $04															; 0AF5	  D9 71	04
	ret																			; 0AF8	  F8

int3C:
	pushx  hl																	; 0AF9	  A5
	pushb  n																	; 0AFA	  A4
	call  set_io_base															; 0AFB	  F2 C7	00
	movb  flags, $C0															; 0AFE	  9F C0
	call  flash0B05																; 0B00	  F0 04
	popb  n																		; 0B02	  AC
	popx  hl																	; 0B03	  AD
	reti																		; 0B04	  F9

flash0B05:
	orb	 [nn+$02], $40															; 0B05	  D9 02	40
	pushw  x1																	; 0B08	  A2
	pushw  ba																	; 0B09	  A0
	andb  [nn+$71],	$FB															; 0B0A	  D8 71	FB
	orb	 [nn+$02], $80															; 0B0D	  D9 02	80
	movw  x1, $0032	; small	delay												; 0B10	  C6 32	00
	decw  x1																	; 0B13	  9A
	jnzb	 @00000B13																; 0B14	  E7 FE
	movb  a, [$2AAA]															; 0B16	  CE D0	AA 2A
	orb	 [nn+$02], $80															; 0B1A	  D9 02	80
	popw  ba																	; 0B1D	  A8
	popw  x1																	; 0B1E	  AA
	ret																			; 0B1F	  F8

int3D:
	popb  flags																	; 0B20	  AF
	pushx  hl																	; 0B21	  A5
	pushb  n																	; 0B22	  A4
	call  set_io_base															; 0B23	  F2 9F	00
	testb  [nn+$53], $02														; 0B26	  DC 53	02
	xorb  flags, $01															; 0B29	  9E 01
	popb  n																		; 0B2B	  AC
	popx  hl																	; 0B2C	  AD
	ret																			; 0B2D	  F8

; load registers and call some routine ?
; parameter	x1
int3E:
	pushx  hl																	; 0B2E	  A5
	pushb  n																	; 0B2F	  A4
	call  set_io_base															; 0B30	  F2 92	00
	pushxxx																		; 0B33	  A6
	pushw  x1																	; 0B34	  A2
	pushw  x2																	; 0B35	  A3
	pushw  hl																	; 0B36	  A1
	pushb  b																	; 0B37	  CF B1
	movb  flags, $C0															; 0B39	  9F C0
	movb  a, [x1]																; 0B3B	  46
	testb  a, $01																; 0B3C	  96 01
	movb  a, flags																; 0B3E	  CE C1
	jz	@00000B4E																; 0B40	  E6 0D

	addw x1,$0a																	; 0b42	  c2 0a	00
	movb  h, [x1]																; 0B45	  5E
	decw  x1																	; 0B46	  9A
	movb  l, [x1]																; 0B47	  56
	decw  x1																	; 0B48	  9A
	pushw  hl																	; 0B49	  A1
	movb  b, [x1]																; 0B4A	  4E
	decw  x1																	; 0B4B	  9A
	jmpb @00000B51																; 0B4C	  F1 04

	addw x1,$07																	; 0b4e	  c2 07	00

	pushw  ba																	; 0B51	  A0
	movb  b, [x1]																; 0B52	  4E
	decw  x1																	; 0B53	  9A
	movb  a, [x1]																; 0B54	  46
	decw  x1																	; 0B55	  9A
	movb  h, [x1]																; 0B56	  5E
	decw  x1																	; 0B57	  9A
	movb  l, [x1]																; 0B58	  56
	decw  x1																	; 0B59	  9A
	movx  x2, a																	; 0B5A	  CE CF
	movw  x2, hl																; 0B5C	  CF ED
	movb  a, [x1]																; 0B5E	  46
	decw  x1																	; 0B5F	  9A
	movb  h, [x1]																; 0B60	  5E
	decw  x1																	; 0B61	  9A
	movb  l, [x1]																; 0B62	  56
	movx  x1, a																	; 0B63	  CE CE
	movw  x1, hl																; 0B65	  CF E9

	orb	 [nn+$02], $80															; 0B67	  D9 02	80
	movb  [x1],	$FF																; 0B6A	  B6 FF
	orb	 [nn+$02], $80															; 0B6C	  D9 02	80
	movb  a, [x2]																; 0B6F	  47
	orb	 [nn+$02], $80															; 0B70	  D9 02	80
	cmpb  a, b																	; 0B73	  31
	popw  ba																	; 0B74	  A8
	pushb  flags																; 0B75	  A7
	movb  flags, a																; 0B76	  CE C3
	jz	@00000B82																; 0B78	  E6 09
	popb  flags																	; 0B7A	  AF
	movb  l, b																	; 0B7B	  51
	popw  ba																	; 0B7C	  A8
	movb  h, a																	; 0B7D	  58
	movb  a, b																	; 0B7E	  41
	pushb  flags																; 0B7F	  A7
	call  @00000B8C																; 0B80	  F0 0B
	popw  ba																	; 0B82	  A8
	andb  a, $01																; 0B83	  22 01
	popw  hl																	; 0B85	  A9
	popw  x2																	; 0B86	  AB
	popw  x1																	; 0B87	  AA
	popxxx																		; 0B88	  AE
	popb  n																		; 0B89	  AC
	popx  hl																	; 0B8A	  AD
	reti																		; 0B8B	  F9

	unknownCECC																	; 0B8C	  CE CC
	jmp	 hl																		; 0B8E	  F4

lcd_set_trace:
	pushx  hl																	; 0B8F	  A5
	pushw  hl																	; 0B90	  A1
	andb  a, $07																; 0B91	  22 07
	shl	a																		; 0B93	  CE 84
	movx  hl, $00																; 0B95	  CE C5	00
	movw  hl, $2081																; 0B98	  C5 81	20
	and	[hl], $F1																; 0B9B	  CE 25	F1
	orb	[HL],A																	; 0B9E	  CE 2C
	popw hl																		; 0ba0	  a9
	popx  hl																	; 0BA1	  AD
	reti																		; 0BA2	  F9

lcd_get_trace:
	pushx  hl																	; 0BA3	  A5
	pushb  n																	; 0BA4	  A4
	call  set_io_base															; 0BA5	  F2 1D	00
	movb  a, [nn+$81]															; 0BA8	  44 81
	andb  a, $0E																; 0BAA	  22 0E
	shrb a																		; 0bac	  ce 8c
	popb  n																		; 0BAE	  AC
	popx  hl																	; 0BAF	  AD
	reti																		; 0BB0	  F9

test_2001_bit3:
	popb  flags																	; 0BB1	  AF
	pushx  hl																	; 0BB2	  A5
	pushb  n																	; 0BB3	  A4
	call  set_io_base															; 0BB4	  F2 0E	00
	testb  [nn+$01], $08														; 0BB7	  DC 01	08
	popb  n																		; 0BBA	  AC
	popx  hl																	; 0BBB	  AD
	ret																			; 0BBC	  F8

x2_bit2_loop:
	movb  [x2],	$02																; 0BBD	  B7 02
	jdbnz  @00000BBF															; 0BBF	  F5 FF
	movb  [x2],	$00																; 0BC1	  B7 00
	reti																		; 0BC3	  F9

set_io_base:
	movx  hl, $00																; 0BC4	  CE C5	00
	movw  nn, $2000																; 0BC7	  B4 20
	ret																			; 0BC9	  F8

delay_07CB:
	pushw  x1																	; 0BCA	  A2
	movw  x1, $07CB																; 0BCB	  C6 CB	07
	decw  x1																	; 0BCE	  9A
	jnzb	 @00000BCE																; 0BCF	  E7 FE
	popw  x1																	; 0BD1	  AA
	ret																			; 0BD2	  F8

	movb  b, [nn+$52]															; 0BD3	  4C 52
	not	b																		; 0BD5	  CE A1
	movb  a, h																	; 0BD7	  43
	movb  h, b																	; 0BD8	  59
	xorb  a, b																	; 0BD9	  39
	andb  a, b																	; 0BDA	  21
	ret																			; 0BDB	  F8

	movw  x1, $1360																; 0BDC	  C6 60	13
	movb  l, $00																; 0BDF	  B2 00
	ldb	b,[x2+l]																; 0be1	  ce 4b
	ldb	[x1+l],b																; 0be3	  ce 4e
	incb  l																		; 0BE5	  82
	cmpb  l, $60																; 0BE6	  CE BD	60
	jnzb	 @00000BE1																; 0BE9	  E7 F7
	ret																			; 0BEB	  F8

	movw  x1, $1378																; 0BEC	  C6 78	13
	movb  l, $00																; 0BEF	  B2 00
	andb  [nn+$80],	$F7															; 0BF1	  D8 80	F7
	ldb	b,[x2+l]																; 0bf4	  ce 4b
	ldb	[x1+l],b																; 0bf6	  ce 4e
	incb  l																		; 0BF8	  82
	cmpb  l, $3C																; 0BF9	  CE BD	3C
	jnzb	 @00000BF4																; 0BFC	  E7 F7
	ret																			; 0BFE	  F8

	movb  [nn+$27],	$80															; 0BFF	  DD 27	80
	orb	 [nn+$80], $08															; 0C02	  D9 80	08
	testb  [nn+$27], $80														; 0C05	  DC 27	80
	jz	@00000C05																; 0C08	  E6 FC
	andb  [nn+$80],	$F7															; 0C0A	  D8 80	F7
	ret																			; 0C0D	  F8

	decb  a																		; 0C0E	  88
	movb  l, $0C																; 0C0F	  B2 0C
	mul	L,A																		; 0C11	  CE D8
	movb  [$152A], l															; 0C13	  CE D6	2A 15
	cmpb  l, $30																; 0C17	  CE BD	30
	jcb	@00000C1E																; 0C1A	  E4 03
	movb  l, $30																; 0C1C	  B2 30
	movb  [$1529], l															; 0C1E	  CE D6	29 15
	movw  x2, $1590																; 0C22	  C7 90	15
	call  @00000BDC																; 0C25	  F2 B5	FF
	movw  x1, $1528																; 0C28	  C6 28	15
	movw  x2, $152B																; 0C2B	  C7 2B	15
	xorb  a, a																	; 0C2E	  38
	movb  [$152C], a															; 0C2F	  CE D4	2C 15
	movb  a, [nn+$52]															; 0C33	  44 52
	not	a																		; 0C35	  CE A0
	movb  h, a																	; 0C37	  58
	xorb  a, a																	; 0C38	  38
	movb  l, a																	; 0C39	  50
	movb  [x1],	a																; 0C3A	  60
	call  @00000CCC																; 0C3B	  F2 8F	00
	movb  [nn+$27],	$40															; 0C3E	  DD 27	40
	testb  [nn+$27], $40														; 0C41	  DC 27	40
	jz	@00000C41																; 0C44	  E6 FC
	call  init_display0															; 0C46	  F2 34	FC
	call  some_other_label														; 0C49	  F2 D1	FB
	call  @00000BD3																; 0C4C	  F2 85	FF
	movb  b, a																	; 0C4F	  48
	movb  a, [$152C]															; 0C50	  CE D0	2C 15
	orb	 a,	b																	; 0C54	  29
	movb  [$152C], a															; 0C55	  CE D4	2C 15
	xchgb  a, b																	; 0C59	  CC
	orb	 a,	a																	; 0C5A	  28
	jz	@00000C61																; 0C5B	  E6 05
	movb  [x2],	$0D																; 0C5D	  B7 0D
	jmpb @00000C6C																; 0C5F	  F1 0C
	movb  a, h																	; 0C61	  43
	andb  a, b																	; 0C62	  21
	jz	@00000C6F																; 0C63	  E6 0B
	movb  b, [x2]																; 0C65	  4F
	decb  b																		; 0C66	  89
	movb  [x2],	b																; 0C67	  71
	jnzb	 @00000C6F																; 0C68	  E7 06
	movb  [x2],	$05																; 0C6A	  B7 05
	call  @00000C71																; 0C6C	  F2 03	00
	jmpb @00000C3E																; 0C6F	  F1 CE
	testb  a, $05																; 0C71	  96 05
	jz	@00000C8B																; 0C73	  E6 17
	movb  h, $00																; 0C75	  B3 00
	movb  a, $0C																; 0C77	  B0 0C
	div	hl,a																	; 0c79	  ce d9
	movb  a, l																	; 0C7B	  42
	andb  [nn+$80],	$F7															; 0C7C	  D8 80	F7
	movw  x2, $1530																; 0C7F	  C7 30	15
	call  @00000BDC																; 0C82	  F2 58	FF
	call  @00000BFF																; 0C85	  F2 78	FF
	jmp	 @000006DC																; 0C88	  F3 52	FA
	testb  a, $82																; 0C8B	  96 82
	jz	@00000C92																; 0C8D	  E6 04
	jmp	 @000007A9																; 0C8F	  F3 18	FB
	testb  a, $08																; 0C92	  96 08
	jz	@00000CAA																; 0C94	  E6 15
	movb  a, l																	; 0C96	  42
	orb	 a,	a																	; 0C97	  28
	jz	@00000CCB																; 0C98	  E6 32
	subb a,$0c																	; 0c9a	  12 0c
	movb  l, a																	; 0C9C	  50
	orb	 a,	a																	; 0C9D	  28
	movb  a, [x1]																; 0C9E	  46
	jz	@00000CA8																; 0C9F	  E6 08
	movb  b, l																	; 0CA1	  4A
	cmpb  a, b																	; 0CA2	  31
	jnzb	 @00000CA8																; 0CA3	  E7 04
	subb a,$0c																	; 0ca5	  12 0c
	movb  [x1],	a																; 0CA7	  60
	jmpb @00000CC8																; 0CA8	  F1 1F
	testb  a, $10																; 0CAA	  96 10
	jz	@00000CCB																; 0CAC	  E6 1E
	movb  a, l																	; 0CAE	  42
	movb  b, [$152A]															; 0CAF	  CE D1	2A 15
	cmpb  a, b																	; 0CB3	  31
	jz	@00000CCB																; 0CB4	  E6 16
	addb a,$0c																	; 0cb6	  02 0c
	movb  l, a																	; 0CB8	  50
	cmpb  a, b																	; 0CB9	  31
	movb  a, [x1]																; 0CBA	  46
	jz	@00000CC8																; 0CBB	  E6 0C
	addb a,[$1529]																; 0cbd	  05 29	15
	movb  b, l																	; 0CC0	  4A
	cmpb  a, b																	; 0CC1	  31
	movb  a, [x1]																; 0CC2	  46
	jnzb	 @00000CC8																; 0CC3	  E7 04
	addb a,$0c																	; 0cc5	  02 0c
	movb  [x1],	a																; 0CC7	  60
	call  @00000CCC																; 0CC8	  F2 02	00
	ret																			; 0CCB	  F8

	pushw  hl																	; 0CCC	  A1
	pushw  x1																	; 0CCD	  A2
	pushw  x2																	; 0CCE	  A3
	movb  h, l																	; 0CCF	  5A
	movw  x2, $15F0																; 0CD0	  C7 F0	15
	movb  b, $00																; 0CD3	  B1 00
	ldb	a,l																		; 0cd5	  cf 42
	call  @00000BEC																; 0CD7	  F2 13	FF
	movw  x2, $1372																; 0CDA	  C7 72	13
	orb	 a,	a																	; 0CDD	  28
	jz	@00000CE4																; 0CDE	  E6 05
	movb  [x2],	$21																; 0CE0	  B7 21
	jmpb @00000CE6																; 0CE2	  F1 03
	movb  [x2],	$1F																; 0CE4	  B7 1F
	movb  b, a																	; 0CE6	  48
	addb a,[$1529]																; 0ce7	  05 29	15
	movw  x2, $13BA																; 0CEA	  C7 BA	13
	cmpb  a, [$152A]															; 0CED	  35 2A	15
	jz	@00000CF6																; 0CF0	  E6 05
	movb  [x2],	$2C																; 0CF2	  B7 2C
	jmpb @00000CF8																; 0CF4	  F1 03
	movb  [x2],	$2a																; 0cf6	  b7 2a
	movb  a, h																	; 0cf8	  43
	subb a,b																	; 0cf9	  11
	addb a,$01																	; 0cfa	  02 01
	movb  b, $00																; 0cfc	  b1 00
	addw x1,ba																	; 0cfe	  cf 40
	movb  [x1],	$0B																; 0D00	  B6 0B
	orb	 [nn+$80], $08															; 0D02	  D9 80	08
	popw  x2																	; 0D05	  AB
	popw  x1																	; 0D06	  AA
	popw  hl																	; 0D07	  A9
	ret																			; 0D08	  F8

	pushw  x1																	; 0D09	  A2
	pushw  x2																	; 0D0A	  A3
	movw  x2, $1530																; 0D0B	  C7 30	15
	call  @00000BDC																; 0D0E	  F2 CC	FE
	popw  x2																	; 0D11	  AB
	popw  x1																	; 0D12	  AA
	movb  a, [x1]																; 0D13	  46
	incw  x1																	; 0D14	  92
	movb  b, [x1]																; 0D15	  4E
	shrb b																		; 0d16	  ce 8d
	movb  l, b																	; 0D18	  51
	movb  b, $00																; 0D19	  B1 00
	rolc b																		; 0D1B	  CE 91
	movw  x1, $152D																; 0D1D	  C6 2D	15
	movw [x1], ba																; 0D20	  CF D4
	movb  [nn+$27],	$40															; 0D22	  DD 27	40
	testb  [nn+$27], $40														; 0D25	  DC 27	40
	jz	@00000D25																; 0D28	  E6 FC
	movb  [nn+$27],	$40															; 0D2A	  DD 27	40
	movb  a, [nn+$52]															; 0D2D	  44 52
	not	a																		; 0D2F	  CE A0
	movb  h, a																	; 0D31	  58
	pushb  l																	; 0d32	  cf b2
	decb  l																		; 0d34	  8a
	ldb	b,[x2+l]																; 0d35	  ce 4b
	decb  l																		; 0d37	  8a
	ldb	a,[x2+l]																; 0d38	  ce 43
	jnzb	 @00000D40																; 0d3a	  e7 05
	popb  l																		; 0d3c	  cf b6
	pushb  l																	; 0d3e	  cf b2
	shrb b																		; 0d40	  ce 8d
	movb  [$152F], b															; 0D42	  CE D5	2F 15
	movb  b, $00																; 0D46	  B1 00
	rolc b																		; 0D48	  CE 91
	pushw  hl																	; 0D4A	  A1
	pushw  x1																	; 0D4B	  A2
	pushw  x2																	; 0D4C	  A3
	movw  x2, $1650																; 0D4D	  C7 50	16
	ldb	a,l																		; 0d50	  cf 42
	call  @00000BEC																; 0D52	  F2 98	FE
	orb	 [nn+$80], $08															; 0D55	  D9 80	08
	popw  x2																	; 0D58	  AB
	popw  x1																	; 0D59	  AA
	popw  hl																	; 0D5A	  A9
	testb  [nn+$27], $40														; 0D5B	  DC 27	40
	jz	@00000D5B																; 0D5E	  E6 FC
	movb  [nn+$27],	$40															; 0D60	  DD 27	40
	call  init_display0															; 0D63	  F2 17	FB
	call  some_other_label														; 0D66	  F2 B4	FA
	call  @00000BD3																; 0D69	  F2 68	FE
	testb  a, $87																; 0D6C	  96 87
	jnzb	 @00000D84																; 0D6E	  E7 15

	ldw ba,[x1]																	; 0D70	  CF D0
	decw  ba																	; 0D72	  98
	movw [x1], ba																; 0D73	  CF D4
	jz	@00000D84																; 0D75	  E6 0E
	movb  a, [$152F]															; 0D77	  CE D0	2F 15
	decb  a																		; 0D7B	  88
	movb  [$152F], a															; 0D7C	  CE D4	2F 15
	jnzb	 @00000D5B																; 0D80	  E7 DA
	jmpb @00000D34																; 0D82	  F1 B1
	popb  b																		; 0D84	  CF B5
	ret																			; 0D86	  F8

	movw  x1, $0E36																; 0D87	  C6 36	0E
	movw  x2, $0E22																; 0D8A	  C7 22	0E
	call  @00000D09																; 0D8D	  F2 7A	FF
	jz	@00000D99																; 0D90	  E6 08
	testb  a, $82																; 0D92	  96 82
	jz	@00000D99																; 0D94	  E6 04
	jmp	 @000007A9																; 0D96	  F3 11	FA
	andb  [nn+$80],	$F7															; 0D99	  D8 80	F7
	movw  x2, $1530																; 0D9C	  C7 30	15
	call  @00000BDC																; 0D9F	  F2 3B	FE
	call  @00000BFF																; 0DA2	  F2 5B	FE
	ret																			; 0DA5	  F8

reset3:
	movb  flags, $C0															; 0DA6	  9F C0
	orb	 [nn+$71], $04															; 0DA8	  D9 71	04
	movw  x1, $0E3E																; 0DAB	  C6 3E	0E
	movw  x2, $0E38																; 0DAE	  C7 38	0E
	call  @00000D09																; 0DB1	  F2 56	FF
	jz	@00000DC4																; 0DB4	  E6 0F
	testb  a, $82																; 0DB6	  96 82
	jnzb	 @00000DC4																; 0DB8	  E7 0B
	testb  [nn+$53], $02														; 0DBA	  DC 53	02
	jz	reset2																	; 0DBD	  EE EC	F2
	call  @00000DC7																; 0DC0	  F0 06
	jmpb @00000DB4																; 0DC2	  F1 F1
	jmp	 @000007A9																; 0DC4	  F3 E3	F9
	pushb  b																	; 0DC7	  CF B1
	jmp	 @00000D70																; 0DC9	  F3 A5	FF


	.org	0x0DCC
decode_picture:
	movw  x2, $0E40	   # start of encoded picture								; 0DCC	  C7 40	0E
	movw  x1, $1530	   # destination buffer										; 0DCF	  C6 30	15

;--	start decoding the picture in RAM at address $1530

loop_decode:
	movb  a, [x2]	   # read data byte											; 0DD2	  47
	incw  x2		   # increment source index									; 0DD3	  93
	cmpb  a, $F9	   # if	it's F9: "special meaning"							; 0DD4	  32 F9
	jnzb	 @00000DE2	   # jnzb @notF9												; 0DD6	  E7 0B

# fills	X+1	bytes with 00
command_fill_zeroes:
	movb  b, [x2]	   # read next byte	(X)										; 0DD8	  4F
	incw  x2		   # increment source index									; 0DD9	  93
	incb  b		 # X+1,	so we can fill 256 zeroes max							; 0DDA	  81
	xorb  a, a																	; 0DDB	  38

	.org	0x0DDC
zero_fill_loop:
	movb  [x1],	a	   # write one zero											; 0DDC	  60
	incw  x1		   # increment destination index							; 0DDD	  92
	jdbnz  @00000DDC   # jdbnz @@zero_fill_loop									; 0DDE	  F5 FD
	jmpb @00000DF3	   # jnzb loop_next											; 0DE0	  F1 12

notF9:
	cmpb  a, $FB	   # if	it's FB: "special meaning"							; 0DE2	  32 FB
	jnzb	 @00000DF1	   # jnzb @normalbyte										; 0DE4	  E7 0C

   # fills X+1 bytes with byte Y
command_fill_byte:
	movb  a, [x2]	   # read next byte	(Y)										; 0DE6	  47
	incw  x2		   # increment x2											; 0DE7	  93
	movb  b, [x2]	   # read next byte	(X)										; 0DE8	  4F
	incw  x2																	; 0DE9	  93
	incb  b		  #	X+1, so	we can fill	256	bytes max							; 0DEA	  81
fill_loop:
	movb  [x1],	a	   # fill													; 0DEB	  60
	incw  x1																	; 0DEC	  92
	jdbnz  @00000DEB   # jdbnz fill_loop										; 0DED	  F5 FD
	jmpb @00000DF3	   # jnzb loop_next											; 0DEF	  F1 03

normalbyte:
	movb  [x1],	a	   # it	was	a normal byte, we								; 0DF1	  60
	incw  x1		   # just copy it to destination							; 0DF2	  92
					   # buffer!
loop_next:
	cmpw  x2, $1000																; 0DF3	  D7 00	10
	jnzb	 @00000DD2	  #	jnzb	loopdecode											; 0DF6	  E7 DB

#--	the	picture	is now decoded in RAM


	movw  x1, $1920																; 0DF8	  C6 20	19
	movw  x2, $1978																; 0DFB	  C7 78	19
loop_1920h_to_1978h_is_88d_times:
	movb  a, [x1]																; 0DFE	  46
	movb  l, $08																; 0DFF	  B2 08
loop_8_times:
	rolc a																		; 0E01	  CE 90
	rorc b																		; 0E03	  CE 99
	decb  l																		; 0E05	  8A
	jnzb	 @00000E01																; 0E06	  E7 FA

	movb  [x2],	b																; 0E08	  71
	incw  x1																	; 0E09	  92
	incw  x2																	; 0E0A	  93
	cmpw  x1, $1978																; 0E0B	  D6 78	19
	jnzb	 @00000DFE																; 0E0E	  E7 EF
	ret																			; 0E10	  F8
