####################
# GCC-13 Toolchain #
####################

set(CMAKE_C_COMPILER    gcc-13)
set(CMAKE_CXX_COMPILER  g++-13)
if(NOT (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin"))
	set(CMAKE_AR        gcc-ar-13)
endif()

