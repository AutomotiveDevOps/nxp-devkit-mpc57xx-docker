PREFIX=powerpc-eabivle-

E200MK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

VLE_TOOLCHAIN_DIR := ${E200MK_DIR}/powerpc-eabivle-4_9

ewl_c -specs=ewl_c9x_noio.specs

--sysroot="${VLE_EWL_DIR}"

/opt/NXP/S32DS_Power_v1.2/eclipse/../Cross_Tools/powerpc-eabivle-4_9/bin:/opt/NXP/S32DS_Power_v1.2/utils/MinGW/msys/1.0/bin:/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/SPT/bin





.DEFAULT: var
.PHONY: var
var:
	echo ${E200MK_DIR}
	echo ${E200MK_DIR}

Compiler:

${cross_prefix}${cross_c}${cross_suffix}



-I"/home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include/pa" -O0 -g3 -Wall -c -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mbig -mvle -mregnames -mhard-float --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"

"${ProjDirPath}/include"
"${VLE_EWL_DIR}/EWL_C/include"
"${VLE_EWL_DIR}/EWL_C/include/pa"

Optimization:
-fsigned-char # Char is signed
-funsigned-bitfields # 'bitfield' is unsigned.
-ffunction-sections # Function Sections
-fdata-sections # Data sections

Debugging:
-g3

Warnings:
-Wall



Linker:
gcc
-T "/home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/Project_Settings/Linker_Files/mem.ld" -T "/home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/Project_Settings/Linker_Files/sections.ld" -T "/home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/Project_Settings/Linker_Files/libs.ld" -Wl,-Map,"ADC_MPC5748G_Z4_1.map" -Xlinker --gc-sections -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mhard-float --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"

${COMMAND} ${FLAGS} ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

"${ProjDirPath}/Project_Settings/Linker_Files/mem.ld"
"${ProjDirPath}/Project_Settings/Linker_Files/sections.ld"
"${ProjDirPath}/Project_Settings/Linker_Files/libs.ld"

Assembler:
${cross_prefix}${cross_c}${cross_suffix}

-I"/home/jafrey/workspaceS32DS.Power/ADC_MPC5748G/ADC_MPC5748G_Z4_1/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include" -I"/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2/EWL_C/include/pa" -x assembler-with-cpp -Dregister_architecture=e200 -Dregister_vendor=Freescale -Dregister_chip=MPC5748G -DMPC574xG -DSTART_FROM_FLASH -DDISABLE_SWT0 -DI_CACHE -DD_CACHE -DHW_INIT -O0 -g3 -mcpu=e200z4 -specs=ewl_c9x_noio.specs -mbig -mvle -mregnames --sysroot="/opt/NXP/S32DS_Power_v1.2/eclipse/../S32DS/e200_ewl2"

${COMMAND} ${FLAGS} -c ${OUTPUT_FLAG} ${OUTPUT_PREFIX}${OUTPUT} ${INPUTS}

Preprocessor:
${cross_prefix}${cross_c}${cross_suffix}
options = -E
${COMMAND} ${FLAGS} ${INPUTS}

Disassembler:
${cross_prefix}objdump${cross_suffix}
options = -d -S -x
${COMMAND} ${FLAGS} ${INPUTS}
