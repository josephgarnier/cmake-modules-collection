# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
BinaryTarget
------------

Operations to fully create and configure a *C++* binary target. It greatly
simplifies the most common process of creating an executable or library, by
wrapping calls to CMake functions in higher-level functions. However, for more
complex cases, you will need to use CMake's native commands. It requires CMake
3.20 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

  binary_target(`CREATE`_ <target-name> <STATIC|SHARED|HEADER|EXEC>)
  binary_target(`CONFIGURE_SETTINGS`_ <target-name> [...])
  binary_target(`ADD_SOURCES`_ <target-name> [...])
  binary_target(`ADD_PRECOMPILED_HEADER`_ <target-name> HEADER_FILE <file-path>)
  binary_target(`ADD_INCLUDE_DIRECTORIES`_ <target-name> INCLUDE_DIRECTORIES [<dir-path>...])
  binary_target(`ADD_DEPENDENCIES`_ <target-name> DEPENDENCIES [<target-name>...|<gen-expr>...])
  binary_target(`CREATE_FULLY`_ <target-name> [...])

Usage
^^^^^

.. signature::
  binary_target(CREATE <target-name> <STATIC|SHARED|HEADER|EXEC>)

  Create a binary target named ``<target-name>`` and add it to the current
  CMake project, according to the specified binary type: ``STATIC``, ``SHARED``
  , ``HEADER``, ``EXEC``.

  Example usage:

  .. code-block:: cmake

    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(CREATE "my_shared_lib" SHARED)

.. signature::
  binary_target(CONFIGURE_SETTINGS <target-name> [...])

  Configure settings for an existing binary target:

  .. code-block:: cmake

    binary_target(CONFIGURE_SETTINGS <target-name>
                 COMPILE_FEATURES [<feature>...]
                 COMPILE_DEFINITIONS [<definition>...]
                 COMPILE_OPTIONS [<option>...]
                 LINK_OPTIONS [<option>...])

  This command updates compile and link settings of a previously created
  target ``<target-name>`` with ``PRIVATE`` visibility. The following
  configuration options are supported:

  * ``COMPILE_FEATURES``: Add required compile features (e.g., ``cxx_std_20``,
    ``cxx_lambda``) with :cmake:command:`target_compile_features() <cmake:command:target_compile_features>`
    and populates the :cmake:prop_tgt:`COMPILE_FEATURES <cmake:prop_tgt:COMPILE_FEATURES>` target property.
  * ``COMPILE_DEFINITIONS``: Add preprocessor definitions (e.g., ``MY_DEFINE``
    or ``MY_DEFINE=42``) with :cmake:command:`target_compile_definitions() <cmake:command:target_compile_definitions>`
    and populates :cmake:prop_tgt:`COMPILE_OPTIONS <cmake:prop_tgt:COMPILE_DEFINITIONS>` target property.
  * ``COMPILE_OPTIONS``: Add compiler command-line options (e.g., ``-Wall``,
    ``/W4``) with :cmake:command:`target_compile_options() <cmake:command:target_compile_options>`
    and populates :cmake:prop_tgt:`COMPILE_OPTIONS <cmake:prop_tgt:COMPILE_OPTIONS>` target property.
  * ``LINK_OPTIONS``: Add linker command-line options (e.g., ``-s``,
    ``/INCREMENTAL:NO``) with :cmake:command:`target_link_options() <cmake:command:target_link_options>`
    and populates :cmake:prop_tgt:`LINK_OPTIONS <cmake:prop_tgt:LINK_OPTIONS>` target property.

  At the first call, the command sets the :cmake:prop_tgt:`CXX_STANDARD <cmake:prop_tgt:CXX_STANDARD>` property
  using the value of :cmake:variable:`CMAKE_CXX_STANDARD <cmake:variable:CMAKE_CXX_STANDARD>`, which must be defined.
  The target is also assigned to a default folder for improved IDE
  integration. All options are optional and may appear in any order. If a
  section is missing, it is simply ignored without warning.

  This command is intended for targets that have been previously created
  using :command:`binary_target(CREATE)`.

  Example usage:

  .. code-block:: cmake

    binary_target(CREATE "my_shared_lib" SHARED)
    binary_target(CONFIGURE_SETTINGS "my_shared_lib"
      COMPILE_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
    )

.. signature::
  binary_target(ADD_SOURCES <target-name> [...])

  Add source and header files to an existing binary target:

  .. code-block:: cmake

    binary_target(ADD_SOURCES <target-name>
                 SOURCE_FILES [<file-path>...]
                 PRIVATE_HEADER_FILES [<file-path>...]
                 PUBLIC_HEADER_FILES [<file-path>...])

  Assigns implementation and header files to the given binary target
  ``<target-name>`` with ``PRIVATE`` visibility:

  * ``SOURCE_FILES``: A list of source files (e.g., ``.cpp``, ``.c``)
    typically located in the ``src/`` directory.
  * ``PRIVATE_HEADER_FILES``: A list of private headers (e.g., ``.h``)
    typically located in the ``src/`` directory.
  * ``PUBLIC_HEADER_FILES``: A list of public headers, usually found in an
    ``include/`` directory.

  These files are added to the target with :cmake:command:`target_sources() <cmake:command:target_sources>` to populate
  the :cmake:prop_tgt:`SOURCES <cmake:prop_tgt:SOURCES>` target property.
  The command also defines a logical grouping of source files in IDEs (e.g.,
  Visual Studio) using :cmake:command:`source_group() <cmake:command:source_group>`, based on the
  project's source tree.

  This command is intended for targets that have been previously created
  using :command:`binary_target(CREATE)`, and is typically used in conjunction
  with :command:`directory(COLLECT_SOURCES_BY_POLICY)` to get the required
  files.

  Example usage:

  .. code-block:: cmake

    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "src/main.cpp" "src/util.cpp" "src/source_1.cpp"
      PRIVATE_HEADER_FILES "src/util.h" "src/source_1.h"
      PUBLIC_HEADER_FILES "include/lib_1.h" "include/lib_2.h"
    )

    # Or with `directory(COLLECT_SOURCES_BY_POLICY)`
    binary_target(CREATE "my_static_lib" STATIC)
    directory(COLLECT_SOURCES_BY_POLICY
      PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
      PRIVATE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src"
      PRIVATE_SOURCE_FILES private_sources
      PUBLIC_HEADER_DIR public_header_dir
      PUBLIC_HEADER_FILES public_headers
      PRIVATE_HEADER_DIR private_header_dir
      PRIVATE_HEADER_FILES private_headers
    )
    binary_target(ADD_SOURCES "my_static_lib"
      SOURCE_FILES "${private_sources}"
      PRIVATE_HEADER_FILES "${private_headers}"
      PUBLIC_HEADER_FILES "${public_headers}"
    )

.. signature::
  binary_target(ADD_PRECOMPILED_HEADER <target-name> HEADER_FILE <file-path>)

  Add a precompiled header file (PCH) ``<file_path>`` to an existing binary
  target ``<target_name>`` with ``PRIVATE`` visibility. The file is added to
  the target with :cmake:command:`target_precompile_headers() <cmake:command:target_precompile_headers>` to populate the
  :cmake:prop_tgt:`PRECOMPILE_HEADERS <cmake:prop_tgt:PRECOMPILE_HEADERS>` target property.

  This command is intended for targets that have been previously created
  using :command:`binary_target(CREATE)`.

  Example usage:

  .. code-block:: cmake

    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(ADD_PRECOMPILED_HEADER "my_static_lib"
      HEADER_FILE "src/header_pch.h"
    )

.. signature::
  binary_target(ADD_INCLUDE_DIRECTORIES <target-name> INCLUDE_DIRECTORIES [<dir-path>...])

  Add include directories to an existing binary target ``<target_name>`` with
  ``PRIVATE`` visibility. The file is added to the target with
  :cmake:command:`target_include_directories() <cmake:command:target_include_directories>` to populate the
  :cmake:prop_tgt:`INCLUDE_DIRECTORIES <cmake:prop_tgt:INCLUDE_DIRECTORIES>` target property.

  This command is intended for targets that have been previously created
  using :command:`binary_target(CREATE)`, and is typically used in conjunction
  with :command:`directory(COLLECT_SOURCES_BY_POLICY)` to get the required
  files.

  Example usage:

  .. code-block:: cmake

    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(ADD_INCLUDE_DIRECTORIES "my_static_lib"
      INCLUDE_DIRECTORIES "include"
    )

.. signature::
  binary_target(ADD_DEPENDENCIES <target-name> DEPENDENCIES [<target-name>...|<gen-expr>...])

  Add dependencies to use when linking a given target ``<target-name>``.

  The ``DEPENDENCIES`` keyword lists the names of other targets or generator
  expressions to linke to ``<target-name>``.

  The behavior is equivalent to calling :cmake:command:`target_link_libraries() <cmake:command:target_link_libraries>`.

  Example usage:
  
  .. code-block:: cmake

    # With target name
    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(ADD_DEPENDENCIES "my_static_lib"
      DEPENDENCIES "dep_1" "dep_2"
    )

    # With generator expression
    binary_target(CREATE "my_static_lib" STATIC)
    binary_target(ADD_DEPENDENCIES "my_static_lib"
      DEPENDENCIES
        "$<BUILD_INTERFACE:dep_1;dep_2>"
        "$<INSTALL_INTERFACE:dep_1;dep_2>"
    )

.. signature::
  binary_target(CREATE_FULLY <target-name> [...])

  Create a fully configured binary target.

  .. code-block:: cmake

    binary_target(CREATE_FULLY <target-name>
                  <STATIC|SHARED|HEADER|EXEC>
                  [COMPILE_FEATURES <feature>...]
                  [COMPILE_DEFINITIONS <definition>...]
                  [COMPILE_OPTIONS <option>...]
                  [LINK_OPTIONS <option>...]
                  SOURCE_FILES [<file-path>...]
                  PRIVATE_HEADER_FILES [<file-path>...]
                  PUBLIC_HEADER_FILES [<file-path>...]
                  [PRECOMPILED_HEADER_FILE <file-path>]
                  INCLUDE_DIRECTORIES [<dir-path>...]
                  [DEPENDENCIES [<target-name>...] ])

  Create a fully configured binary target named ``<target-name>`` and add it
  to the current project. This command acts as a high-level wrapper that
  combines the behavior of other module sub-commands, including
  :command:`binary_target(CREATE)`, :command:`binary_target(CONFIGURE_SETTINGS)`,
  :command:`binary_target(ADD_SOURCES)`, :command:`binary_target(ADD_PRECOMPILED_HEADER)`,
  :command:`binary_target(ADD_INCLUDE_DIRECTORIES)`, and :command:`binary_target(ADD_DEPENDENCIES)`.

  The second argument must specify the type of binary target to create:
  ``STATIC``, ``SHARED``, ``HEADER``, or ``EXEC``. Only one type may be given.

  Additional parameters can be provided to configure compile options,
  precompiled headers, include directories, and target dependencies. Each of
  these keywords delegates internally to the corresponding
  :module:`BinaryTarget` command. See their documentation for details.
  Example usage:

  .. code-block:: cmake

    directory(COLLECT_SOURCES_BY_POLICY
      PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
      PRIVATE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src"
      PRIVATE_SOURCE_FILES private_sources
      PUBLIC_HEADER_DIR public_header_dir
      PUBLIC_HEADER_FILES public_headers
      PRIVATE_HEADER_DIR private_header_dir
      PRIVATE_HEADER_FILES private_headers
    )
    binary_target(
      CREATE_FULLY "my_shared_lib"
      SHARED
      COMPILE_FEATURES "cxx_std_20"
      COMPILE_DEFINITIONS "MY_DEFINE"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s"
      SOURCE_FILES "${private_sources}"
      PRIVATE_HEADER_FILES "${private_headers}"
      PUBLIC_HEADER_FILES "${public_headers}"
      PRECOMPILED_HEADER_FILE "src/header_pch.h"
      INCLUDE_DIRECTORIES "$<$<BOOL:${private_header_dir}>:${private_header_dir}>" "${public_header_dir}"
      DEPENDENCIES "dep_1" "dep_2"
    )

Full example
^^^^^^^^^^^^

This example shows how to call the module functions to create a complete
binary.

.. code-block:: cmake

  binary_target(CREATE "my_shared_lib" SHARED)
  binary_target(CONFIGURE_SETTINGS "my_shared_lib"
    COMPILE_FEATURES "cxx_std_20"
    COMPILE_DEFINITIONS "MY_DEFINE"
    COMPILE_OPTIONS "-Wall" "-Wextra"
    LINK_OPTIONS "-s"
  )
  directory(COLLECT_SOURCES_BY_POLICY
    PUBLIC_HEADERS_SEPARATED on "${CMAKE_SOURCE_DIR}/include/mylib"
    PRIVATE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src"
    PRIVATE_SOURCE_FILES private_sources
    PUBLIC_HEADER_DIR public_header_dir
    PUBLIC_HEADER_FILES public_headers
    PRIVATE_HEADER_DIR private_header_dir
    PRIVATE_HEADER_FILES private_headers
  )
  binary_target(ADD_SOURCES "my_shared_lib"
    SOURCE_FILES "${private_sources}"
    PRIVATE_HEADER_FILES "${private_headers}"
    PUBLIC_HEADER_FILES "${public_headers}"
  )
  binary_target(ADD_PRECOMPILED_HEADER "my_shared_lib"
    HEADER_FILE "src/header_pch.h"
  )
  binary_target(ADD_INCLUDE_DIRECTORIES "my_shared_lib"
    INCLUDE_DIRECTORIES "$<$<BOOL:${private_header_dir}>:${private_header_dir}>" "${public_header_dir}"
  )
#]=======================================================================]

include_guard()

cmake_minimum_required (VERSION 3.20 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module
function(binary_target)
  set(options STATIC SHARED HEADER EXEC)
  set(one_value_args CREATE CONFIGURE_SETTINGS ADD_SOURCES ADD_PRECOMPILED_HEADER HEADER_FILE ADD_INCLUDE_DIRECTORIES ADD_DEPENDENCIES CREATE_FULLY PRECOMPILED_HEADER_FILE)
  set(multi_value_args COMPILE_FEATURES COMPILE_DEFINITIONS COMPILE_OPTIONS LINK_OPTIONS SOURCE_FILES PRIVATE_HEADER_FILES PUBLIC_HEADER_FILES INCLUDE_DIRECTORIES DEPENDENCIES)
  cmake_parse_arguments(BBT "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
  
  if(DEFINED BBT_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unrecognized arguments: \"${BBT_UNPARSED_ARGUMENTS}\"")
  endif()
  if(DEFINED BBT_CREATE)
    _binary_target_create()
  elseif(DEFINED BBT_CREATE_FULLY)
    _binary_target_create_fully()
  elseif(DEFINED BBT_CONFIGURE_SETTINGS)
    _binary_target_config_settings()
  elseif(DEFINED BBT_ADD_SOURCES)
    _binary_target_add_sources()
  elseif(DEFINED BBT_ADD_PRECOMPILED_HEADER)
    _binary_target_add_pre_header()
  elseif(DEFINED BBT_ADD_INCLUDE_DIRECTORIES)
    _binary_target_add_include_dirs()
  elseif(DEFINED BBT_ADD_DEPENDENCIES)
    _binary_target_add_dependencies()
  else()
    message(FATAL_ERROR "The operation name or arguments are missing!")
  endif()
endfunction()

#------------------------------------------------------------------------------
# Internal usage
macro(_binary_target_create)
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
    message(STATUS "Static library target \"${BBT_CREATE}\" added to project")
  elseif(${BBT_SHARED})
    # All libraries will be built shared unless the library was explicitly
    # added as a static library
    set(BUILD_SHARED_LIBS                           on)
    message(STATUS "All exported symbols are hidden by default")
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS            off)
    set(CMAKE_CXX_VISIBILITY_PRESET                 "hidden")
    set(CMAKE_VISIBILITY_INLINES_HIDDEN             on)
    add_library("${BBT_CREATE}" SHARED)
    message(STATUS "Shared library target \"${BBT_CREATE}\" added to project")
  elseif(${BBT_HEADER})
    add_library("${BBT_CREATE}" INTERFACE)
    message(STATUS "Header-only library target \"${BBT_CREATE}\" added to project")
  elseif(${BBT_EXEC})
    add_executable("${BBT_CREATE}")
    message(STATUS "Executable target \"${BBT_CREATE}\" added to project")
  else()
    message(FATAL_ERROR "Invalid binary type: expected STATIC, SHARED, HEADER or EXEC!")
  endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_binary_target_config_settings)
  if(NOT DEFINED BBT_CONFIGURE_SETTINGS)
    message(FATAL_ERROR "CONFIGURE_SETTINGS argument is missing or need a value!")
  endif()
  if(NOT TARGET "${BBT_CONFIGURE_SETTINGS}")
    message(FATAL_ERROR "The target \"${BBT_CONFIGURE_SETTINGS}\" does not exists!")
  endif()
  if((NOT DEFINED BBT_COMPILE_FEATURES)
    AND (NOT "COMPILE_FEATURES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "COMPILE_FEATURES argument is missing or need a value!")
  endif()
  if((NOT DEFINED BBT_COMPILE_DEFINITIONS)
    AND (NOT "COMPILE_DEFINITIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "COMPILE_DEFINITIONS argument is missing or need a value!")
  endif()
  if((NOT DEFINED BBT_COMPILE_OPTIONS)
    AND (NOT "COMPILE_OPTIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "COMPILE_OPTIONS argument is missing or need a value!")
  endif()
  if((NOT DEFINED BBT_LINK_OPTIONS)
    AND (NOT "LINK_OPTIONS" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "LINK_OPTIONS argument is missing or need a value!")
  endif()
  if(NOT DEFINED CMAKE_CXX_STANDARD)
    message(FATAL_ERROR "CMAKE_CXX_STANDARD is not set!")
  endif()

  # Add the bin target in a folder for IDE project
  set_target_properties("${BBT_CONFIGURE_SETTINGS}" PROPERTIES FOLDER "")
  
  # Add C++ standard in target compile features
  get_target_property(compile_features "${BBT_CONFIGURE_SETTINGS}" COMPILE_FEATURES)
  set(cxx_standard "cxx_std_${CMAKE_CXX_STANDARD}")
  if(NOT compile_features STREQUAL "NOTFOUND")
    list(FIND compile_features "${cxx_standard}" index_of)
  else()
    set(index_of -1)
  endif()
  if(index_of EQUAL -1)
    target_compile_features("${BBT_CONFIGURE_SETTINGS}" PRIVATE "${cxx_standard}")
  endif()

  # Add input target compile features
  if(DEFINED BBT_COMPILE_FEATURES)
    target_compile_features("${BBT_CONFIGURE_SETTINGS}"
      PRIVATE
        ${BBT_COMPILE_FEATURES} # don't add quote (but yeah, it's inconsistent with the other CMake functions)
    )
    message(STATUS "C++ standard set to: C++${CMAKE_CXX_STANDARD}")
    message(STATUS "Applied compile features: ${BBT_COMPILE_FEATURES}")
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
# Internal usage
macro(_binary_target_add_sources)
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
    source_group(TREE "${CMAKE_SOURCE_DIR}"
      FILES "${BBT_SOURCE_FILES}")
  endif()
  if(DEFINED BBT_PRIVATE_HEADER_FILES)
    target_sources("${BBT_ADD_SOURCES}" PRIVATE "${BBT_PRIVATE_HEADER_FILES}")
    source_group(TREE "${CMAKE_SOURCE_DIR}"
      FILES "${BBT_PRIVATE_HEADER_FILES}")
  endif()
  if(DEFINED BBT_PUBLIC_HEADER_FILES)
    target_sources("${BBT_ADD_SOURCES}" PRIVATE "${BBT_PUBLIC_HEADER_FILES}")
    source_group(TREE "${CMAKE_SOURCE_DIR}"
      FILES "${BBT_PUBLIC_HEADER_FILES}")
  endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_binary_target_add_pre_header)
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
# Internal usage
macro(_binary_target_add_include_dirs)
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

#------------------------------------------------------------------------------
# Internal usage
macro(_binary_target_add_dependencies)
  if(NOT DEFINED BBT_ADD_DEPENDENCIES)
    message(FATAL_ERROR "ADD_DEPENDENCIES argument is missing or need a value!")
  endif()
  if(NOT TARGET "${BBT_ADD_DEPENDENCIES}")
    message(FATAL_ERROR "The target \"${BBT_ADD_DEPENDENCIES}\" does not exists!")
  endif()
  if((NOT DEFINED BBT_DEPENDENCIES)
    AND (NOT "DEPENDENCIES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "DEPENDENCIES argument is missing or need a value!")
  endif()

  if(DEFINED BBT_DEPENDENCIES)
    target_link_libraries("${BBT_ADD_DEPENDENCIES}"
      PUBLIC
        "${BBT_DEPENDENCIES}"
    )
  endif()
endmacro()

#------------------------------------------------------------------------------
# Internal usage
macro(_binary_target_create_fully)
  if(NOT DEFINED BBT_CREATE_FULLY)
    message(FATAL_ERROR "CREATE_FULLY argument is missing or need a value!")
  endif()
  if(TARGET "${BBT_CREATE_FULLY}")
    message(FATAL_ERROR "The target \"${BBT_CREATE_FULLY}\" already exists!")
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
  if("COMPILE_FEATURES" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "COMPILE_FEATURES argument is missing or need a value!")
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
  if("PRECOMPILED_HEADER_FILE" IN_LIST BBT_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "PRECOMPILED_HEADER_FILE argument is missing or need a value!")
  endif()
  if((DEFINED BBT_PRECOMPILED_HEADER_FILE)
    AND (NOT EXISTS "${BBT_PRECOMPILED_HEADER_FILE}"))
    message(FATAL_ERROR "Given path: ${BBT_PRECOMPILED_HEADER_FILE} does not refer to an existing path or directory on disk!")
  endif()
  if((NOT DEFINED BBT_INCLUDE_DIRECTORIES)
    AND (NOT "INCLUDE_DIRECTORIES" IN_LIST BBT_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "INCLUDE_DIRECTORIES argument is missing or need a value!")
  endif()

  # Call binary_target(CREATE)
  set(BBT_CREATE "${BBT_CREATE_FULLY}")
  _binary_target_create()

  # Call binary_target(CONFIGURE_SETTINGS)
  set(BBT_CONFIGURE_SETTINGS "${BBT_CREATE_FULLY}")
  if(NOT DEFINED BBT_COMPILE_FEATURES)
    list(APPEND BBT_KEYWORDS_MISSING_VALUES "COMPILE_FEATURES")
  endif()
  if(NOT DEFINED BBT_COMPILE_DEFINITIONS)
    list(APPEND BBT_KEYWORDS_MISSING_VALUES "COMPILE_DEFINITIONS")
  endif()
  if(NOT DEFINED BBT_COMPILE_OPTIONS)
    list(APPEND BBT_KEYWORDS_MISSING_VALUES "COMPILE_OPTIONS")
  endif()
  if(NOT DEFINED BBT_LINK_OPTIONS)
    list(APPEND BBT_KEYWORDS_MISSING_VALUES "LINK_OPTIONS")
  endif()
  _binary_target_config_settings()

  # Call binary_target(ADD_SOURCES)
  set(BBT_ADD_SOURCES "${BBT_CREATE_FULLY}")
  _binary_target_add_sources()

  # Call binary_target(ADD_PRECOMPILED_HEADER)
  if(DEFINED BBT_PRECOMPILED_HEADER_FILE)
    set(BBT_ADD_PRECOMPILED_HEADER "${BBT_CREATE_FULLY}")
    set(BBT_HEADER_FILE "${BBT_PRECOMPILED_HEADER_FILE}")
    _binary_target_add_pre_header()
  endif()

  # Call binary_target(ADD_INCLUDE_DIRECTORIES)
  set(BBT_ADD_INCLUDE_DIRECTORIES "${BBT_CREATE_FULLY}")
  _binary_target_add_include_dirs()

  # Call binary_target(ADD_DEPENDENCIES)
  if(DEFINED BBT_DEPENDENCIES)
    set(BBT_ADD_DEPENDENCIES "${BBT_CREATE_FULLY}")
    _binary_target_add_dependencies()
  endif()
endmacro()