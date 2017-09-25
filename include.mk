PROJ_DIR:=$(realpath $(dir $(realpath ${firstword ${MAKEFILE_LIST}})))

BIN_ROOT:=${notdir ${PROJ_DIR}}
ELF:=${BIN_ROOT}.elf
HEX:=${BIN_ROOT}.hex
BIN:=${BIN_ROOT}.bin
S19:=${BIN_ROOT}.S19

null:
	@echo ${BIN_ROOT}
	@echo ${ELF}


x:
	$(notdir $(realpath $(dir $(realpath ${firstword ${MAKEFILE_LIST}}))))
