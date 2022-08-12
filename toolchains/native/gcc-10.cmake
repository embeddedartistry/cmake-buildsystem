####################
# GCC-10 Toolchain #
####################

set(CMAKE_C_COMPILER    gcc-10)
set(CMAKE_CXX_COMPILER  g++-10)
if(NOT (${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin"))
	set(CMAKE_AR        gcc-ar-10)
endif()

