# Copyright 2019-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
Directory
---------

Operations to manipule directories. It requires CMake 3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

    directory(`SCAN`_ <output_list_var> [LIST_DIRECTORIES <on|off>] RELATIVE <on|off> ROOT_DIR <directory_path> <INCLUDE_REGEX|EXCLUDE_REGEX> <regular_expression>)
    directory(`SCAN_DIRS`_ <output_list_var> RECURSE <on|off> RELATIVE <on|off> ROOT_DIR <directory_path> <INCLUDE_REGEX|EXCLUDE_REGEX> <regular_expression>)
    directory(`FIND_LIB`_ <output_lib_var> FIND_IMPLIB <output_implib_var> NAME <raw_filename> <STATIC|SHARED> RELATIVE <on|off> ROOT_DIR <directory_path>)

Usage
^^^^^

.. signature::
  directory(SCAN <output_list_var> [LIST_DIRECTORIES <on|off>] RELATIVE <on|off> ROOT_DIR <directory_path> <INCLUDE_REGEX|EXCLUDE_REGEX> <regular_expression>)

  Recursively scans files and directories under ``ROOT_DIR``, applies an
  optional filter based on ``INCLUDE_REGEX`` or ``EXCLUDE_REGEX``, and
  stores the result in ``<output_list_var>``.

  Paths are returned as relative to ``ROOT_DIR`` if ``RELATIVE`` is ``on``,
  or as absolute paths if ``RELATIVE`` is ``off``.

  If ``LIST_DIRECTORIES`` is ``on`` (the default), directories are included in
  the result. If ``LIST_DIRECTORIES`` is ``off``, only files are listed.

  Example usage:

  .. code-block:: cmake

    directory(SCAN result_list
              LIST_DIRECTORIES off
              RELATIVE on
              ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}"
              INCLUDE_REGEX ".*[.]cpp$|.*[.]cc$|.*[.]cxx$")
    # output is:
    #   src/main.cpp;src/util.cpp;lib/module.cpp

.. signature::
  directory(SCAN_DIRS <output_list_var> RECURSE <on|off> RELATIVE <on|off> ROOT_DIR <directory_path> <INCLUDE_REGEX|EXCLUDE_REGEX> <regular_expression>)

  Scan and collect all directories under ``ROOT_DIR`` that match the regular
  expression provided with either ``INCLUDE_REGEX`` or ``EXCLUDE_REGEX``, and
  store the result in ``<output_list_var>``.

  If ``RECURSE`` is ``on``, the function traverses subdirectories recursively.
  If ``RECURSE`` is ``off``, only the directories directly under ``ROOT_DIR``
  are considered.

  The paths in the result are returned relative to ``ROOT_DIR`` if
  ``RELATIVE`` is ``on``, or as absolute paths if ``RELATIVE`` is ``off``.

  Example usage:

  .. code-block:: cmake

    directory(SCAN_DIRS matched_dirs
              RECURSE on
              RELATIVE on
              ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}"
              INCLUDE_REGEX "include")
    # output is:
    #   src/include;src/lib/include

.. signature::
  directory(FIND_LIB <output_lib_var> FIND_IMPLIB <output_implib_var> NAME <raw_filename> <STATIC|SHARED> RELATIVE <on|off> ROOT_DIR <directory_path>)

  Search recursively in ``ROOT_DIR`` for a library and, on DLL platforms, its
  import library. The name to search for is given via ``NAME``, which should
  represent the base name of the library (without prefix or suffix).

  The matching uses system-defined prefixes and suffixes depending on the
  ``STATIC`` (by `CMAKE_STATIC_LIBRARY_PREFIX <CMAKE_STATIC_LIBRARY_PREFIX>`_ and `CMAKE_STATIC_LIBRARY_SUFFIX <https://cmake.org/cmake/help/latest/variable/CMAKE_STATIC_LIBRARY_SUFFIX.html>`_)
  or ``SHARED`` (by `CMAKE_SHARED_LIBRARY_PREFIX <https://cmake.org/cmake/help/latest/variable/CMAKE_SHARED_LIBRARY_PREFIX.html>`_ and
  `CMAKE_SHARED_LIBRARY_SUFFIX <https://cmake.org/cmake/help/latest/variable/CMAKE_SHARED_LIBRARY_SUFFIX.html>`_) flag, as well as 
  `CMAKE_FIND_LIBRARY_PREFIXES <https://cmake.org/cmake/help/latest/variable/CMAKE_FIND_LIBRARY_PREFIXES.html>`_ and `CMAKE_FIND_LIBRARY_SUFFIXES <https://cmake.org/cmake/help/latest/variable/CMAKE_STATIC_LIBRARY_SUFFIX.html>`_ if
  defined. This makes the behavior similar to `find_library() <https://cmake.org/cmake/help/latest/command/find_library.html>`_, but more robust.

  If a matching library is found, its path is stored in ``<output_lib_var>``. If a
  matching import library is found, its path is stored in ``<output_implib_var>``. If
  ``RELATIVE`` is set to ``on``, the results are relative to ``ROOT_DIR``.
  Otherwise, absolute paths are returned.

  If no match is found, the values will be ``<output_lib_var>-NOTFOUND`` and
  ``<output_implib_var>-NOTFOUND``. If multiple matches are found, a fatal error
  is raised.
  
  This command is especially useful to locate dependency artifacts when
  configuring `imported targets <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#imported-targets>`_ manually. The resulting paths are typically
  used to set properties like `IMPORTED_LOCATION <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_LOCATION.html>`_ and
  `IMPORTED_IMPLIB_DEBUG <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_IMPLIB.html>`_ on an imported target, particularly in development
  or custom build setups where standard `find_library() <https://cmake.org/cmake/help/latest/command/find_library.html>`_ behavior is not
  sufficient.

  Example usage:

  .. code-block:: cmake

    directory(FIND_LIB mylib_path
              FIND_IMPLIB mylib_import
              NAME "zlib1"
              SHARED
              RELATIVE on
              ROOT_DIR "${CMAKE_SOURCE_DIR}/libs")
    # output is:
    #   lib=lib/zlib1.dll
    #   implib=lib/zlib1.lib
#]=======================================================================]

include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module.
function(directory)
	set(options SHARED STATIC)
	set(one_value_args SCAN SCAN_DIRS LIST_DIRECTORIES RELATIVE ROOT_DIR INCLUDE_REGEX EXCLUDE_REGEX RECURSE FIND_LIB FIND_IMPLIB NAME)
	set(multi_value_args "")
	cmake_parse_arguments(DIR "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(DEFINED DIR_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${DIR_UNPARSED_ARGUMENTS}\"")
	endif()

	if(DEFINED DIR_SCAN)
		_directory_scan()
	elseif(DEFINED DIR_SCAN_DIRS)
		_directory_scan_dirs()
	elseif(DEFINED DIR_FIND_LIB)
		_directory_find_lib()
	else()
		message(FATAL_ERROR "Operation argument is missing")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage.
macro(_directory_scan)
	if(NOT DEFINED DIR_SCAN)
		message(FATAL_ERROR "SCAN arguments is missing")
	endif()
	if((DEFINED DIR_LIST_DIRECTORIES)
		AND	((NOT ${DIR_LIST_DIRECTORIES} STREQUAL "on")
		AND (NOT ${DIR_LIST_DIRECTORIES} STREQUAL "off")))
		message(FATAL_ERROR "LIST_DIRECTORIES arguments is wrong")
	endif()
	if((NOT DEFINED DIR_RELATIVE)
		OR ((NOT ${DIR_RELATIVE} STREQUAL "on")
		AND (NOT ${DIR_RELATIVE} STREQUAL "off")))
		message(FATAL_ERROR "RELATIVE arguments is wrong")
	endif()
	if(NOT DEFINED DIR_ROOT_DIR)
		message(FATAL_ERROR "ROOT_DIR arguments is missing")
	endif()
	if((NOT DEFINED DIR_INCLUDE_REGEX)
		AND (NOT DEFINED DIR_EXCLUDE_REGEX))
		message(FATAL_ERROR "INCLUDE_REGEX|EXCLUDE_REGEX arguments is missing")
	endif()

	set(file_list "")
	if(NOT DEFINED DIR_LIST_DIRECTORIES)
		set(DIR_LIST_DIRECTORIES on)
	endif()
	if(${DIR_RELATIVE})
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES ${DIR_LIST_DIRECTORIES} RELATIVE "${DIR_ROOT_DIR}" CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	else()
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES ${DIR_LIST_DIRECTORIES} CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	endif()
	
	if(DEFINED DIR_INCLUDE_REGEX)
		list(FILTER file_list INCLUDE REGEX "${DIR_INCLUDE_REGEX}")
	elseif(DEFINED DIR_EXCLUDE_REGEX)
		list(FILTER file_list EXCLUDE REGEX "${DIR_EXCLUDE_REGEX}")
	endif()
	
	set(${DIR_SCAN} "${file_list}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_directory_scan_dirs)
	if(NOT DEFINED DIR_SCAN_DIRS)
		message(FATAL_ERROR "SCAN_DIRS arguments is missing")
	endif()
	if((NOT DEFINED DIR_RECURSE)
		OR ((NOT ${DIR_RECURSE} STREQUAL "on")
		AND (NOT ${DIR_RECURSE} STREQUAL "off")))
		message(FATAL_ERROR "RECURSE arguments is wrong")
	endif()
	if((NOT DEFINED DIR_RELATIVE)
		OR ((NOT ${DIR_RELATIVE} STREQUAL "on")
		AND (NOT ${DIR_RELATIVE} STREQUAL "off")))
		message(FATAL_ERROR "RELATIVE arguments is wrong")
	endif()
	if(NOT DEFINED DIR_ROOT_DIR)
		message(FATAL_ERROR "ROOT_DIR arguments is missing")
	endif()
	if((NOT DEFINED DIR_INCLUDE_REGEX)
		AND (NOT DEFINED DIR_EXCLUDE_REGEX))
		message(FATAL_ERROR "INCLUDE_REGEX|EXCLUDE_REGEX arguments is missing")
	endif()

	set(file_list "")
	if(${DIR_RECURSE} AND ${DIR_RELATIVE})
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES on RELATIVE "${DIR_ROOT_DIR}" CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	elseif(${DIR_RECURSE} AND NOT ${DIR_RELATIVE})
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES on CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	elseif(NOT ${DIR_RECURSE} AND ${DIR_RELATIVE})
		file(GLOB file_list LIST_DIRECTORIES on RELATIVE "${DIR_ROOT_DIR}" CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	else()
		file(GLOB file_list LIST_DIRECTORIES on CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	endif()

	# Removes non-directory files.
	set(directory_list "")
	foreach(file IN ITEMS ${file_list})
		if(IS_DIRECTORY "${file}")
			list(APPEND directory_list "${file}")
		endif()
	endforeach()

	if(DEFINED DIR_INCLUDE_REGEX)
		list(FILTER directory_list INCLUDE REGEX "${DIR_INCLUDE_REGEX}")
	elseif(DEFINED DIR_EXCLUDE_REGEX)
		list(FILTER directory_list EXCLUDE REGEX "${DIR_EXCLUDE_REGEX}")
	endif()

	set(${DIR_SCAN_DIRS} "${directory_list}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_directory_find_lib)
	if(NOT DEFINED DIR_FIND_LIB)
		message(FATAL_ERROR "FIND_LIB arguments is missing or need a value!")
	endif()
	if(NOT DEFINED DIR_FIND_IMPLIB)
		message(FATAL_ERROR "FIND_IMPLIB arguments is missing or need a value!")
	endif()
	if(NOT DEFINED DIR_NAME)
		message(FATAL_ERROR "NAME arguments is missing or need a value!")
	endif()
	if((NOT ${DIR_SHARED})
		AND (NOT ${DIR_STATIC}))
		message(FATAL_ERROR "SHARED|STATIC arguments is missing!")
	endif()
	if(${DIR_SHARED} AND ${DIR_STATIC})
		message(FATAL_ERROR "SHARED|STATIC cannot be used together!")
	endif()
	if((NOT DEFINED DIR_RELATIVE)
		OR ((NOT ${DIR_RELATIVE} STREQUAL "on")
		AND (NOT ${DIR_RELATIVE} STREQUAL "off")))
		message(FATAL_ERROR "RELATIVE arguments is wrong!")
	endif()
	if(NOT DEFINED DIR_ROOT_DIR)
		message(FATAL_ERROR "ROOT_DIR arguments is missing or need a value!")
	endif()

	set(file_list "")
	if(${DIR_RELATIVE})
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES off RELATIVE "${DIR_ROOT_DIR}" CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	else()
		file(GLOB_RECURSE file_list FOLLOW_SYMLINKS LIST_DIRECTORIES off CONFIGURE_DEPENDS "${DIR_ROOT_DIR}/*")
	endif()

	# Build regex to find library
	if(${DIR_SHARED})
		set(lib_prefix_list "${CMAKE_SHARED_LIBRARY_PREFIX}")
		set(lib_suffix_list "${CMAKE_SHARED_LIBRARY_SUFFIX}")
	elseif(${DIR_STATIC})
		set(lib_prefix_list "${CMAKE_STATIC_LIBRARY_PREFIX}")
		set(lib_suffix_list "${CMAKE_STATIC_LIBRARY_SUFFIX}")
	else()
		message(FATAL_ERROR "Wrong build type!")
	endif()
	list(JOIN CMAKE_FIND_LIBRARY_PREFIXES "|" lib_prefix_list)
	set(lib_regex "^(${lib_prefix_list})?${DIR_NAME}(${lib_suffix_list})$")
	string(REGEX REPLACE [[(\.)]] [[\\\1]] lib_regex "${lib_regex}") # escape '.' char

	# Build regex to find imported library
	set(implib_prefix_list "${lib_prefix_list}")
	set(implib_suffix_list "")
	list(JOIN CMAKE_FIND_LIBRARY_SUFFIXES "|" implib_suffix_list)
	set(implib_regex "^(${implib_prefix_list})?${DIR_NAME}(${implib_suffix_list})$")
	string(REGEX REPLACE [[(\.)]] [[\\\1]] implib_regex "${implib_regex}") # escape '.' char

	# Search lib and implib
	set(library_found_path "${DIR_FIND_LIB}-NOTFOUND")
	set(import_library_found_path "${DIR_FIND_IMPLIB}-NOTFOUND")
	foreach(file IN ITEMS ${file_list})
		cmake_path(GET file FILENAME file_name)
		if("${file_name}" MATCHES "${lib_regex}")
			# Find library (lib)
			if("${library_found_path}" STREQUAL "${DIR_FIND_LIB}-NOTFOUND")
				set(library_found_path "${file}")
			else()
				message(FATAL_ERROR "At least two matches with the library name \"${DIR_NAME}\"!")
			endif()
		endif()
		if("${file_name}" MATCHES "${implib_regex}")
			# Find imported library (implib)
			if("${import_library_found_path}" STREQUAL "${DIR_FIND_IMPLIB}-NOTFOUND")
				set(import_library_found_path "${file}")
			else()
				message(FATAL_ERROR "At least two matches with the import library name \"${DIR_NAME}\"!")
			endif()
		endif()
	endforeach()

	set(${DIR_FIND_LIB} "${library_found_path}" PARENT_SCOPE)
	set(${DIR_FIND_IMPLIB} "${import_library_found_path}" PARENT_SCOPE)
endmacro()
