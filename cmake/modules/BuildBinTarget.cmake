# Copyright 2019-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
BuildBinTarget
--------------

Operations to fully create and configure a *C++* binary target. It greatly
simplifies the most common process of creating an executable or library, by
wrapping calls to CMake functions in higher-level functions. However, for more
complex cases, you will need to use CMake's native commands. It requires CMake
3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

  build_bin_target(`CREATE`_ <target-name> <STATIC|SHARED|HEADER|EXEC>)
  build_bin_target(`CONFIGURE_SETTINGS`_ <target-name> [...])
  build_bin_target(`ADD_SOURCES`_ <target-name> [...])
  build_bin_target(`ADD_PRECOMPILED_HEADER`_ <target-name> HEADER_FILE <file-path>)
  build_bin_target(`ADD_INCLUDE_DIRECTORIES`_ <target-name> INCLUDE_DIRECTORIES <directory-path>...)

Usage
^^^^^

.. signature::
  build_bin_target(CREATE <target-name> <STATIC|SHARED|HEADER|EXEC>)

  Create a binary target named ``<target-name>`` and add it to the current
  CMake project, according to the specified binary type: ``STATIC``, ``SHARED``
  , ``HEADER``, ``EXEC``.

  Example usage:

  .. code-block:: cmake

    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(CREATE "my_shared_lib" SHARED)

.. signature::
  build_bin_target(CONFIGURE_SETTINGS <target-name> [...])

  Configure settings for an existing binary target:

  .. code-block:: cmake

    build_bin_target(CONFIGURE_SETTINGS <target-name>
                    [COMPILER_FEATURES <feature>...]
                    [COMPILE_DEFINITIONS <definition>...]
                    [COMPILE_OPTIONS <option>...]
                    [LINK_OPTIONS <option>...])

  This command updates compile and link settings of a previously created
  target ``<target-name>``. The following configuration options are supported:

  * ``COMPILER_FEATURES``: Add required compiler features (e.g., ``cxx_std_20``,
    ``cxx_lambda``).
  * ``COMPILE_DEFINITIONS``: Add preprocessor definitions (e.g., ``MY_DEFINE``
    or ``MY_DEFINE=42``).
  * ``COMPILE_OPTIONS``: Add compiler command-line options (e.g., ``-Wall``,
    ``/W4``).
  * ``LINK_OPTIONS``: Add linker command-line options (e.g., ``-s``,
    ``/INCREMENTAL:NO``).

  At the first call, the command sets the :cmake:prop_tgt:`CXX_STANDARD <cmake:prop_tgt:CXX_STANDARD>` property
    using the value of :cmake:variable:`CMAKE_CXX_STANDARD <cmake:variable:CMAKE_CXX_STANDARD>`, which must be defined.

  The target is also assigned to a default folder for improved IDE integration.
  All options are optional and may appear in any order. If a section is
  missing, it is simply ignored without warning.

  This command is intended for targets that have been previously created
  using :command:`build_bin_target(CREATE)`.

  Example usage:

  .. code-block:: cmake

    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(CONFIGURE_SETTINGS "my_static_lib"
      COMPILER_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
    )

.. signature::
  build_bin_target(ADD_SOURCES <target-name> [...])

  Add source and header files to an existing binary target:

  .. code-block:: cmake

    build_bin_target(ADD_SOURCES <target-name>
                    SOURCE_FILES <file-path>...
                    PRIVATE_HEADER_FILES <file-path>...
                    PUBLIC_HEADER_FILES <file-path>...)

  Assigns implementation and header files to the given binary target
  ``<target-name>`` with ``PRIVATE`` visibility:

  * ``SOURCE_FILES``: A list of source files (e.g., ``.cpp``, ``.c``)
    typically located in the ``src/`` directory.
  * ``PRIVATE_HEADER_FILES``: A list of private headers (e.g., ``.h``)
    typically located in the ``src/`` directory.
  * ``PUBLIC_HEADER_FILES``: A list of public headers, usually found in an
    ``include/`` directory.

  It also defines a logical grouping of source files in IDEs (e.g., Visual
  Studio) using :cmake:command:`source_group() <cmake:command:source_group>`, based on the project's source tree.

  This command is intended for targets that have been previously created
  using :command:`build_bin_target(CREATE)`, and is typically used in conjunction
  with :command:`directory(COLLECT_SOURCES_BY_POLICY)` to get the required
  files.

  Example usage:

  .. code-block:: cmake

    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "src/main.cpp" "src/util.cpp" "src/source_1.cpp"
      PRIVATE_HEADER_FILES "src/util.h" "src/source_1.h"
      PUBLIC_HEADER_FILES "include/lib_1.h" "include/lib_2.h"
    )

    # Full example
    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(CONFIGURE_SETTINGS "my_static_lib"
      COMPILER_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
    )
    directory(COLLECT_SOURCES_BY_POLICY
      PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
      SRC_DIR "${CMAKE_SOURCE_DIR}/src"
      SRC_SOURCE_FILES sources
      PUBLIC_HEADER_DIR public_headers_dir
      PUBLIC_HEADER_FILES public_headers
      PRIVATE_HEADER_DIR private_headers_dir
      PRIVATE_HEADER_FILES private_headers
    )
    build_bin_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "${sources}"
      PRIVATE_HEADER_FILES "${private_headers}"
      PUBLIC_HEADER_FILES "${public_headers}"
    )

.. signature::
  build_bin_target(ADD_PRECOMPILED_HEADER <target-name> HEADER_FILE <file-path>)

  Add a precompiled header file (PCH) ``<file_path>`` to an existing binary
  target ``<target_name>`` with ``PRIVATE`` visibility.

  This command is intended for targets that have been previously created
  using :command:`build_bin_target(CREATE)`.

  Example usage:

  .. code-block:: cmake

    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(ADD_PRECOMPILED_HEADER "my_static_lib"
      HEADER_FILE "src/header_pch.h")

    # Full example
    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(CONFIGURE_SETTINGS "my_static_lib"
      COMPILER_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
    )
    directory(COLLECT_SOURCES_BY_POLICY
      PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
      SRC_DIR "${CMAKE_SOURCE_DIR}/src"
      SRC_SOURCE_FILES sources
      PUBLIC_HEADER_DIR public_headers_dir
      PUBLIC_HEADER_FILES public_headers
      PRIVATE_HEADER_DIR private_headers_dir
      PRIVATE_HEADER_FILES private_headers
    )
    build_bin_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "${sources}"
      PRIVATE_HEADER_FILES "${private_headers}"
      PUBLIC_HEADER_FILES "${public_headers}"
    )
    build_bin_target(ADD_PRECOMPILED_HEADER "my_static_lib"
      HEADER_FILE "src/header_pch.h")

.. signature::
  build_bin_target(ADD_INCLUDE_DIRECTORIES <target-name> INCLUDE_DIRECTORIES <directory-path>...)

  Add include directories to an existing binary target ``<target_name>`` with
  ``PRIVATE`` visibility.

  This command is intended for targets that have been previously created
  using :command:`build_bin_target(CREATE)`, and is typically used in conjunction
  with :command:`directory(COLLECT_SOURCES_BY_POLICY)` to get the required
  files.

  Example usage:

  .. code-block:: cmake

    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(ADD_INCLUDE_DIRECTORIES "my_static_lib"
      INCLUDE_DIRECTORIES "include")

    # Full example
    build_bin_target(CREATE "my_static_lib" STATIC)
    build_bin_target(CONFIGURE_SETTINGS "my_static_lib"
      COMPILER_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
    )
    directory(COLLECT_SOURCES_BY_POLICY
      PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
      SRC_DIR "${CMAKE_SOURCE_DIR}/src"
      SRC_SOURCE_FILES sources
      PUBLIC_HEADER_DIR public_headers_dir
      PUBLIC_HEADER_FILES public_headers
      PRIVATE_HEADER_DIR private_headers_dir
      PRIVATE_HEADER_FILES private_headers
    )
    build_bin_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "${sources}"
      PRIVATE_HEADER_FILES "${private_headers}"
      PUBLIC_HEADER_FILES "${public_headers}"
    )
    build_bin_target(ADD_PRECOMPILED_HEADER "my_static_lib"
      HEADER_FILE "src/header_pch.h")
    build_bin_target(ADD_INCLUDE_DIRECTORIES "my_static_lib"
      INCLUDE_DIRECTORIES "$<$<BOOL:${private_headers_dir}>:${private_headers_dir}>" "${public_headers_dir}")
#]=======================================================================]

include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module.
function(build_bin_target)
	set(options STATIC SHARED HEADER EXEC)
	set(one_value_args CREATE CONFIGURE_SETTINGS ADD_SOURCES ADD_PRECOMPILED_HEADER HEADER_FILE ADD_INCLUDE_DIRECTORIES)
	set(multi_value_args COMPILER_FEATURES COMPILE_DEFINITIONS COMPILE_OPTIONS LINK_OPTIONS SOURCE_FILES PRIVATE_HEADER_FILES PUBLIC_HEADER_FILES INCLUDE_DIRECTORIES)
	cmake_parse_arguments(BBT "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(DEFINED BBT_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${BBT_UNPARSED_ARGUMENTS}\"")
	endif()
	if(DEFINED BBT_CREATE)
		_build_bin_target_create()
	elseif(DEFINED BBT_CONFIGURE_SETTINGS)
		_build_bin_target_config_settings()
	elseif(DEFINED BBT_ADD_SOURCES)
		_build_bin_target_add_sources()
	elseif(DEFINED BBT_ADD_PRECOMPILED_HEADER)
		_build_bin_target_add_pre_header()
	elseif(DEFINED BBT_ADD_INCLUDE_DIRECTORIES)
		_build_bin_target_add_include_dirs()
	else()
		message(FATAL_ERROR "Operation argument is missing!")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage.
macro(_build_bin_target_create)
	if(NOT DEFINED BBT_CREATE)
		message(FATAL_ERROR "CREATE argument is missing or need a value!")
	endif()
	if(TARGET "${BBT_CREATE}")
		message(FATAL_ERROR "The target \"${BBT_CREATE}\" already exists!")
	endif()
	if((NOT ${BBT_STATIC})
		AND (NOT ${BBT_SHARED})
		AND (NOT ${BBT_HEADER})
		AND (NOT ${BBT_EXEC}))
		message(FATAL_ERROR "STATIC|SHARED|HEADER|EXEC arguments is missing!")
	endif()
	if(${BBT_STATIC} AND ${BBT_SHARED} AND ${BBT_HEADER} AND ${BBT_EXEC})
		message(FATAL_ERROR "STATIC|SHARED|HEADER|EXEC cannot be used together!")
	endif()

	if(${BBT_STATIC})
		add_library("${BBT_CREATE}" STATIC)
		message(STATUS "Static library target added to project")
	elseif(${BBT_SHARED})
		# All libraries will be built shared unless the library was explicitly
		# added as a static library
		set(BUILD_SHARED_LIBS                           on)
		message(STATUS "All exported symbols are hidden by default")
		set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS            off)
		set(CMAKE_CXX_VISIBILITY_PRESET                 "hidden")
		set(CMAKE_VISIBILITY_INLINES_HIDDEN             on)
		add_library("${BBT_CREATE}" SHARED)
		message(STATUS "Shared library target added to project")
	elseif(${BBT_HEADER})
		add_library("${BBT_CREATE}" INTERFACE)
		message(STATUS "Header-only library target added to project")
	elseif(${BBT_EXEC})
		add_executable("${BBT_CREATE}")
		message(STATUS "Executable target added to project")
	else()
		message(FATAL_ERROR "Invalid binary type: expected STATIC, SHARED, HEADER or EXEC!")
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_build_bin_target_config_settings)
	if(NOT DEFINED BBT_CONFIGURE_SETTINGS)
		message(FATAL_ERROR "CONFIGURE_SETTINGS argument is missing or need a value!")
	endif()
	if(NOT TARGET "${BBT_CONFIGURE_SETTINGS}")
		message(FATAL_ERROR "The target \"${BBT_CONFIGURE_SETTINGS}\" does not exists!")
	endif()
	if("COMPILER_FEATURES" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "COMPILER_FEATURES argument is missing or need a value!")
	endif()
	if("COMPILE_DEFINITIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "COMPILE_DEFINITIONS argument is missing or need a value!")
	endif()
	if("COMPILE_OPTIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "COMPILE_OPTIONS argument is missing or need a value!")
	endif()
	if("LINK_OPTIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "LINK_OPTIONS argument is missing or need a value!")
	endif()
	if(NOT DEFINED CMAKE_CXX_STANDARD)
		message(FATAL_ERROR "CMAKE_CXX_STANDARD is not set!")
	endif()
	
	# Add the bin target in a folder for IDE project
	set_target_properties("${BBT_CONFIGURE_SETTINGS}" PROPERTIES FOLDER "")
	
	# Add C++ standard in target compiler features
	get_target_property(compiler_features "${BBT_CONFIGURE_SETTINGS}" COMPILE_FEATURES)
	set(cxx_standard "cxx_std_${CMAKE_CXX_STANDARD}")
	if(NOT compiler_features STREQUAL "NOTFOUND")
		list(FIND compiler_features "${cxx_standard}" index_of)
	else()
		set(index_of -1)
	endif()
	if(index_of EQUAL -1)
		target_compile_features("${BBT_CONFIGURE_SETTINGS}" PRIVATE "${cxx_standard}")
	endif()

	# Add input target compiler features
	if(DEFINED BBT_COMPILER_FEATURES)
		target_compile_features("${BBT_CONFIGURE_SETTINGS}"
			PRIVATE
				${BBT_COMPILER_FEATURES} # don't add quote (but yeah, it's inconsistent with the other CMake functions)
		)
		message(STATUS "C++ standard set to: C++${CMAKE_CXX_STANDARD}")
		message(STATUS "Applied compile features: ${BBT_COMPILER_FEATURES}")
	else()
		message(STATUS "Applied compile features: (none)")
	endif()

	# Add input target compile definitions
	if(DEFINED BBT_COMPILE_DEFINITIONS)
		target_compile_definitions("${BBT_CONFIGURE_SETTINGS}"
			PRIVATE
				"${BBT_COMPILE_DEFINITIONS}"
		)
		message(STATUS "Applied compile definitions: ${BBT_COMPILE_DEFINITIONS}")
	else()
		message(STATUS "Applied compile definitions: (none)")
	endif()
	
	# Add input target compile options
	if(DEFINED BBT_COMPILE_OPTIONS)
		target_compile_options("${BBT_CONFIGURE_SETTINGS}"
			PRIVATE
				"${BBT_COMPILE_OPTIONS}"
		)
		message(STATUS "Applied compile options: ${BBT_COMPILE_OPTIONS}")
	else()
		message(STATUS "Applied compile options: (none)")
	endif()

	# Add input target link options
	if(DEFINED BBT_LINK_OPTIONS)
		get_target_property(bin_type "${BBT_CONFIGURE_SETTINGS}" TYPE)
		if(bin_type STREQUAL "STATIC_LIBRARY")
			message(FATAL_ERROR "No link options can be added to a static library!")
		endif()
		target_link_options("${BBT_CONFIGURE_SETTINGS}"
			PRIVATE
				"${BBT_LINK_OPTIONS}"
		)
		message(STATUS "Applied link options: ${BBT_LINK_OPTIONS}")
	else()
		message(STATUS "Applied link options: (none)")
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_build_bin_target_add_sources)
	if(NOT DEFINED BBT_ADD_SOURCES)
		message(FATAL_ERROR "ADD_SOURCES argument is missing or need a value!")
	endif()
	if(NOT TARGET "${BBT_ADD_SOURCES}")
		message(FATAL_ERROR "The target \"${BBT_ADD_SOURCES}\" does not exists!")
	endif()
	if((NOT DEFINED BBT_SOURCE_FILES)
		AND (NOT "SOURCE_FILES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
		message(FATAL_ERROR "SOURCE_FILES argument is missing or need a value!")
	endif()
	if((NOT DEFINED BBT_PRIVATE_HEADER_FILES)
		AND (NOT "PRIVATE_HEADER_FILES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
		message(FATAL_ERROR "PRIVATE_HEADER_FILES argument is missing or need a value!")
	endif()
	if((NOT DEFINED BBT_PUBLIC_HEADER_FILES)
		AND (NOT "PUBLIC_HEADER_FILES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
		message(FATAL_ERROR "PUBLIC_HEADER_FILES argument is missing or need a value!")
	endif()

	message(STATUS "Assigning sources and headers to the target")
	message(STATUS "Organizing files according to the project tree")
	if(DEFINED BBT_SOURCE_FILES)
		target_sources("${BBT_ADD_SOURCES}" PRIVATE "${BBT_SOURCE_FILES}")
		source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}"
			FILES "${BBT_SOURCE_FILES}")
	endif()
	if(DEFINED BBT_PRIVATE_HEADER_FILES)
		target_sources("${BBT_ADD_SOURCES}" PRIVATE "${BBT_PRIVATE_HEADER_FILES}")
		source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}"
			FILES "${BBT_PRIVATE_HEADER_FILES}")
	endif()
	if(DEFINED BBT_PUBLIC_HEADER_FILES)
		target_sources("${BBT_ADD_SOURCES}" PRIVATE "${BBT_PUBLIC_HEADER_FILES}")
		source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}"
			FILES "${BBT_PUBLIC_HEADER_FILES}")
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_build_bin_target_add_pre_header)
	if(NOT DEFINED BBT_ADD_PRECOMPILED_HEADER)
		message(FATAL_ERROR "ADD_PRECOMPILED_HEADER argument is missing or need a value!")
	endif()
	if(NOT TARGET "${BBT_ADD_PRECOMPILED_HEADER}")
		message(FATAL_ERROR "The target \"${BBT_ADD_PRECOMPILED_HEADER}\" does not exists!")
	endif()
	if(NOT DEFINED BBT_HEADER_FILE)
		message(FATAL_ERROR "HEADER_FILE argument is missing or need a value!")
	endif()
	if(NOT EXISTS "${BBT_HEADER_FILE}")
		message(FATAL_ERROR "Given path: ${BBT_HEADER_FILE} does not refer to an existing path or directory on disk!")
	endif()

	target_precompile_headers("${BBT_ADD_PRECOMPILED_HEADER}"
		PRIVATE
			"${BBT_HEADER_FILE}"
	)
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_build_bin_target_add_include_dirs)
	if(NOT DEFINED BBT_ADD_INCLUDE_DIRECTORIES)
		message(FATAL_ERROR "ADD_INCLUDE_DIRECTORIES argument is missing or need a value!")
	endif()
	if(NOT TARGET "${BBT_ADD_INCLUDE_DIRECTORIES}")
		message(FATAL_ERROR "The target \"${BBT_ADD_INCLUDE_DIRECTORIES}\" does not exists!")
	endif()
	if((NOT DEFINED BBT_INCLUDE_DIRECTORIES)
		AND (NOT "INCLUDE_DIRECTORIES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
		message(FATAL_ERROR "INCLUDE_DIRECTORIES argument is missing or need a value!")
	endif()
	
	if(DEFINED BBT_INCLUDE_DIRECTORIES)
		target_include_directories("${BBT_ADD_INCLUDE_DIRECTORIES}"
			# @see https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#build-specification-and-usage-requirements
			# and https://stackoverflow.com/questions/26243169/cmake-target-include-directories-meaning-of-scope
			# and https://cmake.org/pipermail/cmake/2017-October/066457.html.
			# If PRIVATE is specified for a certain option/property, then that option/property will only impact
			# the current target. If PUBLIC is specified, then the option/property impacts both the current
			# target and any others that link to it. If INTERFACE is specified, then the option/property does
			# not impact the current target but will propagate to other targets that link to it.
			PRIVATE
				"${BBT_INCLUDE_DIRECTORIES}"
		)
	endif()
endmacro()
