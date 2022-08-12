####################
# GCC-12 Toolchain #
####################

set(CMAKE_C_COMPILER    gcc-12)
set(CMAKE_CXX_COMPILER  g++-12)
if(NOT (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin"))
	set(CMAKE_AR        gcc-ar-12)
endif()

