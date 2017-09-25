PROJ_DIR:=$(realpath $(dir $(realpath ${firstword ${MAKEFILE_LIST}})))

E200MK_DIR:=$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

SRC = ${realpath ${wildcard src/*.c}}
OBJ = $(patsubst %.c,%.o,${SRC})

BIN_ROOT:=${notdir ${PROJ_DIR}}
ELF:=${BIN_ROOT}.elf
HEX:=${BIN_ROOT}.hex
BIN:=${BIN_ROOT}.bin
S19:=${BIN_ROOT}.S19

null:
	@echo ${BIN_ROOT}
	@echo ${ELF}
	@echo ${OBJ}


x:
	$(notdir $(realpath $(dir $(realpath ${firstword ${MAKEFILE_LIST}}))))

all: ${ELF} ${HEX} ${BIN} ${S19}

VLE_TOOLCHAIN_DIR := ${E200MK_DIR}/powerpc-eabivle-4_9
VLE_EWL_DIR:=${E200MK_DIR}/e200_ewl2

CROSS_PREFIX:=powerpc-eabivle-

CC_NAME      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}gcc
CXX_NAME     := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}g++
OBJCOPY_NAME := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objcopy
OBJDUMP_NAME := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}objdump
SIZE_NAME    := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}size
NM_NAME      := ${VLE_TOOLCHAIN_DIR}/bin/${CROSS_PREFIX}nm

INCLUDE += ${PROJ_DIR}/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include
INCLUDE += ${VLE_EWL_DIR}/EWL_C/include/pa
