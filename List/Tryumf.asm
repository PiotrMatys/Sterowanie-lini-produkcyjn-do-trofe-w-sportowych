
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
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
	.DEF _monter_1_skonczyl=R4
	.DEF _monter_2_skonczyl=R6
	.DEF _monter_3_skonczyl=R8
	.DEF _monterzy_skonczyli=R10
	.DEF _start=R12

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
	JMP  0x00
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

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x49,0x6E,0x69,0x63,0x6A,0x61,0x6C
	.DB  0x69,0x7A,0x75,0x6A,0x65,0x20,0x6D,0x61
	.DB  0x73,0x7A,0x79,0x6E,0x65,0x0,0x57,0x79
	.DB  0x63,0x7A,0x79,0x73,0x7A,0x63,0x7A,0x6F
	.DB  0x6E,0x6F,0x20,0x6D,0x61,0x73,0x7A,0x79
	.DB  0x6E,0x65,0x0,0x4D,0x61,0x73,0x7A,0x79
	.DB  0x6E,0x61,0x20,0x7A,0x61,0x69,0x6E,0x69
	.DB  0x63,0x6A,0x61,0x6C,0x69,0x7A,0x6F,0x77
	.DB  0x61,0x6E,0x61,0x0,0x43,0x7A,0x65,0x6B
	.DB  0x61,0x6D,0x20,0x6E,0x61,0x20,0x70,0x72
	.DB  0x65,0x74,0x20,0x67,0x77,0x69,0x6E,0x74
	.DB  0x6F,0x77,0x61,0x6E,0x79,0x0,0x50,0x72
	.DB  0x61,0x63,0x61,0x0,0x5A,0x61,0x6B,0x72
	.DB  0x65,0x63,0x69,0x6C,0x65,0x6D,0x20,0x77
	.DB  0x73,0x7A,0x79,0x73,0x74,0x6B,0x69,0x65
	.DB  0x20,0x7A,0x61,0x64,0x61,0x6E,0x65,0x20
	.DB  0x70,0x75,0x63,0x68,0x61,0x72,0x79,0x0
	.DB  0x42,0x72,0x61,0x6B,0x20,0x77,0x79,0x6D
	.DB  0x61,0x67,0x61,0x6E,0x65,0x67,0x6F,0x20
	.DB  0x63,0x69,0x73,0x6E,0x69,0x65,0x6E,0x69
	.DB  0x61,0x20,0x36,0x20,0x62,0x61,0x72,0x0
	.DB  0x44,0x6F,0x7A,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x6B,0x6C,0x65,0x6A,0x75,0x20,0x70
	.DB  0x72,0x65,0x74,0x6F,0x77,0x20,0x6E,0x69
	.DB  0x65,0x20,0x67,0x6F,0x74,0x6F,0x77,0x79
	.DB  0x0,0x44,0x6F,0x7A,0x6F,0x77,0x6E,0x69
	.DB  0x6B,0x20,0x6B,0x6C,0x65,0x6A,0x75,0x20
	.DB  0x6E,0x61,0x6B,0x72,0x65,0x74,0x65,0x6B
	.DB  0x20,0x6E,0x69,0x65,0x20,0x67,0x6F,0x74
	.DB  0x6F,0x77,0x79,0x0,0x57,0x79,0x6C,0x61
	.DB  0x63,0x7A,0x20,0x6D,0x61,0x73,0x7A,0x79
	.DB  0x6E,0x65,0x20,0x69,0x20,0x70,0x6F,0x63
	.DB  0x7A,0x65,0x6B,0x61,0x6A,0x20,0x31,0x20
	.DB  0x6D,0x69,0x6E,0x75,0x74,0x65,0x0,0x4F
	.DB  0x64,0x73,0x6C,0x6F,0x6E,0x20,0x69,0x20
	.DB  0x7A,0x72,0x65,0x73,0x65,0x74,0x75,0x6A
	.DB  0x20,0x6B,0x75,0x72,0x74,0x79,0x6E,0x65
	.DB  0x0,0x4D,0x6F,0x6E,0x74,0x65,0x72,0x20
	.DB  0x33,0x20,0x6E,0x69,0x65,0x20,0x6E,0x61
	.DB  0x63,0x69,0x73,0x6E,0x61,0x6C,0x20,0x70
	.DB  0x65,0x64,0x61,0x6C,0x61,0x0,0x43,0x7A
	.DB  0x65,0x6B,0x61,0x6D,0x20,0x6E,0x61,0x20
	.DB  0x72,0x75,0x63,0x68,0x20,0x6C,0x61,0x6E
	.DB  0x63,0x75,0x63,0x68,0x61,0x0,0x50,0x6F
	.DB  0x70,0x72,0x61,0x77,0x20,0x70,0x72,0x65
	.DB  0x74,0x20,0x7A,0x20,0x67,0x72,0x7A,0x79
	.DB  0x62,0x6B,0x69,0x65,0x6D,0x20,0x69,0x20
	.DB  0x6E,0x61,0x63,0x69,0x73,0x6E,0x69,0x6A
	.DB  0x20,0x67,0x75,0x7A,0x69,0x6B,0x0,0x55
	.DB  0x73,0x75,0x6E,0x20,0x70,0x72,0x65,0x74
	.DB  0x20,0x7A,0x65,0x20,0x73,0x7A,0x63,0x7A
	.DB  0x65,0x6B,0x20,0x69,0x20,0x6E,0x61,0x63
	.DB  0x69,0x73,0x6E,0x69,0x6A,0x20,0x67,0x75
	.DB  0x7A,0x69,0x6B,0x0,0x57,0x79,0x6D,0x69
	.DB  0x65,0x6E,0x20,0x6C,0x75,0x62,0x20,0x6E
	.DB  0x61,0x6B,0x72,0x65,0x63,0x2F,0x64,0x6F
	.DB  0x6B,0x72,0x65,0x63,0x20,0x67,0x72,0x7A
	.DB  0x79,0x62,0x65,0x6B,0x20,0x69,0x20,0x6E
	.DB  0x61,0x63,0x69,0x73,0x6E,0x69,0x6A,0x20
	.DB  0x67,0x75,0x7A,0x69,0x6B,0x0,0x4D,0x6F
	.DB  0x6E,0x74,0x65,0x72,0x20,0x33,0x20,0x2D
	.DB  0x20,0x7A,0x64,0x65,0x6D,0x6F,0x6E,0x74
	.DB  0x75,0x6A,0x20,0x70,0x75,0x63,0x68,0x61
	.DB  0x72,0x20,0x69,0x20,0x70,0x6F,0x74,0x77
	.DB  0x69,0x65,0x72,0x64,0x7A,0x0,0x4D,0x6F
	.DB  0x6E,0x74,0x65,0x72,0x20,0x33,0x20,0x2D
	.DB  0x20,0x77,0x79,0x7A,0x77,0x6F,0x6C,0x20
	.DB  0x72,0x65,0x63,0x7A,0x6E,0x69,0x65,0x20
	.DB  0x63,0x7A,0x75,0x6A,0x6E,0x69,0x6B,0x20
	.DB  0x70,0x75,0x63,0x68,0x61,0x72,0x61,0x0
	.DB  0x53,0x4C,0x41,0x56,0x45,0x20,0x6E,0x69
	.DB  0x65,0x20,0x70,0x6F,0x74,0x77,0x69,0x65
	.DB  0x72,0x64,0x7A,0x69,0x6C,0x20,0x70,0x6F
	.DB  0x64,0x61,0x6E,0x69,0x61,0x20,0x6E,0x61
	.DB  0x6B,0x72,0x65,0x74,0x6B,0x69,0x0,0x53
	.DB  0x4C,0x41,0x56,0x45,0x20,0x6E,0x69,0x65
	.DB  0x20,0x70,0x6F,0x74,0x77,0x69,0x65,0x72
	.DB  0x64,0x7A,0x69,0x6C,0x20,0x7A,0x65,0x7A
	.DB  0x77,0x6F,0x6C,0x65,0x6E,0x69,0x61,0x20
	.DB  0x6E,0x61,0x20,0x73,0x7A,0x63,0x7A,0x65
	.DB  0x6B,0x69,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x30,0x25
	.DB  0x64,0x0,0x3A,0x0
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
;Date    : 2016-11-18
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
;#include <io.h>
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
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0025 {

	.CSEG
; 0000 0026 unsigned char status;
; 0000 0027 char data;
; 0000 0028 while (1)
;	status -> R17
;	data -> R16
; 0000 0029       {
; 0000 002A       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 002B       data=UDR1;
; 0000 002C       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 002D          return data;
; 0000 002E       }
; 0000 002F }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 0035 {
; 0000 0036 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0037 UDR1=c;
; 0000 0038 }
;#pragma used-
;
;
;#include <stdio.h>
;#include <mega128.h>
;#include <delay.h>
;//#include <alcd.h>
;#include <string.h>
;#include <stdlib.h>
;#include <math.h>
;
;int skonczony_proces[10];
;int proces[10];
;int monter_1_skonczyl,monter_2_skonczyl,monter_3_skonczyl,monterzy_skonczyli;
;int start;
;int licznik_pucharow;
;int licznik;
;int jest_pret_pod_czujnikami;
;int czas_silnika_dokrecajacego_grzybki, czas_silnika_dokrecajacego_grzybki_stala;
;int il_pretow_gwintowanych;
;int dlugosc_preta_gwintowanego;
;long int sek0,sek1,sek2,sek3;
;long int sek0_7s,sek1_7s,sek2_7s,sek3_7s;
;long int czas_monterow,czas_na_transport_preta;
;long int monter_1_time, monter_2_time, monter_3_time;
;long int stala_czasowa;
;int licznik_spoznien_monter_1,licznik_spoznien_monter_2, licznik_spoznien_monter_3;
;int licznik_spoznien_monter_1_2, licznik_spoznien_monter_3_nowy;
;int d,dd,gg,klej,klej_slave,monter_slave;
;//char *dupa1;
;//int i,ff;
;int ff;
;char z;
;int grzybek;
;int il_grzybkow,kontrola_grzybkow;
;int licz;
;int grzybek_biezacy_dokrecony;
;int grzybek_dokrecony;
;int oproznij_podajnik;
;int metalowe_grzybki;
;int zajechalem,sekwencja;
;int pierwszy_raz;
;int czas_monterow_stala;
;int il_pretow_gwintowanych_stala;
;int oczekiwanie_na_poprawienie;
;int potw_zielonym_bo_pomyliles_pedal_z_potwierdz;
;int czekaj_komunikat;
;int przejechalem_czujnik_lub_jestem_na_nim;
;int licznik_niezakreconych_grzybkow;
;int grzybek_jest_nakrecony_na_precie;
;int licznik_wylatujacych_grzybkow;
;int licznik_wyzwolen_kurtyny;
;int licznik_pucharow_global;
;long int czas_zaloczonego_orientatora;
;int zaloczono_kurtyne;
;int anuluj_biezace_zlecenie;
;int licznik_niewlozonych_pretow_z_grzybkiem;
;int anuluj_biezace_zlecenie_const;
;int msek_clock;
;int sek_clock, min_clock, godz_clock;
;int przez_sek_clock, przez_min_clock, przez_godz_clock;
;
;int tryb_male_puchary;
;int predkosc_wiezyczek_male_puchary;
;int wynik_wyboru_male_puchary;
;int wielkosc_kamienia;
;
;
;
;//int dupcia;
;//int wynik;
;//int wynik1;
;//int oleole;
;
;
;void sterowanie_tasmociagami_monterow()
; 0000 0085 {
; 0000 0086 /*
; 0000 0087 
; 0000 0088 if(PINF.0 == 0)
; 0000 0089     PORTD.7 = 1;
; 0000 008A else                //tasma 1
; 0000 008B     PORTD.7 = 0;
; 0000 008C 
; 0000 008D if(PINF.1 == 0)
; 0000 008E     PORTD.6 = 1;
; 0000 008F else                //tasma 2
; 0000 0090     PORTD.6 = 0;
; 0000 0091 
; 0000 0092 */
; 0000 0093 }
;
;void zerowanie_czasu()
; 0000 0096 {
_zerowanie_czasu:
; 0000 0097 msek_clock = 0;
	CALL SUBOPT_0x0
; 0000 0098 sek_clock = 0;
	CALL SUBOPT_0x1
; 0000 0099 min_clock = 0;
	CALL SUBOPT_0x2
; 0000 009A godz_clock = 0;
	LDI  R30,LOW(0)
	STS  _godz_clock,R30
	STS  _godz_clock+1,R30
; 0000 009B }
	RET
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 009F {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A0 sek0++;
	LDI  R26,LOW(_sek0)
	LDI  R27,HIGH(_sek0)
	CALL SUBOPT_0x3
; 0000 00A1 sek1++;
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x3
; 0000 00A2 sek2++;
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x3
; 0000 00A3 sek3++;
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x3
; 0000 00A4 
; 0000 00A5 msek_clock++;
	LDI  R26,LOW(_msek_clock)
	LDI  R27,HIGH(_msek_clock)
	CALL SUBOPT_0x4
; 0000 00A6 if(msek_clock == 60)
	LDS  R26,_msek_clock
	LDS  R27,_msek_clock+1
	SBIW R26,60
	BRNE _0xD
; 0000 00A7      {
; 0000 00A8      msek_clock = 0;
	CALL SUBOPT_0x0
; 0000 00A9      sek_clock++;
	LDI  R26,LOW(_sek_clock)
	LDI  R27,HIGH(_sek_clock)
	CALL SUBOPT_0x4
; 0000 00AA      if(sek_clock == 60)
	CALL SUBOPT_0x5
	SBIW R26,60
	BRNE _0xE
; 0000 00AB         {
; 0000 00AC         sek_clock = 0;
	CALL SUBOPT_0x1
; 0000 00AD         min_clock++;
	LDI  R26,LOW(_min_clock)
	LDI  R27,HIGH(_min_clock)
	CALL SUBOPT_0x4
; 0000 00AE         if(min_clock == 60)
	CALL SUBOPT_0x6
	SBIW R26,60
	BRNE _0xF
; 0000 00AF             {
; 0000 00B0             min_clock = 0;
	CALL SUBOPT_0x2
; 0000 00B1             godz_clock++;
	LDI  R26,LOW(_godz_clock)
	LDI  R27,HIGH(_godz_clock)
	CALL SUBOPT_0x4
; 0000 00B2             }
; 0000 00B3         }
_0xF:
; 0000 00B4      }
_0xE:
; 0000 00B5 
; 0000 00B6 //16 mhz =
; 0000 00B7 //co 1/16000s wykonywana jest operacja
; 0000 00B8 //co 1/15,625 whodzi tam
; 0000 00B9 //co 1024 jest 1s
; 0000 00BA 
; 0000 00BB 
; 0000 00BC 
; 0000 00BD 
; 0000 00BE 
; 0000 00BF //sek0_7s++;
; 0000 00C0 
; 0000 00C1 //sek1_7s++;
; 0000 00C2 
; 0000 00C3 //sek2_7s++;
; 0000 00C4 
; 0000 00C5 //sek3_7s++;
; 0000 00C6 //if(z == 1)
; 0000 00C7 //    {
; 0000 00C8 //    monter_1_time++;
; 0000 00C9 //    monter_2_time++;
; 0000 00CA //    monter_3_time++;
; 0000 00CB //    }
; 0000 00CC //if(start == 0)
; 0000 00CD     //sterowanie_tasmociagami_monterow();
; 0000 00CE }
_0xD:
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
;
;void orientator_grzybkow()
; 0000 00D3 {
_orientator_grzybkow:
; 0000 00D4 
; 0000 00D5 if(PINA.1 == 1)
	SBIC 0x19,1
; 0000 00D6     {
; 0000 00D7     PORTD.4 = 1;
	SBI  0x12,4
; 0000 00D8     //if(grzybek == 0)
; 0000 00D9     //   {
; 0000 00DA     //   il_grzybkow++;
; 0000 00DB     //   grzybek = 1;
; 0000 00DC     //
; 0000 00DD     }
; 0000 00DE if(PORTD.4 == 1 & PINA.1 == 0)
	LDI  R26,0
	SBIC 0x12,4
	LDI  R26,1
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	AND  R30,R0
	BREQ _0x13
; 0000 00DF     czas_zaloczonego_orientatora++;
	LDI  R26,LOW(_czas_zaloczonego_orientatora)
	LDI  R27,HIGH(_czas_zaloczonego_orientatora)
	CALL SUBOPT_0x3
; 0000 00E0 
; 0000 00E1 if(PINA.1 == 0 & czas_zaloczonego_orientatora > 100000) //zmieniam z 10000
_0x13:
	CALL SUBOPT_0x8
	MOV  R0,R30
	LDS  R26,_czas_zaloczonego_orientatora
	LDS  R27,_czas_zaloczonego_orientatora+1
	LDS  R24,_czas_zaloczonego_orientatora+2
	LDS  R25,_czas_zaloczonego_orientatora+3
	CALL SUBOPT_0x9
	AND  R30,R0
	BREQ _0x14
; 0000 00E2     {
; 0000 00E3     czas_zaloczonego_orientatora = 0;
	CALL SUBOPT_0xA
; 0000 00E4     PORTD.4 = 0;
	CBI  0x12,4
; 0000 00E5     grzybek = 0;
	LDI  R30,LOW(0)
	STS  _grzybek,R30
	STS  _grzybek+1,R30
; 0000 00E6     }
; 0000 00E7 
; 0000 00E8 
; 0000 00E9 }
_0x14:
	RET
;
;int kontrola_grzyb()
; 0000 00EC {
_kontrola_grzyb:
; 0000 00ED int k;
; 0000 00EE 
; 0000 00EF /*
; 0000 00F0 if(il_grzybkow < 7)
; 0000 00F1     k = 0;
; 0000 00F2 else
; 0000 00F3     k = 1;
; 0000 00F4 if(il_grzybkow >= 7 | PINA.1 == 0)
; 0000 00F5     k = 1;
; 0000 00F6 
; 0000 00F7 */
; 0000 00F8 
; 0000 00F9 k = 1; //na pewno beda grzybki
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	__GETWRN 16,17,1
; 0000 00FA 
; 0000 00FB 
; 0000 00FC return k;
	MOVW R30,R16
	RJMP _0x20A0006
; 0000 00FD }
;
;
;void inicjalizacja_orientator_grzybkow()
; 0000 0101 {
_inicjalizacja_orientator_grzybkow:
; 0000 0102 int g;
; 0000 0103 g = 0;
	CALL SUBOPT_0xB
;	g -> R16,R17
; 0000 0104 
; 0000 0105 
; 0000 0106 while(PINA.1 == 1)
_0x17:
	SBIS 0x19,1
	RJMP _0x19
; 0000 0107    PORTD.4 = 1;
	SBI  0x12,4
	RJMP _0x17
_0x19:
; 0000 0108 delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 0109 PORTD.4 = 0;
; 0000 010A 
; 0000 010B while(g<20)
_0x1E:
	__CPWRN 16,17,20
	BRGE _0x20
; 0000 010C     {
; 0000 010D     if(PINA.1 == 1)
	SBIS 0x19,1
	RJMP _0x21
; 0000 010E         {
; 0000 010F         while(PINA.1 == 1)
_0x22:
	SBIS 0x19,1
	RJMP _0x24
; 0000 0110             PORTD.4 = 1;
	SBI  0x12,4
	RJMP _0x22
_0x24:
; 0000 0111 delay_ms(2000);
	CALL SUBOPT_0xC
; 0000 0112         PORTD.4 = 0;
; 0000 0113         }
; 0000 0114     g++;
_0x21:
	__ADDWRN 16,17,1
; 0000 0115     }
	RJMP _0x1E
_0x20:
; 0000 0116 
; 0000 0117 
; 0000 0118 
; 0000 0119 il_grzybkow = 20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _il_grzybkow,R30
	STS  _il_grzybkow+1,R31
; 0000 011A }
_0x20A0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;void wylacz_maszyne()
; 0000 011E {
_wylacz_maszyne:
; 0000 011F putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0120 putchar(165); //A5
; 0000 0121 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 0122 putchar(130);  //82
; 0000 0123 putchar(0);    //00
; 0000 0124 putchar(48);   //adres zmiennej 30
	CALL SUBOPT_0xF
; 0000 0125 putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 0126 putchar(0);   //0
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 0127 }
;
;int czekaj_na_guzik_start()
; 0000 012A {
_czekaj_na_guzik_start:
; 0000 012B z = 0;
	LDI  R30,LOW(0)
	STS  _z,R30
; 0000 012C putchar(90);
	CALL SUBOPT_0xD
; 0000 012D putchar(165);
; 0000 012E putchar(4);
	CALL SUBOPT_0x11
; 0000 012F putchar(131);
; 0000 0130 putchar(0);
; 0000 0131 putchar(48);  //adres zmiennej - 30
	CALL SUBOPT_0xF
; 0000 0132 putchar(1);
	CALL SUBOPT_0x12
; 0000 0133 getchar();
; 0000 0134 getchar();
; 0000 0135 getchar();
; 0000 0136 getchar();
; 0000 0137 getchar();
; 0000 0138 getchar();
; 0000 0139 getchar();
; 0000 013A getchar();
; 0000 013B z = getchar();
	STS  _z,R30
; 0000 013C //itoa(z,dupa1);
; 0000 013D //lcd_puts(dupa1);
; 0000 013E 
; 0000 013F return z;
	LDI  R31,0
	RET
; 0000 0140 }
;
;
;void ustaw_na_nie_anulacje_zlecenia()
; 0000 0144 {
_ustaw_na_nie_anulacje_zlecenia:
; 0000 0145 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0146 putchar(165); //A5
; 0000 0147 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 0148 putchar(130);  //82    //zmienie na anulowanie zlecenia
; 0000 0149 putchar(0);    //00
; 0000 014A putchar(96);   //60
	CALL SUBOPT_0x13
; 0000 014B putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 014C putchar(1);   //1
	LDI  R30,LOW(1)
	RJMP _0x20A0004
; 0000 014D }
;
;void kontrola_lampki_brak_pretow()
; 0000 0150 {
_kontrola_lampki_brak_pretow:
; 0000 0151 if(PINA.6 == 0)
	SBIC 0x19,6
	RJMP _0x29
; 0000 0152     PORTD.7 = 0;
	CBI  0x12,7
; 0000 0153 else
	RJMP _0x2C
_0x29:
; 0000 0154     PORTD.7 = 1;
	SBI  0x12,7
; 0000 0155 }
_0x2C:
	RET
;
;int wyczysc_grzebienie()
; 0000 0158 {
; 0000 0159 int wynik;
; 0000 015A wynik = 0;
;	wynik -> R16,R17
; 0000 015B 
; 0000 015C switch(proces[1])
; 0000 015D     {
; 0000 015E     case 0:
; 0000 015F         sek1_7s = 0;
; 0000 0160         sek1 = 0;
; 0000 0161         proces[1] = 1;
; 0000 0162     break;
; 0000 0163 
; 0000 0164     case 1:
; 0000 0165             if(sek1 > 100)
; 0000 0166                 {
; 0000 0167                 if(PINA.4 == 0)
; 0000 0168                     {
; 0000 0169                     PORTB.7 = 0;  //zakoncz dociskanie preta
; 0000 016A                     PORTD.0 = 1; //rozpcznij przeniesienie pret do nakladania kleju
; 0000 016B                     }
; 0000 016C                 else
; 0000 016D                     {
; 0000 016E                     PORTD.0 = 1; //czujnik juz nie swieci, czyli jade dalej
; 0000 016F                     sek1 = 0;
; 0000 0170                     proces[1] = 2;
; 0000 0171                     }
; 0000 0172                 }
; 0000 0173     break;
; 0000 0174     case 2:
; 0000 0175             if(PINA.4 == 0)  //dojechalem znowu do czujnika
; 0000 0176                 {
; 0000 0177                 PORTD.0 = 0; //wylacz silnik
; 0000 0178                 proces[1] = 3;
; 0000 0179                 }
; 0000 017A     break;
; 0000 017B 
; 0000 017C     case 3:
; 0000 017D                 sek1 = 0;
; 0000 017E                 proces[1] = 0;
; 0000 017F                 wynik = 1;
; 0000 0180     break;
; 0000 0181     }
; 0000 0182 
; 0000 0183 return wynik;
; 0000 0184 }
;
;void wydaj_dzwiek()
; 0000 0187 {
_wydaj_dzwiek:
; 0000 0188 licz++;
	LDI  R26,LOW(_licz)
	LDI  R27,HIGH(_licz)
	CALL SUBOPT_0x4
; 0000 0189 if(licz >= 100);
; 0000 018A     {
; 0000 018B     licz = 0;
	CALL SUBOPT_0x14
; 0000 018C     putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 018D     putchar(165); //A5
; 0000 018E     putchar(3);//03
	CALL SUBOPT_0x15
; 0000 018F     putchar(128);  //80    //dzwiek
; 0000 0190     putchar(2);    //02
; 0000 0191     putchar(16);   //10
	RJMP _0x20A0004
; 0000 0192     }
; 0000 0193 }
;
;
;
;
;void komunikat_1_na_panel()
; 0000 0199 {
_komunikat_1_na_panel:
; 0000 019A putchar(90);
	CALL SUBOPT_0xD
; 0000 019B putchar(165);
; 0000 019C putchar(35);       //ilosc liter 43 + 3
	CALL SUBOPT_0x16
; 0000 019D putchar(130);  //82
; 0000 019E putchar(0);    //0
; 0000 019F putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01A0 printf("                                        ");
	CALL SUBOPT_0x18
; 0000 01A1 
; 0000 01A2 putchar(90);
; 0000 01A3 putchar(165);
; 0000 01A4 putchar(23);       //ilosc liter 20 + 3
	LDI  R30,LOW(23)
	CALL SUBOPT_0x19
; 0000 01A5 putchar(130);  //82
; 0000 01A6 putchar(0);    //0
; 0000 01A7 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01A8 printf("Inicjalizuje maszyne");
	__POINTW1FN _0x0,41
	RJMP _0x20A0005
; 0000 01A9 }
;
;void komunikat_2_na_panel()
; 0000 01AC {
; 0000 01AD putchar(90);
; 0000 01AE putchar(165);
; 0000 01AF putchar(23);       //ilosc liter 20 + 3
; 0000 01B0 putchar(130);  //82
; 0000 01B1 putchar(0);    //0
; 0000 01B2 putchar(144);  //adres 90 - 144
; 0000 01B3 printf("Wyczyszczono maszyne");
; 0000 01B4 }
;
;void komunikat_3_na_panel()
; 0000 01B7 {
_komunikat_3_na_panel:
; 0000 01B8 putchar(90);
	CALL SUBOPT_0xD
; 0000 01B9 putchar(165);
; 0000 01BA putchar(27);       //ilosc liter 20 + 3
	LDI  R30,LOW(27)
	CALL SUBOPT_0x19
; 0000 01BB putchar(130);  //82
; 0000 01BC putchar(0);    //0
; 0000 01BD putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01BE printf("Maszyna zainicjalizowana");
	__POINTW1FN _0x0,83
	RJMP _0x20A0005
; 0000 01BF }
;
;void komunikat_4_na_panel()
; 0000 01C2 {
_komunikat_4_na_panel:
; 0000 01C3 putchar(90);
	CALL SUBOPT_0xD
; 0000 01C4 putchar(165);
; 0000 01C5 putchar(28);       //ilosc liter 25 + 3
	LDI  R30,LOW(28)
	CALL SUBOPT_0x19
; 0000 01C6 putchar(130);  //82
; 0000 01C7 putchar(0);    //0
; 0000 01C8 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01C9 printf("Czekam na pret gwintowany");
	__POINTW1FN _0x0,108
	RJMP _0x20A0005
; 0000 01CA }
;
;void komunikat_5_na_panel()
; 0000 01CD {
_komunikat_5_na_panel:
; 0000 01CE putchar(90);
	CALL SUBOPT_0xD
; 0000 01CF putchar(165);
; 0000 01D0 putchar(35);       //ilosc liter 43 + 3
	CALL SUBOPT_0x16
; 0000 01D1 putchar(130);  //82
; 0000 01D2 putchar(0);    //0
; 0000 01D3 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01D4 printf("                                        ");
	CALL SUBOPT_0x18
; 0000 01D5 
; 0000 01D6 putchar(90);
; 0000 01D7 putchar(165);
; 0000 01D8 putchar(8);       //ilosc liter 5 + 3
	LDI  R30,LOW(8)
	CALL SUBOPT_0x19
; 0000 01D9 putchar(130);  //82
; 0000 01DA putchar(0);    //0
; 0000 01DB putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01DC printf("Praca");
	__POINTW1FN _0x0,134
	RJMP _0x20A0005
; 0000 01DD }
;
;void komunikat_6_na_panel()
; 0000 01E0 {
_komunikat_6_na_panel:
; 0000 01E1 putchar(90);
	CALL SUBOPT_0xD
; 0000 01E2 putchar(165);
; 0000 01E3 putchar(27);       //ilosc liter 24 + 3
	LDI  R30,LOW(27)
	CALL SUBOPT_0x19
; 0000 01E4 putchar(130);  //82
; 0000 01E5 putchar(0);    //0
; 0000 01E6 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01E7 printf("                        ");
	__POINTW1FN _0x0,16
	CALL SUBOPT_0x1A
; 0000 01E8 
; 0000 01E9 putchar(90);
	CALL SUBOPT_0xD
; 0000 01EA putchar(165);
; 0000 01EB putchar(38);       //ilosc liter 35 + 3
	LDI  R30,LOW(38)
	CALL SUBOPT_0x19
; 0000 01EC putchar(130);  //82
; 0000 01ED putchar(0);    //0
; 0000 01EE putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01EF printf("Zakrecilem wszystkie zadane puchary");
	__POINTW1FN _0x0,140
	RJMP _0x20A0005
; 0000 01F0 }
;
;void komunikat_7_na_panel()
; 0000 01F3 {
_komunikat_7_na_panel:
; 0000 01F4 putchar(90);
	CALL SUBOPT_0xD
; 0000 01F5 putchar(165);
; 0000 01F6 putchar(34);       //ilosc liter 31 + 3
	LDI  R30,LOW(34)
	CALL SUBOPT_0x19
; 0000 01F7 putchar(130);  //82
; 0000 01F8 putchar(0);    //0
; 0000 01F9 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 01FA printf("Brak wymaganego cisnienia 6 bar");
	__POINTW1FN _0x0,176
	RJMP _0x20A0005
; 0000 01FB }
;
;void komunikat_8_na_panel(int i)
; 0000 01FE {
; 0000 01FF if(i == 0)
;	i -> Y+0
; 0000 0200     {
; 0000 0201     putchar(90);
; 0000 0202     putchar(165);
; 0000 0203     putchar(35);       //ilosc liter 32 + 3
; 0000 0204     putchar(130);  //82
; 0000 0205     putchar(0);    //0
; 0000 0206     putchar(144);  //adres 70 - 112
; 0000 0207     printf("Dozownik kleju pretow nie gotowy");
; 0000 0208     }
; 0000 0209 if(i == 1)
; 0000 020A     {
; 0000 020B     putchar(90);
; 0000 020C     putchar(165);
; 0000 020D     putchar(37);       //ilosc liter 34 + 3
; 0000 020E     putchar(130);  //82
; 0000 020F     putchar(0);    //0
; 0000 0210     putchar(144);  //adres 90 - 144
; 0000 0211     printf("Dozownik kleju nakretek nie gotowy");
; 0000 0212     }
; 0000 0213 }
;
;void komunikat_9_na_panel()
; 0000 0216 {
_komunikat_9_na_panel:
; 0000 0217 putchar(90);
	CALL SUBOPT_0xD
; 0000 0218 putchar(165);
; 0000 0219 putchar(37);       //ilosc liter 34 + 3
	LDI  R30,LOW(37)
	CALL SUBOPT_0x19
; 0000 021A putchar(130);  //82
; 0000 021B putchar(0);    //0
; 0000 021C putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 021D printf("Wylacz maszyne i poczekaj 1 minute");
	__POINTW1FN _0x0,276
	RJMP _0x20A0005
; 0000 021E }
;
;void komunikat_10_na_panel()
; 0000 0221 {
_komunikat_10_na_panel:
; 0000 0222 putchar(90);
	CALL SUBOPT_0xD
; 0000 0223 putchar(165);
; 0000 0224 putchar(28);       //ilosc liter 25 + 3
	LDI  R30,LOW(28)
	CALL SUBOPT_0x19
; 0000 0225 putchar(130);  //82
; 0000 0226 putchar(0);    //0
; 0000 0227 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 0228 printf("Odslon i zresetuj kurtyne");
	__POINTW1FN _0x0,311
	RJMP _0x20A0005
; 0000 0229 }
;
;void komunikat_11_na_panel()
; 0000 022C {
_komunikat_11_na_panel:
; 0000 022D putchar(90);
	CALL SUBOPT_0xD
; 0000 022E putchar(165);
; 0000 022F putchar(31);       //ilosc liter 28 + 3
	LDI  R30,LOW(31)
	CALL SUBOPT_0x19
; 0000 0230 putchar(130);  //82
; 0000 0231 putchar(0);    //0
; 0000 0232 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 0233 printf("Monter 3 nie nacisnal pedala");
	__POINTW1FN _0x0,337
	RJMP _0x20A0005
; 0000 0234 }
;
;void komunikat_12_na_panel()
; 0000 0237 {
_komunikat_12_na_panel:
; 0000 0238 putchar(90);
	CALL SUBOPT_0xD
; 0000 0239 putchar(165);
; 0000 023A putchar(26);       //ilosc liter 23 + 3
	LDI  R30,LOW(26)
	CALL SUBOPT_0x19
; 0000 023B putchar(130);  //82
; 0000 023C putchar(0);    //0
; 0000 023D putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 023E printf("Czekam na ruch lancucha");
	__POINTW1FN _0x0,366
	RJMP _0x20A0005
; 0000 023F }
;
;void komunikat_14_na_panel()
; 0000 0242 {
_komunikat_14_na_panel:
; 0000 0243 putchar(90);
	CALL SUBOPT_0xD
; 0000 0244 putchar(165);
; 0000 0245 putchar(43);       //ilosc liter 40 + 3
	LDI  R30,LOW(43)
	CALL SUBOPT_0x19
; 0000 0246 putchar(130);  //82
; 0000 0247 putchar(0);    //0
; 0000 0248 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 0249 printf("Popraw pret z grzybkiem i nacisnij guzik");
	__POINTW1FN _0x0,390
	RJMP _0x20A0005
; 0000 024A }
;
;void komunikat_13_na_panel()
; 0000 024D {
_komunikat_13_na_panel:
; 0000 024E putchar(90);
	CALL SUBOPT_0xD
; 0000 024F putchar(165);
; 0000 0250 putchar(39);       //ilosc liter 36 + 3
	LDI  R30,LOW(39)
	CALL SUBOPT_0x19
; 0000 0251 putchar(130);  //82
; 0000 0252 putchar(0);    //0
; 0000 0253 putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 0254 printf("Usun pret ze szczek i nacisnij guzik");
	__POINTW1FN _0x0,431
	RJMP _0x20A0005
; 0000 0255 }
;
;void komunikat_15_na_panel()
; 0000 0258 {
_komunikat_15_na_panel:
; 0000 0259 putchar(90);
	CALL SUBOPT_0xD
; 0000 025A putchar(165);
; 0000 025B putchar(52);       //ilosc liter 42 + 3  //49+3
	LDI  R30,LOW(52)
	CALL SUBOPT_0x19
; 0000 025C putchar(130);  //82
; 0000 025D putchar(0);    //0
; 0000 025E putchar(144);  //adres 90 - 144
	CALL SUBOPT_0x17
; 0000 025F printf("Wymien lub nakrec/dokrec grzybek i nacisnij guzik");
	__POINTW1FN _0x0,468
	RJMP _0x20A0005
; 0000 0260 }
;
;void komunikat_16_na_panel()
; 0000 0263 {
; 0000 0264 putchar(90);
; 0000 0265 putchar(165);
; 0000 0266 putchar(42);       //ilosc liter 39 + 3
; 0000 0267 putchar(130);  //82
; 0000 0268 putchar(0);    //0
; 0000 0269 putchar(144);  //adres 90 - 144
; 0000 026A printf("Monter 3 - zdemontuj puchar i potwierdz");
; 0000 026B }
;
;void komunikat_17_na_panel()
; 0000 026E {
; 0000 026F putchar(90);
; 0000 0270 putchar(165);
; 0000 0271 putchar(44);       //ilosc liter 41 + 3
; 0000 0272 putchar(130);  //82
; 0000 0273 putchar(0);    //0
; 0000 0274 putchar(144);  //adres 90 - 144
; 0000 0275 printf("Monter 3 - wyzwol recznie czujnik puchara");  //41
; 0000 0276 }
;
;
;void komunikat_18_na_panel()
; 0000 027A {
; 0000 027B putchar(90);
; 0000 027C putchar(165);
; 0000 027D putchar(41);       //ilosc liter 38 + 3
; 0000 027E putchar(130);  //82
; 0000 027F putchar(0);    //0
; 0000 0280 putchar(144);  //adres 90 - 144
; 0000 0281 printf("SLAVE nie potwierdzil podania nakretki");  //41
; 0000 0282 }
;
;void komunikat_19_na_panel()
; 0000 0285 {
; 0000 0286 putchar(90);
; 0000 0287 putchar(165);
; 0000 0288 putchar(46);       //ilosc liter 43 + 3
; 0000 0289 putchar(130);  //82
; 0000 028A putchar(0);    //0
; 0000 028B putchar(144);  //adres 90 - 144
; 0000 028C printf("SLAVE nie potwierdzil zezwolenia na szczeki");  //43
; 0000 028D }
;
;void komunikat_czysc_na_panel()
; 0000 0290 {
_komunikat_czysc_na_panel:
; 0000 0291 putchar(90);
	CALL SUBOPT_0xD
; 0000 0292 putchar(165);
; 0000 0293 putchar(53); //38      //ilosc liter 50 + 3 //TU ZMIENIAM NORMALNIE SIE DODAJE??
	LDI  R30,LOW(53)
	CALL SUBOPT_0x19
; 0000 0294 putchar(130);  //82
; 0000 0295 putchar(0);    //0
; 0000 0296 putchar(144);  //adres 70 - 112
	CALL SUBOPT_0x17
; 0000 0297 printf("                                                  ");
	__POINTW1FN _0x0,683
_0x20A0005:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0298 }
	RET
;
;void przeslij_parametry_do_slave(char pomocnicza,char numer)
; 0000 029B {
; 0000 029C 
; 0000 029D int spr;
; 0000 029E 
; 0000 029F PORTE.7 = 1;//do komunikacji ¿adanie
;	pomocnicza -> Y+3
;	numer -> Y+2
;	spr -> R16,R17
; 0000 02A0 putchar1(numer);
; 0000 02A1 putchar1(pomocnicza);
; 0000 02A2 spr = getchar1();
; 0000 02A3 if(spr == 3)
; 0000 02A4     PORTE.7 = 0;//do komunikacji koniec ¿adania
; 0000 02A5 else
; 0000 02A6     {
; 0000 02A7     if(numer == 3)
; 0000 02A8         komunikat_18_na_panel();  //nie potwierdzil podania nakretki
; 0000 02A9     if(numer == 5)
; 0000 02AA         komunikat_19_na_panel();  //nie potwierdzil zezwolenia na szczeki
; 0000 02AB     PORTE.7 = 0;//do komunikacji koniec ¿adania
; 0000 02AC     }
; 0000 02AD }
;
;
;void odpytaj_parametry_z_panelu(int k)
; 0000 02B1 {
_odpytaj_parametry_z_panelu:
; 0000 02B2 char pomocnicza;
; 0000 02B3 int hh;
; 0000 02B4 int oleole;
; 0000 02B5 oleole = 0;
	CALL __SAVELOCR6
;	k -> Y+6
;	pomocnicza -> R17
;	hh -> R18,R19
;	oleole -> R20,R21
	__GETWRN 20,21,0
; 0000 02B6 z = 0;
	LDI  R30,LOW(0)
	STS  _z,R30
; 0000 02B7 pomocnicza = 0;
	LDI  R17,LOW(0)
; 0000 02B8 
; 0000 02B9 if(k == 1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x4F
; 0000 02BA {
; 0000 02BB putchar(90);
	CALL SUBOPT_0xD
; 0000 02BC putchar(165);
; 0000 02BD putchar(4);
	CALL SUBOPT_0x11
; 0000 02BE putchar(131);
; 0000 02BF putchar(0);
; 0000 02C0 putchar(64);  //adres zmiennej - 40
	CALL SUBOPT_0x1B
; 0000 02C1 putchar(1);   //dlugosc preta gwintowanego
; 0000 02C2 getchar();
; 0000 02C3 getchar();
; 0000 02C4 getchar();
; 0000 02C5 getchar();
; 0000 02C6 getchar();
; 0000 02C7 getchar();
; 0000 02C8 getchar();
; 0000 02C9 getchar();
; 0000 02CA dlugosc_preta_gwintowanego = getchar();
	LDI  R31,0
	CALL SUBOPT_0x1C
; 0000 02CB if(dlugosc_preta_gwintowanego == 60)
	CALL SUBOPT_0x1D
	SBIW R26,60
	BRNE _0x50
; 0000 02CC     dlugosc_preta_gwintowanego = 61;
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	CALL SUBOPT_0x1C
; 0000 02CD 
; 0000 02CE putchar(90);
_0x50:
	CALL SUBOPT_0xD
; 0000 02CF putchar(165);
; 0000 02D0 putchar(4);
	CALL SUBOPT_0x1E
; 0000 02D1 putchar(131);
; 0000 02D2 putchar(16);
; 0000 02D3 putchar(16);  //adres zmiennej - 1010
	CALL SUBOPT_0x1F
; 0000 02D4 putchar(1);   //czy metalowe grzybki
	CALL SUBOPT_0x12
; 0000 02D5 getchar();
; 0000 02D6 getchar();
; 0000 02D7 getchar();
; 0000 02D8 getchar();
; 0000 02D9 getchar();
; 0000 02DA getchar();
; 0000 02DB getchar();
; 0000 02DC getchar();
; 0000 02DD hh = getchar();
	CALL SUBOPT_0x20
; 0000 02DE if(hh == 0)
	BRNE _0x51
; 0000 02DF     metalowe_grzybki = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _metalowe_grzybki,R30
	STS  _metalowe_grzybki+1,R31
; 0000 02E0 else
	RJMP _0x52
_0x51:
; 0000 02E1     metalowe_grzybki = 0;
	LDI  R30,LOW(0)
	STS  _metalowe_grzybki,R30
	STS  _metalowe_grzybki+1,R30
; 0000 02E2 
; 0000 02E3 putchar(90);
_0x52:
	CALL SUBOPT_0xD
; 0000 02E4 putchar(165);
; 0000 02E5 putchar(4);
	CALL SUBOPT_0x1E
; 0000 02E6 putchar(131);
; 0000 02E7 putchar(16);
; 0000 02E8 putchar(32);  //adres zmiennej - 1020
	CALL SUBOPT_0x21
; 0000 02E9 putchar(1);   //czy oproznic podajnik grzybkow
	CALL SUBOPT_0x12
; 0000 02EA getchar();
; 0000 02EB getchar();
; 0000 02EC getchar();
; 0000 02ED getchar();
; 0000 02EE getchar();
; 0000 02EF getchar();
; 0000 02F0 getchar();
; 0000 02F1 getchar();
; 0000 02F2 hh = getchar();
	CALL SUBOPT_0x20
; 0000 02F3 if(hh == 0)
	BRNE _0x53
; 0000 02F4     oproznij_podajnik = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _oproznij_podajnik,R30
	STS  _oproznij_podajnik+1,R31
; 0000 02F5 else
	RJMP _0x54
_0x53:
; 0000 02F6     oproznij_podajnik = 0;
	LDI  R30,LOW(0)
	STS  _oproznij_podajnik,R30
	STS  _oproznij_podajnik+1,R30
; 0000 02F7 }
_0x54:
; 0000 02F8 
; 0000 02F9 putchar(90);
_0x4F:
	CALL SUBOPT_0xD
; 0000 02FA putchar(165);
; 0000 02FB putchar(4);
	CALL SUBOPT_0x11
; 0000 02FC putchar(131);
; 0000 02FD putchar(0);
; 0000 02FE putchar(80);  //adres zmiennej - 50
	CALL SUBOPT_0x22
; 0000 02FF putchar(1);   //czas po jakim wylaczony silnik
; 0000 0300 getchar();
; 0000 0301 getchar();
; 0000 0302 getchar();
; 0000 0303 getchar();
; 0000 0304 getchar();
; 0000 0305 getchar();
; 0000 0306 getchar();
; 0000 0307 getchar();
; 0000 0308 czas_silnika_dokrecajacego_grzybki = getchar();
	LDI  R31,0
	STS  _czas_silnika_dokrecajacego_grzybki,R30
	STS  _czas_silnika_dokrecajacego_grzybki+1,R31
; 0000 0309 
; 0000 030A if(k == 1 | (k == 0 & il_pretow_gwintowanych > 4))
	CALL SUBOPT_0x23
	MOV  R1,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __GTW12
	AND  R30,R0
	OR   R30,R1
	BREQ _0x55
; 0000 030B {
; 0000 030C putchar(90);
	CALL SUBOPT_0xD
; 0000 030D putchar(165);
; 0000 030E putchar(4);
	CALL SUBOPT_0x11
; 0000 030F putchar(131);
; 0000 0310 putchar(0);
; 0000 0311 putchar(96);  //adres zmiennej - 60
	CALL SUBOPT_0x13
; 0000 0312 putchar(1);     //odczyt czy anulowac zlecenie
	CALL SUBOPT_0x12
; 0000 0313 getchar();
; 0000 0314 getchar();
; 0000 0315 getchar();
; 0000 0316 getchar();
; 0000 0317 getchar();
; 0000 0318 getchar();
; 0000 0319 getchar();
; 0000 031A getchar();
; 0000 031B hh = getchar();
	CALL SUBOPT_0x20
; 0000 031C 
; 0000 031D if(hh == 0)
	BRNE _0x56
; 0000 031E     anuluj_biezace_zlecenie = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _anuluj_biezace_zlecenie,R30
	STS  _anuluj_biezace_zlecenie+1,R31
; 0000 031F else
	RJMP _0x57
_0x56:
; 0000 0320     anuluj_biezace_zlecenie = 0;
	LDI  R30,LOW(0)
	STS  _anuluj_biezace_zlecenie,R30
	STS  _anuluj_biezace_zlecenie+1,R30
; 0000 0321 
; 0000 0322 
; 0000 0323 
; 0000 0324 //czas_monterow = (long int)pomocnicza * stala_czasowa;
; 0000 0325 czas_monterow = 7 * stala_czasowa;
_0x57:
	LDS  R30,_stala_czasowa
	LDS  R31,_stala_czasowa+1
	LDS  R22,_stala_czasowa+2
	LDS  R23,_stala_czasowa+3
	__GETD2N 0x7
	CALL __MULD12
	STS  _czas_monterow,R30
	STS  _czas_monterow+1,R31
	STS  _czas_monterow+2,R22
	STS  _czas_monterow+3,R23
; 0000 0326 }
; 0000 0327 
; 0000 0328 if(pierwszy_raz == 0)
_0x55:
	LDS  R30,_pierwszy_raz
	LDS  R31,_pierwszy_raz+1
	SBIW R30,0
	BRNE _0x58
; 0000 0329     {
; 0000 032A     //przeslij_parametry_do_slave(pomocnicza, 2);
; 0000 032B     pierwszy_raz = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _pierwszy_raz,R30
	STS  _pierwszy_raz+1,R31
; 0000 032C     czas_monterow_stala = czas_monterow;
	LDS  R30,_czas_monterow
	LDS  R31,_czas_monterow+1
	STS  _czas_monterow_stala,R30
	STS  _czas_monterow_stala+1,R31
; 0000 032D     }
; 0000 032E 
; 0000 032F if(czas_monterow_stala != czas_monterow)
_0x58:
	CALL SUBOPT_0x26
	LDS  R26,_czas_monterow_stala
	LDS  R27,_czas_monterow_stala+1
	CALL __CWD2
	CALL __CPD12
	BREQ _0x59
; 0000 0330    pierwszy_raz = 0;
	LDI  R30,LOW(0)
	STS  _pierwszy_raz,R30
	STS  _pierwszy_raz+1,R30
; 0000 0331 
; 0000 0332 if(start == 0 & k == 1)
_0x59:
	MOVW R26,R12
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	AND  R30,R0
	BREQ _0x5A
; 0000 0333     {
; 0000 0334     putchar(90);
	CALL SUBOPT_0xD
; 0000 0335     putchar(165);
; 0000 0336     putchar(4);
	CALL SUBOPT_0x11
; 0000 0337     putchar(131);
; 0000 0338     putchar(0);
; 0000 0339     putchar(112);  //adres zmiennej - 70
	CALL SUBOPT_0x27
; 0000 033A     putchar(1);     //odczyt ilosci pucharow do zmontowania
	CALL SUBOPT_0x28
; 0000 033B     getchar();
	CALL SUBOPT_0x29
; 0000 033C     getchar();
; 0000 033D     getchar();
; 0000 033E     getchar();
	CALL SUBOPT_0x29
; 0000 033F     getchar();
; 0000 0340     getchar();
; 0000 0341     getchar();
	CALL _getchar
; 0000 0342     oleole = getchar();
	CALL _getchar
	MOV  R20,R30
	CLR  R21
; 0000 0343     il_pretow_gwintowanych = getchar();
	CALL _getchar
	LDI  R31,0
	CALL SUBOPT_0x2A
; 0000 0344 
; 0000 0345     if(oleole > 0)
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRGE _0x5B
; 0000 0346         il_pretow_gwintowanych = oleole * 255 + il_pretow_gwintowanych + oleole;
	MOVW R30,R20
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __MULW12
	CALL SUBOPT_0x25
	ADD  R30,R26
	ADC  R31,R27
	ADD  R30,R20
	ADC  R31,R21
	CALL SUBOPT_0x2A
; 0000 0347 
; 0000 0348 
; 0000 0349 
; 0000 034A     il_pretow_gwintowanych_stala = il_pretow_gwintowanych;
_0x5B:
	CALL SUBOPT_0x2B
; 0000 034B     }
; 0000 034C 
; 0000 034D 
; 0000 034E if(k == 1)
_0x5A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,1
	BRNE _0x5C
; 0000 034F {
; 0000 0350 putchar(90);
	CALL SUBOPT_0xD
; 0000 0351 putchar(165);
; 0000 0352 putchar(4);
	CALL SUBOPT_0x2C
; 0000 0353 putchar(131);
; 0000 0354 putchar(32);
; 0000 0355 putchar(48);  //adres zmiennej - 2030
	CALL SUBOPT_0xF
; 0000 0356 putchar(1);
	CALL SUBOPT_0x12
; 0000 0357 getchar();
; 0000 0358 getchar();
; 0000 0359 getchar();
; 0000 035A getchar();
; 0000 035B getchar();
; 0000 035C getchar();
; 0000 035D getchar();
; 0000 035E getchar();
; 0000 035F hh = getchar();
	CALL SUBOPT_0x20
; 0000 0360 if(hh == 0)
	BRNE _0x5D
; 0000 0361     tryb_male_puchary = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R31
; 0000 0362 else
	RJMP _0x5E
_0x5D:
; 0000 0363    tryb_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R30
; 0000 0364 }
_0x5E:
; 0000 0365 
; 0000 0366 
; 0000 0367 putchar(90);
_0x5C:
	CALL SUBOPT_0xD
; 0000 0368 putchar(165);
; 0000 0369 putchar(4);
	CALL SUBOPT_0x2C
; 0000 036A putchar(131);
; 0000 036B putchar(32);
; 0000 036C putchar(64);  //adres zmiennej - 2040
	CALL SUBOPT_0x1B
; 0000 036D putchar(1);
; 0000 036E getchar();
; 0000 036F getchar();
; 0000 0370 getchar();
; 0000 0371 getchar();
; 0000 0372 getchar();
; 0000 0373 getchar();
; 0000 0374 getchar();
; 0000 0375 getchar();
; 0000 0376 predkosc_wiezyczek_male_puchary = getchar();
	LDI  R31,0
	STS  _predkosc_wiezyczek_male_puchary,R30
	STS  _predkosc_wiezyczek_male_puchary+1,R31
; 0000 0377 
; 0000 0378 
; 0000 0379 
; 0000 037A putchar(90);
	CALL SUBOPT_0xD
; 0000 037B putchar(165);
; 0000 037C putchar(4);
	CALL SUBOPT_0x2C
; 0000 037D putchar(131);
; 0000 037E putchar(32);
; 0000 037F putchar(80);  //adres zmiennej - 2050
	CALL SUBOPT_0x22
; 0000 0380 putchar(1);
; 0000 0381 getchar();
; 0000 0382 getchar();
; 0000 0383 getchar();
; 0000 0384 getchar();
; 0000 0385 getchar();
; 0000 0386 getchar();
; 0000 0387 getchar();
; 0000 0388 getchar();
; 0000 0389 wielkosc_kamienia = getchar();
	LDI  R31,0
	STS  _wielkosc_kamienia,R30
	STS  _wielkosc_kamienia+1,R31
; 0000 038A 
; 0000 038B 
; 0000 038C if(tryb_male_puchary == 0)
	LDS  R30,_tryb_male_puchary
	LDS  R31,_tryb_male_puchary+1
	SBIW R30,0
	BRNE _0x5F
; 0000 038D      wynik_wyboru_male_puchary = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x2BB
; 0000 038E else
_0x5F:
; 0000 038F     {
; 0000 0390     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 50)
	CALL SUBOPT_0x2D
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x61
; 0000 0391        wynik_wyboru_male_puchary = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x2E
; 0000 0392     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 55)
_0x61:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x62
; 0000 0393        wynik_wyboru_male_puchary = 18;
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x2E
; 0000 0394     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 60)
_0x62:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x63
; 0000 0395        wynik_wyboru_male_puchary = 19;
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CALL SUBOPT_0x2E
; 0000 0396     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 65)
_0x63:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x64
; 0000 0397        wynik_wyboru_male_puchary = 20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2E
; 0000 0398     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 70)
_0x64:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x65
; 0000 0399        wynik_wyboru_male_puchary = 21;
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	CALL SUBOPT_0x2E
; 0000 039A     if(predkosc_wiezyczek_male_puchary == 1 & wielkosc_kamienia == 75)
_0x65:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x66
; 0000 039B        wynik_wyboru_male_puchary = 22;
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x2E
; 0000 039C 
; 0000 039D 
; 0000 039E     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 50)
_0x66:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x67
; 0000 039F           wynik_wyboru_male_puchary = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x2E
; 0000 03A0     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 55)
_0x67:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x68
; 0000 03A1           wynik_wyboru_male_puchary = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x2E
; 0000 03A2     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 60)
_0x68:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x69
; 0000 03A3           wynik_wyboru_male_puchary = 13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CALL SUBOPT_0x2E
; 0000 03A4     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 65)
_0x69:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x6A
; 0000 03A5           wynik_wyboru_male_puchary = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x2E
; 0000 03A6     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 70)
_0x6A:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x6B
; 0000 03A7           wynik_wyboru_male_puchary = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x2E
; 0000 03A8     if(predkosc_wiezyczek_male_puchary == 2 & wielkosc_kamienia == 75)
_0x6B:
	CALL SUBOPT_0x2F
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x6C
; 0000 03A9           wynik_wyboru_male_puchary = 16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
_0x2BB:
	STS  _wynik_wyboru_male_puchary,R30
	STS  _wynik_wyboru_male_puchary+1,R31
; 0000 03AA 
; 0000 03AB     }
_0x6C:
; 0000 03AC 
; 0000 03AD 
; 0000 03AE 
; 0000 03AF }
	CALL __LOADLOCR6
	RJMP _0x20A0003
;
;void wartosci_wstepne_panelu()
; 0000 03B2 {
_wartosci_wstepne_panelu:
; 0000 03B3 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 03B4 putchar(165); //A5
; 0000 03B5 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 03B6 putchar(130);  //82    //dlugosc preta gwintowanego
; 0000 03B7 putchar(0);    //00
; 0000 03B8 putchar(64);   //40
	CALL SUBOPT_0x30
; 0000 03B9 putchar(0);    //00
; 0000 03BA putchar(dlugosc_preta_gwintowanego);   //80
	LDS  R30,_dlugosc_preta_gwintowanego
	CALL SUBOPT_0x31
; 0000 03BB 
; 0000 03BC putchar(90);  //5A
; 0000 03BD putchar(165); //A5
; 0000 03BE putchar(5);//05
	CALL SUBOPT_0xE
; 0000 03BF putchar(130);  //82    //czas po jakim wylaczamy silnik
; 0000 03C0 putchar(0);    //00
; 0000 03C1 putchar(80);   //50
	CALL SUBOPT_0x32
; 0000 03C2 putchar(0);    //00
; 0000 03C3 putchar(czas_silnika_dokrecajacego_grzybki);
	LDS  R30,_czas_silnika_dokrecajacego_grzybki
	CALL SUBOPT_0x31
; 0000 03C4 
; 0000 03C5 putchar(90);  //5A
; 0000 03C6 putchar(165); //A5
; 0000 03C7 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 03C8 putchar(130);  //82    //zmienie na anulowanie zlecenia
; 0000 03C9 putchar(0);    //00
; 0000 03CA putchar(96);   //60
	CALL SUBOPT_0x13
; 0000 03CB putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03CC putchar(1);   //1
	CALL SUBOPT_0x28
; 0000 03CD 
; 0000 03CE putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 03CF putchar(165); //A5
; 0000 03D0 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 03D1 putchar(130);  //82    //ilosc pucharow do zmontowania
; 0000 03D2 putchar(0);    //00
; 0000 03D3 putchar(112);   //70
	CALL SUBOPT_0x27
; 0000 03D4 putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03D5 putchar(5);   //5
	LDI  R30,LOW(5)
	CALL SUBOPT_0x31
; 0000 03D6 
; 0000 03D7 putchar(90);  //5A
; 0000 03D8 putchar(165); //A5
; 0000 03D9 putchar(5);//05                              0-tak
	CALL SUBOPT_0x33
; 0000 03DA putchar(130);  //82    /Czy grzybki metalowe 1-nie
; 0000 03DB putchar(16);    //10
; 0000 03DC putchar(16);   //10
	CALL SUBOPT_0x1F
; 0000 03DD putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03DE putchar(1);   //1
	CALL SUBOPT_0x28
; 0000 03DF 
; 0000 03E0 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 03E1 putchar(165); //A5
; 0000 03E2 putchar(5);//05                              0-tak
	CALL SUBOPT_0x33
; 0000 03E3 putchar(130);  //82    /Czy oproznic podajnik grzybkow 1-nie
; 0000 03E4 putchar(16);    //10
; 0000 03E5 putchar(32);   //80
	CALL SUBOPT_0x21
; 0000 03E6 putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03E7 putchar(1);   //1
	CALL SUBOPT_0x28
; 0000 03E8 
; 0000 03E9 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 03EA putchar(165); //A5
; 0000 03EB putchar(5);//05                              0-tak
	CALL SUBOPT_0x33
; 0000 03EC putchar(130);  //82    /Czy tryb kontynuacji 1-nie
; 0000 03ED putchar(16);    //10
; 0000 03EE putchar(128);   //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 03EF putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03F0 putchar(1);   //1
	CALL SUBOPT_0x28
; 0000 03F1 
; 0000 03F2 //tu obrabiam tryb male puchary pod adresem 2030
; 0000 03F3 
; 0000 03F4 putchar(90);
	CALL SUBOPT_0xD
; 0000 03F5 putchar(165);
; 0000 03F6 putchar(5);
	CALL SUBOPT_0x34
; 0000 03F7 putchar(130);  //82
; 0000 03F8 putchar(32);    //20
; 0000 03F9 putchar(48);  //adres 30
	CALL SUBOPT_0xF
; 0000 03FA putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 03FB putchar(1);   //1          Czy tryb male puchary 1-nie 0-tak
	CALL SUBOPT_0x28
; 0000 03FC 
; 0000 03FD 
; 0000 03FE //tu obrabiam predkosc wiezyczek male puchary
; 0000 03FF 
; 0000 0400 putchar(90);
	CALL SUBOPT_0xD
; 0000 0401 putchar(165);
; 0000 0402 putchar(5);
	CALL SUBOPT_0x34
; 0000 0403 putchar(130);  //82
; 0000 0404 putchar(32);    //20
; 0000 0405 putchar(64);  //adres 40
	CALL SUBOPT_0x30
; 0000 0406 putchar(0);    //00
; 0000 0407 putchar(2);   //1          predkosc wiezyczek male puchary 2-maks 1-min
	LDI  R30,LOW(2)
	CALL SUBOPT_0x31
; 0000 0408 
; 0000 0409 //tu obrabiam wielkosc kamienia male puchary
; 0000 040A 
; 0000 040B putchar(90);
; 0000 040C putchar(165);
; 0000 040D putchar(5);
	CALL SUBOPT_0x34
; 0000 040E putchar(130);  //82
; 0000 040F putchar(32);    //20
; 0000 0410 putchar(80);  //adres 50
	CALL SUBOPT_0x32
; 0000 0411 putchar(0);    //00
; 0000 0412 putchar(50);   //   //50 55 60 65 70 75
	LDI  R30,LOW(50)
_0x20A0004:
	ST   -Y,R30
	CALL _putchar
; 0000 0413 
; 0000 0414 
; 0000 0415 
; 0000 0416 }
	RET
;
;
;void wyswietl_ilosc_zmontowanych_pucharow(int i,int j)
; 0000 041A {
_wyswietl_ilosc_zmontowanych_pucharow:
; 0000 041B int gg,hh;
; 0000 041C 
; 0000 041D if(i>255)
	CALL __SAVELOCR4
;	i -> Y+6
;	j -> Y+4
;	gg -> R16,R17
;	hh -> R18,R19
	CALL SUBOPT_0x35
	BRLT _0x6D
; 0000 041E     {
; 0000 041F     gg = i/255;
	CALL SUBOPT_0x36
	CALL __DIVW21
	MOVW R16,R30
; 0000 0420     hh = i%255;
	CALL SUBOPT_0x36
	CALL __MODW21
	MOVW R18,R30
; 0000 0421     }
; 0000 0422 else
	RJMP _0x6E
_0x6D:
; 0000 0423     {
; 0000 0424     gg = 0;
	CALL SUBOPT_0x37
; 0000 0425     hh = 0;
; 0000 0426     }
_0x6E:
; 0000 0427 
; 0000 0428 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0429 putchar(165); //A5
; 0000 042A putchar(5);//05
	CALL SUBOPT_0xE
; 0000 042B putchar(130);  //82
; 0000 042C putchar(0);    //00
; 0000 042D putchar(128);   //80
	LDI  R30,LOW(128)
	CALL SUBOPT_0x38
; 0000 042E putchar(gg);    //00
; 0000 042F if(i>255)
	CALL SUBOPT_0x35
	BRLT _0x6F
; 0000 0430     putchar(gg*255+hh);   //7
	CALL SUBOPT_0x39
	RJMP _0x2BC
; 0000 0431 else
_0x6F:
; 0000 0432     if(i>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x71
; 0000 0433         putchar(i);
	LDD  R30,Y+6
	RJMP _0x2BC
; 0000 0434     else
_0x71:
; 0000 0435         putchar(0);
	LDI  R30,LOW(0)
_0x2BC:
	ST   -Y,R30
	CALL _putchar
; 0000 0436 
; 0000 0437 
; 0000 0438 if(j>255)
	CALL SUBOPT_0x3A
	BRLT _0x73
; 0000 0439     {
; 0000 043A     gg = j/255;
	CALL SUBOPT_0x3B
	CALL __DIVW21
	MOVW R16,R30
; 0000 043B     hh = j%255;
	CALL SUBOPT_0x3B
	CALL __MODW21
	MOVW R18,R30
; 0000 043C     }
; 0000 043D else
	RJMP _0x74
_0x73:
; 0000 043E     {
; 0000 043F     gg = 0;
	CALL SUBOPT_0x37
; 0000 0440     hh = 0;
; 0000 0441     }
_0x74:
; 0000 0442 
; 0000 0443 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0444 putchar(165); //A5
; 0000 0445 putchar(5);//05
	CALL SUBOPT_0x33
; 0000 0446 putchar(130);  //82
; 0000 0447 putchar(16);    //10
; 0000 0448 putchar(64);   //40
	LDI  R30,LOW(64)
	CALL SUBOPT_0x38
; 0000 0449 putchar(gg);    //00
; 0000 044A if(j>255)
	CALL SUBOPT_0x3A
	BRLT _0x75
; 0000 044B     putchar(gg*255+hh);
	CALL SUBOPT_0x39
	RJMP _0x2BD
; 0000 044C else
_0x75:
; 0000 044D     putchar(j);   //7  //j na razie bo mam problem z 255
	LDD  R30,Y+4
_0x2BD:
	ST   -Y,R30
	CALL _putchar
; 0000 044E }
	CALL __LOADLOCR4
_0x20A0003:
	ADIW R28,8
	RET
;
;void wyswietl_czas_procesu()
; 0000 0451 {
_wyswietl_czas_procesu:
; 0000 0452 putchar(90);
	CALL SUBOPT_0xD
; 0000 0453 putchar(165);
; 0000 0454 putchar(11);       //ilosc liter 8+3
	CALL SUBOPT_0x3C
; 0000 0455 putchar(130);  //82
; 0000 0456 putchar(32);    //20
; 0000 0457 putchar(16);  //adres 10
	CALL SUBOPT_0x1F
; 0000 0458 
; 0000 0459 if(sek_clock < 10)
	CALL SUBOPT_0x5
	SBIW R26,10
	BRGE _0x77
; 0000 045A     printf("0%d",sek_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2BE
; 0000 045B else
_0x77:
; 0000 045C     printf("%d",sek_clock);
	__POINTW1FN _0x0,735
_0x2BE:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3D
; 0000 045D printf(":");
	CALL SUBOPT_0x3E
; 0000 045E 
; 0000 045F if(min_clock < 10)
	CALL SUBOPT_0x6
	SBIW R26,10
	BRGE _0x79
; 0000 0460     printf("0%d",min_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2BF
; 0000 0461 else
_0x79:
; 0000 0462     printf("%d",min_clock);
	__POINTW1FN _0x0,735
_0x2BF:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3F
; 0000 0463 printf(":");
	CALL SUBOPT_0x3E
; 0000 0464 
; 0000 0465 if(godz_clock < 10)
	LDS  R26,_godz_clock
	LDS  R27,_godz_clock+1
	SBIW R26,10
	BRGE _0x7B
; 0000 0466     printf("0%d",godz_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C0
; 0000 0467 else
_0x7B:
; 0000 0468     printf("%d",godz_clock);
	__POINTW1FN _0x0,735
_0x2C0:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x40
; 0000 0469 }
	RET
;
;
;void wyswietl_czas_przezbrojenia()
; 0000 046D {
_wyswietl_czas_przezbrojenia:
; 0000 046E putchar(90);
	CALL SUBOPT_0xD
; 0000 046F putchar(165);
; 0000 0470 putchar(11);       //ilosc liter 8+3
	CALL SUBOPT_0x3C
; 0000 0471 putchar(130);  //82
; 0000 0472 putchar(32);    //20
; 0000 0473 putchar(00);  //adres 10
	CALL SUBOPT_0x10
; 0000 0474 
; 0000 0475 if(sek_clock < 10)
	CALL SUBOPT_0x5
	SBIW R26,10
	BRGE _0x7D
; 0000 0476     printf("0%d",sek_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C1
; 0000 0477 else
_0x7D:
; 0000 0478     printf("%d",sek_clock);
	__POINTW1FN _0x0,735
_0x2C1:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3D
; 0000 0479 printf(":");
	CALL SUBOPT_0x3E
; 0000 047A 
; 0000 047B if(min_clock < 10)
	CALL SUBOPT_0x6
	SBIW R26,10
	BRGE _0x7F
; 0000 047C     printf("0%d",min_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C2
; 0000 047D else
_0x7F:
; 0000 047E     printf("%d",min_clock);
	__POINTW1FN _0x0,735
_0x2C2:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3F
; 0000 047F printf(":");
	CALL SUBOPT_0x3E
; 0000 0480 
; 0000 0481 if(godz_clock < 10)
	LDS  R26,_godz_clock
	LDS  R27,_godz_clock+1
	SBIW R26,10
	BRGE _0x81
; 0000 0482     printf("0%d",godz_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C3
; 0000 0483 else
_0x81:
; 0000 0484     printf("%d",godz_clock);
	__POINTW1FN _0x0,735
_0x2C3:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x40
; 0000 0485 
; 0000 0486 }
	RET
;
;void wyswietl_czas_laczny_przezbrajan()
; 0000 0489 {
_wyswietl_czas_laczny_przezbrajan:
; 0000 048A putchar(90);
	CALL SUBOPT_0xD
; 0000 048B putchar(165);
; 0000 048C putchar(11);       //ilosc liter 8+3
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _putchar
; 0000 048D putchar(130);  //82
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
; 0000 048E putchar(16);    //10
	CALL SUBOPT_0x1F
; 0000 048F putchar(144);  //adres 90
	CALL SUBOPT_0x17
; 0000 0490 
; 0000 0491 przez_sek_clock = przez_sek_clock + sek_clock;
	LDS  R30,_sek_clock
	LDS  R31,_sek_clock+1
	CALL SUBOPT_0x41
	ADD  R30,R26
	ADC  R31,R27
	STS  _przez_sek_clock,R30
	STS  _przez_sek_clock+1,R31
; 0000 0492 if(przez_sek_clock > 60)
	CALL SUBOPT_0x41
	SBIW R26,61
	BRLT _0x83
; 0000 0493     {
; 0000 0494     przez_sek_clock = przez_sek_clock - 60;
	LDS  R30,_przez_sek_clock
	LDS  R31,_przez_sek_clock+1
	SBIW R30,60
	STS  _przez_sek_clock,R30
	STS  _przez_sek_clock+1,R31
; 0000 0495     przez_min_clock++;
	LDI  R26,LOW(_przez_min_clock)
	LDI  R27,HIGH(_przez_min_clock)
	CALL SUBOPT_0x4
; 0000 0496     }
; 0000 0497 
; 0000 0498 przez_min_clock = przez_min_clock + min_clock;
_0x83:
	LDS  R30,_min_clock
	LDS  R31,_min_clock+1
	CALL SUBOPT_0x42
	ADD  R30,R26
	ADC  R31,R27
	STS  _przez_min_clock,R30
	STS  _przez_min_clock+1,R31
; 0000 0499 if(przez_min_clock > 60)
	CALL SUBOPT_0x42
	SBIW R26,61
	BRLT _0x84
; 0000 049A     {
; 0000 049B     przez_min_clock = przez_min_clock - 60;
	LDS  R30,_przez_min_clock
	LDS  R31,_przez_min_clock+1
	SBIW R30,60
	STS  _przez_min_clock,R30
	STS  _przez_min_clock+1,R31
; 0000 049C     przez_godz_clock++;
	LDI  R26,LOW(_przez_godz_clock)
	LDI  R27,HIGH(_przez_godz_clock)
	CALL SUBOPT_0x4
; 0000 049D     }
; 0000 049E 
; 0000 049F przez_godz_clock = przez_godz_clock + godz_clock;
_0x84:
	LDS  R30,_godz_clock
	LDS  R31,_godz_clock+1
	CALL SUBOPT_0x43
	ADD  R30,R26
	ADC  R31,R27
	STS  _przez_godz_clock,R30
	STS  _przez_godz_clock+1,R31
; 0000 04A0 if(przez_godz_clock > 60)
	CALL SUBOPT_0x43
	SBIW R26,61
	BRLT _0x85
; 0000 04A1     {
; 0000 04A2     przez_godz_clock = przez_godz_clock - 60;
	LDS  R30,_przez_godz_clock
	LDS  R31,_przez_godz_clock+1
	SBIW R30,60
	STS  _przez_godz_clock,R30
	STS  _przez_godz_clock+1,R31
; 0000 04A3     przez_godz_clock = 0;
	LDI  R30,LOW(0)
	STS  _przez_godz_clock,R30
	STS  _przez_godz_clock+1,R30
; 0000 04A4     }
; 0000 04A5 
; 0000 04A6 
; 0000 04A7 
; 0000 04A8 if(przez_sek_clock < 10)
_0x85:
	CALL SUBOPT_0x41
	SBIW R26,10
	BRGE _0x86
; 0000 04A9     printf("0%d",przez_sek_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C4
; 0000 04AA else
_0x86:
; 0000 04AB     printf("%d",przez_sek_clock);
	__POINTW1FN _0x0,735
_0x2C4:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_przez_sek_clock
	LDS  R31,_przez_sek_clock+1
	CALL SUBOPT_0x44
; 0000 04AC printf(":");
	CALL SUBOPT_0x3E
; 0000 04AD 
; 0000 04AE if(przez_min_clock < 10)
	CALL SUBOPT_0x42
	SBIW R26,10
	BRGE _0x88
; 0000 04AF     printf("0%d",przez_min_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C5
; 0000 04B0 else
_0x88:
; 0000 04B1     printf("%d",przez_min_clock);
	__POINTW1FN _0x0,735
_0x2C5:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_przez_min_clock
	LDS  R31,_przez_min_clock+1
	CALL SUBOPT_0x44
; 0000 04B2 printf(":");
	CALL SUBOPT_0x3E
; 0000 04B3 
; 0000 04B4 if(przez_godz_clock < 10)
	CALL SUBOPT_0x43
	SBIW R26,10
	BRGE _0x8A
; 0000 04B5     printf("0%d",przez_godz_clock);
	__POINTW1FN _0x0,734
	RJMP _0x2C6
; 0000 04B6 else
_0x8A:
; 0000 04B7     printf("%d",przez_godz_clock);
	__POINTW1FN _0x0,735
_0x2C6:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_przez_godz_clock
	LDS  R31,_przez_godz_clock+1
	CALL SUBOPT_0x44
; 0000 04B8 }
	RET
;
;void wyswietl_parametry(int i,int j,int k,int l, int m, int n)
; 0000 04BB {
_wyswietl_parametry:
; 0000 04BC int gg,hh;
; 0000 04BD 
; 0000 04BE putchar(90);  //5A
	CALL __SAVELOCR4
;	i -> Y+14
;	j -> Y+12
;	k -> Y+10
;	l -> Y+8
;	m -> Y+6
;	n -> Y+4
;	gg -> R16,R17
;	hh -> R18,R19
	CALL SUBOPT_0xD
; 0000 04BF putchar(165); //A5
; 0000 04C0 putchar(5);//05
	CALL SUBOPT_0xE
; 0000 04C1 putchar(130);  //82
; 0000 04C2 putchar(0);    //00
; 0000 04C3 putchar(16);   //10
	CALL SUBOPT_0x1F
; 0000 04C4 putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 04C5 //if(i>=0)
; 0000 04C6     putchar(i);   //
	LDD  R30,Y+14
	CALL SUBOPT_0x31
; 0000 04C7 //else
; 0000 04C8 //    putchar(i);
; 0000 04C9 
; 0000 04CA putchar(90);  //5A
; 0000 04CB putchar(165); //A5
; 0000 04CC putchar(5);//05
	CALL SUBOPT_0xE
; 0000 04CD putchar(130);  //82
; 0000 04CE putchar(0);    //00
; 0000 04CF putchar(32);   //20
	CALL SUBOPT_0x21
; 0000 04D0 putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 04D1 //if(j>=0)
; 0000 04D2     putchar(j);   //
	LDD  R30,Y+12
	CALL SUBOPT_0x31
; 0000 04D3 //else
; 0000 04D4 //    putchar(0);
; 0000 04D5 
; 0000 04D6 putchar(90);  //5A
; 0000 04D7 putchar(165); //A5
; 0000 04D8 putchar(5);//05
	CALL SUBOPT_0x33
; 0000 04D9 putchar(130);  //82
; 0000 04DA putchar(16);    //10
; 0000 04DB putchar(48);   //30
	CALL SUBOPT_0xF
; 0000 04DC putchar(0);    //00
	CALL SUBOPT_0x10
; 0000 04DD putchar(k);   //7
	LDD  R30,Y+10
	CALL SUBOPT_0x31
; 0000 04DE 
; 0000 04DF putchar(90);  //5A
; 0000 04E0 putchar(165); //A5
; 0000 04E1 putchar(5);//05
	CALL SUBOPT_0x33
; 0000 04E2 putchar(130);  //82
; 0000 04E3 putchar(16);    //10   //ilosc niewlozonych pretow z grzybkami do wiezy, czyli raczej krzywa wieza
; 0000 04E4 putchar(80);   //50
	CALL SUBOPT_0x32
; 0000 04E5 putchar(0);    //00
; 0000 04E6 putchar(l);   //7
	LDD  R30,Y+8
	ST   -Y,R30
	CALL _putchar
; 0000 04E7 
; 0000 04E8 
; 0000 04E9 
; 0000 04EA if(m>255)
	CALL SUBOPT_0x35
	BRLT _0x8C
; 0000 04EB     {
; 0000 04EC     gg = m/255;
	CALL SUBOPT_0x36
	CALL __DIVW21
	MOVW R16,R30
; 0000 04ED     hh = m%255;
	CALL SUBOPT_0x36
	CALL __MODW21
	MOVW R18,R30
; 0000 04EE     }
; 0000 04EF else
	RJMP _0x8D
_0x8C:
; 0000 04F0     {
; 0000 04F1     gg = 0;
	CALL SUBOPT_0x37
; 0000 04F2     hh = 0;
; 0000 04F3     }
_0x8D:
; 0000 04F4 
; 0000 04F5 
; 0000 04F6 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 04F7 putchar(165); //A5
; 0000 04F8 putchar(5);//05
	CALL SUBOPT_0x33
; 0000 04F9 putchar(130);  //82
; 0000 04FA putchar(16);    //10   //liczba spozniem monter 1 i 2
; 0000 04FB putchar(96);   //60
	CALL SUBOPT_0x13
; 0000 04FC putchar(gg);    //00
	ST   -Y,R16
	CALL _putchar
; 0000 04FD if(m>255)
	CALL SUBOPT_0x35
	BRLT _0x8E
; 0000 04FE     putchar(gg*255+hh);   //7
	CALL SUBOPT_0x39
	RJMP _0x2C7
; 0000 04FF else
_0x8E:
; 0000 0500     if(m>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x90
; 0000 0501         putchar(m);
	LDD  R30,Y+6
	RJMP _0x2C7
; 0000 0502     else
_0x90:
; 0000 0503         putchar(0);
	LDI  R30,LOW(0)
_0x2C7:
	ST   -Y,R30
	CALL _putchar
; 0000 0504 
; 0000 0505 
; 0000 0506 if(n>255)
	CALL SUBOPT_0x3A
	BRLT _0x92
; 0000 0507     {
; 0000 0508     gg = n/255;
	CALL SUBOPT_0x3B
	CALL __DIVW21
	MOVW R16,R30
; 0000 0509     hh = n%255;
	CALL SUBOPT_0x3B
	CALL __MODW21
	MOVW R18,R30
; 0000 050A     }
; 0000 050B else
	RJMP _0x93
_0x92:
; 0000 050C     {
; 0000 050D     gg = 0;
	CALL SUBOPT_0x37
; 0000 050E     hh = 0;
; 0000 050F     }
_0x93:
; 0000 0510 
; 0000 0511 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0512 putchar(165); //A5
; 0000 0513 putchar(5);//05
	CALL SUBOPT_0x33
; 0000 0514 putchar(130);  //82
; 0000 0515 putchar(16);    //10   //liczba spoznien monter 3
; 0000 0516 putchar(112);   //70
	CALL SUBOPT_0x27
; 0000 0517 putchar(gg);    //00
	ST   -Y,R16
	CALL _putchar
; 0000 0518 
; 0000 0519 if(n>255)
	CALL SUBOPT_0x3A
	BRLT _0x94
; 0000 051A     putchar(gg*255+hh);   //7
	CALL SUBOPT_0x39
	RJMP _0x2C8
; 0000 051B else
_0x94:
; 0000 051C     if(n>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x96
; 0000 051D         putchar(n);
	LDD  R30,Y+4
	RJMP _0x2C8
; 0000 051E     else
_0x96:
; 0000 051F         putchar(0);
	LDI  R30,LOW(0)
_0x2C8:
	ST   -Y,R30
	CALL _putchar
; 0000 0520 
; 0000 0521 }
	CALL __LOADLOCR4
	RJMP _0x20A0002
;
;
;
;void obsluga_startowa_dozownika_kleju()
; 0000 0526 {
_obsluga_startowa_dozownika_kleju:
; 0000 0527 PORTD.5 = 1;  //zasilanie 220V na dozownik kleju
	SBI  0x12,5
; 0000 0528 //PORTC.0 = 1;  //cisnienie na dozownik kleju
; 0000 0529 
; 0000 052A /*
; 0000 052B while(PINA.6 == 1)
; 0000 052C   {
; 0000 052D   komunikat_8_na_panel(0); //dozownik kleju nie gotowy
; 0000 052E   delay_ms(1000);
; 0000 052F   }
; 0000 0530 */
; 0000 0531 }
	RET
;
;void obsluga_startowa_dozownika_kleju_slave()
; 0000 0534 {
; 0000 0535 int spr;
; 0000 0536 spr = 0;
;	spr -> R16,R17
; 0000 0537 
; 0000 0538 PORTE.7 = 1;
; 0000 0539 delay_ms(100);
; 0000 053A spr = getchar1();
; 0000 053B if(spr == 0)   //jak na poczatku podal 0 to jeszcze raz getchar
; 0000 053C     {
; 0000 053D     komunikat_8_na_panel(1);
; 0000 053E     getchar1();  //tu utyka i czeka az ok z dozownikiem            //wtedy ten getchar puszcza
; 0000 053F     }
; 0000 0540 PORTE.7 = 0;  //koniec komunikacji
; 0000 0541 
; 0000 0542 }
;
;int pusc_pierwszego_preta()
; 0000 0545 {
; 0000 0546 int wynik;
; 0000 0547 wynik = 0;
;	wynik -> R16,R17
; 0000 0548 
; 0000 0549 //PORTC.5   si³ownik 3 kolejkuj¹cy na rynnie
; 0000 054A //PORTC.6   si³ownik 2 kolejkuj¹cy na rynnie  //na pewno podupcona kolejnoœæ
; 0000 054B //PORTC.7   si³ownik 1 kolejkuj¹cy na rynnie
; 0000 054C 
; 0000 054D switch(proces[0])
; 0000 054E     {
; 0000 054F     case 0:
; 0000 0550         proces[0] = 1;
; 0000 0551     break;
; 0000 0552 
; 0000 0553     case 1:
; 0000 0554 
; 0000 0555         sek0_7s = 0;
; 0000 0556         sek0 = 0;
; 0000 0557         proces[0] = 4;
; 0000 0558 
; 0000 0559     break;
; 0000 055A 
; 0000 055B     case 4:
; 0000 055C             if(sek0 > 100)
; 0000 055D                 {
; 0000 055E                 PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
; 0000 055F                 sek0 = 0;
; 0000 0560                 proces[0] = 5;
; 0000 0561                 }
; 0000 0562     break;
; 0000 0563 
; 0000 0564     case 5:
; 0000 0565             if(sek0 > 100)
; 0000 0566                 {
; 0000 0567                 PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
; 0000 0568                 sek0 = 0;
; 0000 0569                 proces[0] = 6;
; 0000 056A                 }
; 0000 056B 
; 0000 056C     break;
; 0000 056D 
; 0000 056E 
; 0000 056F     case 6:
; 0000 0570             if(sek0 > 100)
; 0000 0571                 {
; 0000 0572                 PORTC.5 = 1; //silownik 3 w gore
; 0000 0573                 sek0 = 0;
; 0000 0574                 proces[0] = 7;
; 0000 0575                 }
; 0000 0576     break;
; 0000 0577 
; 0000 0578     case 7:
; 0000 0579             if(sek0 > 100)
; 0000 057A                 {
; 0000 057B                 PORTC.5 = 0; //silownik 3 w dol
; 0000 057C                 sek0 = 0;
; 0000 057D                 proces[0] = 8;
; 0000 057E                 }
; 0000 057F     break;
; 0000 0580 
; 0000 0581     case 8:
; 0000 0582             if(sek0 > 100)
; 0000 0583                proces[0] = 9;
; 0000 0584     break;
; 0000 0585 
; 0000 0586     case 9:
; 0000 0587 
; 0000 0588          sek0 = 0;
; 0000 0589          proces[0] = 0;
; 0000 058A          wynik = 1;
; 0000 058B 
; 0000 058C     break;
; 0000 058D     }
; 0000 058E 
; 0000 058F return wynik;
; 0000 0590 }
;
;
;void wyczysc_maszyne_z_pretow_gwintowanych()
; 0000 0594 {
; 0000 0595 int i;
; 0000 0596 i=0;
;	i -> R16,R17
; 0000 0597 
; 0000 0598 
; 0000 0599 while(i == 0)
; 0000 059A     i = wyczysc_grzebienie();  //przenies raz grzebienie
; 0000 059B i = 0;
; 0000 059C while(i == 0)
; 0000 059D     i = pusc_pierwszego_preta();
; 0000 059E i = 0;
; 0000 059F while(i == 0)
; 0000 05A0     i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym jest pod klejem
; 0000 05A1 i = 0;
; 0000 05A2 while(i == 0)
; 0000 05A3     i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym jest pod zakrecaniem
; 0000 05A4 i = 0;
; 0000 05A5 
; 0000 05A6 while(i == 0)
; 0000 05A7     i = wyczysc_grzebienie();  //przenies raz grzebienie - po tym spada
; 0000 05AF komunikat_2_na_panel();
; 0000 05B0 
; 0000 05B1 }
;
;
;int obsluga_startowa_tasmy_lancuchowej()
; 0000 05B5 {
_obsluga_startowa_tasmy_lancuchowej:
; 0000 05B6 //int zaloczono_kurtyne;
; 0000 05B7 //zaloczono_kurtyne = 0;
; 0000 05B8 
; 0000 05B9 //PINF.6    czujnik ze jedzie lancuchowy
; 0000 05BA //0 - jedzie
; 0000 05BB //1 - stoi
; 0000 05BC 
; 0000 05BD //PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
; 0000 05BE             //jak monterzy zresetuja to sama mi sie pojawi 1
; 0000 05BF 
; 0000 05C0 
; 0000 05C1 //uproszczona obsluga
; 0000 05C2 //PORTE.5   sekwencja startowa pivexin
; 0000 05C3 //PORTE.6   manipulator wykonal pivexin
; 0000 05C4 //if(PINF.7 == 1)
; 0000 05C5 //            {
; 0000 05C6 //            zw = 99;
; 0000 05C7 //            wydaj_dzwiek();
; 0000 05C8 
; 0000 05C9 
; 0000 05CA //PORTE.5 = 1;
; 0000 05CB //delay_ms(300);
; 0000 05CC //PORTE.5 = 0;
; 0000 05CD //delay_ms(300);
; 0000 05CE //PORTE.6 = 1;
; 0000 05CF //delay_ms(300);
; 0000 05D0 //PORTE.6 = 0;
; 0000 05D1 
; 0000 05D2 switch(PINF.7)
	LDI  R30,0
	SBIC 0x0,7
	LDI  R30,1
; 0000 05D3     {
; 0000 05D4 case 0:  //zmieniam 28.06 bylo 0
	CPI  R30,0
	BREQ PC+3
	JMP _0xC9
; 0000 05D5         switch(sekwencja)
	LDS  R30,_sekwencja
	LDS  R31,_sekwencja+1
; 0000 05D6            {
; 0000 05D7            case 0:
	SBIW R30,0
	BRNE _0xCD
; 0000 05D8                     komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 05D9                     zaloczono_kurtyne = 0;
	CALL SUBOPT_0x45
; 0000 05DA                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 05DB                     delay_ms(400);  //delay_ms(400);
	CALL SUBOPT_0x46
; 0000 05DC                     sekwencja = 1;
	CALL SUBOPT_0x47
; 0000 05DD            break;
	RJMP _0xCC
; 0000 05DE            case 1:
_0xCD:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD0
; 0000 05DF                     PORTE.5 = 0;
	CBI  0x3,5
; 0000 05E0                     delay_ms(400);
	CALL SUBOPT_0x46
; 0000 05E1                     sekwencja = 2;
	CALL SUBOPT_0x48
; 0000 05E2            break;
	RJMP _0xCC
; 0000 05E3 
; 0000 05E4            case 2:
_0xD0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD3
; 0000 05E5                     PORTE.6 = 1;
	SBI  0x3,6
; 0000 05E6                     if(PINF.6 == 0)  //ze jedzie
	SBIC 0x0,6
	RJMP _0xD6
; 0000 05E7                         {
; 0000 05E8                         komunikat_czysc_na_panel();
	CALL SUBOPT_0x49
; 0000 05E9                         sekwencja = 3;
; 0000 05EA                         PORTE.6 = 0;
; 0000 05EB                         }
; 0000 05EC                     else
	RJMP _0xD9
_0xD6:
; 0000 05ED                         {
; 0000 05EE                         komunikat_12_na_panel();
	RCALL _komunikat_12_na_panel
; 0000 05EF                         //delay_ms(100);
; 0000 05F0                         }
_0xD9:
; 0000 05F1            break;
	RJMP _0xCC
; 0000 05F2 
; 0000 05F3            case 3:
_0xD3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xDA
; 0000 05F4                     if(PINF.6 == 1)  //ze stoi
	SBIS 0x0,6
	RJMP _0xDB
; 0000 05F5                     {
; 0000 05F6                     komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 05F7                     if(zajechalem == 2)
	LDS  R26,_zajechalem
	LDS  R27,_zajechalem+1
	SBIW R26,2
	BRNE _0xDC
; 0000 05F8                         zajechalem = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x4A
; 0000 05F9                     if(zajechalem == 0)
_0xDC:
	LDS  R30,_zajechalem
	LDS  R31,_zajechalem+1
	SBIW R30,0
	BRNE _0xDD
; 0000 05FA                         zajechalem = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x4A
; 0000 05FB                     sekwencja = 4;
_0xDD:
	CALL SUBOPT_0x4B
; 0000 05FC                     }
; 0000 05FD            break;
_0xDB:
	RJMP _0xCC
; 0000 05FE 
; 0000 05FF            case 4:
_0xDA:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0600 
; 0000 0601                     if(zajechalem == 2)
	CALL SUBOPT_0x4C
	SBIW R26,2
	BRNE _0xDF
; 0000 0602                         {
; 0000 0603                         delay_ms(400);
	CALL SUBOPT_0x46
; 0000 0604                         sekwencja = 2;
	CALL SUBOPT_0x48
; 0000 0605                         }
; 0000 0606                     else
	RJMP _0xE0
_0xDF:
; 0000 0607                         {
; 0000 0608                         zajechalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x4A
; 0000 0609                         sekwencja = 0;
	CALL SUBOPT_0x4D
; 0000 060A                         }
_0xE0:
; 0000 060B            break;
; 0000 060C            }
_0xCC:
; 0000 060D 
; 0000 060E 
; 0000 060F break;
	RJMP _0xC8
; 0000 0610 
; 0000 0611 case 1: //zmieniam 28.06 bylo 1
_0xC9:
	CPI  R30,LOW(0x1)
	BRNE _0xC8
; 0000 0612         komunikat_10_na_panel();
	RCALL _komunikat_10_na_panel
; 0000 0613         PORTE.5 = 0;
	CBI  0x3,5
; 0000 0614         PORTE.6 = 0;
	CBI  0x3,6
; 0000 0615         zajechalem = 0;
	CALL SUBOPT_0x4E
; 0000 0616         sekwencja = 0;
; 0000 0617         if(zaloczono_kurtyne == 0)
	LDS  R30,_zaloczono_kurtyne
	LDS  R31,_zaloczono_kurtyne+1
	SBIW R30,0
	BRNE _0xE6
; 0000 0618             {
; 0000 0619             zaloczono_kurtyne = 1;
	CALL SUBOPT_0x4F
; 0000 061A             licznik_wyzwolen_kurtyny++;
; 0000 061B             }
; 0000 061C         wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
_0xE6:
	CALL SUBOPT_0x50
; 0000 061D         delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 061E break;
; 0000 061F     }
_0xC8:
; 0000 0620 
; 0000 0621 return zajechalem;
	LDS  R30,_zajechalem
	LDS  R31,_zajechalem+1
	RET
; 0000 0622 }
;
;
;void przenies_pret_gwintowany()
; 0000 0626 {
_przenies_pret_gwintowany:
; 0000 0627 int zwrot;
; 0000 0628 int liczenie;
; 0000 0629 int rozpoczalem_ruch_preta;
; 0000 062A int zwloka_czasowa;
; 0000 062B long int time,time1;
; 0000 062C //int zaloczono_kurtyne;
; 0000 062D 
; 0000 062E //zaloczono_kurtyne = 0;
; 0000 062F 
; 0000 0630 liczenie = 0;
	SBIW R28,10
	CALL __SAVELOCR6
;	zwrot -> R16,R17
;	liczenie -> R18,R19
;	rozpoczalem_ruch_preta -> R20,R21
;	zwloka_czasowa -> Y+14
;	time -> Y+10
;	time1 -> Y+6
	__GETWRN 18,19,0
; 0000 0631 rozpoczalem_ruch_preta = 0;
	__GETWRN 20,21,0
; 0000 0632 licz = 0;
	CALL SUBOPT_0x14
; 0000 0633 time = 0;
	CALL SUBOPT_0x52
; 0000 0634 time1 = 0;
	CALL SUBOPT_0x53
; 0000 0635 zwrot = 1;  //wylaczam to na razie bo testuje czekam na ruch lanucha 27.06
	__GETWRN 16,17,1
; 0000 0636 //zwrot = 5;   //do testu czekam na ruch lanuchya
; 0000 0637 sekwencja = 0;
	CALL SUBOPT_0x4D
; 0000 0638 zwloka_czasowa = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 0639 
; 0000 063A 
; 0000 063B       //wylaczam to na razie bo testuje czekam na ruch lanucha 27.06
; 0000 063C 
; 0000 063D 
; 0000 063E if(start >=8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0xE7
; 0000 063F     //zw = 99;   //na razie do testow
; 0000 0640     //zw = 1;
; 0000 0641     sekwencja = 0;
	CALL SUBOPT_0x4D
; 0000 0642 else
	RJMP _0xE8
_0xE7:
; 0000 0643     sekwencja = 5;
	CALL SUBOPT_0x54
; 0000 0644     //zw = 0;
; 0000 0645 
; 0000 0646 
; 0000 0647 
; 0000 0648 
; 0000 0649 
; 0000 064A //to ponizej dziala na pewno ale kombinuje z kurtyna 22.03.2017
; 0000 064B 
; 0000 064C //while(zwrot == 1 | zwrot == 2 | zw == 1 | zw == 2 | zw == 3 | zw == 4 | zw == 5 | zw == 99)
; 0000 064D while(zwrot == 1 | zwrot == 2 | zwrot == 3 | zwrot == 4 | sekwencja == 0 | sekwencja == 1 | sekwencja == 2 | sekwencja == 3 | sekwencja == 4)
_0xE8:
_0xE9:
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	CALL SUBOPT_0x56
	CALL SUBOPT_0x58
	CALL SUBOPT_0x56
	CALL SUBOPT_0x59
	CALL SUBOPT_0x56
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	CALL SUBOPT_0x56
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	OR   R30,R0
	BRNE PC+3
	JMP _0xEB
; 0000 064E     {
; 0000 064F     if(zwrot == 1 | zwrot == 2 | zwrot == 3 | zwrot == 4)
	CALL SUBOPT_0x55
	OR   R30,R0
	BRNE PC+3
	JMP _0xEC
; 0000 0650             {
; 0000 0651             switch(zwrot)
	MOVW R30,R16
; 0000 0652                 {
; 0000 0653                 case 1:                                                       //30000 04.07
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0654                         if((rozpoczalem_ruch_preta == 1 & start >=8 & time1 > 20000) | (start < 8 & time1 > 3000))
	MOVW R26,R20
	CALL SUBOPT_0x58
	MOV  R0,R30
	CALL SUBOPT_0x5A
	AND  R0,R30
	CALL SUBOPT_0x5B
	__GETD1N 0x4E20
	CALL __GTD12
	AND  R30,R0
	MOV  R1,R30
	MOVW R26,R12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x5B
	__GETD1N 0xBB8
	CALL __GTD12
	AND  R30,R0
	OR   R30,R1
	BREQ _0xF1
; 0000 0655                             {
; 0000 0656                             if(start < 8)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0xF2
; 0000 0657                                 PORTB.5 = 1;  //si³ownik ma³y chwytania prêcika - chwycenie
	SBI  0x18,5
; 0000 0658                             zwrot = 2;
_0xF2:
	__GETWRN 16,17,2
; 0000 0659                             time1 = 0;
	CALL SUBOPT_0x53
; 0000 065A                             }
; 0000 065B                 break;
_0xF1:
	RJMP _0xEF
; 0000 065C                 case 2:
_0xF0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF5
; 0000 065D                         if((PINA.5 == 0 & start < 8) | (PINA.5 == 1 & start >= 8)) //kontrola ok - wywalam kontrolwe 14.09 bo koliduje jak sie zapetli nakretka
	CALL SUBOPT_0x5C
	MOV  R0,R30
	MOVW R26,R12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __LTW12
	AND  R30,R0
	MOV  R1,R30
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CALL SUBOPT_0x7
	CALL SUBOPT_0x5A
	AND  R30,R0
	OR   R30,R1
	BREQ _0xF6
; 0000 065E                             {
; 0000 065F                             PORTB.5 = 0; //si³ownik ma³y chwytania prêcika - puszczenie
	CBI  0x18,5
; 0000 0660                             PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem
	RJMP _0x2C9
; 0000 0661                             PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
; 0000 0662                             zwrot = 3;
; 0000 0663                             }
; 0000 0664                         else
_0xF6:
; 0000 0665                             {
; 0000 0666                             if(time1 > 100000 & PINA.7 == 1)
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x9
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5E
	BREQ _0xFE
; 0000 0667                                 {
; 0000 0668                                 wydaj_dzwiek();
	RCALL _wydaj_dzwiek
; 0000 0669                                 komunikat_13_na_panel();
	RCALL _komunikat_13_na_panel
; 0000 066A                                 PORTB.5 = 0;
	CBI  0x18,5
; 0000 066B                                 time1 = 100001;
	__GETD1N 0x186A1
	__PUTD1S 6
; 0000 066C                                 }
; 0000 066D                             if(time1 > 100000 & PINA.7 == 0)
_0xFE:
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x9
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5F
	BREQ _0x101
; 0000 066E                                 {
; 0000 066F                                 komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 0670                                 time1 = 0;
	CALL SUBOPT_0x53
; 0000 0671                                 PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem
_0x2C9:
	CBI  0x18,2
; 0000 0672                                 PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
	CBI  0x18,6
; 0000 0673                                 zwrot = 3;
	__GETWRN 16,17,3
; 0000 0674                                 }
; 0000 0675 
; 0000 0676                             }
_0x101:
; 0000 0677 
; 0000 0678                 break;
	RJMP _0xEF
; 0000 0679 
; 0000 067A                 case 3:
_0xF5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x106
; 0000 067B 
; 0000 067C 
; 0000 067D                         if(przejechalem_czujnik_lub_jestem_na_nim == 1)
	LDS  R26,_przejechalem_czujnik_lub_jestem_na_nim
	LDS  R27,_przejechalem_czujnik_lub_jestem_na_nim+1
	SBIW R26,1
	BRNE _0x107
; 0000 067E                             {
; 0000 067F                             //if(dlugosc_preta_gwintowanego < 70 & il_pretow_gwintowanych > 1 & start >= 6 & metalowe_grzybki == 0)
; 0000 0680                             //  PORTE.3 = 1;
; 0000 0681                             PORTB.7 = 0;  //zakoncz dociskanie preta
	CBI  0x18,7
; 0000 0682                             PORTD.0 = 1; //rozpcznij przeniesienie pret do nakladania kleju
	SBI  0x12,0
; 0000 0683                             przejechalem_czujnik_lub_jestem_na_nim = 0;
	LDI  R30,LOW(0)
	STS  _przejechalem_czujnik_lub_jestem_na_nim,R30
	STS  _przejechalem_czujnik_lub_jestem_na_nim+1,R30
; 0000 0684                             }
; 0000 0685                         if(PINA.4 == 1 & przejechalem_czujnik_lub_jestem_na_nim == 0)
_0x107:
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CALL SUBOPT_0x7
	LDS  R26,_przejechalem_czujnik_lub_jestem_na_nim
	LDS  R27,_przejechalem_czujnik_lub_jestem_na_nim+1
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x10C
; 0000 0686                             {
; 0000 0687                             PORTD.0 = 1; //czujnik juz nie swieci, czyli jade dalej
	SBI  0x12,0
; 0000 0688                             przejechalem_czujnik_lub_jestem_na_nim = 1;
	CALL SUBOPT_0x60
; 0000 0689                             grzybek_jest_nakrecony_na_precie = 0;
	CALL SUBOPT_0x61
; 0000 068A                             sek1 = 0;
	CALL SUBOPT_0x62
; 0000 068B                             zwrot = 4;
	__GETWRN 16,17,4
; 0000 068C                             }
; 0000 068D 
; 0000 068E                 break;
_0x10C:
	RJMP _0xEF
; 0000 068F 
; 0000 0690                 case 4:
_0x106:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0691 
; 0000 0692                     if(PINF.2 == 0)
	SBIC 0x0,2
	RJMP _0x110
; 0000 0693                         grzybek_jest_nakrecony_na_precie = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _grzybek_jest_nakrecony_na_precie,R30
	STS  _grzybek_jest_nakrecony_na_precie+1,R31
; 0000 0694 
; 0000 0695 
; 0000 0696                     if(PINA.4 == 0)  //dojechalem znowu do czujnika
_0x110:
	SBIC 0x19,4
	RJMP _0x111
; 0000 0697                         {
; 0000 0698                         //if(grzybek_jest_nakrecony_na_precie == 0)
; 0000 0699                         //    licznik_wylatujacych_grzybkow++;
; 0000 069A                         //PORTD.0 = 0; //wylacz silnik      //zwalniam 20.09.2018
; 0000 069B                         //zwrot = 5;
; 0000 069C                         sek1 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x62
; 0000 069D                         zwloka_czasowa = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 069E                         }
; 0000 069F 
; 0000 06A0                     if(zwloka_czasowa == 1 & sek1 > 5)
_0x111:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x58
	MOV  R0,R30
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
	AND  R30,R0
	BREQ _0x112
; 0000 06A1                         {
; 0000 06A2                         PORTD.0 = 0;
	CBI  0x12,0
; 0000 06A3                         sek1 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x62
; 0000 06A4                         zwloka_czasowa = 0;
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
; 0000 06A5                         zwrot = 5;
	__GETWRN 16,17,5
; 0000 06A6                         }
; 0000 06A7 
; 0000 06A8 
; 0000 06A9                 break;
_0x112:
; 0000 06AA                 }
_0xEF:
; 0000 06AB             }
; 0000 06AC 
; 0000 06AD //PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
; 0000 06AE                         //jak monterzy zresetuja to sama mi sie pojawi 1
; 0000 06AF 
; 0000 06B0     switch(PINF.7)
_0xEC:
	LDI  R30,0
	SBIC 0x0,7
	LDI  R30,1
; 0000 06B1     {
; 0000 06B2     case 0:    //zmieniam 28.06 bylo 0
	CPI  R30,0
	BREQ PC+3
	JMP _0x118
; 0000 06B3         switch(sekwencja)
	LDS  R30,_sekwencja
	LDS  R31,_sekwencja+1
; 0000 06B4            {
; 0000 06B5            case 0:
	SBIW R30,0
	BRNE _0x11C
; 0000 06B6                     if(PINF.7 == 0 & PINF.3 == 0)
	CALL SUBOPT_0x65
	LDI  R26,0
	SBIC 0x0,3
	LDI  R26,1
	CALL SUBOPT_0x5F
	BREQ _0x11D
; 0000 06B7                     {
; 0000 06B8                     zaloczono_kurtyne = 0;
	CALL SUBOPT_0x45
; 0000 06B9                     komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 06BA                     PORTE.5 = 1;
	SBI  0x3,5
; 0000 06BB                     time = 0;
	CALL SUBOPT_0x52
; 0000 06BC                     sekwencja = 1;
	CALL SUBOPT_0x47
; 0000 06BD                     }
; 0000 06BE                     else
	RJMP _0x120
_0x11D:
; 0000 06BF                         {
; 0000 06C0                         if(PINF.3 == 1 & liczenie == 0)
	LDI  R26,0
	SBIC 0x0,3
	LDI  R26,1
	CALL SUBOPT_0x7
	MOVW R26,R18
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x121
; 0000 06C1                             {
; 0000 06C2                             licznik_spoznien_monter_1_2++;
	LDI  R26,LOW(_licznik_spoznien_monter_1_2)
	LDI  R27,HIGH(_licznik_spoznien_monter_1_2)
	CALL SUBOPT_0x4
; 0000 06C3                             liczenie = 1;
	__GETWRN 18,19,1
; 0000 06C4                             }
; 0000 06C5                         break;
_0x121:
	RJMP _0x11B
; 0000 06C6                         }
_0x120:
; 0000 06C7            break;                                 //& PINF.1 == 0
	RJMP _0x11B
; 0000 06C8            case 1:                    //silownik chwytania lancy
_0x11C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x122
; 0000 06C9                     if(PINF.7 == 0 & PORTB.1 == 0)
	CALL SUBOPT_0x65
	LDI  R26,0
	SBIC 0x18,1
	LDI  R26,1
	CALL SUBOPT_0x5F
	BREQ _0x123
; 0000 06CA                     {
; 0000 06CB                     if(time > 1000)  //7500 04.07.2017 dziala bez zarzutu, to byla wina chyba przekaznikow i opoznien na nich, zmieniam tak jak bylo
	CALL SUBOPT_0x66
	BRLT _0x124
; 0000 06CC                         {
; 0000 06CD                         PORTE.5 = 0;
	CBI  0x3,5
; 0000 06CE                         sekwencja = 2;
	CALL SUBOPT_0x48
; 0000 06CF                         time = 0;
	CALL SUBOPT_0x52
; 0000 06D0                         }
; 0000 06D1 
; 0000 06D2                     }
_0x124:
; 0000 06D3                     else
	RJMP _0x127
_0x123:
; 0000 06D4                         break;
	RJMP _0x11B
; 0000 06D5            break;
_0x127:
	RJMP _0x11B
; 0000 06D6 
; 0000 06D7            case 2:                 //& PINF.1 == 0
_0x122:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x128
; 0000 06D8                     if(PINF.7 == 0)
	SBIC 0x0,7
	RJMP _0x129
; 0000 06D9                     {
; 0000 06DA                     if(time > 1000)   ////7500  04.07.2017
	CALL SUBOPT_0x66
	BRLT _0x12A
; 0000 06DB                     {
; 0000 06DC                     PORTE.6 = 1;
	SBI  0x3,6
; 0000 06DD                     if(PINF.6 == 0)  //ze jedzie
	SBIC 0x0,6
	RJMP _0x12D
; 0000 06DE                         {
; 0000 06DF                         rozpoczalem_ruch_preta = 1;
	__GETWRN 20,21,1
; 0000 06E0                         time1 = 0;   //zeby sekunde odczekac z chwyceniem
	CALL SUBOPT_0x53
; 0000 06E1                         komunikat_czysc_na_panel();
	CALL SUBOPT_0x49
; 0000 06E2                         sekwencja = 3;
; 0000 06E3                         PORTE.6 = 0;
; 0000 06E4                         time = 0;
	CALL SUBOPT_0x52
; 0000 06E5                         }
; 0000 06E6                     else
	RJMP _0x130
_0x12D:
; 0000 06E7                         {
; 0000 06E8                         komunikat_12_na_panel();
	RCALL _komunikat_12_na_panel
; 0000 06E9                         }
_0x130:
; 0000 06EA                     }
; 0000 06EB                     }
_0x12A:
; 0000 06EC                     else
	RJMP _0x131
_0x129:
; 0000 06ED                         {
; 0000 06EE                         PORTB.1 = 0;
	CBI  0x18,1
; 0000 06EF                         break;
	RJMP _0x11B
; 0000 06F0                         }
_0x131:
; 0000 06F1 
; 0000 06F2            break;
	RJMP _0x11B
; 0000 06F3 
; 0000 06F4            case 3:
_0x128:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x134
; 0000 06F5                     if(PINF.6 == 1)  //ze stoi
	SBIS 0x0,6
	RJMP _0x135
; 0000 06F6                     {
; 0000 06F7                     komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 06F8                     PORTE.6 = 0;
	CBI  0x3,6
; 0000 06F9                     if(time > 6000)      //to bêdzie chyba to......to powoduje jechanie dwa razy...zmieniam to na 6000..bylo 60000  12.20.2017
	__GETD2S 10
	__CPD2N 0x1771
	BRLT _0x138
; 0000 06FA                         sekwencja = 4;
	CALL SUBOPT_0x4B
; 0000 06FB                     else
	RJMP _0x139
_0x138:
; 0000 06FC                         sekwencja = 0;
	CALL SUBOPT_0x4D
; 0000 06FD                     }
_0x139:
; 0000 06FE            break;
_0x135:
	RJMP _0x11B
; 0000 06FF            case 4:
_0x134:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0700                     sekwencja = 5;
	CALL SUBOPT_0x54
; 0000 0701                     if(start >= 10 & tryb_male_puchary == 0)
	CALL SUBOPT_0x67
	MOV  R0,R30
	CALL SUBOPT_0x68
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x13B
; 0000 0702                         PORTD.2 = 1;  //komunikacja bez rs232 zgodna na zacisniecie szczek
	SBI  0x12,2
; 0000 0703                     if(start >= 9 & tryb_male_puchary == 1)
_0x13B:
	CALL SUBOPT_0x69
	CALL SUBOPT_0x6A
	AND  R30,R0
	BREQ _0x13E
; 0000 0704                         PORTD.2 = 1;  //komunikacja bez rs232 zgodna na wysuniecie silownika otwierajacego wieze
	SBI  0x12,2
; 0000 0705            break;
_0x13E:
; 0000 0706 
; 0000 0707            }
_0x11B:
; 0000 0708 
; 0000 0709 
; 0000 070A     break;
	RJMP _0x117
; 0000 070B 
; 0000 070C     case 1: //zmieniam 28.06 bylo 1
_0x118:
	CPI  R30,LOW(0x1)
	BRNE _0x117
; 0000 070D         komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 070E         komunikat_10_na_panel();
	RCALL _komunikat_10_na_panel
; 0000 070F 
; 0000 0710         PORTE.5 = 0;
	CBI  0x3,5
; 0000 0711         PORTE.6 = 0;
	CBI  0x3,6
; 0000 0712         PORTD.2 = 0;   //koniec zezwolenia na zacisniecie szczek
	CBI  0x12,2
; 0000 0713         sekwencja = 0;
	CALL SUBOPT_0x4D
; 0000 0714         time = 0;
	CALL SUBOPT_0x52
; 0000 0715         if(zaloczono_kurtyne == 0)
	LDS  R30,_zaloczono_kurtyne
	LDS  R31,_zaloczono_kurtyne+1
	SBIW R30,0
	BRNE _0x148
; 0000 0716             {
; 0000 0717             zaloczono_kurtyne = 1;
	CALL SUBOPT_0x4F
; 0000 0718             licznik_wyzwolen_kurtyny++;
; 0000 0719             }
; 0000 071A     break;
_0x148:
; 0000 071B     }
_0x117:
; 0000 071C 
; 0000 071D 
; 0000 071E 
; 0000 071F 
; 0000 0720 
; 0000 0721     time++;
	__GETD1S 10
	CALL SUBOPT_0x6B
	__PUTD1S 10
; 0000 0722     time1++;
	__GETD1S 6
	CALL SUBOPT_0x6B
	__PUTD1S 6
; 0000 0723     }
	RJMP _0xE9
_0xEB:
; 0000 0724 
; 0000 0725 
; 0000 0726 
; 0000 0727 }
	CALL __LOADLOCR6
_0x20A0002:
	ADIW R28,16
	RET
;
;
;void komunikacja_startowa_male_puchary(int wynik_wyboru_male_puchary)
; 0000 072B {
_komunikacja_startowa_male_puchary:
; 0000 072C int licznik_impulsow_male_puchary;
; 0000 072D int znacznik;
; 0000 072E 
; 0000 072F licznik_impulsow_male_puchary = 0;
	CALL __SAVELOCR4
;	wynik_wyboru_male_puchary -> Y+4
;	licznik_impulsow_male_puchary -> R16,R17
;	znacznik -> R18,R19
	CALL SUBOPT_0x37
; 0000 0730 znacznik = 0;
; 0000 0731 
; 0000 0732 PORTD.6 = 1;
	SBI  0x12,6
; 0000 0733 delay_ms(500);
	CALL SUBOPT_0x6C
; 0000 0734 while(licznik_impulsow_male_puchary < wynik_wyboru_male_puchary)    //3 oznacza brak malych pucharow
_0x14B:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x14D
; 0000 0735 {
; 0000 0736 if(PINF.1 == 1)
	SBIS 0x0,1
	RJMP _0x14E
; 0000 0737     {
; 0000 0738     PORTD.3 = 1;
	SBI  0x12,3
; 0000 0739     znacznik = 1;
	__GETWRN 18,19,1
; 0000 073A     }
; 0000 073B 
; 0000 073C if(PINF.1 == 0 & znacznik == 1)
_0x14E:
	LDI  R26,0
	SBIC 0x0,1
	LDI  R26,1
	CALL SUBOPT_0x6D
	MOVW R26,R18
	CALL SUBOPT_0x58
	AND  R30,R0
	BREQ _0x151
; 0000 073D     {            //czekaj
; 0000 073E     PORTD.3 = 0;
	CBI  0x12,3
; 0000 073F     znacznik = 2;
	__GETWRN 18,19,2
; 0000 0740     }
; 0000 0741 
; 0000 0742 if(znacznik == 2)
_0x151:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x154
; 0000 0743     {
; 0000 0744     licznik_impulsow_male_puchary++;
	__ADDWRN 16,17,1
; 0000 0745     znacznik = 3;
	__GETWRN 18,19,3
; 0000 0746     }
; 0000 0747 
; 0000 0748 }
_0x154:
	RJMP _0x14B
_0x14D:
; 0000 0749 delay_ms(500);
	CALL SUBOPT_0x6C
; 0000 074A PORTD.6 = 0;
	CBI  0x12,6
; 0000 074B 
; 0000 074C }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;
;
;
;int ustawienia_startowe()
; 0000 0752 {
_ustawienia_startowe:
; 0000 0753 
; 0000 0754 wartosci_wstepne_panelu();
	RCALL _wartosci_wstepne_panelu
; 0000 0755 
; 0000 0756 while(PINA.0 == 0)//brak cisnienia
_0x157:
	SBIC 0x19,0
	RJMP _0x159
; 0000 0757     komunikat_7_na_panel();
	RCALL _komunikat_7_na_panel
	RJMP _0x157
_0x159:
; 0000 0758 komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 0759 
; 0000 075A obsluga_startowa_dozownika_kleju();
	RCALL _obsluga_startowa_dozownika_kleju
; 0000 075B komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 075C komunikat_1_na_panel();
	RCALL _komunikat_1_na_panel
; 0000 075D //obsluga_startowa_dozownika_kleju_slave();
; 0000 075E komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 075F 
; 0000 0760 while(PINA.4 == 1)  //jak nie widzi czujnika przenosnik pretow czyli nie wiadomo gdzie jestesmy
_0x15A:
	SBIS 0x19,4
	RJMP _0x15C
; 0000 0761     PORTD.0 = 1; //silnik przenosnika pretow
	SBI  0x12,0
	RJMP _0x15A
_0x15C:
; 0000 0762 przejechalem_czujnik_lub_jestem_na_nim = 1;
	CALL SUBOPT_0x60
; 0000 0763 
; 0000 0764 
; 0000 0765 
; 0000 0766 PORTD.0 = 0;
	CBI  0x12,0
; 0000 0767 PORTC.3 = 0;  //silownik na ktorym jest silnik dokrecajacy grzybki
	CBI  0x15,3
; 0000 0768 PORTC.1 = 0;  //silownik pobierania grzybow duzy
	CBI  0x15,1
; 0000 0769 PORTC.2 = 1;  //silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
	SBI  0x15,2
; 0000 076A PORTE.2 = 0;  //silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
	CBI  0x3,2
; 0000 076B PORTB.7 = 0;   //silownik dociskajacy pret na grzybkach
	CBI  0x18,7
; 0000 076C 
; 0000 076D inicjalizacja_orientator_grzybkow();
	RCALL _inicjalizacja_orientator_grzybkow
; 0000 076E komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 076F komunikat_3_na_panel();
	RCALL _komunikat_3_na_panel
; 0000 0770 
; 0000 0771 while(z == 0)
_0x16B:
	LDS  R30,_z
	CPI  R30,0
	BRNE _0x16D
; 0000 0772 {
; 0000 0773 //obsluga oproznienia grzybkow
; 0000 0774 odpytaj_parametry_z_panelu(1);
	CALL SUBOPT_0x6E
; 0000 0775 if(oproznij_podajnik == 1)
	LDS  R26,_oproznij_podajnik
	LDS  R27,_oproznij_podajnik+1
	SBIW R26,1
	BRNE _0x16E
; 0000 0776     {
; 0000 0777     delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 0778     PORTC.2 = 0;  //silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
	CALL SUBOPT_0x6F
; 0000 0779     PORTE.2 = 1;  //silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
; 0000 077A     delay_ms(3000);
; 0000 077B     PORTC.1 = 1;  //silownik pobierania grzybow duzy - cofamy sie
	SBI  0x15,1
; 0000 077C     delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x70
; 0000 077D     PORTC.2 = 1;  //silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
	SBI  0x15,2
; 0000 077E     PORTE.2 = 0;  //silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
	CBI  0x3,2
; 0000 077F     delay_ms(2000);
	CALL SUBOPT_0x71
; 0000 0780     PORTC.2 = 0;  //silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
	CALL SUBOPT_0x6F
; 0000 0781     PORTE.2 = 1;  //silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
; 0000 0782     delay_ms(3000);
; 0000 0783     PORTC.1 = 0;  //silownik pobierania grzybow duzy
	CBI  0x15,1
; 0000 0784 
; 0000 0785     komunikat_9_na_panel();
	RCALL _komunikat_9_na_panel
; 0000 0786 
; 0000 0787     /*
; 0000 0788     while(1)
; 0000 0789         {
; 0000 078A         delay_ms(1000);
; 0000 078B         PORTC.1 = 0;  //silownik pobierania grzybow duzy
; 0000 078C         delay_ms(1000);
; 0000 078D         PORTC.1 = 1;  //silownik pobierania grzybow duzy
; 0000 078E         }
; 0000 078F     */
; 0000 0790 
; 0000 0791     while(1);
_0x17F:
	RJMP _0x17F
; 0000 0792         {
; 0000 0793         }
; 0000 0794     }
; 0000 0795 
; 0000 0796 //obsluga guzika start
; 0000 0797 z = czekaj_na_guzik_start();
_0x16E:
	CALL SUBOPT_0x72
; 0000 0798 }
	RJMP _0x16B
_0x16D:
; 0000 0799 z = 0;
	LDI  R30,LOW(0)
	STS  _z,R30
; 0000 079A 
; 0000 079B 
; 0000 079C przenies_pret_gwintowany(); //teraz mozemy spasc pierwszym pretem ze zjezdzalni
	RCALL _przenies_pret_gwintowany
; 0000 079D PORTC.5 = 1; //silownik ostatni otwarcie
	SBI  0x15,5
; 0000 079E delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 079F PORTC.5 = 0;
	CBI  0x15,5
; 0000 07A0 przenies_pret_gwintowany();
	RCALL _przenies_pret_gwintowany
; 0000 07A1 delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 07A2 przenies_pret_gwintowany();
	RCALL _przenies_pret_gwintowany
; 0000 07A3 delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 07A4 przenies_pret_gwintowany();
	RCALL _przenies_pret_gwintowany
; 0000 07A5 
; 0000 07A6 zajechalem = 0;
	CALL SUBOPT_0x4E
; 0000 07A7 sekwencja = 0;
; 0000 07A8 
; 0000 07A9 
; 0000 07AA //if(PINF.1 == 1)
; 0000 07AB //    while(1)
; 0000 07AC //        {
; 0000 07AD //        }
; 0000 07AE 
; 0000 07AF while(zajechalem == 0 | zajechalem == 2 | zajechalem == 3)
_0x186:
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x24
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x59
	OR   R0,R30
	CALL SUBOPT_0x4C
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x188
; 0000 07B0     zajechalem = obsluga_startowa_tasmy_lancuchowej();
	RCALL _obsluga_startowa_tasmy_lancuchowej
	CALL SUBOPT_0x4A
	RJMP _0x186
_0x188:
; 0000 07B1 zajechalem = 0;
	LDI  R30,LOW(0)
	STS  _zajechalem,R30
	STS  _zajechalem+1,R30
; 0000 07B2 
; 0000 07B3 /*
; 0000 07B4 while(1)
; 0000 07B5 {
; 0000 07B6 delay_ms(1000);
; 0000 07B7 delay_ms(1000);
; 0000 07B8 delay_ms(1000);
; 0000 07B9 delay_ms(1000);
; 0000 07BA delay_ms(1000);
; 0000 07BB delay_ms(1000);
; 0000 07BC //sekwencna testowa
; 0000 07BD przenies_pret_gwintowany();
; 0000 07BE }
; 0000 07BF */
; 0000 07C0 
; 0000 07C1 
; 0000 07C2 /*
; 0000 07C3 while(1)
; 0000 07C4 {
; 0000 07C5 if(PINA.7 == 0)
; 0000 07C6     {
; 0000 07C7     PORTB.5 = 1; //si³ownik ma³y chwytania prêcika - zlap
; 0000 07C8     PORTB.1 = 1; //si³ownik chwytania lancy - zlap
; 0000 07C9     PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
; 0000 07CA     delay_ms(1000);
; 0000 07CB     PORTB.6 = 1; //silownik obrotowy na ktorym jest maly chwytajacy precik
; 0000 07CC     delay_ms(1000);
; 0000 07CD     PORTB.2 = 1; //wkladanie do lancy precika z grzybkiem
; 0000 07CE     delay_ms(1000);
; 0000 07CF     PORTB.0 = 0; //zamkniecie szczek w lancy - silownik z boku
; 0000 07D0     delay_ms(500);
; 0000 07D1     while(PINA.7 == 0)
; 0000 07D2         {
; 0000 07D3         }
; 0000 07D4     }
; 0000 07D5 else
; 0000 07D6     {
; 0000 07D7     PORTB.5 = 0; //si³ownik ma³y chwytania prêcika - pusc
; 0000 07D8     delay_ms(2000);
; 0000 07D9     PORTB.1 = 0; //si³ownik chwytania lancy - pusc
; 0000 07DA     //PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem
; 0000 07DB     //PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik
; 0000 07DC     delay_ms(2000);
; 0000 07DD     }
; 0000 07DE                                              //& PORTB.2 == 0 & PORTB.6 == 0
; 0000 07DF if(PINF.0 == 0 & PORTB.5 == 0 & PORTB.1 == 0 & PORTB.0 == 0)  //pedal
; 0000 07E0     {
; 0000 07E1     PORTE.6 = 1;
; 0000 07E2     delay_ms(500);
; 0000 07E3     PORTE.6 = 0;
; 0000 07E4     delay_ms(500);
; 0000 07E5     PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem
; 0000 07E6     PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik
; 0000 07E7     delay_ms(100);
; 0000 07E8     }
; 0000 07E9 
; 0000 07EA }
; 0000 07EB */
; 0000 07EC 
; 0000 07ED delay_ms(1000);
	CALL SUBOPT_0x51
; 0000 07EE odpytaj_parametry_z_panelu(1);
	CALL SUBOPT_0x6E
; 0000 07EF 
; 0000 07F0 //////////////////////////////////////////////
; 0000 07F1 
; 0000 07F2 
; 0000 07F3 if(tryb_male_puchary == 1)
	CALL SUBOPT_0x68
	SBIW R26,1
	BRNE _0x189
; 0000 07F4     komunikacja_startowa_male_puchary(wynik_wyboru_male_puchary);
	CALL SUBOPT_0x73
; 0000 07F5 
; 0000 07F6 PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje
_0x189:
	SBI  0x15,4
; 0000 07F7 
; 0000 07F8 return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 07F9 }
;
;int czekaj_na_klej()
; 0000 07FC {
_czekaj_na_klej:
; 0000 07FD /*
; 0000 07FE if(PINA.6 == 1)
; 0000 07FF   {
; 0000 0800   komunikat_8_na_panel(0); //dozownik kleju nie gotowy
; 0000 0801   delay_ms(1000);
; 0000 0802   klej = 0;
; 0000 0803   d = 1;
; 0000 0804   }
; 0000 0805 */
; 0000 0806 
; 0000 0807 /*
; 0000 0808 
; 0000 0809 if(PINA.6 == 0 | PINA.6 == 1)
; 0000 080A   {
; 0000 080B   if(d == 1)
; 0000 080C      {
; 0000 080D      komunikat_czysc_na_panel();
; 0000 080E      d = 0;
; 0000 080F      }
; 0000 0810 
; 0000 0811   klej = 1;
; 0000 0812   }
; 0000 0813 */
; 0000 0814 
; 0000 0815 klej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x74
; 0000 0816 return klej;
	LDS  R30,_klej
	LDS  R31,_klej+1
	RET
; 0000 0817 }
;
;
;int czekaj_na_odpuszczenie_szczek()
; 0000 081B {
_czekaj_na_odpuszczenie_szczek:
; 0000 081C int spr;
; 0000 081D 
; 0000 081E PORTE.7 = 1;//do komunikacji ¿adanie
	ST   -Y,R17
	ST   -Y,R16
;	spr -> R16,R17
	SBI  0x3,7
; 0000 081F 
; 0000 0820 //putchar1(4);  //ze dotyczy szczek
; 0000 0821 //spr = getchar1();
; 0000 0822 //PORTE.7 = 0;//do komunikacji koniec ¿adania
; 0000 0823 
; 0000 0824 if(PINF.1 == 0)
	SBIC 0x0,1
	RJMP _0x18E
; 0000 0825     spr = 1;
	__GETWRN 16,17,1
; 0000 0826 else
	RJMP _0x18F
_0x18E:
; 0000 0827    spr = 0;
	__GETWRN 16,17,0
; 0000 0828 
; 0000 0829 
; 0000 082A if(spr == 0)
_0x18F:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x190
; 0000 082B   {
; 0000 082C   if(czekaj_komunikat == 5)
	LDS  R26,_czekaj_komunikat
	LDS  R27,_czekaj_komunikat+1
	SBIW R26,5
	BRNE _0x191
; 0000 082D         {
; 0000 082E         komunikat_11_na_panel(); //monter nie nacisnal pedala
	RCALL _komunikat_11_na_panel
; 0000 082F         czekaj_komunikat = 0;
	CALL SUBOPT_0x75
; 0000 0830         }
; 0000 0831   czekaj_komunikat++;
_0x191:
	LDI  R26,LOW(_czekaj_komunikat)
	LDI  R27,HIGH(_czekaj_komunikat)
	CALL SUBOPT_0x4
; 0000 0832   monter_slave = 0;
	CALL SUBOPT_0x76
; 0000 0833   gg = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _gg,R30
	STS  _gg+1,R31
; 0000 0834   }
; 0000 0835 
; 0000 0836 if(spr == 1)
_0x190:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x192
; 0000 0837   {
; 0000 0838   czekaj_komunikat = 0;
	CALL SUBOPT_0x75
; 0000 0839   if(gg == 1)
	LDS  R26,_gg
	LDS  R27,_gg+1
	SBIW R26,1
	BRNE _0x193
; 0000 083A      {
; 0000 083B      komunikat_czysc_na_panel();
	RCALL _komunikat_czysc_na_panel
; 0000 083C      gg = 0;
	LDI  R30,LOW(0)
	STS  _gg,R30
	STS  _gg+1,R30
; 0000 083D      }
; 0000 083E 
; 0000 083F   monter_slave = 1;
_0x193:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x77
; 0000 0840   PORTE.7 = 0;
	CBI  0x3,7
; 0000 0841   PORTD.2 = 0;  //komunikacja bez rs232 KONIEC zgody na zacisniecie szczek
	CBI  0x12,2
; 0000 0842   }
; 0000 0843 
; 0000 0844 return monter_slave;
_0x192:
	LDS  R30,_monter_slave
	LDS  R31,_monter_slave+1
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0845 
; 0000 0846 }
;
;
;int czekaj_na_widzenie_puchara_przez_czujnik()
; 0000 084A {
; 0000 084B int spr;
; 0000 084C 
; 0000 084D PORTE.7 = 1;//do komunikacji ¿adanie
;	spr -> R16,R17
; 0000 084E putchar1(6);  //ze dotyczy czujnika widzenia puchara
; 0000 084F spr = getchar1();
; 0000 0850 PORTE.7 = 0;//do komunikacji koniec ¿adania
; 0000 0851 
; 0000 0852 if(spr == 0)
; 0000 0853   {
; 0000 0854   if(czekaj_komunikat == 5)
; 0000 0855         {
; 0000 0856         komunikat_17_na_panel(); //czujnik nie zobaczyl
; 0000 0857         czekaj_komunikat = 0;
; 0000 0858         }
; 0000 0859   czekaj_komunikat++;
; 0000 085A   //delay_ms(1000);
; 0000 085B   monter_slave = 0;
; 0000 085C   gg = 1;
; 0000 085D   }
; 0000 085E 
; 0000 085F if(spr == 1)
; 0000 0860   {
; 0000 0861   czekaj_komunikat = 0;
; 0000 0862   if(gg == 1)
; 0000 0863      {
; 0000 0864      komunikat_czysc_na_panel();
; 0000 0865      gg = 0;
; 0000 0866      }
; 0000 0867 
; 0000 0868   monter_slave = 1;
; 0000 0869   }
; 0000 086A 
; 0000 086B return monter_slave;
; 0000 086C 
; 0000 086D }
;
;
;
;int czekaj_na_klej_slave()
; 0000 0872 {
; 0000 0873 int spr;
; 0000 0874 
; 0000 0875 PORTE.7 = 1;//do komunikacji ¿adanie
;	spr -> R16,R17
; 0000 0876 putchar1(1);  //ze dotyczy kleju
; 0000 0877 spr = getchar1();
; 0000 0878 PORTE.7 = 0;//do komunikacji koniec ¿adania
; 0000 0879 
; 0000 087A if(spr == 0)
; 0000 087B   {
; 0000 087C   komunikat_8_na_panel(1); //dozownik kleju nie gotowy
; 0000 087D   delay_ms(1000);
; 0000 087E   klej_slave = 0;
; 0000 087F   dd = 1;
; 0000 0880   }
; 0000 0881 
; 0000 0882 if(spr == 1)
; 0000 0883   {
; 0000 0884   if(dd == 1)
; 0000 0885      {
; 0000 0886      komunikat_czysc_na_panel();
; 0000 0887      dd = 0;
; 0000 0888      }
; 0000 0889 
; 0000 088A   klej_slave = 1;
; 0000 088B   }
; 0000 088C 
; 0000 088D return klej_slave;
; 0000 088E 
; 0000 088F }
;
;
;
;int proces_0()
; 0000 0894 {
_proces_0:
; 0000 0895 int wynik;
; 0000 0896 wynik = 0;
	CALL SUBOPT_0xB
;	wynik -> R16,R17
; 0000 0897 
; 0000 0898 switch(proces[0])
	LDS  R30,_proces
	LDS  R31,_proces+1
; 0000 0899     {
; 0000 089A     case 0:
	SBIW R30,0
	BRNE _0x1AA
; 0000 089B         proces[0] = 1;
	CALL SUBOPT_0x78
; 0000 089C         zerowanie_czasu();
	CALL _zerowanie_czasu
; 0000 089D 
; 0000 089E     break;
	RJMP _0x1A9
; 0000 089F 
; 0000 08A0     case 1:
_0x1AA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1AB
; 0000 08A1             PORTC.7 = 1;      //silownik 1 w gore
	SBI  0x15,7
; 0000 08A2             if(PINA.2 == 0 & PINA.3 == 0)  //widzi preta
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
	BREQ _0x1AE
; 0000 08A3                 {
; 0000 08A4                 sek0_7s = 0;
	LDI  R30,LOW(0)
	STS  _sek0_7s,R30
	STS  _sek0_7s+1,R30
	STS  _sek0_7s+2,R30
	STS  _sek0_7s+3,R30
; 0000 08A5                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08A6                 proces[0] = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7C
; 0000 08A7                 jest_pret_pod_czujnikami = 1;
	CALL SUBOPT_0x7D
; 0000 08A8                 komunikat_5_na_panel();
	RCALL _komunikat_5_na_panel
; 0000 08A9                 }
; 0000 08AA             else
	RJMP _0x1AF
_0x1AE:
; 0000 08AB                 {
; 0000 08AC                 komunikat_4_na_panel();
	RCALL _komunikat_4_na_panel
; 0000 08AD 
; 0000 08AE                 }
_0x1AF:
; 0000 08AF     break;
	RJMP _0x1A9
; 0000 08B0 
; 0000 08B1     case 2:
_0x1AB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1B0
; 0000 08B2             if(sek0 > 40)  //silownik 1 w dol
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
	BRLT _0x1B1
; 0000 08B3                 {
; 0000 08B4                 PORTC.7 = 0;
	CBI  0x15,7
; 0000 08B5                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08B6                 proces[0] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7C
; 0000 08B7                 }
; 0000 08B8     break;
_0x1B1:
	RJMP _0x1A9
; 0000 08B9     case 3:
_0x1B0:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B4
; 0000 08BA             if(sek0 > 20)  //20 13.09  //60   //40 11.23
	CALL SUBOPT_0x80
	BRLT _0x1B5
; 0000 08BB                 {
; 0000 08BC                 PORTC.6 = 1; //silownik 2 w gore
	SBI  0x15,6
; 0000 08BD                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08BE                 proces[0] = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7C
; 0000 08BF                 }
; 0000 08C0 
; 0000 08C1     break;
_0x1B5:
	RJMP _0x1A9
; 0000 08C2     case 4:
_0x1B4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1B8
; 0000 08C3             if(sek0 > 20) //20 13.09  //60    //40 11.23
	CALL SUBOPT_0x80
	BRLT _0x1B9
; 0000 08C4                 {
; 0000 08C5                 PORTC.6 = 0; //silownik 2 w dol
	CBI  0x15,6
; 0000 08C6                 PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
	SBI  0x18,4
; 0000 08C7                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08C8                 proces[0] = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x7C
; 0000 08C9                 }
; 0000 08CA     break;
_0x1B9:
	RJMP _0x1A9
; 0000 08CB 
; 0000 08CC     case 5:
_0x1B8:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1BE
; 0000 08CD             if(sek0 > 40)       //60
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
	BRLT _0x1BF
; 0000 08CE                 {
; 0000 08CF                 PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
	CBI  0x18,4
; 0000 08D0                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08D1                 proces[0] = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x7C
; 0000 08D2                 }
; 0000 08D3 
; 0000 08D4     break;
_0x1BF:
	RJMP _0x1A9
; 0000 08D5 
; 0000 08D6     case 6:
_0x1BE:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1C2
; 0000 08D7             if(PINA.2 == 0 & PINA.3 == 1)    //
	CALL SUBOPT_0x79
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	CALL SUBOPT_0x5E
	BREQ _0x1C3
; 0000 08D8                 {
; 0000 08D9                 //proces[0] = 3;
; 0000 08DA                 proces[0] = 1;
	CALL SUBOPT_0x78
; 0000 08DB                 sek0 = 21;
	CALL SUBOPT_0x81
; 0000 08DC                 }
; 0000 08DD 
; 0000 08DE             if(PINA.2 == 1 & PINA.3 == 0)
_0x1C3:
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7A
	BREQ _0x1C4
; 0000 08DF                 {
; 0000 08E0                 //proces[0] = 3;
; 0000 08E1                 proces[0] = 1;
	CALL SUBOPT_0x78
; 0000 08E2                 sek0 = 21;
	CALL SUBOPT_0x81
; 0000 08E3                 }
; 0000 08E4 
; 0000 08E5             if(PINA.2 == 0 & PINA.3 == 0)
_0x1C4:
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
	BREQ _0x1C5
; 0000 08E6                 {
; 0000 08E7                 proces[0] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x7C
; 0000 08E8                 sek0 = 21;
	CALL SUBOPT_0x81
; 0000 08E9                 }
; 0000 08EA 
; 0000 08EB             if(PINA.2 == 1 & PINA.3 == 1)   //
_0x1C5:
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CALL SUBOPT_0x7
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	CALL SUBOPT_0x5E
	BREQ _0x1C6
; 0000 08EC                 {
; 0000 08ED                 proces[0] = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x7C
; 0000 08EE                 }
; 0000 08EF 
; 0000 08F0 
; 0000 08F1     break;
_0x1C6:
	RJMP _0x1A9
; 0000 08F2 
; 0000 08F3 
; 0000 08F4     case 7:
_0x1C2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1C7
; 0000 08F5             if(sek0 > 20)    //60  tu byla chyba akcja jak dalem na 20, zwiekszam czas na 40, 20 bylo ok chwilowo daje 30    //30 11.23
	CALL SUBOPT_0x80
	BRLT _0x1C8
; 0000 08F6                 {
; 0000 08F7                 PORTC.5 = 1; //silownik 3 w gore
	SBI  0x15,5
; 0000 08F8                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 08F9                 proces[0] = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x7C
; 0000 08FA                 }
; 0000 08FB     break;
_0x1C8:
	RJMP _0x1A9
; 0000 08FC 
; 0000 08FD     case 8:
_0x1C7:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x1CB
; 0000 08FE             if(sek0 > 20)      //60
	CALL SUBOPT_0x80
	BRLT _0x1CC
; 0000 08FF                 {
; 0000 0900                 PORTC.5 = 0; //silownik 3 w dol
	CBI  0x15,5
; 0000 0901                 PORTB.4 = 1; //silownik pozycjonujacy na zjezdzalni wzdloz
	SBI  0x18,4
; 0000 0902                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 0903                 proces[0] = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x7C
; 0000 0904                 }
; 0000 0905     break;
_0x1CC:
	RJMP _0x1A9
; 0000 0906 
; 0000 0907     case 9:
_0x1CB:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x1D1
; 0000 0908             if(sek0 > 50)  //10
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x82
	BRLT _0x1D2
; 0000 0909                {
; 0000 090A                PORTB.4 = 0; //silownik pozycjonujacy na zjezdzalni wzdloz
	CBI  0x18,4
; 0000 090B                proces[0] = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x7C
; 0000 090C                //proces[0] = 1;
; 0000 090D                }
; 0000 090E     break;
_0x1D2:
	RJMP _0x1A9
; 0000 090F 
; 0000 0910     case 10:
_0x1D1:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1A9
; 0000 0911             //if(sek0_7s > czas_monterow)
; 0000 0912             //    {
; 0000 0913                 sek0 = 0;
	CALL SUBOPT_0x7B
; 0000 0914                 proces[0] = 0;
	LDI  R30,LOW(0)
	STS  _proces,R30
	STS  _proces+1,R30
; 0000 0915                 wynik = 1;
	__GETWRN 16,17,1
; 0000 0916                 if(start == 1)  //do sytuacji startowej
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x1D6
; 0000 0917                     start = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 0918             //    }
; 0000 0919 
; 0000 091A     break;
_0x1D6:
; 0000 091B     }
_0x1A9:
; 0000 091C 
; 0000 091D 
; 0000 091E return wynik;
	RJMP _0x20A0001
; 0000 091F }
;
;
;int proces_1()
; 0000 0923 {
_proces_1:
; 0000 0924 int wynik;
; 0000 0925 wynik = 0;
	CALL SUBOPT_0xB
;	wynik -> R16,R17
; 0000 0926 //zwrotka = 0;
; 0000 0927 
; 0000 0928 switch(proces[1])
	__GETW1MN _proces,2
; 0000 0929     {
; 0000 092A     case 0:
	SBIW R30,0
	BRNE _0x1DA
; 0000 092B         sek1_7s = 0;
	LDI  R30,LOW(0)
	STS  _sek1_7s,R30
	STS  _sek1_7s+1,R30
	STS  _sek1_7s+2,R30
	STS  _sek1_7s+3,R30
; 0000 092C         sek1 = 0;
	CALL SUBOPT_0x83
; 0000 092D         proces[1] = 1;
	CALL SUBOPT_0x84
; 0000 092E     break;
	RJMP _0x1D9
; 0000 092F 
; 0000 0930 
; 0000 0931     case 1:
_0x1DA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1DB
; 0000 0932             //if(sek1 > 40)
; 0000 0933             //    {
; 0000 0934             //    PORTC.4 = 1;      //silownik z glowica kleju nad pret nie ma juz na razie kleju
; 0000 0935             //    }
; 0000 0936 
; 0000 0937             if(sek1 > 60)  //150 01.08
	CALL SUBOPT_0x63
	CALL SUBOPT_0x85
	BRLT _0x1DC
; 0000 0938                 {
; 0000 0939                 //lej klej
; 0000 093A                 PORTE.4 = 1;  //lej klej
	SBI  0x3,4
; 0000 093B                 sek1 = 0;
	CALL SUBOPT_0x83
; 0000 093C                 proces[1] = 2;
	CALL SUBOPT_0x86
; 0000 093D                 }
; 0000 093E     break;
_0x1DC:
	RJMP _0x1D9
; 0000 093F 
; 0000 0940     case 2:
_0x1DB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1DF
; 0000 0941             if(sek1 > 30) //100
	CALL SUBOPT_0x63
	CALL SUBOPT_0x87
	BRLT _0x1E0
; 0000 0942                 {
; 0000 0943                 //przestan lac klej
; 0000 0944                 PORTE.4 = 0;  //lej klej
	CBI  0x3,4
; 0000 0945                 sek1 = 0;
	CALL SUBOPT_0x83
; 0000 0946                 proces[1] = 3;
	CALL SUBOPT_0x88
; 0000 0947                 }
; 0000 0948     break;
_0x1E0:
	RJMP _0x1D9
; 0000 0949     case 3:
_0x1DF:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1E3
; 0000 094A             if(sek1 > 50)
	CALL SUBOPT_0x63
	CALL SUBOPT_0x82
	BRLT _0x1E4
; 0000 094B                 {
; 0000 094C                 //PORTC.4 = 0; //cofnij silownik z klejem  //nie ma juz na razie kleju
; 0000 094D                 sek1 = 0;
	CALL SUBOPT_0x83
; 0000 094E                 proces[1] = 4;
	CALL SUBOPT_0x89
; 0000 094F                 }
; 0000 0950 
; 0000 0951     break;
_0x1E4:
	RJMP _0x1D9
; 0000 0952     case 4:
_0x1E3:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1E5
; 0000 0953             if(sek1 > 50)  //czekaj az sie cofnie
	CALL SUBOPT_0x63
	CALL SUBOPT_0x82
	BRLT _0x1E6
; 0000 0954                 proces[1] = 5;
	__POINTW1MN _proces,2
	CALL SUBOPT_0x8A
; 0000 0955 
; 0000 0956     break;
_0x1E6:
	RJMP _0x1D9
; 0000 0957 
; 0000 0958     case 5:
_0x1E5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1D9
; 0000 0959             //if(sek1_7s > czas_monterow)
; 0000 095A             //    {
; 0000 095B                 sek1 = 0;
	CALL SUBOPT_0x83
; 0000 095C                 proces[1] = 0;
	CALL SUBOPT_0x8B
; 0000 095D                 wynik = 1;
; 0000 095E                 if(start == 3)  //do sytuacji startowej
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x1E8
; 0000 095F                     start = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 0960             //    }
; 0000 0961 
; 0000 0962     break;
_0x1E8:
; 0000 0963     }
_0x1D9:
; 0000 0964 
; 0000 0965 
; 0000 0966 
; 0000 0967 
; 0000 0968 return wynik;
	RJMP _0x20A0001
; 0000 0969 }
;
;
;// wersja fast ale koliduje to ze przenosze pret na poczotku
;int proces_2()
; 0000 096E {
_proces_2:
; 0000 096F int wynik;
; 0000 0970 wynik = 0;
	CALL SUBOPT_0xB
;	wynik -> R16,R17
; 0000 0971 
; 0000 0972 switch(proces[2])
	__GETW1MN _proces,4
; 0000 0973     {
; 0000 0974     case 0:
	SBIW R30,0
	BRNE _0x1EC
; 0000 0975         sek2_7s = 0;
	LDI  R30,LOW(0)
	STS  _sek2_7s,R30
	STS  _sek2_7s+1,R30
	STS  _sek2_7s+2,R30
	STS  _sek2_7s+3,R30
; 0000 0976         sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0977         PORTB.3 = 0; //silownik dociskajacy grzybki - na wszelki wypadek w gore gdyby nie byl
	CBI  0x18,3
; 0000 0978         PORTC.2 = 0; //maly silownik grzybka - droga DO grzebieni
	CBI  0x15,2
; 0000 0979         proces[2] = 1;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x84
; 0000 097A     break;
	RJMP _0x1EB
; 0000 097B 
; 0000 097C     case 1:
_0x1EC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F1
; 0000 097D             if(sek2 > 1)
	CALL SUBOPT_0x8D
	__CPD2N 0x2
	BRLT _0x1F2
; 0000 097E                 {
; 0000 097F                 PORTE.2 = 1; //wroc malym silownik grzybka
	SBI  0x3,2
; 0000 0980                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0981                 proces[2] = 2;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x86
; 0000 0982                 }
; 0000 0983     break;
_0x1F2:
	RJMP _0x1EB
; 0000 0984 
; 0000 0985     case 2:
_0x1F1:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F5
; 0000 0986 
; 0000 0987             if(metalowe_grzybki == 1)
	LDS  R26,_metalowe_grzybki
	LDS  R27,_metalowe_grzybki+1
	SBIW R26,1
	BRNE _0x1F6
; 0000 0988                 {
; 0000 0989                 grzybek_biezacy_dokrecony = 1;
	CALL SUBOPT_0x8E
; 0000 098A                 sek2 = 0;
; 0000 098B                 proces[2] = 9;
	CALL SUBOPT_0x8F
; 0000 098C                 }
; 0000 098D 
; 0000 098E             if(sek2 > 10)  //30
_0x1F6:
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x90
	BRLT _0x1F7
; 0000 098F                 {
; 0000 0990                 PORTC.1 = 1; //wroc duzym pobieraniem grzybka
	SBI  0x15,1
; 0000 0991                 PORTB.7 = 1; //docisnij preta
	SBI  0x18,7
; 0000 0992                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0993                 proces[2] = 3;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x88
; 0000 0994                 }
; 0000 0995     break;
_0x1F7:
	RJMP _0x1EB
; 0000 0996 
; 0000 0997 
; 0000 0998     case 3:
_0x1F5:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1FC
; 0000 0999             if(sek2 > 50)  //30   bylo ale stukalo, zwolnie
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x82
	BRLT _0x1FD
; 0000 099A                 {
; 0000 099B                 PORTC.1 = 0; //pobierz grzybek
	CBI  0x15,1
; 0000 099C                 il_grzybkow--;
	LDI  R26,LOW(_il_grzybkow)
	LDI  R27,HIGH(_il_grzybkow)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 099D                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 099E                 proces[2] = 4;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x89
; 0000 099F                 }
; 0000 09A0     break;
_0x1FD:
	RJMP _0x1EB
; 0000 09A1 
; 0000 09A2     case 4:
_0x1FC:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x200
; 0000 09A3             //if(PINA.4 == 0 | )  //upewnij sie ze grzebienie na dole
; 0000 09A4             //    {
; 0000 09A5                 //PORTB.7 = 1; //docisnij preta
; 0000 09A6                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 09A7                 proces[2] = 5;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x8A
; 0000 09A8             //    }
; 0000 09A9     break;
	RJMP _0x1EB
; 0000 09AA 
; 0000 09AB 
; 0000 09AC     case 5:
_0x200:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x201
; 0000 09AD             if(sek2 > 20)  //70
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x91
	BRLT _0x202
; 0000 09AE                 {
; 0000 09AF                 PORTB.3 = 1;   //docisnij grzybek z gory
	SBI  0x18,3
; 0000 09B0                 PORTE.2 = 0;  //maly silownik grzybka na luz
	CBI  0x3,2
; 0000 09B1                 grzybek_biezacy_dokrecony = 0;
	CALL SUBOPT_0x92
; 0000 09B2                 sek2 = 0;
; 0000 09B3                 proces[2] = 6;
	__POINTW1MN _proces,4
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 09B4                 }
; 0000 09B5     break;
_0x202:
	RJMP _0x1EB
; 0000 09B6 
; 0000 09B7     case 6:
_0x201:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x207
; 0000 09B8             if(sek2 > 40)  //30
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x7F
	BRLT _0x208
; 0000 09B9                 {
; 0000 09BA 
; 0000 09BB                 //while(1)
; 0000 09BC                 //    {
; 0000 09BD                 //    }
; 0000 09BE 
; 0000 09BF                 PORTD.1 = 1;  //silnik dokrecajacy grzybki
	SBI  0x12,1
; 0000 09C0                 PORTC.3 = 1; //przysun silnik
	SBI  0x15,3
; 0000 09C1                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 09C2                 proces[2] = 7;
	__POINTW1MN _proces,4
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 09C3                 }
; 0000 09C4 
; 0000 09C5     break;
_0x208:
	RJMP _0x1EB
; 0000 09C6     /*
; 0000 09C7     case 7:
; 0000 09C8 
; 0000 09C9             if(PINF.5 == 0)
; 0000 09CA                 grzybek_biezacy_dokrecony = 1;
; 0000 09CB 
; 0000 09CC             if(sek2 > czas_silnika_dokrecajacego_grzybki)       //maks 200, min 20
; 0000 09CD                 {
; 0000 09CE                 PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
; 0000 09CF                 PORTD.1 = 0;  //silnik dokrecajacy grzybki
; 0000 09D0                 }
; 0000 09D1 
; 0000 09D2              if(sek2 > czas_silnika_dokrecajacego_grzybki+10)
; 0000 09D3                 {
; 0000 09D4                 PORTC.3 = 0; //odsun silnik
; 0000 09D5                 PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
; 0000 09D6                 sek2 = 0;
; 0000 09D7                 proces[2] = 8;
; 0000 09D8                 }
; 0000 09D9 
; 0000 09DA 
; 0000 09DB     break;
; 0000 09DC     */
; 0000 09DD     case 7:
_0x207:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x20D
; 0000 09DE 
; 0000 09DF             if(PINF.5 == 0 & grzybek_biezacy_dokrecony == 0)
	LDI  R26,0
	SBIC 0x0,5
	LDI  R26,1
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x93
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x20E
; 0000 09E0                 {
; 0000 09E1                 grzybek_biezacy_dokrecony = 1;
	CALL SUBOPT_0x8E
; 0000 09E2                 sek2 = 0;
; 0000 09E3                 }
; 0000 09E4 
; 0000 09E5             //if(grzybek_biezacy_dokrecony == 1 & sek2 >= (czas_silnika_dokrecajacego_grzybki - 5))
; 0000 09E6 
; 0000 09E7 
; 0000 09E8             if(grzybek_biezacy_dokrecony == 1 & sek2 >= czas_silnika_dokrecajacego_grzybki)
_0x20E:
	CALL SUBOPT_0x94
	MOV  R0,R30
	LDS  R30,_czas_silnika_dokrecajacego_grzybki
	LDS  R31,_czas_silnika_dokrecajacego_grzybki+1
	CALL SUBOPT_0x8D
	CALL __CWD1
	CALL __GED12
	AND  R30,R0
	BREQ _0x20F
; 0000 09E9                 {
; 0000 09EA                 PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
	CBI  0x18,3
; 0000 09EB                 PORTD.1 = 0;  //silnik dokrecajacy grzybki
	CBI  0x12,1
; 0000 09EC                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 09ED                 proces[2] = 8;
	CALL SUBOPT_0x95
; 0000 09EE                 }
; 0000 09EF 
; 0000 09F0             if(sek2 > czas_silnika_dokrecajacego_grzybki_stala)       //maks 200, min 20
_0x20F:
	LDS  R30,_czas_silnika_dokrecajacego_grzybki_stala
	LDS  R31,_czas_silnika_dokrecajacego_grzybki_stala+1
	CALL SUBOPT_0x8D
	CALL __CWD1
	CALL __CPD12
	BRGE _0x214
; 0000 09F1                 {
; 0000 09F2                 PORTB.3 = 0;   //silownik dociskajacy grzybek z gory
	CBI  0x18,3
; 0000 09F3                 PORTD.1 = 0;  //silnik dokrecajacy grzybki
	CBI  0x12,1
; 0000 09F4                 licznik_niezakreconych_grzybkow++;
	LDI  R26,LOW(_licznik_niezakreconych_grzybkow)
	LDI  R27,HIGH(_licznik_niezakreconych_grzybkow)
	CALL SUBOPT_0x4
; 0000 09F5                 grzybek_biezacy_dokrecony = 0;
	CALL SUBOPT_0x92
; 0000 09F6                 sek2 = 0;
; 0000 09F7                 proces[2] = 8;
	CALL SUBOPT_0x95
; 0000 09F8                 }
; 0000 09F9 
; 0000 09FA 
; 0000 09FB     break;
_0x214:
	RJMP _0x1EB
; 0000 09FC 
; 0000 09FD     case 8:
_0x20D:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x219
; 0000 09FE              if(sek2 > 0 & grzybek_biezacy_dokrecony == 1)   //NOWE 18.09.2018
	CALL SUBOPT_0x96
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x21A
; 0000 09FF                  PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
	SBI  0x15,2
; 0000 0A00              if(sek2 > 0 & grzybek_biezacy_dokrecony == 0)   //NOWE 18.09.2018
_0x21A:
	CALL SUBOPT_0x96
	CALL SUBOPT_0x93
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x21D
; 0000 0A01                  PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
	SBI  0x15,2
; 0000 0A02 
; 0000 0A03              if(sek2 > 5 & grzybek_biezacy_dokrecony == 1)
_0x21D:
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x64
	MOV  R0,R30
	CALL SUBOPT_0x94
	AND  R30,R0
	BREQ _0x220
; 0000 0A04                 {
; 0000 0A05                 //PORTC.3 = 0; //odsun silnik
; 0000 0A06                 PORTB.7 = 0; //przestan dociskac pret////////
	CALL SUBOPT_0x97
; 0000 0A07                 //PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
; 0000 0A08                 if(sek2 > 13)
	BRLT _0x223
; 0000 0A09                     {
; 0000 0A0A                     PORTB.7 = 1;  //docisnij pret
	SBI  0x18,7
; 0000 0A0B                     sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0A0C                     proces[2] = 9;
	CALL SUBOPT_0x8F
; 0000 0A0D                     }
; 0000 0A0E                 }
_0x223:
; 0000 0A0F 
; 0000 0A10              if(sek2 > 5 & grzybek_biezacy_dokrecony == 0)
_0x220:
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x64
	MOV  R0,R30
	CALL SUBOPT_0x93
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x226
; 0000 0A11                 {
; 0000 0A12                 //PORTC.3 = 0; //odsun silnik
; 0000 0A13                 PORTB.7 = 0; //przestan dociskac pret////////
	CALL SUBOPT_0x97
; 0000 0A14                 //PORTC.2 = 1; //maly silownik grzybka - droga DO grzebieni
; 0000 0A15                 if(sek2 > 13)
	BRLT _0x229
; 0000 0A16                     {
; 0000 0A17                     PORTB.7 = 1;    //docisnij pret
	SBI  0x18,7
; 0000 0A18                     sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0A19                     proces[2] = 9;
	CALL SUBOPT_0x8F
; 0000 0A1A                     }
; 0000 0A1B                 }
_0x229:
; 0000 0A1C 
; 0000 0A1D 
; 0000 0A1E 
; 0000 0A1F     break;
_0x226:
	RJMP _0x1EB
; 0000 0A20 
; 0000 0A21 
; 0000 0A22     case 9:
_0x219:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x22C
; 0000 0A23             if(sek2 > 5)
	CALL SUBOPT_0x8D
	__CPD2N 0x6
	BRLT _0x22D
; 0000 0A24                 {
; 0000 0A25                 PORTC.3 = 0; //odsun silnik
	CBI  0x15,3
; 0000 0A26                 if(sek2 > 33)    //zmieniam 5 na 30 zeby trzymalo dluzej az odjedzie silnik
	CALL SUBOPT_0x8D
	__CPD2N 0x22
	BRLT _0x230
; 0000 0A27                     {
; 0000 0A28                     PORTB.7 = 0; //pusc preta
	CBI  0x18,7
; 0000 0A29                     sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0A2A                     proces[2] = 10;
	__POINTW1MN _proces,4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0A2B                     }
; 0000 0A2C                 }
_0x230:
; 0000 0A2D     break;
_0x22D:
	RJMP _0x1EB
; 0000 0A2E 
; 0000 0A2F     case 10:
_0x22C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1EB
; 0000 0A30             //if(sek2_7s > czas_monterow)
; 0000 0A31             //    {
; 0000 0A32                 grzybek_dokrecony = grzybek_biezacy_dokrecony;
	LDS  R30,_grzybek_biezacy_dokrecony
	LDS  R31,_grzybek_biezacy_dokrecony+1
	STS  _grzybek_dokrecony,R30
	STS  _grzybek_dokrecony+1,R31
; 0000 0A33                 sek2 = 0;
	CALL SUBOPT_0x8C
; 0000 0A34                 proces[2] = 0;
	__POINTW1MN _proces,4
	CALL SUBOPT_0x8B
; 0000 0A35                 wynik = 1;
; 0000 0A36                 if(start == 5)  //do sytuacji startowej
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x234
; 0000 0A37                     start = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R12,R30
; 0000 0A38             //    }
; 0000 0A39 
; 0000 0A3A     break;
_0x234:
; 0000 0A3B     }
_0x1EB:
; 0000 0A3C 
; 0000 0A3D 
; 0000 0A3E 
; 0000 0A3F 
; 0000 0A40 return wynik;
	RJMP _0x20A0001
; 0000 0A41 }
;
;int proces_3()
; 0000 0A44 {
_proces_3:
; 0000 0A45 int wynik;
; 0000 0A46 wynik = 0;
	CALL SUBOPT_0xB
;	wynik -> R16,R17
; 0000 0A47 
; 0000 0A48 switch(proces[3])
	__GETW1MN _proces,6
; 0000 0A49     {
; 0000 0A4A     case 0:
	SBIW R30,0
	BRNE _0x238
; 0000 0A4B         sek3_7s = 0;
	LDI  R30,LOW(0)
	STS  _sek3_7s,R30
	STS  _sek3_7s+1,R30
	STS  _sek3_7s+2,R30
	STS  _sek3_7s+3,R30
; 0000 0A4C         sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0A4D         proces[3] = 1;
	__POINTW1MN _proces,6
	CALL SUBOPT_0x84
; 0000 0A4E         licz = 0;
	CALL SUBOPT_0x14
; 0000 0A4F     break;
	RJMP _0x237
; 0000 0A50 
; 0000 0A51     case 1:
_0x238:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x239
; 0000 0A52 
; 0000 0A53             sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0A54             PORTC.4 = 0;     //bramka grzybkow w gore
	CBI  0x15,4
; 0000 0A55             if(dlugosc_preta_gwintowanego < 70)
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRGE _0x23C
; 0000 0A56                   PORTE.3 = 1;
	SBI  0x3,3
; 0000 0A57             proces[3] = 2;
_0x23C:
	__POINTW1MN _proces,6
	CALL SUBOPT_0x86
; 0000 0A58 
; 0000 0A59 
; 0000 0A5A     break;
	RJMP _0x237
; 0000 0A5B 
; 0000 0A5C     case 2:
_0x239:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x23F
; 0000 0A5D 
; 0000 0A5E 
; 0000 0A5F 
; 0000 0A60             if(sek3 > 50)    //80 02.08
	CALL SUBOPT_0x99
	CALL SUBOPT_0x82
	BRLT _0x240
; 0000 0A61                 {
; 0000 0A62                 if(dlugosc_preta_gwintowanego < 70)
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRGE _0x241
; 0000 0A63                   PORTE.3 = 0;
	CBI  0x3,3
; 0000 0A64                 }
_0x241:
; 0000 0A65             if(sek3 > 60)
_0x240:
	CALL SUBOPT_0x99
	CALL SUBOPT_0x85
	BRLT _0x244
; 0000 0A66                 {
; 0000 0A67                 PORTC.0 = 0;
	CBI  0x15,0
; 0000 0A68                 if(dlugosc_preta_gwintowanego != 60)
	CALL SUBOPT_0x1D
	SBIW R26,60
	BREQ _0x247
; 0000 0A69                     PORTB.1 = 1; //si³ownik chwytania lancy
	SBI  0x18,1
; 0000 0A6A                 PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
_0x247:
	SBI  0x18,0
; 0000 0A6B                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0A6C                 proces[3] = 3;
	__POINTW1MN _proces,6
	CALL SUBOPT_0x88
; 0000 0A6D                 }
; 0000 0A6E 
; 0000 0A6F 
; 0000 0A70     break;
_0x244:
	RJMP _0x237
; 0000 0A71 
; 0000 0A72 
; 0000 0A73     case 3:
_0x23F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x24C
; 0000 0A74             if(grzybek_dokrecony == 1 & metalowe_grzybki == 0 & oczekiwanie_na_poprawienie == 0 & grzybek_jest_nakrecony_na_precie == 1)
	LDS  R26,_grzybek_dokrecony
	LDS  R27,_grzybek_dokrecony+1
	CALL SUBOPT_0x58
	MOV  R0,R30
	LDS  R26,_metalowe_grzybki
	LDS  R27,_metalowe_grzybki+1
	CALL SUBOPT_0x57
	AND  R0,R30
	LDS  R26,_oczekiwanie_na_poprawienie
	LDS  R27,_oczekiwanie_na_poprawienie+1
	CALL SUBOPT_0x57
	AND  R0,R30
	LDS  R26,_grzybek_jest_nakrecony_na_precie
	LDS  R27,_grzybek_jest_nakrecony_na_precie+1
	CALL SUBOPT_0x58
	AND  R30,R0
	BRNE _0x2CA
; 0000 0A75                 {
; 0000 0A76                 proces[3] = 4;
; 0000 0A77                 sek3 = 0;
; 0000 0A78                 }
; 0000 0A79             else
; 0000 0A7A                 {
; 0000 0A7B                 wydaj_dzwiek();
	CALL _wydaj_dzwiek
; 0000 0A7C                 komunikat_15_na_panel();
	CALL _komunikat_15_na_panel
; 0000 0A7D                 oczekiwanie_na_poprawienie = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _oczekiwanie_na_poprawienie,R30
	STS  _oczekiwanie_na_poprawienie+1,R31
; 0000 0A7E                 if(PINA.7 == 0)
	SBIC 0x19,7
	RJMP _0x24F
; 0000 0A7F                     {
; 0000 0A80                     if(grzybek_jest_nakrecony_na_precie == 0 & start >= 7)
	LDS  R26,_grzybek_jest_nakrecony_na_precie
	LDS  R27,_grzybek_jest_nakrecony_na_precie+1
	CALL SUBOPT_0x24
	MOVW R26,R12
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __GEW12
	AND  R30,R0
	BREQ _0x250
; 0000 0A81                         licznik_wylatujacych_grzybkow++;
	LDI  R26,LOW(_licznik_wylatujacych_grzybkow)
	LDI  R27,HIGH(_licznik_wylatujacych_grzybkow)
	CALL SUBOPT_0x4
; 0000 0A82                     proces[3] = 4;
_0x250:
_0x2CA:
	__POINTW1MN _proces,6
	CALL SUBOPT_0x89
; 0000 0A83                     sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0A84                     }
; 0000 0A85                 }
_0x24F:
; 0000 0A86     break;
	RJMP _0x237
; 0000 0A87 
; 0000 0A88     case 4:
_0x24C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x251
; 0000 0A89 
; 0000 0A8A 
; 0000 0A8B 
; 0000 0A8C                     if(dlugosc_preta_gwintowanego != 60)
	CALL SUBOPT_0x1D
	SBIW R26,60
	BREQ _0x252
; 0000 0A8D                         {
; 0000 0A8E                         komunikat_czysc_na_panel();
	CALL _komunikat_czysc_na_panel
; 0000 0A8F                         oczekiwanie_na_poprawienie = 0;
	LDI  R30,LOW(0)
	STS  _oczekiwanie_na_poprawienie,R30
	STS  _oczekiwanie_na_poprawienie+1,R30
; 0000 0A90                         PORTB.5 = 1; //si³ownik ma³y chwytania prêcika
	SBI  0x18,5
; 0000 0A91                         }
; 0000 0A92 
; 0000 0A93                     if(dlugosc_preta_gwintowanego == 60 & PINA.7 == 0)
_0x252:
	CALL SUBOPT_0x1D
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __EQW12
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5F
	BREQ _0x255
; 0000 0A94                         {
; 0000 0A95                         skonczony_proces[0] = 0;
	CALL SUBOPT_0x9A
; 0000 0A96                         skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0A97                         skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0A98                         skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0A99                         zerowanie_czasu();
	CALL SUBOPT_0x9E
; 0000 0A9A                         jest_pret_pod_czujnikami = 0;
; 0000 0A9B                         proces[3] = 0;
	__POINTW1MN _proces,6
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0A9C                         start = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 0A9D                         przenies_pret_gwintowany();
	RCALL _przenies_pret_gwintowany
; 0000 0A9E                         }
; 0000 0A9F 
; 0000 0AA0 
; 0000 0AA1                    if(dlugosc_preta_gwintowanego != 60)
_0x255:
	CALL SUBOPT_0x1D
	SBIW R26,60
	BREQ _0x256
; 0000 0AA2                         {
; 0000 0AA3                         sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AA4                         proces[3] = 5; //WYWALAM NA RAZIE PRZEJSCIE DALEJ ABY UPROSCIC
	__POINTW1MN _proces,6
	CALL SUBOPT_0x8A
; 0000 0AA5                         }
; 0000 0AA6     break;
_0x256:
	RJMP _0x237
; 0000 0AA7 
; 0000 0AA8     case 5:
_0x251:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x257
; 0000 0AA9 
; 0000 0AAA             if(sek3 > 25 & PINA.5 == 1 & PORTB.5 == 1) //nie dojechal do konca czyli jest precik  //50 02.08
	CALL SUBOPT_0x99
	__GETD1N 0x19
	CALL __GTD12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x18,5
	LDI  R26,1
	CALL SUBOPT_0x5E
	BREQ _0x258
; 0000 0AAB                 {
; 0000 0AAC                 //PORTB.1 = 1; //si³ownik chwytania lancy
; 0000 0AAD                 //PORTB.0 = 1; //otwarcie szczek w lancy - silownik z boku
; 0000 0AAE                 PORTB.6 = 1; //silownik obrotowy na ktorym jest maly chwytajacy precik
	SBI  0x18,6
; 0000 0AAF                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AB0                 proces[3] = 6;
	__POINTW1MN _proces,6
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0AB1                 }
; 0000 0AB2             if(sek3 > 50 & PINA.5 == 0) // dojechal do konca czyli jest precika nie ma
_0x258:
	CALL SUBOPT_0x99
	__GETD1N 0x32
	CALL __GTD12
	MOV  R0,R30
	CALL SUBOPT_0x5C
	AND  R30,R0
	BREQ _0x25B
; 0000 0AB3                 {
; 0000 0AB4                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AB5                 wydaj_dzwiek();
	CALL _wydaj_dzwiek
; 0000 0AB6                 komunikat_14_na_panel();
	CALL _komunikat_14_na_panel
; 0000 0AB7                 PORTB.5 = 0; //si³ownik ma³y chwytania prêcika
	CBI  0x18,5
; 0000 0AB8                 }
; 0000 0AB9             if(PORTB.5 == 0 & PINA.7 == 0)
_0x25B:
	LDI  R26,0
	SBIC 0x18,5
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5F
	BREQ _0x25E
; 0000 0ABA                  {
; 0000 0ABB                  komunikat_czysc_na_panel();
	CALL _komunikat_czysc_na_panel
; 0000 0ABC                  proces[3] = 4;
	__POINTW1MN _proces,6
	CALL SUBOPT_0x89
; 0000 0ABD                  }
; 0000 0ABE 
; 0000 0ABF 
; 0000 0AC0     break;
_0x25E:
	RJMP _0x237
; 0000 0AC1 
; 0000 0AC2     case 6:
_0x257:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x25F
; 0000 0AC3 
; 0000 0AC4             if(sek3 > 25)  //50 02.08
	CALL SUBOPT_0x99
	__CPD2N 0x1A
	BRLT _0x260
; 0000 0AC5                 {
; 0000 0AC6                 //PORTB.1 = 1; //si³ownik chwytania lancy
; 0000 0AC7                 PORTB.2 = 1; //wkladanie do lancy precika z grzybkiem
	SBI  0x18,2
; 0000 0AC8                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AC9                 proces[3] = 7;
	__POINTW1MN _proces,6
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0ACA                 }
; 0000 0ACB     break;
_0x260:
	RJMP _0x237
; 0000 0ACC 
; 0000 0ACD     case 7:
_0x25F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x263
; 0000 0ACE 
; 0000 0ACF             if(sek3 > 30)  //50 02.08
	CALL SUBOPT_0x99
	CALL SUBOPT_0x87
	BRLT _0x264
; 0000 0AD0                 {
; 0000 0AD1                 if(PINF.0 == 1)
	SBIS 0x0,0
	RJMP _0x265
; 0000 0AD2                     licznik_niewlozonych_pretow_z_grzybkiem++;
	LDI  R26,LOW(_licznik_niewlozonych_pretow_z_grzybkiem)
	LDI  R27,HIGH(_licznik_niewlozonych_pretow_z_grzybkiem)
	CALL SUBOPT_0x4
	SBIW R30,1
; 0000 0AD3                 PORTB.0 = 0; //zacisniecie szczek w lancy - silownik z boku
_0x265:
	CBI  0x18,0
; 0000 0AD4                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AD5                 proces[3] = 8;
	__POINTW1MN _proces,6
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0AD6                 }
; 0000 0AD7     break;
_0x264:
	RJMP _0x237
; 0000 0AD8 
; 0000 0AD9     case 8:
_0x263:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x268
; 0000 0ADA 
; 0000 0ADB             if(sek3 > 30)  //50  02.08
	CALL SUBOPT_0x99
	CALL SUBOPT_0x87
	BRLT _0x269
; 0000 0ADC                 {
; 0000 0ADD                 PORTB.5 = 0; //si³ownik ma³y chwytania prêcika - puszczenie precika
	CBI  0x18,5
; 0000 0ADE                 //PORTB.1 = 0; //si³ownik chwytania lancy - puszczenie
; 0000 0ADF                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AE0                 proces[3] = 9;  ///bylo 9 omijam teraz te dwa ponizej  //jednak finalnie nie omijam
	__POINTW1MN _proces,6
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0AE1                                 //jednal omijam tylko jednego ponizej
; 0000 0AE2                 }
; 0000 0AE3     break;
_0x269:
	RJMP _0x237
; 0000 0AE4 
; 0000 0AE5 
; 0000 0AE6 
; 0000 0AE7     case 9:
_0x268:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x26C
; 0000 0AE8             if(sek3 > 10)
	CALL SUBOPT_0x99
	CALL SUBOPT_0x90
	BRLT _0x26D
; 0000 0AE9                 {
; 0000 0AEA                 PORTB.2 = 0; //wkladanie do lancy precika z grzybkiem - powrot silownikiem
	CBI  0x18,2
; 0000 0AEB                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AEC                 proces[3] = 10;
	__POINTW1MN _proces,6
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0AED                 }
; 0000 0AEE     break;
_0x26D:
	RJMP _0x237
; 0000 0AEF 
; 0000 0AF0     case 10:
_0x26C:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x270
; 0000 0AF1             if(sek3 > 10)
	CALL SUBOPT_0x99
	CALL SUBOPT_0x90
	BRLT _0x271
; 0000 0AF2                 {
; 0000 0AF3                 PORTB.1 = 0; //si³ownik chwytania lancy - puszczenie
	CBI  0x18,1
; 0000 0AF4                 //PORTB.6 = 0; //silownik obrotowy na ktorym jest maly chwytajacy precik - powrot
; 0000 0AF5                 PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje
	SBI  0x15,4
; 0000 0AF6                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0AF7                 proces[3] = 11;
	__POINTW1MN _proces,6
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0AF8                 }
; 0000 0AF9     break;
_0x271:
	RJMP _0x237
; 0000 0AFA 
; 0000 0AFB 
; 0000 0AFC 
; 0000 0AFD 
; 0000 0AFE     case 11:
_0x270:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x237
; 0000 0AFF                          //& PINF.1 == 0
; 0000 0B00             if(sek3 > 20 )
	CALL SUBOPT_0x99
	CALL SUBOPT_0x91
	BRLT _0x277
; 0000 0B01                 {
; 0000 0B02                 sek3 = 0;
	CALL SUBOPT_0x98
; 0000 0B03                 proces[3] = 0;
	__POINTW1MN _proces,6
	CALL SUBOPT_0x8B
; 0000 0B04                 wynik = 1;
; 0000 0B05                 il_pretow_gwintowanych--;
	LDI  R26,LOW(_il_pretow_gwintowanych)
	LDI  R27,HIGH(_il_pretow_gwintowanych)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0B06                 if(start == 7)  //do sytuacji startowej
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x278
; 0000 0B07                     {
; 0000 0B08                     start = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R12,R30
; 0000 0B09                     monter_1_time = 0;
	CALL SUBOPT_0x9F
; 0000 0B0A                     monter_2_time = 0;
; 0000 0B0B                     monter_3_time = 0;
; 0000 0B0C                     }
; 0000 0B0D                 }
_0x278:
; 0000 0B0E 
; 0000 0B0F     break;
_0x277:
; 0000 0B10     }
_0x237:
; 0000 0B11 
; 0000 0B12 
; 0000 0B13 return wynik;
_0x20A0001:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0B14 }
;
;
;void procesy()
; 0000 0B18 {
_procesy:
; 0000 0B19 if(skonczony_proces[0] == 0 & start != 0)
	CALL SUBOPT_0xA0
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA1
	AND  R30,R0
	BREQ _0x279
; 0000 0B1A   skonczony_proces[0] = proces_0();
	RCALL _proces_0
	STS  _skonczony_proces,R30
	STS  _skonczony_proces+1,R31
; 0000 0B1B 
; 0000 0B1C if(skonczony_proces[1] == 0 & start != 0 & start != 1 & jest_pret_pod_czujnikami == 1)
_0x279:
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x27A
; 0000 0B1D   skonczony_proces[1] = proces_1();
	RCALL _proces_1
	__PUTW1MN _skonczony_proces,2
; 0000 0B1E 
; 0000 0B1F if(skonczony_proces[2] == 0 & start != 0 & start != 1 & start != 2 & start != 3 & start != 4 & jest_pret_pod_czujnikami == 1)
_0x27A:
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA7
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x27B
; 0000 0B20     skonczony_proces[2] = proces_2();
	RCALL _proces_2
	__PUTW1MN _skonczony_proces,4
; 0000 0B21 
; 0000 0B22 if(skonczony_proces[3] == 0 & start != 0 & start != 1 & start != 2 & start != 3 & start != 4 & start != 5 & start != 6 & jest_pret_pod_czujnikami == 1)
_0x27B:
	__GETW1MN _skonczony_proces,6
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA7
	MOVW R26,R12
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __NEW12
	AND  R0,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x27C
; 0000 0B23   skonczony_proces[3] = proces_3();
	RCALL _proces_3
	__PUTW1MN _skonczony_proces,6
; 0000 0B24 }
_0x27C:
	RET
;
;void wyzeruj_monterow()
; 0000 0B27 {
_wyzeruj_monterow:
; 0000 0B28 monterzy_skonczyli = 0;
	CLR  R10
	CLR  R11
; 0000 0B29 monter_1_skonczyl = 0;
	CALL SUBOPT_0xA8
; 0000 0B2A monter_2_skonczyl = 0;
; 0000 0B2B monter_3_skonczyl = 0;
; 0000 0B2C monter_1_time = 0;
	CALL SUBOPT_0x9F
; 0000 0B2D monter_2_time = 0;
; 0000 0B2E monter_3_time = 0;
; 0000 0B2F wyswietl_czas_procesu();
	CALL _wyswietl_czas_procesu
; 0000 0B30 zerowanie_czasu();
	CALL _zerowanie_czasu
; 0000 0B31 //if(skonczony_proces[0] == 0)
; 0000 0B32 //    wyswietl_czas_procesu();
; 0000 0B33 }
	RET
;
;
;
;void zerowanie_procesow()
; 0000 0B38 {
_zerowanie_procesow:
; 0000 0B39 int liczenie;
; 0000 0B3A long int czestosc_komunikacji;
; 0000 0B3B czestosc_komunikacji = 0;
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	liczenie -> R16,R17
;	czestosc_komunikacji -> Y+2
	CALL SUBOPT_0xA9
; 0000 0B3C liczenie = 0;
	__GETWRN 16,17,0
; 0000 0B3D 
; 0000 0B3E if(skonczony_proces[0] == 1 & start == 2)
	CALL SUBOPT_0xAA
	MOV  R0,R30
	MOVW R26,R12
	CALL SUBOPT_0x59
	AND  R30,R0
	BREQ _0x27D
; 0000 0B3F         {
; 0000 0B40         z = czekaj_na_guzik_start();
	CALL SUBOPT_0x72
; 0000 0B41         klej = czekaj_na_klej();
	CALL SUBOPT_0xAB
; 0000 0B42         //klej_slave = czekaj_na_klej_slave();
; 0000 0B43         klej_slave = 1;
; 0000 0B44         kontrola_grzybkow = kontrola_grzyb();  // & kontrola_grzybkow == 1
; 0000 0B45         if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	AND  R30,R0
	BREQ _0x27E
; 0000 0B46             {
; 0000 0B47             przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
	CALL SUBOPT_0xAF
; 0000 0B48             wyswietl_czas_procesu();
; 0000 0B49             odpytaj_parametry_z_panelu(0);
; 0000 0B4A             skonczony_proces[0] = 0;
; 0000 0B4B             zerowanie_czasu();
	CALL SUBOPT_0x9E
; 0000 0B4C             jest_pret_pod_czujnikami = 0;
; 0000 0B4D             start = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 0B4E             }
; 0000 0B4F         }
_0x27E:
; 0000 0B50 
; 0000 0B51 if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & start == 4)
_0x27D:
	CALL SUBOPT_0xAA
	MOV  R0,R30
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xB0
	MOVW R26,R12
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x27F
; 0000 0B52         {
; 0000 0B53         z = czekaj_na_guzik_start();
	CALL SUBOPT_0x72
; 0000 0B54         klej = czekaj_na_klej();
	CALL SUBOPT_0xAB
; 0000 0B55         //klej_slave = czekaj_na_klej_slave();
; 0000 0B56         klej_slave = 1;
; 0000 0B57         kontrola_grzybkow = kontrola_grzyb();
; 0000 0B58         if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	AND  R30,R0
	BREQ _0x280
; 0000 0B59             {
; 0000 0B5A             przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
	CALL SUBOPT_0xAF
; 0000 0B5B             wyswietl_czas_procesu();
; 0000 0B5C             odpytaj_parametry_z_panelu(0);
; 0000 0B5D             skonczony_proces[0] = 0;
; 0000 0B5E             skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0B5F             zerowanie_czasu();
	CALL _zerowanie_czasu
; 0000 0B60             start = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 0B61             jest_pret_pod_czujnikami = 0;
	CALL SUBOPT_0xB1
; 0000 0B62             }
; 0000 0B63         }
_0x280:
; 0000 0B64 
; 0000 0B65 if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & start == 6)
_0x27F:
	CALL SUBOPT_0xAA
	MOV  R0,R30
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xB0
	MOVW R26,R12
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x281
; 0000 0B66         {
; 0000 0B67         z = czekaj_na_guzik_start();
	CALL SUBOPT_0x72
; 0000 0B68         klej = czekaj_na_klej();
	CALL SUBOPT_0xAB
; 0000 0B69         //klej_slave = czekaj_na_klej_slave();
; 0000 0B6A         klej_slave = 1;
; 0000 0B6B         kontrola_grzybkow = kontrola_grzyb();
; 0000 0B6C         if(z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	AND  R30,R0
	BREQ _0x282
; 0000 0B6D             {
; 0000 0B6E             //ksp = 0;
; 0000 0B6F             przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
	CALL SUBOPT_0xAF
; 0000 0B70             wyswietl_czas_procesu();
; 0000 0B71             odpytaj_parametry_z_panelu(0);
; 0000 0B72             skonczony_proces[0] = 0;
; 0000 0B73             skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0B74             skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0B75             zerowanie_czasu();
	CALL SUBOPT_0x9E
; 0000 0B76             jest_pret_pod_czujnikami = 0;
; 0000 0B77             start = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 0B78             }
; 0000 0B79         }
_0x282:
; 0000 0B7A 
; 0000 0B7B //to ju¿ jest ten glowny co chodzi w kolko
; 0000 0B7C if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & skonczony_proces[2] == 1 & skonczony_proces[3] == 1 & start >= 8)
_0x281:
	CALL SUBOPT_0xAA
	MOV  R0,R30
	CALL SUBOPT_0xA2
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xA6
	CALL SUBOPT_0xB0
	__GETW1MN _skonczony_proces,6
	CALL SUBOPT_0xB0
	CALL SUBOPT_0x5A
	AND  R30,R0
	BRNE PC+3
	JMP _0x283
; 0000 0B7D         {
; 0000 0B7E         z = czekaj_na_guzik_start();
	CALL SUBOPT_0x72
; 0000 0B7F         klej = czekaj_na_klej();
	RCALL _czekaj_na_klej
	CALL SUBOPT_0x74
; 0000 0B80         //klej_slave = czekaj_na_klej_slave();
; 0000 0B81         klej_slave = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _klej_slave,R30
	STS  _klej_slave+1,R31
; 0000 0B82         kontrola_grzybkow = kontrola_grzyb();
	CALL _kontrola_grzyb
	STS  _kontrola_grzybkow,R30
	STS  _kontrola_grzybkow+1,R31
; 0000 0B83         if(monterzy_skonczyli == 1 & z == 1 & klej == 1 & klej_slave == 1 & kontrola_grzybkow == 1)
	MOVW R26,R10
	CALL SUBOPT_0x58
	MOV  R0,R30
	LDS  R26,_z
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R0,R30
	CALL SUBOPT_0xAC
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
	AND  R30,R0
	BRNE PC+3
	JMP _0x284
; 0000 0B84             {
; 0000 0B85             monter_slave = 0;
	CALL SUBOPT_0x76
; 0000 0B86             czestosc_komunikacji = 0;
	CALL SUBOPT_0xA9
; 0000 0B87             while(monter_slave == 0 & start >=11 & tryb_male_puchary == 0)
_0x285:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0xB3
	AND  R30,R0
	BREQ _0x287
; 0000 0B88                 {
; 0000 0B89                 czestosc_komunikacji++;
	CALL SUBOPT_0xB4
; 0000 0B8A                 if(czestosc_komunikacji == 1)
	BRNE _0x288
; 0000 0B8B                     monter_slave = czekaj_na_odpuszczenie_szczek();
	RCALL _czekaj_na_odpuszczenie_szczek
	CALL SUBOPT_0x77
; 0000 0B8C                 if(czestosc_komunikacji > 100)
_0x288:
	CALL SUBOPT_0xB5
	BRLT _0x289
; 0000 0B8D                     czestosc_komunikacji = 0;
	CALL SUBOPT_0xA9
; 0000 0B8E 
; 0000 0B8F                 if(monter_slave == 0 & liczenie == 0)   //nie nacisnal o czasie szczek
_0x289:
	CALL SUBOPT_0xB2
	MOVW R26,R16
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x28A
; 0000 0B90                       {
; 0000 0B91                       licznik_spoznien_monter_3_nowy++;
	LDI  R26,LOW(_licznik_spoznien_monter_3_nowy)
	LDI  R27,HIGH(_licznik_spoznien_monter_3_nowy)
	CALL SUBOPT_0x4
; 0000 0B92                       liczenie = 1;
	__GETWRN 16,17,1
; 0000 0B93                       }
; 0000 0B94                 }
_0x28A:
	RJMP _0x285
_0x287:
; 0000 0B95 
; 0000 0B96             while(monter_slave == 0 & start >=10 & tryb_male_puchary == 1)
_0x28B:
	CALL SUBOPT_0xB2
	CALL SUBOPT_0x67
	AND  R0,R30
	CALL SUBOPT_0x6A
	AND  R30,R0
	BREQ _0x28D
; 0000 0B97                 {
; 0000 0B98                 czestosc_komunikacji++;
	CALL SUBOPT_0xB4
; 0000 0B99                 if(czestosc_komunikacji == 1)
	BRNE _0x28E
; 0000 0B9A                     monter_slave = czekaj_na_odpuszczenie_szczek();
	RCALL _czekaj_na_odpuszczenie_szczek
	CALL SUBOPT_0x77
; 0000 0B9B                     //tasma lancuchowa powinna ruszyc monter 2 nacisnie pedal i minie okolo 1s
; 0000 0B9C                 if(czestosc_komunikacji > 100)
_0x28E:
	CALL SUBOPT_0xB5
	BRLT _0x28F
; 0000 0B9D                     czestosc_komunikacji = 0;
	CALL SUBOPT_0xA9
; 0000 0B9E                 }
_0x28F:
	RJMP _0x28B
_0x28D:
; 0000 0B9F 
; 0000 0BA0 
; 0000 0BA1 
; 0000 0BA2 
; 0000 0BA3 
; 0000 0BA4                 przenies_pret_gwintowany();  //chodzi w whilu dopoki nie zrobi
	CALL _przenies_pret_gwintowany
; 0000 0BA5                                           //nie dawca zezwolenia na szczeki
; 0000 0BA6 
; 0000 0BA7             odpytaj_parametry_z_panelu(0);       //jak il_pretow == 4
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odpytaj_parametry_z_panelu
; 0000 0BA8             if(anuluj_biezace_zlecenie == 1 & anuluj_biezace_zlecenie_const == 0)
	LDS  R26,_anuluj_biezace_zlecenie
	LDS  R27,_anuluj_biezace_zlecenie+1
	CALL SUBOPT_0x58
	MOV  R0,R30
	LDS  R26,_anuluj_biezace_zlecenie_const
	LDS  R27,_anuluj_biezace_zlecenie_const+1
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x290
; 0000 0BA9                 {
; 0000 0BAA                 anuluj_biezace_zlecenie = 0;
	LDI  R30,LOW(0)
	STS  _anuluj_biezace_zlecenie,R30
	STS  _anuluj_biezace_zlecenie+1,R30
; 0000 0BAB                 anuluj_biezace_zlecenie_const = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _anuluj_biezace_zlecenie_const,R30
	STS  _anuluj_biezace_zlecenie_const+1,R31
; 0000 0BAC                 ustaw_na_nie_anulacje_zlecenia();
	CALL _ustaw_na_nie_anulacje_zlecenia
; 0000 0BAD                 il_pretow_gwintowanych = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2A
; 0000 0BAE                 il_pretow_gwintowanych_stala = il_pretow_gwintowanych;
	CALL SUBOPT_0x2B
; 0000 0BAF                 licznik_pucharow = -2;  //0
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	STS  _licznik_pucharow,R30
	STS  _licznik_pucharow+1,R31
; 0000 0BB0                 }
; 0000 0BB1 
; 0000 0BB2 
; 0000 0BB3             start++;
_0x290:
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0BB4             if(start > 1000)
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x291
; 0000 0BB5                start = 100;  //zeby sie nie zapetlil start
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	MOVW R12,R30
; 0000 0BB6 
; 0000 0BB7             if(il_pretow_gwintowanych > 3 & jest_pret_pod_czujnikami == 1)
_0x291:
	CALL SUBOPT_0x25
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __GTW12
	MOV  R0,R30
	CALL SUBOPT_0xA5
	AND  R30,R0
	BREQ _0x292
; 0000 0BB8                 {
; 0000 0BB9                 jest_pret_pod_czujnikami = 0;
	CALL SUBOPT_0xB1
; 0000 0BBA                 skonczony_proces[0] = 0;
	CALL SUBOPT_0x9A
; 0000 0BBB                 skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0BBC                 skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0BBD                 skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0BBE                 }
; 0000 0BBF 
; 0000 0BC0              if(il_pretow_gwintowanych > 2)
_0x292:
	CALL SUBOPT_0x25
	SBIW R26,3
	BRLT _0x293
; 0000 0BC1                 {
; 0000 0BC2                 jest_pret_pod_czujnikami = 1;//bo procesu 0 juz nie ma
	CALL SUBOPT_0x7D
; 0000 0BC3                 skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0BC4                 skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0BC5                 skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0BC6                 }
; 0000 0BC7 
; 0000 0BC8              if(il_pretow_gwintowanych > 1)
_0x293:
	CALL SUBOPT_0x25
	SBIW R26,2
	BRLT _0x294
; 0000 0BC9                 {
; 0000 0BCA                 jest_pret_pod_czujnikami = 1; //bo procesu 0 juz nie ma
	CALL SUBOPT_0x7D
; 0000 0BCB                 skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0BCC                 skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0BCD                 }
; 0000 0BCE 
; 0000 0BCF              if(il_pretow_gwintowanych > 0)
_0x294:
	CALL SUBOPT_0x25
	CALL __CPW02
	BRGE _0x295
; 0000 0BD0                 {
; 0000 0BD1                 jest_pret_pod_czujnikami = 1; //bo procesu 0 juz nie ma
	CALL SUBOPT_0x7D
; 0000 0BD2                 skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0BD3                 }
; 0000 0BD4 
; 0000 0BD5             wyzeruj_monterow();
_0x295:
	RCALL _wyzeruj_monterow
; 0000 0BD6 
; 0000 0BD7             if((licznik_pucharow - 1) == il_pretow_gwintowanych_stala & potw_zielonym_bo_pomyliles_pedal_z_potwierdz == 0)
	CALL SUBOPT_0xB6
	LDS  R26,_il_pretow_gwintowanych_stala
	LDS  R27,_il_pretow_gwintowanych_stala+1
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_potw_zielonym_bo_pomyliles_pedal_z_potwierdz
	LDS  R27,_potw_zielonym_bo_pomyliles_pedal_z_potwierdz+1
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x296
; 0000 0BD8                     {
; 0000 0BD9                     komunikat_6_na_panel();
	CALL _komunikat_6_na_panel
; 0000 0BDA                     msek_clock = 0;
	CALL SUBOPT_0x0
; 0000 0BDB                     sek_clock = 0;
	CALL SUBOPT_0x1
; 0000 0BDC                     min_clock = 0;
	CALL SUBOPT_0x2
; 0000 0BDD                     godz_clock = 0;
	LDI  R30,LOW(0)
	STS  _godz_clock,R30
	STS  _godz_clock+1,R30
; 0000 0BDE                     PORTD.4 = 0;  //wylacz orientator bo wyl
	CBI  0x12,4
; 0000 0BDF                     PORTD.2 = 0;  //koniec zezwolenia na szczeki
	CBI  0x12,2
; 0000 0BE0                     ustaw_na_nie_anulacje_zlecenia();
	CALL _ustaw_na_nie_anulacje_zlecenia
; 0000 0BE1                     wylacz_maszyne();
	CALL _wylacz_maszyne
; 0000 0BE2                     z = 0;
	LDI  R30,LOW(0)
	STS  _z,R30
; 0000 0BE3                     start = 0;
	CLR  R12
	CLR  R13
; 0000 0BE4                     }
; 0000 0BE5             }
_0x296:
; 0000 0BE6 
; 0000 0BE7         }
_0x284:
; 0000 0BE8 }
_0x283:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;
;void kontrola_monterow()
; 0000 0BEC {
_kontrola_monterow:
; 0000 0BED //brak monterow
; 0000 0BEE 
; 0000 0BEF if(start == 8 & monterzy_skonczyli == 0)
	MOVW R26,R12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x29B
; 0000 0BF0       monterzy_skonczyli = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0BF1 
; 0000 0BF2 //praca ciagla monterow
; 0000 0BF3 
; 0000 0BF4 if(start >= 9 & monterzy_skonczyli == 0)
_0x29B:
	CALL SUBOPT_0x69
	MOVW R26,R10
	CALL SUBOPT_0x57
	AND  R30,R0
	BRNE PC+3
	JMP _0x29C
; 0000 0BF5     {
; 0000 0BF6     if(monter_1_skonczyl == 0)  //zmianiam & na | i powinno nie byc potrzebne naciskanie guzika monter 1
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x29D
; 0000 0BF7         {
; 0000 0BF8         if(monter_1_time > czas_monterow & start >= 10)
	CALL SUBOPT_0x26
	LDS  R26,_monter_1_time
	LDS  R27,_monter_1_time+1
	LDS  R24,_monter_1_time+2
	LDS  R25,_monter_1_time+3
	CALL SUBOPT_0xB7
	AND  R30,R0
	BREQ _0x29E
; 0000 0BF9            licznik_spoznien_monter_1++;
	LDI  R26,LOW(_licznik_spoznien_monter_1)
	LDI  R27,HIGH(_licznik_spoznien_monter_1)
	CALL SUBOPT_0x4
; 0000 0BFA         monter_1_skonczyl = 1;
_0x29E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0BFB         }
; 0000 0BFC 
; 0000 0BFD     if(monter_2_skonczyl == 0)    //zmianiam & na | i powinno nie byc potrzebne naciskanie guzika monter 2
_0x29D:
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x29F
; 0000 0BFE         {
; 0000 0BFF         if(monter_2_time > czas_monterow & start >= 10)
	CALL SUBOPT_0x26
	LDS  R26,_monter_2_time
	LDS  R27,_monter_2_time+1
	LDS  R24,_monter_2_time+2
	LDS  R25,_monter_2_time+3
	CALL SUBOPT_0xB7
	AND  R30,R0
	BREQ _0x2A0
; 0000 0C00            licznik_spoznien_monter_2++;
	LDI  R26,LOW(_licznik_spoznien_monter_2)
	LDI  R27,HIGH(_licznik_spoznien_monter_2)
	CALL SUBOPT_0x4
; 0000 0C01         monter_2_skonczyl = 1;
_0x2A0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 0C02         }
; 0000 0C03 
; 0000 0C04 
; 0000 0C05 
; 0000 0C06     if(PINF.4 == 0 & monter_3_skonczyl == 0 & start < 11 & tryb_male_puchary == 0)
_0x29F:
	CALL SUBOPT_0xB8
	MOVW R26,R8
	CALL SUBOPT_0x57
	AND  R0,R30
	MOVW R26,R12
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __LTW12
	AND  R0,R30
	CALL SUBOPT_0x68
	CALL SUBOPT_0x57
	AND  R30,R0
	BREQ _0x2A1
; 0000 0C07         {
; 0000 0C08         if(monter_3_time > czas_monterow & start >= 10)
	CALL SUBOPT_0xB9
	AND  R30,R0
	BREQ _0x2A2
; 0000 0C09            licznik_spoznien_monter_3++;
	CALL SUBOPT_0xBA
; 0000 0C0A         if(start >=10)   //12 23.03.2016
_0x2A2:
	CALL SUBOPT_0xBB
	BRLT _0x2A3
; 0000 0C0B             {
; 0000 0C0C             licznik_pucharow++;
	CALL SUBOPT_0xBC
; 0000 0C0D             licznik_pucharow_global++;
	CALL SUBOPT_0xBD
; 0000 0C0E             wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBE
; 0000 0C0F             wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
; 0000 0C10             }
; 0000 0C11         monter_3_skonczyl = 1;
_0x2A3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0C12         }
; 0000 0C13 
; 0000 0C14 
; 0000 0C15 
; 0000 0C16      if(PINF.4 == 0 & monter_3_skonczyl == 0 & start == 9 & tryb_male_puchary == 1)
_0x2A1:
	CALL SUBOPT_0xB8
	MOVW R26,R8
	CALL SUBOPT_0x57
	AND  R0,R30
	MOVW R26,R12
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x6A
	AND  R30,R0
	BREQ _0x2A4
; 0000 0C17         {
; 0000 0C18         monter_3_skonczyl = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0C19         }
; 0000 0C1A 
; 0000 0C1B 
; 0000 0C1C      if((PINF.4 == 0 | monter_3_skonczyl == 0) & start >= 10 & tryb_male_puchary == 1)
_0x2A4:
	CALL SUBOPT_0xB8
	MOVW R26,R8
	CALL SUBOPT_0x57
	OR   R0,R30
	CALL SUBOPT_0x67
	AND  R0,R30
	CALL SUBOPT_0x6A
	AND  R30,R0
	BREQ _0x2A5
; 0000 0C1D         {
; 0000 0C1E         if(monter_3_time > czas_monterow & start >= 10)
	CALL SUBOPT_0xB9
	AND  R30,R0
	BREQ _0x2A6
; 0000 0C1F            licznik_spoznien_monter_3++;
	CALL SUBOPT_0xBA
; 0000 0C20         if(start >=10)   //12 23.03.2016
_0x2A6:
	CALL SUBOPT_0xBB
	BRLT _0x2A7
; 0000 0C21             {
; 0000 0C22             licznik_pucharow++;
	CALL SUBOPT_0xBC
; 0000 0C23             licznik_pucharow_global++;
	CALL SUBOPT_0xBD
; 0000 0C24             wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBE
; 0000 0C25             wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
; 0000 0C26             }
; 0000 0C27         monter_3_skonczyl = 1;
_0x2A7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0C28         }
; 0000 0C29 
; 0000 0C2A 
; 0000 0C2B 
; 0000 0C2C 
; 0000 0C2D 
; 0000 0C2E 
; 0000 0C2F 
; 0000 0C30 
; 0000 0C31      if((PINF.4 == 0 | monter_3_skonczyl == 0) & start >= 11 & tryb_male_puchary == 0)      //nowe cale if 31.07
_0x2A5:
	CALL SUBOPT_0xB8
	MOVW R26,R8
	CALL SUBOPT_0x57
	OR   R0,R30
	CALL SUBOPT_0xB3
	AND  R30,R0
	BREQ _0x2A8
; 0000 0C32         {
; 0000 0C33         if(monter_3_time > czas_monterow & start >= 10)
	CALL SUBOPT_0xB9
	AND  R30,R0
	BREQ _0x2A9
; 0000 0C34            licznik_spoznien_monter_3++;
	CALL SUBOPT_0xBA
; 0000 0C35         if(start >=10)   //12 23.03.2016
_0x2A9:
	CALL SUBOPT_0xBB
	BRLT _0x2AA
; 0000 0C36             {
; 0000 0C37             licznik_pucharow++;
	CALL SUBOPT_0xBC
; 0000 0C38             licznik_pucharow_global++;
	CALL SUBOPT_0xBD
; 0000 0C39             wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow-1,licznik_pucharow_global-1);
	CALL SUBOPT_0xB6
	CALL SUBOPT_0xBE
; 0000 0C3A             wyswietl_parametry(licznik_wylatujacych_grzybkow,licznik_niezakreconych_grzybkow,licznik_wyzwolen_kurtyny,licznik_niewlozonych_pretow_z_grzybkiem,licznik_spoznien_monter_1_2,licznik_spoznien_monter_3_nowy);
; 0000 0C3B             }
; 0000 0C3C         monter_3_skonczyl = 1;
_0x2AA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 0C3D         }
; 0000 0C3E 
; 0000 0C3F 
; 0000 0C40     if(monter_1_skonczyl == 1 & monter_2_skonczyl == 1 & monter_3_skonczyl == 1)
_0x2A8:
	MOVW R26,R4
	CALL SUBOPT_0x58
	MOV  R0,R30
	MOVW R26,R6
	CALL SUBOPT_0x58
	AND  R0,R30
	MOVW R26,R8
	CALL SUBOPT_0x58
	AND  R30,R0
	BREQ _0x2AB
; 0000 0C41        {
; 0000 0C42        monterzy_skonczyli = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0C43        }
; 0000 0C44     }
_0x2AB:
; 0000 0C45 
; 0000 0C46 }
_0x29C:
	RET
;
;
;void wznowienie_pracy_po_wykonaniu_zadania()
; 0000 0C4A {
_wznowienie_pracy_po_wykonaniu_zadania:
; 0000 0C4B if(start == 0)
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x2AC
; 0000 0C4C          {
; 0000 0C4D          if(z == 0)
	LDS  R30,_z
	CPI  R30,0
	BRNE _0x2AD
; 0000 0C4E             {
; 0000 0C4F             z = czekaj_na_guzik_start();
	CALL SUBOPT_0x72
; 0000 0C50             wyswietl_czas_przezbrojenia();
	CALL _wyswietl_czas_przezbrojenia
; 0000 0C51             }
; 0000 0C52          else
	RJMP _0x2AE
_0x2AD:
; 0000 0C53             {
; 0000 0C54             odpytaj_parametry_z_panelu(1);
	CALL SUBOPT_0x6E
; 0000 0C55             //if(tryb_male_puchary == 1)
; 0000 0C56             komunikacja_startowa_male_puchary(wynik_wyboru_male_puchary);
	CALL SUBOPT_0x73
; 0000 0C57 
; 0000 0C58             licznik_pucharow = 0;
	CALL SUBOPT_0xBF
; 0000 0C59             licznik_spoznien_monter_1 = -1;
	CALL SUBOPT_0xC0
; 0000 0C5A             licznik_spoznien_monter_2 = -1;
; 0000 0C5B             licznik_spoznien_monter_3 = -1;
; 0000 0C5C             skonczony_proces[0] = 0;
	CALL SUBOPT_0x9A
; 0000 0C5D             skonczony_proces[1] = 0;
	CALL SUBOPT_0x9B
; 0000 0C5E             skonczony_proces[2] = 0;
	CALL SUBOPT_0x9C
; 0000 0C5F             skonczony_proces[3] = 0;
	CALL SUBOPT_0x9D
; 0000 0C60             licznik_pucharow = 0;
	CALL SUBOPT_0xBF
; 0000 0C61             komunikat_czysc_na_panel();
	CALL _komunikat_czysc_na_panel
; 0000 0C62             PORTD.4 = 0; //wylacz orientatorchy gdyby chodzil
	CBI  0x12,4
; 0000 0C63             anuluj_biezace_zlecenie_const = 0;
	LDI  R30,LOW(0)
	STS  _anuluj_biezace_zlecenie_const,R30
	STS  _anuluj_biezace_zlecenie_const+1,R30
; 0000 0C64             wyswietl_ilosc_zmontowanych_pucharow(licznik_pucharow,licznik_pucharow_global);
	LDS  R30,_licznik_pucharow
	LDS  R31,_licznik_pucharow+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_pucharow_global
	LDS  R31,_licznik_pucharow_global+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _wyswietl_ilosc_zmontowanych_pucharow
; 0000 0C65             wyswietl_czas_laczny_przezbrajan();
	CALL _wyswietl_czas_laczny_przezbrajan
; 0000 0C66             PORTC.4 = 1;  //bramka grzybkow z precikiem znowu sie blokuje
	SBI  0x15,4
; 0000 0C67             start = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0C68 
; 0000 0C69             }
_0x2AE:
; 0000 0C6A          }
; 0000 0C6B }
_0x2AC:
	RET
;
;
;void main(void)
; 0000 0C6F {
_main:
; 0000 0C70 // Declare your local variables here
; 0000 0C71 
; 0000 0C72 // Input/Output Ports initialization
; 0000 0C73 // Port A initialization
; 0000 0C74 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0C75 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0C76 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0C77 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0C78 
; 0000 0C79 // Port B initialization
; 0000 0C7A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0C7B // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0C7C PORTB=0x00;
	OUT  0x18,R30
; 0000 0C7D DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0C7E 
; 0000 0C7F // Port C initialization
; 0000 0C80 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0C81 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0C82 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0C83 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0C84 
; 0000 0C85 // Port D initialization
; 0000 0C86 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0C87 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0C88 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0C89 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0C8A 
; 0000 0C8B // Port E initialization
; 0000 0C8C // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0C8D // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0C8E PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0C8F DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 0C90 
; 0000 0C91 // Port F initialization
; 0000 0C92 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0C93 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0C94 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0C95 DDRF=0x00;
	STS  97,R30
; 0000 0C96 
; 0000 0C97 // Port G initialization
; 0000 0C98 // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0C99 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0C9A PORTG=0x00;
	STS  101,R30
; 0000 0C9B DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0C9C 
; 0000 0C9D // Timer/Counter 0 initialization
; 0000 0C9E // Clock source: System Clock
; 0000 0C9F // Clock value: 15,625 kHz
; 0000 0CA0 // Mode: Normal top=0xFF
; 0000 0CA1 // OC0 output: Disconnected
; 0000 0CA2 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0CA3 TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 0CA4 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0CA5 OCR0=0x00;
	OUT  0x31,R30
; 0000 0CA6 
; 0000 0CA7 // Timer/Counter 1 initialization
; 0000 0CA8 // Clock source: System Clock
; 0000 0CA9 // Clock value: Timer1 Stopped
; 0000 0CAA // Mode: Normal top=0xFFFF
; 0000 0CAB // OC1A output: Discon.
; 0000 0CAC // OC1B output: Discon.
; 0000 0CAD // OC1C output: Discon.
; 0000 0CAE // Noise Canceler: Off
; 0000 0CAF // Input Capture on Falling Edge
; 0000 0CB0 // Timer1 Overflow Interrupt: Off
; 0000 0CB1 // Input Capture Interrupt: Off
; 0000 0CB2 // Compare A Match Interrupt: Off
; 0000 0CB3 // Compare B Match Interrupt: Off
; 0000 0CB4 // Compare C Match Interrupt: Off
; 0000 0CB5 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0CB6 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0CB7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0CB8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0CB9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0CBA ICR1L=0x00;
	OUT  0x26,R30
; 0000 0CBB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0CBC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0CBD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0CBE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0CBF OCR1CH=0x00;
	STS  121,R30
; 0000 0CC0 OCR1CL=0x00;
	STS  120,R30
; 0000 0CC1 
; 0000 0CC2 // Timer/Counter 2 initialization
; 0000 0CC3 // Clock source: System Clock
; 0000 0CC4 // Clock value: Timer2 Stopped
; 0000 0CC5 // Mode: Normal top=0xFF
; 0000 0CC6 // OC2 output: Disconnected
; 0000 0CC7 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0CC8 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0CC9 OCR2=0x00;
	OUT  0x23,R30
; 0000 0CCA 
; 0000 0CCB // Timer/Counter 3 initialization
; 0000 0CCC // Clock source: System Clock
; 0000 0CCD // Clock value: Timer3 Stopped
; 0000 0CCE // Mode: Normal top=0xFFFF
; 0000 0CCF // OC3A output: Discon.
; 0000 0CD0 // OC3B output: Discon.
; 0000 0CD1 // OC3C output: Discon.
; 0000 0CD2 // Noise Canceler: Off
; 0000 0CD3 // Input Capture on Falling Edge
; 0000 0CD4 // Timer3 Overflow Interrupt: Off
; 0000 0CD5 // Input Capture Interrupt: Off
; 0000 0CD6 // Compare A Match Interrupt: Off
; 0000 0CD7 // Compare B Match Interrupt: Off
; 0000 0CD8 // Compare C Match Interrupt: Off
; 0000 0CD9 TCCR3A=0x00;
	STS  139,R30
; 0000 0CDA TCCR3B=0x00;
	STS  138,R30
; 0000 0CDB TCNT3H=0x00;
	STS  137,R30
; 0000 0CDC TCNT3L=0x00;
	STS  136,R30
; 0000 0CDD ICR3H=0x00;
	STS  129,R30
; 0000 0CDE ICR3L=0x00;
	STS  128,R30
; 0000 0CDF OCR3AH=0x00;
	STS  135,R30
; 0000 0CE0 OCR3AL=0x00;
	STS  134,R30
; 0000 0CE1 OCR3BH=0x00;
	STS  133,R30
; 0000 0CE2 OCR3BL=0x00;
	STS  132,R30
; 0000 0CE3 OCR3CH=0x00;
	STS  131,R30
; 0000 0CE4 OCR3CL=0x00;
	STS  130,R30
; 0000 0CE5 
; 0000 0CE6 // External Interrupt(s) initialization
; 0000 0CE7 // INT0: Off
; 0000 0CE8 // INT1: Off
; 0000 0CE9 // INT2: Off
; 0000 0CEA // INT3: Off
; 0000 0CEB // INT4: Off
; 0000 0CEC // INT5: Off
; 0000 0CED // INT6: Off
; 0000 0CEE // INT7: Off
; 0000 0CEF EICRA=0x00;
	STS  106,R30
; 0000 0CF0 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0CF1 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0CF2 
; 0000 0CF3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0CF4 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 0CF5 
; 0000 0CF6 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0CF7 
; 0000 0CF8 
; 0000 0CF9 
; 0000 0CFA // USART0 initialization
; 0000 0CFB // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0CFC // USART0 Receiver: On
; 0000 0CFD // USART0 Transmitter: On
; 0000 0CFE // USART0 Mode: Asynchronous
; 0000 0CFF // USART0 Baud Rate: 9600
; 0000 0D00 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0D01 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0D02 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0D03 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0D04 UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 0D05 
; 0000 0D06 /*
; 0000 0D07 // USART1 initialization
; 0000 0D08 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0D09 // USART1 Receiver: On
; 0000 0D0A // USART1 Transmitter: On
; 0000 0D0B // USART1 Mode: Asynchronous
; 0000 0D0C // USART1 Baud Rate: 2400
; 0000 0D0D UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
; 0000 0D0E UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
; 0000 0D0F UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
; 0000 0D10 UBRR1H=0x01;
; 0000 0D11 UBRR1L=0xA0;
; 0000 0D12 
; 0000 0D13 */
; 0000 0D14 
; 0000 0D15 // USART1 initialization
; 0000 0D16 // USART1 disabled
; 0000 0D17 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0D18 
; 0000 0D19 
; 0000 0D1A /*
; 0000 0D1B 
; 0000 0D1C // USART1 initialization
; 0000 0D1D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0D1E // USART1 Receiver: On
; 0000 0D1F // USART1 Transmitter: On
; 0000 0D20 // USART1 Mode: Asynchronous
; 0000 0D21 // USART1 Baud Rate: 9600
; 0000 0D22 UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
; 0000 0D23 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
; 0000 0D24 UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
; 0000 0D25 UBRR1H=0x00;
; 0000 0D26 UBRR1L=0x67;
; 0000 0D27 
; 0000 0D28 */
; 0000 0D29 
; 0000 0D2A /*
; 0000 0D2B 
; 0000 0D2C // USART0 initialization
; 0000 0D2D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0D2E // USART0 Receiver: On
; 0000 0D2F // USART0 Transmitter: On
; 0000 0D30 // USART0 Mode: Asynchronous
; 0000 0D31 // USART0 Baud Rate: 115200
; 0000 0D32 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 0D33 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 0D34 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 0D35 UBRR0H=0x00;
; 0000 0D36 UBRR0L=0x08;
; 0000 0D37 
; 0000 0D38 // USART1 initialization
; 0000 0D39 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0D3A // USART1 Receiver: On
; 0000 0D3B // USART1 Transmitter: On
; 0000 0D3C // USART1 Mode: Asynchronous
; 0000 0D3D // USART1 Baud Rate: 115200
; 0000 0D3E UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
; 0000 0D3F UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
; 0000 0D40 UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
; 0000 0D41 UBRR1H=0x00;
; 0000 0D42 UBRR1L=0x08;
; 0000 0D43 
; 0000 0D44 */
; 0000 0D45 
; 0000 0D46 // Analog Comparator initialization
; 0000 0D47 // Analog Comparator: Off
; 0000 0D48 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0D49 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0D4A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0D4B 
; 0000 0D4C // ADC initialization
; 0000 0D4D // ADC disabled
; 0000 0D4E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0D4F 
; 0000 0D50 // SPI initialization
; 0000 0D51 // SPI disabled
; 0000 0D52 SPCR=0x00;
	OUT  0xD,R30
; 0000 0D53 
; 0000 0D54 // TWI initialization
; 0000 0D55 // TWI disabled
; 0000 0D56 TWCR=0x00;
	STS  116,R30
; 0000 0D57 
; 0000 0D58 // Global enable interrupts
; 0000 0D59 #asm("sei")
	sei
; 0000 0D5A 
; 0000 0D5B //WE
; 0000 0D5C //PINA.0    czujnik ciœnienia
; 0000 0D5D //PINA.1    czujnik widzenia grzybka
; 0000 0D5E //PINA.2    czujnik 1 widzenia prêta gwintowanego na rynnie
; 0000 0D5F //PINA.3    czujnik 2 widzenia prêta gwintowanego na rynnie
; 0000 0D60 //PINA.4    czujnik od silnika grzebieni
; 0000 0D61 //PINA.5    sygnal braku kleju - informacja z dozownika kleju - nie wykorzystuje, zmieniam na czujnik chwycenia preta
; 0000 0D62 //PINA.6    sygnal gotowosci do pracy dozownika kleju - zmieniam na czujnik czy sa prety gorne
; 0000 0D63 //PINA.7    guzik czy monter dokrecil grzybka, je¿eli by³a taka potrzeba
; 0000 0D64 
; 0000 0D65 //PINF.0    wlacznik tasmociagu monterow 1 dawnij, teraz: czujnik czy w³o¿y³ grzybek do lufy
; 0000 0D66 //PINF.1    teraz czy si³ownik chwytaj¹cy wie¿e jest zamkniety  //znowu idzie out//teraz sygnal odpowiedzi od Slave
; 0000 0D67 //PINF.2    monter 1 wykonal dawniej //tu teraz podpinamy czujnik czy jest grzybek
; 0000 0D68 //PINF.3    monter 2 wykonal dawnij //teraz sygnal ze kurtyna jest aktywna
; 0000 0D69 //PINF.4    monter 3 wykonal (dawniej czujnik indukcyjny widzacy wieze - ju¿ go nie ma)
; 0000 0D6A //PINF.5    czujnik czy dokrecil grzybka
; 0000 0D6B //PINF.6    czujnik ze jedzie lancuchowy
; 0000 0D6C //PINF.7    sygnal ze kurtyna zadzialala - jak ktos wlozyl lape to bedzie 0
; 0000 0D6D             //jak monterzy zresetuja to sama mi sie pojawi 1
; 0000 0D6E 
; 0000 0D6F //WY
; 0000 0D70 //PORTB.0   zaciskanie grzybka w lancy
; 0000 0D71 //PORTB.1   si³ownik chwytania lancy
; 0000 0D72 //PORTB.2   wkladanie do lancy precika z grzybkiem
; 0000 0D73 //PORTB.3   silownik przytrzymujacy grzybka od gory
; 0000 0D74 //PORTB.4   silownik pozycjonujacy preta jeszcze na zjezdzalni
; 0000 0D75 //PORTB.5   si³ownik ma³y chwytania prêcika
; 0000 0D76 //PORTB.6   silownik obrotowy na ktorym jest maly chwytajacy precik
; 0000 0D77 //PORTB.7   silownik dociskajacy pret na grzebieniach
; 0000 0D78 
; 0000 0D79 //PORTC.0   cisnienie na linijke - ciœnienie do dozownika kleju - dalem na stale ------------------TU EWENTUALNIE PSIKANIE NA GRZYBEK - chyba wolne
; 0000 0D7A //PORTC.1   silownik pobierania grzybow duzy
; 0000 0D7B //PORTC.2   silownik pobierania grzybow maly - droga DO grzebienie pod ciœnieniem
; 0000 0D7C //PORTC.3   silownik na ktorym jest silnik dokrecajacy grzybki
; 0000 0D7D //PORTC.4   dawniej silownik trzymajcy strzelanie klejem - zmieniam na silownik bramki precikow z grzybkiem
; 0000 0D7E //PORTC.5   si³ownik 3 kolejkuj¹cy na rynnie
; 0000 0D7F //PORTC.6   si³ownik 2 kolejkuj¹cy na rynnie
; 0000 0D80 //PORTC.7   si³ownik 1 kolejkuj¹cy na rynnie
; 0000 0D81 
; 0000 0D82 //PORTD.0   silnik przenosnika pretow
; 0000 0D83 //PORTD.1   silnik dokrecajacy grzybki
; 0000 0D84 //PORTD.2   DAWNIEJ kana³ 1 RS232, TERAZ   zgoda na zacisniecie szczek w wersji komunikacja uproszczona
; 0000 0D85 //PORTD.3   DAWNIEJ kana³ 1 RS232, TERAZ sygnal do przesylania informacji malych pucharach
; 0000 0D86 //PORTD.4   orientator grzybkow
; 0000 0D87 //PORTD.5   dozownik kleju zasilanie 220V
; 0000 0D88 //PORTD.6   SPALONY DAWNIEJ, TERAZ DAJE TU SYGNAL JAKO PRZECINEK MIEDZY PACZKAMI DANYCH - informacja o malych puchyarach
; 0000 0D89 //PORTD.7   LAMPA BRAK PRETOW
; 0000 0D8A 
; 0000 0D8B //PORTE.0   kana³ 0 RS232
; 0000 0D8C //PORTE.1   kana³ 0 RS232
; 0000 0D8D //PORTE.2   silownik pobierania grzybow maly - droga OD grzebienie pod ciœnieniem
; 0000 0D8E //PORTE.3   podpiêty do listwy zaworowej ale nie podpiêty ciœnieniowo------TU EWENTUALNIE PSIKANIE NA GRZYBEK
; 0000 0D8F //PORTE.4   wlaczenie lania kleju
; 0000 0D90 //PORTE.5   sekwencja startowa pivexin
; 0000 0D91 //PORTE.6   manipulator wykonal pivexin
; 0000 0D92 //PORTE.7   sygnal synchronizacji dla procesora slave
; 0000 0D93 
; 0000 0D94 //PROCESY
; 0000 0D95 //proces_0 - kolejkowanie prêta na zje¿d¿alni
; 0000 0D96 //proces_1 - nak³adanie kleju
; 0000 0D97 //proces_2 - nakrecanie grzybka
; 0000 0D98 //proces_3 - pobieranie grzybka i wsadzanie do lancy
; 0000 0D99 
; 0000 0D9A 
; 0000 0D9B 
; 0000 0D9C //delay_ms(8000); //bo panel sie inicjalizuje
; 0000 0D9D //delay_ms(2000); //bo panel sie inicjalizuje
; 0000 0D9E delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x71
; 0000 0D9F delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0x71
; 0000 0DA0 
; 0000 0DA1 
; 0000 0DA2 putchar(90);  //5A
	CALL SUBOPT_0xD
; 0000 0DA3 putchar(165); //A5
; 0000 0DA4 putchar(3);//03  //znak dzwiekowy ze jestem
	CALL SUBOPT_0x15
; 0000 0DA5 putchar(128);  //80
; 0000 0DA6 putchar(2);    //02
; 0000 0DA7 putchar(16);   //10
	ST   -Y,R30
	RCALL _putchar
; 0000 0DA8 
; 0000 0DA9 //PORTD.1 = 1;
; 0000 0DAA //while(1)
; 0000 0DAB //{
; 0000 0DAC //}
; 0000 0DAD 
; 0000 0DAE 
; 0000 0DAF komunikacja_startowa_male_puchary(3);//brak malych pucharow
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _komunikacja_startowa_male_puchary
; 0000 0DB0 //przeslanie danych do slave
; 0000 0DB1 //wnioski do komunikacji - wcale nie trzeba czekac czy monter 3 nie nacisnal szczek
; 0000 0DB2 //sygnalem aby tasmociag ruszyl ponownie jest nacisniecie pedala tego nowego przez montera
; 0000 0DB3 
; 0000 0DB4 
; 0000 0DB5 //zmienne startowe
; 0000 0DB6 start = 0;
	CLR  R12
	CLR  R13
; 0000 0DB7 czas_monterow = 0;
	LDI  R30,LOW(0)
	STS  _czas_monterow,R30
	STS  _czas_monterow+1,R30
	STS  _czas_monterow+2,R30
	STS  _czas_monterow+3,R30
; 0000 0DB8 monter_1_skonczyl = 0;
	CALL SUBOPT_0xA8
; 0000 0DB9 monter_2_skonczyl = 0;
; 0000 0DBA monter_3_skonczyl = 0;
; 0000 0DBB monterzy_skonczyli = 0;
	CLR  R10
	CLR  R11
; 0000 0DBC czas_na_transport_preta = 100;
	__GETD1N 0x64
	STS  _czas_na_transport_preta,R30
	STS  _czas_na_transport_preta+1,R31
	STS  _czas_na_transport_preta+2,R22
	STS  _czas_na_transport_preta+3,R23
; 0000 0DBD jest_pret_pod_czujnikami = 0;
	CALL SUBOPT_0xB1
; 0000 0DBE stala_czasowa = 62;
	__GETD1N 0x3E
	STS  _stala_czasowa,R30
	STS  _stala_czasowa+1,R31
	STS  _stala_czasowa+2,R22
	STS  _stala_czasowa+3,R23
; 0000 0DBF //il_pretow_gwintowanych = 5;  //minimum dac 5 w panelu
; 0000 0DC0 zajechalem = 0;
	CALL SUBOPT_0x4E
; 0000 0DC1 sekwencja = 0;
; 0000 0DC2 czas_silnika_dokrecajacego_grzybki_stala = 220;
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	STS  _czas_silnika_dokrecajacego_grzybki_stala,R30
	STS  _czas_silnika_dokrecajacego_grzybki_stala+1,R31
; 0000 0DC3 czas_silnika_dokrecajacego_grzybki = 40;  //zmianiam z 35 na 55 bo sie wyrobila guma
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _czas_silnika_dokrecajacego_grzybki,R30
	STS  _czas_silnika_dokrecajacego_grzybki+1,R31
; 0000 0DC4 dlugosc_preta_gwintowanego = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x1C
; 0000 0DC5 licznik = 0;
	LDI  R30,LOW(0)
	STS  _licznik,R30
	STS  _licznik+1,R30
; 0000 0DC6 licznik_pucharow = 0;
	CALL SUBOPT_0xBF
; 0000 0DC7 licznik_spoznien_monter_1 = -1;
	CALL SUBOPT_0xC0
; 0000 0DC8 licznik_spoznien_monter_2 = -1;
; 0000 0DC9 licznik_spoznien_monter_3 = -1;
; 0000 0DCA ff = 0;
	LDI  R30,LOW(0)
	STS  _ff,R30
	STS  _ff+1,R30
; 0000 0DCB pierwszy_raz = 0;
	STS  _pierwszy_raz,R30
	STS  _pierwszy_raz+1,R30
; 0000 0DCC czas_monterow_stala = 0;
	STS  _czas_monterow_stala,R30
	STS  _czas_monterow_stala+1,R30
; 0000 0DCD oczekiwanie_na_poprawienie = 0;
	STS  _oczekiwanie_na_poprawienie,R30
	STS  _oczekiwanie_na_poprawienie+1,R30
; 0000 0DCE czekaj_komunikat = 0;
	CALL SUBOPT_0x75
; 0000 0DCF potw_zielonym_bo_pomyliles_pedal_z_potwierdz = 0;
	LDI  R30,LOW(0)
	STS  _potw_zielonym_bo_pomyliles_pedal_z_potwierdz,R30
	STS  _potw_zielonym_bo_pomyliles_pedal_z_potwierdz+1,R30
; 0000 0DD0 przejechalem_czujnik_lub_jestem_na_nim = 0;
	STS  _przejechalem_czujnik_lub_jestem_na_nim,R30
	STS  _przejechalem_czujnik_lub_jestem_na_nim+1,R30
; 0000 0DD1 licznik_niezakreconych_grzybkow = 0;
	STS  _licznik_niezakreconych_grzybkow,R30
	STS  _licznik_niezakreconych_grzybkow+1,R30
; 0000 0DD2 licznik_wylatujacych_grzybkow = 0;
	STS  _licznik_wylatujacych_grzybkow,R30
	STS  _licznik_wylatujacych_grzybkow+1,R30
; 0000 0DD3 grzybek_jest_nakrecony_na_precie = 0;
	CALL SUBOPT_0x61
; 0000 0DD4 licznik_wyzwolen_kurtyny = 0;
	STS  _licznik_wyzwolen_kurtyny,R30
	STS  _licznik_wyzwolen_kurtyny+1,R30
; 0000 0DD5 licznik_pucharow_global = 0;
	LDI  R30,LOW(0)
	STS  _licznik_pucharow_global,R30
	STS  _licznik_pucharow_global+1,R30
; 0000 0DD6 czas_zaloczonego_orientatora = 0;
	CALL SUBOPT_0xA
; 0000 0DD7 zaloczono_kurtyne = 0;
	CALL SUBOPT_0x45
; 0000 0DD8 anuluj_biezace_zlecenie_const = 0;
	LDI  R30,LOW(0)
	STS  _anuluj_biezace_zlecenie_const,R30
	STS  _anuluj_biezace_zlecenie_const+1,R30
; 0000 0DD9 wynik_wyboru_male_puchary = 0;
	STS  _wynik_wyboru_male_puchary,R30
	STS  _wynik_wyboru_male_puchary+1,R30
; 0000 0DDA wielkosc_kamienia = 0;
	STS  _wielkosc_kamienia,R30
	STS  _wielkosc_kamienia+1,R30
; 0000 0DDB 
; 0000 0DDC 
; 0000 0DDD 
; 0000 0DDE z = 0; //do panela
	STS  _z,R30
; 0000 0DDF d = 0;
	STS  _d,R30
	STS  _d+1,R30
; 0000 0DE0 dd = 0;
	STS  _dd,R30
	STS  _dd+1,R30
; 0000 0DE1 gg = 0;
	STS  _gg,R30
	STS  _gg+1,R30
; 0000 0DE2 klej = 0;
	STS  _klej,R30
	STS  _klej+1,R30
; 0000 0DE3 klej_slave = 0;
	STS  _klej_slave,R30
	STS  _klej_slave+1,R30
; 0000 0DE4 monter_slave = 0;
	CALL SUBOPT_0x76
; 0000 0DE5 
; 0000 0DE6 
; 0000 0DE7 
; 0000 0DE8 //while(1)
; 0000 0DE9 //{
; 0000 0DEA //wyswietl_czas_laczny_przezbrajan();
; 0000 0DEB //wyswietl_czas_procesu();
; 0000 0DEC //wyswietl_czas_przezbrojenia();
; 0000 0DED //}
; 0000 0DEE 
; 0000 0DEF /////////////////////////////////////////sekwencja do testowania jak jada grzebienie
; 0000 0DF0 
; 0000 0DF1 
; 0000 0DF2 //while(1)
; 0000 0DF3 //{
; 0000 0DF4 //if(PINA.7 == 0)
; 0000 0DF5 //    PORTD.0 = 1;
; 0000 0DF6 //else
; 0000 0DF7 //    PORTD.0 = 0;
; 0000 0DF8 //}
; 0000 0DF9 
; 0000 0DFA 
; 0000 0DFB //jezeli dajemy z panelu dlugosc preta gwintowanego na 60 to wtedy tryb testowy
; 0000 0DFC 
; 0000 0DFD 
; 0000 0DFE ///////////////////////////////////////////
; 0000 0DFF while(start == 0)
_0x2B3:
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x2B5
; 0000 0E00     start = ustawienia_startowe();
	CALL _ustawienia_startowe
	MOVW R12,R30
	RJMP _0x2B3
_0x2B5:
; 0000 0E02 while (1)
_0x2B6:
; 0000 0E03       {
; 0000 0E04       orientator_grzybkow();
	CALL _orientator_grzybkow
; 0000 0E05       wznowienie_pracy_po_wykonaniu_zadania();
	RCALL _wznowienie_pracy_po_wykonaniu_zadania
; 0000 0E06       procesy();
	RCALL _procesy
; 0000 0E07       kontrola_monterow();
	RCALL _kontrola_monterow
; 0000 0E08       zerowanie_procesow();
	RCALL _zerowanie_procesow
; 0000 0E09       kontrola_lampki_brak_pretow();
	CALL _kontrola_lampki_brak_pretow
; 0000 0E0A       }
	RJMP _0x2B6
; 0000 0E0B }
_0x2B9:
	RJMP _0x2B9
;
;
;
;
;
;
;
;
;
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
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x4
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0xC1
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0xC1
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0xC2
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xC3
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC4
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC4
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC5
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xC5
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0xC1
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0xC1
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xC3
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0xC1
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xC3
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_skonczony_proces:
	.BYTE 0x14
_proces:
	.BYTE 0x14
_licznik_pucharow:
	.BYTE 0x2
_licznik:
	.BYTE 0x2
_jest_pret_pod_czujnikami:
	.BYTE 0x2
_czas_silnika_dokrecajacego_grzybki:
	.BYTE 0x2
_czas_silnika_dokrecajacego_grzybki_stala:
	.BYTE 0x2
_il_pretow_gwintowanych:
	.BYTE 0x2
_dlugosc_preta_gwintowanego:
	.BYTE 0x2
_sek0:
	.BYTE 0x4
_sek1:
	.BYTE 0x4
_sek2:
	.BYTE 0x4
_sek3:
	.BYTE 0x4
_sek0_7s:
	.BYTE 0x4
_sek1_7s:
	.BYTE 0x4
_sek2_7s:
	.BYTE 0x4
_sek3_7s:
	.BYTE 0x4
_czas_monterow:
	.BYTE 0x4
_czas_na_transport_preta:
	.BYTE 0x4
_monter_1_time:
	.BYTE 0x4
_monter_2_time:
	.BYTE 0x4
_monter_3_time:
	.BYTE 0x4
_stala_czasowa:
	.BYTE 0x4
_licznik_spoznien_monter_1:
	.BYTE 0x2
_licznik_spoznien_monter_2:
	.BYTE 0x2
_licznik_spoznien_monter_3:
	.BYTE 0x2
_licznik_spoznien_monter_1_2:
	.BYTE 0x2
_licznik_spoznien_monter_3_nowy:
	.BYTE 0x2
_d:
	.BYTE 0x2
_dd:
	.BYTE 0x2
_gg:
	.BYTE 0x2
_klej:
	.BYTE 0x2
_klej_slave:
	.BYTE 0x2
_monter_slave:
	.BYTE 0x2
_ff:
	.BYTE 0x2
_z:
	.BYTE 0x1
_grzybek:
	.BYTE 0x2
_il_grzybkow:
	.BYTE 0x2
_kontrola_grzybkow:
	.BYTE 0x2
_licz:
	.BYTE 0x2
_grzybek_biezacy_dokrecony:
	.BYTE 0x2
_grzybek_dokrecony:
	.BYTE 0x2
_oproznij_podajnik:
	.BYTE 0x2
_metalowe_grzybki:
	.BYTE 0x2
_zajechalem:
	.BYTE 0x2
_sekwencja:
	.BYTE 0x2
_pierwszy_raz:
	.BYTE 0x2
_czas_monterow_stala:
	.BYTE 0x2
_il_pretow_gwintowanych_stala:
	.BYTE 0x2
_oczekiwanie_na_poprawienie:
	.BYTE 0x2
_potw_zielonym_bo_pomyliles_pedal_z_potwierdz:
	.BYTE 0x2
_czekaj_komunikat:
	.BYTE 0x2
_przejechalem_czujnik_lub_jestem_na_nim:
	.BYTE 0x2
_licznik_niezakreconych_grzybkow:
	.BYTE 0x2
_grzybek_jest_nakrecony_na_precie:
	.BYTE 0x2
_licznik_wylatujacych_grzybkow:
	.BYTE 0x2
_licznik_wyzwolen_kurtyny:
	.BYTE 0x2
_licznik_pucharow_global:
	.BYTE 0x2
_czas_zaloczonego_orientatora:
	.BYTE 0x4
_zaloczono_kurtyne:
	.BYTE 0x2
_anuluj_biezace_zlecenie:
	.BYTE 0x2
_licznik_niewlozonych_pretow_z_grzybkiem:
	.BYTE 0x2
_anuluj_biezace_zlecenie_const:
	.BYTE 0x2
_msek_clock:
	.BYTE 0x2
_sek_clock:
	.BYTE 0x2
_min_clock:
	.BYTE 0x2
_godz_clock:
	.BYTE 0x2
_przez_sek_clock:
	.BYTE 0x2
_przez_min_clock:
	.BYTE 0x2
_przez_godz_clock:
	.BYTE 0x2
_tryb_male_puchary:
	.BYTE 0x2
_predkosc_wiezyczek_male_puchary:
	.BYTE 0x2
_wynik_wyboru_male_puchary:
	.BYTE 0x2
_wielkosc_kamienia:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _msek_clock,R30
	STS  _msek_clock+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _sek_clock,R30
	STS  _sek_clock+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _min_clock,R30
	STS  _min_clock+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R26,_sek_clock
	LDS  R27,_sek_clock+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_min_clock
	LDS  R27,_min_clock+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	__GETD1N 0x186A0
	CALL __GTD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _czas_zaloczonego_orientatora,R30
	STS  _czas_zaloczonego_orientatora+1,R30
	STS  _czas_zaloczonego_orientatora+2,R30
	STS  _czas_zaloczonego_orientatora+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x12,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 52 TIMES, CODE SIZE REDUCTION:303 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(131)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:157 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(96)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _licz,R30
	STS  _licz+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(35)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(144)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	STS  _dlugosc_preta_gwintowanego,R30
	STS  _dlugosc_preta_gwintowanego+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDS  R26,_dlugosc_preta_gwintowanego
	LDS  R27,_dlugosc_preta_gwintowanego+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(131)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(16)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(16)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	MOV  R18,R30
	CLR  R19
	MOV  R0,R18
	OR   R0,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(80)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDS  R26,_il_pretow_gwintowanych
	LDS  R27,_il_pretow_gwintowanych+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x26:
	LDS  R30,_czas_monterow
	LDS  R31,_czas_monterow+1
	LDS  R22,_czas_monterow+2
	LDS  R23,_czas_monterow+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(112)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL _getchar
	CALL _getchar
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	STS  _il_pretow_gwintowanych,R30
	STS  _il_pretow_gwintowanych+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDS  R30,_il_pretow_gwintowanych
	LDS  R31,_il_pretow_gwintowanych+1
	STS  _il_pretow_gwintowanych_stala,R30
	STS  _il_pretow_gwintowanych_stala+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(131)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x2D:
	LDS  R26,_predkosc_wiezyczek_male_puchary
	LDS  R27,_predkosc_wiezyczek_male_puchary+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wielkosc_kamienia
	LDS  R27,_wielkosc_kamienia+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2E:
	STS  _wynik_wyboru_male_puchary,R30
	STS  _wynik_wyboru_male_puchary+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x2F:
	LDS  R26,_predkosc_wiezyczek_male_puchary
	LDS  R27,_predkosc_wiezyczek_male_puchary+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wielkosc_kamienia
	LDS  R27,_wielkosc_kamienia+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x31:
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(80)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	CALL _putchar
	ST   -Y,R16
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(255)
	MULS R16,R26
	MOVW R30,R0
	ADD  R30,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	CALL _putchar
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	LDS  R30,_sek_clock
	LDS  R31,_sek_clock+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	__POINTW1FN _0x0,738
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3F:
	LDS  R30,_min_clock
	LDS  R31,_min_clock+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	LDS  R30,_godz_clock
	LDS  R31,_godz_clock+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDS  R26,_przez_sek_clock
	LDS  R27,_przez_sek_clock+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDS  R26,_przez_min_clock
	LDS  R27,_przez_min_clock+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDS  R26,_przez_godz_clock
	LDS  R27,_przez_godz_clock+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(0)
	STS  _zaloczono_kurtyne,R30
	STS  _zaloczono_kurtyne+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x49:
	CALL _komunikat_czysc_na_panel
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R31
	CBI  0x3,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	STS  _zajechalem,R30
	STS  _zajechalem+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	LDS  R26,_zajechalem
	LDS  R27,_zajechalem+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(0)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(0)
	STS  _zajechalem,R30
	STS  _zajechalem+1,R30
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zaloczono_kurtyne,R30
	STS  _zaloczono_kurtyne+1,R31
	LDI  R26,LOW(_licznik_wyzwolen_kurtyny)
	LDI  R27,HIGH(_licznik_wyzwolen_kurtyny)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x50:
	LDS  R30,_licznik_wylatujacych_grzybkow
	LDS  R31,_licznik_wylatujacych_grzybkow+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_niezakreconych_grzybkow
	LDS  R31,_licznik_niezakreconych_grzybkow+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_wyzwolen_kurtyny
	LDS  R31,_licznik_wyzwolen_kurtyny+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_niewlozonych_pretow_z_grzybkiem
	LDS  R31,_licznik_niewlozonych_pretow_z_grzybkiem+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_spoznien_monter_1_2
	LDS  R31,_licznik_spoznien_monter_1_2+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_spoznien_monter_3_nowy
	LDS  R31,_licznik_spoznien_monter_3_nowy+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wyswietl_parametry

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(0)
	__CLRD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(0)
	__CLRD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _sekwencja,R30
	STS  _sekwencja+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x55:
	MOVW R26,R16
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	OR   R0,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	OR   R0,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	OR   R0,R30
	LDS  R26,_sekwencja
	LDS  R27,_sekwencja+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x57:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	MOVW R26,R12
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __GEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5F:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _przejechalem_czujnik_lub_jestem_na_nim,R30
	STS  _przejechalem_czujnik_lub_jestem_na_nim+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(0)
	STS  _grzybek_jest_nakrecony_na_precie,R30
	STS  _grzybek_jest_nakrecony_na_precie+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x62:
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x63:
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	__GETD1N 0x5
	CALL __GTD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x65:
	LDI  R26,0
	SBIC 0x0,7
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x66:
	__GETD2S 10
	__CPD2N 0x3E9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x67:
	MOVW R26,R12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __GEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x68:
	LDS  R26,_tryb_male_puchary
	LDS  R27,_tryb_male_puchary+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	MOVW R26,R12
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __GEW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x68
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	__SUBD1N -1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6D:
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odpytaj_parametry_z_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	CBI  0x15,2
	SBI  0x3,2
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0x70

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x72:
	CALL _czekaj_na_guzik_start
	STS  _z,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	LDS  R30,_wynik_wyboru_male_puchary
	LDS  R31,_wynik_wyboru_male_puchary+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikacja_startowa_male_puchary

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x74:
	STS  _klej,R30
	STS  _klej+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	LDI  R30,LOW(0)
	STS  _czekaj_komunikat,R30
	STS  _czekaj_komunikat+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDI  R30,LOW(0)
	STS  _monter_slave,R30
	STS  _monter_slave+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	STS  _monter_slave,R30
	STS  _monter_slave+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _proces,R30
	STS  _proces+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	RJMP SUBOPT_0x6D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	RJMP SUBOPT_0x5F

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x7B:
	LDI  R30,LOW(0)
	STS  _sek0,R30
	STS  _sek0+1,R30
	STS  _sek0+2,R30
	STS  _sek0+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7C:
	STS  _proces,R30
	STS  _proces+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jest_pret_pod_czujnikami,R30
	STS  _jest_pret_pod_czujnikami+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7E:
	LDS  R26,_sek0
	LDS  R27,_sek0+1
	LDS  R24,_sek0+2
	LDS  R25,_sek0+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7F:
	__CPD2N 0x29
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x80:
	RCALL SUBOPT_0x7E
	__CPD2N 0x15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x81:
	__GETD1N 0x15
	STS  _sek0,R30
	STS  _sek0+1,R31
	STS  _sek0+2,R22
	STS  _sek0+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x82:
	__CPD2N 0x33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x62
	__POINTW1MN _proces,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x84:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x85:
	__CPD2N 0x3D
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x87:
	__CPD2N 0x1F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x88:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x89:
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8B:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x8C:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x8D:
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _grzybek_biezacy_dokrecony,R30
	STS  _grzybek_biezacy_dokrecony+1,R31
	RJMP SUBOPT_0x8C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8F:
	__POINTW1MN _proces,4
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x90:
	__CPD2N 0xB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x91:
	__CPD2N 0x15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x92:
	LDI  R30,LOW(0)
	STS  _grzybek_biezacy_dokrecony,R30
	STS  _grzybek_biezacy_dokrecony+1,R30
	RJMP SUBOPT_0x8C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x93:
	LDS  R26,_grzybek_biezacy_dokrecony
	LDS  R27,_grzybek_biezacy_dokrecony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x94:
	RCALL SUBOPT_0x93
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x95:
	__POINTW1MN _proces,4
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x96:
	RCALL SUBOPT_0x8D
	__GETD1N 0x0
	CALL __GTD12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x97:
	CBI  0x18,7
	RCALL SUBOPT_0x8D
	__CPD2N 0xE
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x98:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x99:
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9A:
	LDI  R30,LOW(0)
	STS  _skonczony_proces,R30
	STS  _skonczony_proces+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9B:
	__POINTW1MN _skonczony_proces,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9C:
	__POINTW1MN _skonczony_proces,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9D:
	__POINTW1MN _skonczony_proces,6
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9E:
	CALL _zerowanie_czasu
	LDI  R30,LOW(0)
	STS  _jest_pret_pod_czujnikami,R30
	STS  _jest_pret_pod_czujnikami+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x9F:
	LDI  R30,LOW(0)
	STS  _monter_1_time,R30
	STS  _monter_1_time+1,R30
	STS  _monter_1_time+2,R30
	STS  _monter_1_time+3,R30
	STS  _monter_2_time,R30
	STS  _monter_2_time+1,R30
	STS  _monter_2_time+2,R30
	STS  _monter_2_time+3,R30
	STS  _monter_3_time,R30
	STS  _monter_3_time+1,R30
	STS  _monter_3_time+2,R30
	STS  _monter_3_time+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA0:
	LDS  R26,_skonczony_proces
	LDS  R27,_skonczony_proces+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA1:
	MOVW R26,R12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA2:
	__GETW1MN _skonczony_proces,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA3:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xA1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA4:
	AND  R0,R30
	MOVW R26,R12
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA5:
	LDS  R26,_jest_pret_pod_czujnikami
	LDS  R27,_jest_pret_pod_czujnikami+1
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA6:
	__GETW1MN _skonczony_proces,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA7:
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __NEW12
	AND  R0,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __NEW12
	AND  R0,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __NEW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA8:
	CLR  R4
	CLR  R5
	CLR  R6
	CLR  R7
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(0)
	__CLRD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xAA:
	RCALL SUBOPT_0xA0
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xAB:
	CALL _czekaj_na_klej
	RCALL SUBOPT_0x74
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _klej_slave,R30
	STS  _klej_slave+1,R31
	CALL _kontrola_grzyb
	STS  _kontrola_grzybkow,R30
	STS  _kontrola_grzybkow+1,R31
	LDS  R26,_z
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xAC:
	LDS  R26,_klej
	LDS  R27,_klej+1
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xAD:
	AND  R0,R30
	LDS  R26,_klej_slave
	LDS  R27,_klej_slave+1
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xAE:
	AND  R0,R30
	LDS  R26,_kontrola_grzybkow
	LDS  R27,_kontrola_grzybkow+1
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xAF:
	CALL _przenies_pret_gwintowany
	CALL _wyswietl_czas_procesu
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL _odpytaj_parametry_z_panelu
	RJMP SUBOPT_0x9A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB0:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EQW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB1:
	LDI  R30,LOW(0)
	STS  _jest_pret_pod_czujnikami,R30
	STS  _jest_pret_pod_czujnikami+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB2:
	LDS  R26,_monter_slave
	LDS  R27,_monter_slave+1
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB3:
	MOVW R26,R12
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __GEW12
	AND  R0,R30
	RCALL SUBOPT_0x68
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xB4:
	__GETD1S 2
	RCALL SUBOPT_0x6B
	__PUTD1S 2
	__GETD2S 2
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB5:
	__GETD2S 2
	__CPD2N 0x65
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB6:
	LDS  R30,_licznik_pucharow
	LDS  R31,_licznik_pucharow+1
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB7:
	CALL __GTD12
	MOV  R0,R30
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB8:
	LDI  R26,0
	SBIC 0x0,4
	LDI  R26,1
	RJMP SUBOPT_0x6D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB9:
	RCALL SUBOPT_0x26
	LDS  R26,_monter_3_time
	LDS  R27,_monter_3_time+1
	LDS  R24,_monter_3_time+2
	LDS  R25,_monter_3_time+3
	RJMP SUBOPT_0xB7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBA:
	LDI  R26,LOW(_licznik_spoznien_monter_3)
	LDI  R27,HIGH(_licznik_spoznien_monter_3)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBC:
	LDI  R26,LOW(_licznik_pucharow)
	LDI  R27,HIGH(_licznik_pucharow)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xBD:
	LDI  R26,LOW(_licznik_pucharow_global)
	LDI  R27,HIGH(_licznik_pucharow_global)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xBE:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_licznik_pucharow_global
	LDS  R31,_licznik_pucharow_global+1
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _wyswietl_ilosc_zmontowanych_pucharow
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xBF:
	LDI  R30,LOW(0)
	STS  _licznik_pucharow,R30
	STS  _licznik_pucharow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC0:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _licznik_spoznien_monter_1,R30
	STS  _licznik_spoznien_monter_1+1,R31
	STS  _licznik_spoznien_monter_2,R30
	STS  _licznik_spoznien_monter_2+1,R31
	STS  _licznik_spoznien_monter_3,R30
	STS  _licznik_spoznien_monter_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xC1:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC2:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC3:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC4:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC5:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

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

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__NEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRNE __NEW12T
	CLR  R30
__NEW12T:
	RET

__GEW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRGE __GEW12T
	CLR  R30
__GEW12T:
	RET

__LTW12:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLT __LTW12T
	CLR  R30
__LTW12T:
	RET

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
	RET

__GED12:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRGE __GED12T
	CLR  R30
__GED12T:
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
