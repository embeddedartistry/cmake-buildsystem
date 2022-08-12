####################
# GCC-11 Toolchain #
####################

set(CMAKE_C_COMPILER    gcc-11)
set(CMAKE_CXX_COMPILER  g++-11)
if(NOT (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin"))
	set(CMAKE_AR        gcc-ar-11)
endif()

