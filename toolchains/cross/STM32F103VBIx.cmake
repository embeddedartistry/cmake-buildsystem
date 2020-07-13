#############################
# STM32F103VBIx (Cortex-M3) #
#############################

set(CPU_NAME STM32F103VBIx)

set(LINKER_SCRIPT_DIR ${CMAKE_SOURCE_DIR}/cmake/linker-scripts/stm)
set(LINKER_SCRIPT_PRIMARY_FILE STM32F103VBIx_FLASH.ld)

# These dependencies are applied to add_executable targets by the
# AddExecutableWithLinkerScriptDep module
list(APPEND LINKER_SCRIPT_DEPENDENCIES "${LINKER_SCRIPT_DIR}/${LINKER_SCRIPT_PRIMARY_FILE}")

set(LD_FLAGS "-T${LINKER_SCRIPT_PRIMARY_FILE} -L${LINKER_SCRIPT_DIR}")

include(${CMAKE_CURRENT_LIST_DIR}/cortex-m3.cmake)
