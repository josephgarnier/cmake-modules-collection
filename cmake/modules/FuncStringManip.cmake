# Copyright 2019-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
StringManip
-----------

Operations on strings. It requires CMake 3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

    string_manip(`SPLIT`_ <string> <output_list_var>)
    string_manip(`TRANSFORM`_ <string_var> <ACTION> [OUTPUT_VARIABLE <output_var>])
    string_manip(`STRIP_INTERFACES`_ <string_var> [OUTPUT_VARIABLE <output_var>])
    string_manip(`EXTRACT_INTERFACE`_ <string_var> <BUILD|INSTALL> [OUTPUT_VARIABLE <output_var>])

Usage
^^^^^

.. signature::
  string_manip(SPLIT <string> <output_list_var>)

  Splits the input string into a list of substrings based on specific
  pattern rules.

  This command analyzes the given ``<string>`` and splits it into components
  using the following criteria:

  * Transitions between lowercase and uppercase letters
    (e.g., ``MyValue`` → ``My;Value``).
  * Non-alphanumeric characters, as defined by the `string(MAKE_C_IDENTIFIER) <https://cmake.org/cmake/help/latest/command/string.html#make-c-identifier>`_
    transformation in CMake.

  The resulting list is stored in ``<output_list_var>``.

  If no split point is detected, the original string is returned as a
  single-element list.

  .. code-block:: cmake

    # No split point detected
    string_manip(SPLIT "mystringtosplit" output)
    # output is "mystringtosplit"
    string_manip(SPLIT "my1string2to3split" output)
    # output is "my1string2to3split"

    # Split on uppercase
    string_manip(SPLIT "myStringToSplit" output)
    # output is "my;String;To;Split"

    # Split on non-alphanumeric
    string_manip(SPLIT "my-string/to*split" output)
    # output is "my;string;to;split"

    # Split on multiple criteria
    string_manip(SPLIT "myString_to*Split" output)
    # output is "my;String;to;Split"

.. signature::
  string_manip(SPLIT_TRANSFORM <string_var> <ACTION> [OUTPUT_VARIABLE <output_var>])

  Applies the :command:`string_manip(SPLIT)` operation to the value stored in ``<string_var>``,
  transforms each resulting element according to the specified ``<ACTION>``,
  then joins the list into a single string.

  The final result is either stored back in ``<string_var>``, or in ``<output_var>`` if the
  ``OUTPUT_VARIABLE`` option is provided.

  The available values for ``<ACTION>`` are:

  ``START_CASE``
    Converts each word to Start Case (first letter uppercase, others lowercase).

  ``C_IDENTIFIER_UPPER``
    Applies a transformation inspired by `string(MAKE_C_IDENTIFIER) <https://cmake.org/cmake/help/latest/command/string.html#make-c-identifier>`_:
    each word is converted to uppercase and suffixed with an underscore.
    If the first character is a digit, an underscore is also prepended to the result.

  Example transformations:

  * Input: ``"myVariableName"``
    Action: ``START_CASE`` → ``"MyVariableName"``

  * Input: ``"myVariableName"``
    Action: ``C_IDENTIFIER_UPPER`` → ``"MY_VARIABLE_NAME_"`` (joined string)

  If no split points are detected, the input is treated as a single-element list and transformed accordingly.

.. _STRIP_INTERFACES:
.. code-block:: cmake

  string_manip(STRIP_INTERFACES <string_var> [OUTPUT_VARIABLE <output_var>])

Strip BUILD_INTERFACE and INSTALL_INTERFACE generator expressions from the input
``<string_var>`` and store the result in place or in the specified ``<output_var>``.

.. _EXTRACT_INTERFACE:
.. code-block:: cmake

  string_manip(EXTRACT_INTERFACE <string_var> <BUILD|INSTALL> [OUTPUT_VARIABLE <output_var>])

Extract the content in BUILD_INTERFACE or INSTALL_INTERFACE generator expressions from the input
``<string_var>`` and store the result as a string in place or in the specified ``<output_var>``.

#]=======================================================================]
include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module.
function(string_manip)
	set(options START_CASE C_IDENTIFIER_UPPER BUILD INSTALL)
	set(one_value_args SPLIT_TRANSFORM STRIP_INTERFACES OUTPUT_VARIABLE EXTRACT_INTERFACE)
	set(multi_value_args SPLIT)
	cmake_parse_arguments(SM "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(DEFINED SM_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${SM_UNPARSED_ARGUMENTS}\"")
	endif()

	if(DEFINED SM_SPLIT)
		_string_manip_split()
	elseif(DEFINED SM_SPLIT_TRANSFORM)
		if(${SM_C_IDENTIFIER_UPPER})
			_string_manip_split_transform_identifier_upper()
		elseif(${SM_START_CASE})
			_string_manip_split_transform_start_case()
		else()
			message(FATAL_ERROR "ACTION argument is missing")
		endif()
	elseif(DEFINED SM_STRIP_INTERFACES)
		_string_manip_strip_interfaces()
	elseif(DEFINED SM_EXTRACT_INTERFACE)
		_string_manip_extract_interface()
	else()
		message(FATAL_ERROR "Operation argument is missing")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage.
macro(_string_manip_split)
	list(LENGTH SM_SPLIT nb_args)
	if(NOT ${nb_args} EQUAL 2)
		message(FATAL_ERROR "SPLIT argument is missing or wrong")
	endif()

	list(GET SM_SPLIT 0 string_to_split)
	string(MAKE_C_IDENTIFIER "${string_to_split}" string_to_split)
	string(REGEX MATCHALL "[^_][^|A-Z|_]*" string_list "${string_to_split}")
	list(GET SM_SPLIT 1 output_list_var)
	set(${output_list_var} "${string_list}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_string_manip_split_transform_identifier_upper)
	if(NOT DEFINED SM_SPLIT_TRANSFORM)
		message(FATAL_ERROR "TRANSFORM arguments is missing")
	endif()
	if(NOT ${SM_C_IDENTIFIER_UPPER})
		message(FATAL_ERROR "C_IDENTIFIER_UPPER argument is missing")
	endif()
	
	string_manip(SPLIT "${${SM_SPLIT_TRANSFORM}}" word_list)
	set(output_formated_word "")
	foreach(word IN ITEMS ${word_list})
		string(TOUPPER "${word}" formated_word)
		string(APPEND output_formated_word "_${formated_word}")
		unset(formated_word)
	endforeach()

	# The underscore is removed if the second letter is not a digit.
	string(LENGTH output_formated_word output_formated_word_size)
	if(${output_formated_word_size} GREATER_EQUAL 2)
		string(SUBSTRING ${output_formated_word} 1 1 second_letter)
		if(NOT "${second_letter}" MATCHES "[0-9]")
			string(SUBSTRING "${output_formated_word}" 1 -1 output_formated_word)
		endif()
	endif()

	if(NOT DEFINED SM_OUTPUT_VARIABLE)
		set(${SM_SPLIT_TRANSFORM} "${output_formated_word}" PARENT_SCOPE)
	else()
		set(${SM_OUTPUT_VARIABLE} "${output_formated_word}" PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_string_manip_split_transform_start_case)
	if(NOT DEFINED SM_SPLIT_TRANSFORM)
		message(FATAL_ERROR "TRANSFORM arguments is missing")
	endif()
	if(NOT ${SM_START_CASE})
		message(FATAL_ERROR "START_CASE argument is missing")
	endif()
	
	string_manip(SPLIT "${${SM_SPLIT_TRANSFORM}}" word_list)
	set(output_formated_word "")
	foreach(word IN ITEMS ${word_list})
		string(TOLOWER "${word}" formated_word)
		string(SUBSTRING ${formated_word} 0 1 first_letter)
		string(TOUPPER "${first_letter}" first_letter)
		string(REGEX REPLACE "^.(.*)" "${first_letter}\\1" formated_word "${formated_word}")
		string(APPEND output_formated_word "${formated_word}")
		unset(formated_word)
	endforeach()

	if(NOT DEFINED SM_OUTPUT_VARIABLE)
		set(${SM_SPLIT_TRANSFORM} "${output_formated_word}" PARENT_SCOPE)
	else()
		set(${SM_OUTPUT_VARIABLE} "${output_formated_word}" PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_string_manip_strip_interfaces)
	if(NOT DEFINED SM_STRIP_INTERFACES)
		message(FATAL_ERROR "STRIP_INTERFACES argument is missing")
	endif()

	set(regex ";?\\$<BUILD_INTERFACE:[^>]+>|;?\\$<INSTALL_INTERFACE:[^>]+>")
	string(REGEX REPLACE "${regex}" "" string_striped "${${SM_STRIP_INTERFACES}}")

	if(NOT DEFINED SM_OUTPUT_VARIABLE)
		set(${SM_STRIP_INTERFACES} "${string_striped}" PARENT_SCOPE)
	else()
		set(${SM_OUTPUT_VARIABLE} "${string_striped}" PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_string_manip_extract_interface)
	if(NOT DEFINED SM_EXTRACT_INTERFACE)
		message(FATAL_ERROR "EXTRACT_INTERFACE arguments is missing or need a value!")
	endif()
	if((NOT ${SM_BUILD})
		AND (NOT ${SM_INSTALL}))
		message(FATAL_ERROR "BUILD|INSTALL arguments is missing!")
	endif()
	if(${SM_BUILD} AND ${SM_INSTALL})
		message(FATAL_ERROR "BUILD|INSTALL cannot be used together!")
	endif()

	set(string_getted "")
	if(${SM_BUILD})
		string(REGEX MATCHALL "\\$<BUILD_INTERFACE:[^>]+>+" matches "${${SM_EXTRACT_INTERFACE}}")
		set(matches_stripped "")
		foreach(match IN ITEMS ${matches})
			string(REPLACE "$<BUILD_INTERFACE:" "" match "${match}")
			# Remove the last character ">".
			string(LENGTH "${match}" match_size)
			math(EXPR match_size "${match_size}-1")
			string(SUBSTRING "${match}" 0 ${match_size} match)
			list(APPEND matches_stripped "${match}")
		endforeach()
		list(JOIN matches_stripped ";" string_getted)
	elseif(${SM_INSTALL})
		string(REGEX MATCHALL "\\$<INSTALL_INTERFACE:[^>]+>+" matches "${${SM_EXTRACT_INTERFACE}}")
		set(matches_stripped "")
		foreach(match IN ITEMS ${matches})
			string(REPLACE "$<INSTALL_INTERFACE:" "" match "${match}")
			# Remove the last character ">".
			string(LENGTH "${match}" match_size)
			math(EXPR match_size "${match_size}-1")
			string(SUBSTRING "${match}" 0 ${match_size} match)
			list(APPEND matches_stripped "${match}")
		endforeach()
		list(JOIN matches_stripped ";" string_getted)
	else()
		message(FATAL_ERROR "Wrong interface type!")
	endif()

	if(NOT DEFINED SM_OUTPUT_VARIABLE)
		set(${SM_EXTRACT_INTERFACE} "${string_getted}" PARENT_SCOPE)
	else()
		set(${SM_OUTPUT_VARIABLE} "${string_getted}" PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Unit Tests.
function(string_manip_unit_test)
	#---- string_manip(SPLIT <string> <output_list_var>) ----
	# Test 1
	set(my_string "4Alpha-4beTagammaDe9ltaEc/hoalpha-Beta-in_4aLpha_4_be_ta_ga_mm5_aalpha_AlphaBetaGammaDelta")
	string_manip(SPLIT "${my_string}" output)
	set(expected "4;Alpha;4be;Tagamma;De9lta;Ec;hoalpha;Beta;in;4a;Lpha;4;be;ta;ga;mm5;aalpha;Alpha;Beta;Gamma;Delta")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	
	#---- string_manip(SPLIT_TRANSFORM <string_var> START_CASE [OUTPUT_VARIABLE <output_var>]) ----
	# Test 1
	set(my_string "4Alpha-4beTagammaDe9ltaEc/hoalpha-Beta-in_4aLpha_4_be_ta_ga_mm5_aalpha_AlphaBetaGammaDelta")
	string_manip(SPLIT_TRANSFORM my_string START_CASE OUTPUT_VARIABLE output)
	set(expected "4Alpha4beTagammaDe9ltaEcHoalphaBetaIn4aLpha4BeTaGaMm5AalphaAlphaBetaGammaDelta")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(START_CASE) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 2
	set(output "4Alpha-4beTagammaDe9ltaEc/hoalpha-Beta-in_4aLpha_4_be_ta_ga_mm5_aalpha_AlphaBetaGammaDelta")
	string_manip(SPLIT_TRANSFORM output START_CASE)
	set(expected "4Alpha4beTagammaDe9ltaEcHoalphaBetaIn4aLpha4BeTaGaMm5AalphaAlphaBetaGammaDelta")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(START_CASE) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 3
	set(my_string "my-project-name")
	string_manip(SPLIT_TRANSFORM my_string START_CASE OUTPUT_VARIABLE output)
	set(expected "MyProjectName")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(START_CASE) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	
	#---- string_manip(SPLIT_TRANSFORM <string_var> C_IDENTIFIER_UPPER [OUTPUT_VARIABLE <output_var>]) ----
	# Test 1
	set(my_string "4Alpha-4beTagammaDe9ltaEc/hoalpha-Beta-in_4aLpha_4_be_ta_ga_mm5_aalpha_AlphaBetaGammaDelta")
	string_manip(SPLIT_TRANSFORM my_string C_IDENTIFIER_UPPER OUTPUT_VARIABLE output)
	set(expected "_4_ALPHA_4BE_TAGAMMA_DE9LTA_EC_HOALPHA_BETA_IN_4A_LPHA_4_BE_TA_GA_MM5_AALPHA_ALPHA_BETA_GAMMA_DELTA")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(C_IDENTIFIER_UPPER) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 2
	set(output "4Alpha-4beTagammaDe9ltaEc/hoalpha-Beta-in_4aLpha_4_be_ta_ga_mm5_aalpha_AlphaBetaGammaDelta")
	string_manip(SPLIT_TRANSFORM output C_IDENTIFIER_UPPER)
	set(expected "_4_ALPHA_4BE_TAGAMMA_DE9LTA_EC_HOALPHA_BETA_IN_4A_LPHA_4_BE_TA_GA_MM5_AALPHA_ALPHA_BETA_GAMMA_DELTA")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(C_IDENTIFIER_UPPER) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 3
	set(my_string "alpha")
	string_manip(SPLIT_TRANSFORM my_string C_IDENTIFIER_UPPER OUTPUT_VARIABLE output)
	set(expected "ALPHA")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(C_IDENTIFIER_UPPER) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 4
	set(my_string "1alpha")
	string_manip(SPLIT_TRANSFORM my_string C_IDENTIFIER_UPPER OUTPUT_VARIABLE output)
	set(expected "_1ALPHA")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(C_IDENTIFIER_UPPER) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	# Test 5
	set(my_string "my-project-name")
	string_manip(SPLIT_TRANSFORM my_string C_IDENTIFIER_UPPER OUTPUT_VARIABLE output)
	set(expected "MY_PROJECT_NAME")
	if (NOT "${output}" STREQUAL "${expected}")
		message (FATAL_ERROR "SPLIT_TRANSFORM(C_IDENTIFIER_UPPER) is \"${output}\", expected is \"${expected}\"")
	endif()
	unset(expected)
	unset(output)
	unset(my_string)
	
	
	message(STATUS "All tests OK!")
endfunction()