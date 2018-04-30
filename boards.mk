##
# Development Board Configuration
##
ifndef MCU
	$(error MCU must be specified)
endif


# Per MCU configurations
ifeq ($(MCU),MPC5748G)
#### Start MPC5748G
ifndef CORE
	$(error CORE must be specified)
endif

SYMBOLS += MPC574xG
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
	OPT_FLAGS:=message-length=0
	OPT_FLAGS+=signed-char
	OPT_FLAGS+=function-sections
	OPT_FLAGS+=data-sections
endif

ifndef MACH_OPTS
	MACH_OPTS:=cpu=${CPU}
	MACH_OPTS+=big
	MACH_OPTS+=vle
	MACH_OPTS+=regnames
	MACH_OPTS+=hard-float
endif

#### End MPC5748G
else
$(error Unknown MCU: ${MCU})
endif

C_STD?=c99
OPT_LVL?=0
DEBUG_LVL?=3
WARNINGS?=all
