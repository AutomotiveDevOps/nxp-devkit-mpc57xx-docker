CROSS_DIR := /projects/DEVKIT-Makefile/powerpc-eabivle-4_9
CROSS_PREFIX=powerpc-eabivle-

E200MK_DIR:=/projects/DEVKIT-Makefile

DIR = $(notdir $(realpath $(dir $(realpath ${lastword ${MAKEFILE_LIST}}))))

C = ${CROSS_DIR}/bin/${CROSS_PREFIX}gcc

SRC = $(wildcard src/*.c)
OBJ = $(patsubst %.c,%.o,${SRC})

# E200MK_DIR:=$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

C_FLAGS = -DSTART_FROM_FLASH \
-DMPC574xP \
-I"/home/jafrey/workspaceS32DS.Power/ADC_MPC5744P/include" \
-I"/opt/NXP/S32DS_Power_v1.2/S32DS/e200_ewl2/EWL_C/include" \
-I"/opt/NXP/S32DS_Power_v1.2/S32DS/e200_ewl2/EWL_C/include/pa" \
-O0 \
-g3 \
-Wall \
-c \
-fmessage-length=0 \
-fsigned-char \
-ffunction-sections \
-fdata-sections \
-mcpu=e200z4 \
-specs=ewl_c9x_noio.specs \
-mbig \
-mvle \
-mregnames \
-mhard-float \
--sysroot="/opt/NXP/S32DS_Power_v1.2/S32DS/e200_ewl2"

SYMBOLS+=START_FROM_FLASH
SYMBOLS+=MPC574xP

SYMBOL_PARAMS=$(foreach d, $(SYMBOLS), -D$d)

INC_PARAMS=$(foreach d, $(E200_INC), -I"$d")

.DEFAULT: objects
.PHONY: objects
objects: ${OBJ}

%.o: %.c
	@echo 'Building file: $<'
	@$(C) $(C_FLAGS) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"

.PHONY: clean
clean:
	@rm -rf ${OBJ}
	
vars:
	@echo $(C) $(C_FLAGS)

include ${E200MK_DIR}/include.mk
