
# Read enabled languages to determine what functionality to provide
get_property(enabled_languages GLOBAL PROPERTY ENABLED_LANGUAGES)

###########################
# Common Macros/Functions #
###########################

# Change - to _ to generate safe variable names
macro(make_safe_varname input_string output_var)
	string(REPLACE - _ ${output_var} ${input_string})
endmacro()

# Use this function to promote an input argument that represents a list
# such that two layers of dereferencing aren't needed.
# This enables supporting both string and variable inputs with a function arg.
macro(check_and_double_deref input)
	if(NOT "${${${input}}}" STREQUAL "")
		set(${input} ${${${input}}})
	endif()
endmacro()

#########################################
# C Language Support (For CMake < 3.18) #
#########################################

if("C" IN_LIST enabled_languages)
	include(CheckCCompilerFlag)

	function(apply_supported_c_compiler_flags target scope flag_list)
		check_and_double_deref(flag_list)
		foreach(flag ${flag_list})
			make_safe_varname(${flag} flag_var)
			check_c_compiler_flag(${flag} ${flag_var})

			if(${flag_var})
				target_compile_options(${target} ${scope} ${flag})
			endif()
		endforeach()
	endfunction()

	function(check_c_linker_flag flag out_var)
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${flag}")
  		check_c_compiler_flag("" ${out_var})
	endfunction()

	function(apply_supported_c_linker_flags target scope flag_list)
		check_and_double_deref(flag_list)
		foreach(flag ${flag_list})
			make_safe_varname(${flag} flag_var)
			check_c_linker_flag(${flag} ${flag_var})

			if(${flag_var})
				target_link_options(${target} ${scope} ${flag})
			endif()
		endforeach()
	endfunction()
endif()

###########################################
# CXX Language Support (For CMake < 3.18) #
###########################################

if("CXX" IN_LIST enabled_languages)
	include(CheckCXXCompilerFlag)

	function(apply_supported_cxx_compiler_flags target scope flag_list)
		check_and_double_deref(flag_list)
		foreach(flag ${flag_list})
			make_safe_varname(${flag} flag_var)
			check_cxx_compiler_flag(${flag} ${flag_var})

			if(${flag_var})
				target_compile_options(${target} ${scope} ${flag})
			endif()
		endforeach()
	endfunction()

	function(check_cxx_linker_flag flag out_var)
		set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${flag}")
  		check_cxx_compiler_flag("" ${out_var})
	endfunction()

	function(apply_supported_cxx_linker_flags target scope flag_list)
		check_and_double_deref(flag_list)
		foreach(flag ${flag_list})
			make_safe_varname(${flag} flag_var)
			check_cxx_linker_flag(${flag} ${flag_var})

			if(${flag_var})
				target_link_options(${target} ${scope} ${flag})
			endif()
		endforeach()
	endfunction()
endif()

#############################
# Common Compiler Interface #
#############################

function(apply_supported_compiler_flags lang target scope flag_list)
if(${CMAKE_VERSION} VERSION_LESS "3.18")
	if(${lang} STREQUAL C)
		apply_supported_c_compiler_flags(${target} ${scope} ${flag_list})
	elseif(${lang} STREQUAL CXX)
		apply_supported_cxx_compiler_flags(${target} ${scope} ${flag_list})
	else()
		message(FATAL_ERROR "Language ${lang} is not supported by this function.")
	endif()
else()
	include(Check${lang}CompilerFlag)

	check_and_double_deref(flag_list)
	foreach(flag ${flag_list})
		make_safe_varname(${flag} flag_var)
		cmake_language(CALL check_${lang}_compiler_flag ${flag} ${flag_var})

		if(${flag_var})
			target_compile_options(${target} ${scope} ${flag})
		endif()
	endforeach()
endif()
endfunction()

###########################
# Common Linker Interface #
###########################

if(${CMAKE_VERSION} VERSION_LESS "3.18")
	function(apply_supported_linker_flags lang target scope flag_list)
		if(${lang} STREQUAL C)
			apply_supported_c_linker_flags(${target} ${scope} ${flag_list})
		elseif(${lang} STREQUAL CXX)
			apply_supported_cxx_linker_flags(${target} ${scope} ${flag_list})
		else()
			message(FATAL_ERROR "Language ${lang} is not supported by this function.")
		endif()
	endfunction()
else()
	include(CheckLinkerFlag)

	function(apply_supported_linker_flags lang target scope flag_list)
		check_and_double_deref(flag_list)
		foreach(flag ${flag_list})
			make_safe_varname(${flag} flag_var)
			check_linker_flag(${lang} ${flag} ${flag_var})

			if(${flag_var})
				target_link_options(${target} ${scope} ${flag})
			endif()
		endforeach()
	endfunction()
endif()
