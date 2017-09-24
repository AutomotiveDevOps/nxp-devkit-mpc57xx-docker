E200MK_DIR:=$(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
S32DS:=/opt/NXP/S32DS_Power_v1.2

.DEFAULT: vars
.PHONY: vars
vars: ${MPC5748G_CORES}
	@echo $@

${MPC5748G_CORES}:
	@echo $@



.PHONY: init
init: powerpc-eabivle-4_9 e200_ewl2 mcu_settings
	@echo Done!

CHIPS:=MPC5744P MPC5748G
.PHONY: mcu_core
mcu_core: ${CHIPS}
	

MPC5744P: Examples
	# MPC5744P
	@mkdir -p $@
	@cp -R Examples/$@/ADC_$@/Project_Settings/Startup_Code/* $@
	@cp -R Examples/$@/ADC_$@/Project_Settings/Linker_Files/* $@

MPC5748G_CORES:=Z4_1 Z4_2 Z2_3
MPC5748G: Examples
	# MPC5748G
	# Core 1
	@mkdir -p $@
	@mkdir -p $@/Z4_1
	@cp Examples/$@/adc/adc_Z4_1/Project_Settings/Linker_Files/* $@/Z4_1
	@cp Examples/$@/adc/adc_Z4_1/Project_Settings/Startup_Code/* $@/Z4_1

	# Core 2
	@mkdir -p $@/Z4_2
	@cp Examples/$@/adc/adc_Z4_2/Project_Settings/Linker_Files/* $@/Z4_2
	@cp Examples/$@/adc/adc_Z4_2/Project_Settings/Startup_Code/* $@/Z4_2

	# Core 3
	@mkdir -p $@/Z2_3
	@cp Examples/$@/adc/adc_Z2_3/Project_Settings/Linker_Files/* $@/Z2_3
	@cp Examples/$@/adc/adc_Z2_3/Project_Settings/Startup_Code/* $@/Z2_3

	# Single Elf
	@mkdir -p $@/single_elf
	@cp Examples/$@/SingleElf_$@/Project_Settings/Linker_Files/* $@/single_elf
	@cp Examples/$@/SingleElf_$@/Project_Settings/Startup_Code/* $@/single_elf

mcu/MPC5748G: Examples
	@mkdir -p 

powerpc-eabivle-4_9:
	@echo Copying $@
	@cp -R ${S32DS}/Cross_Tools/powerpc-eabivle-4_9 ./

Examples:
	@echo Copying $@
	@cp -R ${S32DS}/eclipse/plugins/com.freescale.s32ds.e200.examples.descriptor_1.0.0.201705101131/Examples ./

e200_ewl2:
	@echo Copying $@
	@cp -R ${S32DS}/S32DS/e200_ewl2 ./

.PHONY: clean
clean:
	@echo -n Removing files ...
	-@rm -rf powerpc-eabivle-4_9 e200_ewl2 Examples
	-@rm -rf ${CHIPS}
	@echo ... Done
