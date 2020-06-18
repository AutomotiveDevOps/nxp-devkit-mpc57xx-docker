##########
# DEVKIT-Makefile
# Makefile for NXP's DEVKIT-MPC5744P & DEVKIT-MPC5748G developmend boards
#
# MIT License
#
# Copyright (c) 2018 Jed Smith
# Copyright (c) 2020 AutomotiveDevOps
# Copyright (c) 1954 NXP/FreeScale/Motorola (They probably have something around here too)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##########

# Error out if PROJ_NAME isn't defined.
ifndef PROJ_NAME
$(error PROJ_NAME is undefined)
endif

# Determine the Project's Directory
SRC_DIR:=/S32DS/build
# Determine the DEVKIT-Makefile directory.
S32DS_BUILD_TOOLS:=/S32DS/build_tools
# Include board configuration

#### Start MPC5744P
CPU=e200z4
SYMBOLS += MPC574xP

# Startup Assembly
SRC_S += ${realpath ${wildcard ${SRC_DIR}/Project_Settings/Startup_Code/*.S}}
# Linker Files.
SRC_LD += ${realpath ${SRC_DIR}/Project_Settings/Linker_Files/libs.ld}

# Determine if we are loading from RAM
ifndef RAM
	SRC_LD += ${realpath ${SRC_DIR}/Project_Settings/Linker_Files/57xx_flash.ld}
	SYMBOLS += START_FROM_FLASH
else
	SRC_LD += ${realpath ${SRC_DIR}/Project_Settings/Linker_Files/57xx_ram.ld}
endif
	
ifndef OPT_FLAGS
	OPT_FLAGS+=message-length=0
	OPT_FLAGS+=signed-char
	OPT_FLAGS+=function-sections
	OPT_FLAGS+=data-sections
endif

ifndef MACH_OPTS
	MACH_OPTS+=cpu=${CPU}
	MACH_OPTS+=big
	MACH_OPTS+=vle
	MACH_OPTS+=regnames
	MACH_OPTS+=hard-float
endif

# Determine the toolchain and ewl directories.
ifndef VLE_TOOLCHAIN_DIR
	VLE_TOOLCHAIN_DIR := ${S32DS_BUILD_TOOLS}/powerpc-eabivle-4_9
endif
VLE_TOOLCHAIN_DIR:=$(realpath ${VLE_TOOLCHAIN_DIR})

ifndef VLE_EWL_DIR
	VLE_EWL_DIR:=${S32DS_BUILD_TOOLS}/e200_ewl2
endif
VLE_EWL_DIR:=$(realpath ${VLE_EWL_DIR})

# Prefix for cross compiler
CROSS_PREFIX:=powerpc-eabivle-
# Standard compiler utils
CC      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}gcc
CXX     := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}g++
LD      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}ld
OBJCOPY := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objcopy
OBJDUMP := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objdump
SIZE    := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}size
NM      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}nm

# Determine the binary names.
ELF:=${PROJ_NAME}.elf
HEX:=${PROJ_NAME}.hex
BIN:=${PROJ_NAME}.bin
S19:=${PROJ_NAME}.s19

# Complier & Linker Setup
ifndef SYSROOT
	SYSROOT=${VLE_EWL_DIR}
endif

ifndef SPECS
	SPECS=ewl_c9x_noio.specs
endif

# Gather source files.
SRC_C += ${realpath ${wildcard ${SRC_DIR}/src/*.c}}
SRC_S += ${realpath ${wildcard ${SRC_DIR}/src/*.S}}

# Calculate
OBJ_C = $(patsubst %.c,%.o,${SRC_C})
OBJ_S = $(patsubst %.S,%.o,${SRC_S})
OBJS = ${OBJ_C} ${OBJ_S}

# Include Directories
INCLUDE += ${SRC_DIR}/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include/pa

C_STD?=c99
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
LD_FLAGS += -Wl,-Map,"${PROJ_NAME}.map"
LD_FLAGS += -Xlinker
LD_FLAGS += --gc-sections
LD_FLAGS += $(foreach d, $(MACH_OPTS),-m$d)
LD_FLAGS += -specs=${SPECS}
LD_FLAGS += --sysroot="${SYSROOT}"

.DEFAULT: all
.PHONY: all
all: ${ELF} ${HEX} ${BIN} ${S19}

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
	-${RM} ${OBJS}
	-${RM} ${BIN_ROOT}.map

%.o: %.c
	$(file >$@.args) $(foreach O,${C_FLAGS},$(file >>$@.args,$O))
	$(CC) -MMD -MP -MF"${@:%.o=%.d}" -MT"${@}" -o "$@" -c "$<" @$@.args
	
%.o: %.S
	$(file >$@.args) $(foreach O,${C_FLAGS},$(file >>$@.args,$O))
	$(CC) -MMD -MP -MF"${@:%.o=%.d}" -MT"${@}" -o "$@" -c "$<" @$@.args
