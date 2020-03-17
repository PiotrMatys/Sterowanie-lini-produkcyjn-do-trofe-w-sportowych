
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
;Date    : 2017-02-16
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
;long int sek5;
;int wyzerowalem_sek5;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0052 {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0053 sek0++;
	LDI  R26,LOW(_sek0)
	LDI  R27,HIGH(_sek0)
	CALL SUBOPT_0x1
; 0000 0054 sek1++;
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x1
; 0000 0055 sek2++;
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x1
; 0000 0056 sek3++;
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x1
; 0000 0057 sek4++;
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x1
; 0000 0058 sek5++;
	LDI  R26,LOW(_sek5)
	LDI  R27,HIGH(_sek5)
	RJMP _0x33A
; 0000 0059 }
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 005C {
_timer2_ovf_isr:
	CALL SUBOPT_0x0
; 0000 005D // Place your code here
; 0000 005E ulamki_sekund_0++;
	LDI  R26,LOW(_ulamki_sekund_0)
	LDI  R27,HIGH(_ulamki_sekund_0)
	CALL SUBOPT_0x1
; 0000 005F ulamki_sekund_1++;
	LDI  R26,LOW(_ulamki_sekund_1)
	LDI  R27,HIGH(_ulamki_sekund_1)
_0x33A:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0060 }
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
; 0000 0064 {
; 0000 0065 PORTE.5 = 0;
;	speed -> Y+2
;	r -> Y+0
; 0000 0066 if(ulamki_sekund_0 >= speed)
; 0000 0067     {
; 0000 0068     PORTE.5 = 1;
; 0000 0069     ulamki_sekund_0 = 0;
; 0000 006A     r++;
; 0000 006B     }
; 0000 006C return r;
; 0000 006D }
;
;
;void drgania()
; 0000 0071 {
_drgania:
; 0000 0072 licznik_drgania++;
	LDI  R26,LOW(_licznik_drgania)
	LDI  R27,HIGH(_licznik_drgania)
	CALL SUBOPT_0x1
; 0000 0073 if(licznik_drgania == 6000)  //6666
	CALL SUBOPT_0x2
	__CPD2N 0x1770
	BRNE _0x8
; 0000 0074     PORTD.4 = 1;
	SBI  0x12,4
; 0000 0075 if(licznik_drgania == 12000)//26666
_0x8:
	CALL SUBOPT_0x2
	__CPD2N 0x2EE0
	BRNE _0xB
; 0000 0076     {
; 0000 0077     PORTD.4 = 0;
	CBI  0x12,4
; 0000 0078     licznik_drgania = 0;
	CALL SUBOPT_0x3
; 0000 0079     }
; 0000 007A }
_0xB:
	RET
;
;
;
;
;void obsluga_startowa_dozownika_kleju()
; 0000 0080 {
; 0000 0081 int ss;
; 0000 0082 ss = 0;
;	ss -> R16,R17
; 0000 0083 
; 0000 0084 PORTB.1 = 1;  //zasilanie 220V na dozownik kleju
; 0000 0085 PORTB.4 = 1;  //cisnienie na dozownik kleju
; 0000 0086 
; 0000 0087 
; 0000 0088 while(PINA.6 == 1)
; 0000 0089   {
; 0000 008A   if(PINA.3 == 0)
; 0000 008B     {
; 0000 008C     //lcd_clear();
; 0000 008D     //lcd_gotoxy(0,0);
; 0000 008E     //lcd_puts("1");
; 0000 008F     delay_ms(1000);
; 0000 0090     if(ss == 0)
; 0000 0091         {
; 0000 0092         putchar(0);       //dozownik kleju nie gotowy
; 0000 0093         ss = 1;
; 0000 0094         }
; 0000 0095 
; 0000 0096     }
; 0000 0097   }
; 0000 0098 putchar(1);  //jest wszystko ok z dozownikiem
; 0000 0099 
; 0000 009A 
; 0000 009B   //sle komunikat
; 0000 009C   //dozownik kleju nie gotowy
; 0000 009D   //poprawnie - jak w naczelnym 1 to na pina.3=0
; 0000 009E 
; 0000 009F   //lcd_clear();
; 0000 00A0   //lcd_gotoxy(0,0);
; 0000 00A1   //lcd_puts("petla");
; 0000 00A2   //delay_ms(1000);
; 0000 00A3   //}
; 0000 00A4   //else
; 0000 00A5   //{
; 0000 00A6   //brak sygnalu z master PINA.3
; 0000 00A7   //delay_ms(1000);
; 0000 00A8   //lcd_clear();
; 0000 00A9   //lcd_gotoxy(0,0);
; 0000 00AA   //lcd_puts("petla222");
; 0000 00AB   //delay_ms(1000);
; 0000 00AC 
; 0000 00AD }
;
;
;
;
;
;
;void komunikacja_bez_rs232()
; 0000 00B5 {
_komunikacja_bez_rs232:
; 0000 00B6 
; 0000 00B7 /*
; 0000 00B8 if(PINA.3 == 0 & poczatek == 0)
; 0000 00B9       {
; 0000 00BA       PORTB.6 = 1;
; 0000 00BB       poczatek = 1;
; 0000 00BC       }
; 0000 00BD 
; 0000 00BE if(PINA.3 == 1 & poczatek == 1)
; 0000 00BF       {
; 0000 00C0       PORTB.6 = 0;
; 0000 00C1       wcisniete_zakonczone = 2;
; 0000 00C2       poczatek = 3;
; 0000 00C3       }
; 0000 00C4 */
; 0000 00C5 
; 0000 00C6 if(tryb_male_puchary == 3)
	CALL SUBOPT_0x4
	SBIW R26,3
	BRNE _0x17
; 0000 00C7     {
; 0000 00C8     if(PINF.5 == 0)
	SBIC 0x0,5
	RJMP _0x18
; 0000 00C9         zezwolenie_od_master = 1;
	CALL SUBOPT_0x5
; 0000 00CA     else
	RJMP _0x19
_0x18:
; 0000 00CB         zezwolenie_od_master = 0;
	CALL SUBOPT_0x6
; 0000 00CC 
; 0000 00CD                                              //dodaje do uzwglednienia komunikacje male puchary
; 0000 00CE     if(PINA.3 == 0 & wcisniete_zakonczone == 1 & PINF.7 == 1)
_0x19:
	CALL SUBOPT_0x7
	BREQ _0x1A
; 0000 00CF        {
; 0000 00D0        PORTB.6 = 1;
	CALL SUBOPT_0x8
; 0000 00D1        wcisniete_zakonczone = 2;
; 0000 00D2        }
; 0000 00D3 
; 0000 00D4                                              //dodaje do uzwglednienia komunikacje male puchary
; 0000 00D5     if(PINA.3 == 1 & wcisniete_zakonczone == 2 & PINF.7 == 1)
_0x1A:
	CALL SUBOPT_0x9
	BREQ _0x1D
; 0000 00D6         PORTB.6 = 0;
	CBI  0x18,6
; 0000 00D7     }
_0x1D:
; 0000 00D8 else
	RJMP _0x20
_0x17:
; 0000 00D9     {
; 0000 00DA     if(PINF.5 == 0)
	SBIC 0x0,5
	RJMP _0x21
; 0000 00DB         zezwolenie_od_master = 1;
	CALL SUBOPT_0x5
; 0000 00DC     else
	RJMP _0x22
_0x21:
; 0000 00DD         zezwolenie_od_master = 0;
	CALL SUBOPT_0x6
; 0000 00DE 
; 0000 00DF 
; 0000 00E0     if(PINA.3 == 0 & wcisniete_zakonczone == 1 & PINF.7 == 1)
_0x22:
	CALL SUBOPT_0x7
	BREQ _0x23
; 0000 00E1        {                                                     //zezwolenie na jazde tasmy
; 0000 00E2        PORTB.6 = 1;
	CALL SUBOPT_0x8
; 0000 00E3        wcisniete_zakonczone = 2;
; 0000 00E4        }
; 0000 00E5 
; 0000 00E6        if(PINA.3 == 1 & wcisniete_zakonczone == 2 & PINF.7 == 1)
_0x23:
	CALL SUBOPT_0x9
	BREQ _0x26
; 0000 00E7             PORTB.6 = 0;
	CBI  0x18,6
; 0000 00E8 
; 0000 00E9     }
_0x26:
_0x20:
; 0000 00EA 
; 0000 00EB 
; 0000 00EC 
; 0000 00ED }
	RET
;
;
;
;
;
;void obsluga_dozownika_kleju_i_komunikacja()
; 0000 00F4 {
; 0000 00F5 int znak;
; 0000 00F6 
; 0000 00F7 znak = 0;
;	znak -> R16,R17
; 0000 00F8 
; 0000 00F9 if(PINA.3 == 0 & znak == 0 & czekaj_komunikacja == 0)
; 0000 00FA     {
; 0000 00FB     znak = getchar();
; 0000 00FC 
; 0000 00FD     if(PINA.6 == 1 & znak == 1)   //brak kleju
; 0000 00FE        {
; 0000 00FF        //putchar(0);
; 0000 0100        putchar(1);
; 0000 0101        }
; 0000 0102 
; 0000 0103     if(PINA.6 == 0 & znak == 1)  //klej jest
; 0000 0104        {
; 0000 0105        putchar(1);
; 0000 0106        }
; 0000 0107 
; 0000 0108     /*
; 0000 0109 
; 0000 010A     if(wcisnalem_pedal == 1 & znak == 4)
; 0000 010B         {
; 0000 010C         putchar(1);
; 0000 010D         }
; 0000 010E 
; 0000 010F     if(wcisnalem_pedal == 0 & znak == 4)
; 0000 0110         {
; 0000 0111         putchar(0);
; 0000 0112         }
; 0000 0113 
; 0000 0114     */
; 0000 0115 
; 0000 0116     if(wcisniete_zakonczone == 1 & znak == 4)
; 0000 0117         {
; 0000 0118         putchar(1);
; 0000 0119         }
; 0000 011A 
; 0000 011B     if(wcisniete_zakonczone == 0 & znak == 4)
; 0000 011C         {
; 0000 011D         putchar(0);
; 0000 011E         }
; 0000 011F 
; 0000 0120     if(zacisnalem_szczeki == 1 & znak == 6)
; 0000 0121         {
; 0000 0122         putchar(1);
; 0000 0123         }
; 0000 0124 
; 0000 0125     if(zacisnalem_szczeki == 0 & znak == 6)
; 0000 0126         {
; 0000 0127         putchar(0);
; 0000 0128         }
; 0000 0129 
; 0000 012A 
; 0000 012B     if(znak == 2)
; 0000 012C        {
; 0000 012D        pomocnicza = getchar();
; 0000 012E        czas_monterow = pomocnicza * stala_czasowa;
; 0000 012F        putchar(3);     //ze przyjalem
; 0000 0130        }
; 0000 0131 
; 0000 0132     if(znak == 3)
; 0000 0133        {
; 0000 0134        podaj_nakretke = getchar();
; 0000 0135        zezwolenie_na_zacisniecie_szczek_od_master = 0;
; 0000 0136        wcisnalem_pedal = 0;
; 0000 0137        zacisnalem_szczeki = 0;
; 0000 0138        wcisniete_zakonczone = 0;
; 0000 0139        putchar(3);     //ze przyjalem
; 0000 013A        }
; 0000 013B 
; 0000 013C     if(znak == 5)
; 0000 013D        {
; 0000 013E        zezwolenie_na_zacisniecie_szczek_od_master = getchar();
; 0000 013F        putchar(3);     //ze przyjalem
; 0000 0140        }
; 0000 0141     }
; 0000 0142 
; 0000 0143 if(znak == 1 | znak == 2 | znak == 3 | znak == 4 | znak == 5  | znak == 6  | czekaj_komunikacja > 0)  //tu jeszcze poprawic
; 0000 0144     czekaj_komunikacja++;
; 0000 0145 if(czekaj_komunikacja == 1000)
; 0000 0146     czekaj_komunikacja = 0;
; 0000 0147 
; 0000 0148 
; 0000 0149 }
;
;
;void kontrola_czujnika_dolnego_nakretek()
; 0000 014D {
_kontrola_czujnika_dolnego_nakretek:
; 0000 014E if(PINF.4 == 0)
	SBIC 0x0,4
	RJMP _0x35
; 0000 014F     {
; 0000 0150     PORTD.5 = 1;
	SBI  0x12,5
; 0000 0151     //PORTB.5 = 1;  //drgania wibracyjne
; 0000 0152     PORTD.6 = 0;  //silownik podaje nakretke monterowi
	CBI  0x12,6
; 0000 0153     }
; 0000 0154 else
	RJMP _0x3A
_0x35:
; 0000 0155     {
; 0000 0156     PORTD.5 = 0;
	CBI  0x12,5
; 0000 0157     }
_0x3A:
; 0000 0158 
; 0000 0159 }
	RET
;
;
;
;void kontrola_orientatora_nakretek_nowa_zjezdzalnia()
; 0000 015E {
_kontrola_orientatora_nakretek_nowa_zjezdzalnia:
; 0000 015F if(PINA.0 == 0)
	SBIC 0x19,0
	RJMP _0x3D
; 0000 0160     {
; 0000 0161     //licznik_widzenia_nakretki++;
; 0000 0162     //if(licznik_widzenia_nakretki > 1000)
; 0000 0163     //    {
; 0000 0164         PORTB.0 = 0;
	CBI  0x18,0
; 0000 0165     //    licznik_widzenia_nakretki = 0;
; 0000 0166     //    }
; 0000 0167     }
; 0000 0168 else
	RJMP _0x40
_0x3D:
; 0000 0169     {
; 0000 016A     PORTB.0 = 1;
	SBI  0x18,0
; 0000 016B     //licznik_widzenia_nakretki = 0;
; 0000 016C     }
_0x40:
; 0000 016D }
	RET
;
;
;
;void kontrola_orientatora_nakretek()
; 0000 0172 {
; 0000 0173 if(PINA.0 == 0 & nakretka < 7)  //to chyba spowoduje ze nie bedzie licznik nakretek sie zapetlal
; 0000 0174         {
; 0000 0175         licznik_nakretek++;
; 0000 0176         }
; 0000 0177 if(licznik_nakretek > 700)
; 0000 0178         {
; 0000 0179         //if(
; 0000 017A             PORTB.0 = 0;  //wylacz orientator bo juz na pewno jedna spadla
; 0000 017B         nakretka++;
; 0000 017C         //nakretka_1++;
; 0000 017D         //lcd_clear();
; 0000 017E         //lcd_gotoxy(0,0);
; 0000 017F         //itoa(licznik_nakretek,dupa1);
; 0000 0180         //lcd_puts(dupa1);
; 0000 0181         //lcd_gotoxy(0,1);
; 0000 0182         //itoa(nakretka_1,dupa1);
; 0000 0183         //lcd_puts(dupa1);
; 0000 0184         licznik_nakretek = 0;
; 0000 0185         }
; 0000 0186 
; 0000 0187 //wyniki pomiarow
; 0000 0188 //1 nakretka - 1643
; 0000 0189 //              1616
; 0000 018A //              1590
; 0000 018B //              1493
; 0000 018C 
; 0000 018D }
;
;
;void jedz_wieza_cykl_nowy_procesor()
; 0000 0191 {
_jedz_wieza_cykl_nowy_procesor:
; 0000 0192 
; 0000 0193 PORTE.0 = 1;
	SBI  0x3,0
; 0000 0194 if(PINE.7 == 1)
	SBIS 0x1,7
	RJMP _0x49
; 0000 0195     {
; 0000 0196     if(wyzerowalem_sek5 == 0)
	LDS  R30,_wyzerowalem_sek5
	LDS  R31,_wyzerowalem_sek5+1
	SBIW R30,0
	BRNE _0x4A
; 0000 0197         {
; 0000 0198         sek5 = 0;
	LDI  R30,LOW(0)
	STS  _sek5,R30
	STS  _sek5+1,R30
	STS  _sek5+2,R30
	STS  _sek5+3,R30
; 0000 0199         wyzerowalem_sek5 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wyzerowalem_sek5,R30
	STS  _wyzerowalem_sek5+1,R31
; 0000 019A         }
; 0000 019B 
; 0000 019C     if(sek5 > 5 & PINE.7 == 1)
_0x4A:
	LDS  R26,_sek5
	LDS  R27,_sek5+1
	LDS  R24,_sek5+2
	LDS  R25,_sek5+3
	CALL SUBOPT_0xA
	LDI  R26,0
	SBIC 0x1,7
	LDI  R26,1
	CALL SUBOPT_0xB
	BREQ _0x4B
; 0000 019D         {
; 0000 019E         jedz_wieza_cykl_znacznik = 0;
	LDI  R30,LOW(0)
	STS  _jedz_wieza_cykl_znacznik,R30
	STS  _jedz_wieza_cykl_znacznik+1,R30
; 0000 019F         PORTC.1 = 0;
	CBI  0x15,1
; 0000 01A0         PORTE.0 = 0;
	CBI  0x3,0
; 0000 01A1         wyzerowalem_sek5 = 0;
	STS  _wyzerowalem_sek5,R30
	STS  _wyzerowalem_sek5+1,R30
; 0000 01A2         }
; 0000 01A3     }
_0x4B:
; 0000 01A4 
; 0000 01A5 if(PINE.7 == 0 & wyzerowalem_sek5 == 1)
_0x49:
	LDI  R26,0
	SBIC 0x1,7
	LDI  R26,1
	CALL SUBOPT_0xC
	LDS  R26,_wyzerowalem_sek5
	LDS  R27,_wyzerowalem_sek5+1
	CALL SUBOPT_0xD
	AND  R30,R0
	BREQ _0x50
; 0000 01A6     wyzerowalem_sek5 = 0;
	LDI  R30,LOW(0)
	STS  _wyzerowalem_sek5,R30
	STS  _wyzerowalem_sek5+1,R30
; 0000 01A7 
; 0000 01A8 }
_0x50:
	RET
;
;void jedz_wieza_cykl()
; 0000 01AB {
; 0000 01AC 
; 0000 01AD //pomysl - wyysylac w czasie drogi impulsy - to bedzie wielkosc kamienia
; 0000 01AE //pomysl - wyysylac w czasie postoju - to bedzie predkosc
; 0000 01AF //to nawet moge zrobic tu
; 0000 01B0 
; 0000 01B1 //w prawo
; 0000 01B2 
; 0000 01B3 
; 0000 01B4     switch(pozycja_wiezy)
; 0000 01B5 
; 0000 01B6         {
; 0000 01B7 
; 0000 01B8         case 0:
; 0000 01B9 
; 0000 01BA 
; 0000 01BB                 PORTE.7 = 1; //enable (1 uruchamia)
; 0000 01BC                 sek2 = 0;
; 0000 01BD                 pozycja_wiezy = 1;
; 0000 01BE                 ulamki_sekund_1 = 0;
; 0000 01BF 
; 0000 01C0 
; 0000 01C1         break;
; 0000 01C2 
; 0000 01C3         case 1:
; 0000 01C4 
; 0000 01C5                 if(kkk == kkk1)
; 0000 01C6                     kkk1 = obroc_o_1_8_stopnia(v1, kkk);
; 0000 01C7                 else
; 0000 01C8                     {                    //30 ok    //60 * 16 * 2 ok na szybki zegar
; 0000 01C9                     if(ulamki_sekund_1 > 60 * 8 * 2)
; 0000 01CA                         {
; 0000 01CB                         v1--;
; 0000 01CC                         ulamki_sekund_1 = 0;
; 0000 01CD                         }
; 0000 01CE                     kkk1 = kkk;
; 0000 01CF                     }
; 0000 01D0 
; 0000 01D1                  if(v1 == speed_normal) //6 sie pieprzy po 30 min, daje 3 ale zmieniam kroki
; 0000 01D2                     {
; 0000 01D3                     kkk = 0;
; 0000 01D4                     if(PORTE.4 == 1)   //DIR du¿y silnik
; 0000 01D5                         pozycja_wiezy = 2;
; 0000 01D6                     else
; 0000 01D7                         pozycja_wiezy = 3;
; 0000 01D8                     }
; 0000 01D9 
; 0000 01DA                 if(sek2 > 170)
; 0000 01DB                     {
; 0000 01DC                     kkk = 0;
; 0000 01DD                     kkk1 = 0;
; 0000 01DE                     bufor_bledu = 25;
; 0000 01DF                     v1 = speed_normal;
; 0000 01E0                     ulamki_sekund_1 = 0;
; 0000 01E1                     if(PORTE.4 == 1)
; 0000 01E2                         pozycja_wiezy = 2;
; 0000 01E3                     else
; 0000 01E4                         pozycja_wiezy = 3;
; 0000 01E5                     }
; 0000 01E6 
; 0000 01E7 
; 0000 01E8         break;
; 0000 01E9 
; 0000 01EA         //ustalic wielkosc przesuniecia kamien dla bez bufor bledu i z bufor bledu
; 0000 01EB 
; 0000 01EC         case 2:
; 0000 01ED             if(PINE.0 != 0)    //czujnik indukcyjny
; 0000 01EE                 obroc_o_1_8_stopnia(v1 + bufor_bledu, 0);
; 0000 01EF             else
; 0000 01F0                 {
; 0000 01F1                 if(kamien == 50)
; 0000 01F2                     wielkosc_przesuniecia_kamien = 770+60;
; 0000 01F3                 if(kamien == 55)
; 0000 01F4                     wielkosc_przesuniecia_kamien = 740+60;
; 0000 01F5                 if(kamien == 60)
; 0000 01F6                     wielkosc_przesuniecia_kamien = 710+60;
; 0000 01F7                 if(kamien == 65)
; 0000 01F8                     wielkosc_przesuniecia_kamien = 680+60;
; 0000 01F9                 if(kamien == 70)
; 0000 01FA                     wielkosc_przesuniecia_kamien = 650+60;
; 0000 01FB                 if(kamien == 75)
; 0000 01FC                     wielkosc_przesuniecia_kamien = 620+60;
; 0000 01FD 
; 0000 01FE                 pozycja_wiezy = 4;
; 0000 01FF                 }
; 0000 0200 
; 0000 0201             if(sek2 > 170 & bufor_bledu == 0)
; 0000 0202                     {
; 0000 0203                     pozycja_wiezy = 2;
; 0000 0204                     bufor_bledu = 25;
; 0000 0205                     }
; 0000 0206 
; 0000 0207         break;
; 0000 0208 
; 0000 0209         case 3:
; 0000 020A 
; 0000 020B             if(PINE.1 != 0)
; 0000 020C                 obroc_o_1_8_stopnia(v1+ bufor_bledu, 0);
; 0000 020D             else
; 0000 020E                 {
; 0000 020F                 if(kamien == 50)
; 0000 0210                     wielkosc_przesuniecia_kamien = 770+60;
; 0000 0211                 if(kamien == 55)//przesuwamy o 2,5mm
; 0000 0212                     wielkosc_przesuniecia_kamien = 740+60;
; 0000 0213                 if(kamien == 60)
; 0000 0214                     wielkosc_przesuniecia_kamien = 710+60;
; 0000 0215                 if(kamien == 65)
; 0000 0216                     wielkosc_przesuniecia_kamien = 680+60;
; 0000 0217                 if(kamien == 70)
; 0000 0218                     wielkosc_przesuniecia_kamien = 650+60;
; 0000 0219                 if(kamien == 75)
; 0000 021A                     wielkosc_przesuniecia_kamien = 620+60; //tu ma byc 8mm + 25/2mm = 20,5    18mm
; 0000 021B 
; 0000 021C                 pozycja_wiezy = 4;
; 0000 021D                 }
; 0000 021E 
; 0000 021F             if(sek2 > 170 & bufor_bledu == 0)
; 0000 0220                     {
; 0000 0221                     pozycja_wiezy = 3;
; 0000 0222                     bufor_bledu = 25;
; 0000 0223                     }
; 0000 0224         break;
; 0000 0225 
; 0000 0226 
; 0000 0227         case 4:
; 0000 0228                 if(kkk < 2)
; 0000 0229                     kkk = obroc_o_1_8_stopnia(v1+ bufor_bledu, kkk);  //jedziemy jeszcze kawalek z pelna pyta
; 0000 022A                 else
; 0000 022B                     {
; 0000 022C                     kkk = 0;
; 0000 022D                     pozycja_wiezy = 5;
; 0000 022E                     }
; 0000 022F 
; 0000 0230         break;
; 0000 0231 
; 0000 0232 
; 0000 0233         case 5:
; 0000 0234                 if(kkk < 2)
; 0000 0235                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 0236                 else
; 0000 0237                     {
; 0000 0238                     kkk = 0;
; 0000 0239                     pozycja_wiezy = 6;
; 0000 023A                     }
; 0000 023B 
; 0000 023C         break;
; 0000 023D 
; 0000 023E         case 6:
; 0000 023F                 if(kkk < 2)
; 0000 0240                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 0241                 else
; 0000 0242                     {
; 0000 0243                     kkk = 0;
; 0000 0244                     pozycja_wiezy = 7;
; 0000 0245                     }
; 0000 0246 
; 0000 0247         break;
; 0000 0248 
; 0000 0249         case 7:
; 0000 024A                 if(kkk < 2)
; 0000 024B                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 024C                 else
; 0000 024D                     {
; 0000 024E                     kkk = 0;
; 0000 024F                     pozycja_wiezy = 8;
; 0000 0250                     }
; 0000 0251 
; 0000 0252         break;
; 0000 0253 
; 0000 0254 
; 0000 0255 
; 0000 0256         case 8:
; 0000 0257                 if(kkk < wielkosc_przesuniecia_kamien)
; 0000 0258                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 0259                 else
; 0000 025A                     {
; 0000 025B                     pozycja_wiezy = 10;//9
; 0000 025C                     ulamki_sekund_1 = 0;
; 0000 025D                     v1 = v1 + 6;
; 0000 025E                     kkk = 0;
; 0000 025F                     kkk1 = 0;
; 0000 0260                     }
; 0000 0261 
; 0000 0262         break;
; 0000 0263 
; 0000 0264         case 9:
; 0000 0265 
; 0000 0266 
; 0000 0267                   if(kkk == kkk1)
; 0000 0268                         kkk1 = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 0269                   else
; 0000 026A                         {
; 0000 026B                         if(ulamki_sekund_1 > 60 * 6 * 2)
; 0000 026C                             {
; 0000 026D                             v1++;
; 0000 026E                             ulamki_sekund_1 = 0;
; 0000 026F                             }
; 0000 0270                         kkk1 = kkk;
; 0000 0271                         }
; 0000 0272                   if(v1 == 40)
; 0000 0273                         {
; 0000 0274                         kkk = 0;
; 0000 0275                         pozycja_wiezy = 10;
; 0000 0276                         }
; 0000 0277 
; 0000 0278         break;
; 0000 0279 
; 0000 027A         case 10:
; 0000 027B 
; 0000 027C                 PORTE.7 = 0;  //koniec enable
; 0000 027D                 PORTC.1 = 0;  //silownik dociskowy os pozioma
; 0000 027E                 kkk = 0;
; 0000 027F                 kkk1 = 0;
; 0000 0280                 v1 = 60;
; 0000 0281                 bufor_bledu = 0;
; 0000 0282                 if(PORTE.4 == 1)
; 0000 0283                     PORTE.4 = 0;  //zmieniamy dir
; 0000 0284                 else
; 0000 0285                     PORTE.4 = 1;
; 0000 0286 
; 0000 0287                 pozycja_wiezy = 11;
; 0000 0288                 jedz_wieza_cykl_znacznik = 0;
; 0000 0289 
; 0000 028A 
; 0000 028B         break;
; 0000 028C         }
; 0000 028D 
; 0000 028E 
; 0000 028F 
; 0000 0290 
; 0000 0291 
; 0000 0292 
; 0000 0293 
; 0000 0294 }
;
;
;
;
;
;
;
;int proces_0()
; 0000 029D {
_proces_0:
; 0000 029E int wynik;
; 0000 029F wynik = 0;
	CALL SUBOPT_0xE
;	wynik -> R16,R17
; 0000 02A0 
; 0000 02A1 switch(proces[0])
	LDS  R30,_proces
	LDS  R31,_proces+1
; 0000 02A2     {
; 0000 02A3     case 0:
	SBIW R30,0
	BRNE _0x97
; 0000 02A4         if(test_zjezdzalni_nakretek == 0)
	LDS  R30,_test_zjezdzalni_nakretek
	LDS  R31,_test_zjezdzalni_nakretek+1
	SBIW R30,0
	BRNE _0x98
; 0000 02A5             proces[0] = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x330
; 0000 02A6         else
_0x98:
; 0000 02A7             proces[0] = 111;
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
_0x330:
	STS  _proces,R30
	STS  _proces+1,R31
; 0000 02A8         sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02A9     break;
	RJMP _0x96
; 0000 02AA 
; 0000 02AB 
; 0000 02AC     case 111:
_0x97:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x9A
; 0000 02AD             if(PINA.7 == 1)
	SBIS 0x19,7
	RJMP _0x9B
; 0000 02AE                 {
; 0000 02AF                 ilosc_prob_wybicia_zakretki_do_gory = 0;
	CALL SUBOPT_0x10
; 0000 02B0                 PORTD.5 = 1;  //silownik kolejkujacy nakretki otworz
; 0000 02B1                 PORTB.3 = 1;  //psikanie
	SBI  0x18,3
; 0000 02B2                 PORTB.5 = 1;  //wibrator nowy
	SBI  0x18,5
; 0000 02B3                 PORTD.4 = 1;  //zeby na pewno byl wysuniety wstepnie ten co robi drgania
	SBI  0x12,4
; 0000 02B4                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02B5                 proces[0] = 2;
	CALL SUBOPT_0x11
; 0000 02B6                 }
; 0000 02B7     break;
_0x9B:
	RJMP _0x96
; 0000 02B8 
; 0000 02B9     case 1:                          //zeby wrocila karetka nakretek sek0 > 40
_0x9A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xA4
; 0000 02BA 
; 0000 02BB             //if(podaj_nakretke == 1)
; 0000 02BC             //    PORTB.5 = 1;  //wibrator nowy
; 0000 02BD 
; 0000 02BE             if(podaj_nakretke == 1 & sek0 > 40)
	LDS  R26,_podaj_nakretke
	LDS  R27,_podaj_nakretke+1
	CALL SUBOPT_0xD
	MOV  R0,R30
	CALL SUBOPT_0x12
	__GETD1N 0x28
	CALL __GTD12
	AND  R30,R0
	BREQ _0xA5
; 0000 02BF                 {
; 0000 02C0                 ilosc_prob_wybicia_zakretki_do_gory = 0;
	CALL SUBOPT_0x10
; 0000 02C1                 PORTD.5 = 1;  //silownik kolejkujacy nakretki otworz
; 0000 02C2                 PORTB.5 = 1;  //wibrator nowy
	SBI  0x18,5
; 0000 02C3                 PORTB.3 = 1;  //psikanie
	SBI  0x18,3
; 0000 02C4                 PORTD.4 = 1;  //zeby na pewno byl wysuniety wstepnie ten co robi drgania
	SBI  0x12,4
; 0000 02C5                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02C6                 proces[0] = 2;
	CALL SUBOPT_0x11
; 0000 02C7                 }
; 0000 02C8     break;
_0xA5:
	RJMP _0x96
; 0000 02C9 
; 0000 02CA 
; 0000 02CB     case 2:
_0xA4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xAE
; 0000 02CC                 if(sek0>15)
	CALL SUBOPT_0x12
	__CPD2N 0x10
	BRLT _0xAF
; 0000 02CD                     {
; 0000 02CE                     sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02CF                     proces[0] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x13
; 0000 02D0                     }
; 0000 02D1     break;
_0xAF:
	RJMP _0x96
; 0000 02D2 
; 0000 02D3     case 3:
_0xAE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB0
; 0000 02D4             drgania();
	CALL SUBOPT_0x14
; 0000 02D5 
; 0000 02D6             if(sek0 > 5 & PORTB.3 == 1)
	CALL SUBOPT_0xA
	LDI  R26,0
	SBIC 0x18,3
	LDI  R26,1
	CALL SUBOPT_0xB
	BREQ _0xB1
; 0000 02D7                  PORTB.3 = 0; //psikanie
	CBI  0x18,3
; 0000 02D8 
; 0000 02D9             if(sek0 > 20)  //silownik kolejkujacy nakretki w dol  //35
_0xB1:
	CALL SUBOPT_0x15
	BRLT _0xB4
; 0000 02DA                 {
; 0000 02DB                 PORTB.5 = 0;  //wibrator nowy
	CBI  0x18,5
; 0000 02DC                 PORTD.5 = 0;  //zamknij
	CBI  0x12,5
; 0000 02DD                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02DE                 proces[0] = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x13
; 0000 02DF                 }
; 0000 02E0     break;
_0xB4:
	RJMP _0x96
; 0000 02E1 
; 0000 02E2 
; 0000 02E3     case 4:
_0xB0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB9
; 0000 02E4 
; 0000 02E5             if(PINA.4 == 0)
	SBIC 0x19,4
	RJMP _0xBA
; 0000 02E6                 wystarczy_zejscia = 1;
	CALL SUBOPT_0x16
; 0000 02E7             drgania();
_0xBA:
	CALL SUBOPT_0x14
; 0000 02E8             if(sek0 > 25)
	__CPD2N 0x1A
	BRLT _0xBB
; 0000 02E9                 {
; 0000 02EA                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 02EB                 proces[0] = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x13
; 0000 02EC                 if(PINA.4 == 0)
	SBIC 0x19,4
	RJMP _0xBC
; 0000 02ED                     wystarczy_zejscia = 1;
	CALL SUBOPT_0x16
; 0000 02EE                 }
_0xBC:
; 0000 02EF 
; 0000 02F0     break;
_0xBB:
	RJMP _0x96
; 0000 02F1 
; 0000 02F2 
; 0000 02F3     case 5:
_0xB9:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xBD
; 0000 02F4             if(PINA.4 == 0 | wystarczy_zejscia == 1)   //zszedl na sam dol, czyli ok
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CALL SUBOPT_0xC
	LDS  R26,_wystarczy_zejscia
	LDS  R27,_wystarczy_zejscia+1
	CALL SUBOPT_0xD
	OR   R30,R0
	BREQ _0xBE
; 0000 02F5                 {
; 0000 02F6                 //proces[0] = 8;
; 0000 02F7                 //PORTD.2 = 0; //przysun igle z klejem nie dawaj igly z klejem
; 0000 02F8                 PORTD.4 = 0;  //zeby na pewno byl schowany ten co robi drgania
	CBI  0x12,4
; 0000 02F9                 wystarczy_zejscia = 0;
	CALL SUBOPT_0x17
; 0000 02FA                 proces[0] = 10;
	CALL SUBOPT_0x18
; 0000 02FB                 sek0 = 50;
	__GETD1N 0x32
	CALL SUBOPT_0x19
; 0000 02FC                 }
; 0000 02FD             else
	RJMP _0xC1
_0xBE:
; 0000 02FE                 {
; 0000 02FF                 wystarczy_zejscia = 0;
	CALL SUBOPT_0x17
; 0000 0300                 ilosc_prob_wybicia_zakretki_do_gory++;
	LDI  R26,LOW(_ilosc_prob_wybicia_zakretki_do_gory)
	LDI  R27,HIGH(_ilosc_prob_wybicia_zakretki_do_gory)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0301                 if(ilosc_prob_wybicia_zakretki_do_gory > 3)
	LDS  R26,_ilosc_prob_wybicia_zakretki_do_gory
	LDS  R27,_ilosc_prob_wybicia_zakretki_do_gory+1
	SBIW R26,4
	BRLT _0xC2
; 0000 0302                     {
; 0000 0303                     proces[0] = 10;
	CALL SUBOPT_0x18
; 0000 0304                     ilosc_prob_wybicia_zakretki_do_gory = 0;
	LDI  R30,LOW(0)
	STS  _ilosc_prob_wybicia_zakretki_do_gory,R30
	STS  _ilosc_prob_wybicia_zakretki_do_gory+1,R30
; 0000 0305                     PORTD.4 = 0;  //zeby na pewno byl schowany ten co robi drgania
	CBI  0x12,4
; 0000 0306                     }
; 0000 0307                 else
	RJMP _0xC5
_0xC2:
; 0000 0308                     {
; 0000 0309                     PORTD.5 = 1;  //do gory silownik otworz
	SBI  0x12,5
; 0000 030A                     PORTB.3 = 1;   //psikanie
	SBI  0x18,3
; 0000 030B                     PORTB.5 = 1;  //wibrator nowy
	SBI  0x18,5
; 0000 030C                     proces[0] = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x13
; 0000 030D                     }
_0xC5:
; 0000 030E                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 030F                 }
_0xC1:
; 0000 0310 
; 0000 0311     break;
	RJMP _0x96
; 0000 0312 
; 0000 0313     case 6:
_0xBD:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0314             drgania();
	CALL SUBOPT_0x14
; 0000 0315 
; 0000 0316             if(sek0 > 130 & PORTB.3 == 1)
	__GETD1N 0x82
	CALL __GTD12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x18,3
	LDI  R26,1
	CALL SUBOPT_0xB
	BREQ _0xCD
; 0000 0317                  {
; 0000 0318                  PORTB.3 = 0; //psikanie
	CBI  0x18,3
; 0000 0319                  PORTB.5 = 0;  //wibrator nowy
	CBI  0x18,5
; 0000 031A                  }
; 0000 031B             if(sek0 > 150)  //czekaj na pukniecie
_0xCD:
	CALL SUBOPT_0x12
	__CPD2N 0x97
	BRLT _0xD2
; 0000 031C                {
; 0000 031D                PORTD.5 = 0;  //na dol
	CBI  0x12,5
; 0000 031E                sek0 = 0;
	CALL SUBOPT_0xF
; 0000 031F                proces[0] = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x13
; 0000 0320                }
; 0000 0321     break;
_0xD2:
	RJMP _0x96
; 0000 0322 
; 0000 0323     case 7:
_0xCC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0324             drgania();
	RCALL _drgania
; 0000 0325             if(PINA.4 == 0)
	SBIC 0x19,4
	RJMP _0xD6
; 0000 0326                 wystarczy_zejscia = 1;
	CALL SUBOPT_0x16
; 0000 0327             if(sek0 > 80)
_0xD6:
	CALL SUBOPT_0x12
	__CPD2N 0x51
	BRLT _0xD7
; 0000 0328                {
; 0000 0329                proces[0] = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x13
; 0000 032A                }
; 0000 032B     break;
_0xD7:
	RJMP _0x96
; 0000 032C 
; 0000 032D     case 8:
_0xD5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xD8
; 0000 032E             if(sek0 > 20)
	CALL SUBOPT_0x15
	BRLT _0xD9
; 0000 032F                 {
; 0000 0330                 //PORTB.7 = 1; //nie lej kleju na razie
; 0000 0331                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 0332                 proces[0] = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x13
; 0000 0333                 }
; 0000 0334 
; 0000 0335     break;
_0xD9:
	RJMP _0x96
; 0000 0336 
; 0000 0337     case 9:
_0xD8:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xDA
; 0000 0338             if(sek0 > 50)
	CALL SUBOPT_0x1A
	BRLT _0xDB
; 0000 0339                 {
; 0000 033A                 PORTB.7 = 0;//przestan lac klej
	CBI  0x18,7
; 0000 033B                 PORTD.2 = 1; //cofnij igle z klejem
	SBI  0x12,2
; 0000 033C                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 033D                 proces[0] = 10;
	CALL SUBOPT_0x18
; 0000 033E                 }
; 0000 033F 
; 0000 0340     break;
_0xDB:
	RJMP _0x96
; 0000 0341 
; 0000 0342 
; 0000 0343 
; 0000 0344     case 10:
_0xDA:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xE0
; 0000 0345             if(sek0 > 50)
	CALL SUBOPT_0x1A
	BRLT _0xE1
; 0000 0346                 {
; 0000 0347                 PORTD.6 = 1; //silownik podaje nakretke monterowi
	SBI  0x12,6
; 0000 0348                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 0349                  if(test_zjezdzalni_nakretek == 0)
	LDS  R30,_test_zjezdzalni_nakretek
	LDS  R31,_test_zjezdzalni_nakretek+1
	SBIW R30,0
	BRNE _0xE4
; 0000 034A                     proces[0] = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RJMP _0x331
; 0000 034B                  else
_0xE4:
; 0000 034C                     proces[0] = 1111;
	LDI  R30,LOW(1111)
	LDI  R31,HIGH(1111)
_0x331:
	STS  _proces,R30
	STS  _proces+1,R31
; 0000 034D                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 034E                 }
; 0000 034F 
; 0000 0350     break;
_0xE1:
	RJMP _0x96
; 0000 0351     case 11:
_0xE0:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0352             if(sek0 > 50)
	CALL SUBOPT_0x1A
	BRLT _0xE7
; 0000 0353                 {
; 0000 0354                 kontrola_czujnika_dolnego_nakretek();
	RCALL _kontrola_czujnika_dolnego_nakretek
; 0000 0355 
; 0000 0356                 if(wcisnalem_pedal == 1)
	LDS  R26,_wcisnalem_pedal
	LDS  R27,_wcisnalem_pedal+1
	SBIW R26,1
	BRNE _0xE8
; 0000 0357                    {
; 0000 0358                    PORTD.6 = 0;  //cofnij podajnik nakretek
	CBI  0x12,6
; 0000 0359                    //PORTB.5 = 1;  //wibrator
; 0000 035A                    sek0 = 0;
	CALL SUBOPT_0xF
; 0000 035B                    proces[0] = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x13
; 0000 035C                    }
; 0000 035D                 else
	RJMP _0xEB
_0xE8:
; 0000 035E                    sek0 = 51;
	__GETD1N 0x33
	CALL SUBOPT_0x19
; 0000 035F 
; 0000 0360                 }
_0xEB:
; 0000 0361     break;
_0xE7:
	RJMP _0x96
; 0000 0362     case 1111:
_0xE6:
	CPI  R30,LOW(0x457)
	LDI  R26,HIGH(0x457)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0363             if(sek0 > 50)
	CALL SUBOPT_0x1A
	BRLT _0xED
; 0000 0364                 {
; 0000 0365                 if(PINA.7 == 1)
	SBIS 0x19,7
	RJMP _0xEE
; 0000 0366                    {
; 0000 0367                    PORTD.5 = 0;   //zamknij przegrode nakretek
	CBI  0x12,5
; 0000 0368                    PORTD.6 = 0;  //cofnij podajnik nakretek
	CBI  0x12,6
; 0000 0369                    //PORTB.5 = 1;  //wibrator
; 0000 036A                    sek0 = 0;
	CALL SUBOPT_0xF
; 0000 036B                    }
; 0000 036C                 }
_0xEE:
; 0000 036D             kontrola_czujnika_dolnego_nakretek();
_0xED:
	RCALL _kontrola_czujnika_dolnego_nakretek
; 0000 036E             if(PORTD.6 == 0 & sek0 > 50 & PORTD.5 == 0)
	LDI  R26,0
	SBIC 0x12,6
	LDI  R26,1
	CALL SUBOPT_0xC
	CALL SUBOPT_0x12
	__GETD1N 0x32
	CALL __GTD12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x12,5
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0xF3
; 0000 036F                     {
; 0000 0370                     proces[0] = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x13
; 0000 0371                     }
; 0000 0372 
; 0000 0373     break;
_0xF3:
	RJMP _0x96
; 0000 0374 
; 0000 0375 
; 0000 0376 
; 0000 0377 
; 0000 0378 
; 0000 0379 
; 0000 037A 
; 0000 037B     case 12:
_0xEC:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xF4
; 0000 037C             if(sek0 > 1)
	CALL SUBOPT_0x12
	CALL SUBOPT_0x1B
	BRLT _0xF5
; 0000 037D                proces[0] = 13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CALL SUBOPT_0x13
; 0000 037E     break;
_0xF5:
	RJMP _0x96
; 0000 037F 
; 0000 0380     case 13:
_0xF4:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x96
; 0000 0381 
; 0000 0382                 sek0 = 0;
	CALL SUBOPT_0xF
; 0000 0383                 proces[0] = 0;
	LDI  R30,LOW(0)
	STS  _proces,R30
	STS  _proces+1,R30
; 0000 0384                 wynik = 1;
	__GETWRN 16,17,1
; 0000 0385                 podaj_nakretke = 0;
	CALL SUBOPT_0x1C
; 0000 0386                 wcisnalem_pedal = 0;
; 0000 0387 
; 0000 0388     break;
; 0000 0389     }
_0x96:
; 0000 038A 
; 0000 038B 
; 0000 038C 
; 0000 038D 
; 0000 038E return wynik;
	RJMP _0x20A0001
; 0000 038F }
;
;
;int proces_1()
; 0000 0393 {
_proces_1:
; 0000 0394 int wynik;
; 0000 0395 wynik = 0;
	CALL SUBOPT_0xE
;	wynik -> R16,R17
; 0000 0396 
; 0000 0397 switch(proces[1])
	__GETW1MN _proces,2
; 0000 0398     {
; 0000 0399     case 0:
	SBIW R30,0
	BRNE _0xFA
; 0000 039A         if(podaj_nakretke == 1)
	LDS  R26,_podaj_nakretke
	LDS  R27,_podaj_nakretke+1
	SBIW R26,1
	BRNE _0xFB
; 0000 039B             proces[1] = 1;
	__POINTW1MN _proces,2
	CALL SUBOPT_0x1D
; 0000 039C     break;
_0xFB:
	RJMP _0xF9
; 0000 039D 
; 0000 039E     case 1:
_0xFA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xFC
; 0000 039F             if(PINA.2 == 0 & wcisniete_zakonczone == 2) //widzi kamien
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CALL SUBOPT_0xC
	LDS  R26,_wcisniete_zakonczone
	LDS  R27,_wcisniete_zakonczone+1
	CALL SUBOPT_0x1E
	AND  R30,R0
	BREQ _0xFD
; 0000 03A0             {
; 0000 03A1             sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03A2             proces[1] = 2;
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03A3             }
; 0000 03A4     break;
_0xFD:
	RJMP _0xF9
; 0000 03A5 
; 0000 03A6     case 2:
_0xFC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xFE
; 0000 03A7             if(PINA.2 == 1 & zezwolenie_od_master == 1) //przejechal kamien na pewno
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	AND  R30,R0
	BREQ _0xFF
; 0000 03A8             {
; 0000 03A9             sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03AA             proces[1] = 3;
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03AB 
; 0000 03AC             }
; 0000 03AD     break;
_0xFF:
	RJMP _0xF9
; 0000 03AE 
; 0000 03AF     case 3:
_0xFE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x100
; 0000 03B0 
; 0000 03B1            sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03B2            proces[1] = 4;
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03B3 
; 0000 03B4     break;
	RJMP _0xF9
; 0000 03B5 
; 0000 03B6     case 4:
_0x100:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x101
; 0000 03B7             if(sek1 > 0) ////////////////////////dam tu wiecej 20, 28.11.2017
	CALL SUBOPT_0x22
	CALL __CPD02
	BRGE _0x102
; 0000 03B8                 {
; 0000 03B9                 PORTD.7 = 1;
	SBI  0x12,7
; 0000 03BA                 sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03BB                 proces[1] = 5;
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03BC                 }
; 0000 03BD 
; 0000 03BE     break;
_0x102:
	RJMP _0xF9
; 0000 03BF 
; 0000 03C0     case 5:
_0x101:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x105
; 0000 03C1             if(sek1 > 100)
	CALL SUBOPT_0x22
	__CPD2N 0x65
	BRLT _0x106
; 0000 03C2                 {
; 0000 03C3                 if(PINA.7 == 1 & proces[0] == 11) //monter nacisnal pedal
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	CALL SUBOPT_0x20
	LDS  R26,_proces
	LDS  R27,_proces+1
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x107
; 0000 03C4                     {
; 0000 03C5                     PORTD.3 = 1;  //zluzuj chwyt grzybka
	SBI  0x12,3
; 0000 03C6                     PORTD.7 = 0; //pusc kamien
	CBI  0x12,7
; 0000 03C7                     wcisnalem_pedal = 1;
	CALL SUBOPT_0x23
; 0000 03C8                     sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03C9                     proces[1] = 6;
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03CA                     }
; 0000 03CB                 else
	RJMP _0x10C
_0x107:
; 0000 03CC                     sek1 = 101;
	__GETD1N 0x65
	STS  _sek1,R30
	STS  _sek1+1,R31
	STS  _sek1+2,R22
	STS  _sek1+3,R23
; 0000 03CD                 }
_0x10C:
; 0000 03CE 
; 0000 03CF     break;
_0x106:
	RJMP _0xF9
; 0000 03D0 
; 0000 03D1 
; 0000 03D2 //teraz jest dane ze natychmiast ruszy, moge dac alternatywe ze po chwili zmieniajac case 5 i case 6
; 0000 03D3 
; 0000 03D4 
; 0000 03D5     case 6:
_0x105:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x10D
; 0000 03D6             if(sek1 > 1)      //50 31.07.2017
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	BRLT _0x10E
; 0000 03D7                 {
; 0000 03D8                 sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03D9                 proces[1] = 7;
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03DA                 }
; 0000 03DB 
; 0000 03DC     break;
_0x10E:
	RJMP _0xF9
; 0000 03DD 
; 0000 03DE 
; 0000 03DF 
; 0000 03E0     case 7:
_0x10D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x10F
; 0000 03E1             if(sek1 > 30) //20 31.07.2017
	CALL SUBOPT_0x22
	__CPD2N 0x1F
	BRLT _0x110
; 0000 03E2                {
; 0000 03E3                PORTD.3 = 0;  //zacisnij z powrotem szczeki
	CBI  0x12,3
; 0000 03E4                proces[1] = 8;
	__POINTW1MN _proces,2
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 03E5                }
; 0000 03E6     break;
_0x110:
	RJMP _0xF9
; 0000 03E7 
; 0000 03E8     case 8:
_0x10F:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xF9
; 0000 03E9 
; 0000 03EA                 sek1 = 0;
	CALL SUBOPT_0x1F
; 0000 03EB                 proces[1] = 0;
	CALL SUBOPT_0x24
; 0000 03EC                 wynik = 1;
	__GETWRN 16,17,1
; 0000 03ED 
; 0000 03EE 
; 0000 03EF     break;
; 0000 03F0     }
_0xF9:
; 0000 03F1 
; 0000 03F2 
; 0000 03F3 
; 0000 03F4 
; 0000 03F5 return wynik;
	RJMP _0x20A0001
; 0000 03F6 }
;
;
;
;int proces_3()
; 0000 03FB {
_proces_3:
; 0000 03FC int wynik;
; 0000 03FD wynik = 0;
	CALL SUBOPT_0xE
;	wynik -> R16,R17
; 0000 03FE 
; 0000 03FF switch(proces[3])
	__GETW1MN _proces,6
; 0000 0400     {                 //ZMIENIAM PINE.2 NA PINE.6
; 0000 0401     case 0: //pedal monter 2   //
	SBIW R30,0
	BRNE _0x117
; 0000 0402         if(PINE.6 == 1 & zezwolenie_od_master == 1)
	LDI  R26,0
	SBIC 0x1,6
	LDI  R26,1
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	AND  R30,R0
	BREQ _0x118
; 0000 0403             {
; 0000 0404             PORTC.5 = 1;     //wysun silownik otwierajacy wieze
	SBI  0x15,5
; 0000 0405             PORTC.6 = 0;     //wysun silownik otwierajacy wieze
	CBI  0x15,6
; 0000 0406             if(wieza == 0)
	CALL SUBOPT_0x25
	BRNE _0x11D
; 0000 0407                 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
	CBI  0x15,2
; 0000 0408             else
	RJMP _0x120
_0x11D:
; 0000 0409                 {
; 0000 040A                 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
	SBI  0x15,3
; 0000 040B                 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
	CBI  0x15,7
; 0000 040C                 }
_0x120:
; 0000 040D             sek3 = 0;
	CALL SUBOPT_0x26
; 0000 040E             proces[3] = 1;
	CALL SUBOPT_0x1D
; 0000 040F             }
; 0000 0410     break;
_0x118:
	RJMP _0x116
; 0000 0411 
; 0000 0412     case 1:
_0x117:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x125
; 0000 0413 
; 0000 0414             if(sek3 > 20)
	CALL SUBOPT_0x27
	__CPD2N 0x15
	BRLT _0x126
; 0000 0415                 {
; 0000 0416                 wcisniete_zakonczone = 1;
	CALL SUBOPT_0x28
; 0000 0417                 PORTC.5 = 0;  //schowaj silownik otwierajacy wieze
	CBI  0x15,5
; 0000 0418                 PORTC.6 = 1;
	SBI  0x15,6
; 0000 0419                 sek3 = 0;
	CALL SUBOPT_0x26
; 0000 041A                 proces[3] = 2;
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 041B                 }
; 0000 041C 
; 0000 041D     break;
_0x126:
	RJMP _0x116
; 0000 041E 
; 0000 041F     case 2:
_0x125:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0420             if(PINE.6 == 0)//ZMIENIAM PINE.2 NA PINE.6
	SBIC 0x1,6
	RJMP _0x12C
; 0000 0421             {
; 0000 0422             if(wieza == 0)
	CALL SUBOPT_0x25
	BRNE _0x12D
; 0000 0423                 {
; 0000 0424                 PORTC.2 = 1;  //stan zamkniecia wieza 1
	SBI  0x15,2
; 0000 0425                 //wieza = 1;
; 0000 0426                 }
; 0000 0427             else
	RJMP _0x130
_0x12D:
; 0000 0428                 {
; 0000 0429                 PORTC.3 = 0;  //stan zamkniecia wejsciowy wie¿a 2
	CBI  0x15,3
; 0000 042A                 PORTC.7 = 1;  //stan zamkniecia wejsciowy wie¿a 2
	SBI  0x15,7
; 0000 042B                 //wieza = 0;
; 0000 042C                 }
_0x130:
; 0000 042D             sek3 = 0;
	CALL SUBOPT_0x26
; 0000 042E             proces[3] = 3;
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 042F             }
; 0000 0430     break;
_0x12C:
	RJMP _0x116
; 0000 0431 
; 0000 0432     case 3:
_0x12B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x135
; 0000 0433             if(sek3 > 2)
	CALL SUBOPT_0x27
	__CPD2N 0x3
	BRLT _0x136
; 0000 0434             {
; 0000 0435             sek3 = 0;
	CALL SUBOPT_0x26
; 0000 0436             proces[3] = 4;
	LDI  R26,LOW(4)
	LDI  R27,HIGH(4)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0437             }
; 0000 0438     break;
_0x136:
	RJMP _0x116
; 0000 0439 
; 0000 043A     case 4:
_0x135:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x137
; 0000 043B             if(PINE.6 == 1)  //ZMIENIAM PIN.2 NA E.6
	SBIS 0x1,6
	RJMP _0x138
; 0000 043C             {
; 0000 043D             sek3 = 0;
	CALL SUBOPT_0x26
; 0000 043E             proces[3] = 5;
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 043F             }
; 0000 0440     break;
_0x138:
	RJMP _0x116
; 0000 0441 
; 0000 0442 
; 0000 0443     case 5:
_0x137:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x139
; 0000 0444                //pozycja_wiezy != 11
; 0000 0445             if(male_puchary_pozwolenie_wyjecia_puchara_monter_3 == 0)
	LDS  R30,_male_puchary_pozwolenie_wyjecia_puchara_monter_3
	LDS  R31,_male_puchary_pozwolenie_wyjecia_puchara_monter_3+1
	SBIW R30,0
	BRNE _0x13A
; 0000 0446             {
; 0000 0447 
; 0000 0448                 //jedz_wieza_cykl();
; 0000 0449                 if(wieza == 0)
	CALL SUBOPT_0x25
	BRNE _0x13B
; 0000 044A                     wieza = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wieza,R30
	STS  _wieza+1,R31
; 0000 044B                 else
	RJMP _0x13C
_0x13B:
; 0000 044C                     wieza = 0;
	LDI  R30,LOW(0)
	STS  _wieza,R30
	STS  _wieza+1,R30
; 0000 044D                 jedz_wieza_cykl_znacznik = 1;
_0x13C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jedz_wieza_cykl_znacznik,R30
	STS  _jedz_wieza_cykl_znacznik+1,R31
; 0000 044E                 male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 1;
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3,R30
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3+1,R31
; 0000 044F                 proces[3] = 6;
	__POINTW1MN _proces,6
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0450             }
; 0000 0451             //else
; 0000 0452             //{
; 0000 0453             //sek3 = 0;
; 0000 0454             //proces[3] = 0;
; 0000 0455             //pozycja_wiezy = 0;
; 0000 0456             //male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 1;
; 0000 0457             //wynik = 1;
; 0000 0458             //}
; 0000 0459     break;
_0x13A:
	RJMP _0x116
; 0000 045A 
; 0000 045B     case 6:
_0x139:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x116
; 0000 045C 
; 0000 045D              if(PINE.6 == 0)  //zmieniam PINE.2 na PINE.6
	SBIC 0x1,6
	RJMP _0x13E
; 0000 045E              {
; 0000 045F              skonczony_proces[3] = 0;
	__POINTW1MN _skonczony_proces,6
	CALL SUBOPT_0x24
; 0000 0460              sek3 = 0;
	CALL SUBOPT_0x26
; 0000 0461              proces[3] = 0;
	CALL SUBOPT_0x24
; 0000 0462              pozycja_wiezy = 0;
	LDI  R30,LOW(0)
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R30
; 0000 0463              wynik = 0;
	__GETWRN 16,17,0
; 0000 0464              }
; 0000 0465     break;
_0x13E:
; 0000 0466 
; 0000 0467 
; 0000 0468 
; 0000 0469 
; 0000 046A 
; 0000 046B 
; 0000 046C }
_0x116:
; 0000 046D 
; 0000 046E 
; 0000 046F 
; 0000 0470 
; 0000 0471 return wynik;
	RJMP _0x20A0001
; 0000 0472 }
;
;
;int proces_4()
; 0000 0476 {
_proces_4:
; 0000 0477 int wynik;
; 0000 0478 wynik = 0;
	CALL SUBOPT_0xE
;	wynik -> R16,R17
; 0000 0479 
; 0000 047A switch(proces[4])
	__GETW1MN _proces,8
; 0000 047B     {
; 0000 047C 
; 0000 047D    case 0:     //monter 3 nacisnal pedal
	SBIW R30,0
	BRNE _0x142
; 0000 047E             if(PINA.7 == 1 & male_puchary_pozwolenie_wyjecia_puchara_monter_3 == 1)
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	CALL SUBOPT_0x20
	LDS  R26,_male_puchary_pozwolenie_wyjecia_puchara_monter_3
	LDS  R27,_male_puchary_pozwolenie_wyjecia_puchara_monter_3+1
	CALL SUBOPT_0xD
	AND  R30,R0
	BREQ _0x143
; 0000 047F             {
; 0000 0480              if(PORTC.0 == 0) //silownik obrotowy o osi pionowej //monter wyciaga puchar
	SBIC 0x15,0
	RJMP _0x144
; 0000 0481                 PORTC.0 = 1;
	SBI  0x15,0
; 0000 0482              else
	RJMP _0x147
_0x144:
; 0000 0483                 PORTC.0 = 0;
	CBI  0x15,0
; 0000 0484             PORTC.1 = 1;  //silownik dociskowy os pozioma
_0x147:
	SBI  0x15,1
; 0000 0485 
; 0000 0486             if(wieza == 1)
	LDS  R26,_wieza
	LDS  R27,_wieza+1
	SBIW R26,1
	BRNE _0x14C
; 0000 0487                 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
	CBI  0x15,2
; 0000 0488             else
	RJMP _0x14F
_0x14C:
; 0000 0489                 {
; 0000 048A                 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
	SBI  0x15,3
; 0000 048B                 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
	CBI  0x15,7
; 0000 048C                 }
_0x14F:
; 0000 048D 
; 0000 048E             sek4 = 0;
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
; 0000 048F             proces[4] = 1;
	__POINTW1MN _proces,8
	CALL SUBOPT_0x1D
; 0000 0490             }
; 0000 0491 
; 0000 0492     break;
_0x143:
	RJMP _0x141
; 0000 0493 
; 0000 0494     case 1:
_0x142:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x141
; 0000 0495           if(sek4 > 60)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	__CPD2N 0x3D
	BRLT _0x155
; 0000 0496             {
; 0000 0497             male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 0;
	LDI  R30,LOW(0)
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3,R30
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3+1,R30
; 0000 0498             wcisnalem_pedal = 1;
	CALL SUBOPT_0x23
; 0000 0499             proces[4] = 0;
	__POINTW1MN _proces,8
	CALL SUBOPT_0x24
; 0000 049A             wynik = 1;
	__GETWRN 16,17,1
; 0000 049B             }
; 0000 049C     break;
_0x155:
; 0000 049D 
; 0000 049E 
; 0000 049F     }
_0x141:
; 0000 04A0 
; 0000 04A1 
; 0000 04A2 
; 0000 04A3 
; 0000 04A4 return wynik;
_0x20A0001:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 04A5 }
;
;
;
;
;
;
;
;void procesy()
; 0000 04AE {
_procesy:
; 0000 04AF if(skonczony_proces[0] == 0)
	LDS  R30,_skonczony_proces
	LDS  R31,_skonczony_proces+1
	SBIW R30,0
	BRNE _0x156
; 0000 04B0   skonczony_proces[0] = proces_0();
	CALL SUBOPT_0x29
; 0000 04B1 
; 0000 04B2 if(skonczony_proces[1] == 0 & tryb_male_puchary == 3)
_0x156:
	__GETW1MN _skonczony_proces,2
	CALL SUBOPT_0x2A
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x157
; 0000 04B3   skonczony_proces[1] = proces_1();
	RCALL _proces_1
	__PUTW1MN _skonczony_proces,2
; 0000 04B4 
; 0000 04B5 if(skonczony_proces[3] == 0 & tryb_male_puchary == 2 & jedz_wieza_cykl_znacznik == 0)
_0x157:
	__GETW1MN _skonczony_proces,6
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1E
	AND  R0,R30
	LDS  R26,_jedz_wieza_cykl_znacznik
	LDS  R27,_jedz_wieza_cykl_znacznik+1
	CALL SUBOPT_0x2B
	AND  R30,R0
	BREQ _0x158
; 0000 04B6   skonczony_proces[3] = proces_3();
	CALL SUBOPT_0x2C
; 0000 04B7 
; 0000 04B8 if(skonczony_proces[4] == 0 & tryb_male_puchary == 2)
_0x158:
	__GETW1MN _skonczony_proces,8
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1E
	AND  R30,R0
	BREQ _0x159
; 0000 04B9   skonczony_proces[4] = proces_4();
	RCALL _proces_4
	__PUTW1MN _skonczony_proces,8
; 0000 04BA 
; 0000 04BB }
_0x159:
	RET
;
;void zerowanie_procesow()
; 0000 04BE {
_zerowanie_procesow:
; 0000 04BF if(skonczony_proces[0] == 1 & skonczony_proces[1] == 1 & test_zjezdzalni_nakretek == 0 & tryb_male_puchary == 3)
	CALL SUBOPT_0x2D
	MOV  R0,R30
	__GETW1MN _skonczony_proces,2
	CALL SUBOPT_0x2E
	AND  R0,R30
	CALL SUBOPT_0x4
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x15A
; 0000 04C0     {
; 0000 04C1     skonczony_proces[0] = 0;
	CALL SUBOPT_0x2F
; 0000 04C2     skonczony_proces[1] = 0;
; 0000 04C3     wcisniete_zakonczone = 1;
	CALL SUBOPT_0x28
; 0000 04C4     podaj_nakretke = 1;
	CALL SUBOPT_0x30
; 0000 04C5     }
; 0000 04C6 
; 0000 04C7 
; 0000 04C8 if(skonczony_proces[0] == 1 & test_zjezdzalni_nakretek == 1)
_0x15A:
	CALL SUBOPT_0x2D
	MOV  R0,R30
	LDS  R26,_test_zjezdzalni_nakretek
	LDS  R27,_test_zjezdzalni_nakretek+1
	CALL SUBOPT_0xD
	AND  R30,R0
	BREQ _0x15B
; 0000 04C9     {
; 0000 04CA     skonczony_proces[0] = 0;
	CALL SUBOPT_0x2F
; 0000 04CB     skonczony_proces[1] = 0;
; 0000 04CC     wcisniete_zakonczone = 1;
	CALL SUBOPT_0x28
; 0000 04CD     podaj_nakretke = 1;
	CALL SUBOPT_0x30
; 0000 04CE     }
; 0000 04CF 
; 0000 04D0 
; 0000 04D1                             //& skonczony_proces[3] == 1
; 0000 04D2 if(skonczony_proces[0] == 1  & skonczony_proces[4] == 1 & test_zjezdzalni_nakretek == 0 & tryb_male_puchary == 2)
_0x15B:
	CALL SUBOPT_0x2D
	MOV  R0,R30
	__GETW1MN _skonczony_proces,8
	CALL SUBOPT_0x2E
	AND  R0,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1E
	AND  R30,R0
	BREQ _0x15C
; 0000 04D3     {
; 0000 04D4     skonczony_proces[0] = 0;                  //tryb male puchary
	LDI  R30,LOW(0)
	STS  _skonczony_proces,R30
	STS  _skonczony_proces+1,R30
; 0000 04D5     //skonczony_proces[3] = 0;
; 0000 04D6     skonczony_proces[4] = 0;
	__POINTW1MN _skonczony_proces,8
	CALL SUBOPT_0x24
; 0000 04D7     podaj_nakretke = 1;
	CALL SUBOPT_0x30
; 0000 04D8     }
; 0000 04D9 
; 0000 04DA 
; 0000 04DB 
; 0000 04DC 
; 0000 04DD 
; 0000 04DE }
_0x15C:
	RET
;
;
;void wypozucjonuj_wieze_wolno()
; 0000 04E2 {
; 0000 04E3 
; 0000 04E4 PORTE.7 = 1;  //enable na silnik krok
; 0000 04E5 
; 0000 04E6 //+_+__________o ___________
; 0000 04E7 //+_+__________ o _________  //dolny - do tego pozycjonujemy
; 0000 04E8 //
; 0000 04E9 PORTE.4 = 0;
; 0000 04EA while(PINE.1 != 0)//kiedy nie widzi czujnik czujnik - jestesmy daleko
; 0000 04EB     {
; 0000 04EC     PORTE.5 = 1;
; 0000 04ED     delay_us(1000);
; 0000 04EE     PORTE.5 = 0;
; 0000 04EF     delay_us(1000);
; 0000 04F0     }
; 0000 04F1 
; 0000 04F2 //zwolnij
; 0000 04F3 PORTE.5 = 1;
; 0000 04F4 delay_us(2000);
; 0000 04F5 PORTE.5 = 0;
; 0000 04F6 delay_us(2000);
; 0000 04F7 
; 0000 04F8 PORTE.5 = 1;
; 0000 04F9 delay_us(4000);
; 0000 04FA PORTE.5 = 0;
; 0000 04FB delay_us(4000);
; 0000 04FC 
; 0000 04FD 
; 0000 04FE 
; 0000 04FF //teraz sie cofniemy
; 0000 0500 PORTE.4 = 1;  //zmieniamy dir
; 0000 0501 while(basia1 < 1000)  //musimy przejechac tak, ze na pewno miniemy czujnuk gdybysmy byli miedzy nimi, zmieniam mikrokroki wiec daje mniej, by³o 2000
; 0000 0502     {                                                         //2000 //1000  //500
; 0000 0503     PORTE.5 = 1;
; 0000 0504     delay_us(1000);
; 0000 0505     PORTE.5 = 0;
; 0000 0506     delay_us(1000);
; 0000 0507     basia1++;
; 0000 0508     }
; 0000 0509 
; 0000 050A //zwolnij
; 0000 050B PORTE.5 = 1;
; 0000 050C delay_us(4000);
; 0000 050D PORTE.5 = 0;
; 0000 050E delay_us(4000);
; 0000 050F 
; 0000 0510 PORTE.5 = 1;
; 0000 0511 delay_us(4000);
; 0000 0512 PORTE.5 = 0;
; 0000 0513 delay_us(4000);
; 0000 0514 
; 0000 0515 
; 0000 0516 PORTE.4 = 0;  //zmieniamy dir
; 0000 0517 basia1 = 0;
; 0000 0518 while(PINE.1 != 0)//i znowu do czujnika
; 0000 0519     {
; 0000 051A     PORTE.5 = 1;
; 0000 051B     delay_us(1000);
; 0000 051C     PORTE.5 = 0;
; 0000 051D     delay_us(1000);
; 0000 051E     }
; 0000 051F while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 0520     {
; 0000 0521     PORTE.5 = 1;
; 0000 0522     delay_us(1000);
; 0000 0523     PORTE.5 = 0;
; 0000 0524     delay_us(1000);
; 0000 0525     basia1++;
; 0000 0526     }
; 0000 0527 while(PINE.1 != 1)//i znowu teraz jak czujnik swieci
; 0000 0528     {
; 0000 0529     PORTE.5 = 1;
; 0000 052A     delay_us(1000);
; 0000 052B     PORTE.5 = 0;
; 0000 052C     delay_us(1000);
; 0000 052D     }
; 0000 052E basia1 = 0;
; 0000 052F while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 0530     {
; 0000 0531     PORTE.5 = 1;
; 0000 0532     delay_us(1000);
; 0000 0533     PORTE.5 = 0;
; 0000 0534     delay_us(1000);
; 0000 0535     basia1++;
; 0000 0536     }
; 0000 0537 while(PINE.1 != 0)//i znowu do czujnika
; 0000 0538     {
; 0000 0539     PORTE.5 = 1;
; 0000 053A     delay_us(1000);
; 0000 053B     PORTE.5 = 0;
; 0000 053C     delay_us(1000);
; 0000 053D     }
; 0000 053E 
; 0000 053F //zwolnij
; 0000 0540 PORTE.5 = 1;
; 0000 0541 delay_us(2000);
; 0000 0542 PORTE.5 = 0;
; 0000 0543 delay_us(2000);
; 0000 0544 
; 0000 0545 PORTE.5 = 1;
; 0000 0546 delay_us(4000);
; 0000 0547 PORTE.5 = 0;
; 0000 0548 delay_us(4000);
; 0000 0549 
; 0000 054A 
; 0000 054B 
; 0000 054C 
; 0000 054D PORTE.4 = 1;  //zmieniamy dir
; 0000 054E delay_ms(3000);
; 0000 054F PORTE.7 = 0;
; 0000 0550 }
;
;
;void wypozucjonuj_wieze_szybko()
; 0000 0554 {
; 0000 0555 PORTE.7 = 1;  //enable na silnik krok
; 0000 0556 
; 0000 0557 //+_+__________o ___________
; 0000 0558 //+_+__________ o _________  //dolny - do tego pozycjonujemy
; 0000 0559 //
; 0000 055A PORTE.4 = 0;
; 0000 055B while(PINE.1 != 0)//kiedy nie widzi czujnik czujnik - jestesmy daleko
; 0000 055C     {
; 0000 055D     PORTE.5 = 1;
; 0000 055E     delay_us(500);
; 0000 055F     PORTE.5 = 0;
; 0000 0560     delay_us(500);
; 0000 0561     }
; 0000 0562 
; 0000 0563 //zwolnij
; 0000 0564 PORTE.5 = 1;
; 0000 0565 delay_us(500);
; 0000 0566 PORTE.5 = 0;
; 0000 0567 delay_us(500);
; 0000 0568 
; 0000 0569 PORTE.5 = 1;
; 0000 056A delay_us(1000);
; 0000 056B PORTE.5 = 0;
; 0000 056C delay_us(1000);
; 0000 056D 
; 0000 056E 
; 0000 056F 
; 0000 0570 //teraz sie cofniemy
; 0000 0571 PORTE.4 = 1;  //zmieniamy dir
; 0000 0572 while(basia1 < 250)  //musimy przejechac tak, ze na pewno miniemy czujnuk gdybysmy byli miedzy nimi, zmieniam mikrokroki wiec daje mniej, by³o 2000
; 0000 0573     {                                                         //2000 //1000  //500
; 0000 0574     PORTE.5 = 1;
; 0000 0575     delay_us(500);
; 0000 0576     PORTE.5 = 0;
; 0000 0577     delay_us(500);
; 0000 0578     basia1++;
; 0000 0579     }
; 0000 057A 
; 0000 057B //zwolnij
; 0000 057C PORTE.5 = 1;
; 0000 057D delay_us(500);
; 0000 057E PORTE.5 = 0;
; 0000 057F delay_us(500);
; 0000 0580 
; 0000 0581 PORTE.5 = 1;
; 0000 0582 delay_us(1000);
; 0000 0583 PORTE.5 = 0;
; 0000 0584 delay_us(1000);
; 0000 0585 
; 0000 0586 
; 0000 0587 PORTE.4 = 0;  //zmieniamy dir
; 0000 0588 basia1 = 0;
; 0000 0589 while(PINE.1 != 0)//i znowu do czujnika
; 0000 058A     {
; 0000 058B     PORTE.5 = 1;
; 0000 058C     delay_us(500);
; 0000 058D     PORTE.5 = 0;
; 0000 058E     delay_us(500);
; 0000 058F     }
; 0000 0590 while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 0591     {
; 0000 0592     PORTE.5 = 1;
; 0000 0593     delay_us(500);
; 0000 0594     PORTE.5 = 0;
; 0000 0595     delay_us(500);
; 0000 0596     basia1++;
; 0000 0597     }
; 0000 0598 while(PINE.1 != 1)//i znowu teraz jak czujnik swieci
; 0000 0599     {
; 0000 059A     PORTE.5 = 1;
; 0000 059B     delay_us(500);
; 0000 059C     PORTE.5 = 0;
; 0000 059D     delay_us(500);
; 0000 059E     }
; 0000 059F basia1 = 0;
; 0000 05A0 while(basia1 < 10)  //kawaleczk zeby nie byc na granicy czujnuika
; 0000 05A1     {
; 0000 05A2     PORTE.5 = 1;
; 0000 05A3     delay_us(500);
; 0000 05A4     PORTE.5 = 0;
; 0000 05A5     delay_us(500);
; 0000 05A6     basia1++;
; 0000 05A7     }
; 0000 05A8 while(PINE.1 != 0)//i znowu do czujnika
; 0000 05A9     {
; 0000 05AA     PORTE.5 = 1;
; 0000 05AB     delay_us(500);
; 0000 05AC     PORTE.5 = 0;
; 0000 05AD     delay_us(500);
; 0000 05AE     }
; 0000 05AF 
; 0000 05B0 //zwolnij
; 0000 05B1 PORTE.5 = 1;
; 0000 05B2 delay_us(500);
; 0000 05B3 PORTE.5 = 0;
; 0000 05B4 delay_us(500);
; 0000 05B5 
; 0000 05B6 PORTE.5 = 1;
; 0000 05B7 delay_us(1000);
; 0000 05B8 PORTE.5 = 0;
; 0000 05B9 delay_us(1000);
; 0000 05BA 
; 0000 05BB 
; 0000 05BC 
; 0000 05BD 
; 0000 05BE PORTE.4 = 1;  //zmieniamy dir
; 0000 05BF delay_ms(3000);
; 0000 05C0 PORTE.7 = 0;
; 0000 05C1 }
;
;
;
;
;void jedz_wieza()
; 0000 05C7 {
; 0000 05C8 
; 0000 05C9 //pomysl - wyysylac w czasie drogi impulsy - to bedzie wielkosc kamienia
; 0000 05CA //pomysl - wyysylac w czasie postoju - to bedzie predkosc
; 0000 05CB //to nawet moge zrobic tu
; 0000 05CC 
; 0000 05CD //w prawo
; 0000 05CE 
; 0000 05CF 
; 0000 05D0     switch(pozycja_wiezy)
; 0000 05D1 
; 0000 05D2         {
; 0000 05D3 
; 0000 05D4         case 0:
; 0000 05D5 
; 0000 05D6 
; 0000 05D7                 PORTE.7 = 1;
; 0000 05D8                 sek2 = 0;
; 0000 05D9                 pozycja_wiezy = 1;
; 0000 05DA                 ulamki_sekund_1 = 0;
; 0000 05DB 
; 0000 05DC 
; 0000 05DD         break;
; 0000 05DE 
; 0000 05DF         case 1:
; 0000 05E0 
; 0000 05E1                 if(kkk == kkk1)
; 0000 05E2                     kkk1 = obroc_o_1_8_stopnia(v1, kkk);
; 0000 05E3                 else
; 0000 05E4                     {                    //30 ok    //60 * 16 * 2 ok na szybki zegar
; 0000 05E5                     if(ulamki_sekund_1 > 60 * 8 * 2)
; 0000 05E6                         {
; 0000 05E7                         v1--;
; 0000 05E8                         ulamki_sekund_1 = 0;
; 0000 05E9                         }
; 0000 05EA                     kkk1 = kkk;
; 0000 05EB                     }
; 0000 05EC 
; 0000 05ED                  if(v1 == speed_normal) //6 sie pieprzy po 30 min, daje 3 ale zmieniam kroki
; 0000 05EE                     {
; 0000 05EF                     kkk = 0;
; 0000 05F0                     if(PORTE.4 == 1)
; 0000 05F1                         pozycja_wiezy = 2;
; 0000 05F2                     else
; 0000 05F3                         pozycja_wiezy = 3;
; 0000 05F4                     }
; 0000 05F5 
; 0000 05F6                 if(sek2 > 170)
; 0000 05F7                     {
; 0000 05F8                     kkk = 0;
; 0000 05F9                     kkk1 = 0;
; 0000 05FA                     bufor_bledu = 25;
; 0000 05FB                     v1 = speed_normal;
; 0000 05FC                     ulamki_sekund_1 = 0;
; 0000 05FD                     if(PORTE.4 == 1)
; 0000 05FE                         pozycja_wiezy = 2;
; 0000 05FF                     else
; 0000 0600                         pozycja_wiezy = 3;
; 0000 0601                     }
; 0000 0602 
; 0000 0603 
; 0000 0604         break;
; 0000 0605 
; 0000 0606         //ustalic wielkosc przesuniecia kamien dla bez bufor bledu i z bufor bledu
; 0000 0607 
; 0000 0608         case 2:
; 0000 0609             if(PINE.0 != 0)
; 0000 060A                 obroc_o_1_8_stopnia(v1 + bufor_bledu, 0);
; 0000 060B             else
; 0000 060C                 {
; 0000 060D                 kamien = 50;
; 0000 060E                 if(kamien == 50)
; 0000 060F                     wielkosc_przesuniecia_kamien = 770+60;
; 0000 0610                 if(kamien == 55)
; 0000 0611                     wielkosc_przesuniecia_kamien = 740;
; 0000 0612                 if(kamien == 60)
; 0000 0613                     wielkosc_przesuniecia_kamien = 710;
; 0000 0614                 if(kamien == 65)
; 0000 0615                     wielkosc_przesuniecia_kamien = 680;
; 0000 0616                 if(kamien == 70)
; 0000 0617                     wielkosc_przesuniecia_kamien = 650;
; 0000 0618                 if(kamien == 75)
; 0000 0619                     wielkosc_przesuniecia_kamien = 620;
; 0000 061A 
; 0000 061B                 pozycja_wiezy = 4;
; 0000 061C                 }
; 0000 061D 
; 0000 061E             if(sek2 > 170 & bufor_bledu == 0)
; 0000 061F                     {
; 0000 0620                     pozycja_wiezy = 2;
; 0000 0621                     bufor_bledu = 25;
; 0000 0622                     }
; 0000 0623 
; 0000 0624         break;
; 0000 0625 
; 0000 0626         case 3:
; 0000 0627 
; 0000 0628             if(PINE.1 != 0)
; 0000 0629                 obroc_o_1_8_stopnia(v1+ bufor_bledu, 0);
; 0000 062A             else
; 0000 062B                 {
; 0000 062C                 kamien = 50;
; 0000 062D                 if(kamien == 50)
; 0000 062E                     wielkosc_przesuniecia_kamien = 770 + 60; //tu ma byc 8mm zgodnie z rys mariusz    //650 - 21mm    //700 - 15mm      //760 //9mm
; 0000 062F                 if(kamien == 55)//przesuwamy o 2,5mm
; 0000 0630                     wielkosc_przesuniecia_kamien = 740;
; 0000 0631                 if(kamien == 60)
; 0000 0632                     wielkosc_przesuniecia_kamien = 710;
; 0000 0633                 if(kamien == 65)
; 0000 0634                     wielkosc_przesuniecia_kamien = 680;
; 0000 0635                 if(kamien == 70)
; 0000 0636                     wielkosc_przesuniecia_kamien = 650;
; 0000 0637                 if(kamien == 75)
; 0000 0638                     wielkosc_przesuniecia_kamien = 620; //tu ma byc 8mm + 25/2mm = 20,5    18mm
; 0000 0639 
; 0000 063A                 pozycja_wiezy = 4;
; 0000 063B                 }
; 0000 063C 
; 0000 063D             if(sek2 > 170 & bufor_bledu == 0)
; 0000 063E                     {
; 0000 063F                     pozycja_wiezy = 3;
; 0000 0640                     bufor_bledu = 25;
; 0000 0641                     }
; 0000 0642         break;
; 0000 0643 
; 0000 0644 
; 0000 0645         case 4:
; 0000 0646                 if(kkk < 2)
; 0000 0647                     kkk = obroc_o_1_8_stopnia(v1+ bufor_bledu, kkk);  //jedziemy jeszcze kawalek z pelna pyta
; 0000 0648                 else
; 0000 0649                     {
; 0000 064A                     kkk = 0;
; 0000 064B                     pozycja_wiezy = 5;
; 0000 064C                     }
; 0000 064D 
; 0000 064E         break;
; 0000 064F 
; 0000 0650 
; 0000 0651         case 5:
; 0000 0652                 if(kkk < 2)
; 0000 0653                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 0654                 else
; 0000 0655                     {
; 0000 0656                     kkk = 0;
; 0000 0657                     pozycja_wiezy = 6;
; 0000 0658                     }
; 0000 0659 
; 0000 065A         break;
; 0000 065B 
; 0000 065C         case 6:
; 0000 065D                 if(kkk < 2)
; 0000 065E                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 065F                 else
; 0000 0660                     {
; 0000 0661                     kkk = 0;
; 0000 0662                     pozycja_wiezy = 7;
; 0000 0663                     }
; 0000 0664 
; 0000 0665         break;
; 0000 0666 
; 0000 0667         case 7:
; 0000 0668                 if(kkk < 2)
; 0000 0669                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);  //zwalniamy do stalej predkosci
; 0000 066A                 else
; 0000 066B                     {
; 0000 066C                     kkk = 0;
; 0000 066D                     pozycja_wiezy = 8;
; 0000 066E                     }
; 0000 066F 
; 0000 0670         break;
; 0000 0671 
; 0000 0672 
; 0000 0673 
; 0000 0674         case 8:
; 0000 0675                 if(kkk < wielkosc_przesuniecia_kamien)
; 0000 0676                     kkk = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 0677                 else
; 0000 0678                     {
; 0000 0679                     pozycja_wiezy = 10;//9
; 0000 067A                     ulamki_sekund_1 = 0;
; 0000 067B                     v1 = v1 + 6;
; 0000 067C                     kkk = 0;
; 0000 067D                     kkk1 = 0;
; 0000 067E                     }
; 0000 067F 
; 0000 0680         break;
; 0000 0681 
; 0000 0682         case 9:
; 0000 0683 
; 0000 0684 
; 0000 0685                   if(kkk == kkk1)
; 0000 0686                         kkk1 = obroc_o_1_8_stopnia(v1 + bufor_bledu, kkk);
; 0000 0687                   else
; 0000 0688                         {
; 0000 0689                         if(ulamki_sekund_1 > 60 * 6 * 2)
; 0000 068A                             {
; 0000 068B                             v1++;
; 0000 068C                             ulamki_sekund_1 = 0;
; 0000 068D                             }
; 0000 068E                         kkk1 = kkk;
; 0000 068F                         }
; 0000 0690                   if(v1 == 40)
; 0000 0691                         {
; 0000 0692                         kkk = 0;
; 0000 0693                         pozycja_wiezy = 10;
; 0000 0694                         }
; 0000 0695 
; 0000 0696         break;
; 0000 0697 
; 0000 0698         case 10:
; 0000 0699 
; 0000 069A                 PORTE.7 = 0;  //koniec enable
; 0000 069B                 PORTC.1 = 0;  //silownik dociskowy os pozioma
; 0000 069C                 kkk = 0;
; 0000 069D                 kkk1 = 0;
; 0000 069E                 v1 = 60;
; 0000 069F                 bufor_bledu = 0;
; 0000 06A0                 if(PORTE.4 == 1)
; 0000 06A1                     PORTE.4 = 0;  //zmieniamy dir
; 0000 06A2                 else
; 0000 06A3                     PORTE.4 = 1;
; 0000 06A4                 pozycja_wiezy = 0;
; 0000 06A5                 delay_ms(2000);
; 0000 06A6                 if(PORTC.0 == 0) //silownik obrotowy o osi pionowej
; 0000 06A7                     PORTC.0 = 1;
; 0000 06A8                 else
; 0000 06A9                     PORTC.0 = 0;
; 0000 06AA                 PORTC.1 = 1;  //silownik dociskowy os pozioma
; 0000 06AB                 delay_ms(2000);
; 0000 06AC 
; 0000 06AD 
; 0000 06AE 
; 0000 06AF         break;
; 0000 06B0         }
; 0000 06B1 
; 0000 06B2 
; 0000 06B3 
; 0000 06B4 
; 0000 06B5 
; 0000 06B6 
; 0000 06B7 
; 0000 06B8 }
;
;
;
;
;void komunikacja_male_puchary()
; 0000 06BE {
_komunikacja_male_puchary:
; 0000 06BF 
; 0000 06C0 //kod u slava
; 0000 06C1 
; 0000 06C2 
; 0000 06C3 if(PINF.7 == 0)
	SBIC 0x0,7
	RJMP _0x252
; 0000 06C4     {
; 0000 06C5     if(PINF.6 == 0 & zliczylem_male_puchary == 0)
	LDI  R26,0
	SBIC 0x0,6
	LDI  R26,1
	CALL SUBOPT_0xC
	LDS  R26,_zliczylem_male_puchary
	LDS  R27,_zliczylem_male_puchary+1
	CALL SUBOPT_0x2B
	AND  R30,R0
	BREQ _0x253
; 0000 06C6         {
; 0000 06C7         PORTB.6 = 1;
	SBI  0x18,6
; 0000 06C8         przeslano_informacje_male_puchary = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _przeslano_informacje_male_puchary,R30
	STS  _przeslano_informacje_male_puchary+1,R31
; 0000 06C9         licznik_impulsow_male_puchary++;
	LDI  R26,LOW(_licznik_impulsow_male_puchary)
	LDI  R27,HIGH(_licznik_impulsow_male_puchary)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 06CA         zliczylem_male_puchary = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zliczylem_male_puchary,R30
	STS  _zliczylem_male_puchary+1,R31
; 0000 06CB         }
; 0000 06CC 
; 0000 06CD 
; 0000 06CE 
; 0000 06CF         if(PINF.6 == 1 & zliczylem_male_puchary == 1)
_0x253:
	LDI  R26,0
	SBIC 0x0,6
	LDI  R26,1
	CALL SUBOPT_0x20
	LDS  R26,_zliczylem_male_puchary
	LDS  R27,_zliczylem_male_puchary+1
	CALL SUBOPT_0xD
	AND  R30,R0
	BREQ _0x256
; 0000 06D0         {
; 0000 06D1         PORTB.6 = 0;
	CBI  0x18,6
; 0000 06D2         zliczylem_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _zliczylem_male_puchary,R30
	STS  _zliczylem_male_puchary+1,R30
; 0000 06D3         }
; 0000 06D4 
; 0000 06D5     }
_0x256:
; 0000 06D6                //& pozycja_wiezy == 0
; 0000 06D7 if(PINF.7 == 1 & przeslano_informacje_male_puchary == 1)
_0x252:
	LDI  R26,0
	SBIC 0x0,7
	LDI  R26,1
	CALL SUBOPT_0x20
	LDS  R26,_przeslano_informacje_male_puchary
	LDS  R27,_przeslano_informacje_male_puchary+1
	CALL SUBOPT_0xD
	AND  R30,R0
	BRNE PC+3
	JMP _0x259
; 0000 06D8     {
; 0000 06D9 
; 0000 06DA     switch(licznik_impulsow_male_puchary)
	LDS  R30,_licznik_impulsow_male_puchary
	LDS  R31,_licznik_impulsow_male_puchary+1
; 0000 06DB         {
; 0000 06DC         case 0:
	SBIW R30,0
	BRNE _0x25D
; 0000 06DD               tryb_male_puchary = 0;  //ze nie dokonano zadnego wyboru
	LDI  R30,LOW(0)
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R30
; 0000 06DE               przeslano_informacje_male_puchary = 0;
	RJMP _0x336
; 0000 06DF         break;
; 0000 06E0 
; 0000 06E1         case 3:
_0x25D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25E
; 0000 06E2               tryb_male_puchary = 3;   //ze nie bedzie malych malych pucharow
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x31
; 0000 06E3               licznik_impulsow_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _licznik_impulsow_male_puchary,R30
	STS  _licznik_impulsow_male_puchary+1,R30
; 0000 06E4               przeslano_informacje_male_puchary = 0;
	STS  _przeslano_informacje_male_puchary,R30
	STS  _przeslano_informacje_male_puchary+1,R30
; 0000 06E5               podaj_nakretke = 1;
	CALL SUBOPT_0x30
; 0000 06E6               PORTE.0 = 0;
	CALL SUBOPT_0x32
; 0000 06E7               PORTE.1 = 0;
; 0000 06E8               PORTE.2 = 0;
; 0000 06E9               PORTE.3 = 0;
; 0000 06EA               PORTE.4 = 0;
	CBI  0x3,4
; 0000 06EB               PORTE.5 = 0;
	CBI  0x3,5
; 0000 06EC 
; 0000 06ED 
; 0000 06EE         break;
	RJMP _0x25C
; 0000 06EF 
; 0000 06F0         case 11:
_0x25E:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x26B
; 0000 06F1              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 06F2              kamien = 50;
	CALL SUBOPT_0x34
; 0000 06F3              PORTE.0 = 0;
; 0000 06F4               PORTE.1 = 1;
; 0000 06F5               PORTE.2 = 0;
; 0000 06F6               PORTE.3 = 0;
; 0000 06F7               PORTE.4 = 0;
; 0000 06F8               PORTE.5 = 0;
; 0000 06F9 
; 0000 06FA 
; 0000 06FB              //speed_normal = 10;
; 0000 06FC              speed_normal = 8;
	RJMP _0x337
; 0000 06FD              licznik_impulsow_male_puchary = 0;
; 0000 06FE              przeslano_informacje_male_puchary = 0;
; 0000 06FF         break;
; 0000 0700 
; 0000 0701         case 12:
_0x26B:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x278
; 0000 0702              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0703              kamien = 55;
	CALL SUBOPT_0x35
; 0000 0704              PORTE.0 = 0;
; 0000 0705               PORTE.1 = 0;
; 0000 0706               PORTE.2 = 1;
; 0000 0707               PORTE.3 = 0;
; 0000 0708               PORTE.4 = 0;
; 0000 0709               PORTE.5 = 0;
; 0000 070A 
; 0000 070B              //speed_normal = 10;
; 0000 070C              speed_normal = 8;
	RJMP _0x337
; 0000 070D              licznik_impulsow_male_puchary = 0;
; 0000 070E              przeslano_informacje_male_puchary = 0;
; 0000 070F         break;
; 0000 0710 
; 0000 0711         case 13:
_0x278:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x285
; 0000 0712              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0713              kamien = 60;
	CALL SUBOPT_0x36
; 0000 0714              PORTE.0 = 0;
; 0000 0715               PORTE.1 = 0;
; 0000 0716               PORTE.2 = 0;
; 0000 0717               PORTE.3 = 1;
; 0000 0718               PORTE.4 = 0;
; 0000 0719               PORTE.5 = 0;
; 0000 071A 
; 0000 071B              //speed_normal = 10;
; 0000 071C              speed_normal = 8;
	RJMP _0x337
; 0000 071D              licznik_impulsow_male_puchary = 0;
; 0000 071E              przeslano_informacje_male_puchary = 0;
; 0000 071F         break;
; 0000 0720 
; 0000 0721         case 14:
_0x285:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x292
; 0000 0722              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0723              kamien = 65;
	CALL SUBOPT_0x37
; 0000 0724              PORTE.0 = 0;
; 0000 0725               PORTE.1 = 0;
; 0000 0726               PORTE.2 = 0;
; 0000 0727               PORTE.3 = 0;
; 0000 0728               PORTE.4 = 1;
	SBI  0x3,4
; 0000 0729               PORTE.5 = 0;
	CBI  0x3,5
; 0000 072A 
; 0000 072B              //speed_normal = 10;
; 0000 072C              speed_normal = 8;
	RJMP _0x337
; 0000 072D              licznik_impulsow_male_puchary = 0;
; 0000 072E              przeslano_informacje_male_puchary = 0;
; 0000 072F         break;
; 0000 0730 
; 0000 0731         case 15:
_0x292:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x29F
; 0000 0732              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0733              kamien = 70;
	CALL SUBOPT_0x38
; 0000 0734              PORTE.0 = 0;
	CALL SUBOPT_0x32
; 0000 0735               PORTE.1 = 0;
; 0000 0736               PORTE.2 = 0;
; 0000 0737               PORTE.3 = 0;
; 0000 0738               PORTE.4 = 0;
	CBI  0x3,4
; 0000 0739               PORTE.5 = 1;
	RJMP _0x338
; 0000 073A 
; 0000 073B              //speed_normal = 10;
; 0000 073C              speed_normal = 8;
; 0000 073D              licznik_impulsow_male_puchary = 0;
; 0000 073E              przeslano_informacje_male_puchary = 0;
; 0000 073F 
; 0000 0740         break;
; 0000 0741 
; 0000 0742         case 16:
_0x29F:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ _0x339
; 0000 0743              tryb_male_puchary = 2;
; 0000 0744              kamien = 75;
; 0000 0745              PORTE.0 = 0;
; 0000 0746               PORTE.1 = 0;
; 0000 0747               PORTE.2 = 0;
; 0000 0748               PORTE.3 = 0;
; 0000 0749               PORTE.4 = 1;
; 0000 074A               PORTE.5 = 1;
; 0000 074B 
; 0000 074C              //speed_normal = 10;
; 0000 074D              speed_normal = 8;
; 0000 074E              licznik_impulsow_male_puchary = 0;
; 0000 074F              przeslano_informacje_male_puchary = 0;
; 0000 0750         break;
; 0000 0751 
; 0000 0752         case 17:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x2B9
; 0000 0753              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0754              kamien = 50;
	CALL SUBOPT_0x34
; 0000 0755              PORTE.0 = 0;
; 0000 0756               PORTE.1 = 1;
; 0000 0757               PORTE.2 = 0;
; 0000 0758               PORTE.3 = 0;
; 0000 0759               PORTE.4 = 0;
; 0000 075A               PORTE.5 = 0;
; 0000 075B 
; 0000 075C              speed_normal = 8;
	RJMP _0x337
; 0000 075D              licznik_impulsow_male_puchary = 0;
; 0000 075E              przeslano_informacje_male_puchary = 0;
; 0000 075F         break;
; 0000 0760 
; 0000 0761         case 18:
_0x2B9:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x2C6
; 0000 0762              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0763              kamien = 55;
	CALL SUBOPT_0x35
; 0000 0764              PORTE.0 = 0;
; 0000 0765               PORTE.1 = 0;
; 0000 0766               PORTE.2 = 1;
; 0000 0767               PORTE.3 = 0;
; 0000 0768               PORTE.4 = 0;
; 0000 0769               PORTE.5 = 0;
; 0000 076A 
; 0000 076B              speed_normal = 8;
	RJMP _0x337
; 0000 076C              licznik_impulsow_male_puchary = 0;
; 0000 076D              przeslano_informacje_male_puchary = 0;
; 0000 076E         break;
; 0000 076F 
; 0000 0770         case 19:
_0x2C6:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x2D3
; 0000 0771              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0772              kamien = 60;
	CALL SUBOPT_0x36
; 0000 0773              PORTE.0 = 0;
; 0000 0774               PORTE.1 = 0;
; 0000 0775               PORTE.2 = 0;
; 0000 0776               PORTE.3 = 1;
; 0000 0777               PORTE.4 = 0;
; 0000 0778               PORTE.5 = 0;
; 0000 0779 
; 0000 077A              speed_normal = 8;
	RJMP _0x337
; 0000 077B              licznik_impulsow_male_puchary = 0;
; 0000 077C              przeslano_informacje_male_puchary = 0;
; 0000 077D         break;
; 0000 077E 
; 0000 077F         case 20:
_0x2D3:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x2E0
; 0000 0780              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0781              kamien = 65;
	CALL SUBOPT_0x37
; 0000 0782              PORTE.0 = 0;
; 0000 0783               PORTE.1 = 0;
; 0000 0784               PORTE.2 = 0;
; 0000 0785               PORTE.3 = 0;
; 0000 0786               PORTE.4 = 1;
	SBI  0x3,4
; 0000 0787               PORTE.5 = 0;
	CBI  0x3,5
; 0000 0788 
; 0000 0789              speed_normal = 8;
	RJMP _0x337
; 0000 078A              licznik_impulsow_male_puchary = 0;
; 0000 078B              przeslano_informacje_male_puchary = 0;
; 0000 078C         break;
; 0000 078D 
; 0000 078E         case 21:
_0x2E0:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x2ED
; 0000 078F              tryb_male_puchary = 2;
	CALL SUBOPT_0x33
; 0000 0790              PORTE.0 = 0;
	CALL SUBOPT_0x32
; 0000 0791               PORTE.1 = 0;
; 0000 0792               PORTE.2 = 0;
; 0000 0793               PORTE.3 = 0;
; 0000 0794               PORTE.4 = 0;
	CBI  0x3,4
; 0000 0795               PORTE.5 = 1;
	SBI  0x3,5
; 0000 0796              kamien = 70;
	CALL SUBOPT_0x38
; 0000 0797              speed_normal = 8;
	RJMP _0x337
; 0000 0798              licznik_impulsow_male_puchary = 0;
; 0000 0799              przeslano_informacje_male_puchary = 0;
; 0000 079A         break;
; 0000 079B 
; 0000 079C         case 22:
_0x2ED:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x25C
; 0000 079D              tryb_male_puchary = 2;
_0x339:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x31
; 0000 079E              kamien = 75;
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	STS  _kamien,R30
	STS  _kamien+1,R31
; 0000 079F              PORTE.0 = 0;
	CALL SUBOPT_0x32
; 0000 07A0               PORTE.1 = 0;
; 0000 07A1               PORTE.2 = 0;
; 0000 07A2               PORTE.3 = 0;
; 0000 07A3               PORTE.4 = 1;
	SBI  0x3,4
; 0000 07A4               PORTE.5 = 1;
_0x338:
	SBI  0x3,5
; 0000 07A5              speed_normal = 8;
_0x337:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _speed_normal,R30
	STS  _speed_normal+1,R31
; 0000 07A6              licznik_impulsow_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _licznik_impulsow_male_puchary,R30
	STS  _licznik_impulsow_male_puchary+1,R30
; 0000 07A7              przeslano_informacje_male_puchary = 0;
_0x336:
	LDI  R30,LOW(0)
	STS  _przeslano_informacje_male_puchary,R30
	STS  _przeslano_informacje_male_puchary+1,R30
; 0000 07A8         break;
; 0000 07A9 
; 0000 07AA 
; 0000 07AB 
; 0000 07AC 
; 0000 07AD         }
_0x25C:
; 0000 07AE     }
; 0000 07AF 
; 0000 07B0 /*
; 0000 07B1 if(PINC.7 == 0)
; 0000 07B2     PORTB.7 = 1;
; 0000 07B3 else
; 0000 07B4     PORTB.7 = 0;
; 0000 07B5 
; 0000 07B6 if(PINC.6 == 0)
; 0000 07B7     PORTB.6 = 1;
; 0000 07B8 else
; 0000 07B9     PORTB.6 = 0;
; 0000 07BA 
; 0000 07BB if(PINC.5 == 0)
; 0000 07BC     PORTB.5 = 1;
; 0000 07BD else
; 0000 07BE     PORTB.5 = 0;
; 0000 07BF 
; 0000 07C0 if(PINC.4 == 0)
; 0000 07C1     PORTB.4 = 1;
; 0000 07C2 else
; 0000 07C3     PORTB.4 = 0;
; 0000 07C4 
; 0000 07C5 if(PINC.3 == 0)
; 0000 07C6     PORTB.3 = 1;
; 0000 07C7 else
; 0000 07C8     PORTB.3 = 0;
; 0000 07C9 
; 0000 07CA if(PINC.2 == 0)
; 0000 07CB     PORTB.2 = 1;
; 0000 07CC else
; 0000 07CD     PORTB.2 = 0;
; 0000 07CE 
; 0000 07CF if(PINC.1 == 0)
; 0000 07D0     PORTB.1 = 1;
; 0000 07D1 else
; 0000 07D2     PORTB.1 = 0;
; 0000 07D3 
; 0000 07D4 if(PINC.0 == 0)
; 0000 07D5     PORTB.0 = 1;
; 0000 07D6 else
; 0000 07D7     PORTB.0 = 0;
; 0000 07D8 */
; 0000 07D9 
; 0000 07DA 
; 0000 07DB 
; 0000 07DC }
_0x259:
	RET
;
;
;void main(void)
; 0000 07E0 {
_main:
; 0000 07E1 // Declare your local variables here
; 0000 07E2 
; 0000 07E3 // Input/Output Ports initialization
; 0000 07E4 // Port A initialization
; 0000 07E5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 07E6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 07E7 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 07E8 DDRA=0x00;
	OUT  0x1A,R30
; 0000 07E9 
; 0000 07EA // Port B initialization
; 0000 07EB // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07EC // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07ED PORTB=0x00;
	OUT  0x18,R30
; 0000 07EE DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 07EF 
; 0000 07F0 // Port C initialization
; 0000 07F1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07F2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07F3 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 07F4 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 07F5 
; 0000 07F6 // Port D initialization
; 0000 07F7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 07F8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 07F9 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 07FA DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 07FB 
; 0000 07FC // Port E initialization
; 0000 07FD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 07FE // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T      //stary przy starych malych pucharach
; 0000 07FF //PORTE=0x00;
; 0000 0800 //DDRE=0xF0;
; 0000 0801 
; 0000 0802 // Port E initialization
; 0000 0803 // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0804 // State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0805 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0806 DDRE=0x3F;
	LDI  R30,LOW(63)
	OUT  0x2,R30
; 0000 0807 
; 0000 0808 // Port F initialization
; 0000 0809 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 080A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 080B PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 080C DDRF=0x00;
	STS  97,R30
; 0000 080D 
; 0000 080E // Port G initialization
; 0000 080F // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0810 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0811 PORTG=0x00;
	STS  101,R30
; 0000 0812 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0813 
; 0000 0814 // Timer/Counter 0 initialization
; 0000 0815 // Clock source: System Clock
; 0000 0816 // Clock value: 15,625 kHz
; 0000 0817 // Mode: Normal top=0xFF
; 0000 0818 // OC0 output: Disconnected
; 0000 0819 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 081A TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 081B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 081C OCR0=0x00;
	OUT  0x31,R30
; 0000 081D 
; 0000 081E // Timer/Counter 1 initialization
; 0000 081F // Clock source: System Clock
; 0000 0820 // Clock value: Timer1 Stopped
; 0000 0821 // Mode: Normal top=0xFFFF
; 0000 0822 // OC1A output: Discon.
; 0000 0823 // OC1B output: Discon.
; 0000 0824 // OC1C output: Discon.
; 0000 0825 // Noise Canceler: Off
; 0000 0826 // Input Capture on Falling Edge
; 0000 0827 // Timer1 Overflow Interrupt: Off
; 0000 0828 // Input Capture Interrupt: Off
; 0000 0829 // Compare A Match Interrupt: Off
; 0000 082A // Compare B Match Interrupt: Off
; 0000 082B // Compare C Match Interrupt: Off
; 0000 082C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 082D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 082E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 082F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0830 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0831 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0832 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0833 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0834 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0835 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0836 OCR1CH=0x00;
	STS  121,R30
; 0000 0837 OCR1CL=0x00;
	STS  120,R30
; 0000 0838 
; 0000 0839 // Timer/Counter 2 initialization
; 0000 083A // Clock source: System Clock
; 0000 083B // Clock value: Timer2 Stopped
; 0000 083C // Mode: Normal top=0xFF
; 0000 083D // OC2 output: Disconnected
; 0000 083E //TCCR2=0x00;
; 0000 083F //TCNT2=0x00;
; 0000 0840 //OCR2=0x00;
; 0000 0841 
; 0000 0842 // Timer/Counter 2 initialization
; 0000 0843 // Clock source: System Clock
; 0000 0844 // Clock value: 250,000 kHz
; 0000 0845 // Mode: Normal top=0xFF
; 0000 0846 // OC2 output: Disconnected
; 0000 0847 //TCCR2=0x03;
; 0000 0848 //TCNT2=0x00;
; 0000 0849 //OCR2=0x00;
; 0000 084A 
; 0000 084B 
; 0000 084C // Timer/Counter 2 initialization
; 0000 084D // Clock source: System Clock
; 0000 084E // Clock value: 2000,000 kHz
; 0000 084F // Mode: Normal top=0xFF
; 0000 0850 // OC2 output: Disconnected
; 0000 0851 //TCCR2=0x02;
; 0000 0852 //TCNT2=0x00;
; 0000 0853 //OCR2=0x00;
; 0000 0854 
; 0000 0855 // Timer/Counter 2 initialization
; 0000 0856 // Clock source: System Clock
; 0000 0857 // Clock value: 16000,000 kHz
; 0000 0858 // Mode: Normal top=0xFF
; 0000 0859 // OC2 output: Disconnected
; 0000 085A TCCR2=0x01;
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 085B TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 085C OCR2=0x00;
	OUT  0x23,R30
; 0000 085D 
; 0000 085E 
; 0000 085F 
; 0000 0860 // Timer/Counter 3 initialization
; 0000 0861 // Clock source: System Clock
; 0000 0862 // Clock value: Timer3 Stopped
; 0000 0863 // Mode: Normal top=0xFFFF
; 0000 0864 // OC3A output: Discon.
; 0000 0865 // OC3B output: Discon.
; 0000 0866 // OC3C output: Discon.
; 0000 0867 // Noise Canceler: Off
; 0000 0868 // Input Capture on Falling Edge
; 0000 0869 // Timer3 Overflow Interrupt: Off
; 0000 086A // Input Capture Interrupt: Off
; 0000 086B // Compare A Match Interrupt: Off
; 0000 086C // Compare B Match Interrupt: Off
; 0000 086D // Compare C Match Interrupt: Off
; 0000 086E TCCR3A=0x00;
	STS  139,R30
; 0000 086F TCCR3B=0x00;
	STS  138,R30
; 0000 0870 TCNT3H=0x00;
	STS  137,R30
; 0000 0871 TCNT3L=0x00;
	STS  136,R30
; 0000 0872 ICR3H=0x00;
	STS  129,R30
; 0000 0873 ICR3L=0x00;
	STS  128,R30
; 0000 0874 OCR3AH=0x00;
	STS  135,R30
; 0000 0875 OCR3AL=0x00;
	STS  134,R30
; 0000 0876 OCR3BH=0x00;
	STS  133,R30
; 0000 0877 OCR3BL=0x00;
	STS  132,R30
; 0000 0878 OCR3CH=0x00;
	STS  131,R30
; 0000 0879 OCR3CL=0x00;
	STS  130,R30
; 0000 087A 
; 0000 087B // External Interrupt(s) initialization
; 0000 087C // INT0: Off
; 0000 087D // INT1: Off
; 0000 087E // INT2: Off
; 0000 087F // INT3: Off
; 0000 0880 // INT4: Off
; 0000 0881 // INT5: Off
; 0000 0882 // INT6: Off
; 0000 0883 // INT7: Off
; 0000 0884 EICRA=0x00;
	STS  106,R30
; 0000 0885 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0886 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0887 
; 0000 0888 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0889 //TIMSK=0x01;
; 0000 088A 
; 0000 088B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 088C TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x37,R30
; 0000 088D 
; 0000 088E 
; 0000 088F 
; 0000 0890 
; 0000 0891 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0892 
; 0000 0893 
; 0000 0894 /*
; 0000 0895 // USART0 initialization
; 0000 0896 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0897 // USART0 Receiver: On
; 0000 0898 // USART0 Transmitter: On
; 0000 0899 // USART0 Mode: Asynchronous
; 0000 089A // USART0 Baud Rate: 2400
; 0000 089B UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 089C UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 089D UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 089E UBRR0H=0x01;
; 0000 089F UBRR0L=0xA0;
; 0000 08A0 */
; 0000 08A1 
; 0000 08A2 
; 0000 08A3 /*
; 0000 08A4 // USART0 initialization
; 0000 08A5 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 08A6 // USART0 Receiver: On
; 0000 08A7 // USART0 Transmitter: On
; 0000 08A8 // USART0 Mode: Asynchronous
; 0000 08A9 // USART0 Baud Rate: 9600
; 0000 08AA UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
; 0000 08AB UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
; 0000 08AC UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
; 0000 08AD UBRR0H=0x00;
; 0000 08AE UBRR0L=0x67;
; 0000 08AF 
; 0000 08B0 */
; 0000 08B1 // USART0 initialization
; 0000 08B2 // USART0 disabled
; 0000 08B3 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 08B4 
; 0000 08B5 
; 0000 08B6 // USART1 initialization
; 0000 08B7 // USART1 disabled
; 0000 08B8 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 08B9 
; 0000 08BA // USART1 initialization
; 0000 08BB // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 08BC // USART1 Receiver: On
; 0000 08BD // USART1 Transmitter: On
; 0000 08BE // USART1 Mode: Asynchronous
; 0000 08BF // USART1 Baud Rate: 9600
; 0000 08C0 //UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
; 0000 08C1 //UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
; 0000 08C2 //UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
; 0000 08C3 //UBRR1H=0x00;
; 0000 08C4 //UBRR1L=0x67;
; 0000 08C5 
; 0000 08C6 
; 0000 08C7 // Analog Comparator initialization
; 0000 08C8 // Analog Comparator: Off
; 0000 08C9 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 08CA ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 08CB SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 08CC 
; 0000 08CD // ADC initialization
; 0000 08CE // ADC disabled
; 0000 08CF ADCSRA=0x00;
	OUT  0x6,R30
; 0000 08D0 
; 0000 08D1 // SPI initialization
; 0000 08D2 // SPI disabled
; 0000 08D3 SPCR=0x00;
	OUT  0xD,R30
; 0000 08D4 
; 0000 08D5 // TWI initialization
; 0000 08D6 // TWI disabled
; 0000 08D7 TWCR=0x00;
	STS  116,R30
; 0000 08D8 
; 0000 08D9 
; 0000 08DA // Alphanumeric LCD initialization
; 0000 08DB // Connections specified in the
; 0000 08DC // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 08DD // RS - PORTG Bit 4
; 0000 08DE // RD - PORTD Bit 6
; 0000 08DF // EN - PORTD Bit 7
; 0000 08E0 // D4 - PORTG Bit 0
; 0000 08E1 // D5 - PORTG Bit 1
; 0000 08E2 // D6 - PORTG Bit 2
; 0000 08E3 // D7 - PORTG Bit 3
; 0000 08E4 // Characters/line: 16
; 0000 08E5 //lcd_init(16);
; 0000 08E6 //BEZ WYSWIETLACZ
; 0000 08E7 
; 0000 08E8 //WE
; 0000 08E9 //PINA.0    czujnik widzenia nakrêtki
; 0000 08EA //PINA.1    uszkodzonie na karcie - Pan Bogdan zwar³
; 0000 08EB //PINA.2    czujnik widzenia kamienia
; 0000 08EC //PINA.3    sygnal odpytania od procesora glownego
; 0000 08ED //PINA.4    czujnik do silownika kolejkujacego nakretki - lampka nie chodzi
; 0000 08EE //PINA.5    czujnik czy jest klej
; 0000 08EF //PINA.6    czujnik czy jest gotowy do pracy dozownik kleju
; 0000 08F0 //PINA.7    pedal montera 3 - informacja ze zwolnil zacisk grzybka i jednoczesnie ze nakretka pobrana
; 0000 08F1 
; 0000 08F2 //PINF.0    uszkodzone
; 0000 08F3 //PINF.1    uszkodzona karta
; 0000 08F4 //PINF.2
; 0000 08F5 //PINF.3
; 0000 08F6 //PINF.4    czujnik dolny nakretek ten cienki magnetyczny
; 0000 08F7 //PINF.5    ze MAster dal zgode na zacisniecie szczek
; 0000 08F8 //PINF.6    do komunikacji z male puchary - NOWY KABEL
; 0000 08F9 //PINF.7    do komunikacji z male puchary sygnal przecinka - NOWY KABEL
; 0000 08FA 
; 0000 08FB //PINE.0    czujnik 1 indukcyjnych pozycjonujacey wieze
; 0000 08FC //PINE.1    czujnik 1 indukcyjnych pozycjonujacey wieze
; 0000 08FD //PINE.2    peda³ 2    //zmieniam na pine.6
; 0000 08FE //PINE.3    czujnik na silowniku otwierania wiezyczki tym nowym
; 0000 08FF 
; 0000 0900 //WNIOSKI:
; 0000 0901 //C ZMIENIC NA F
; 0000 0902 //DO C PODPIAC NOWA WYSPE
; 0000 0903 //DO E PODPISAC KARTE 4 + SILNIK KROK
; 0000 0904 
; 0000 0905 
; 0000 0906 //WY
; 0000 0907 //PORTB.0   orientator nakretek
; 0000 0908 //PORTB.1   za³¹czenie 220V na dozownik kleju
; 0000 0909 //PORTB.2
; 0000 090A //PORTB.3   psikanie
; 0000 090B //PORTB.4   cisnienia na dozownik kleju
; 0000 090C //PORTB.5   wibrator nowy
; 0000 090D //PORTB.6   SYGAN POTWIERDZENIA DO MASTER
; 0000 090E //PORTB.7   podawanie kleju
; 0000 090F 
; 0000 0910 //PORTD.0
; 0000 0911 //PORTD.1
; 0000 0912 //PORTD.2   silownik podawania kleju
; 0000 0913 //PORTD.3   silownik otwierania lancy
; 0000 0914 //PORTD.4   silownik wykonujacy drgania
; 0000 0915 //PORTD.5   silownik kolejkujacy nakrêtki na zjezdzalni
; 0000 0916 //PORTD.6   tacka pobierajaca nakretki
; 0000 0917 //PORTD.7   chwytanie kamienia
; 0000 0918 
; 0000 0919 
; 0000 091A //PORTC.0   // silownik obrotowy os pionowa
; 0000 091B //PORTC.1  //silownik obrotowy os pozioma w gore czyli nie ma kolizji
; 0000 091C //PORTC.2  //zamykanie wiezyczki 1
; 0000 091D //PORTC.3  //zamykanie wiezyczki 2
; 0000 091E //PORTC.4
; 0000 091F //PORTC.5
; 0000 0920 //PORTC.6
; 0000 0921 //PORTC.7  //zamykanie wiezyczki 2
; 0000 0922 
; 0000 0923 //WPROWADZAM MODYFIKACJE POD MALE PUCHARY
; 0000 0924 //PORTE.4 - DIR du¿y silnik
; 0000 0925 //PORTE.5 - CLK
; 0000 0926 //PORTE.7 - enable (1 uruchamia)
; 0000 0927 
; 0000 0928 //PROCESY
; 0000 0929 //proces_0 - podawanie nakretki monterowi
; 0000 092A //proces_1 - chwytanie kamienia
; 0000 092B 
; 0000 092C 
; 0000 092D //////////////////////////////////////////
; 0000 092E ////obsluga_startowa_dozownika_kleju();    //wywalam bo modul male puchary
; 0000 092F //////////////////////////////////////////
; 0000 0930 
; 0000 0931 /*
; 0000 0932 delay_ms(2000);
; 0000 0933 delay_ms(2000);
; 0000 0934 
; 0000 0935 PORTC.2 = 0;  //stan otwart wejsciowy wie¿a 1
; 0000 0936 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
; 0000 0937 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
; 0000 0938 //(aby zamknac: PORTC.3 = 0; PORTC.7 = 1;)
; 0000 0939 
; 0000 093A PORTC.5 = 0;  //schowaj silownik otwierajacy wieze - ustawienie wstepne
; 0000 093B PORTC.6 = 1;
; 0000 093C delay_ms(2000);
; 0000 093D delay_ms(2000);
; 0000 093E 
; 0000 093F 
; 0000 0940 PORTC.5 = 1;     //wysun silownik
; 0000 0941 PORTC.6 = 0;
; 0000 0942 
; 0000 0943 delay_ms(2000);
; 0000 0944 delay_ms(2000);
; 0000 0945 PORTC.5 = 0;  //schowaj silownik
; 0000 0946 PORTC.6 = 1;
; 0000 0947 
; 0000 0948 
; 0000 0949 delay_ms(2000);
; 0000 094A delay_ms(2000);
; 0000 094B */
; 0000 094C 
; 0000 094D 
; 0000 094E PORTC.5 = 0;  //schowaj silownik otwierajacy wieze
	CBI  0x15,5
; 0000 094F PORTC.6 = 1;
	SBI  0x15,6
; 0000 0950 
; 0000 0951 PORTC.3 = 1;  //stan otwarcia wejsciowy wie¿a 2
	SBI  0x15,3
; 0000 0952 PORTC.7 = 0;  //stan otwarcia wejsciowy wie¿a 2
	CBI  0x15,7
; 0000 0953 
; 0000 0954 
; 0000 0955 pomocnicza = 7;
	__GETD1N 0x7
	STS  _pomocnicza,R30
	STS  _pomocnicza+1,R31
	STS  _pomocnicza+2,R22
	STS  _pomocnicza+3,R23
; 0000 0956 stala_czasowa = 62;
	__GETD1N 0x3E
	STS  _stala_czasowa,R30
	STS  _stala_czasowa+1,R31
	STS  _stala_czasowa+2,R22
	STS  _stala_czasowa+3,R23
; 0000 0957 czas_monterow = pomocnicza * stala_czasowa;
	LDS  R26,_pomocnicza
	LDS  R27,_pomocnicza+1
	LDS  R24,_pomocnicza+2
	LDS  R25,_pomocnicza+3
	CALL __MULD12
	STS  _czas_monterow,R30
	STS  _czas_monterow+1,R31
	STS  _czas_monterow+2,R22
	STS  _czas_monterow+3,R23
; 0000 0958 start = 0;
	CLR  R4
	CLR  R5
; 0000 0959 PORTD.2 = 1;  //igla wysunieta z klejem czyli wysuniety silownik
	SBI  0x12,2
; 0000 095A nakretka = 1; //silownik z dysza kleju do gory
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 095B licznik_nakretek = 0;
	CLR  R6
	CLR  R7
; 0000 095C 
; 0000 095D czekaj_komunikacja = 0;
	CLR  R10
	CLR  R11
; 0000 095E podaj_nakretke = 0;
	CALL SUBOPT_0x1C
; 0000 095F wcisnalem_pedal = 0;
; 0000 0960 zezwolenie_na_zacisniecie_szczek_od_master = 0;
	LDI  R30,LOW(0)
	STS  _zezwolenie_na_zacisniecie_szczek_od_master,R30
	STS  _zezwolenie_na_zacisniecie_szczek_od_master+1,R30
; 0000 0961 zacisnalem_szczeki = 0;
	STS  _zacisnalem_szczeki,R30
	STS  _zacisnalem_szczeki+1,R30
; 0000 0962 ff = 0;
	CLR  R12
	CLR  R13
; 0000 0963 jest_nakretka_przy_dolnym = 0;
	STS  _jest_nakretka_przy_dolnym,R30
	STS  _jest_nakretka_przy_dolnym+1,R30
; 0000 0964 wlaczam_dodatkowe_wibracje_i_psikanie = 0;
	STS  _wlaczam_dodatkowe_wibracje_i_psikanie,R30
	STS  _wlaczam_dodatkowe_wibracje_i_psikanie+1,R30
; 0000 0965 licznik_drgania = 0;
	CALL SUBOPT_0x3
; 0000 0966 wystarczy_zejscia = 0;
	CALL SUBOPT_0x17
; 0000 0967 licznik_widzenia_nakretki = 0;
	LDI  R30,LOW(0)
	STS  _licznik_widzenia_nakretki,R30
	STS  _licznik_widzenia_nakretki+1,R30
; 0000 0968 wcisniete_zakonczone = 0;
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R30
; 0000 0969 wielkosc_przesuniecia_kamien = 0;
	STS  _wielkosc_przesuniecia_kamien,R30
	STS  _wielkosc_przesuniecia_kamien+1,R30
; 0000 096A kamien = 0;
	STS  _kamien,R30
	STS  _kamien+1,R30
; 0000 096B test_zjezdzalni_nakretek = 0;  //TEST ZJEZDZALNI NAKRETEK
	STS  _test_zjezdzalni_nakretek,R30
	STS  _test_zjezdzalni_nakretek+1,R30
; 0000 096C male_puchary_pozwolenie_wyjecia_puchara_monter_3 = 0;
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3,R30
	STS  _male_puchary_pozwolenie_wyjecia_puchara_monter_3+1,R30
; 0000 096D 
; 0000 096E podaj_nakretke = 1;
	CALL SUBOPT_0x30
; 0000 096F wcisnalem_pedal = 0;
	LDI  R30,LOW(0)
	STS  _wcisnalem_pedal,R30
	STS  _wcisnalem_pedal+1,R30
; 0000 0970 zacisnalem_szczeki = 0;
	STS  _zacisnalem_szczeki,R30
	STS  _zacisnalem_szczeki+1,R30
; 0000 0971 zezwolenie_od_master = 0;
	CALL SUBOPT_0x6
; 0000 0972 wcisniete_zakonczone = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R31
; 0000 0973 wieza = 0;
	LDI  R30,LOW(0)
	STS  _wieza,R30
	STS  _wieza+1,R30
; 0000 0974 
; 0000 0975 pozycja_wiezy = 0;
	STS  _pozycja_wiezy,R30
	STS  _pozycja_wiezy+1,R30
; 0000 0976 kkk = 0;
	STS  _kkk,R30
	STS  _kkk+1,R30
; 0000 0977 kkk1 = 0;
	STS  _kkk1,R30
	STS  _kkk1+1,R30
; 0000 0978 v1 = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	STS  _v1,R30
	STS  _v1+1,R31
; 0000 0979 speed_normal = 8;  //8 to totalny maks , 09.08.2018 bylo 10, zmieniam na 12, bo wtedy jest stabilnie
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _speed_normal,R30
	STS  _speed_normal+1,R31
; 0000 097A tryb_male_puchary = 0;
	LDI  R30,LOW(0)
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R30
; 0000 097B jedz_wieza_cykl_znacznik = 0;
	STS  _jedz_wieza_cykl_znacznik,R30
	STS  _jedz_wieza_cykl_znacznik+1,R30
; 0000 097C 
; 0000 097D PORTC.0 = 1;  // silownik obrotowy os pionowa
	SBI  0x15,0
; 0000 097E PORTC.1 = 1;  //silownik obrotowy os pozioma w gore czyli nie ma kolizji
	SBI  0x15,1
; 0000 097F PORTB.5 = 1;  //wibrator nowy
	SBI  0x18,5
; 0000 0980 
; 0000 0981 delay_ms(1000);
	CALL SUBOPT_0x39
; 0000 0982 delay_ms(1000);
	CALL SUBOPT_0x39
; 0000 0983 
; 0000 0984 //////////////////////////////////////////////////////////////
; 0000 0985 //wypozucjonuj_wieze_wolno();
; 0000 0986 
; 0000 0987 //#asm("sei")
; 0000 0988 //while(1)
; 0000 0989 //    jedz_wieza();
; 0000 098A 
; 0000 098B ////////////////////////////////////////////
; 0000 098C 
; 0000 098D while(tryb_male_puchary == 0)
_0x317:
	LDS  R30,_tryb_male_puchary
	LDS  R31,_tryb_male_puchary+1
	SBIW R30,0
	BRNE _0x319
; 0000 098E      komunikacja_male_puchary();
	RCALL _komunikacja_male_puchary
	RJMP _0x317
_0x319:
; 0000 0993 while(PINE.7 == 0)
_0x31A:
	SBIC 0x1,7
	RJMP _0x31C
; 0000 0994    {
; 0000 0995    PORTE.0 = 1;    //zadanie wypozycjonowania
	SBI  0x3,0
; 0000 0996    }
	RJMP _0x31A
_0x31C:
; 0000 0997 PORTE.0 = 0;
	CBI  0x3,0
; 0000 0998 PORTB.5 = 0;  //wibrator nowy stop
	CBI  0x18,5
; 0000 0999 
; 0000 099A // Global enable interrupts
; 0000 099B #asm("sei")
	sei
; 0000 099C 
; 0000 099D //while(1)
; 0000 099E //    jedz_wieza();
; 0000 099F 
; 0000 09A0 
; 0000 09A1 while (1)
_0x323:
; 0000 09A2       {
; 0000 09A3 
; 0000 09A4       procesy();
	RCALL _procesy
; 0000 09A5 
; 0000 09A6 
; 0000 09A7       //if(proces[3] != 4)
; 0000 09A8       //  {
; 0000 09A9         zerowanie_procesow();
	RCALL _zerowanie_procesow
; 0000 09AA         kontrola_orientatora_nakretek_nowa_zjezdzalnia();
	RCALL _kontrola_orientatora_nakretek_nowa_zjezdzalnia
; 0000 09AB         komunikacja_bez_rs232();
	RCALL _komunikacja_bez_rs232
; 0000 09AC         komunikacja_male_puchary();
	RCALL _komunikacja_male_puchary
; 0000 09AD       //  }
; 0000 09AE 
; 0000 09AF       while(jedz_wieza_cykl_znacznik == 1 & tryb_male_puchary == 2)
_0x326:
	LDS  R26,_jedz_wieza_cykl_znacznik
	LDS  R27,_jedz_wieza_cykl_znacznik+1
	CALL SUBOPT_0xD
	MOV  R0,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x1E
	AND  R30,R0
	BREQ _0x328
; 0000 09B0           {
; 0000 09B1           //jedz_wieza_cykl();
; 0000 09B2           jedz_wieza_cykl_nowy_procesor();
	RCALL _jedz_wieza_cykl_nowy_procesor
; 0000 09B3           if(skonczony_proces[0] == 0)
	LDS  R30,_skonczony_proces
	LDS  R31,_skonczony_proces+1
	SBIW R30,0
	BRNE _0x329
; 0000 09B4                 skonczony_proces[0] = proces_0();
	CALL SUBOPT_0x29
; 0000 09B5           if(skonczony_proces[3] == 0)
_0x329:
	__GETW1MN _skonczony_proces,6
	SBIW R30,0
	BRNE _0x32A
; 0000 09B6                 skonczony_proces[3] = proces_3();
	CALL SUBOPT_0x2C
; 0000 09B7           }
_0x32A:
	RJMP _0x326
_0x328:
; 0000 09B8 
; 0000 09B9       }
	RJMP _0x323
; 0000 09BA //kontrola_czujnika_dolnego_nakretek();
; 0000 09BB //kontrola_orientatora_nakretek();
; 0000 09BC //obsluga_dozownika_kleju_i_komunikacja();
; 0000 09BD //drgania();
; 0000 09BE //obsluga_probna_pobierania_nakretek();
; 0000 09BF }
_0x32B:
	RJMP _0x32B
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
_sek5:
	.BYTE 0x4
_wyzerowalem_sek5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_licznik_drgania
	LDS  R27,_licznik_drgania+1
	LDS  R24,_licznik_drgania+2
	LDS  R25,_licznik_drgania+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _licznik_drgania,R30
	STS  _licznik_drgania+1,R30
	STS  _licznik_drgania+2,R30
	STS  _licznik_drgania+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDS  R26,_tryb_male_puchary
	LDS  R27,_tryb_male_puchary+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zezwolenie_od_master,R30
	STS  _zezwolenie_od_master+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _zezwolenie_od_master,R30
	STS  _zezwolenie_od_master+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_wcisniete_zakonczone
	LDS  R27,_wcisniete_zakonczone+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x0,7
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	SBI  0x18,6
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_wcisniete_zakonczone
	LDS  R27,_wcisniete_zakonczone+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x0,7
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	__GETD1N 0x5
	CALL __GTD12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	STS  _sek0,R30
	STS  _sek0+1,R30
	STS  _sek0+2,R30
	STS  _sek0+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	STS  _ilosc_prob_wybicia_zakretki_do_gory,R30
	STS  _ilosc_prob_wybicia_zakretki_do_gory+1,R30
	SBI  0x12,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _proces,R30
	STS  _proces+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x12:
	LDS  R26,_sek0
	LDS  R27,_sek0+1
	LDS  R24,_sek0+2
	LDS  R25,_sek0+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	STS  _proces,R30
	STS  _proces+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _drgania
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x12
	__CPD2N 0x15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wystarczy_zejscia,R30
	STS  _wystarczy_zejscia+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _wystarczy_zejscia,R30
	STS  _wystarczy_zejscia+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	STS  _sek0,R30
	STS  _sek0+1,R31
	STS  _sek0+2,R22
	STS  _sek0+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x12
	__CPD2N 0x33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _podaj_nakretke,R30
	STS  _podaj_nakretke+1,R30
	STS  _wcisnalem_pedal,R30
	STS  _wcisnalem_pedal+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	__POINTW1MN _proces,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDS  R26,_zezwolenie_od_master
	LDS  R27,_zezwolenie_od_master+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x22:
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wcisnalem_pedal,R30
	STS  _wcisnalem_pedal+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDS  R30,_wieza
	LDS  R31,_wieza+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	__POINTW1MN _proces,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wcisniete_zakonczone,R30
	STS  _wcisniete_zakonczone+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	CALL _proces_0
	STS  _skonczony_proces,R30
	STS  _skonczony_proces+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	CALL _proces_3
	__PUTW1MN _skonczony_proces,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDS  R26,_skonczony_proces
	LDS  R27,_skonczony_proces+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __EQW12
	AND  R0,R30
	LDS  R26,_test_zjezdzalni_nakretek
	LDS  R27,_test_zjezdzalni_nakretek+1
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _skonczony_proces,R30
	STS  _skonczony_proces+1,R30
	__POINTW1MN _skonczony_proces,2
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _podaj_nakretke,R30
	STS  _podaj_nakretke+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x31:
	STS  _tryb_male_puchary,R30
	STS  _tryb_male_puchary+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	CBI  0x3,0
	CBI  0x3,1
	CBI  0x3,2
	CBI  0x3,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _kamien,R30
	STS  _kamien+1,R31
	CBI  0x3,0
	SBI  0x3,1
	CBI  0x3,2
	CBI  0x3,3
	CBI  0x3,4
	CBI  0x3,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	STS  _kamien,R30
	STS  _kamien+1,R31
	CBI  0x3,0
	CBI  0x3,1
	SBI  0x3,2
	CBI  0x3,3
	CBI  0x3,4
	CBI  0x3,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	STS  _kamien,R30
	STS  _kamien+1,R31
	CBI  0x3,0
	CBI  0x3,1
	CBI  0x3,2
	SBI  0x3,3
	CBI  0x3,4
	CBI  0x3,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	STS  _kamien,R30
	STS  _kamien+1,R31
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	STS  _kamien,R30
	STS  _kamien+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
