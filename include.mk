##########
# DEVKIT-Makefile
# Makefile for NXP's DEVKIT-MPC5744P & DEVKIT-MPC5748G developmend boards
##########

# Determine the Project's Directory
ifndef PROJ_DIR
	PROJ_DIR:=$(realpath $(dir $(realpath ${firstword ${MAKEFILE_LIST}})))
endif

# Determine the DEVKIT-Makefile directory.
ifndef E200MK_DIR
	E200MK_DIR:=$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif
	
# Include board configuration
include ${E200MK_DIR}/boards.mk
include ${E200MK_DIR}/Common.mk

# Determine the toolchain and ewl directories.
ifndef VLE_TOOLCHAIN_DIR
	VLE_TOOLCHAIN_DIR := ${E200MK_DIR}/powerpc-eabivle-4_9
endif

ifndef VLE_EWL_DIR
	VLE_EWL_DIR:=${E200MK_DIR}/e200_ewl2
endif

# Prefix for cross compiler
CROSS_PREFIX:=powerpc-eabivle-
# Standard compiler utils
CC      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}gcc
CXX     := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}g++
LD     := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}ld
OBJCOPY := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objcopy
OBJDUMP := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objdump
SIZE    := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}size
NM      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}nm

# Determine the root binary project name.
BIN_ROOT:=${notdir ${PROJ_DIR}}
ELF:=${BIN_ROOT}.elf
HEX:=${BIN_ROOT}.hex
BIN:=${BIN_ROOT}.bin
S19:=${BIN_ROOT}.S19

# Complier & Linker Setup
ifndef SYSROOT
	SYSROOT=${VLE_EWL_DIR}
endif

ifndef SPECS
	SPECS=ewl_c9x_noio.specs
endif

# Gather source files.
SRC_C += ${realpath ${wildcard ${PROJ_DIR}/src/*.c}}
SRC_S += ${realpath ${wildcard ${PROJ_DIR}/src/*.S}}

# Calculate
OBJ_C = $(patsubst %.c,%.o,${SRC_C})
OBJ_S = $(patsubst %.S,%.o,${SRC_S})
OBJS = ${OBJ_C} ${OBJ_S}

# Include Directories
INCLUDE += ${PROJ_DIR}/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include/pa

# C Flags
C_FLAGS += -std=${C_STD}
C_FLAGS += $(foreach d, $(SYMBOLS),-D$d)
C_FLAGS += $(foreach d, $(OPT_FLAGS),-f$d)
C_FLAGS += $(foreach d, $(MACH_OPTS),-m$d)
C_FLAGS += -W${WARNINGS}
C_FLAGS += -g${DEBUG_LVL}
C_FLAGS += -specs=${SPECS}
C_FLAGS += --sysroot="${SYSROOT}"
C_FLAGS += $(foreach d, $(INCLUDE),-I"$d")

# Linker Flags
LD_FLAGS += $(foreach d, $(SRC_LD),-T"$d")
LD_FLAGS += -Wl,-Map,"${BIN_ROOT}.map"
LD_FLAGS += -Xlinker
LD_FLAGS += --gc-sections
LD_FLAGS += $(foreach d, $(MACH_OPTS),-m$d)
LD_FLAGS += -specs=${SPECS}
LD_FLAGS += --sysroot="${SYSROOT}"

.DEFAULT: all
.PHONY: all
all: ${ELF} ${HEX} ${BIN} ${S19}

.PHONY: flash
flash: ${ELF}
	osf flash ${ELF}

.PHONY: elf hex bin s19
elf: ${ELF}
hex: ${HEX}
bin: ${BIN}
s19: ${S19}

${ELF}: ${OBJS}
	${CC} ${LD_FLAGS} ${OBJS} -o "$@"

${HEX}: ${ELF}
	${OBJCOPY} --strip-all --output-target ihex $< "$@"
	
${BIN}: ${ELF}
	${OBJCOPY} --strip-all --output-target binary $< "$@"
	
${S19}: ${ELF}
	${OBJCOPY} --strip-all --output-target srec $< $@

.PHONY: clean
clean:
	-${RM} ${ELF}
	-${RM} ${HEX}
	-${RM} ${BIN}
	-${RM} ${S19}

%.o: %.c
	$(file >$@.in) $(foreach O,${C_FLAGS},$(file >>$@.in,$O))
	$(CC) -o "$@" -c "$<" @$@.in 
	
%.o: %.S
	$(file >$@.in) $(foreach O,${C_FLAGS},$(file >>$@.in,$O))
	$(CC) $(C_FLAGS) -o "$@" -c "$<"
