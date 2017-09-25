
E200MK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
VLE_EWL_DIR := ${E200MK_DIR}/e200_ewl2
PROJ_DIR=/projects/DEVKIT-Makefile/Examples/MPC5744P/ADC_MPC5744P
ProjDirPath:=$(PROJ_DIR)

E200_INC += ${E200MK_DIR}/powerpc-eabivle-4_9/lib/gcc/powerpc-eabivle/4.9.4/include
E200_INC += ${E200MK_DIR}/powerpc-eabivle-4_9/lib/gcc/powerpc-eabivle/4.9.4/include-fixed
E200_INC += ${E200MK_DIR}/powerpc-eabivle-4_9/powerpc-eabivle/include
E200_INC += ${E200MK_DIR}/powerpc-eabivle-4_9/powerpc-eabivle/usr/include
E200_IRC += ${ProjDirPath}/include
E200_INC += ${VLE_EWL_DIR}/EWL_C/include
E200_INC += ${VLE_EWL_DIR}/EWL_C/include/pa

/opt/NXP/S32DS_Power_v1.2/Cross_Tools/powerpc-eabivle-4_9/bin/../lib/gcc/powerpc-eabivle/4.9.4/../../../../powerpc-eabivle/bin/as -I /home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/include -I /opt/NXP/S32DS_Power_v1.2/S32DS/e200_ewl2/EWL_C/include -I /opt/NXP/S32DS_Power_v1.2/S32DS/e200_ewl2/EWL_C/include/pa -mvle -me200z4 -mvle -many -mbig -o src/mode.o /tmp/ccYCiH6L.s
l

SYMBOLS+=START_FROM_FLASH
SYMBOLS+=MPC574xP

SYMBOL_PARAMS=$(foreach d, $(SYMBOLS), -D$d)

INC_PARAMS=$(foreach d, $(E200_INC), -I"$d")

ARCH=e200
VENDOR=Freescale
CHIP=MPC5744P
CORE=e200z4204n3
FAMILY=MPC574xP

CORE=e200z4251n3



C_FLAGS = -O0 -g3 -Wall -c -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mbig -mvle -mregnames -mhard-float --sysroot="${EWL2_DIR}" ${INC_PARAMS}
