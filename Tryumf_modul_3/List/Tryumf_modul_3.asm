
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _start=R4
	.DEF _licznik_nakretek=R6
	.DEF _nakretka=R8
	.DEF _czekaj_komunikacja=R10
	.DEF _ff=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2018-10-04
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <delay.h>
;//#include <alcd.h>
;#include <string.h>
;#include <stdlib.h>
;#include <math.h>
;
;// Declare your global variables here
;long int sek0,sek1,sek2,sek3,sek4;
;long int ulamki_sekund_0,ulamki_sekund_1;
;int proces[10];
;int skonczony_proces[10];
;long int czas_monterow;
;long int pomocnicza;
;long int stala_czasowa;
;int start;
;int licznik_nakretek;
;//char *dupa1;
;int nakretka;
;//int nakretka_1;
;int licznik_nakretek;
;int czekaj_komunikacja;
;int ff;
;int podaj_nakretke;
;int wcisnalem_pedal;
;int zezwolenie_na_zacisniecie_szczek_od_master;
;int zacisnalem_szczeki;
;int jest_nakretka_przy_dolnym;
;int wlaczam_dodatkowe_wibracje_i_psikanie;
;long int licznik_drgania;
;int wystarczy_zejscia;
;int licznik_widzenia_nakretki;
;int ilosc_prob_wybicia_zakretki_do_gory;
;int wcisniete_zakonczone;
;int zezwolenie_od_master;
;int basia1;
;int pozycja_wiezy;
;int kkk;
;int kkk1;
;int v1;
;int wielkosc_przesuniecia_kamien;
;int kamien;
;int speed_normal;
;int bufor_bledu;
;int zliczylem_male_puchary;
;int licznik_impulsow_male_puchary;
;int tryb_male_puchary;
;int test_zjezdzalni_nakretek;
;int przeslano_informacje_male_puchary;
;int male_puchary_pozwolenie_wyjecia_puchara_monter_3;
;int wieza;
;int jedz_wieza_cykl_znacznik;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0051 {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0052 sek0++;
	LDI  R26,LOW(_sek0)
	LDI  R27,HIGH(_sek0)
	CALL SUBOPT_0x1
; 0000 0053 sek1++;
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x1
; 0000 0054 sek2++;
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x1
; 0000 0055 sek3++;
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x1
; 0000 0056 sek4++;
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	RJMP _0x294
; 0000 0057 }
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 005A {
_timer2_ovf_isr:
	CALL SUBOPT_0x0
; 0000 005B // Place your code here
; 0000 005C ulamki_sekund_0++;
	LDI  R26,LOW(_ulamki_sekund_0)
	LDI  R27,HIGH(_ulamki_sekund_0)
	CALL SUBOPT_0x1
; 0000 005D ulamki_sekund_1++;
	LDI  R26,LOW(_ulamki_sekund_1)
	LDI  R27,HIGH(_ulamki_sekund_1)
_0x294:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 005E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;
;int obroc_o_1_8_stopnia(int speed, int r)
; 0000 0062 {
_obroc_o_1_8_stopnia:
; 0000 0063 PORTE.5 = 0;
;	speed -> Y+2
;	r -> Y+0
	CBI  0x3,5
; 0000 0064 if(ulamki_sekund_0 >= speed)
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_ulamki_sekund_0
	LDS  R27,_ulamki_sekund_0+1
	LDS  R24,_ulamki_sekund_0+2
	LDS  R25,_ulamki_sekund_0+3
	CALL __CWD1
	CALL __CPD21
	BRLT _0x5
; 0000 0065     {
; 0000 0066     PORTE.5 = 1;
	SBI  0x3,5
; 0000 0067     ulamki_sekund_0 = 0;
	LDI  R30,LOW(0)
	STS  _ulamki_sekund_0,R30
	STS  _ulamki_sekund_0+1,R30
	STS  _ulamki_sekund_0+2,R30
	STS  _ulamki_sekund_0+3,R30
; 0000 0068     r++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0069     }
; 0000 006A return r;
_0x5:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R28,4
	RET
; 0000 006B }
;
;
;void drgania()
; 0000 006F {
; 0000 0070 licznik_drgania++;
; 0000 0071 if(licznik_drgania == 6000)  //6666
; 0000 0072     PORTD.4 = 1;
; 0000 0073 if(licznik_drgania == 12000)//26666
; 0000 0074     {
; 0000 0075     PORTD.4 = 0;
; 0000 0076     licznik_drgania = 0;
; 0000 0077     }
; 0000 0078 }
;
;
;
;
;void obsluga_startowa_dozownika_kleju()
; 0000 007E {
; 0000 007F int ss;
; 0000 0080 ss = 0;
;	ss -> R16,R17
; 0000 0081 
; 0000 0082 PORTB.1 = 1;  //zasilanie 220V na dozownik kleju
; 0000 0083 PORTB.4 = 1;  //cisnienie na dozownik kleju
; 0000 0084 
; 0000 0085 
; 0000 0086 while(PINA.6 == 1)
; 0000 0087   {
; 0000 0088   if(PINA.3 == 0)
; 0000 0089     {
; 0000 008A     //lcd_clear();
; 0000 008B     //lcd_gotoxy(0,0);
; 0000 008C     //lcd_puts("1");
; 0000 008D     delay_ms(1000);
; 0000 008E     if(ss == 0)
; 0000 008F         {
; 0000 0090         putchar(0);       //dozownik kleju nie gotowy
; 0000 0091         ss = 1;
; 0000 0092         }
; 0000 0093 
; 0000 0094     }
; 0000 0095   }
; 0000 0096 putchar(1);  //jest wszystko ok z dozownikiem
; 0000 0097 
; 0000 0098 
; 0000 0099   //sle komunikat
; 0000 009A   //dozownik kleju nie gotowy
; 0000 009B   //poprawnie - jak w naczelnym 1 to na pina.3=0
; 0000 009C 
; 0000 009D   //lcd_clear();
; 0000 009E   //lcd_gotoxy(0,0);
; 0000 009F   //lcd_puts("petla");
; 0000 00A0   //delay_ms(1000);
; 0000 00A1   //}
; 0000 00A2   //else
; 0000 00A3   //{
; 0000 00A4   //brak sygnalu z master PINA.3
; 0000 00A5   //delay_ms(1000);
; 0000 00A6   //lcd_clear();
; 0000 00A7   //lcd_gotoxy(0,0);
; 0000 00A8   //lcd_puts("petla222");
; 0000 00A9   //delay_ms(1000);
; 0000 00AA 
; 0000 00AB }
;
;
;
;
;
;
;void komunikacja_bez_rs232()
; 0000 00B3 {
; 0000 00B4 
; 0000 00B5 /*
; 0000 00B6 if(PINA.3 == 0 & poczatek == 0)
; 0000 00B7       {
; 0000 00B8       PORTB.6 = 1;
; 0000 00B9       poczatek = 1;
; 0000 00BA       }
; 0000 00BB 
; 0000 00BC if(PINA.3 == 1 & poczatek == 1)
; 0000 00BD       {
; 0000 00BE       PORTB.6 = 0;
; 0000 00BF       wcisniete_zakonczone = 2;
; 0000 00C0       poczatek = 3;
; 0000 00C1       }
; 0000 00C2 */
; 0000 00C3 
; 0000 00C4 if(tryb_male_puchary == 3)
; 0000 00C5     {
; 0000 00C6     if(PINF.5 == 0)
; 0000 00C7         zezwolenie_od_master = 1;
; 0000 00C8     else
; 0000 00C9         zezwolenie_od_master = 0;
; 0000 00CA 
; 0000 00CB                                              //dodaje do uzwglednienia komunikacje male puchary
; 0000 00CC     if(PINA.3 == 0 & wcisniete_zakonczone == 1 & PINF.7 == 1)
; 0000 00CD        {
; 0000 00CE        PORTB.6 = 1;
; 0000 00CF        wcisniete_zakonczone = 2;
; 0000 00D0        }
; 0000 00D1 
; 0000 00D2                                              //dodaje do uzwglednienia komunikacje male puchary
; 0000 00D3     if(PINA.3 == 1 & wcisniete_zakonczone == 2 & PINF.7 == 1)
; 0000 00D4         PORTB.6 = 0;
; 0000 00D5     }
; 0000 00D6 else
; 0000 00D7     {
; 0000 00D8     if(PINF.5 == 0)
; 0000 00D9         zezwolenie_od_master = 1;
; 0000 00DA     else
; 0000 00DB         zezwolenie_od_master = 0;
; 0000 00DC 
; 0000 00DD 
; 0000 00DE     if(PINA.3 == 0 & wcisniete_zakonczone == 1 & PINF.7 == 1)
; 0000 00DF        {                                                     //zezwolenie na jazde tasmy
; 0000 00E0        PORTB.6 = 1;
; 0000 00E1        wcisniete_zakonczone = 2;
; 0000 00E2        }
; 0000 00E3 
; 0000 00E4        if(PINA.3 == 1 & wcisniete_zakonczone == 2 & PINF.7 == 1)
; 0000 00E5             PORTB.6 = 0;
; 0000 00E6 
; 0000 00E7     }
; 0000 00E8 
; 0000 00E9 
; 0000 00EA 
; 0000 00EB }
;
;
;
;
;
;void obsluga_dozownika_kleju_i_komunikacja()
; 0000 00F2 {
; 0000 00F3 int znak;
; 0000 00F4 
; 0000 00F5 znak = 0;
;	znak -> R16,R17
; 0000 00F6 
; 0000 00F7 if(PINA.3 == 0 & znak == 0 & czekaj_komunikacja == 0)
; 0000 00F8     {
; 0000 00F9     znak = getchar();
; 0000 00FA 
; 0000 00FB     if(PINA.6 == 1 & znak == 1)   //brak kleju
; 0000 00FC        {
; 0000 00FD        //putchar(0);
; 0000 00FE        putchar(1);
; 0000 00FF        }
; 0000 0100 
; 0000 0101     if(PINA.6 == 0 & znak == 1)  //klej jest
; 0000 0102        {
; 0000 0103        putchar(1);
; 0000 0104        }
; 0000 0105 
; 0000 0106     /*
; 0000 0107 
; 0000 0108     if(wcisnalem_pedal == 1 & znak == 4)
; 0000 0109         {
; 0000 010A         putchar(1);
; 0000 010B         }
; 0000 010C 
; 0000 010D     if(wcisnalem_pedal == 0 & znak == 4)
; 0000 010E         {
; 0000 010F         putchar(0);
; 0000 0110         }
; 0000 0111 
; 0000 0112     */
; 0000 0113 
; 0000 0114     if(wcisniete_zakonczone == 1 & znak == 4)
; 0000 0115         {
; 0000 0116         putchar(1);
; 0000 0117         }
; 0000 0118 
; 0000 0119     if(wcisniete_zakonczone == 0 & znak == 4)
; 0000 011A         {
; 0000 011B         putchar(0);
; 0000 011C         }
; 0000 011D 
; 0000 011E     if(zacisnalem_szczeki == 1 & znak == 6)
; 0000 011F         {
; 0000 0120         putchar(1);
; 0000 0121         }
; 0000 0122 
; 0000 0123     if(zacisnalem_szczeki == 0 & znak == 6)
; 0000 0124         {
; 0000 0125         putchar(0);
; 0000 0126         }
; 0000 0127 
; 0000 0128 
; 0000 0129     if(znak == 2)
; 0000 012A        {
; 0000 012B        pomocnicza = getchar();
; 0000 012C        czas_monterow = pomocnicza * stala_czasowa;
; 0000 012D        putchar(3);     //ze przyjalem
; 0000 012E        }
; 0000 012F 
; 0000 0130     if(znak == 3)
; 0000 0131        {
; 0000 0132        podaj_nakretke = getchar();
; 0000 0133        zezwolenie_na_zacisniecie_szczek_od_master = 0;
; 0000 0134        wcisnalem_pedal = 0;
; 0000 0135        zacisnalem_szczeki = 0;
; 0000 0136        wcisniete_zakonczone = 0;
; 0000 0137        putchar(3);     //ze przyjalem
; 0000 0138        }
; 0000 0139 
; 0000 013A     if(znak == 5)
; 0000 013B        {
; 0000 013C        zezwolenie_na_zacisniecie_szczek_od_master = getchar();
; 0000 013D        putchar(3);     //ze przyjalem
; 0000 013E        }
; 0000 013F     }
; 0000 0140 
; 0000 0141 if(znak == 1 | znak == 2 | znak == 3 | znak == 4 | znak == 5  | znak == 6  | czekaj_komunikacja > 0)  //tu jeszcze poprawic
; 0000 0142     czekaj_komunikacja++;
; 0000 0143 if(czekaj_komunikacja == 1000)
; 0000 0144     czekaj_komunikacja = 0;
; 0000 0145 
; 0000 0146 
; 0000 0147 }
;
;
;void kontrola_czujnika_dolnego_nakretek()
; 0000 014B {
; 0000 014C if(PINF.4 == 0)
; 0000 014D     {
; 0000 014E     PORTD.5 = 1;
; 0000 014F     PORTD.6 = 0;  //silownik podaje nakretke monterowi
; 0000 0150     }
; 0000 0151 else
; 0000 0152     {
; 0000 0153     PORTD.5 = 0;
; 0000 0154     }
; 0000 0155 
; 0000 0156 }
;
;
;
;void kontrola_orientatora_nakretek_nowa_zjezdzalnia()
; 0000 015B {
; 0000 015C if(PINA.0 == 0)
; 0000 015D     {
; 0000 015E     //licznik_widzenia_nakretki++;
; 0000 015F     //if(licznik_widzenia_nakretki > 1000)
; 0000 0160     //    {
; 0000 0161         PORTB.0 = 0;
; 0000 0162     //    licznik_widzenia_nakretki = 0;
; 0000 0163     //    }
; 0000 0164     }
; 0000 0165 else
; 0000 0166     {
; 0000 0167     PORTB.0 = 1;
; 0000 0168     //licznik_widzenia_nakretki = 0;
; 0000 0169     }
; 0000 016A }
;
;
;
;void kontrola_orientatora_nakretek()
; 0000 016F {
; 0000 0170 if(PINA.0 == 0 & nakretka < 7)  //to chyba spowoduje ze nie bedzie licznik nakretek sie zapetlal
; 0000 0171         {
; 0000 0172         licznik_nakretek++;
; 0000 0173         }
; 0000 0174 if(licznik_nakretek > 700)
; 0000 0175         {
; 0000 0176         //if(
; 0000 0177             PORTB.0 = 0;  //wylacz orientator bo juz na pewno jedna spadla
; 0000 0178         nakretka++;
; 0000 0179         //nakretka_1++;
; 0000 017A         //lcd_clear();
; 0000 017B         //lcd_gotoxy(0,0);
; 0000 017C         //itoa(licznik_nakretek,dupa1);
; 0000 017D         //lcd_puts(dupa1);
; 0000 017E         //lcd_gotoxy(0,1);
; 0000 017F         //itoa(nakretka_1,dupa1);
; 0000 0180         //lcd_puts(dupa1);
; 0000 0181         licznik_nakretek = 0;
; 0000 0182         }
; 0000 0183 
; 0000 0184 //wyniki pomiarow
; 0000 0185 //1 nakretka - 1643
; 0000 0186 //              1616
; 0000 0187 //              1590
; 0000 0188 //              1493
; 0000 0189 
; 0000 018A }
;
;
;void jedz_wieza_cykl()
; 0000 018E {
_jedz_wieza_cykl:
; 0000 018F 
; 0000 0190 //pomysl - wyysylac w czasie drogi impulsy - to bedzie wielkosc kamienia
; 0000 0191 //pomysl - wyysylac w czasie postoju - to bedzie predkosc
; 0000 0192 //to nawet moge zrobic tu
; 0000 0193 
; 0000 0194 //w prawo
; 0000 0195 
; 0000 0196 
; 0000 0197     switch(pozycja_wiezy)
	LDS  R30,_pozycja_wiezy
	LDS  R31,_pozycja_wiezy+1
; 0000 0198 
; 0000 0199         {
; 0000 019A 
; 0000 019B         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x4A
; 0000 019C 
; 0000 019D                 switch(PINA.0)
	LDI  R30,0
	SBIC 0x19,0
	LDI  R30,1
; 0000 019E                     {
; 0000 019F                     case 0:
	CPI  R30,0
	BRNE _0x4E
; 0000 01A0                     break;
	RJMP _0x4D
; 0000 01A1 
; 0000 01A2                     case 1:
_0x4E:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x4D
; 0000 01A3                         delay_ms(50);   //filtruje ewentualne zaklocenia, aby miec pewnosc ze sygnal nastapil
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x2
; 0000 01A4                         if(PINA.0 == 1)
	SBIS 0x19,0
	RJMP _0x50
; 0000 01A5                             {
; 0000 01A6                             if(PINA.1 == 1)
	SBIS 0x19,1
	RJMP _0x51
; 0000 01A7                                 kamien = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x3
; 0000 01A8                             if(PINA.2 == 1)
_0x51:
	SBIS 0x19,2
	RJMP _0x52
; 0000 01A9                                 kamien = 55;
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL SUBOPT_0x3
; 0000 01AA                             if(PINA.3 == 1)
_0x52:
	SBIS 0x19,3
	RJMP _0x53
; 0000 01AB                                 kamien = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x3
; 0000 01AC                             if(PINA.4 == 1)
_0x53:
	SBIS 0x19,4
	RJMP _0x54
; 0000 01AD                                 kamien = 65;
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CALL SUBOPT_0x3
; 0000 01AE                             if(PINA.5 == 1 & PINA.4 == 0)
_0x54:
	CALL SUBOPT_0x4
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x55
; 0000 01AF                                 kamien = 70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x3
; 0000 01B0                             if(PINA.4 == 1 & PINA.5 == 1)
_0x55:
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	CALL SUBOPT_0x4
	AND  R30,R0
	BREQ _0x56
; 0000 01B1                                 kamien = 75;
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL SUBOPT_0x3
; 0000 01B2 
; 0000 01B3 
; 0000 01B4 
; 0000 01B5                             PORTE.7 = 1; //enable (1 uruchamia)
_0x56:
	SBI  0x3,7
; 0000 01B6                             sek2 = 0;
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
; 0000 01B7                             pozycja_wiezy = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x5
; 0000 01B8                             ulamki_sekund_1 = 0;
	CALL SUBOPT_0x6
; 0000 01B9                             }
; 0000 01BA 
; 0000 01BB                     break;
_0x50:
; 0000 01BC                     }
_0x4D:
; 0000 01BD 
; 0000 01BE 
; 0000 01BF                 /*
; 0000 01C0                 if(PINA.0 == 1)  //sygnal jechania
; 0000 01C1                 {
; 0000 01C2 
; 0000 01C3 
; 0000 01C4                 if(PINA.1 == 1)
; 0000 01C5                     kamien = 50;
; 0000 01C6                 if(PINA.2 == 1)
; 0000 01C7                     kamien = 55;
; 0000 01C8                 if(PINA.3 == 1)
; 0000 01C9                     kamien = 60;
; 0000 01CA                 if(PINA.4 == 1)
; 0000 01CB                     kamien = 65;
; 0000 01CC                 if(PINA.5 == 1 & PINA.4 == 0)
; 0000 01CD                     kamien = 70;
; 0000 01CE                 if(PINA.4 == 1 & PINA.5 == 1)
; 0000 01CF                     kamien = 75;
; 0000 01D0 
; 0000 01D1 
; 0000 01D2 
; 0000 01D3                 PORTE.7 = 1; //enable (1 uruchamia)
; 0000 01D4                 sek2 = 0;
; 0000 01D5                 pozycja_wiezy = 1;
; 0000 01D6                 ulamki_sekund_1 = 0;
; 0000 01D7                 }
; 0000 01D8 
; 0000 01D9                 */
; 0000 01DA 
; 0000 01DB 
; 0000 01DC         break;
	RJMP _0x49
; 0000 01DD 
; 0000 01DE         case 1:
_0x4A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x59
; 0000 01DF 
; 0000 01E0                 if(kkk == kkk1)
	CALL SUBOPT_0x7
	BRNE _0x5A
; 0000 01E1                     kkk1 = obroc_o_1_8_stopnia(v1, kkk);
	LDS  R30,_v1
	LDS  R31,_v1+1
	CALL SUBOPT_0x8
	RJMP _0x287
; 0000 01E2                 else
_0x5A:
; 0000 01E3                     {                    //30 ok    //60 * 16 * 2 ok na szybki zegar
; 0000 01E4                     if(ulamki_sekund_1 > 60 * 8 * 2)
	CALL SUBOPT_0x9
	__CPD2N 0x3C1
	BRLT _0x5C
; 0000 01E5                         {
; 0000 01E6                         v1--;
	LDI  R26,LOW(_v1)
	LDI  R27,HIGH(_v1)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 01E7                         ulamki_sekund_1 = 0;
	CALL SUBOPT_0x6
; 0000 01E8                         }
; 0000 01E9                     kkk1 = kkk;
_0x5C:
	LDS  R30,_kkk
	LDS  R31,_kkk+1
_0x287:
	STS  _kkk1,R30
	STS  _kkk1+1,R31
; 0000 01EA                     }
; 0000 01EB 
; 0000 01EC                  if(v1 == speed_normal) //6 sie pieprzy po 30 min, daje 3 ale zmieniam kroki
	LDS  R30,_speed_normal
	LDS  R31,_speed_normal+1
	CALL SUBOPT_0xA
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x5D
; 0000 01ED                     {
; 0000 01EE                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 01EF                     if(PORTE.4 == 1)   //DIR du¿y silnik
	SBIS 0x3,4
	RJMP _0x5E
; 0000 01F0                         pozycja_wiezy = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x288
; 0000 01F1                     else
_0x5E:
; 0000 01F2                         pozycja_wiezy = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x288:
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R31
; 0000 01F3 
; 0000 01F4                     }
; 0000 01F5 
; 0000 01F6                 if(sek2 > 170)
_0x5D:
	CALL SUBOPT_0xC
	__CPD2N 0xAB
	BRLT _0x60
; 0000 01F7                     {
; 0000 01F8                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 01F9                     kkk1 = 0;
	CALL SUBOPT_0xD
; 0000 01FA                     bufor_bledu = 25;
	CALL SUBOPT_0xE
; 0000 01FB                     v1 = speed_normal;
	LDS  R30,_speed_normal
	LDS  R31,_speed_normal+1
	CALL SUBOPT_0xF
; 0000 01FC                     ulamki_sekund_1 = 0;
	CALL SUBOPT_0x6
; 0000 01FD                     if(PORTE.4 == 1)
	SBIS 0x3,4
	RJMP _0x61
; 0000 01FE                         pozycja_wiezy = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x289
; 0000 01FF                     else
_0x61:
; 0000 0200                         pozycja_wiezy = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x289:
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R31
; 0000 0201 
; 0000 0202                     }
; 0000 0203 
; 0000 0204 
; 0000 0205         break;
_0x60:
	RJMP _0x49
; 0000 0206 
; 0000 0207         //ustalic wielkosc przesuniecia kamien dla bez bufor bledu i z bufor bledu
; 0000 0208 
; 0000 0209         case 2:
_0x59:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x63
; 0000 020A             if(PINE.0 != 0)    //czujnik indukcyjny
	SBIS 0x1,0
	RJMP _0x64
; 0000 020B                 obroc_o_1_8_stopnia(v1 + bufor_bledu, 0);
	CALL SUBOPT_0x10
; 0000 020C             else
	RJMP _0x65
_0x64:
; 0000 020D                 {
; 0000 020E                 if(kamien == 50)
	CALL SUBOPT_0x11
	SBIW R26,50
	BRNE _0x66
; 0000 020F                     wielkosc_przesuniecia_kamien = 770+60;
	CALL SUBOPT_0x12
; 0000 0210                 if(kamien == 55)
_0x66:
	CALL SUBOPT_0x11
	SBIW R26,55
	BRNE _0x67
; 0000 0211                     wielkosc_przesuniecia_kamien = 740+60;
	CALL SUBOPT_0x13
; 0000 0212                 if(kamien == 60)
_0x67:
	CALL SUBOPT_0x11
	SBIW R26,60
	BRNE _0x68
; 0000 0213                     wielkosc_przesuniecia_kamien = 710+60;
	CALL SUBOPT_0x14
; 0000 0214                 if(kamien == 65)
_0x68:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRNE _0x69
; 0000 0215                     wielkosc_przesuniecia_kamien = 680+60;
	CALL SUBOPT_0x15
; 0000 0216                 if(kamien == 70)
_0x69:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRNE _0x6A
; 0000 0217                     wielkosc_przesuniecia_kamien = 650+60;
	CALL SUBOPT_0x16
; 0000 0218                 if(kamien == 75)
_0x6A:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	BRNE _0x6B
; 0000 0219                     wielkosc_przesuniecia_kamien = 620+60;
	CALL SUBOPT_0x17
; 0000 021A 
; 0000 021B                 pozycja_wiezy = 4;
_0x6B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x5
; 0000 021C                 }
_0x65:
; 0000 021D 
; 0000 021E             if(sek2 > 170 & bufor_bledu == 0)
	CALL SUBOPT_0x18
	BREQ _0x6C
; 0000 021F                     {
; 0000 0220                     pozycja_wiezy = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x5
; 0000 0221                     bufor_bledu = 25;
	CALL SUBOPT_0xE
; 0000 0222                     }
; 0000 0223 
; 0000 0224         break;
_0x6C:
	RJMP _0x49
; 0000 0225 
; 0000 0226         case 3:
_0x63:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6D
; 0000 0227 
; 0000 0228             if(PINE.1 != 0)
	SBIS 0x1,1
	RJMP _0x6E
; 0000 0229                 obroc_o_1_8_stopnia(v1+ bufor_bledu, 0);
	CALL SUBOPT_0x10
; 0000 022A             else
	RJMP _0x6F
_0x6E:
; 0000 022B                 {
; 0000 022C                 if(kamien == 50)
	CALL SUBOPT_0x11
	SBIW R26,50
	BRNE _0x70
; 0000 022D                     wielkosc_przesuniecia_kamien = 770+60;
	CALL SUBOPT_0x12
; 0000 022E                 if(kamien == 55)//przesuwamy o 2,5mm
_0x70:
	CALL SUBOPT_0x11
	SBIW R26,55
	BRNE _0x71
; 0000 022F                     wielkosc_przesuniecia_kamien = 740+60;
	CALL SUBOPT_0x13
; 0000 0230                 if(kamien == 60)
_0x71:
	CALL SUBOPT_0x11
	SBIW R26,60
	BRNE _0x72
; 0000 0231                     wielkosc_przesuniecia_kamien = 710+60;
	CALL SUBOPT_0x14
; 0000 0232                 if(kamien == 65)
_0x72:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRNE _0x73
; 0000 0233                     wielkosc_przesuniecia_kamien = 680+60;
	CALL SUBOPT_0x15
; 0000 0234                 if(kamien == 70)
_0x73:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRNE _0x74
; 0000 0235                     wielkosc_przesuniecia_kamien = 650+60;
	CALL SUBOPT_0x16
; 0000 0236                 if(kamien == 75)
_0x74:
	CALL SUBOPT_0x11
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	BRNE _0x75
; 0000 0237                     wielkosc_przesuniecia_kamien = 620+60; //tu ma byc 8mm + 25/2mm = 20,5    18mm
	CALL SUBOPT_0x17
; 0000 0238 
; 0000 0239                 pozycja_wiezy = 4;
_0x75:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x5
; 0000 023A                 }
_0x6F:
; 0000 023B 
; 0000 023C             if(sek2 > 170 & bufor_bledu == 0)
	CALL SUBOPT_0x18
	BREQ _0x76
; 0000 023D                     {
; 0000 023E                     pozycja_wiezy = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x5
; 0000 023F                     bufor_bledu = 25;
	CALL SUBOPT_0xE
; 0000 0240                     }
; 0000 0241         break;
_0x76:
	RJMP _0x49
; 0000 0242 
; 0000 0243 
; 0000 0244         case 4:
_0x6D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x77
; 0000 0245                 if(kkk < 2)
	CALL SUBOPT_0x19
	BRGE _0x78
; 0000 0246                     kkk = obroc_o_1_8_stopnia(v1+ bufor_bledu, kkk);  //jedziemy jeszcze kawalek z pelna pyta
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 0247                 else
	RJMP _0x79
_0x78:
; 0000 0248                     {
; 0000 0249                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 024A                     pozycja_wiezy = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x5
; 0000 024B                     }
_0x79:
; 0000 024C 
; 0000 024D         break;
	RJMP _0x49
; 0000 024E 
; 0000 024F 
; 0000 0250         case 5:
_0x77:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x7A
; 0000 0251                 if(kkk < 2)
	CALL SUBOPT_0x19
	BRGE _0x7B
; 0000 0252                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 0253                 else
	RJMP _0x7C
_0x7B:
; 0000 0254                     {
; 0000 0255                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 0256                     pozycja_wiezy = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x5
; 0000 0257                     }
_0x7C:
; 0000 0258 
; 0000 0259         break;
	RJMP _0x49
; 0000 025A 
; 0000 025B         case 6:
_0x7A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x7D
; 0000 025C                 if(kkk < 2)
	CALL SUBOPT_0x19
	BRGE _0x7E
; 0000 025D                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 025E                 else
	RJMP _0x7F
_0x7E:
; 0000 025F                     {
; 0000 0260                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 0261                     pozycja_wiezy = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x5
; 0000 0262                     }
_0x7F:
; 0000 0263 
; 0000 0264         break;
	RJMP _0x49
; 0000 0265 
; 0000 0266         case 7:
_0x7D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x80
; 0000 0267                 if(kkk < 2)
	CALL SUBOPT_0x19
	BRGE _0x81
; 0000 0268                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 0269                 else
	RJMP _0x82
_0x81:
; 0000 026A                     {
; 0000 026B                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 026C                     pozycja_wiezy = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x5
; 0000 026D                     }
_0x82:
; 0000 026E 
; 0000 026F         break;
	RJMP _0x49
; 0000 0270 
; 0000 0271 
; 0000 0272 
; 0000 0273         case 8:
_0x80:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x83
; 0000 0274                 if(kkk < wielkosc_przesuniecia_kamien)
	LDS  R30,_wielkosc_przesuniecia_kamien
	LDS  R31,_wielkosc_przesuniecia_kamien+1
	LDS  R26,_kkk
	LDS  R27,_kkk+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x84
; 0000 0275                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
; 0000 0276                 else
	RJMP _0x85
_0x84:
; 0000 0277                     {
; 0000 0278                     pozycja_wiezy = 10;//9
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x5
; 0000 0279                     ulamki_sekund_1 = 0;
	CALL SUBOPT_0x6
; 0000 027A                     v1 = v1 + 6;
	LDS  R30,_v1
	LDS  R31,_v1+1
	ADIW R30,6
	CALL SUBOPT_0xF
; 0000 027B                     kkk = 0;
	CALL SUBOPT_0xB
; 0000 027C                     kkk1 = 0;
	CALL SUBOPT_0xD
; 0000 027D                     }
_0x85:
; 0000 027E 
; 0000 027F         break;
	RJMP _0x49
; 0000 0280 
; 0000 0281         case 9:
_0x83:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x86
; 0000 0282 
; 0000 0283 
; 0000 0284                   if(kkk == kkk1)
	CALL SUBOPT_0x7
	BRNE _0x87
; 0000 0285                         kkk1 = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
	CALL SUBOPT_0x1A
	RJMP _0x28A
; 0000 0286                   else
_0x87:
; 0000 0287                         {
; 0000 0288                         if(ulamki_sekund_1 > 60 * 6 * 2)
	CALL SUBOPT_0x9
	__CPD2N 0x2D1
	BRLT _0x89
; 0000 0289                             {
; 0000 028A                             v1++;
	LDI  R26,LOW(_v1)
	LDI  R27,HIGH(_v1)
	CALL SUBOPT_0x1C
; 0000 028B                             ulamki_sekund_1 = 0;
	CALL SUBOPT_0x6
; 0000 028C                             }
; 0000 028D                         kkk1 = kkk;
_0x89:
	LDS  R30,_kkk
	LDS  R31,_kkk+1
_0x28A:
	STS  _kkk1,R30
	STS  _kkk1+1,R31
; 0000 028E                         }
; 0000 028F                   if(v1 == 40)
	CALL SUBOPT_0xA
	SBIW R26,40
	BRNE _0x8A
; 0000 0290                         {
; 0000 0291                         kkk = 0;
	CALL SUBOPT_0xB
; 0000 0292                         pozycja_wiezy = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x5
; 0000 0293                         }
; 0000 0294 
; 0000 0295         break;
_0x8A:
	RJMP _0x49
; 0000 0296 
; 0000 0297         case 10:
_0x86:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x49
; 0000 0298 
; 0000 0299                 PORTE.7 = 0;  //koniec enable
	CBI  0x3,7
; 0000 029A                 PORTC.1 = 0;  //silownik dociskowy os pozioma
	CBI  0x15,1
; 0000 029B                 kkk = 0;
	CALL SUBOPT_0xB
; 0000 029C                 kkk1 = 0;
	CALL SUBOPT_0xD
; 0000 029D                 v1 = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0xF
; 0000 029E                 bufor_bledu = 0;
	LDI  R30,LOW(0)
	STS  _bufor_bledu,R30
	STS  _bufor_bledu+1,R30
; 0000 029F                 if(PORTE.4 == 1)
	SBIS 0x3,4
	RJMP _0x90
; 0000 02A0                     PORTE.4 = 0;  //zmieniamy dir
	CBI  0x3,4
; 0000 02A1                 else
	RJMP _0x93
_0x90:
; 0000 02A2                     PORTE.4 = 1;
	SBI  0x3,4
; 0000 02A3 
; 0000 02A4                 pozycja_wiezy = 11;
_0x93:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x5
; 0000 02A5                 jedz_wieza_cykl_znacznik = 0;
	LDI  R30,LOW(0)
	STS  _jedz_wieza_cykl_znacznik,R30
	STS  _jedz_wieza_cykl_znacznik+1,R30
; 0000 02A6 
; 0000 02A7                 PORTA.7 = 1;
	SBI  0x1B,7
; 0000 02A8                 while(PINA.0 == 1)
_0x98:
	SBIS 0x19,0
	RJMP _0x9A
; 0000 02A9                     PORTA.7 = 1;  //sygnal ze dojechalem
	SBI  0x1B,7
	RJMP _0x98
_0x9A:
; 0000 02AA pozycja_wiezy = 0;
	LDI  R30,LOW(0)
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R30
; 0000 02AB                 delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x2
; 0000 02AC                 PORTA.7 = 0;
	CBI  0x1B,7
; 0000 02AD 
; 0000 02AE 
; 0000 02AF 
; 0000 02B0 
; 0000 02B1         break;
; 0000 02B2         }
_0x49:
; 0000 02B3 
; 0000 02B4 
; 0000 02B5 
; 0000 02B6 
; 0000 02B7 
; 0000 02B8 
; 0000 02B9 
; 0000 02BA }
	RET
;
;
;
;
;
;
;
;int proces_0()
; 0000 02C3 {
; 0000 02C4 int wynik;
; 0000 02C5 wynik = 0;
;	wynik -> R16,R17
; 0000 02C6 
; 0000 02C7 switch(proces[0])
; 0000 02C8     {
; 0000 02C9     case 0:
; 0000 02CA         if(test_zjezdzalni_nakretek == 0)
; 0000 02CB             proces[0] = 1;
; 0000 02CC         else
; 0000 02CD             proces[0] = 111;
; 0000 02CE         sek0 = 0;
; 0000 02CF     break;
; 0000 02D0 
; 0000 02D1 
; 0000 02D2     case 111:
; 0000 02D3             if(PINA.7 == 1)
; 0000 02D4                 {
; 0000 02D5                 ilosc_prob_wybicia_zakretki_do_gory = 0;
; 0000 02D6                 PORTD.5 = 1;  //silownik kolejkujacy nakretki otworz
; 0000 02D7                 PORTB.3 = 1;  //psikanie
; 0000 02D8                 PORTD.4 = 1;  //zeby na pewno byl wysuniety wstepnie ten co robi drgania
; 0000 02D9                 sek0 = 0;
; 0000 02DA                 proces[0] = 2;
; 0000 02DB                 }
; 0000 02DC     break;
; 0000 02DD 
; 0000 02DE     case 1:                          //zeby wrocila karetka nakretek
; 0000 02DF             if(podaj_nakretke == 1 & sek0 > 40)
; 0000 02E0                 {
; 0000 02E1                 ilosc_prob_wybicia_zakretki_do_gory = 0;
; 0000 02E2                 PORTD.5 = 1;  //silownik kolejkujacy nakretki otworz
; 0000 02E3                 PORTB.3 = 1;  //psikanie
; 0000 02E4                 PORTD.4 = 1;  //zeby na pewno byl wysuniety wstepnie ten co robi drgania
; 0000 02E5                 sek0 = 0;
; 0000 02E6                 proces[0] = 2;
; 0000 02E7                 }
; 0000 02E8     break;
; 0000 02E9 
; 0000 02EA 
; 0000 02EB     case 2:
; 0000 02EC                 if(sek0>15)
; 0000 02ED                     {
; 0000 02EE                     sek0 = 0;
; 0000 02EF                     proces[0] = 3;
; 0000 02F0                     }
; 0000 02F1     break;
; 0000 02F2 
; 0000 02F3     case 3:
; 0000 02F4             drgania();
; 0000 02F5 
; 0000 02F6             if(sek0 > 5 & PORTB.3 == 1)
; 0000 02F7                  PORTB.3 = 0; //psikanie
; 0000 02F8 
; 0000 02F9             if(sek0 > 20)  //silownik kolejkujacy nakretki w dol  //35
; 0000 02FA                 {
; 0000 02FB                 PORTD.5 = 0;  //zamknij
; 0000 02FC                 sek0 = 0;
; 0000 02FD                 proces[0] = 4;
; 0000 02FE                 }
; 0000 02FF     break;
; 0000 0300 
; 0000 0301 
; 0000 0302     case 4:
; 0000 0303 
; 0000 0304             if(PINA.4 == 0)
; 0000 0305                 wystarczy_zejscia = 1;
; 0000 0306             drgania();
; 0000 0307             if(sek0 > 25)
; 0000 0308                 {
; 0000 0309                 sek0 = 0;
; 0000 030A                 proces[0] = 5;
; 0000 030B                 if(PINA.4 == 0)
; 0000 030C                     wystarczy_zejscia = 1;
; 0000 030D                 }
; 0000 030E 
; 0000 030F     break;
; 0000 0310 
; 0000 0311 
; 0000 0312     case 5:
; 0000 0313             if(PINA.4 == 0 | wystarczy_zejscia == 1)   //zszedl na sam dol, czyli ok
; 0000 0314                 {
; 0000 0315                 //proces[0] = 8;
; 0000 0316                 //PORTD.2 = 0; //przysun igle z klejem nie dawaj igly z klejem
; 0000 0317                 PORTD.4 = 0;  //zeby na pewno byl schowany ten co robi drgania
; 0000 0318                 wystarczy_zejscia = 0;
; 0000 0319                 proces[0] = 10;
; 0000 031A                 sek0 = 50;
; 0000 031B                 }
; 0000 031C             else
; 0000 031D                 {
; 0000 031E                 wystarczy_zejscia = 0;
; 0000 031F                 ilosc_prob_wybicia_zakretki_do_gory++;
; 0000 0320                 if(ilosc_prob_wybicia_zakretki_do_gory > 3)
; 0000 0321                     {
; 0000 0322                     proces[0] = 10;
; 0000 0323                     ilosc_prob_wybicia_zakretki_do_gory = 0;
; 0000 0324                     PORTD.4 = 0;  //zeby na pewno byl schowany ten co robi drgania
; 0000 0325                     }
; 0000 0326                 else
; 0000 0327                     {
; 0000 0328                     PORTD.5 = 1;  //do gory silownik otworz
; 0000 0329                     PORTB.3 = 1;   //psikanie
; 0000 032A                     proces[0] = 6;
; 0000 032B                     }
; 0000 032C                 sek0 = 0;
; 0000 032D                 }
; 0000 032E 
; 0000 032F     break;
; 0000 0330 
; 0000 0331     case 6:
; 0000 0332             drgania();
; 0000 0333 
; 0000 0334             if(sek0 > 130 & PORTB.3 == 1)
; 0000 0335                  PORTB.3 = 0; //psikanie
; 0000 0336 
; 0000 0337             if(sek0 > 150)  //czekaj na pukniecie
; 0000 0338                {
; 0000 0339                PORTD.5 = 0;  //na dol
; 0000 033A                sek0 = 0;
; 0000 033B                proces[0] = 7;
; 0000 033C                }
; 0000 033D     break;
; 0000 033E 
; 0000 033F     case 7:
; 0000 0340             drgania();
; 0000 0341             if(PINA.4 == 0)
; 0000 0342                 wystarczy_zejscia = 1;
; 0000 0343             if(sek0 > 80)
; 0000 0344                {
; 0000 0345                proces[0] = 5;
; 0000 0346                }
; 0000 0347     break;
; 0000 0348 
; 0000 0349     case 8:
; 0000 034A             if(sek0 > 20)
; 0000 034B                 {
; 0000 034C                 //PORTB.7 = 1; //nie lej kleju na razie
; 0000 034D                 sek0 = 0;
; 0000 034E                 proces[0] = 9;
; 0000 034F                 }
; 0000 0350 
; 0000 0351     break;
; 0000 0352 
; 0000 0353     case 9:
; 0000 0354             if(sek0 > 50)
; 0000 0355                 {
; 0000 0356                 PORTB.7 = 0;//przestan lac klej
; 0000 0357                 PORTD.2 = 1; //cofnij igle z klejem
; 0000 0358                 sek0 = 0;
; 0000 0359                 proces[0] = 10;
; 0000 035A                 }
; 0000 035B 
; 0000 035C     break;
; 0000 035D 
; 0000 035E 
; 0000 035F 
; 0000 0360     case 10:
; 0000 0361             if(sek0 > 50)
; 0000 0362                 {
; 0000 0363                 PORTD.6 = 1; //silownik podaje nakretke monterowi
; 0000 0364                 sek0 = 0;
; 0000 0365                  if(test_zjezdzalni_nakretek == 0)
; 0000 0366                     proces[0] = 11;
; 0000 0367                  else
; 0000 0368                     proces[0] = 1111;
; 0000 0369                 sek0 = 0;
; 0000 036A                 }
; 0000 036B 
; 0000 036C     break;
; 0000 036D     case 11:
; 0000 036E             if(sek0 > 50)
; 0000 036F                 {
; 0000 0370                 kontrola_czujnika_dolnego_nakretek();
; 0000 0371 
; 0000 0372                 if(wcisnalem_pedal == 1)
; 0000 0373                    {
; 0000 0374                    PORTD.6 = 0;  //cofnij podajnik nakretek
; 0000 0375                    sek0 = 0;
; 0000 0376                    proces[0] = 12;
; 0000 0377                    }
; 0000 0378                 else
; 0000 0379                    sek0 = 51;
; 0000 037A 
; 0000 037B                 }
; 0000 037C     break;
; 0000 037D     case 1111:
; 0000 037E             if(sek0 > 50)
; 0000 037F                 {
; 0000 0380                 if(PINA.7 == 1)
; 0000 0381                    {
; 0000 0382                    PORTD.5 = 0;   //zamknij przegrode nakretek
; 0000 0383                    PORTD.6 = 0;  //cofnij podajnik nakretek
; 0000 0384                    sek0 = 0;
; 0000 0385                    }
; 0000 0386                 }
; 0000 0387             kontrola_czujnika_dolnego_nakretek();
; 0000 0388             if(PORTD.6 == 0 & sek0 > 50 & PORTD.5 == 0)
; 0000 0389                     {
; 0000 038A                     proces[0] = 12;
; 0000 038B                     }
; 0000 038C 
; 0000 038D     break;
; 0000 038E 
; 0000 038F 
; 0000 0390 
; 0000 0391 
; 0000 0392 
; 0000 0393 
; 0000 0394 
; 0000 0395     case 12:
; 0000 0396             if(sek0 > 1)
; 0000 0397                proces[0] = 13;
; 0000 0398     break;
; 0000 0399 
; 0000 039A     case 13:
; 0000 039B 
; 0000 039C                 sek0 = 0;
; 0000 039D                 proces[0] = 0;
; 0000 039E                 wynik = 1;
; 0000 039F                 podaj_nakretke = 0;
; 0000 03A0                 wcisnalem_pedal = 0;
; 0000 03A1 
; 0000 03A2     break;
; 0000 03A3     }
; 0000 03A4 
; 0000 03A5 
; 0000 03A6 
; 0000 03A7 
; 0000 03A8 return wynik;
; 0000 03A9 }
;
;
;int proces_1()
; 0000 03AD {
; 0000 03AE int wynik;
; 0000 03AF wynik = 0;
;	wynik -> R16,R17
; 0000 03B0 
; 0000 03B1 switch(proces[1])
; 0000 03B2     {
; 0000 03B3     case 0:
; 0000 03B4         if(podaj_nakretke == 1)
; 0000 03B5             proces[1] = 1;
; 0000 03B6     break;
; 0000 03B7 
; 0000 03B8     case 1:
; 0000 03B9             if(PINA.2 == 0 & wcisniete_zakonczone == 2) //widzi kamien
; 0000 03BA             {
; 0000 03BB             sek1 = 0;
; 0000 03BC             proces[1] = 2;
; 0000 03BD             }
; 0000 03BE     break;
; 0000 03BF 
; 0000 03C0     case 2:
; 0000 03C1             if(PINA.2 == 1 & zezwolenie_od_master == 1) //przejechal kamien na pewno
; 0000 03C2             {
; 0000 03C3             sek1 = 0;
; 0000 03C4             proces[1] = 3;
; 0000 03C5 
; 0000 03C6             }
; 0000 03C7     break;
; 0000 03C8 
; 0000 03C9     case 3:
; 0000 03CA 
; 0000 03CB            sek1 = 0;
; 0000 03CC            proces[1] = 4;
; 0000 03CD 
; 0000 03CE     break;
; 0000 03CF 
; 0000 03D0     case 4:
; 0000 03D1             if(sek1 > 0) ////////////////////////dam tu wiecej 20, 28.11.2017
; 0000 03D2                 {
; 0000 03D3                 PORTD.7 = 1;
; 0000 03D4                 sek1 = 0;
; 0000 03D5                 proces[1] = 5;
; 0000 03D6                 }
; 0000 03D7 
; 0000 03D8     break;
; 0000 03D9 
; 0000 03DA     case 5:
; 0000 03DB             if(sek1 > 100)
; 0000 03DC                 {
; 0000 03DD                 if(PINA.7 == 1 & proces[0] == 11) //monter nacisnal pedal
; 0000 03DE                     {
; 0000 03DF                     PORTD.3 = 1;  //zluzuj chwyt grzybka
; 0000 03E0                     PORTD.7 = 0; //pusc kamien
; 0000 03E1                     wcisnalem_pedal = 1;
; 0000 03E2                     sek1 = 0;
; 0000 03E3                     proces[1] = 6;
; 0000 03E4                     }
; 0000 03E5                 else
; 0000 03E6                     sek1 = 101;
; 0000 03E7                 }
; 0000 03E8 
; 0000 03E9     break;
; 0000 03EA 
; 0000 03EB 
; 0000 03EC //teraz jest dane ze natychmiast ruszy, moge dac alternatywe ze po chwili zmieniajac case 5 i case 6
; 0000 03ED 
; 0000 03EE 
; 0000 03EF     case 6:
; 0000 03F0             if(sek1 > 1)      //50 31.07.2017
; 0000 03F1                 {
; 0000 03F2                 sek1 = 0;
; 0000 03F3                 proces[1] = 7;
; 0000 03F4                 }
; 0000 03F5 
; 0000 03F6     break;
; 0000 03F7 
; 0000 03F8 
; 0000 03F9 
; 0000 03FA     case 7:
; 0000 03FB             if(sek1 > 30) //20 31.07.2017
; 0000 03FC                {
; 0000 03FD                PORTD.3 = 0;  //zacisnij z powrotem szczeki
; 0000 03FE                proces[1] = 8;
; 0000 03FF                }
; 0000 0400     break;
; 0000 0401 
; 0000 0402     case 8:
; 0000 0403 
; 0000 0404                 sek1 = 0;
; 0000 0405                 proces[1] = 0;
; 0000 0406                 wynik = 1;
; 0000 0407 
; 0000 0408 
; 0000 0409     break;
; 0000 040A     }
; 0000 040B 
; 0000 040C 
; 0000 040D 
; 0000 040E 
; 0000 040F return wynik;
; 0000 0410 }
;
;
;
;int proces_3()
; 0000 0415 {
; 0000 0416 int wynik;
; 0000 0417 wynik = 0;
;	wynik -> R16,R17
; 0000 0418 
; 0000 0419 switch(proces[3])
; 0000 041A     {
; 0000 041B     case 0: //pedal monter 2   //
; 0000 041C         if(PINE.2 == 1 & zezwolenie_od_master == 1)
; 0000 041D             {
; 0000 041E             PORTC.5 = 1;     //wysun silownik otwierajacy wieze
; 0000 041F             PORTC.6 = 0;     //wysun silownik otwierajacy wieze
; 0000 0420             if(wieza == 0)
; 0000 0421                 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
; 0000 0422             else
; 0000 0423                 {
; 0000 0424                 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
; 0000 0425                 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
; 0000 0426                 }
; 0000 0427             sek3 = 0;
; 0000 0428             proces[3] = 1;
; 0000 0429             }
; 0000 042A     break;
; 0000 042B 
; 0000 042C     case 1:
; 0000 042D 
; 0000 042E             if(sek3 > 20)
; 0000 042F                 {
; 0000 0430                 wcisniete_zakonczone = 1;
; 0000 0431                 PORTC.5 = 0;  //schowaj silownik otwierajacy wieze
; 0000 0432                 PORTC.6 = 1;
; 0000 0433                 sek3 = 0;
; 0000 0434                 proces[3] = 2;
; 0000 0435                 }
; 0000 0436 
; 0000 0437     break;
; 0000 0438 
; 0000 0439     case 2:
; 0000 043A             if(PINE.2 == 0)
; 0000 043B             {
; 0000 043C             if(wieza == 0)
; 0000 043D                 {
; 0000 043E                 PORTC.2 = 1;  //stan zamkniecia wieza 1
; 0000 043F                 //wieza = 1;
; 0000 0440                 }
; 0000 0441             else
; 0000 0442                 {
; 0000 0443                 PORTC.3 = 0;  //stan zamkniecia wejsciowy wie¿a 2
; 0000 0444                 PORTC.7 = 1;  //stan zamkniecia wejsciowy wie¿a 2
; 0000 0445                 //wieza = 0;
; 0000 0446                 }
; 0000 0447             sek3 = 0;
; 0000 0448             proces[3] = 3;
; 0000 0449             }
; 0000 044A     break;
; 0000 044B 
; 0000 044C     case 3:
; 0000 044D             if(sek3 > 2)
; 0000 044E             {
; 0000 044F             sek3 = 0;
; 0000 0450             proces[3] = 4;
; 0000 0451             }
; 0000 0452     break;
; 0000 0453 
; 0000 0454     case 4:
; 0000 0455             if(PINE.2 == 1)
; 0000 0456             {
; 0000 0457             sek3 = 0;
; 0000 0458             proces[3] = 5;
; 0000 0459             }
; 0000 045A     break;
; 0000 045B 
; 0000 045C 
; 0000 045D     case 5:
; 0000 045E                //pozycja_wiezy != 11
; 0000 045F             if(male_puchary_pozwolenie_wyjecia_puchara_monter_3 == 0)
; 0000 0460             {
; 0000 0461 
; 0000 0462                 //jedz_wieza_cykl();
; 0000 0463                 if(wieza == 0)
; 0000 0464                     wieza = 1;
; 0000 0465                 else
; 0000 0466                     wieza = 0;
; 0000 0467                 jedz_wieza_cykl_znacznik = 1;
; 0000 0468                 male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 1;
; 0000 0469                 proces[3] = 6;
; 0000 046A             }
; 0000 046B             //else
; 0000 046C             //{
; 0000 046D             //sek3 = 0;
; 0000 046E             //proces[3] = 0;
; 0000 046F             //pozycja_wiezy = 0;
; 0000 0470             //male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 1;
; 0000 0471             //wynik = 1;
; 0000 0472             //}
; 0000 0473     break;
; 0000 0474 
; 0000 0475     case 6:
; 0000 0476 
; 0000 0477              if(PINE.2 == 0)
; 0000 0478              {
; 0000 0479              skonczony_proces[3] = 0;
; 0000 047A              sek3 = 0;
; 0000 047B              proces[3] = 0;
; 0000 047C              pozycja_wiezy = 0;
; 0000 047D              wynik = 0;
; 0000 047E              }
; 0000 047F     break;
; 0000 0480 
; 0000 0481 
; 0000 0482 
; 0000 0483 
; 0000 0484 
; 0000 0485 
; 0000 0486 }
; 0000 0487 
; 0000 0488 
; 0000 0489 
; 0000 048A 
; 0000 048B return wynik;
; 0000 048C }
;
;
;int proces_4()
; 0000 0490 {
; 0000 0491 int wynik;
; 0000 0492 wynik = 0;
;	wynik -> R16,R17
; 0000 0493 
; 0000 0494 switch(proces[4])
; 0000 0495     {
; 0000 0496 
; 0000 0497    case 0:     //monter 3 nacisnal pedal
; 0000 0498             if(PINA.7 == 1 & male_puchary_pozwolenie_wyjecia_puchara_monter_3 == 1)
; 0000 0499             {
; 0000 049A              if(PORTC.0 == 0) //silownik obrotowy o osi pionowej //monter wyciaga puchar
; 0000 049B                 PORTC.0 = 1;
; 0000 049C              else
; 0000 049D                 PORTC.0 = 0;
; 0000 049E             PORTC.1 = 1;  //silownik dociskowy os pozioma
; 0000 049F 
; 0000 04A0             if(wieza == 1)
; 0000 04A1                 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
; 0000 04A2             else
; 0000 04A3                 {
; 0000 04A4                 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
; 0000 04A5                 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
; 0000 04A6                 }
; 0000 04A7 
; 0000 04A8             sek4 = 0;
; 0000 04A9             proces[4] = 1;
; 0000 04AA             }
; 0000 04AB 
; 0000 04AC     break;
; 0000 04AD 
; 0000 04AE     case 1:
; 0000 04AF           if(sek4 > 60)
; 0000 04B0             {
; 0000 04B1             male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 0;
; 0000 04B2             wcisnalem_pedal = 1;
; 0000 04B3             proces[4] = 0;
; 0000 04B4             wynik = 1;
; 0000 04B5             }
; 0000 04B6     break;
; 0000 04B7 
; 0000 04B8 
; 0000 04B9     }
; 0000 04BA 
; 0000 04BB 
; 0000 04BC 
; 0000 04BD 
; 0000 04BE return wynik;
; 0000 04BF }
;
;
;
;
;
;
;
;void procesy()
; 0000 04C8 {
; 0000 04C9 if(skonczony_proces[0] == 0)
; 0000 04CA   skonczony_proces[0] = proces_0();
; 0000 04CB 
; 0000 04CC if(skonczony_proces[1] == 0 & tryb_male_puchary == 3)
; 0000 04CD   skonczony_proces[1] = proces_1();
; 0000 04CE 
; 0000 04CF if(skonczony_proces[3] == 0 & tryb_male_puchary == 2 & jedz_wieza_cykl_znacznik == 0)
; 0000 04D0   skonczony_proces[3] = proces_3();
; 0000 04D1 
; 0000 04D2 if(skonczony_proces[4] == 0 & tryb_male_puchary == 2)
; 0000 04D3   skonczony_proces[4] = proces_4();
; 0000 04D4 
; 0000 04D5 }
;
;void zerowanie_procesow()
; 0000 04D8 {
; 0000 04D9 if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & test_zjezdzalni_nakretek == 0 & tryb_male_puchary == 3)
; 0000 04DA     {
; 0000 04DB     skonczony_proces[0] = 0;
; 0000 04DC     skonczony_proces[1] = 0;
; 0000 04DD     wcisniete_zakonczone = 1;
; 0000 04DE     podaj_nakretke = 1;
; 0000 04DF     }
; 0000 04E0 
; 0000 04E1 
; 0000 04E2 if(skonczony_proces[0] == 1 & test_zjezdzalni_nakretek == 1)
; 0000 04E3     {
; 0000 04E4     skonczony_proces[0] = 0;
; 0000 04E5     skonczony_proces[1] = 0;
; 0000 04E6     wcisniete_zakonczone = 1;
; 0000 04E7     podaj_nakretke = 1;
; 0000 04E8     }
; 0000 04E9 
; 0000 04EA 
; 0000 04EB                             //& skonczony_proces[3] == 1
; 0000 04EC if(skonczony_proces[0] == 1  & skonczony_proces[4] == 1 & test_zjezdzalni_nakretek == 0 & tryb_male_puchary == 2)
; 0000 04ED     {
; 0000 04EE     skonczony_proces[0] = 0;                  //tryb male puchary
; 0000 04EF     //skonczony_proces[3] = 0;
; 0000 04F0     skonczony_proces[4] = 0;
; 0000 04F1     podaj_nakretke = 1;
; 0000 04F2     }
; 0000 04F3 
; 0000 04F4 
; 0000 04F5 
; 0000 04F6 
; 0000 04F7 
; 0000 04F8 }
;
;
;void wypozucjonuj_wieze_wolno()
; 0000 04FC {
_wypozucjonuj_wieze_wolno:
; 0000 04FD 
; 0000 04FE PORTE.7 = 1;  //enable na silnik krok
	SBI  0x3,7
; 0000 04FF 
; 0000 0500 //+_+__________o ___________
; 0000 0501 //+_+__________ o _________  //dolny - do tego pozycjonujemy
; 0000 0502 //
; 0000 0503 PORTE.4 = 0;
	CBI  0x3,4
; 0000 0504 while(PINE.1 != 0)//kiedy nie widzi czujnik czujnik - jestesmy daleko
_0x162:
	SBIS 0x1,1
	RJMP _0x164
; 0000 0505     {
; 0000 0506     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 0507     delay_us(1000);
; 0000 0508     PORTE.5 = 0;
; 0000 0509     delay_us(1000);
; 0000 050A     }
	RJMP _0x162
_0x164:
; 0000 050B 
; 0000 050C //zwolnij
; 0000 050D PORTE.5 = 1;
	CALL SUBOPT_0x1E
; 0000 050E delay_us(2000);
; 0000 050F PORTE.5 = 0;
; 0000 0510 delay_us(2000);
; 0000 0511 
; 0000 0512 PORTE.5 = 1;
; 0000 0513 delay_us(4000);
; 0000 0514 PORTE.5 = 0;
; 0000 0515 delay_us(4000);
; 0000 0516 
; 0000 0517 
; 0000 0518 
; 0000 0519 //teraz sie cofniemy
; 0000 051A PORTE.4 = 1;  //zmieniamy dir
; 0000 051B while(basia1 < 1000)  //musimy przejechac tak, ze na pewno miniemy czujnuk gdybysmy byli miedzy nimi, zmieniam mikrokroki wiec daje mniej, by³o 2000
_0x173:
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRGE _0x175
; 0000 051C     {                                                         //2000 //1000  //500
; 0000 051D     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 051E     delay_us(1000);
; 0000 051F     PORTE.5 = 0;
; 0000 0520     delay_us(1000);
; 0000 0521     basia1++;
	CALL SUBOPT_0x20
; 0000 0522     }
	RJMP _0x173
_0x175:
; 0000 0523 
; 0000 0524 //zwolnij
; 0000 0525 PORTE.5 = 1;
	CALL SUBOPT_0x21
; 0000 0526 delay_us(4000);
; 0000 0527 PORTE.5 = 0;
; 0000 0528 delay_us(4000);
; 0000 0529 
; 0000 052A PORTE.5 = 1;
	CALL SUBOPT_0x21
; 0000 052B delay_us(4000);
; 0000 052C PORTE.5 = 0;
; 0000 052D delay_us(4000);
; 0000 052E 
; 0000 052F 
; 0000 0530 PORTE.4 = 0;  //zmieniamy dir
	CBI  0x3,4
; 0000 0531 basia1 = 0;
	LDI  R30,LOW(0)
	STS  _basia1,R30
	STS  _basia1+1,R30
; 0000 0532 while(PINE.1 != 0)//i znowu do czujnika
_0x184:
	SBIS 0x1,1
	RJMP _0x186
; 0000 0533     {
; 0000 0534     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 0535     delay_us(1000);
; 0000 0536     PORTE.5 = 0;
; 0000 0537     delay_us(1000);
; 0000 0538     }
	RJMP _0x184
_0x186:
; 0000 0539 while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
_0x18B:
	CALL SUBOPT_0x1F
	SBIW R26,10
	BRGE _0x18D
; 0000 053A     {
; 0000 053B     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 053C     delay_us(1000);
; 0000 053D     PORTE.5 = 0;
; 0000 053E     delay_us(1000);
; 0000 053F     basia1++;
	CALL SUBOPT_0x20
; 0000 0540     }
	RJMP _0x18B
_0x18D:
; 0000 0541 while(PINE.1 != 1)//i znowu teraz jak czujnik swieci
_0x192:
	SBIC 0x1,1
	RJMP _0x194
; 0000 0542     {
; 0000 0543     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 0544     delay_us(1000);
; 0000 0545     PORTE.5 = 0;
; 0000 0546     delay_us(1000);
; 0000 0547     }
	RJMP _0x192
_0x194:
; 0000 0548 basia1 = 0;
	LDI  R30,LOW(0)
	STS  _basia1,R30
	STS  _basia1+1,R30
; 0000 0549 while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
_0x199:
	CALL SUBOPT_0x1F
	SBIW R26,10
	BRGE _0x19B
; 0000 054A     {
; 0000 054B     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 054C     delay_us(1000);
; 0000 054D     PORTE.5 = 0;
; 0000 054E     delay_us(1000);
; 0000 054F     basia1++;
	CALL SUBOPT_0x20
; 0000 0550     }
	RJMP _0x199
_0x19B:
; 0000 0551 while(PINE.1 != 0)//i znowu do czujnika
_0x1A0:
	SBIS 0x1,1
	RJMP _0x1A2
; 0000 0552     {
; 0000 0553     PORTE.5 = 1;
	CALL SUBOPT_0x1D
; 0000 0554     delay_us(1000);
; 0000 0555     PORTE.5 = 0;
; 0000 0556     delay_us(1000);
; 0000 0557     }
	RJMP _0x1A0
_0x1A2:
; 0000 0558 
; 0000 0559 //zwolnij
; 0000 055A PORTE.5 = 1;
	CALL SUBOPT_0x1E
; 0000 055B delay_us(2000);
; 0000 055C PORTE.5 = 0;
; 0000 055D delay_us(2000);
; 0000 055E 
; 0000 055F PORTE.5 = 1;
; 0000 0560 delay_us(4000);
; 0000 0561 PORTE.5 = 0;
; 0000 0562 delay_us(4000);
; 0000 0563 
; 0000 0564 
; 0000 0565 
; 0000 0566 
; 0000 0567 PORTE.4 = 1;  //zmieniamy dir
; 0000 0568 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x2
; 0000 0569 PORTE.7 = 0;
	CBI  0x3,7
; 0000 056A }
	RET
;
;
;void wypozucjonuj_wieze_szybko()
; 0000 056E {
; 0000 056F PORTE.7 = 1;  //enable na silnik krok
; 0000 0570 
; 0000 0571 //+_+__________o ___________
; 0000 0572 //+_+__________ o _________  //dolny - do tego pozycjonujemy
; 0000 0573 //
; 0000 0574 PORTE.4 = 0;
; 0000 0575 while(PINE.1 != 0)//kiedy nie widzi czujnik czujnik - jestesmy daleko
; 0000 0576     {
; 0000 0577     PORTE.5 = 1;
; 0000 0578     delay_us(500);
; 0000 0579     PORTE.5 = 0;
; 0000 057A     delay_us(500);
; 0000 057B     }
; 0000 057C 
; 0000 057D //zwolnij
; 0000 057E PORTE.5 = 1;
; 0000 057F delay_us(500);
; 0000 0580 PORTE.5 = 0;
; 0000 0581 delay_us(500);
; 0000 0582 
; 0000 0583 PORTE.5 = 1;
; 0000 0584 delay_us(1000);
; 0000 0585 PORTE.5 = 0;
; 0000 0586 delay_us(1000);
; 0000 0587 
; 0000 0588 
; 0000 0589 
; 0000 058A //teraz sie cofniemy
; 0000 058B PORTE.4 = 1;  //zmieniamy dir
; 0000 058C while(basia1 < 250)  //musimy przejechac tak, ze na pewno miniemy czujnuk gdybysmy byli miedzy nimi, zmieniam mikrokroki wiec daje mniej, by³o 2000
; 0000 058D     {                                                         //2000 //1000  //500
; 0000 058E     PORTE.5 = 1;
; 0000 058F     delay_us(500);
; 0000 0590     PORTE.5 = 0;
; 0000 0591     delay_us(500);
; 0000 0592     basia1++;
; 0000 0593     }
; 0000 0594 
; 0000 0595 //zwolnij
; 0000 0596 PORTE.5 = 1;
; 0000 0597 delay_us(500);
; 0000 0598 PORTE.5 = 0;
; 0000 0599 delay_us(500);
; 0000 059A 
; 0000 059B PORTE.5 = 1;
; 0000 059C delay_us(1000);
; 0000 059D PORTE.5 = 0;
; 0000 059E delay_us(1000);
; 0000 059F 
; 0000 05A0 
; 0000 05A1 PORTE.4 = 0;  //zmieniamy dir
; 0000 05A2 basia1 = 0;
; 0000 05A3 while(PINE.1 != 0)//i znowu do czujnika
; 0000 05A4     {
; 0000 05A5     PORTE.5 = 1;
; 0000 05A6     delay_us(500);
; 0000 05A7     PORTE.5 = 0;
; 0000 05A8     delay_us(500);
; 0000 05A9     }
; 0000 05AA while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 05AB     {
; 0000 05AC     PORTE.5 = 1;
; 0000 05AD     delay_us(500);
; 0000 05AE     PORTE.5 = 0;
; 0000 05AF     delay_us(500);
; 0000 05B0     basia1++;
; 0000 05B1     }
; 0000 05B2 while(PINE.1 != 1)//i znowu teraz jak czujnik swieci
; 0000 05B3     {
; 0000 05B4     PORTE.5 = 1;
; 0000 05B5     delay_us(500);
; 0000 05B6     PORTE.5 = 0;
; 0000 05B7     delay_us(500);
; 0000 05B8     }
; 0000 05B9 basia1 = 0;
; 0000 05BA while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 05BB     {
; 0000 05BC     PORTE.5 = 1;
; 0000 05BD     delay_us(500);
; 0000 05BE     PORTE.5 = 0;
; 0000 05BF     delay_us(500);
; 0000 05C0     basia1++;
; 0000 05C1     }
; 0000 05C2 while(PINE.1 != 0)//i znowu do czujnika
; 0000 05C3     {
; 0000 05C4     PORTE.5 = 1;
; 0000 05C5     delay_us(500);
; 0000 05C6     PORTE.5 = 0;
; 0000 05C7     delay_us(500);
; 0000 05C8     }
; 0000 05C9 
; 0000 05CA //zwolnij
; 0000 05CB PORTE.5 = 1;
; 0000 05CC delay_us(500);
; 0000 05CD PORTE.5 = 0;
; 0000 05CE delay_us(500);
; 0000 05CF 
; 0000 05D0 PORTE.5 = 1;
; 0000 05D1 delay_us(1000);
; 0000 05D2 PORTE.5 = 0;
; 0000 05D3 delay_us(1000);
; 0000 05D4 
; 0000 05D5 
; 0000 05D6 
; 0000 05D7 
; 0000 05D8 PORTE.4 = 1;  //zmieniamy dir
; 0000 05D9 delay_ms(3000);
; 0000 05DA PORTE.7 = 0;
; 0000 05DB }
;
;
;
;
;void jedz_wieza()
; 0000 05E1 {
; 0000 05E2 
; 0000 05E3 //pomysl - wyysylac w czasie drogi impulsy - to bedzie wielkosc kamienia
; 0000 05E4 //pomysl - wyysylac w czasie postoju - to bedzie predkosc
; 0000 05E5 //to nawet moge zrobic tu
; 0000 05E6 
; 0000 05E7 //w prawo
; 0000 05E8 
; 0000 05E9 
; 0000 05EA     switch(pozycja_wiezy)
; 0000 05EB 
; 0000 05EC         {
; 0000 05ED 
; 0000 05EE         case 0:
; 0000 05EF 
; 0000 05F0 
; 0000 05F1                 PORTE.7 = 1;
; 0000 05F2                 sek2 = 0;
; 0000 05F3                 pozycja_wiezy = 1;
; 0000 05F4                 ulamki_sekund_1 = 0;
; 0000 05F5 
; 0000 05F6 
; 0000 05F7         break;
; 0000 05F8 
; 0000 05F9         case 1:
; 0000 05FA 
; 0000 05FB                 if(kkk == kkk1)
; 0000 05FC                     kkk1 = obroc_o_1_8_stopnia(v1, kkk);
; 0000 05FD                 else
; 0000 05FE                     {                    //30 ok    //60 * 16 * 2 ok na szybki zegar
; 0000 05FF                     if(ulamki_sekund_1 > 60 * 8 * 2)
; 0000 0600                         {
; 0000 0601                         v1--;
; 0000 0602                         ulamki_sekund_1 = 0;
; 0000 0603                         }
; 0000 0604                     kkk1 = kkk;
; 0000 0605                     }
; 0000 0606 
; 0000 0607                  if(v1 == speed_normal) //6 sie pieprzy po 30 min, daje 3 ale zmieniam kroki
; 0000 0608                     {
; 0000 0609                     kkk = 0;
; 0000 060A                     if(PORTE.4 == 1)
; 0000 060B                         pozycja_wiezy = 2;
; 0000 060C                     else
; 0000 060D                         pozycja_wiezy = 3;
; 0000 060E                     }
; 0000 060F 
; 0000 0610                 if(sek2 > 170)
; 0000 0611                     {
; 0000 0612                     kkk = 0;
; 0000 0613                     kkk1 = 0;
; 0000 0614                     bufor_bledu = 25;
; 0000 0615                     v1 = speed_normal;
; 0000 0616                     ulamki_sekund_1 = 0;
; 0000 0617                     if(PORTE.4 == 1)
; 0000 0618                         pozycja_wiezy = 2;
; 0000 0619                     else
; 0000 061A                         pozycja_wiezy = 3;
; 0000 061B                     }
; 0000 061C 
; 0000 061D 
; 0000 061E         break;
; 0000 061F 
; 0000 0620         //ustalic wielkosc przesuniecia kamien dla bez bufor bledu i z bufor bledu
; 0000 0621 
; 0000 0622         case 2:
; 0000 0623             if(PINE.0 != 0)
; 0000 0624                 obroc_o_1_8_stopnia(v1 + bufor_bledu, 0);
; 0000 0625             else
; 0000 0626                 {
; 0000 0627                 kamien = 50;
; 0000 0628                 if(kamien == 50)
; 0000 0629                     wielkosc_przesuniecia_kamien = 770+60;
; 0000 062A                 if(kamien == 55)
; 0000 062B                     wielkosc_przesuniecia_kamien = 740;
; 0000 062C                 if(kamien == 60)
; 0000 062D                     wielkosc_przesuniecia_kamien = 710;
; 0000 062E                 if(kamien == 65)
; 0000 062F                     wielkosc_przesuniecia_kamien = 680;
; 0000 0630                 if(kamien == 70)
; 0000 0631                     wielkosc_przesuniecia_kamien = 650;
; 0000 0632                 if(kamien == 75)
; 0000 0633                     wielkosc_przesuniecia_kamien = 620;
; 0000 0634 
; 0000 0635                 pozycja_wiezy = 4;
; 0000 0636                 }
; 0000 0637 
; 0000 0638             if(sek2 > 170 & bufor_bledu == 0)
; 0000 0639                     {
; 0000 063A                     pozycja_wiezy = 2;
; 0000 063B                     bufor_bledu = 25;
; 0000 063C                     }
; 0000 063D 
; 0000 063E         break;
; 0000 063F 
; 0000 0640         case 3:
; 0000 0641 
; 0000 0642             if(PINE.1 != 0)
; 0000 0643                 obroc_o_1_8_stopnia(v1+ bufor_bledu, 0);
; 0000 0644             else
; 0000 0645                 {
; 0000 0646                 kamien = 50;
; 0000 0647                 if(kamien == 50)
; 0000 0648                     wielkosc_przesuniecia_kamien = 770 + 60; //tu ma byc 8mm zgodnie z rys mariusz    //650 - 21mm    //700 - 15mm      //760 //9mm
; 0000 0649                 if(kamien == 55)//przesuwamy o 2,5mm
; 0000 064A                     wielkosc_przesuniecia_kamien = 740;
; 0000 064B                 if(kamien == 60)
; 0000 064C                     wielkosc_przesuniecia_kamien = 710;
; 0000 064D                 if(kamien == 65)
; 0000 064E                     wielkosc_przesuniecia_kamien = 680;
; 0000 064F                 if(kamien == 70)
; 0000 0650                     wielkosc_przesuniecia_kamien = 650;
; 0000 0651                 if(kamien == 75)
; 0000 0652                     wielkosc_przesuniecia_kamien = 620; //tu ma byc 8mm + 25/2mm = 20,5    18mm
; 0000 0653 
; 0000 0654                 pozycja_wiezy = 4;
; 0000 0655                 }
; 0000 0656 
; 0000 0657             if(sek2 > 170 & bufor_bledu == 0)
; 0000 0658                     {
; 0000 0659                     pozycja_wiezy = 3;
; 0000 065A                     bufor_bledu = 25;
; 0000 065B                     }
; 0000 065C         break;
; 0000 065D 
; 0000 065E 
; 0000 065F         case 4:
; 0000 0660                 if(kkk < 2)
; 0000 0661                     kkk = obroc_o_1_8_stopnia(v1+ bufor_bledu, kkk);  //jedziemy jeszcze kawalek z pelna pyta
; 0000 0662                 else
; 0000 0663                     {
; 0000 0664                     kkk = 0;
; 0000 0665                     pozycja_wiezy = 5;
; 0000 0666                     }
; 0000 0667 
; 0000 0668         break;
; 0000 0669 
; 0000 066A 
; 0000 066B         case 5:
; 0000 066C                 if(kkk < 2)
; 0000 066D                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 066E                 else
; 0000 066F                     {
; 0000 0670                     kkk = 0;
; 0000 0671                     pozycja_wiezy = 6;
; 0000 0672                     }
; 0000 0673 
; 0000 0674         break;
; 0000 0675 
; 0000 0676         case 6:
; 0000 0677                 if(kkk < 2)
; 0000 0678                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 0679                 else
; 0000 067A                     {
; 0000 067B                     kkk = 0;
; 0000 067C                     pozycja_wiezy = 7;
; 0000 067D                     }
; 0000 067E 
; 0000 067F         break;
; 0000 0680 
; 0000 0681         case 7:
; 0000 0682                 if(kkk < 2)
; 0000 0683                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 0684                 else
; 0000 0685                     {
; 0000 0686                     kkk = 0;
; 0000 0687                     pozycja_wiezy = 8;
; 0000 0688                     }
; 0000 0689 
; 0000 068A         break;
; 0000 068B 
; 0000 068C 
; 0000 068D 
; 0000 068E         case 8:
; 0000 068F                 if(kkk < wielkosc_przesuniecia_kamien)
; 0000 0690                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 0691                 else
; 0000 0692                     {
; 0000 0693                     pozycja_wiezy = 10;//9
; 0000 0694                     ulamki_sekund_1 = 0;
; 0000 0695                     v1 = v1 + 6;
; 0000 0696                     kkk = 0;
; 0000 0697                     kkk1 = 0;
; 0000 0698                     }
; 0000 0699 
; 0000 069A         break;
; 0000 069B 
; 0000 069C         case 9:
; 0000 069D 
; 0000 069E 
; 0000 069F                   if(kkk == kkk1)
; 0000 06A0                         kkk1 = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 06A1                   else
; 0000 06A2                         {
; 0000 06A3                         if(ulamki_sekund_1 > 60 * 6 * 2)
; 0000 06A4                             {
; 0000 06A5                             v1++;
; 0000 06A6                             ulamki_sekund_1 = 0;
; 0000 06A7                             }
; 0000 06A8                         kkk1 = kkk;
; 0000 06A9                         }
; 0000 06AA                   if(v1 == 40)
; 0000 06AB                         {
; 0000 06AC                         kkk = 0;
; 0000 06AD                         pozycja_wiezy = 10;
; 0000 06AE                         }
; 0000 06AF 
; 0000 06B0         break;
; 0000 06B1 
; 0000 06B2         case 10:
; 0000 06B3 
; 0000 06B4                 PORTE.7 = 0;  //koniec enable
; 0000 06B5                 PORTC.1 = 0;  //silownik dociskowy os pozioma
; 0000 06B6                 kkk = 0;
; 0000 06B7                 kkk1 = 0;
; 0000 06B8                 v1 = 60;
; 0000 06B9                 bufor_bledu = 0;
; 0000 06BA                 if(PORTE.4 == 1)
; 0000 06BB                     PORTE.4 = 0;  //zmieniamy dir
; 0000 06BC                 else
; 0000 06BD                     PORTE.4 = 1;
; 0000 06BE                 pozycja_wiezy = 0;
; 0000 06BF                 delay_ms(2000);
; 0000 06C0                 if(PORTC.0 == 0) //silownik obrotowy o osi pionowej
; 0000 06C1                     PORTC.0 = 1;
; 0000 06C2                 else
; 0000 06C3                     PORTC.0 = 0;
; 0000 06C4                 PORTC.1 = 1;  //silownik dociskowy os pozioma
; 0000 06C5                 delay_ms(2000);
; 0000 06C6 
; 0000 06C7 
; 0000 06C8 
; 0000 06C9         break;
; 0000 06CA         }
; 0000 06CB 
; 0000 06CC 
; 0000 06CD 
; 0000 06CE 
; 0000 06CF 
; 0000 06D0 
; 0000 06D1 
; 0000 06D2 }
;
;
;
;
;void komunikacja_male_puchary()
; 0000 06D8 {
; 0000 06D9 
; 0000 06DA //kod u slava
; 0000 06DB 
; 0000 06DC 
; 0000 06DD if(PINF.7 == 0)
; 0000 06DE     {
; 0000 06DF     if(PINF.6 == 0 & zliczylem_male_puchary == 0)
; 0000 06E0         {
; 0000 06E1         PORTB.6 = 1;
; 0000 06E2         przeslano_informacje_male_puchary = 1;
; 0000 06E3         licznik_impulsow_male_puchary++;
; 0000 06E4         zliczylem_male_puchary = 1;
; 0000 06E5         }
; 0000 06E6 
; 0000 06E7 
; 0000 06E8 
; 0000 06E9         if(PINF.6 == 1 & zliczylem_male_puchary == 1)
; 0000 06EA         {
; 0000 06EB         PORTB.6 = 0;
; 0000 06EC         zliczylem_male_puchary = 0;
; 0000 06ED         }
; 0000 06EE 
; 0000 06EF     }
; 0000 06F0                //& pozycja_wiezy == 0
; 0000 06F1 if(PINF.7 == 1 & przeslano_informacje_male_puchary == 1)
; 0000 06F2     {
; 0000 06F3 
; 0000 06F4     switch(licznik_impulsow_male_puchary)
; 0000 06F5         {
; 0000 06F6         case 0:
; 0000 06F7               tryb_male_puchary = 0;  //ze nie dokonano zadnego wyboru
; 0000 06F8               przeslano_informacje_male_puchary = 0;
; 0000 06F9         break;
; 0000 06FA 
; 0000 06FB         case 3:
; 0000 06FC               tryb_male_puchary = 3;   //ze nie bedzie malych malych pucharow
; 0000 06FD               licznik_impulsow_male_puchary = 0;
; 0000 06FE               przeslano_informacje_male_puchary = 0;
; 0000 06FF               podaj_nakretke = 1;
; 0000 0700         break;
; 0000 0701 
; 0000 0702         case 11:
; 0000 0703              tryb_male_puchary = 2;
; 0000 0704              kamien = 50;
; 0000 0705              //speed_normal = 10;
; 0000 0706              speed_normal = 12;
; 0000 0707              licznik_impulsow_male_puchary = 0;
; 0000 0708              przeslano_informacje_male_puchary = 0;
; 0000 0709         break;
; 0000 070A 
; 0000 070B         case 12:
; 0000 070C              tryb_male_puchary = 2;
; 0000 070D              kamien = 55;
; 0000 070E              //speed_normal = 10;
; 0000 070F              speed_normal = 12;
; 0000 0710              licznik_impulsow_male_puchary = 0;
; 0000 0711              przeslano_informacje_male_puchary = 0;
; 0000 0712         break;
; 0000 0713 
; 0000 0714         case 13:
; 0000 0715              tryb_male_puchary = 2;
; 0000 0716              kamien = 60;
; 0000 0717              //speed_normal = 10;
; 0000 0718              speed_normal = 12;
; 0000 0719              licznik_impulsow_male_puchary = 0;
; 0000 071A              przeslano_informacje_male_puchary = 0;
; 0000 071B         break;
; 0000 071C 
; 0000 071D         case 14:
; 0000 071E              tryb_male_puchary = 2;
; 0000 071F              kamien = 65;
; 0000 0720              //speed_normal = 10;
; 0000 0721              speed_normal = 12;
; 0000 0722              licznik_impulsow_male_puchary = 0;
; 0000 0723              przeslano_informacje_male_puchary = 0;
; 0000 0724         break;
; 0000 0725 
; 0000 0726         case 15:
; 0000 0727              tryb_male_puchary = 2;
; 0000 0728              kamien = 70;
; 0000 0729              //speed_normal = 10;
; 0000 072A              speed_normal = 12;
; 0000 072B              licznik_impulsow_male_puchary = 0;
; 0000 072C              przeslano_informacje_male_puchary = 0;
; 0000 072D 
; 0000 072E         break;
; 0000 072F 
; 0000 0730         case 16:
; 0000 0731              tryb_male_puchary = 2;
; 0000 0732              kamien = 75;
; 0000 0733              //speed_normal = 10;
; 0000 0734              speed_normal = 12;
; 0000 0735              licznik_impulsow_male_puchary = 0;
; 0000 0736              przeslano_informacje_male_puchary = 0;
; 0000 0737         break;
; 0000 0738 
; 0000 0739         case 17:
; 0000 073A              tryb_male_puchary = 2;
; 0000 073B              kamien = 50;
; 0000 073C              speed_normal = 14;
; 0000 073D              licznik_impulsow_male_puchary = 0;
; 0000 073E              przeslano_informacje_male_puchary = 0;
; 0000 073F         break;
; 0000 0740 
; 0000 0741         case 18:
; 0000 0742              tryb_male_puchary = 2;
; 0000 0743              kamien = 55;
; 0000 0744              speed_normal = 14;
; 0000 0745              licznik_impulsow_male_puchary = 0;
; 0000 0746              przeslano_informacje_male_puchary = 0;
; 0000 0747         break;
; 0000 0748 
; 0000 0749         case 19:
; 0000 074A              tryb_male_puchary = 2;
; 0000 074B              kamien = 60;
; 0000 074C              speed_normal = 14;
; 0000 074D              licznik_impulsow_male_puchary = 0;
; 0000 074E              przeslano_informacje_male_puchary = 0;
; 0000 074F         break;
; 0000 0750 
; 0000 0751         case 20:
; 0000 0752              tryb_male_puchary = 2;
; 0000 0753              kamien = 65;
; 0000 0754              speed_normal = 14;
; 0000 0755              licznik_impulsow_male_puchary = 0;
; 0000 0756              przeslano_informacje_male_puchary = 0;
; 0000 0757         break;
; 0000 0758 
; 0000 0759         case 21:
; 0000 075A              tryb_male_puchary = 2;
; 0000 075B              kamien = 70;
; 0000 075C              speed_normal = 14;
; 0000 075D              licznik_impulsow_male_puchary = 0;
; 0000 075E              przeslano_informacje_male_puchary = 0;
; 0000 075F         break;
; 0000 0760 
; 0000 0761         case 22:
; 0000 0762              tryb_male_puchary = 2;
; 0000 0763              kamien = 75;
; 0000 0764              speed_normal = 14;
; 0000 0765              licznik_impulsow_male_puchary = 0;
; 0000 0766              przeslano_informacje_male_puchary = 0;
; 0000 0767         break;
; 0000 0768 
; 0000 0769 
; 0000 076A 
; 0000 076B 
; 0000 076C         }
; 0000 076D     }
; 0000 076E 
; 0000 076F /*
; 0000 0770 if(PINC.7 == 0)
; 0000 0771     PORTB.7 = 1;
; 0000 0772 else
; 0000 0773     PORTB.7 = 0;
; 0000 0774 
; 0000 0775 if(PINC.6 == 0)
; 0000 0776     PORTB.6 = 1;
; 0000 0777 else
; 0000 0778     PORTB.6 = 0;
; 0000 0779 
; 0000 077A if(PINC.5 == 0)
; 0000 077B     PORTB.5 = 1;
; 0000 077C else
; 0000 077D     PORTB.5 = 0;
; 0000 077E 
; 0000 077F if(PINC.4 == 0)
; 0000 0780     PORTB.4 = 1;
; 0000 0781 else
; 0000 0782     PORTB.4 = 0;
; 0000 0783 
; 0000 0784 if(PINC.3 == 0)
; 0000 0785     PORTB.3 = 1;
; 0000 0786 else
; 0000 0787     PORTB.3 = 0;
; 0000 0788 
; 0000 0789 if(PINC.2 == 0)
; 0000 078A     PORTB.2 = 1;
; 0000 078B else
; 0000 078C     PORTB.2 = 0;
; 0000 078D 
; 0000 078E if(PINC.1 == 0)
; 0000 078F     PORTB.1 = 1;
; 0000 0790 else
; 0000 0791     PORTB.1 = 0;
; 0000 0792 
; 0000 0793 if(PINC.0 == 0)
; 0000 0794     PORTB.0 = 1;
; 0000 0795 else
; 0000 0796     PORTB.0 = 0;
; 0000 0797 */
; 0000 0798 
; 0000 0799 
; 0000 079A 
; 0000 079B }
;
;
;
;
;void main(void)
; 0000 07A1 {
_main:
; 0000 07A2 // Declare your local variables here
; 0000 07A3 
; 0000 07A4 // Input/Output Ports initialization
; 0000 07A5 // Port A initialization
; 0000 07A6 // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 07A7 // State7=0 State6=0 State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 07A8 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 07A9 DDRA=0xC0;
	LDI  R30,LOW(192)
	OUT  0x1A,R30
; 0000 07AA 
; 0000 07AB // Port B initialization
; 0000 07AC // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07AD // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07AE PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 07AF DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 07B0 
; 0000 07B1 // Port C initialization
; 0000 07B2 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07B3 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07B4 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 07B5 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 07B6 
; 0000 07B7 // Port D initialization
; 0000 07B8 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07B9 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07BA PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 07BB DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 07BC 
; 0000 07BD // Port E initialization
; 0000 07BE // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 07BF // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 07C0 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 07C1 DDRE=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2,R30
; 0000 07C2 
; 0000 07C3 // Port F initialization
; 0000 07C4 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07C5 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07C6 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 07C7 DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 07C8 
; 0000 07C9 // Port G initialization
; 0000 07CA // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07CB // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07CC PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 07CD DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 07CE 
; 0000 07CF // Timer/Counter 0 initialization
; 0000 07D0 // Clock source: System Clock
; 0000 07D1 // Clock value: 15,625 kHz
; 0000 07D2 // Mode: Normal top=0xFF
; 0000 07D3 // OC0 output: Disconnected
; 0000 07D4 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 07D5 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 07D6 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 07D7 OCR0=0x00;
	OUT  0x31,R30
; 0000 07D8 
; 0000 07D9 // Timer/Counter 1 initialization
; 0000 07DA // Clock source: System Clock
; 0000 07DB // Clock value: Timer1 Stopped
; 0000 07DC // Mode: Normal top=0xFFFF
; 0000 07DD // OC1A output: Discon.
; 0000 07DE // OC1B output: Discon.
; 0000 07DF // OC1C output: Discon.
; 0000 07E0 // Noise Canceler: Off
; 0000 07E1 // Input Capture on Falling Edge
; 0000 07E2 // Timer1 Overflow Interrupt: Off
; 0000 07E3 // Input Capture Interrupt: Off
; 0000 07E4 // Compare A Match Interrupt: Off
; 0000 07E5 // Compare B Match Interrupt: Off
; 0000 07E6 // Compare C Match Interrupt: Off
; 0000 07E7 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 07E8 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 07E9 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 07EA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 07EB ICR1H=0x00;
	OUT  0x27,R30
; 0000 07EC ICR1L=0x00;
	OUT  0x26,R30
; 0000 07ED OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 07EE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 07EF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 07F0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 07F1 OCR1CH=0x00;
	STS  121,R30
; 0000 07F2 OCR1CL=0x00;
	STS  120,R30
; 0000 07F3 
; 0000 07F4 // Timer/Counter 2 initialization
; 0000 07F5 // Clock source: System Clock
; 0000 07F6 // Clock value: Timer2 Stopped
; 0000 07F7 // Mode: Normal top=0xFF
; 0000 07F8 // OC2 output: Disconnected
; 0000 07F9 //TCCR2=0x00;
; 0000 07FA //TCNT2=0x00;
; 0000 07FB //OCR2=0x00;
; 0000 07FC 
; 0000 07FD // Timer/Counter 2 initialization
; 0000 07FE // Clock source: System Clock
; 0000 07FF // Clock value: 250,000 kHz
; 0000 0800 // Mode: Normal top=0xFF
; 0000 0801 // OC2 output: Disconnected
; 0000 0802 //TCCR2=0x03;
; 0000 0803 //TCNT2=0x00;
; 0000 0804 //OCR2=0x00;
; 0000 0805 
; 0000 0806 
; 0000 0807 // Timer/Counter 2 initialization
; 0000 0808 // Clock source: System Clock
; 0000 0809 // Clock value: 2000,000 kHz
; 0000 080A // Mode: Normal top=0xFF
; 0000 080B // OC2 output: Disconnected
; 0000 080C //TCCR2=0x02;
; 0000 080D //TCNT2=0x00;
; 0000 080E //OCR2=0x00;
; 0000 080F 
; 0000 0810 // Timer/Counter 2 initialization
; 0000 0811 // Clock source: System Clock
; 0000 0812 // Clock value: 16000,000 kHz
; 0000 0813 // Mode: Normal top=0xFF
; 0000 0814 // OC2 output: Disconnected
; 0000 0815 TCCR2=0x01;
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0816 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0817 OCR2=0x00;
	OUT  0x23,R30
; 0000 0818 
; 0000 0819 
; 0000 081A 
; 0000 081B // Timer/Counter 3 initialization
; 0000 081C // Clock source: System Clock
; 0000 081D // Clock value: Timer3 Stopped
; 0000 081E // Mode: Normal top=0xFFFF
; 0000 081F // OC3A output: Discon.
; 0000 0820 // OC3B output: Discon.
; 0000 0821 // OC3C output: Discon.
; 0000 0822 // Noise Canceler: Off
; 0000 0823 // Input Capture on Falling Edge
; 0000 0824 // Timer3 Overflow Interrupt: Off
; 0000 0825 // Input Capture Interrupt: Off
; 0000 0826 // Compare A Match Interrupt: Off
; 0000 0827 // Compare B Match Interrupt: Off
; 0000 0828 // Compare C Match Interrupt: Off
; 0000 0829 TCCR3A=0x00;
	STS  139,R30
; 0000 082A TCCR3B=0x00;
	STS  138,R30
; 0000 082B TCNT3H=0x00;
	STS  137,R30
; 0000 082C TCNT3L=0x00;
	STS  136,R30
; 0000 082D ICR3H=0x00;
	STS  129,R30
; 0000 082E ICR3L=0x00;
	STS  128,R30
; 0000 082F OCR3AH=0x00;
	STS  135,R30
; 0000 0830 OCR3AL=0x00;
	STS  134,R30
; 0000 0831 OCR3BH=0x00;
	STS  133,R30
; 0000 0832 OCR3BL=0x00;
	STS  132,R30
; 0000 0833 OCR3CH=0x00;
	STS  131,R30
; 0000 0834 OCR3CL=0x00;
	STS  130,R30
; 0000 0835 
; 0000 0836 // External Interrupt(s) initialization
; 0000 0837 // INT0: Off
; 0000 0838 // INT1: Off
; 0000 0839 // INT2: Off
; 0000 083A // INT3: Off
; 0000 083B // INT4: Off
; 0000 083C // INT5: Off
; 0000 083D // INT6: Off
; 0000 083E // INT7: Off
; 0000 083F EICRA=0x00;
	STS  106,R30
; 0000 0840 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0841 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0842 
; 0000 0843 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0844 //TIMSK=0x01;
; 0000 0845 
; 0000 0846 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0847 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x37,R30
; 0000 0848 
; 0000 0849 
; 0000 084A 
; 0000 084B 
; 0000 084C ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 084D 
; 0000 084E 
; 0000 084F /*
; 0000 0850 // USART0 initialization
; 0000 0851 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0852 // USART0 Receiver: On
; 0000 0853 // USART0 Transmitter: On
; 0000 0854 // USART0 Mode: Asynchronous
; 0000 0855 // USART0 Baud Rate: 2400
; 0000 0856 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 0857 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 0858 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 0859 UBRR0H=0x01;
; 0000 085A UBRR0L=0xA0;
; 0000 085B */
; 0000 085C 
; 0000 085D 
; 0000 085E /*
; 0000 085F // USART0 initialization
; 0000 0860 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0861 // USART0 Receiver: On
; 0000 0862 // USART0 Transmitter: On
; 0000 0863 // USART0 Mode: Asynchronous
; 0000 0864 // USART0 Baud Rate: 9600
; 0000 0865 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 0866 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 0867 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 0868 UBRR0H=0x00;
; 0000 0869 UBRR0L=0x67;
; 0000 086A 
; 0000 086B */
; 0000 086C // USART0 initialization
; 0000 086D // USART0 disabled
; 0000 086E UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 086F 
; 0000 0870 
; 0000 0871 // USART1 initialization
; 0000 0872 // USART1 disabled
; 0000 0873 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 0874 
; 0000 0875 // USART1 initialization
; 0000 0876 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0877 // USART1 Receiver: On
; 0000 0878 // USART1 Transmitter: On
; 0000 0879 // USART1 Mode: Asynchronous
; 0000 087A // USART1 Baud Rate: 9600
; 0000 087B //UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
; 0000 087C //UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
; 0000 087D //UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
; 0000 087E //UBRR1H=0x00;
; 0000 087F //UBRR1L=0x67;
; 0000 0880 
; 0000 0881 
; 0000 0882 // Analog Comparator initialization
; 0000 0883 // Analog Comparator: Off
; 0000 0884 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0885 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0886 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0887 
; 0000 0888 // ADC initialization
; 0000 0889 // ADC disabled
; 0000 088A ADCSRA=0x00;
	OUT  0x6,R30
; 0000 088B 
; 0000 088C // SPI initialization
; 0000 088D // SPI disabled
; 0000 088E SPCR=0x00;
	OUT  0xD,R30
; 0000 088F 
; 0000 0890 // TWI initialization
; 0000 0891 // TWI disabled
; 0000 0892 TWCR=0x00;
	STS  116,R30
; 0000 0893 
; 0000 0894 
; 0000 0895 // Alphanumeric LCD initialization
; 0000 0896 // Connections specified in the
; 0000 0897 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0898 // RS - PORTG Bit 4
; 0000 0899 // RD - PORTD Bit 6
; 0000 089A // EN - PORTD Bit 7
; 0000 089B // D4 - PORTG Bit 0
; 0000 089C // D5 - PORTG Bit 1
; 0000 089D // D6 - PORTG Bit 2
; 0000 089E // D7 - PORTG Bit 3
; 0000 089F // Characters/line: 16
; 0000 08A0 //lcd_init(16);
; 0000 08A1 //BEZ WYSWIETLACZ
; 0000 08A2 
; 0000 08A3 //WE
; 0000 08A4 //PINA.0    czujnik widzenia nakrêtki
; 0000 08A5 //PINA.1    uszkodzonie na karcie - Pan Bogdan zwar³
; 0000 08A6 //PINA.2    czujnik widzenia kamienia
; 0000 08A7 //PINA.3    sygnal odpytania od procesora glownego
; 0000 08A8 //PINA.4    czujnik do silownika kolejkujacego nakretki - lampka nie chodzi
; 0000 08A9 //PINA.5    czujnik czy jest klej
; 0000 08AA //PINA.6    czujnik czy jest gotowy do pracy dozownik kleju
; 0000 08AB //PINA.7    pedal montera 3 - informacja ze zwolnil zacisk grzybka i jednoczesnie ze nakretka pobrana
; 0000 08AC 
; 0000 08AD //PINF.0    uszkodzone
; 0000 08AE //PINF.1    uszkodzona karta
; 0000 08AF //PINF.2
; 0000 08B0 //PINF.3
; 0000 08B1 //PINF.4    czujnik dolny nakretek ten cienki magnetyczny
; 0000 08B2 //PINF.5    ze MAster dal zgode na zacisniecie szczek
; 0000 08B3 //PINF.6    do komunikacji z male puchary - NOWY KABEL
; 0000 08B4 //PINF.7    do komunikacji z male puchary sygnal przecinka - NOWY KABEL
; 0000 08B5 
; 0000 08B6 //PINE.0    czujnik 1 indukcyjnych pozycjonujacey wieze
; 0000 08B7 //PINE.1    czujnik 1 indukcyjnych pozycjonujacey wieze
; 0000 08B8 //PINE.2    peda³ 2
; 0000 08B9 //PINE.3    czujnik na silowniku otwierania wiezyczki tym nowym
; 0000 08BA 
; 0000 08BB //WNIOSKI:
; 0000 08BC //C ZMIENIC NA F
; 0000 08BD //DO C PODPIAC NOWA WYSPE
; 0000 08BE //DO E PODPISAC KARTE 4 + SILNIK KROK
; 0000 08BF 
; 0000 08C0 
; 0000 08C1 //WY
; 0000 08C2 //PORTB.0   orientator nakretek
; 0000 08C3 //PORTB.1   za³¹czenie 220V na dozownik kleju
; 0000 08C4 //PORTB.2
; 0000 08C5 //PORTB.3   psikanie
; 0000 08C6 //PORTB.4   cisnienia na dozownik kleju
; 0000 08C7 //PORTB.5
; 0000 08C8 //PORTB.6   SYGAN POTWIERDZENIA DO MASTER
; 0000 08C9 //PORTB.7   podawanie kleju
; 0000 08CA 
; 0000 08CB //PORTD.0
; 0000 08CC //PORTD.1
; 0000 08CD //PORTD.2   silownik podawania kleju
; 0000 08CE //PORTD.3   silownik otwierania lancy
; 0000 08CF //PORTD.4   silownik wykonujacy drgania
; 0000 08D0 //PORTD.5   silownik kolejkujacy nakrêtki na zjezdzalni
; 0000 08D1 //PORTD.6   tacka pobierajaca nakretki
; 0000 08D2 //PORTD.7   chwytanie kamienia
; 0000 08D3 
; 0000 08D4 
; 0000 08D5 //PORTC.0   // silownik obrotowy os pionowa
; 0000 08D6 //PORTC.1  //silownik obrotowy os pozioma w gore czyli nie ma kolizji
; 0000 08D7 //PORTC.2  //zamykanie wiezyczki 1
; 0000 08D8 //PORTC.3  //zamykanie wiezyczki 2
; 0000 08D9 //PORTC.4
; 0000 08DA //PORTC.5
; 0000 08DB //PORTC.6
; 0000 08DC //PORTC.7  //zamykanie wiezyczki 2
; 0000 08DD 
; 0000 08DE //WPROWADZAM MODYFIKACJE POD MALE PUCHARY
; 0000 08DF //PORTE.4 - DIR du¿y silnik
; 0000 08E0 //PORTE.5 - CLK
; 0000 08E1 //PORTE.7 - enable (1 uruchamia)
; 0000 08E2 
; 0000 08E3 //PROCESY
; 0000 08E4 //proces_0 - podawanie nakretki monterowi
; 0000 08E5 //proces_1 - chwytanie kamienia
; 0000 08E6 
; 0000 08E7 
; 0000 08E8 //////////////////////////////////////////
; 0000 08E9 ////obsluga_startowa_dozownika_kleju();    //wywalam bo modul male puchary
; 0000 08EA //////////////////////////////////////////
; 0000 08EB 
; 0000 08EC /*
; 0000 08ED delay_ms(2000);
; 0000 08EE delay_ms(2000);
; 0000 08EF 
; 0000 08F0 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
; 0000 08F1 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
; 0000 08F2 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
; 0000 08F3 //(aby zamknac: PORTC.3 = 0; PORTC.7 = 1;)
; 0000 08F4 
; 0000 08F5 PORTC.5 = 0;  //schowaj silownik otwierajacy wieze - ustawienie wstepne
; 0000 08F6 PORTC.6 = 1;
; 0000 08F7 delay_ms(2000);
; 0000 08F8 delay_ms(2000);
; 0000 08F9 
; 0000 08FA 
; 0000 08FB PORTC.5 = 1;     //wysun silownik
; 0000 08FC PORTC.6 = 0;
; 0000 08FD 
; 0000 08FE delay_ms(2000);
; 0000 08FF delay_ms(2000);
; 0000 0900 PORTC.5 = 0;  //schowaj silownik
; 0000 0901 PORTC.6 = 1;
; 0000 0902 
; 0000 0903 
; 0000 0904 delay_ms(2000);
; 0000 0905 delay_ms(2000);
; 0000 0906 */
; 0000 0907 
; 0000 0908 
; 0000 0909 PORTC.5 = 0;  //schowaj silownik otwierajacy wieze
	CBI  0x15,5
; 0000 090A PORTC.6 = 1;
	SBI  0x15,6
; 0000 090B 
; 0000 090C PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
	SBI  0x15,3
; 0000 090D PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
	CBI  0x15,7
; 0000 090E 
; 0000 090F 
; 0000 0910 pomocnicza = 7;
	__GETD1N 0x7
	STS  _pomocnicza,R30
	STS  _pomocnicza+1,R31
	STS  _pomocnicza+2,R22
	STS  _pomocnicza+3,R23
; 0000 0911 stala_czasowa = 62;
	__GETD1N 0x3E
	STS  _stala_czasowa,R30
	STS  _stala_czasowa+1,R31
	STS  _stala_czasowa+2,R22
	STS  _stala_czasowa+3,R23
; 0000 0912 czas_monterow = pomocnicza * stala_czasowa;
	LDS  R26,_pomocnicza
	LDS  R27,_pomocnicza+1
	LDS  R24,_pomocnicza+2
	LDS  R25,_pomocnicza+3
	CALL __MULD12
	STS  _czas_monterow,R30
	STS  _czas_monterow+1,R31
	STS  _czas_monterow+2,R22
	STS  _czas_monterow+3,R23
; 0000 0913 start = 0;
	CLR  R4
	CLR  R5
; 0000 0914 PORTD.2 = 1;  //igla wysunieta z klejem czyli wysuniety silownik
	SBI  0x12,2
; 0000 0915 nakretka = 1; //silownik z dysza kleju do gory
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0916 licznik_nakretek = 0;
	CLR  R6
	CLR  R7
; 0000 0917 
; 0000 0918 czekaj_komunikacja = 0;
	CLR  R10
	CLR  R11
; 0000 0919 podaj_nakretke = 0;
	LDI  R30,LOW(0)
	STS  _podaj_nakretke,R30
	STS  _podaj_nakretke+1,R30
; 0000 091A wcisnalem_pedal = 0;
	CALL SUBOPT_0x22
; 0000 091B zezwolenie_na_zacisniecie_szczek_od_master = 0;
	STS  _zezwolenie_na_zacisniecie_szczek_od_master,R30
	STS  _zezwolenie_na_zacisniecie_szczek_od_master+1,R30
; 0000 091C zacisnalem_szczeki = 0;
	LDI  R30,LOW(0)
	STS  _zacisnalem_szczeki,R30
	STS  _zacisnalem_szczeki+1,R30
; 0000 091D ff = 0;
	CLR  R12
	CLR  R13
; 0000 091E jest_nakretka_przy_dolnym = 0;
	STS  _jest_nakretka_przy_dolnym,R30
	STS  _jest_nakretka_przy_dolnym+1,R30
; 0000 091F wlaczam_dodatkowe_wibracje_i_psikanie = 0;
	STS  _wlaczam_dodatkowe_wibracje_i_psikanie,R30
	STS  _wlaczam_dodatkowe_wibracje_i_psikanie+1,R30
; 0000 0920 licznik_drgania = 0;
	STS  _licznik_drgania,R30
	STS  _licznik_drgania+1,R30
	STS  _licznik_drgania+2,R30
	STS  _licznik_drgania+3,R30
; 0000 0921 wystarczy_zejscia = 0;
	STS  _wystarczy_zejscia,R30
	STS  _wystarczy_zejscia+1,R30
; 0000 0922 licznik_widzenia_nakretki = 0;
	STS  _licznik_widzenia_nakretki,R30
	STS  _licznik_widzenia_nakretki+1,R30
; 0000 0923 wcisniete_zakonczone = 0;
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R30
; 0000 0924 wielkosc_przesuniecia_kamien = 0;
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R30
; 0000 0925 kamien = 0;
	STS  _kamien,R30
	STS  _kamien+1,R30
; 0000 0926 test_zjezdzalni_nakretek = 0;  //TEST ZJEZDZALNI NAKRETEK
	STS  _test_zjezdzalni_nakretek,R30
	STS  _test_zjezdzalni_nakretek+1,R30
; 0000 0927 male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 0;
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3,R30
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3+1,R30
; 0000 0928 
; 0000 0929 podaj_nakretke = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _podaj_nakretke,R30
	STS  _podaj_nakretke+1,R31
; 0000 092A wcisnalem_pedal = 0;
	CALL SUBOPT_0x22
; 0000 092B zacisnalem_szczeki = 0;
	STS  _zacisnalem_szczeki,R30
	STS  _zacisnalem_szczeki+1,R30
; 0000 092C zezwolenie_od_master = 0;
	LDI  R30,LOW(0)
	STS  _zezwolenie_od_master,R30
	STS  _zezwolenie_od_master+1,R30
; 0000 092D wcisniete_zakonczone = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R31
; 0000 092E wieza = 0;
	LDI  R30,LOW(0)
	STS  _wieza,R30
	STS  _wieza+1,R30
; 0000 092F 
; 0000 0930 pozycja_wiezy = 0;
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R30
; 0000 0931 kkk = 0;
	CALL SUBOPT_0xB
; 0000 0932 kkk1 = 0;
	CALL SUBOPT_0xD
; 0000 0933 v1 = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0xF
; 0000 0934 speed_normal = 8;  //8 to totalny maks , 09.08.2018 bylo 10, zmieniam na 12, bo wtedy jest stabilnie
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _speed_normal,R30
	STS  _speed_normal+1,R31
; 0000 0935 tryb_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R30
; 0000 0936 jedz_wieza_cykl_znacznik = 0;
	STS  _jedz_wieza_cykl_znacznik,R30
	STS  _jedz_wieza_cykl_znacznik+1,R30
; 0000 0937 
; 0000 0938 PORTC.0 = 1;  // silownik obrotowy os pionowa
	SBI  0x15,0
; 0000 0939 PORTC.1 = 1;  //silownik obrotowy os pozioma w gore czyli nie ma kolizji
	SBI  0x15,1
; 0000 093A 
; 0000 093B delay_ms(1000);
	CALL SUBOPT_0x23
; 0000 093C delay_ms(1000);
	CALL SUBOPT_0x23
; 0000 093D 
; 0000 093E //////////////////////////////////////////////////////////////
; 0000 093F while(PINA.0 == 0)
_0x27A:
	SBIS 0x19,0
; 0000 0940     {
; 0000 0941     }       //czekaj na sygnal
	RJMP _0x27A
; 0000 0942 
; 0000 0943 wypozucjonuj_wieze_wolno();
	RCALL _wypozucjonuj_wieze_wolno
; 0000 0944 PORTA.7 = 1;  //potwierdzam wypozycjonowanie
	SBI  0x1B,7
; 0000 0945 delay_ms(1000);
	CALL SUBOPT_0x23
; 0000 0946 PORTA.7 = 0;
	CBI  0x1B,7
; 0000 0947 
; 0000 0948 #asm("sei")
	sei
; 0000 0949 //while(1)
; 0000 094A //    jedz_wieza();
; 0000 094B 
; 0000 094C ////////////////////////////////////////////
; 0000 094D 
; 0000 094E //while(tryb_male_puchary == 0)
; 0000 094F //     komunikacja_male_puchary();
; 0000 0950 
; 0000 0951 //wypozucjonuj_wieze_wolno();
; 0000 0952 
; 0000 0953 // Global enable interrupts
; 0000 0954 //#asm("sei")
; 0000 0955 
; 0000 0956 //while(1)
; 0000 0957 //    jedz_wieza();
; 0000 0958 
; 0000 0959 
; 0000 095A while (1)
_0x281:
; 0000 095B       {
; 0000 095C       jedz_wieza_cykl();
	RCALL _jedz_wieza_cykl
; 0000 095D       PORTA.6 = PINE.2;
	SBIC 0x1,2
	RJMP _0x284
	CBI  0x1B,6
	RJMP _0x285
_0x284:
	SBI  0x1B,6
_0x285:
; 0000 095E       /*
; 0000 095F       procesy();
; 0000 0960 
; 0000 0961 
; 0000 0962       //if(proces[3] != 4)
; 0000 0963       //  {
; 0000 0964         zerowanie_procesow();
; 0000 0965         kontrola_orientatora_nakretek_nowa_zjezdzalnia();
; 0000 0966         komunikacja_bez_rs232();
; 0000 0967         komunikacja_male_puchary();
; 0000 0968       //  }
; 0000 0969 
; 0000 096A       while(jedz_wieza_cykl_znacznik == 1 & tryb_male_puchary == 2)
; 0000 096B           {
; 0000 096C           jedz_wieza_cykl();
; 0000 096D           if(skonczony_proces[0] == 0)
; 0000 096E                 skonczony_proces[0] = proces_0();
; 0000 096F           if(skonczony_proces[3] == 0)
; 0000 0970                 skonczony_proces[3] = proces_3();
; 0000 0971 
; 0000 0972 
; 0000 0973 
; 0000 0974          }
; 0000 0975       */
; 0000 0976 
; 0000 0977       }
	RJMP _0x281
; 0000 0978 //kontrola_czujnika_dolnego_nakretek();
; 0000 0979 //kontrola_orientatora_nakretek();
; 0000 097A //obsluga_dozownika_kleju_i_komunikacja();
; 0000 097B //drgania();
; 0000 097C //obsluga_probna_pobierania_nakretek();
; 0000 097D }
_0x286:
	RJMP _0x286
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_sek0:
	.BYTE 0x4
_sek1:
	.BYTE 0x4
_sek2:
	.BYTE 0x4
_sek3:
	.BYTE 0x4
_sek4:
	.BYTE 0x4
_ulamki_sekund_0:
	.BYTE 0x4
_ulamki_sekund_1:
	.BYTE 0x4
_proces:
	.BYTE 0x14
_skonczony_proces:
	.BYTE 0x14
_czas_monterow:
	.BYTE 0x4
_pomocnicza:
	.BYTE 0x4
_stala_czasowa:
	.BYTE 0x4
_podaj_nakretke:
	.BYTE 0x2
_wcisnalem_pedal:
	.BYTE 0x2
_zezwolenie_na_zacisniecie_szczek_od_master:
	.BYTE 0x2
_zacisnalem_szczeki:
	.BYTE 0x2
_jest_nakretka_przy_dolnym:
	.BYTE 0x2
_wlaczam_dodatkowe_wibracje_i_psikanie:
	.BYTE 0x2
_licznik_drgania:
	.BYTE 0x4
_wystarczy_zejscia:
	.BYTE 0x2
_licznik_widzenia_nakretki:
	.BYTE 0x2
_ilosc_prob_wybicia_zakretki_do_gory:
	.BYTE 0x2
_wcisniete_zakonczone:
	.BYTE 0x2
_zezwolenie_od_master:
	.BYTE 0x2
_basia1:
	.BYTE 0x2
_pozycja_wiezy:
	.BYTE 0x2
_kkk:
	.BYTE 0x2
_kkk1:
	.BYTE 0x2
_v1:
	.BYTE 0x2
_wielkosc_przesuniecia_kamien:
	.BYTE 0x2
_kamien:
	.BYTE 0x2
_speed_normal:
	.BYTE 0x2
_bufor_bledu:
	.BYTE 0x2
_zliczylem_male_puchary:
	.BYTE 0x2
_licznik_impulsow_male_puchary:
	.BYTE 0x2
_tryb_male_puchary:
	.BYTE 0x2
_test_zjezdzalni_nakretek:
	.BYTE 0x2
_przeslano_informacje_male_puchary:
	.BYTE 0x2
_male_puchary_pozwolenie_wyjecia_puchara_monter_3:
	.BYTE 0x2
_wieza:
	.BYTE 0x2
_jedz_wieza_cykl_znacznik:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	STS  _kamien,R30
	STS  _kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _ulamki_sekund_1,R30
	STS  _ulamki_sekund_1+1,R30
	STS  _ulamki_sekund_1+2,R30
	STS  _ulamki_sekund_1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDS  R30,_kkk1
	LDS  R31,_kkk1+1
	LDS  R26,_kkk
	LDS  R27,_kkk+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_kkk
	LDS  R31,_kkk+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _obroc_o_1_8_stopnia

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_ulamki_sekund_1
	LDS  R27,_ulamki_sekund_1+1
	LDS  R24,_ulamki_sekund_1+2
	LDS  R25,_ulamki_sekund_1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	LDS  R26,_v1
	LDS  R27,_v1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _kkk,R30
	STS  _kkk+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _kkk1,R30
	STS  _kkk1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	STS  _bufor_bledu,R30
	STS  _bufor_bledu+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	STS  _v1,R30
	STS  _v1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	LDS  R30,_bufor_bledu
	LDS  R31,_bufor_bledu+1
	RCALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _obroc_o_1_8_stopnia

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDS  R26,_kamien
	LDS  R27,_kamien+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(830)
	LDI  R31,HIGH(830)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(770)
	LDI  R31,HIGH(770)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(740)
	LDI  R31,HIGH(740)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(710)
	LDI  R31,HIGH(710)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(680)
	LDI  R31,HIGH(680)
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0xC
	__GETD1N 0xAA
	CALL __GTD12
	MOV  R0,R30
	LDS  R26,_bufor_bledu
	LDS  R27,_bufor_bledu+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LDS  R26,_kkk
	LDS  R27,_kkk+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1A:
	LDS  R30,_bufor_bledu
	LDS  R31,_bufor_bledu+1
	RCALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	STS  _kkk,R30
	STS  _kkk+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x1D:
	SBI  0x3,5
	__DELAY_USW 4000
	CBI  0x3,5
	__DELAY_USW 4000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1E:
	SBI  0x3,5
	__DELAY_USW 8000
	CBI  0x3,5
	__DELAY_USW 8000
	SBI  0x3,5
	__DELAY_USW 16000
	CBI  0x3,5
	__DELAY_USW 16000
	SBI  0x3,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R26,_basia1
	LDS  R27,_basia1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_basia1)
	LDI  R27,HIGH(_basia1)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	SBI  0x3,5
	__DELAY_USW 16000
	CBI  0x3,5
	__DELAY_USW 16000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _wcisnalem_pedal,R30
	STS  _wcisnalem_pedal+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x2


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__GTD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLT __GTD12T
	CLR  R30
__GTD12T:
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

;END OF CODE MARKER
__END_OF_CODE:
