########################
# Cortex-M4 Hard-float #
########################

if(NOT CPU_NAME)
	set(CPU_NAME cortex-m4)
endif()
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb ${CPU_FLAGS}")
set(VFP_FLAGS "-mfloat-abi=hard -mfpu=fpv4-sp-d16 ${VFP_FLAGS}")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi-gcc.cmake)
