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
    string_manip(`SPLIT_TRANSFORM`_ <string_var> <ACTION> [OUTPUT_VARIABLE <output_var>])
    string_manip(`STRIP_INTERFACES`_ <string_var> [OUTPUT_VARIABLE <output_var>])
    string_manip(`EXTRACT_INTERFACE`_ <string_var> <BUILD|INSTALL> [OUTPUT_VARIABLE <output_var>])

Usage
^^^^^

.. signature::
  string_manip(SPLIT <string> <output_list_var>)

  Splits the input string into a list of substrings based on specific
  pattern rules. This command analyzes the given ``<string>`` and splits
  it into components using the following criteria:

  * Transitions between lowercase and uppercase letters
    (e.g., ``MyValue`` becomes ``My;Value``).
  * Non-alphanumeric characters, as defined by the `string(MAKE_C_IDENTIFIER) <https://cmake.org/cmake/help/latest/command/string.html#make-c-identifier>`_
    transformation in CMake.

  The resulting list is stored in ``<output_list_var>``. If no split point is
  detected, the original string is returned as a single-element list.

  Example usage:

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
  then joins the list into a single string. The final result is either stored
  back in ``<string_var>``, or in ``<output_var>`` if the ``OUTPUT_VARIABLE``
  option is provided.

  The available values for ``<ACTION>`` are:

    ``START_CASE``
      Converts each word to Start Case (first letter uppercase, others lowercase).

    ``C_IDENTIFIER_UPPER``
      Applies a transformation inspired by `string(MAKE_C_IDENTIFIER) <https://cmake.org/cmake/help/latest/command/string.html#make-c-identifier>`_:
      each word is converted to uppercase and suffixed with an underscore.
      If the first character is a digit, an underscore is also prepended to
      the result.

  Example of transformations:

  ====================  ======================  =======================================
  Input                 Action                  Output
  ====================  ======================  =======================================
  ``"myVariableName"``  ``START_CASE``          ``"MyVariableName"``
  ``"myVariableName"``  ``C_IDENTIFIER_UPPER``  ``"MY_VARIABLE_NAME_"`` (joined string)
  ====================  ======================  =======================================

  If no split points are detected, the input is treated as a single-element
  list and transformed accordingly.

.. signature::
  string_manip(STRIP_INTERFACES <string_var> [OUTPUT_VARIABLE <output_var>])

  Removes CMake generator expressions of the form ``$<BUILD_INTERFACE:...>`` and
  ``$<INSTALL_INTERFACE:...>`` from the value stored in ``<string_var>``. The
  expressions are removed entirely, including any leading semicolon if
  present.

  The resulting string is either stored back in ``<string_var>``, or in
  ``<output_var>`` if the ``OUTPUT_VARIABLE`` option is provided.

.. signature::
  string_manip(EXTRACT_INTERFACE <string_var> <BUILD|INSTALL> [OUTPUT_VARIABLE <output_var>])

  Extracts the content from either the ``$<BUILD_INTERFACE:...>`` or
  ``$<INSTALL_INTERFACE:...>``  generator expression within the value stored
  in ``<string_var>``, depending on the specified mode.

  The ``<BUILD|INSTALL>`` argument determines which generator expression to
  extract:

  * ``BUILD``: Extracts the content of ``$<BUILD_INTERFACE:...>``.
  * ``INSTALL``: Extracts the content of ``$<INSTALL_INTERFACE:...>``.

  If multiple generator expressions of the specified type are present, their contents
  are concatenated into a list.

  The result is stored either back in ``<string_var>``, or in ``<output_var>``
  if the ``OUTPUT_VARIABLE`` option is provided. If the specified generator
  expression is not present in the input, an empty string is returned.
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
		message(FATAL_ERROR "SPLIT argument is missing or wrong!")
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
		message(FATAL_ERROR "TRANSFORM arguments is missing or need a value!")
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
		message(FATAL_ERROR "TRANSFORM arguments is missing or need a value!")
	endif()
	if(NOT ${SM_START_CASE})
		message(FATAL_ERROR "START_CASE argument is missing!")
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
		message(FATAL_ERROR "STRIP_INTERFACES argument is missing or need a value!")
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
			# Remove the first part "$<BUILD_INTERFACE:"
			string(REPLACE "$<BUILD_INTERFACE:" "" match "${match}")
			# Remove the last character ">"
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
			# Remove the first part "$<INSTALL_INTERFACE:"
			string(REPLACE "$<INSTALL_INTERFACE:" "" match "${match}")
			# Remove the last character ">"
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
