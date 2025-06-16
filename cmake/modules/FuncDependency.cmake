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
	set(one_value_args IMPORT RELEASE_NAME DEBUG_NAME ROOT_DIR INCLUDE_DIR OUTPUT_FILE INCLUDE_DIRECTORIES IMPORTED_LOCATION CONFIGURATION)
	set(multi_value_args EXPORT PUBLIC)
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
	if((NOT DEFINED DEP_EXPORT)
		AND (NOT "EXPORT" IN_LIST FM_KEYWORDS_MISSING_VALUES))
		message(FATAL_ERROR "EXPORT arguments is missing or need a value!")
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
	foreach(lib_target_name IN ITEMS ${DEP_EXPORT})
		if(NOT TARGET "${lib_target_name}")
			message(FATAL_ERROR "The target \"${lib_target_name}\" does not exists!")
		endif()
	endforeach()
	if((NOT DEFINED CMAKE_BUILD_TYPE)
		OR ("${CMAKE_BUILD_TYPE}" STREQUAL ""))
		message(FATAL_ERROR "CMAKE_BUILD_TYPE is not set!")
	endif()

	# Set paths to export files
	cmake_path(SET export_file "${CMAKE_CURRENT_BINARY_DIR}")
	cmake_path(SET export_file_template "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	if(${DEP_BUILD_TREE})
		cmake_path(APPEND export_file_template "ImportBuildTreeLibTargets.cmake.in")
	elseif(${DEP_INSTALL_TREE})
		cmake_path(APPEND export_file "CMakeFiles" "Export")
		cmake_path(APPEND export_file_template "ImportInstallTreeLibTargets.cmake.in")
	endif()
	cmake_path(APPEND export_file "${DEP_OUTPUT_FILE}")

	# Read the template file once
	file(READ "${export_file_template}" template_content)

	# Sanitize the output file path to create a valid CMake property identifier
	cmake_path(GET export_file FILENAME sanitized_export_file)
	string(MAKE_C_IDENTIFIER "${sanitized_export_file}" sanitized_export_file)
	
	# List of previously generated intermediate files
	get_property(existing_export_parts GLOBAL PROPERTY "_EXPORT_PARTS_${sanitized_export_file}")

	# Error if export command already specified for the file and 'APPEND' keyword is not used
	list(LENGTH existing_export_parts nb_parts)
	if((NOT nb_parts EQUAL 0) AND (NOT ${DEP_APPEND}))
		message(FATAL_ERROR "Export command already specified for the file \"${DEP_OUTPUT_FILE}\". Did you miss 'APPEND' keyword?")
	endif()
	
	# List of intermediate files to concatenate later
	set(new_export_parts "")
	foreach(lib_target_name IN ITEMS ${DEP_EXPORT})
		# Set template file variables
		get_target_property(lib_target_type "${lib_target_name}" TYPE)
		if("${lib_target_type}" STREQUAL "STATIC_LIBRARY")
			set(lib_target_type "STATIC")
		elseif("${lib_target_type}" STREQUAL "SHARED_LIBRARY")
			set(lib_target_type "SHARED")
		else()
			message(FATAL_ERROR "Target type \"${lib_target_type}\" for target \"${lib_target_name}\" is unsupported by export command!")
		endif()
	
		# Substitute variable values referenced as @VAR@
		string(CONFIGURE "${template_content}" configured_content @ONLY)

		# Generate a per-target intermediate file with generator expressions
		set(new_part_file "${CMAKE_CURRENT_BINARY_DIR}/${lib_target_name}Target-${lib_target_type}.part.cmake")
		if(NOT ("${new_part_file}" IN_LIST existing_export_parts))
			file(GENERATE OUTPUT "${new_part_file}"
				CONTENT "${configured_content}"
				TARGET "${lib_target_name}"
			)
			set_source_files_properties("${new_part_file}" PROPERTIES GENERATED TRUE)
			# Add generated files to the `clean` target
			set_property(DIRECTORY
				APPEND
				PROPERTY ADDITIONAL_CLEAN_FILES
				"${new_part_file}"
			)
			list(APPEND new_export_parts "${new_part_file}")
		else()
			message(FATAL_ERROR "Given target \"${lib_target_name}\" more than once!")
		endif()
	endforeach()

	# Append the generated intermediate files to the file's associated global property
	list(APPEND existing_export_parts "${new_export_parts}")
	set_property(GLOBAL PROPERTY "_EXPORT_PARTS_${sanitized_export_file}" "${existing_export_parts}")

	# Only define the output generation rule once
	set(unique_target_name "GenerateImportTargetFile_${sanitized_export_file}")

	# Build `add_custom_command()` for exporting
	set(output_part "")
	if(NOT TARGET ${unique_target_name})
		list(APPEND output_part "OUTPUT" "${export_file}")
	else()
		list(APPEND output_part "OUTPUT" "${export_file}" "APPEND")
	endif()

	set(comment_part "")
	set(command_part "")
	if(${DEP_APPEND})
		list(APPEND command_part
			"COMMAND" "${CMAKE_COMMAND}" "-E" "touch" "${export_file}")
		list(APPEND command_part
			"COMMAND" "${CMAKE_COMMAND}" "-E" "cat" ${new_export_parts} ">>" "${export_file}")
		list(APPEND comment_part
			"COMMENT" "Update the import file \"${export_file}\"")
	else()
		list(APPEND command_part
			"COMMAND" "${CMAKE_COMMAND}" "-E" "cat" ${new_export_parts} ">" "${export_file}")
		list(APPEND comment_part
			"COMMENT" "Overwrite the import file \"${export_file}\"")
	endif()

	add_custom_command(
		${output_part}
		${command_part}
		DEPENDS "${new_export_parts}"
		${comment_part}
	)

	if(NOT TARGET "${unique_target_name}")
		# Create a unique generative target per output file to trigger the command
		add_custom_target("${unique_target_name}" ALL
			DEPENDS "${export_file}"
			VERBATIM
		)
	endif()

	if(${DEP_INSTALL_TREE})
		cmake_path(GET export_file PARENT_PATH install_export_dir)
		install(FILES "${export_file}"
			DESTINATION "${install_export_dir}"
		)
		message("install_export_dir: ${install_export_dir}")
	endif()
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