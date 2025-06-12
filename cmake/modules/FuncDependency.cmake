# Copyright 2019-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
Dependency
---------

Operations to manipule dependencies. It requires CMake 3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

    dependency(`IMPORT`_ <lib_name> <STATIC|SHARED> [RELEASE_NAME <raw_filename>] [DEBUG_NAME <raw_filename>] ROOT_DIR <directory_path> INCLUDE_DIR <directory_path>)
    dependency(`EXPORT`_ <lib_name> <BUILD_TREE|INSTALL_TREE> [APPEND] OUTPUT_FILE <file_path>)
    dependency(`INCLUDE_DIRECTORIES`_ <lib_name> <SET|APPEND> PUBLIC <gen_expr_list> ...)
    dependency(`IMPORTED_LOCATION`_ <lib_name> [CONFIGURATION <build_type>] PUBLIC <gen_expr_list> ...)

Usage
^^^^^

.. signature::
  dependency(IMPORT <lib_name> <STATIC|SHARED> [RELEASE_NAME <raw_filename>] [DEBUG_NAME <raw_filename>] ROOT_DIR <directory_path> INCLUDE_DIR <directory_path>)

  Create an imported library target named ``<lib_name>`` by locating its
  binary files and setting the necessary target properties. This command
  combines behavior similar to `find_library() <https://cmake.org/cmake/help/latest/command/find_library.html>`_ and
  `add_library(IMPORTED) <https://cmake.org/cmake/help/latest/command/add_library.html>`_.

  The command requires either the ``STATIC`` or ``SHARED`` keyword to specify
  the type of library. Only one may be used. At least one of
  ``RELEASE_NAME <raw_filename>`` or ``DEBUG_NAME <raw_filename>`` must be
  provided. Both can be used. These arguments determine which configurations
  of the library will be available, typically matching values in the
  `CMAKE_CONFIGURATION_TYPES <https://cmake.org/cmake/help/latest/variable/CMAKE_CONFIGURATION_TYPES.html>`_ variable.

  The value of ``<raw_filename>`` should be the core name of the library file,
  stripped of:

  * Any version numbers.
  * Platform-specific prefixes (e.g. ``lib``).
  * Platform-specific suffixes (e.g. ``.so``, ``.dll``, ``.a``, ``.lib``).

  The file will be resolved by scanning recursively all files in the given
  ``ROOT_DIR`` and attempting to match against expected filename patterns
  constructed using the relevant ``CMAKE_<CONFIG>_LIBRARY_PREFIX`` and
  ``CMAKE_<CONFIG>_LIBRARY_SUFFIX``, accounting for platform conventions
  and possible version-number noise in filenames. More specifically, it tries
  to do a matching between the ``<raw_filename>`` in format
  ``<CMAKE_STATIC_LIBRARY_PREFIX|CMAKE_SHARED_LIBRARY_PREFIX><raw_filename>
  <verions-numbers><CMAKE_STATIC_LIBRARY_SUFFIX|CMAKE_SHARED_LIBRARY_SUFFIX>``
  and each filename found striped from their numeric and special character
  version and their suffix and their prefix based on the plateform and the
  kind of library ``STATIC`` or ``SHARED``. See the command module
  :command:`directory(SCAN)`, that is used internally, for full details.

  If more than one file matches or no file is found, an error is raised.

  Once located, an imported target is created using `add_library(IMPORTED) <https://cmake.org/cmake/help/latest/command/add_library.html>`_ and
  appropriate properties for each available configuration (``RELEASE`` and/or
  ``DEBUG``) are set, including paths to the binary and import libraries (if
  applicable), as well as the soname.

  The following target properties are configured:

    ``INTERFACE_INCLUDE_DIRECTORIES``
      Set to the directory given by ``INCLUDE_DIR``. This path is propagated
      to consumers of the imported target during build and link phases. See
      the `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_INCLUDE_DIRECTORIES.html>`_ for full details.

    ``INTERFACE_INCLUDE_DIRECTORIES_BUILD``
      Set to an empty value. This is a *custom property*, not used by CMake
      natively, intended to track include directories for usage from the
      build-tree context.

    ``INTERFACE_INCLUDE_DIRECTORIES_INSTALL``
      Set to an empty value. This is a *custom property* intended for tracking
      include paths during installation or packaging, for usage from the
      install-tree context.

    ``IMPORTED_LOCATION_<CONFIG>``
      The full path to the actual library file (e.g. ``.a``, ``.so``, ``.dll``),
      set separately for each configuration (``RELEASE`` and/or ``DEBUG``). See the `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_LOCATION_CONFIG.html>`_ for full details.

    ``IMPORTED_LOCATION_BUILD_<CONFIG>``
      *Custom property* set to an empty value. Intended for build-tree specific
      overrides of the library path, for usage from the build-tree context

    ``IMPORTED_LOCATION_INSTALL_<CONFIG>``
      *Custom property* set to an empty value. Intended for install-time
      overrides of the library path, for usage from the install-tree context.

    ``IMPORTED_IMPLIB_<CONFIG>``
      On DLL-based platforms (e.g. Windows), set to the full path of the
      import library file (e.g. ``.lib``, ``.dll.a``) for the corresponding
      configuration. See the `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_IMPLIB_CONFIG.html>`_ for full details.

    ``IMPORTED_SONAME_<CONFIG>``
      Set to the filename of the resolved library (without path), allowing
      CMake to handle runtime linking and version resolution. See the
      `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_SONAME_CONFIG.html>`_ for full details.

    ``IMPORTED_CONFIGURATIONS``
      Appended with each configuration for which a library was found and
      configured (e.g. ``RELEASE``, ``DEBUG``). See the `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_CONFIGURATIONS.html>`_ for full
      details.

  Example usage:

  .. code-block:: cmake

    dependency(IMPORT "mylib"
      SHARED
      RELEASE_NAME "mylib_1.11.0"
      DEBUG_NAME "mylibd_1.11.0"
      ROOT_DIR "${CMAKE_SOURCE_DIR}/libs"
      INCLUDE_DIR "${CMAKE_SOURCE_DIR}/include/mylib"
    )

.. signature::
  dependency(EXPORT <lib_name> <BUILD_TREE|INSTALL_TREE> [APPEND] OUTPUT_FILE <file_path>)

  Export an imported library target ``<lib_name>`` for use by external CMake
  projects. This command provides enhanced and customized behavior comparable
  to `export() <https://cmake.org/cmake/help/latest/command/export.html>`_ (for ``BUILD_TREE``) and `install(EXPORT) <https://cmake.org/cmake/help/latest/command/install.html#export>`_
  (for ``INSTALL_TREE``), but specifically tailored to exported imported targets.

  The output is a CMake script file named ``<file_path>``, which can be
  included by downstream projects to import library target from the current
  project's build-tree or install-tree.

  Depending on the tree context:

  * For ``BUILD_TREE``: The file is generated in ``CMAKE_CURRENT_BINARY_DIR``.

  * For ``INSTALL_TREE``: The file is generated in ``CMAKE_CURRENT_BINARY_DIR/
    CMakeFiles/Export`` and installed in the same relative directory structure
    under the install prefix.

  If the ``APPEND`` keyword is specified, new export code is appended
  to the output file instead of overwriting it.

  The exported script recreates the target and sets all relevant properties,
  so the target can be used transparently by other projects. It set the same
  properties than the module command :command:`dependency(IMPORT)`, so see
  its documentations for more details.

  Example usage:

  .. code-block:: cmake

    dependency(EXPORT "myimportedlib"
      BUILD_TREE
      APPEND
      OUTPUT_FILE "InternalDependencyTargets.cmake"
    )

    dependency(EXPORT "${imported_library}"
      INSTALL_TREE
      APPEND
      OUTPUT_FILE "${CMAKE_INSTALL_PREFIX}/share/${PROJECT_NAME}/cmake/InternalDependencyTargets.cmake"
    )

  The resulting file ``InternalDependencyTargets.cmake`` may then be included
  by CMake projects in ``<PackageName>Config.cmake.in`` to be used by
  `configure_package_config_file() <https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html>`_ CMake command:

  .. code-block:: cmake

    include("${CMAKE_CURRENT_LIST_DIR}/InternalDependencyTargets.cmake")

.. signature::
  dependency(INCLUDE_DIRECTORIES <lib_name> <SET|APPEND> PUBLIC <gen_expr_list> ...)

  Set or append public include directories via `INTERFACE_INCLUDE_DIRECTORIES <https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_INCLUDE_DIRECTORIES.html>`_
  property to the imported target ``<lib_name>``. This command works similarly to
  `target_include_directories() <https://cmake.org/cmake/help/latest/command/target_include_directories.html>`_ in CMake, but introduces a separation
  between build-time and install-time contexts for imported dependencies.

  The behavior differs from standard CMake in that it stores build and install
  include paths separately using generator expressions (see the section
  "`Build specification with generator expressions <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#build-specification-with-generator-expressions>`_").

  The ``PUBLIC`` keyword indicates that the specified directories apply to the
  usage requirements of the target (i.e., will be propagated to consumers of
  the target). The directories following it **must use generator expressions** like
  ``$<BUILD_INTERFACE:...>`` and ``$<INSTALL_INTERFACE:...>`` to distinguish
  between build and install phases.

  The command accepts the following mutually exclusive modifiers:

  - ``SET``: Replaces any existing include directories.
  - ``APPEND``: Adds to the current list of include directories.

  This command internally sets or appends the following CMake properties on the target:

    ``INTERFACE_INCLUDE_DIRECTORIES``
      This standard property determines the public include directories seen
      by consumers of the library. This will be populated using only the
      build-specific include paths (i.e., extracted from ``$<BUILD_INTERFACE:...>``).

    ``INTERFACE_INCLUDE_DIRECTORIES_BUILD``
      A *custom property* used internally to distinguish the build-time
      include paths. It stores the expanded list of directories extracted
      from the ``$<BUILD_INTERFACE:...>`` portion of the arguments.

    ``INTERFACE_INCLUDE_DIRECTORIES_INSTALL``
      A *custom property* used to store include directories intended to
      be used after installation. It is extracted from the
      ``$<INSTALL_INTERFACE:...>`` expressions.

  These custom properties (`_BUILD` and `_INSTALL`) are not directly used by
  CMake itself but are later re-injected into export files generated by
  :command:`dependency(EXPORT)`.

  Example usage:

  .. code-block:: cmake

    dependency(INCLUDE_DIRECTORIES "mylib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )

  This example sets ``mylib`` to expose:

  * ``${CMAKE_CURRENT_SOURCE_DIR}/include`` during the build.
  * ``<prefix>/include`` after installation (where ``<prefix>`` is resolved
    when imported via :command:`dependency(EXPORT)`).

.. signature::
  dependency(IMPORTED_LOCATION <lib_name> [CONFIGURATION <config_type>] PUBLIC <gen_expr_list> ...)

  Set the full path to the imported target ``<lib_name>`` for one or more
  configurations. This command sets the ``IMPORTED_LOCATION_<CONFIG>`` property
  of the imported target from a generator expressions. More
  details in `CMake doc <https://cmake.org/cmake/help/latest/prop_tgt/IMPORTED_LOCATION.html>`_.

  If the ``CONFIGURATION`` option is specified, the path is set only for the
  given ``<config_type>`` (e.g. ``DEBUG``, ``RELEASE``), provided that this
  configuration is supported by the target. If ``CONFIGURATION`` is omitted, the
  path is set for all configurations supported by the imported target.

  The ``PUBLIC`` keyword specifies the usage scope of the following arguments.
  These arguments **must use generator expressions** such as ``$<BUILD_INTERFACE:...>``
  and ``$<INSTALL_INTERFACE:...>`` to distinguish between build and install
  phases (see the section
  "`Build specification with generator expressions <https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#build-specification-with-generator-expressions>`_").

  Example usage:

  .. code-block:: cmake

    dependency(IMPORTED_LOCATION "mylib"
      CONFIGURATION "DEBUG"
      PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/debug/libMyLib.a>"
        "$<INSTALL_INTERFACE:lib/libMyLib.a>"
    )
#]=======================================================================]
include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)
include(FuncDirectory)
include(FuncStringManip)

#------------------------------------------------------------------------------
# Public function of this module.
function(dependency)
	set(options SHARED STATIC BUILD_TREE INSTALL_TREE SET APPEND)
	set(one_value_args IMPORT RELEASE_NAME DEBUG_NAME ROOT_DIR INCLUDE_DIR EXPORT OUTPUT_FILE INCLUDE_DIRECTORIES IMPORTED_LOCATION CONFIGURATION)
	set(multi_value_args PUBLIC)
	cmake_parse_arguments(DEP "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
	
	if(DEFINED DEP_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${DEP_UNPARSED_ARGUMENTS}\"")
	endif()

	if(DEFINED DEP_IMPORT)
		_dependency_import()
	elseif(DEFINED DEP_EXPORT)
		_dependency_export()
	elseif(DEFINED DEP_INCLUDE_DIRECTORIES)
		_dependency_include_directories()
	elseif(DEFINED DEP_IMPORTED_LOCATION)
		_dependency_imported_location()
	else()
		message(FATAL_ERROR "Operation argument is missing")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage.
macro(_dependency_import)
	if(NOT DEFINED DEP_IMPORT)
		message(FATAL_ERROR "IMPORT argument is missing or need a value!")
	endif()
	if((NOT ${DEP_SHARED})
		AND (NOT ${DEP_STATIC}))
		message(FATAL_ERROR "SHARED|STATIC argument is missing!")
	endif()
	if(${DEP_SHARED} AND ${DEP_STATIC})
		message(FATAL_ERROR "SHARED|STATIC cannot be used together!")
	endif()
	if((NOT DEFINED DEP_RELEASE_NAME)
		AND (NOT DEFINED DEP_DEBUG_NAME))
		message(FATAL_ERROR "RELEASE_NAME|DEBUG_NAME argument is missing!")
	endif()
	if("RELEASE_NAME" IN_LIST DEP_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "RELEASE_NAME need a value!")
	endif()
	if("DEBUG_NAME" IN_LIST DEP_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "DEBUG_NAME need a value!")
	endif()
	if(NOT DEFINED DEP_ROOT_DIR)
		message(FATAL_ERROR "ROOT_DIR argument is missing or need a value!")
	endif()
	if(NOT DEFINED DEP_INCLUDE_DIR)
		message(FATAL_ERROR "INCLUDE_DIR argument is missing or need a value!")
	endif()
	
	if(${DEP_SHARED})
		set(library_type "SHARED")
	elseif(${DEP_STATIC})
		set(library_type "STATIC")
	else()
		message(FATAL_ERROR "Wrong library type!")
	endif()

	add_library("${DEP_IMPORT}" "${library_type}" IMPORTED)
	set_target_properties("${DEP_IMPORT}" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${DEP_INCLUDE_DIR}") # For usage from source-tree.
	set_target_properties("${DEP_IMPORT}" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES_BUILD "") # Custom property for usage from build-tree.
	set_target_properties("${DEP_IMPORT}" PROPERTIES INTERFACE_INCLUDE_DIRECTORIES_INSTALL "") # Custom property for usage from install-tree.
	if(DEFINED DEP_RELEASE_NAME)
		# Get the library file for release.
		directory(FIND_LIB lib_release
			FIND_IMPLIB imp_lib_release
			NAME "${DEP_RELEASE_NAME}"
			"${library_type}"
			RELATIVE off
			ROOT_DIR "${DEP_ROOT_DIR}"
		)
		if(NOT lib_release)
			message(FATAL_ERROR "The release library \"${DEP_RELEASE_NAME}\" was not found!")
		endif()
		if(WIN32 AND NOT imp_lib_release)
			message(FATAL_ERROR "The release import library \"${DEP_RELEASE_NAME}\" was not found!")
		endif()

		# Add library properties for release.
		cmake_path(GET lib_release FILENAME lib_release_name)
		set_target_properties("${DEP_IMPORT}" PROPERTIES
			IMPORTED_LOCATION_RELEASE "${lib_release}" # Only for ".dll" and ".lib" and ".a" and ".so". For usage from source-tree.
			IMPORTED_LOCATION_BUILD_RELEASE "" # Custom property for usage from build-tree.
			IMPORTED_LOCATION_INSTALL_RELEASE "" # Custom property for usage from install-tree.
			IMPORTED_IMPLIB_RELEASE "${imp_lib_release}" # Only for ".lib" and ".dll.a" on DLL platforms.
			IMPORTED_SONAME_RELEASE "${lib_release_name}"
		)
		set_property(TARGET "${DEP_IMPORT}" APPEND PROPERTY IMPORTED_CONFIGURATIONS "RELEASE")
	endif()

	if(DEFINED DEP_DEBUG_NAME)
		# Get the library file for debug.
		directory(FIND_LIB lib_debug
			FIND_IMPLIB imp_lib_debug
			NAME "${DEP_DEBUG_NAME}"
			"${library_type}"
			RELATIVE off
			ROOT_DIR "${DEP_ROOT_DIR}"
		)
		if(NOT lib_debug)
			message(FATAL_ERROR "The debug library \"${DEP_DEBUG_NAME}\" was not found!")
		endif()
		if(WIN32 AND NOT imp_lib_debug)
			message(FATAL_ERROR "The debug import library \"${DEP_DEBUG_NAME}\" was not found!")
		endif()
		# Add library properties for debug.
		cmake_path(GET lib_debug FILENAME lib_debug_name)
		set_target_properties("${DEP_IMPORT}" PROPERTIES
			IMPORTED_LOCATION_DEBUG "${lib_debug}" # Only for ".dll" and ".lib" and ".a" and ".so". For usage from source-tree.
			IMPORTED_LOCATION_BUILD_DEBUG "" # Custom property for usage from build-tree.
			IMPORTED_LOCATION_INSTALL_DEBUG "" # Custom property for usage from install-tree.
			IMPORTED_IMPLIB_DEBUG "${imp_lib_debug}" # Only for ".lib" and ".dll.a" on DLL platforms.
			IMPORTED_SONAME_DEBUG "${lib_debug_name}"
		)
		set_property(TARGET "${DEP_IMPORT}" APPEND PROPERTY IMPORTED_CONFIGURATIONS "DEBUG")
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_dependency_export)
	if(NOT DEFINED DEP_EXPORT)
		message(FATAL_ERROR "EXPORT argument is missing or need a value!")
	endif()
	if((NOT ${DEP_BUILD_TREE})
		AND (NOT ${DEP_INSTALL_TREE}))
		message(FATAL_ERROR "BUILD_TREE|INSTALL_TREE argument is missing!")
	endif()
	if(${DEP_BUILD_TREE} AND ${DEP_INSTALL_TREE})
		message(FATAL_ERROR "BUILD_TREE|INSTALL_TREE cannot be used together!")
	endif()
	if(NOT DEFINED DEP_OUTPUT_FILE)
		message(FATAL_ERROR "OUTPUT_FILE argument is missing or need a value!")
	endif()
	if(NOT TARGET "${DEP_EXPORT}")
		message(FATAL_ERROR "The target \"${DEP_EXPORT}\" does not exists!")
	endif()

	cmake_path(SET export_temp_file "${CMAKE_CURRENT_BINARY_DIR}")
	cmake_path(SET export_file "${CMAKE_CURRENT_BINARY_DIR}")
	if(${DEP_BUILD_TREE})
		cmake_path(APPEND export_temp_file "DependencyBuildTreeTemp.cmake")
	elseif(${DEP_INSTALL_TREE})
		cmake_path(APPEND export_temp_file "DependencyInstallTreeTemp.cmake")
		cmake_path(APPEND export_file "CMakeFiles" "Export")
	endif()
	cmake_path(APPEND export_file "${DEP_OUTPUT_FILE}")

	# When cmake command is call, the previous generated files has to be removed
	if(EXISTS "${export_file}")
		file(REMOVE
			"${export_file}"
			"${export_temp_file}"
		)
	endif()
	
	set(import_instructions "")
	if((EXISTS "${export_temp_file}") AND (NOT ${DEP_APPEND}))
		message(FATAL_ERROR "Export command already specified for the file \"${export_file}\". Did you miss 'APPEND' keyword?")
	endif()
	if(NOT EXISTS "${export_temp_file}")
		# Ouptut file will be generated only one time after processing all of a project's CMakeLists.txt files
		file(GENERATE OUTPUT "${export_file}" 
			INPUT "${export_temp_file}"
			TARGET "${DEP_EXPORT}"
		)
		if(${DEP_INSTALL_TREE})
			cmake_path(GET DEP_OUTPUT_FILE PARENT_PATH install_export_dir)
			install(FILES "${export_file}"
				DESTINATION "${install_export_dir}"
			)
		endif()
		_export_generate_header_code()
	endif()

	if(${DEP_BUILD_TREE})
		_export_generate_build_tree()
	elseif(${DEP_INSTALL_TREE})
		_export_generate_install_tree()
	endif()
	_export_generate_footer_code()
	
	file(APPEND "${export_temp_file}" "${import_instructions}")
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_export_generate_build_tree)
	# Create the imported target
	get_target_property(target_type "${DEP_EXPORT}" TYPE)
  	string(APPEND import_instructions "# Create imported target \"$<TARGET_PROPERTY:NAME>\"\n")
	if("${target_type}" STREQUAL "STATIC_LIBRARY")
		string(APPEND import_instructions "add_library(\"$<TARGET_PROPERTY:NAME>\" STATIC IMPORTED)\n")
	elseif("${target_type}" STREQUAL "SHARED_LIBRARY")
		string(APPEND import_instructions "add_library(\"$<TARGET_PROPERTY:NAME>\" SHARED IMPORTED)\n")
	else()
		message(FATAL_ERROR "Target type \"${target_type}\" is unsupported by export command!")
	endif()

	# Add usage requirements.
	string(APPEND import_instructions "\n")
	string(APPEND import_instructions "set_target_properties(\"$<TARGET_PROPERTY:NAME>\" PROPERTIES\n")
	string(APPEND import_instructions "  INTERFACE_INCLUDE_DIRECTORIES \"$<TARGET_PROPERTY:INTERFACE_INCLUDE_DIRECTORIES_BUILD>\"\n")
	string(APPEND import_instructions "  IMPORTED_LOCATION_$<CONFIG> \"$<TARGET_PROPERTY:IMPORTED_LOCATION_BUILD_$<CONFIG>>\"\n")
	string(APPEND import_instructions "  IMPORTED_IMPLIB_$<CONFIG> \"$<TARGET_PROPERTY:IMPORTED_IMPLIB_$<CONFIG>>\"\n")
	string(APPEND import_instructions "  IMPORTED_SONAME_$<CONFIG> \"$<TARGET_PROPERTY:IMPORTED_SONAME_$<CONFIG>>\"\n")
	string(APPEND import_instructions ")\n")
	string(APPEND import_instructions "set_property(TARGET \"$<TARGET_PROPERTY:NAME>\" APPEND PROPERTY IMPORTED_CONFIGURATIONS \"$<CONFIG>\")\n")
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_export_generate_install_tree)
	# Add code to compute the installation prefix relative to the import file location.
	string(APPEND import_instructions "# Compute the installation prefix relative to this file.\n")
	string(APPEND import_instructions "get_filename_component(_IMPORT_PREFIX \"\${CMAKE_CURRENT_LIST_FILE}\" PATH)\n")
	set(import_prefix "${install_export_dir}")
	while((NOT "${import_prefix}" STREQUAL "${CMAKE_INSTALL_PREFIX}")
		AND (NOT "${import_prefix}" STREQUAL ""))
		string(APPEND import_instructions "get_filename_component(_IMPORT_PREFIX \"\${_IMPORT_PREFIX}\" PATH)\n")
		cmake_path(GET import_prefix PARENT_PATH import_prefix)
	endwhile()
	string(APPEND import_instructions "if(_IMPORT_PREFIX STREQUAL \"/\")\n")
	string(APPEND import_instructions "  set(_IMPORT_PREFIX \"\")\n")
	string(APPEND import_instructions "endif()\n")
	string(APPEND import_instructions "\n")

	# Create the imported target.
	get_target_property(target_type "${DEP_EXPORT}" TYPE)
  	string(APPEND import_instructions "# Create imported target \"$<TARGET_PROPERTY:NAME>\"\n")
	if("${target_type}" STREQUAL "STATIC_LIBRARY")
		string(APPEND import_instructions "add_library(\"$<TARGET_PROPERTY:NAME>\" STATIC IMPORTED)\n")
	elseif("${target_type}" STREQUAL "SHARED_LIBRARY")
		string(APPEND import_instructions "add_library(\"$<TARGET_PROPERTY:NAME>\" SHARED IMPORTED)\n")
	else()
		message(FATAL_ERROR "Target type \"${target_type}\" is unsupported by export command!")
	endif()

	# Add usage requirements.
	string(APPEND import_instructions "\n")
	string(APPEND import_instructions "set_target_properties(\"$<TARGET_PROPERTY:NAME>\" PROPERTIES\n")
	string(APPEND import_instructions "  INTERFACE_INCLUDE_DIRECTORIES \"\${_IMPORT_PREFIX}/$<TARGET_PROPERTY:INTERFACE_INCLUDE_DIRECTORIES_INSTALL>\"\n")
	string(APPEND import_instructions "  IMPORTED_LOCATION_$<CONFIG> \"\${_IMPORT_PREFIX}/$<TARGET_PROPERTY:IMPORTED_LOCATION_INSTALL_$<CONFIG>>\"\n")
	string(APPEND import_instructions "  IMPORTED_IMPLIB_$<CONFIG> \"$<TARGET_PROPERTY:IMPORTED_IMPLIB_$<CONFIG>>\"\n")
	string(APPEND import_instructions "  IMPORTED_SONAME_$<CONFIG> \"$<TARGET_PROPERTY:IMPORTED_SONAME_$<CONFIG>>\"\n")
	string(APPEND import_instructions ")\n")
	string(APPEND import_instructions "set_property(TARGET \"$<TARGET_PROPERTY:NAME>\" APPEND PROPERTY IMPORTED_CONFIGURATIONS \"$<CONFIG>\")\n")
	string(APPEND import_instructions "\n")
	
	# Cleanup temporary variables.
	string(APPEND import_instructions "# Cleanup temporary variables.\n")
	string(APPEND import_instructions "unset(_IMPORT_PREFIX)\n")
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_export_generate_header_code)
	string(APPEND import_instructions "# Generated by the \"${PROJECT_NAME}\" project \n")
	string(APPEND import_instructions "\n")
	string(APPEND import_instructions "#----------------------------------------------------------------\n")
	string(APPEND import_instructions "# Generated CMake target import file for internal libraries.\n")
	string(APPEND import_instructions "#----------------------------------------------------------------\n")
	string(APPEND import_instructions "\n")
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_export_generate_footer_code)
	string(APPEND import_instructions "#----------------------------------------------------------------\n")
	string(APPEND import_instructions "\n")
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_dependency_include_directories)
	if(NOT DEFINED DEP_INCLUDE_DIRECTORIES)
		message(FATAL_ERROR "INCLUDE_DIRECTORIES argument is missing or need a value!")
	endif()
	if((NOT ${DEP_SET})
		AND (NOT ${DEP_APPEND}))
		message(FATAL_ERROR "SET|APPEND argument is missing!")
	endif()
	if(${DEP_SET} AND ${DEP_APPEND})
		message(FATAL_ERROR "SET|APPEND cannot be used together!")
	endif()
	if(NOT DEFINED DEP_PUBLIC)
		OR ("PUBLIC" IN_LIST DEP_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "PUBLIC argument is missing or need a value!")
	endif()

	if(NOT TARGET "${DEP_INCLUDE_DIRECTORIES}")
		message(FATAL_ERROR "The target \"${DEP_INCLUDE_DIRECTORIES}\" does not exists!")
	endif()

	string_manip(EXTRACT_INTERFACE DEP_PUBLIC BUILD OUTPUT_VARIABLE include_directories_build_interface)
	string_manip(EXTRACT_INTERFACE DEP_PUBLIC INSTALL OUTPUT_VARIABLE include_directories_install_interface)
	if(${DEP_SET})
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}"
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${include_directories_build_interface}"
		)
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}"
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD "${include_directories_build_interface}"
		)
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}"
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL "${include_directories_install_interface}"
		)
	elseif(${DEP_APPEND})
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}" APPEND
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${include_directories_build_interface}"
		)
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}" APPEND
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD "${include_directories_build_interface}"
		)
		set_property(TARGET "${DEP_INCLUDE_DIRECTORIES}" APPEND
			PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL "${include_directories_install_interface}"
		)
	else()
		message(FATAL_ERROR "Wrong option!")
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage.
macro(_dependency_imported_location)
	if(NOT DEFINED DEP_IMPORTED_LOCATION)
		message(FATAL_ERROR "IMPORTED_LOCATION argument is missing or need a value!")
	endif()
	if("CONFIGURATION" IN_LIST DEP_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "CONFIGURATION argument is missing or need a value!")
	endif()
	if(NOT DEFINED DEP_PUBLIC)
		OR ("PUBLIC" IN_LIST DEP_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "PUBLIC argument is missing or need a value!")
	endif()

	if(NOT TARGET "${DEP_IMPORTED_LOCATION}")
		message(FATAL_ERROR "The target \"${DEP_IMPORTED_LOCATION}\" does not exists!")
	endif()

	get_target_property(supported_config_types "${imported_library}" IMPORTED_CONFIGURATIONS)
	string_manip(EXTRACT_INTERFACE DEP_PUBLIC BUILD OUTPUT_VARIABLE imported_location_build_interface)
	string_manip(EXTRACT_INTERFACE DEP_PUBLIC INSTALL OUTPUT_VARIABLE imported_location_install_interface)
	if(DEFINED DEP_CONFIGURATION)
		if(NOT "${DEP_CONFIGURATION}" IN_LIST supported_config_types)
			message(FATAL_ERROR "The build type \"${DEP_CONFIGURATION}\" is not a supported configuration!")
		endif()
		set_target_properties("${DEP_IMPORTED_LOCATION}" PROPERTIES
			IMPORTED_LOCATION_${DEP_CONFIGURATION} "${imported_location_build_interface}"
			IMPORTED_LOCATION_BUILD_${DEP_CONFIGURATION} "${imported_location_build_interface}"
			IMPORTED_LOCATION_INSTALL_${DEP_CONFIGURATION} "${imported_location_install_interface}"
		)
	else()
		foreach(config_type IN ITEMS ${supported_config_types})
			set_target_properties("${DEP_IMPORTED_LOCATION}" PROPERTIES
				IMPORTED_LOCATION_${config_type} "${imported_location_build_interface}"
				IMPORTED_LOCATION_BUILD_${config_type} "${imported_location_build_interface}"
				IMPORTED_LOCATION_INSTALL_${config_type} "${imported_location_install_interface}"
			)
		endforeach()
	endif()
endmacro()