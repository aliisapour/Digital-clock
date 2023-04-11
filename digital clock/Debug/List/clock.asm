
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _k=R5
	.DEF __lcd_x=R4
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R6

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x48,0x48,0x20,0x4D,0x4D,0x20,0x53,0x53
	.DB  0x0,0x43,0x48,0x52,0x4F,0x4E,0x4F,0x4D
	.DB  0x45,0x54,0x45,0x52,0x0,0x30,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x09
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x3+9
	.DW  _0x0*2+9

	.DW  0x02
	.DW  _0x3+21
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x3+23
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x3+25
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x3+27
	.DW  _0x0*2+21

	.DW  0x09
	.DW  _0x3+29
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x3+38
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x3+40
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x3+42
	.DW  _0x0*2+21

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>
;#include <stdlib.h>
;
;// hex porta ra baraye lcd tarif mikonim
;#asm
.equ __lcd_port=0x1B;
; 0000 0009 #endasm
;
;unsigned char k;
;void main(void){
; 0000 000C void main(void){

	.CSEG
_main:
; .FSTART _main
; 0000 000D 
; 0000 000E 
; 0000 000F 
; 0000 0010 char str_second[1],str_minute[1],str_hour[1],str_sadsecond[1];
; 0000 0011 int second,minute,hour;
; 0000 0012 int counter;
; 0000 0013 int TIM;
; 0000 0014 int ERROR=70;
; 0000 0015 int adad=0;
; 0000 0016 int shomarande;
; 0000 0017 int timer=0;
; 0000 0018 int sadsecond ;
; 0000 0019 
; 0000 001A lcd_init(16);
	SBIW R28,18
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	LDI  R30,LOW(70)
	STD  Y+8,R30
	LDI  R30,LOW(0)
	STD  Y+9,R30
;	str_second -> Y+17
;	str_minute -> Y+16
;	str_hour -> Y+15
;	str_sadsecond -> Y+14
;	second -> R16,R17
;	minute -> R18,R19
;	hour -> R20,R21
;	counter -> Y+12
;	TIM -> Y+10
;	ERROR -> Y+8
;	adad -> Y+6
;	shomarande -> Y+4
;	timer -> Y+2
;	sadsecond -> Y+0
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 001B lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x0
; 0000 001C lcd_puts("HH MM SS");
	__POINTW2MN _0x3,0
	CALL _lcd_puts
; 0000 001D 
; 0000 001E 
; 0000 001F DDRB = 0XFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0020 DDRD = 0XF0;
	LDI  R30,LOW(240)
	OUT  0x11,R30
; 0000 0021 PORTD.0 = 1;
	SBI  0x12,0
; 0000 0022 PORTD.1 = 1;
	SBI  0x12,1
; 0000 0023 PORTD.2 = 1;
	SBI  0x12,2
; 0000 0024 
; 0000 0025 
; 0000 0026 U:{if(timer==1){
_0xA:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xB
; 0000 0027 lcd_clear();
	CALL _lcd_clear
; 0000 0028 
; 0000 0029 lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x0
; 0000 002A lcd_puts("CHRONOMETER");
	__POINTW2MN _0x3,9
	CALL _lcd_puts
; 0000 002B 
; 0000 002C    second=0;
	__GETWRN 16,17,0
; 0000 002D        while(1){
_0xC:
; 0000 002E sadsecond++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 002F 
; 0000 0030  if(sadsecond==10){sadsecond=0;second++;}
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0xF
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
	__ADDWRN 16,17,1
; 0000 0031 if(second==60){second=0;minute++;}
_0xF:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x10
	__GETWRN 16,17,0
	__ADDWRN 18,19,1
; 0000 0032 if(minute==60){minute=0;hour++;}
_0x10:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x11
	__GETWRN 18,19,0
	__ADDWRN 20,21,1
; 0000 0033 if(hour==24){hour=0;}
_0x11:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x12
	__GETWRN 20,21,0
; 0000 0034 //////////////////////////////////////
; 0000 0035 itoa(hour,str_hour);
_0x12:
	CALL SUBOPT_0x1
; 0000 0036 lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
; 0000 0037 if(hour<10)
	__CPWRN 20,21,10
	BRGE _0x13
; 0000 0038 lcd_puts("0");
	__POINTW2MN _0x3,21
	CALL _lcd_puts
; 0000 0039 lcd_puts(str_hour);
_0x13:
	CALL SUBOPT_0x3
; 0000 003A lcd_putchar(' ');
; 0000 003B lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2
; 0000 003C lcd_putchar(':');
	CALL SUBOPT_0x4
; 0000 003D ///////////////////////////////////////
; 0000 003E itoa(minute,str_minute);
; 0000 003F lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
; 0000 0040 if(minute<10)
	__CPWRN 18,19,10
	BRGE _0x14
; 0000 0041 lcd_puts("0");
	__POINTW2MN _0x3,23
	CALL _lcd_puts
; 0000 0042 lcd_puts(str_minute);
_0x14:
	CALL SUBOPT_0x5
; 0000 0043 lcd_putchar(' ');
; 0000 0044 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2
; 0000 0045 lcd_putchar(':');
	CALL SUBOPT_0x6
; 0000 0046 ///////////////////////////////////////
; 0000 0047 itoa(second,str_second);
; 0000 0048 lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
; 0000 0049 if(second<10)
	__CPWRN 16,17,10
	BRGE _0x15
; 0000 004A lcd_puts("0");
	__POINTW2MN _0x3,25
	CALL _lcd_puts
; 0000 004B lcd_puts(str_second);
_0x15:
	CALL SUBOPT_0x7
; 0000 004C lcd_putchar(' ');
; 0000 004D lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2
; 0000 004E lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 004F 
; 0000 0050 //////////////////////////////////////
; 0000 0051   itoa(sadsecond,str_sadsecond);
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,16
	CALL _itoa
; 0000 0052 lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x2
; 0000 0053 if(sadsecond<10)
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRGE _0x16
; 0000 0054 lcd_puts("0");
	__POINTW2MN _0x3,27
	CALL _lcd_puts
; 0000 0055 lcd_puts(str_sadsecond);
_0x16:
	MOVW R26,R28
	ADIW R26,14
	CALL _lcd_puts
; 0000 0056 lcd_putchar(' ');
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 0057 
; 0000 0058  delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0059  }
	RJMP _0xC
; 0000 005A         }
; 0000 005B       }
_0xB:
; 0000 005C 
; 0000 005D 
; 0000 005E A:{
_0x17:
; 0000 005F lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x0
; 0000 0060 lcd_puts("HH MM SS");
	__POINTW2MN _0x3,29
	CALL _lcd_puts
; 0000 0061 
; 0000 0062 counter=0;
	LDI  R30,LOW(0)
	STD  Y+12,R30
	STD  Y+12+1,R30
; 0000 0063 while(1) {
_0x18:
; 0000 0064 
; 0000 0065 if (ERROR==1){ERROR=70;counter=2;}
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x1B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0066 if (ERROR==2){ERROR=70;counter=4;}
_0x1B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRNE _0x1C
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0067 k = 10;
_0x1C:
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 0068 PORTD = 0XF0;
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 0069 //ROW1
; 0000 006A PORTD.4 = 0;
	CBI  0x12,4
; 0000 006B delay_ms(5);
	CALL SUBOPT_0x8
; 0000 006C if(PIND.0 == 0){k = 1;while(PIND.0 == 0);}
	SBIC 0x10,0
	RJMP _0x1F
	LDI  R30,LOW(1)
	MOV  R5,R30
_0x20:
	SBIS 0x10,0
	RJMP _0x20
; 0000 006D if(PIND.1 == 0){k = 2;while(PIND.1 == 0);}
_0x1F:
	SBIC 0x10,1
	RJMP _0x23
	LDI  R30,LOW(2)
	MOV  R5,R30
_0x24:
	SBIS 0x10,1
	RJMP _0x24
; 0000 006E if(PIND.2 == 0){k = 3;while(PIND.2 == 0);}
_0x23:
	SBIC 0x10,2
	RJMP _0x27
	LDI  R30,LOW(3)
	MOV  R5,R30
_0x28:
	SBIS 0x10,2
	RJMP _0x28
; 0000 006F PORTD.4 = 1;
_0x27:
	SBI  0x12,4
; 0000 0070 //ROW2
; 0000 0071 PORTD.5 = 0;
	CBI  0x12,5
; 0000 0072 delay_ms(5);
	CALL SUBOPT_0x8
; 0000 0073 if(PIND.0 == 0){k = 4;while(PIND.0 == 0);}
	SBIC 0x10,0
	RJMP _0x2F
	LDI  R30,LOW(4)
	MOV  R5,R30
_0x30:
	SBIS 0x10,0
	RJMP _0x30
; 0000 0074 if(PIND.1 == 0){k = 5;while(PIND.1 == 0);}
_0x2F:
	SBIC 0x10,1
	RJMP _0x33
	LDI  R30,LOW(5)
	MOV  R5,R30
_0x34:
	SBIS 0x10,1
	RJMP _0x34
; 0000 0075 if(PIND.2 == 0){k = 6;while(PIND.2 == 0);}
_0x33:
	SBIC 0x10,2
	RJMP _0x37
	LDI  R30,LOW(6)
	MOV  R5,R30
_0x38:
	SBIS 0x10,2
	RJMP _0x38
; 0000 0076 PORTD.5 = 1;
_0x37:
	SBI  0x12,5
; 0000 0077 //ROW3
; 0000 0078 PORTD.6 = 0;
	CBI  0x12,6
; 0000 0079 delay_ms(5);
	CALL SUBOPT_0x8
; 0000 007A if(PIND.0 == 0){k = 7;while(PIND.0 == 0);}
	SBIC 0x10,0
	RJMP _0x3F
	LDI  R30,LOW(7)
	MOV  R5,R30
_0x40:
	SBIS 0x10,0
	RJMP _0x40
; 0000 007B if(PIND.1 == 0){k = 8;while(PIND.1 == 0);}
_0x3F:
	SBIC 0x10,1
	RJMP _0x43
	LDI  R30,LOW(8)
	MOV  R5,R30
_0x44:
	SBIS 0x10,1
	RJMP _0x44
; 0000 007C if(PIND.2 == 0){k = 9;while(PIND.2 == 0);}
_0x43:
	SBIC 0x10,2
	RJMP _0x47
	LDI  R30,LOW(9)
	MOV  R5,R30
_0x48:
	SBIS 0x10,2
	RJMP _0x48
; 0000 007D PORTD.6 = 1;
_0x47:
	SBI  0x12,6
; 0000 007E //ROW4
; 0000 007F PORTD.7 = 0;
	CBI  0x12,7
; 0000 0080 delay_ms(5);
	CALL SUBOPT_0x8
; 0000 0081 if(PIND.0 == 0){k = 11;while(PIND.0 == 0);}
	SBIC 0x10,0
	RJMP _0x4F
	LDI  R30,LOW(11)
	MOV  R5,R30
_0x50:
	SBIS 0x10,0
	RJMP _0x50
; 0000 0082 if(PIND.1 == 0){k = 0;while(PIND.1 == 0);}
_0x4F:
	SBIC 0x10,1
	RJMP _0x53
	CLR  R5
_0x54:
	SBIS 0x10,1
	RJMP _0x54
; 0000 0083 if(PIND.2 == 0){k = 12;while(PIND.2 == 0);}
_0x53:
	SBIC 0x10,2
	RJMP _0x57
	LDI  R30,LOW(12)
	MOV  R5,R30
_0x58:
	SBIS 0x10,2
	RJMP _0x58
; 0000 0084 PORTD.7 = 1;
_0x57:
	SBI  0x12,7
; 0000 0085 if(k != 10){ if (k!=11){TIM = k; }
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE PC+2
	RJMP _0x5D
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x5E
	MOV  R30,R5
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0086 if (k==11){timer=1;sadsecond=0;goto U;}
_0x5E:
	LDI  R30,LOW(11)
	CP   R30,R5
	BRNE _0x5F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
	RJMP _0xA
; 0000 0087 if(k==12){lcd_clear();goto A;}
_0x5F:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE _0x60
	CALL _lcd_clear
	RJMP _0x17
; 0000 0088 
; 0000 0089 PORTB=k;
_0x60:
	OUT  0x18,R5
; 0000 008A counter=counter+1;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 008B if(counter==1){hour=TIM;};
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x61
	__GETWRS 20,21,10
_0x61:
; 0000 008C if(counter==2){hour=hour*10+TIM;} ;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0x62
	MOVW R30,R20
	CALL SUBOPT_0x9
	MOVW R20,R30
_0x62:
; 0000 008D itoa(hour,str_hour);
	CALL SUBOPT_0x1
; 0000 008E lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2
; 0000 008F lcd_puts(str_hour);
	CALL SUBOPT_0x3
; 0000 0090 lcd_putchar(' ');
; 0000 0091 lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0000 0092 lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 0093 
; 0000 0094 if(counter==3){minute=TIM;} ;
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,3
	BRNE _0x63
	__GETWRS 18,19,10
_0x63:
; 0000 0095 if(counter==4){minute=10*minute+TIM;};
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,4
	BRNE _0x64
	MOVW R30,R18
	CALL SUBOPT_0x9
	MOVW R18,R30
_0x64:
; 0000 0096 itoa(minute,str_minute);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,18
	CALL _itoa
; 0000 0097 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2
; 0000 0098 lcd_puts(str_minute);
	CALL SUBOPT_0x5
; 0000 0099 lcd_putchar(' ');
; 0000 009A lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2
; 0000 009B lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 009C 
; 0000 009D if(counter==5){second=TIM;};
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,5
	BRNE _0x65
	__GETWRS 16,17,10
_0x65:
; 0000 009E if(counter==6){second=second*10+TIM;break;};
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,6
	BRNE _0x66
	MOVW R30,R16
	CALL SUBOPT_0x9
	MOVW R16,R30
	RJMP _0x1A
_0x66:
; 0000 009F itoa(second,str_second);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,19
	CALL _itoa
; 0000 00A0 lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2
; 0000 00A1 lcd_puts(str_second);
	CALL SUBOPT_0x7
; 0000 00A2 lcd_putchar(' ');
; 0000 00A3 lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2
; 0000 00A4 lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 00A5 
; 0000 00A6 };
_0x5D:
; 0000 00A7 
; 0000 00A8 }
	RJMP _0x18
_0x1A:
; 0000 00A9 }
; 0000 00AA 
; 0000 00AB if(hour>24){PORTB=14;goto A;}
	__CPWRN 20,21,25
	BRLT _0x67
	LDI  R30,LOW(14)
	OUT  0x18,R30
	RJMP _0x17
; 0000 00AC if(minute>59){ERROR=1;PORTB=14;goto A;}
_0x67:
	__CPWRN 18,19,60
	BRLT _0x68
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(14)
	OUT  0x18,R30
	RJMP _0x17
; 0000 00AD if(second>59){ERROR=2;PORTB=14;goto A;}
_0x68:
	__CPWRN 16,17,60
	BRLT _0x69
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(14)
	OUT  0x18,R30
	RJMP _0x17
; 0000 00AE 
; 0000 00AF PORTB=13;
_0x69:
	LDI  R30,LOW(13)
	OUT  0x18,R30
; 0000 00B0 
; 0000 00B1 
; 0000 00B2 
; 0000 00B3    DDRC.1=0xFF ;
	SBI  0x14,1
; 0000 00B4    DDRC.0=0xFF ;
	SBI  0x14,0
; 0000 00B5 
; 0000 00B6 while(1){
_0x6E:
; 0000 00B7 
; 0000 00B8 second++;
	__ADDWRN 16,17,1
; 0000 00B9 
; 0000 00BA if(second==60){second=0;minute++;}
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x71
	__GETWRN 16,17,0
	__ADDWRN 18,19,1
; 0000 00BB if(minute==60){minute=0;hour++;}
_0x71:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x72
	__GETWRN 18,19,0
	__ADDWRN 20,21,1
; 0000 00BC if(hour==24){hour=0;}
_0x72:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x73
	__GETWRN 20,21,0
; 0000 00BD 
; 0000 00BE if(second==0&minute==15){PORTC.1=1;shomarande=0;goto D;}
_0x73:
	CALL SUBOPT_0xA
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x74
	CALL SUBOPT_0xB
	RJMP _0x77
; 0000 00BF if(second==0&minute==30){PORTC.1=1;shomarande=0;goto D;}
_0x74:
	CALL SUBOPT_0xA
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x78
	CALL SUBOPT_0xB
	RJMP _0x77
; 0000 00C0 if(second==0&minute==45){PORTC.1=1;shomarande=0;goto D;}
_0x78:
	CALL SUBOPT_0xA
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x7B
	CALL SUBOPT_0xB
	RJMP _0x77
; 0000 00C1 if(second==0&minute==0){PORTC.1=0;PORTC.0=1;PORTC.1=1;shomarande=0;goto D;}
_0x7B:
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x7E
	CBI  0x15,1
	SBI  0x15,0
	CALL SUBOPT_0xB
; 0000 00C2 
; 0000 00C3 D:{shomarande++;}
_0x7E:
_0x77:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00C4 if (shomarande == 3){PORTC.0=0;PORTC.1=0;}
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRNE _0x85
	CBI  0x15,0
	CBI  0x15,1
; 0000 00C5 
; 0000 00C6 
; 0000 00C7 //////////////////////////////////////
; 0000 00C8 itoa(hour,str_hour);
_0x85:
	CALL SUBOPT_0x1
; 0000 00C9 lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2
; 0000 00CA if(hour<10)
	__CPWRN 20,21,10
	BRGE _0x8A
; 0000 00CB lcd_puts("0");
	__POINTW2MN _0x3,38
	CALL _lcd_puts
; 0000 00CC lcd_puts(str_hour);
_0x8A:
	CALL SUBOPT_0x3
; 0000 00CD lcd_putchar(' ');
; 0000 00CE lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
; 0000 00CF lcd_putchar(':');
	CALL SUBOPT_0x4
; 0000 00D0 ///////////////////////////////////////
; 0000 00D1 itoa(minute,str_minute);
; 0000 00D2 lcd_gotoxy(7,1);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2
; 0000 00D3 if(minute<10)
	__CPWRN 18,19,10
	BRGE _0x8B
; 0000 00D4 lcd_puts("0");
	__POINTW2MN _0x3,40
	CALL _lcd_puts
; 0000 00D5 lcd_puts(str_minute);
_0x8B:
	CALL SUBOPT_0x5
; 0000 00D6 lcd_putchar(' ');
; 0000 00D7 lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2
; 0000 00D8 lcd_putchar(':');
	CALL SUBOPT_0x6
; 0000 00D9 ///////////////////////////////////////
; 0000 00DA itoa(second,str_second);
; 0000 00DB lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2
; 0000 00DC if(second<10)
	__CPWRN 16,17,10
	BRGE _0x8C
; 0000 00DD lcd_puts("0");
	__POINTW2MN _0x3,42
	CALL _lcd_puts
; 0000 00DE lcd_puts(str_second);
_0x8C:
	CALL SUBOPT_0x7
; 0000 00DF lcd_putchar(' ');
; 0000 00E0 lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2
; 0000 00E1 lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 00E2 //////////////////////////////////////
; 0000 00E3 
; 0000 00E4  delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00E5 
; 0000 00E6 
; 0000 00E7 
; 0000 00E8 
; 0000 00E9     }
	RJMP _0x6E
; 0000 00EA 
; 0000 00EB 
; 0000 00EC     }
_0x8D:
	RJMP _0x8D
; .FEND

	.DSEG
_0x3:
	.BYTE 0x2C
;
;
;
;
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20A0001
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R4,Y+1
	LDD  R7,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R4,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	CP   R4,R6
	BRLO _0x2000004
	__lcd_putchar1:
	INC  R7
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R7
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	INC  R4
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20A0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20A0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LDD  R6,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	CALL SUBOPT_0xD
	LDI  R26,LOW(4)
	CALL SUBOPT_0xD
	LDI  R26,LOW(133)
	CALL SUBOPT_0xD
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20A0001
_0x200000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	ST   -Y,R21
	ST   -Y,R20
	MOVW R26,R28
	ADIW R26,17
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	MOVW R26,R28
	ADIW R26,15
	CALL _lcd_puts
	LDI  R26,LOW(32)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(58)
	CALL _lcd_putchar
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,18
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	MOVW R26,R28
	ADIW R26,16
	CALL _lcd_puts
	LDI  R26,LOW(32)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(58)
	CALL _lcd_putchar
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,19
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	MOVW R26,R28
	ADIW R26,17
	CALL _lcd_puts
	LDI  R26,LOW(32)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	MOVW R26,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	SBI  0x15,1
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __lcd_write_data
	JMP  __long_delay_G100


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

;END OF CODE MARKER
__END_OF_CODE:
