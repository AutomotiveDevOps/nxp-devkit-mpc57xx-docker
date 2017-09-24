E200MK_DIR:=$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

VLE_TOOLCHAIN_DIR:=${E200MK_DIR}/powerpc-eabivle-4_9

PREFIX:=${VLE_TOOLCHAIN_DIR}/bin/powerpc-eabivle-


CC      = ${PREFIX}gcc
CXX     = ${PREFIX}g++
OBJCOPY = ${PREFIX}objcopy
OBJDUMP = ${PREFIX}objdump
SIZE    = ${PREFIX}size

C_FLAGS=-DSTART_FROM_FLASH -DMPC574xP -I"/home/jafrey/workspaceS32DS.Power/ADC_MPC5744P/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include/pa" -O0 -g3 -Wall -c -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mbig -mvle -mregnames -mhard-float --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"
C_CMD=${COMMAND} ${FLAGS} -c ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

LD_FLAGS=-T "/home/jafrey/workspaceS32DS.Power/ADC_MPC5744P/Project_Settings/Linker_Files/57xx_flash.ld" -T "/home/jafrey/workspaceS32DS.Power/ADC_MPC5744P/Project_Settings/Linker_Files/libs.ld" -Wl,-Map,"ADC_MPC5744P.map" -Xlinker --gc-sections -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mhard-float --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"
LD_CMD=${COMMAND} ${FLAGS} ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

AS_FLAGS=-I"/home/jafrey/workspaceS32DS.Power/ADC_MPC5744P/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include/pa" -x assembler-with-cpp -DSTART_FROM_FLASH -DMPC574xP -O0 -g3 -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mbig -mvle -mregnames --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"

AS_CMD=${COMMAND} ${FLAGS} -c ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

# Preprocessor
# ${cross_prefix}${cross_c}${cross_suffix}
# -E
# ${COMMAND} ${FLAGS} ${INPUTS}

# Disassembler
# ${cross_prefix}objdump${cross_suffix}
# -d -S -x
# ${COMMAND} ${FLAGS} ${INPUTS}

# linking rule remains the same as before.
$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(PROG)

# now comes a meta-rule for compiling any "C" source file.

SRCS=$(wildcard $(ProjDirPath)/src/*.c)
OBJS=$(SRCS:.c=.o)

%.o: %.c
	$(CC) $(C_FLAGS) -c $<


.DEFAULT: var
.PHONY: var
var:
	@echo ${OBJS}
	
.PHONY: obj
obj: ${OBJS}

S32DS:=/opt/NXP/S32DS_Power_v1.2

comp:
	${CC} ${C_FLAGS}

.PHONY: init
init: powerpc-eabivle-4_9 e200_ewl2 Examples


powerpc-eabivle-4_9:
	cp -R ${S32DS}/Cross_Tools/powerpc-eabivle-4_9 ./

Examples:
	cp -R ${S32DS}/eclipse/plugins/com.freescale.s32ds.e200.examples.descriptor_1.0.0.201705101131/Examples ./

e200_ewl2:
	cp -R ${S32DS}/S32DS/e200_ewl2 ./
