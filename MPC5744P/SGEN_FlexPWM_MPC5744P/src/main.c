/* main.c - SGEN-FlexPWM example for MPC5744P */
/* Description:  Measures eTimer pulse/period measurement */
/* Rev 1 Sept 06 2016 D Chung - initial version */
/* Copyright NXP Semiconductor, Inc 2016 All rights reserved. */

/*******************************************************************************
* NXP Semiconductor Inc.
* (c) Copyright 2016 NXP Semiconductor, Inc.
* ALL RIGHTS RESERVED.
********************************************************************************
Services performed by NXP in this matter are performed AS IS and without
any warranty. CUSTOMER retains the final decision relative to the total design
and functionality of the end product. NXP neither guarantees nor will be
held liable by CUSTOMER for the success of this project.
NXP DISCLAIMS ALL WARRANTIES, EXPRESSED, IMPLIED OR STATUTORY INCLUDING,
BUT NOT LIMITED TO, IMPLIED WARRANTY OF MERCHANTABILITY OR FITNESS FOR
A PARTICULAR PURPOSE ON ANY HARDWARE, SOFTWARE ORE ADVISE SUPPLIED TO THE PROJECT
BY NXP, AND OR NAY PRODUCT RESULTING FROM NXP SERVICES. IN NO EVENT
SHALL NXP BE LIABLE FOR INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF
THIS AGREEMENT.

CUSTOMER agrees to hold NXP harmless against any and all claims demands or
actions by anyone on account of any damage, or injury, whether commercial,
contractual, or tortuous, rising directly or indirectly as a result of the advise
or assistance supplied CUSTOMER in connection with product, services or goods
supplied under this Agreement.
********************************************************************************
* File              main.c
* Owner             David Chung
* Version           1.0
* Date              Sept-6-2016
* Classification    General Business Information
* Brief            	FlexPWM and SGEN synchronization
*                    RUN0 mode with max core frequency(200MHz) generated from PLL1
********************************************************************************
* Detailed Description:
* This example shows usage of FlexPWM and Sine Wave generator (SGEN) modules.
* The setting is selected in the way to have a PWM output signal synchronized with
* SWG output signal. This is necessary for resolver usage in motor control appls.
*
* See attached Excel sheet for calculation of parammeters used here (AUX0_clk_DIV0,
* AUX0_clk_DIV1, SGEN_IOFREQ, PWM_PRESCALER, PWM_MODULO).
*
* This example is set for 2.44140625 kHz SGEN/PWM frequency.
* ------------------------------------------------------------------------------
* Test HW:         XDEVKIT-MPC5744P
* MCU:             MPC5744P
* Terminal:        None
* Fsys:            200 MHz PLL on 40MHz external oscillator
* Debugger:        OpenSDA
* Target:          FLASH
* EVB connection:  D[7] (J5_6).. SGEN output to oscilloscope.
*
* 					A[11] (J1_5).. FlexPWM A[0] output to oscilloscope
* 					A[10] (J1_7).. FlexPWM B[0] output to oscilloscope
*
********************************************************************************
Revision History:
Version  Date         Author  			Description of Changes
1.0      Sept-06-2016  David Chung	  	Initial version

*******************************************************************************/

/*******************************************************************************
* Includes
*******************************************************************************/
#include "MPC5744P.h"

/*******************************************************************************
* Constants and macros
*******************************************************************************/

#define AUX0_clk_DIV1 	7
#define SGEN_IOFREQ 	128

#define AUX0_clk_DIV0 	0
#define PWM_PRESCALER	4
#define PWM_MODULO 	4096

/*******************************************************************************
* External objects
*******************************************************************************/
extern void xcptn_xmpl(void);

/*******************************************************************************
* Global variables
*******************************************************************************/
//extern const uint32_t IntcIsrVectorTable[];
//extern void xcptn_xmpl(void);

/*******************************************************************************
* Local functions
*******************************************************************************/

/*******************************************************************************
Function Name : Sys_Init
Engineer      : PetrS
Date          : Apr-14-2015
Parameters    : NONE
Modifies      : NONE
Returns       : NONE
Notes         : Enable XOSC, PLL0, PLL1 and enter RUN0 with PLL1 as sys clk (200 MHz)
Issues        : NONE
*******************************************************************************/
void SysClk_Init(void)
{
    MC_CGM.AC3_SC.B.SELCTL = 0x01;		    //connect XOSC to the PLL0 input
    MC_CGM.AC4_SC.B.SELCTL = 0x01;		    //connect XOSC to the PLL1 input

    // Set PLL0 to 160 MHz with 40MHz XOSC reference
    PLLDIG.PLL0DV.R = 0x28021008;	     // PREDIV =  1, MFD = 8, RFDPHI = 2, RFDPHI1 = 5
    MC_ME.RUN0_MC.R = 0x00130070;		    // RUN0 cfg: IRCON,OSC0ON,PLL0ON,syclk=IRC

    // Mode Transition to enter RUN0 mode:
    MC_ME.MCTL.R = 0x40005AF0;		    // Enter RUN0 Mode & Key
    MC_ME.MCTL.R = 0x4000A50F;		    // Enter RUN0 Mode & Inverted Key
    while (MC_ME.GS.B.S_MTRANS) {};		    // Wait for mode transition to complete
    while(MC_ME.GS.B.S_CURRENT_MODE != 4) {};	    // Verify RUN0 is the current mode

    // Set PLL1 to 200 MHz with 40MHz XOSC reference
    PLLDIG.PLL1DV.R = 0x00020014;	     // MFD = 20, RFDPHI = 2
//    MC_ME.RUN_PC[0].R = 0x000000FE;		    // enable peripherals run in all modes
    MC_ME.RUN_PC[1].R = 0x000000FE;			//Enable peripherals to run in all modes if they follow RUN_PC[1]
    MC_ME.PCTL239.B.RUN_CFG = 1;			//Make SGEN follow RUN_PC[1]
    MC_ME.PCTL255.B.RUN_CFG = 1;			//Make FlexPWM0 follow RUN_PC[1]
    MC_ME.RUN0_MC.R = 0x001300F4;		    // RUN0 cfg: IRCON, OSC0ON, PLL1ON, syclk=PLL1
    MC_CGM.SC_DC0.R = 0x80030000;    // PBRIDGE0/PBRIDGE1_CLK at syst clk div by 4 ... (50 MHz)

    // Mode Transition to enter RUN0 mode:
    MC_ME.MCTL.R = 0x40005AF0;		    // Enter RUN0 Mode & Key
    MC_ME.MCTL.R = 0x4000A50F;		    // Enter RUN0 Mode & Inverted Key
    while (MC_ME.GS.B.S_MTRANS) {};		    // Wait for mode transition to complete
    while(MC_ME.GS.B.S_CURRENT_MODE != 4) {};	    // Verify RUN0 is the current mode

    // set peripheral clocks
    MC_CGM.AC0_SC.R = 0x02000000;    // Select PLL0 for auxiliary clock 0
    MC_CGM.AC0_DC0.R = 0x80000000|(AUX0_clk_DIV0<<16);    // MOTC_CLK : Enable aux clk 0 div by (AUX0_clk_DIV0+1)
    MC_CGM.AC0_DC1.R = 0x80000000|(AUX0_clk_DIV1<<16);    // SGEN_CLK : Enable aux clk 0 div by (AUX0_clk_DIV1+1)

}

/*******************************************************************************
Function Name : SUIL2_Init
Engineer      : PetrS
Date          : Apr-14-2015
Parameters    : NONE
Modifies      : NONE
Returns       : NONE
Notes         : SIUL2 initialization (ports)
Issues        : NONE
*******************************************************************************/
void SUIL2_Init(void)
{
	SIUL2.MSCR[55].R = 0x02000000; // D[7] pin as SGEN output

    SIUL2.MSCR[11].R = 0x02800002; // A[11] pin as FlexPWM A[0] output
    SIUL2.MSCR[10].R = 0x02800002; // A[10] pin as FlexPWM B[0] output

}

/*******************************************************************************
Function Name : FlexPWM_Init
Engineer      : PetrS
Date          : Apr-14-2015
Parameters    : NONE
Modifies      : NONE
Returns       : NONE
Notes         : FlexPWM initialization
Issues        : NONE
*******************************************************************************/
static void FlexPWM_Init(void)
{
    /* Submodule 0 Initialisation */
    FlexPWM_0.OUTEN.R           = 0x110;	// enable A and B outputs on submodule 0

    FlexPWM_0.SUB[0].CTRL1.R    = 0x0400|(PWM_PRESCALER<<4);	// full cycle reload, every opportunity
    FlexPWM_0.SUB[0].CTRL2.R    = 0x2000;	// independent outputs
    FlexPWM_0.SUB[0].DTCNT0.R   = 0x0000;	// deadtime values
    FlexPWM_0.SUB[0].DTCNT1.R   = 0x0000;
    FlexPWM_0.SUB[0].INIT.R   = 0x1;
    FlexPWM_0.SUB[0].VAL1.R   = PWM_MODULO;	// PWM modulo
    FlexPWM_0.SUB[0].VAL2.R   = 0x1;   		// PWM A0 rising edge
    FlexPWM_0.SUB[0].VAL3.R   = PWM_MODULO/3;	// PWM A0 falling edge
    FlexPWM_0.SUB[0].VAL4.R   = PWM_MODULO/2;	// PWM B0 rising edge
//	FlexPWM_0.SUB[0].VAL4.R = 0x1;
    FlexPWM_0.SUB[0].VAL5.R   = PWM_MODULO;	// PWM B0 falling edge
    FlexPWM_0.SUB[0].DISMAP.R   = 0x0000;	// disable fault pin condition

    FlexPWM_0.MCTRL.B.LDOK = 0x1;	/* Load the PRSC bits of CTRL1 and the INIT, and VALx registers
    								   into a set of buffers */
	
}

/*******************************************************************************
Function Name : SGEN_Init
Engineer      : PetrS
Date          : Apr-14-2015
Parameters    : NONE
Modifies      : NONE
Returns       : NONE
Notes         : Sine Wave Generator initialization
Issues        : NONE
*******************************************************************************/
static void SGEN_Init(void)
{
	SGEN_0.CTRL.B.LDOS = 0;
	SGEN_0.CTRL.B.IOAMPL = 0xf;	// max amplitude
	SGEN_0.CTRL.B.IOFREQ = SGEN_IOFREQ;
	SGEN_0.CTRL.B.PDS = 0;

}

/*******************************************************************************
* Global functions
*******************************************************************************/
int main (void)
{
    unsigned short i=1,j = 0;

    xcptn_xmpl();

    SysClk_Init();
    SUIL2_Init();
    FlexPWM_Init();
    SGEN_Init();

    SGEN_0.CTRL.B.LDOS = 1;
    FlexPWM_0.MCTRL.B.RUN = 0x1;		// Submodule 0 PWM generator enabled


    while(1)
    {
#if 1
	for(j=0;j<10000;j++){}

	if(i<PWM_MODULO) FlexPWM_0.SUB[0].VAL3.R = i;
//	if(i<PWM_MODULO) FlexPWM_0.SUB[0].VAL5.R = i;
	else
	{
	    if(i<2*PWM_MODULO) FlexPWM_0.SUB[0].VAL3.R = (2*PWM_MODULO) - i;
//		if(i<2*PWM_MODULO) FlexPWM_0.SUB[0].VAL5.R = (2*PWM_MODULO) - i;
	    else i=1;
	}
	i++;
	FlexPWM_0.MCTRL.B.LDOK = 0x1;
#endif

    }
    return 0;
}//main
