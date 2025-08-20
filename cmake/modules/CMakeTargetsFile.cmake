# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
CMakeTargetsFile
----------------

Provide operations to configure binary targets using a JSON configuration file.
It requires CMake 3.20 or newer.

Introduction
^^^^^^^^^^^^

In a CMake build project, there is no native and straightforward way to
separate the declaration of a binary target from its definition. Both are
typically performed together when writing commands in a ``CMakeLists.txt``
file. However, in many use cases, the sequence of commands used to define
targets is identical across projects, with only the data changing. The
definition logic for the binary target remains the same, while only its
declarations (i.e., its configuration) change.

The purpose of this module is to simplify the automated creation of binary
targets by allowing their settings to be declared in a standardized JSON
configuration file. The structure of this file is defined using a
`JSON schema <https://json-schema.org/>`_. Various commands are provided to
read and interpret this configuration file.

The configuration file must be named ``CMakeTargets.json`` and must reside
in the project's root directory.

.. note::

  CMake is currently developing the
  `Common Package Specification <https://cps-org.github.io/cps/index.html>`_
  to standardize the way packages are declared and to improve their
  integration via the
  `System Package Registry <https://cmake.org/cmake/help/git-master/manual/cmake-packages.7.html#system-package-registry>`_.
  It is therefore possible that this module may become obsolete in the
  future. In the meantime, it will continue to evolve to reflect updates
  introduced in upcoming versions.

Format
^^^^^^

The CMake targets declaration file is a JSON document with an object as the
root (:download:`click to download <../../../cmake/modules/CMakeTargets.json>`):

.. literalinclude:: ../../../cmake/modules/CMakeTargets.json
  :language: json

The JSON document must be conformed to the :download:`CMakeTargets.json schema <../../../cmake/modules/schema.json>` described below.

The root object recognizes the following fields:

``$schema``
  An optional string that provides a URI to the `JSON schema <https://json-schema.org/>`_
  that describes the structure of this JSON document. This field is used for
  validation and autocompletion in editors that support JSON schema. It doesn't
  affect the behavior of the document itself. If this field is not specified,
  the JSON document will still be valid, but tools that use JSON schema for
  validation and autocompletion may not function correctly. The module does
  not perform schema validation automatically. Use ``$schema`` to document the
  schema version or to enable external validation and tooling workflows.

``$id``
  An optional string that provides a unique identifier for the JSON document or
  the schema resource. The value must be a valid URI or a relative URI
  reference. When present, ``$id`` can be used by external tooling to
  disambiguate or resolve the schema/resource and to avoid collisions between
  different schema documents. The module stores this property but does not
  interpret or enforce any semantics associated with ``$id``.

``targets``
  The required root property containing the set of targets defined in the
  file. Its value is an object whose keys are unique directory paths that
  identify the parent folder containing the source files for each target.
  For example: ``src``, ``src/apple``.

  Each path must be relative to the project root and must not include a
  trailing slash. The directory path serves as the unique identifier for
  the target within the file because it is assumed that there can be no
  more than one target defined per folder.

  The value for each key is a target definition object as described in the
  following subsections. The key name (directory path) can be used internally
  to organize and retrieve target configurations during the CMake building
  process.

  Each entry of a ``targets`` is a JSON object that may contain the following
  properties:

  ``name``
    A required string specifying the human-meaningful name of the target.
    This name must be unique across all targets listed in the same
    ``targets`` object. Two targets within the same file must not share
    the same name, even if their directory paths differ. The name is used to
    create a CMake target.

  ``type``
    A required string specifying the kind of binary to generate for this
    target. Valid values are:

      * ``staticLib`` - a static library.
      * ``sharedLib`` - a shared (dynamic) library.
      * ``interfaceLib`` - a header-only library.
      * ``executable`` - an executable program.

    The type influences how the target is built and linked by the consuming
    CMake logic.

  ``build``
    A required object describing build settings. It contains the
    following array properties:

      ``compileFeatures``
        A list of optional compile features to pass to the target. It is
        used as a parameter for the
        :cmake:command:`target_compile_features() <cmake:command:target_compile_features>`
        command. The property is required, but the array can be empty.

      ``compileDefinitions``
        A list of optional preprocessor definitions applied when compiling this
        target. It is used as a parameter for the
        :cmake:command:`target_compile_definitions() <cmake:command:target_compile_definitions>`
        command. The property is required, but the array can be empty.

      ``compileOptions``
        A list of compiler options to pass when building this
        target. It is used as a parameter for the
        :cmake:command:`target_compile_options() <cmake:command:target_compile_options>`
        command. The property is required, but the array can be empty.

      ``linkOptions``
        A list of linker options to pass when building this target. It is used
        as a parameter for the
        :cmake:command:`target_link_options() <cmake:command:target_link_options>`
        command. The property is required, but the array can be empty.

    All four properties must be present. Lists may be empty to indicate no
    entries.

  ``mainFile``
    A required string specifying the path to the main source file for this
    target. The path must be relative to the project root. The file must exist
    and have a ``.cpp``, ``.cc``, or ``.cxx`` extension.

  ``pchFile``
    An optional string specifying the path to the precompiled header file
    (PCH) for this target. The path must be relative to the project root. If
    present, it must have one of the following extensions: ``.h``, ``.hpp``,
    ``.hxx``, ``.inl``, ``.tpp``. If not specified, the target is considered to
    have no PCH.

  ``headerPolicy``
    A required object describing how header files are organized within the
    project. It has the following properties:

      ``mode``
        A required string specifying whether all header files are grouped in a
        a single common folder or whether public headers are separated from
        private headers. Valid values are:

          * ``split`` - public headers are stored in a different folder
            (e.g., ``include/``) than private headers (e.g., ``src/``).
          * ``merged`` - public and private headers are in the same folder
            (e.g., ``src/``).

      ``includeDir``
        Required only if ``mode`` is ``split``. A path relative to the project
        root specifying the folder in ``include/`` where the public
        headers are located. The path must start with ``include`` (e.g.,
        ``include``, ``include/mylib``) and must not include a trailing slash.

  ``dependencies``
    The required object property specifying the set of dependencies needed by
    the target. Its value is an object whose keys are the names of the
    dependencies. Each name must be unique within the ``dependencies`` object.

    Each entry of a ``dependencies`` object is a JSON object that may contain
    the following properties:

    ``rulesFile``
      A required path to a CMake file ending in ``.cmake`` that defines how to
      integrate the dependency into the build system.

    ``minVersion``
      A required integer specifying the minimum acceptable version of the
      dependency. This value is used as the ``VERSION`` argument to
      :cmake:command:`find_package() <cmake:command:find_package>` calls for
      that dependency.

    ``autodownload``
      A required boolean indicating whether the dependency may be
      automatically downloaded if not found locally.

    ``optional``
      A required boolean indicating whether the dependency is optional.
      If ``true`` and the dependency cannot be found, it is ignored and
      not linked. If ``false`` and the dependency is missing, the build
      will fail.

Schema
^^^^^^

:download:`This file <../../../cmake/modules/schema.json>` provides a machine-
readable JSON schema for the ``CMakeTargets.json`` format.

Synopsis
^^^^^^^^

.. parsed-literal::

  cmake_targets_file(`LOAD`_ <json-file-path>)
  cmake_targets_file(`IS_LOADED`_ <output-var>)
  cmake_targets_file(`GET_LOADED_FILE`_ <output-var>)
  cmake_targets_file(`GET_SETTINGS`_ <output-var> TARGET <target-dir-path>)
  cmake_targets_file(`GET_SETTINGS_KEYS`_ <output-var> TARGET <target-dir-path>)
  cmake_targets_file(`GET_SETTING_VALUE`_ <output-var> TARGET <target-dir-path> KEY <setting-name>)
  cmake_targets_file(`PRINT_CONFIGS`_ [])
  cmake_targets_file(`PRINT_TARGET_CONFIG`_ <target-dir-path>)

Usage
^^^^^

.. signature::
  cmake_targets_file(LOAD <json-file-path>)

  Load and parses a targets configuration file in `JSON format <https://json-schema.org/>`_.

  The ``<json-file-path>`` specifies the location of the configuration file to
  load. It must refer to an existing file on disk and must have a ``.json``
  extension. The file must conform to the :download:`CMakeTargets.json schema <../../../cmake/modules/schema.json>`.

  When this command is invoked, the JSON content is read into memory and stored
  in global properties for later retrieval. Each target entry described in the
  JSON file is parsed into an independent configuration :module:`Map`, keyed by its
  directory path. Both the original raw JSON and the list of target directory
  paths are preserved.

  The following global properties are initialized:

    ``TARGETS_CONFIG_<target-dir-path>``
      For each target directory path in the configuration file, stores the
      serialized key-value :module:`Map` of its parsed properties.

    ``TARGETS_CONFIG_RAW_JSON``
      Contains the loaded JSON file as text.

    ``TARGETS_CONFIG_LIST``
      Holds the list of all target directory paths defined in the file. They
      serve as value to get the target configurations stored in
      ``TARGETS_CONFIG_<target-dir-path>``.

    ``TARGETS_CONFIG_LOADED``
      Set to ``on`` once the configuration is successfully loaded, otherwise
      to ``off``.

  This command must be called exactly once before using any other
  module operation. If the configuration is already loaded, calling :command:`cmake_targets_file(LOAD)`
  again will replace the current configuration in memory.

  Each target's configuration is stored separately in a global property
  named ``TARGETS_CONFIG_<target-dir-path>``. These properties are of type
  :module:`Map`, where each JSON block is represented as a *flat tree* list.

  Keys in the map are derived from the JSON property names. Nested properties
  are flattened by concatenating their successive parent keys, separated by a
  dot (``.``). For example, the JSON key ``rulesFile`` from the above example
  is stored in the map as ``dependencies.AppleLib.rulesFile``. The list of all
  keys for a target's map can be retrieved using the :command:`cmake_targets_file(GET_SETTINGS_KEYS)` command.

  Since CMake does not support two-dimensional arrays, and because a Map is
  itself a particular type of list, JSON arrays are serialized before being
  stored. Elements in a serialized array are separated by a pipe (``|``)
  character. For example, the JSON array ``["MY_DEFINE=42", "MY_OTHER_DEFINE",
  "MY_OTHER_DEFINE=42"]`` become
  ``MY_DEFINE=42|MY_OTHER_DEFINE|MY_OTHER_DEFINE=42``. And to avoid conflicts,
  pipe characters (``|``) are first escaped with a slash (``\|``).

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(LOAD "${CMAKE_SOURCE_DIR}/CMakeTargets.json")
    get_property(raw_json GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    get_property(is_loaded GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    get_property(paths_list GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
    get_property(apple_config GLOBAL PROPERTY "TARGETS_CONFIG_src/apple")
    get_property(banana_config GLOBAL PROPERTY "TARGETS_CONFIG_src/banana")
    get_property(src_config GLOBAL PROPERTY "TARGETS_CONFIG_src")
    message("'src' array is: ${src_config}")
    # output is:
    #   'src' array is: name:fruit-salad;type:executable;mainFile:src/main.cpp;
    #   pchFile:include/fruit_salad_pch.h;build.compileFeatures:cxx_std_20;
    #   build.compileDefinitions:MY_DEFINE=42|MY_OTHER_DEFINE|
    #   MY_OTHER_DEFINE=42;build.compileOptions:;build.linkOptions:;
    #   headerPolicy.mode:split;headerPolicy.includeDir:include;dependencies:
    #   AppleLib|BananaLib;dependencies.AppleLib.rulesFile:FindAppleLib.cmake;
    #   dependencies.AppleLib.minVersion:2;dependencies.AppleLib.autodownload:
    #   ON;dependencies.AppleLib.optional:OFF;dependencies.BananaLib.rulesFile
    #   :FindBananaLib.cmake;dependencies.BananaLib.minVersion:4;dependencies.
    #   BananaLib.autodownload:OFF;dependencies.BananaLib.optional:ON

.. signature::
  cmake_targets_file(IS_LOADED <output-var>)

  Set ``<output-var>`` to ``on`` if a targets configuration file has been
  loaded with success, or ``off`` otherwise. This checks the global property
  ``TARGETS_CONFIG_LOADED`` set by a successful invocation of the
  :command:`cmake_targets_file(LOAD)` command.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(LOAD "${CMAKE_SOURCE_DIR}/CMakeTargets.json")
    cmake_targets_file(IS_LOADED is_file_loaded)
    message("file_loaded: ${is_file_loaded}")
    # output is:
    #   file_loaded: on

.. signature::
  cmake_targets_file(GET_LOADED_FILE <output-var>)

  Set ``<output-var>`` to the full JSON content of the currently loaded
  targets configuration file. The content is retrieved from the global property
  ``TARGETS_CONFIG_RAW_JSON``, which is set by a successful invocation of the
  :command:`cmake_targets_file(LOAD)` command.

  An error is raised if no configuration file is loaded.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(GET_LOADED_FILE json_file_content)
    message("json_file_content: ${json_file_content}")
    # output is:
    #   json_file_content: {
    #     "$schema": "schema.json",
    #     "$id": "schema.json",
    #     "targets": {
    #       ...
    #     }
    #   }

.. signature::
  cmake_targets_file(GET_SETTINGS <output-var> TARGET <target-dir-path>)

  Retrieves the list of all settings defined for a given target configuration
  in the global property ``TARGETS_CONFIG_<target-dir-path>``.

  The ``<target-dir-path>`` specifies the directory path of the target whose
  configuration settings should be retrieved. This must correspond to a path
  listed in the global property ``TARGETS_CONFIG_LIST``, and must match one
  of the keys in the ``targets`` JSON object of the loaded configuration file.

  The result is stored in ``<output-var>`` as a :module:`Map`.

  An error is raised if no configuration file has been previously loaded with
  the :command:`cmake_targets_file(LOAD)` command or if the ``TARGET`` does not
  exist in the loaded configuration file.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(GET_SETTINGS target_config_map TARGET "src")
    message("target_config (src): ${target_config_map}")
    # output is:
    #   target_config (src): name:fruit-salad;type:executable;mainFile:
    #   src/main.cpp;pchFile:include/fruit_salad_pch.h;...

.. signature::
  cmake_targets_file(GET_SETTINGS_KEYS <output-var> TARGET <target-dir-path>)

  Retrieves the list of all setting keys defined for a given target
  configuration in the global property ``TARGETS_CONFIG_<target-dir-path>``.

  The ``<target-dir-path>`` specifies the directory path of the target whose
  configuration settings should be retrieved. This must correspond to a path
  listed in the global property ``TARGETS_CONFIG_LIST``, and must match one
  of the keys in the ``targets`` JSON object of the loaded configuration file.

  The result is stored in ``<output-var>`` as a semicolon-separated list.

  An error is raised if no configuration file has been previously loaded with
  the :command:`cmake_targets_file(LOAD)` command or if the ``TARGET`` does not
  exist in the loaded configuration file.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(GET_SETTINGS_KEYS setting_keys TARGET "src")
    message("setting_keys: ${setting_keys}")
    # output is:
    #   setting_keys: name;type;mainFile;pchFile;build.compileFeatures;
    #   build.compileDefinitions;...

.. signature::
  cmake_targets_file(GET_SETTING_VALUE <output-var> TARGET <target-dir-path> KEY <setting-name>)

  Retrieves the value of a specific configuration defined for a given target
  configuration in the global property ``TARGETS_CONFIG_<target-dir-path>``.

  The ``<target-dir-path>`` specifies the directory path of the target whose
  configuration setting should be retrieved. This must correspond to a path
  listed in the global property ``TARGETS_CONFIG_LIST``, and must match one
  of the keys in the ``targets`` JSON object of the loaded configuration file.

  The ``<setting-name>`` specifies the flattened key name as stored in the
  :module:`Map` ``TARGETS_CONFIG_<target-dir-path>``. Nested JSON properties
  are concatenated using a dot (``.``) separator (e.g.,
  ``build.compileDefinitions``).

  The result is stored in ``<output-var>`` as a value or a deserialized list.

  An error is raised if no configuration file has been previously loaded with
  the :command:`cmake_targets_file(LOAD)` command or if the ``TARGET`` does not
  exist in the loaded configuration file.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(GET_SETTING_VALUE setting_value TARGET "src" KEY "type")
    message("setting_value (type): ${setting_value}")
    # output is:
    #   setting_value (type): executable
    cmake_targets_file(GET_SETTING_VALUE setting_value TARGET "src" KEY "build.compileDefinitions")
    message("setting_value (build.compileDefinitions): ${setting_value}")
    # output is:
    #   setting_value (build.compileDefinitions): MY_DEFINE=42;MY_OTHER_DEFINE;
    #   MY_OTHER_DEFINE=42
    cmake_targets_file(GET_SETTING_VALUE setting_value TARGET "src" KEY "dependencies")
    message("setting_value (dependencies): ${setting_value}")
    # output is:
    #   setting_value (dependencies): AppleLib;BananaLib

.. signature::
  cmake_targets_file(PRINT_CONFIGS [])

  Prints the configuration of all targets defined in the currently loaded
  configuration file. It is primarily intended for debugging or inspecting the
  parsed target settings after loading a configuration file.

  An error is raised if no configuration file has been previously loaded with
  the :command:`cmake_targets_file(LOAD)` command

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(PRINT_CONFIGS)
    # output is:
    #   -- Target: fruit-salad
    #   --   type: executable
    #   --   mainFile: src/main.cpp
    #   --   pchFile: include/fruit_salad_pch.h
    #   --   build.compileFeatures: cxx_std_20
    #   ...

.. signature::
  cmake_targets_file(PRINT_TARGET_CONFIG <target-dir-path>)

  Prints the configuration of a given target configuration in the global
  property ``TARGETS_CONFIG_<target-dir-path>``. It is primarily intended for
  debugging or inspecting a parsed target settings after loading a
  configuration file.

  The ``<target-dir-path>`` specifies the directory path of the target whose
  configuration setting should be retrieved. This must correspond to a path
  listed in the global property ``TARGETS_CONFIG_LIST``, and must match one
  of the keys in the ``targets`` JSON object of the loaded configuration file.

  An error is raised if no configuration file has been previously loaded with
  the :command:`cmake_targets_file(LOAD)` command.

  Example usage:

  .. code-block:: cmake

    cmake_targets_file(PRINT_TARGET_CONFIG "src")
    # output is:
    #   -- Target: fruit-salad
    #   --   type: executable
    #   --   mainFile: src/main.cpp
    #   --   pchFile: include/fruit_salad_pch.h
    #   --   build.compileFeatures: cxx_std_20
    #   ...
#]=======================================================================]

include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)
include(Map)

#------------------------------------------------------------------------------
# Public function of this module
function(cmake_targets_file)
	set(options PRINT_CONFIGS)
	set(one_value_args LOAD IS_LOADED GET_LOADED_FILE GET_SETTING_VALUE TARGET KEY GET_SETTINGS GET_SETTINGS_KEYS PRINT_TARGET_CONFIG)
	set(multi_value_args "")
	cmake_parse_arguments(CTF "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})

	if(DEFINED CTF_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "Unrecognized arguments: \"${CTF_UNPARSED_ARGUMENTS}\"")
	endif()
	if(DEFINED CTF_LOAD)
		_cmake_targets_file_load()
	elseif(DEFINED CTF_IS_LOADED)
		_cmake_targets_file_is_loaded()
	elseif(DEFINED CTF_GET_LOADED_FILE)
		_cmake_targets_file_get_loaded_file()
	elseif(DEFINED CTF_GET_SETTING_VALUE)
		_cmake_targets_file_get_setting_value()
	elseif(DEFINED CTF_GET_SETTINGS)
		_cmake_targets_file_get_settings()
	elseif(DEFINED CTF_GET_SETTINGS_KEYS)
		_cmake_targets_file_get_settings_keys()
	elseif(${CTF_PRINT_CONFIGS})
		_cmake_targets_file_print_configs()
	elseif(DEFINED CTF_PRINT_TARGET_CONFIG)
		_cmake_targets_file_print_target_config()
	else()
		message(FATAL_ERROR "The operation name or arguments are missing!")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_load)
	if(NOT DEFINED CTF_LOAD)
		message(FATAL_ERROR "LOAD argument is missing or need a value!")
	endif()
	if((NOT EXISTS "${CTF_LOAD}") OR (IS_DIRECTORY "${CTF_LOAD}"))
		message(FATAL_ERROR "Given path: ${CTF_LOAD} does not refer to an existing path or file on disk!")
	endif()
	if(NOT "${CTF_LOAD}" MATCHES "\\.json$")
		message(FATAL_ERROR "Given path: ${CTF_LOAD} is not a json file!")
	endif()

	# Read the JSON file into a variable
	file(READ "${CTF_LOAD}" json_file_content)

	# Extract and parse the list of target paths (keys of the "targets" object)
	_get_json_object(targets_map "${json_file_content}" "targets")
	map(KEYS targets_map target_paths)
	foreach(target_path IN ITEMS ${target_paths})
		set(target_config_map "")
		map(GET targets_map "${target_path}" target_json_block)

		# Extract all simple top-level properties
		foreach(prop_key "name" "type" "mainFile" "pchFile")
			string(JSON prop_value GET "${target_json_block}" "${prop_key}")
			map(ADD target_config_map "${prop_key}" "${prop_value}")
		endforeach()

		# Extract nested 'build' configuration properties
		foreach(prop_key "compileFeatures" "compileDefinitions" "compileOptions" "linkOptions")
			_get_json_array(build_settings_list "${target_json_block}" "build" "${prop_key}")
			_serialize_list(serialized_list "${build_settings_list}")
			map(ADD target_config_map "build.${prop_key}" "${serialized_list}")
		endforeach()

		# Extract nested 'header policy' configuration properties
		string(JSON header_policy_mode GET "${target_json_block}" "headerPolicy" "mode")
		map(ADD target_config_map "headerPolicy.mode" "${header_policy_mode}")
		if("${header_policy_mode}" STREQUAL "split")
			# 'includeDir' is only required when mode is 'split'
			string(JSON include_dir GET "${target_json_block}" "headerPolicy" "includeDir")
			map(ADD target_config_map "headerPolicy.includeDir" "${include_dir}")
		endif()
		
		# Extract nested target 'dependencies' properties
		_get_json_object(deps_map "${target_json_block}" "dependencies")
		map(KEYS deps_map dep_names)
		_serialize_list(serialized_dep_names "${dep_names}")
		map(ADD target_config_map "dependencies" "${serialized_dep_names}")
		foreach(dep_name IN ITEMS ${dep_names})
			map(GET deps_map "${dep_name}" dep_json_block)
			foreach(prop_key "rulesFile" "minVersion" "autodownload" "optional")
				string(JSON prop_value GET "${dep_json_block}" "${prop_key}")
				map(ADD target_config_map "dependencies.${dep_name}.${prop_key}" "${prop_value}")
			endforeach()
		endforeach()
		
		# Store the target configuration
		set_property(GLOBAL PROPERTY "TARGETS_CONFIG_${target_path}" "${target_config_map}")
	endforeach()

	# Mark the configuration as loaded and store the raw JSON content and the
	# list of targets
	set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "${json_file_content}")
	set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "${target_paths}")
	set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED on)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
function(_get_json_array output_list_var json_block json_path)
	list(APPEND json_path ${ARGN}) # No quotes must be used because we don't want to keep empty elements
	if("${output_list_var}" STREQUAL "")
		message(FATAL_ERROR "output_list_var argument is missing!")
	endif()
	if("${json_block}" STREQUAL "")
		message(FATAL_ERROR "json_block argument is missing or empty!")
	endif()
	string(JSON json_block_type TYPE "${json_block}" ${json_path})
	if(NOT "${json_block_type}" STREQUAL "ARRAY")
		message(FATAL_ERROR "Given JSON block is not an ARRAY, but a ${json_block_type}!")
	endif()

	set(elements_list "")
	string(JSON json_array GET "${json_block}" ${json_path})
	_json_array_to_list(elements_list "${json_array}")
	set(${output_list_var} "${elements_list}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_json_array_to_list output_list_var json_array)
	if("${output_list_var}" STREQUAL "")
		message(FATAL_ERROR "output_list_var argument is missing!")
	endif()
	if("${json_array}" STREQUAL "")
		message(FATAL_ERROR "json_array argument is missing or empty!")
	endif()
	string(JSON json_block_type TYPE "${json_array}")
	if(NOT "${json_block_type}" STREQUAL "ARRAY")
		message(FATAL_ERROR "Given JSON block is not an ARRAY, but a ${json_block_type}!")
	endif()

	set(elements_list "")
	string(JSON nb_elem LENGTH "${json_array}")
	if (nb_elem GREATER 0)
		math(EXPR last_index "${nb_elem} - 1")
		foreach(i RANGE 0 ${last_index})
			string(JSON elem GET "${json_array}" ${i})
			list(APPEND elements_list "${elem}")
		endforeach()
	endif()
	set(${output_list_var} "${elements_list}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_get_json_object output_map_var json_block json_path)
	list(APPEND json_path ${ARGN}) # No quotes must be used because we don't want to keep empty elements
	if("${output_map_var}" STREQUAL "")
		message(FATAL_ERROR "output_map_var argument is missing!")
	endif()
	if("${json_block}" STREQUAL "")
		message(FATAL_ERROR "json_block argument is missing or empty!")
	endif()
	string(JSON json_block_type TYPE "${json_block}" ${json_path})
	if(NOT "${json_block_type}" STREQUAL "OBJECT")
		message(FATAL_ERROR "Given JSON block is not an OBJECT, but a ${json_block_type}!")
	endif()

	set(objects_map "")
	string(JSON json_object GET "${json_block}" ${json_path})
	_json_object_to_map(objects_map "${json_object}")
	set(${output_map_var} "${objects_map}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_json_object_to_map output_map_var json_object)
	if("${output_map_var}" STREQUAL "")
		message(FATAL_ERROR "output_map_var argument is missing!")
	endif()
	if("${json_object}" STREQUAL "")
		message(FATAL_ERROR "json_object argument is missing or empty!")
	endif()
	string(JSON json_block_type TYPE "${json_object}")
	if(NOT "${json_block_type}" STREQUAL "OBJECT")
		message(FATAL_ERROR "Given JSON block is not an OBJECT, but a ${json_block_type}!")
	endif()

	set(objects_map "")
	string(JSON nb_objects LENGTH "${json_object}")
	if(nb_objects GREATER 0)
		math(EXPR last_index "${nb_objects} - 1")
		foreach(i RANGE 0 ${last_index})
			string(JSON prop_key MEMBER "${json_object}" ${i})
			string(JSON prop_value GET "${json_object}" "${prop_key}")
			map(ADD objects_map "${prop_key}" "${prop_value}")
		endforeach()
	endif()
	set(${output_map_var} "${objects_map}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_serialize_list output_var input_list)
	if("${output_var}" STREQUAL "")
		message(FATAL_ERROR "output_var argument is missing!")
	endif()

	list(TRANSFORM input_list REPLACE "\\|" "\\\\|")
	list(JOIN input_list "|" joined)
	set(${output_var} "${joined}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_deserialize_list output_list_var encoded_string)
	if("${output_list_var}" STREQUAL "")
		message(FATAL_ERROR "output_list_var argument is missing!")
	endif()

	string(REPLACE "\\|" "<PIPE_ESC>" result "${encoded_string}")
	string(REPLACE "|" ";" result "${result}")
	string(REPLACE "<PIPE_ESC>" "|" result "${result}")
	set(${output_list_var} "${result}" PARENT_SCOPE)
endfunction()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_is_loaded)
	if(NOT DEFINED CTF_IS_LOADED)
		message(FATAL_ERROR "IS_LOADED argument is missing or need a value!")
	endif()

	get_property(is_file_loaded GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
	if(NOT "${is_file_loaded}" STREQUAL "on")
		set(${CTF_IS_LOADED} off PARENT_SCOPE)
	else()
		set(${CTF_IS_LOADED} on PARENT_SCOPE)
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_get_loaded_file)
	if(NOT DEFINED CTF_GET_LOADED_FILE)
		message(FATAL_ERROR "GET_LOADED_FILE argument is missing or need a value!")
	endif()
	_assert_config_file_loaded()

	get_property(is_set GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON" SET)
	if(NOT ${is_set})
		message(FATAL_ERROR "No JSON configuration file loaded!")
	endif()

	get_property(loaded_file_content GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
	set(${CTF_GET_LOADED_FILE} "${loaded_file_content}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_get_setting_value)
	if(NOT DEFINED CTF_GET_SETTING_VALUE)
		message(FATAL_ERROR "GET_SETTING_VALUE argument is missing or need a value!")
	endif()
	if(NOT DEFINED CTF_TARGET)
		message(FATAL_ERROR "TARGET argument is missing or need a value!")
	endif()
	if(NOT DEFINED CTF_KEY)
		message(FATAL_ERROR "KEY argument is missing or need a value!")
	endif()
	_assert_config_file_loaded()
	_assert_target_config_exists("${CTF_TARGET}")
	
	# Check if the key exists
	get_property(target_config_map GLOBAL PROPERTY "TARGETS_CONFIG_${CTF_TARGET}")
	map(HAS_KEY target_config_map "${CTF_KEY}" has_setting_key)
	if(NOT ${has_setting_key})
		message(FATAL_ERROR "Target ${CTF_TARGET} has no setting key '${CTF_KEY}'!")
	endif()

	# Get the value
	map(GET target_config_map "${CTF_KEY}" setting_value)
	
	# Deserialize the value if needed
	if("${CTF_KEY}"
		MATCHES "(dependencies|compileFeatures|compileDefinitions|compileOptions|linkOptions)$")
		_deserialize_list(setting_value "${setting_value}")
	endif()
	set(${CTF_GET_SETTING_VALUE} "${setting_value}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_get_settings)
	if(NOT DEFINED CTF_GET_SETTINGS)
		message(FATAL_ERROR "GET_SETTINGS argument is missing or need a value!")
	endif()
	if(NOT DEFINED CTF_TARGET)
		message(FATAL_ERROR "TARGET argument is missing or need a value!")
	endif()
	_assert_config_file_loaded()
	_assert_target_config_exists("${CTF_TARGET}")

	get_property(target_config_map GLOBAL PROPERTY "TARGETS_CONFIG_${CTF_TARGET}")
	set(${CTF_GET_SETTINGS} "${target_config_map}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_get_settings_keys)
	if(NOT DEFINED CTF_GET_SETTINGS_KEYS)
		message(FATAL_ERROR "GET_SETTINGS_KEYS argument is missing or need a value!")
	endif()
	if(NOT DEFINED CTF_TARGET)
		message(FATAL_ERROR "TARGET argument is missing or need a value!")
	endif()
	_assert_config_file_loaded()
	_assert_target_config_exists("${CTF_TARGET}")

	get_property(target_config_map GLOBAL PROPERTY "TARGETS_CONFIG_${CTF_TARGET}")
	map(KEYS target_config_map setting_keys)

	set(${CTF_GET_SETTINGS_KEYS} "${setting_keys}" PARENT_SCOPE)
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_print_configs)
	_assert_config_file_loaded()
	
	get_property(target_paths GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
	foreach(target_path IN ITEMS ${target_paths})
		set(CTF_PRINT_TARGET_CONFIG "${target_path}")
		_cmake_targets_file_print_target_config()
	endforeach()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_cmake_targets_file_print_target_config)
	if(NOT DEFINED CTF_PRINT_TARGET_CONFIG)
		message(FATAL_ERROR "PRINT_TARGET_CONFIG argument is missing or need a value!")
	endif()
	_assert_config_file_loaded()
	_assert_target_config_exists("${CTF_PRINT_TARGET_CONFIG}")

	get_property(target_config_map GLOBAL PROPERTY "TARGETS_CONFIG_${CTF_PRINT_TARGET_CONFIG}")
	map(GET target_config_map "name" target_name)
	message(STATUS "Target: ${target_name}")

	# Print all simple top-level settings
	foreach(setting_key "type" "mainFile" "pchFile")
		map(GET target_config_map "${setting_key}" setting_value)
		message(STATUS "  ${setting_key}: ${setting_value}")
	endforeach()

	# Print nested 'build' configuration settings
	foreach(setting_key "compileFeatures" "compileDefinitions" "compileOptions" "linkOptions")
		map(GET target_config_map "build.${setting_key}" setting_value)
		message(STATUS "  build.${setting_key}: ${setting_value}")
	endforeach()

	# Print nested 'header policy' configuration settings
	map(GET target_config_map "headerPolicy.mode" header_policy_mode)
	message(STATUS "  headerPolicy.mode: ${header_policy_mode}")
	if("${header_policy_mode}" STREQUAL "split")
		map(GET target_config_map "headerPolicy.includeDir" include_dir)
		message(STATUS "  headerPolicy.includeDir: ${include_dir}")
	endif()

	# Print nested target 'dependencies' configuration settings
	message(STATUS "  Dependencies:")
	map(GET target_config_map "dependencies" dep_names)
	if(NOT "${dep_names}" STREQUAL "")
		_deserialize_list(dep_names "${dep_names}")
		foreach(dep_name IN ITEMS ${dep_names})
			message(STATUS "    ${dep_name}:")
			foreach(dep_prop_key "rulesFile" "minVersion" "autodownload" "optional")
				map(GET target_config_map "dependencies.${dep_name}.${dep_prop_key}" dep_prop_value)
				message(STATUS "      ${dep_prop_key}: ${dep_prop_value}")
			endforeach()
		endforeach()
	endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
function(_assert_config_file_loaded)
	get_property(is_file_loaded GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
	if(NOT "${is_file_loaded}" STREQUAL "on")
		message(FATAL_ERROR "Targets configuration not loaded. Call cmake_targets_file(LOAD) first!")
	endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage
function(_assert_target_config_exists target_dir_path)
	if("${target_dir_path}" STREQUAL "")
		message(FATAL_ERROR "target_dir_path argument is missing!")
	endif()

	get_property(does_config_exist GLOBAL PROPERTY "TARGETS_CONFIG_${target_dir_path}" SET)
	if(NOT ${does_config_exist})
		message(FATAL_ERROR "No configuration found with the target path ${target_dir_path}!")
	endif()
endfunction()
