#################
# Unity Module #
#################
# This module simplifies the process of adding Unity testing support to your build.
#
# You can link against the `unity_dep` target to access the dependency and build a test program.
#
# We set our own default build settings for the unity framework, such as enabling extensions.
# You can pass your own settings to the dependency by setting the UNITY_DEP_SETTINGS variable.
#
# Our default compile-time settings are provided in UNITY_COMPILE_SETTINGS. You can override
# our settings completely by defining this variable. You can also provide additional settings
# using UNITY_ADDITIONAL_COMPILE_SETTINGS.
#
# This module also provides a `register_unity_test` function to simplify the registration of Unity
# test programs. Call this function with the desired test name and the build target for the test
# program. This call can be used with multiple test programs.
#
# Example:
#   register_unity_test(Printf.Test printf_tests)

########
# TODO #
########
# By default, XML output will be placed in ${CMAKE_BINARY_DIR}/test. You can change this
# by setting UNITY_TEST_OUTPUT_DIR before you include this module.

# I understand your root question is that you would prefer to not use Ceedling
# at all and would just like to get xml output from Unity. While unity itself
# doesn't output xml output, it CAN be post-processed using a script.
# There are some sample scripts in the unity/auto directory of the repo.
# For example, stylize_as_junit.rb is a ruby script which will output
# junit-compatible xml from unity's output files.

# So. i did some digging and in my particular setup, i was just building my own
# main, then running the executable that I created. Then I tee'd that output to
# a <test_name>.testResults file. Then after I had that, I was able to use the
# style_as_junit.rb ruby script to generate the appropriate junit xml file.

include(${CMAKE_CURRENT_LIST_DIR}/../CPM.cmake)

if(NOT UNITY_TEST_OUTPUT_DIR)
  set(UNITY_TEST_OUTPUT_DIR ${CMAKE_BINARY_DIR}/test/ CACHE STRING "Location where Catch2 test results should live.")
endif()

if(NOT UNITY_DEP_SETTINGS)
	set(UNITY_DEP_SETTINGS
		"UNITY_EXTENSION_FIXTURE ON"
		"UNITY_EXTENSION_MEMORY ON"
		CACHE STRING "Settings that control the Unity dependency build target.")
endif()

if(NOT UNITY_COMPILE_SETTINGS)
	set(UNITY_COMPILE_SETTINGS
		# UNITY_EXCLUDE_FLOAT
		# UNITY_EXCLUDE_DOUBLE
		# UNITY_EXCLUDE_FLOAT_PRINT
		# UNITY_OUTPUT_COLOR
	CACHE STRING "Settings that control Unity compilation.")
endif()

if(UNITY_ADDITIONAL_COMPILE_SETTINGS)
	list(APPEND UNITY_COMPILE_SETTINGS ${UNITY_ADDITIONAL_COMPILE_SETTINGS})
endif()

######################
# Satisfy Dependency #
######################

# The library target is Unity
CPMAddPackage(
  NAME Unity
  GITHUB_REPOSITORY ThrowTheSwitch/Unity
  VERSION 2.5.2
  OPTIONS
  	${UNITY_DEP_SETTINGS}
)

# Define a build target that users can link against to build a Catch2 test program
add_library(unity_dep INTERFACE)
target_link_libraries(unity_dep INTERFACE unity)
target_compile_options(unity_dep INTERFACE ${UNITY_COMPILE_SETTINGS})

################################
# Register Unity test targets #
################################

function(register_unity_test test_name target)
  add_custom_target(test-${target}
    COMMAND ${target}
  )

  add_test(NAME ${test_name}
    COMMAND ${target}
  )
endfunction()
