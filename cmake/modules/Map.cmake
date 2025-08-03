# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
Map
---

Operations to manipulate maps. It requires CMake 3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

  `Reading`
    map(`SIZE`_ <map-var> <output-var>)
    map(`GET`_ <map-var> <key> <output-var>)
    map(`KEYS`_ <map-var> <output-list-var>)
    map(`VALUES`_ <map-var> <output-list-var>)

  `Search`_
    map(`FIND`_ <map-var> <value> <output-list-var>)
    map(`HAS_KEY`_ <map-var> <key> <output-var>)
    map(`HAS_VALUE`_ <map-var> <value> <output-var>)

  `Modification`_
    map(`SET`_ <map-var> <key> <value>)
    map(`ADD`_ <map-var> <key> <value>)
    map(`REMOVE`_ <map-var> <key>)

Reading
^^^^^^^

.. signature::
  map(SIZE <map-var> <output-var>)

  Get the number of key/value pairs in the map.

  Example usage:

  .. code-block:: cmake

    map(ADD my_map "fruit 1" "apple")
    map(ADD my_map "fruit 2" "banana")
    map(ADD my_map "fruit 3" "orange")
    map(SIZE map map_size)
    # map_size = 3

.. signature::
  map(GET <map-var> <key> <output-var>)

  Get the value for the given key.

  Example usage:

  .. code-block:: cmake

    map(GET map "key" map_value)

.. signature::
  map(KEYS <map-var> <output-list-var>)

  Get the list of keys in the map.

  Example usage:

  .. code-block:: cmake

    map(KEYS map map_keys)

.. signature::
  map(VALUES <map-var> <output-list-var>)

  Get the list of values in the map.

  Example usage:

  .. code-block:: cmake

    map(VALUES map map_values)

Search
^^^^^^

.. signature::
  map(FIND <map-var> <value> <output-list-var>)

  Get the list of keys that have the given value.

  Example usage:

  .. code-block:: cmake

    map(FIND map "value" map_keys)

.. signature::
  map(HAS_KEY <map-var> <key> <output-var>)

  Check if the map contains the given key.

  Example usage:

  .. code-block:: cmake

    map(HAS_KEY map "key" map_has_key)

.. signature::
  map(HAS_VALUE <map-var> <value> <output-var>)

  Check if the map contains the given value.

  Example usage:

  .. code-block:: cmake

    map(HAS_VALUE map "value" map_has_value)

Modification
^^^^^^^^^^^^

.. signature::
  map(SET <map-var> <key> <value>)

  Set the value for the given key.

  Example usage:

  .. code-block:: cmake

    map(SET map "key" "value")

.. signature::
  map(ADD <map-var> <key> <value>)

  Add a key/value pair to the map.

  Example usage:

  .. code-block:: cmake

    map(ADD map "key" "value")

.. signature::
  map(REMOVE <map-var> <key>)

  Remove a key/value pair from the map.

  Example usage:

  .. code-block:: cmake

    map(REMOVE map "key")
#]=======================================================================]

include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module
function(map)
	set(options "")
	set(one_value_args "")
	set(multi_value_args SIZE GET KEYS VALUES FIND HAS_KEY HAS_VALUE SET ADD REMOVE)
	cmake_parse_arguments(MAP "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	set(MAP_ARGN "${ARGN}") # `cmake_parse_arguments` removing empty arguments, we will work directly with ARGN to retrieve empty values when they are allowed.
	list(POP_FRONT MAP_ARGN) # Remove the operation name
	if(DEFINED MAP_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${MAP_UNPARSED_ARGUMENTS}\"!")
	endif()
	if(DEFINED MAP_SIZE)
		_map_size()
	elseif(DEFINED MAP_GET)
		_map_get()
	elseif(DEFINED MAP_KEYS)
		_map_keys()
	elseif(DEFINED MAP_VALUES)
		_map_values()
	elseif(DEFINED MAP_FIND)
		_map_find()
	elseif(DEFINED MAP_HAS_KEY)
		_map_has_key()
	elseif(DEFINED MAP_HAS_VALUE)
		_map_has_value()
	elseif(DEFINED MAP_SET)
		_map_set()
	elseif(DEFINED MAP_ADD)
		_map_add()
	elseif(DEFINED MAP_REMOVE)
		_map_remove()
	else()
		message(FATAL_ERROR "The operation name or arguments are missing!")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_size)
	list(LENGTH MAP_SIZE nb_args)
	if(NOT ${nb_args} EQUAL 2)
		message(FATAL_ERROR "SIZE requires exactly 2 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_SIZE 0 map_var)
	list(GET MAP_SIZE 1 output_var)

	set(map_content "${${map_var}}")
	set(count 0)

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()
		math(EXPR count "${count} + 1")
	endforeach()

	set(${output_var} ${count} PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_get)
	list(LENGTH MAP_GET nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "GET requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_GET 0 map_var)
	list(GET MAP_GET 1 key)
	list(GET MAP_GET 2 output_var)
	if("${key}" STREQUAL "")
		message(FATAL_ERROR "Cannot get empty key!")
	endif()

	set(map_content "${${map_var}}")
	set(found_value "${output_var}-NOTFOUND")
	set(key_is_found off)

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()

		string(LENGTH "${entry_key}" key_len)
		math(EXPR value_start "${key_len} + 1") # Skip the colon separator
		string(SUBSTRING "${entry}" ${value_start} -1 entry_value)
		if("${entry_key}" STREQUAL "${key}")
			set(found_value "${entry_value}")
			set(key_is_found on)
			break()
		endif()
	endforeach()

	set(${output_var} "${found_value}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_keys)
	list(LENGTH MAP_KEYS nb_args)
	if(NOT ${nb_args} EQUAL 2)
		message(FATAL_ERROR "KEYS requires exactly 2 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_KEYS 0 map_var)
	list(GET MAP_KEYS 1 output_var)

	set(map_content "${${map_var}}")
	set(result_keys "")

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()
		list(APPEND result_keys "${entry_key}")
	endforeach()

	set(${output_var} "${result_keys}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_values)
	list(LENGTH MAP_VALUES nb_args)
	if(NOT ${nb_args} EQUAL 2)
		message(FATAL_ERROR "VALUES requires exactly 2 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_VALUES 0 map_var)
	list(GET MAP_VALUES 1 output_var)

	set(map_content "${${map_var}}")
	set(result_values "")

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()

		string(LENGTH "${entry_key}" key_len)
		math(EXPR value_start "${key_len} + 1") # Skip the colon separator
		string(SUBSTRING "${entry}" ${value_start} -1 entry_value)
		list(APPEND result_values "${entry_value}")
	endforeach()

	set(${output_var} "${result_values}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_find)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "FIND requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 value)
	list(GET MAP_ARGN 2 output_var)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot find in empty map!")
	endif()
	if("${output_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot store result in empty variable!")
	endif()
	
	set(map_content "${${map_var}}")
	set(result_keys "")

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()
		
		string(LENGTH "${entry_key}" key_len)
		math(EXPR value_start "${key_len} + 1") # Skip the colon separator
		string(SUBSTRING "${entry}" ${value_start} -1 entry_value)
		
		list(APPEND result_values "${entry_value}")
		if("${entry_value}" STREQUAL "${value}")
			list(APPEND result_keys "${entry_key}")
		endif()
	endforeach()

	set(${output_var} "${result_keys}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_has_key)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "HAS_KEY requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 key)
	list(GET MAP_ARGN 2 output_var)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot search in empty map!")
	endif()
	if("${output_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot store result in empty variable!")
	endif()

	set(map_content "${${map_var}}")
	set(key_is_found off)

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()

		if("${entry_key}" STREQUAL "${key}")
			set(key_is_found on)
			break()
		endif()
	endforeach()

	set(${output_var} ${key_is_found} PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_has_value)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "HAS_VALUE requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 value)
	list(GET MAP_ARGN 2 output_var)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot search in empty map!")
	endif()
	if("${output_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot store result in empty variable!")
	endif()

	set(map_content "${${map_var}}")
	set(value_is_found off)

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()
		
		string(LENGTH "${entry_key}" key_len)
		math(EXPR value_start "${key_len} + 1") # Skip the colon separator
		string(SUBSTRING "${entry}" ${value_start} -1 entry_value)
		if("${entry_value}" STREQUAL "${value}")
			set(value_is_found on)
			break()
		endif()
	endforeach()

	set(${output_var} ${value_is_found} PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_set)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "SET requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 new_key)
	list(GET MAP_ARGN 2 new_value)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot set in empty map!")
	endif()
	if("${new_key}" STREQUAL "")
		message(FATAL_ERROR "Cannot set empty key!")
	endif()
	
	set(map_content "${${map_var}}")
	set(new_entry "${new_key}:${new_value}")
	set(key_is_found off)

	list(LENGTH map_content map_len)
	if(map_len GREATER 0)
		math(EXPR last_index "${map_len} - 1") # With RANGE, the last index is included
		foreach(i RANGE 0 ${last_index})
			list(GET map_content ${i} entry)
			_validate_map_key("${entry}" entry_key key_is_valid)
			if(NOT ${key_is_valid})
				continue()
			endif()

			if("${entry_key}" STREQUAL "${new_key}")
				list(REMOVE_AT map_content ${i}) # CMake has no SET operator
				list(INSERT map_content ${i} "${new_entry}")
				set(key_is_found on)
				break()
			endif()
		endforeach()
	endif()

	if(NOT ${key_is_found})
		list(APPEND map_content "${new_entry}")
	endif()
	set(${map_var} "${map_content}" PARENT_SCOPE)
	message("")
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_add)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 3)
		message(FATAL_ERROR "ADD requires exactly 3 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 new_key)
	list(GET MAP_ARGN 2 new_value)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot add in empty map!")
	endif()
	if("${new_key}" STREQUAL "")
		message(FATAL_ERROR "Cannot add empty key!")
	endif()

	set(map_content "${${map_var}}")
	set(new_entry "${new_key}:${new_value}")
	set(key_is_found off)

	foreach(entry IN ITEMS ${map_content})
		_validate_map_key("${entry}" entry_key key_is_valid)
		if(NOT ${key_is_valid})
			continue()
		endif()

		if("${entry_key}" STREQUAL "${new_key}")
			set(key_is_found on)
			break()
		endif()
	endforeach()

	if(NOT ${key_is_found})
		list(APPEND map_content "${new_entry}")
		set(${map_var} "${map_content}" PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_map_remove)
	list(LENGTH MAP_ARGN nb_args)
	if(NOT ${nb_args} EQUAL 2)
		message(FATAL_ERROR "REMOVE requires exactly 2 arguments, got ${nb_args}!")
	endif()

	list(GET MAP_ARGN 0 map_var)
	list(GET MAP_ARGN 1 key_to_remove)
	if("${map_var}" STREQUAL "")
		message(FATAL_ERROR "Cannot add in empty map!")
	endif()

	set(map_content "${${map_var}}")
	set(entry_to_remove_index -1)

	list(LENGTH map_content map_len)
	if(map_len GREATER 0)
		math(EXPR last_index "${map_len} - 1") # The last index is included in RANGE loop
		foreach(i RANGE 0 ${last_index})
			list(GET map_content ${i} entry)
			_validate_map_key("${entry}" entry_key key_is_valid)
			if(NOT ${key_is_valid})
				continue()
			endif()

			if("${entry_key}" STREQUAL "${key_to_remove}")
				set(entry_to_remove_index ${i})
				break()
			endif()
		endforeach()
	endif()

	if(NOT ${entry_to_remove_index} EQUAL -1)
		list(REMOVE_AT map_content ${entry_to_remove_index})
	endif()
	set(${map_var} "${map_content}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
function(_validate_map_key entry output_key_var output_is_valid_var)
	set(entry_key "")
	string(FIND "${entry}" ":" colon_pos)
	if(${colon_pos} EQUAL -1)
		message(WARNING "Skipping malformed entry '${entry}' (no colon found)")
		set(${output_key_var} "${output_key_var}-NOTFOUND" PARENT_SCOPE)
		set(${output_is_valid_var} off PARENT_SCOPE)
		return()
	endif()

	string(SUBSTRING "${entry}" 0 ${colon_pos} entry_key)
	if("${entry_key}" STREQUAL "")
		message(WARNING "Skipping malformed entry '${entry}' (empty key)")
		set(${output_key_var} "${output_key_var}-NOTFOUND" PARENT_SCOPE)
		set(${output_is_valid_var} off PARENT_SCOPE)
		return()
	endif()
	
	set(${output_key_var} "${entry_key}" PARENT_SCOPE)
	set(${output_is_valid_var} on PARENT_SCOPE)
endfunction()