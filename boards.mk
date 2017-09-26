##
# Development Board Configuration
##
ifndef MCU
	$(error MCU must be specified)
endif


# Per MCU configurations
ifeq ($(MCU),MPC5744P)
#### Start MPC5744P
	CPU=e200z4

SYMBOLS += MPC574xP

# Startup Assembly
SRC_S += ${realpath ${wildcard ${E200MK_DIR}/${MCU}/*.S}}

# Linker Files.
SRC_LD += ${realpath ${wildcard ${E200MK_DIR}/${MCU}/libs.ld}}


# Determine if we are loading from RAM
ifndef RAM
	SRC_LD += ${realpath ${wildcard ${E200MK_DIR}/${MCU}/57xx_flash.ld}}
	SYMBOLS += START_FROM_FLASH
else
	SRC_LD += ${realpath ${wildcard ${E200MK_DIR}/${MCU}/57xx_ram.ld}}
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

#### End MPC5744P
else
	$(error Unknown MCU: ${MCU})
endif

ifndef C_STD
	C_STD=c99
endif

ifndef OPT_LVL
	OPT_LVL=0
endif

ifndef DEBUG_LVL
	DEBUG_LVL=3
endif

ifndef WARNINGS
	WARNINGS=all
endif