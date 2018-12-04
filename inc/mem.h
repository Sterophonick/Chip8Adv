extern u8 MinxWRAM[4096];
extern u8 MinxMMIO[256];
extern u8 MinxBIOS[4096];

extern u8 MinxROM[12544];

extern u8 MinxOAM[95];

#define PMR_REG_KEYPAD MinxMMIO[0x52]
extern void GetKeypad();
extern void MergeKeyData();

#define PMR_PRC_SCROLL_Y MinxMMIO[0x85]
#define PMR_PRC_SCROLL_X MinxMMIO[0x86]

#define PMR_IRQ_PRI1		(MinxMMIO[0x20])
#define PMR_IRQ_PRI2		(MinxMMIO[0x21])
#define PMR_IRQ_PRI3		(MinxMMIO[0x22])
#define PMR_IRQ_ENA1		(MinxMMIO[0x23])
#define PMR_IRQ_ENA2		(MinxMMIO[0x24])
#define PMR_IRQ_ENA3		(MinxMMIO[0x25])
#define PMR_IRQ_ENA4		(MinxMMIO[0x26])
#define PMR_IRQ_ACT1		(MinxMMIO[0x27])
#define PMR_IRQ_ACT2		(MinxMMIO[0x28])
#define PMR_IRQ_ACT3		(MinxMMIO[0x29])
#define PMR_IRQ_ACT4		(MinxMMIO[0x2A])

#define PMR_SYS_CTRL1		(MinxMMIO[0x00])
#define PMR_SYS_CTRL2		(MinxMMIO[0x01])
#define PMR_SYS_CTRL3		(MinxMMIO[0x02])

#define PMR_LCD_CTRL (MinxMMIO[0xFE])
#define PMR_LCD_DATA (MinxMMIO[0xFF])

#define PMR_PRC_RATE (MinxMMIO[0x81])

#define PMR_PRC_MAP_LO (MinxMMIO[0x82])
#define PMR_PRC_MAP_MID (MinxMMIO[0x83])
#define PMR_PRC_MAP_HI (MinxMMIO[0x84])

#define PMR_PRC_SPR_LO (MinxMMIO[0x87])
#define PMR_PRC_SPR_MID (MinxMMIO[0x88])
#define PMR_PRC_SPR_HI (MinxMMIO[0x89])

#define PMR_PRC_MODE (MinxMMIO[0x81])