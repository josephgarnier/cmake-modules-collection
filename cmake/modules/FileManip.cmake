# Copyright 2019-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:
FileManip
---------

Operations on files. It requires CMake 4.0.1 or newer.

Synopsis
^^^^^^^^

.. parsed-literal::

  file_manip(`RELATIVE_PATH`_ <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])
  file_manip(`ABSOLUTE_PATH`_ <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])
  file_manip(`STRIP_PATH`_ <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])
  file_manip(`GET_COMPONENT`_ [<file-path>...] MODE <mode> OUTPUT_VARIABLE <output-list-var>)

Usage
^^^^^

.. signature::
  file_manip(RELATIVE_PATH <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])

  Computes the relative path from a given ``BASE_DIR`` for each file and
  directory in the list variable named ``<file-list-var>``. The files and the
  ``BASE_DIR`` must exist on the disk and must be passed as absolute path. The
  result is stored either in-place in ``<file-list-var>``, or in the variable
  specified by ``<output-list-var>``, if the ``OUTPUT_VARIABLE`` option is
  provided. The result is an empty list if the input list is empty.

  Example usage:

  .. code-block:: cmake

    set(files
      "${CMAKE_SOURCE_DIR}/src/main.cpp"
      "${CMAKE_SOURCE_DIR}/src")
    file_manip(RELATIVE_PATH files BASE_DIR "${CMAKE_SOURCE_DIR}")
    # files is:
    #   src/main.cpp;src

.. signature::
  file_manip(ABSOLUTE_PATH <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])

  Computes the absolute path from a given ``BASE_DIR`` for each file and
  directory in the list variable named ``<file-list-var>``. Files and the
  ``BASE_DIR`` must exist on the disk. ``BASE_DIR`` must be passed as absolute
  path, while the files can be relative or absolute. The result is stored
  either in-place in ``<file-list-var>``, or in the variable specified by
  ``<output-list-var>``, if the ``OUTPUT_VARIABLE`` option is provided. The
  result is an empty list if the input list is empty.

  Example usage:

  .. code-block:: cmake

    set(files
      "src/main.cpp"
      "src"
      "${CMAKE_SOURCE_DIR}/src/main.cpp"
      "${CMAKE_SOURCE_DIR}/src")
    file_manip(ABSOLUTE_PATH files BASE_DIR "${CMAKE_SOURCE_DIR}")
    # files is:
    #   /full/path/to/src/main.cpp;/full/path/to/src;/full/path/to/src/main.cpp;/full/path/to/src

.. signature::
  file_manip(STRIP_PATH <file-list-var> BASE_DIR <dir-path> [OUTPUT_VARIABLE <output-list-var>])

  Removes the ``BASE_DIR`` prefix from each file or directory path in
  ``<file-list-var>``. The result is stored either in-place in
  ``<file-list-var>``, or in the variable specified by ``<output-list-var>``,
  if the ``OUTPUT_VARIABLE`` option is provided. ``BASE_DIR`` must be
  provided without trailing slash. The result is an empty list if the input
  list is empty.

  Like with :cmake:command:`cmake_path() <cmake:command:cmake_path>`,
  only syntactic aspects of paths are handled, there is no interaction of any
  kind with any underlying file system. A path may represent a non-existing
  path or even one that is not allowed to exist on the current file system or
  platform, no error is raised when a file do not exist. A path can be relative
  or absolute.

  Example usage:

  .. code-block:: cmake

    set(files
      "src/main.cpp"
      "src"
      "${CMAKE_SOURCE_DIR}/src/main.cpp"
      "${CMAKE_SOURCE_DIR}/src"
      "fake/directory/file.cpp"
      "fake/directory"
      "${CMAKE_SOURCE_DIR}/fake/directory/file.cpp"
      "${CMAKE_SOURCE_DIR}/fake/directory")
    file_manip(STRIP_PATH files BASE_DIR "${CMAKE_SOURCE_DIR}")
    # output is:
    #   src/main.cpp;src;src/main.cpp;src;fake/directory/file.cpp;fake/directory;fake/directory/file.cpp;fake/directory

.. signature::
  file_manip(GET_COMPONENT [<file-path>...] MODE <mode> OUTPUT_VARIABLE <output-list-var>)

  Extracts a specific component defined by ``MODE`` from each path to a file
  or a directory in the given ``<file-path>`` list and stores the result in the
  variable specified by ``OUTPUT_VARIABLE`` option. The result is an empty list
  if the input list is empty.

  Like with :cmake:command:`cmake_path() <cmake:command:cmake_path>`,
  only syntactic aspects of paths are handled, there is no interaction of any
  kind with any underlying file system. A path may represent a non-existing
  path or even one that is not allowed to exist on the current file system or
  platform, no error is raised when a file do not exist. A path can be relative
  or absolute.

  The ``MODE`` argument determines which component to extract and must be one of:

  * ``DIRECTORY`` - Directory without file name.
  * ``NAME``      - File name without directory.

  Example usage:

  .. code-block:: cmake

    set(files
      "src/main.cpp"
      "src"
      "${CMAKE_SOURCE_DIR}/src/main.cpp"
      "${CMAKE_SOURCE_DIR}/src"
      "fake/directory/file.cpp"
      "fake/directory"
      "${CMAKE_SOURCE_DIR}/fake/directory/file.cpp"
      "${CMAKE_SOURCE_DIR}/fake/directory")
    file_manip(GET_COMPONENT ${files} MODE DIRECTORY OUTPUT_VARIABLE dirs)
    # dirs is:
    #   src;src;/full/path/to/src;/full/path/to/src;fake/directory;fake;full/path/to/fake/directory;full/path/to/fake
    file_manip(GET_COMPONENT ${files} MODE NAME OUTPUT_VARIABLE filenames)
    # filenames is:
    #   main.cpp;src;main.cpp;src;file.cpp;directory;file.cpp;directory
#]=======================================================================]

include_guard()

cmake_minimum_required(VERSION 4.0.1 FATAL_ERROR)

#------------------------------------------------------------------------------
# Public function of this module
function(file_manip)
  set(options "")
  set(one_value_args RELATIVE_PATH ABSOLUTE_PATH STRIP_PATH BASE_DIR MODE OUTPUT_VARIABLE)
  set(multi_value_args GET_COMPONENT)
  cmake_parse_arguments(PARSE_ARGV 0 arg
    "${options}" "${one_value_args}" "${multi_value_args}"
  )

  if(DEFINED arg_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() called with unrecognized arguments: \"${arg_UNPARSED_ARGUMENTS}\"!")
  endif()

  if(DEFINED arg_RELATIVE_PATH)
    _file_manip_relative_path()
  elseif(DEFINED arg_ABSOLUTE_PATH)
    _file_manip_absolute_path()
  elseif(DEFINED arg_STRIP_PATH)
    _file_manip_strip_path()
  elseif((DEFINED arg_GET_COMPONENT)
      OR ("GET_COMPONENT" IN_LIST arg_KEYWORDS_MISSING_VALUES))
    if("${arg_MODE}" STREQUAL DIRECTORY)
      _file_manip_get_component_directory()
    elseif("${arg_MODE}" STREQUAL NAME)
      _file_manip_get_component_name()
    else()
      message(FATAL_ERROR "file_manip(GET_COMPONENT) requires a MODE to be specified!")
    endif()
  else()
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}(<OP> <value> ...) requires an operation and a value to be specified!")
  endif()
endfunction()

#------------------------------------------------------------------------------
# [Internal use only]
macro(_file_manip_relative_path)
  if(NOT DEFINED arg_RELATIVE_PATH)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() requires the keyword RELATIVE_PATH to be provided!")
  endif()
  if("${arg_RELATIVE_PATH}" STREQUAL "")
    message(FATAL_ERROR "file_manip(RELATIVE_PATH) requires RELATIVE_PATH to be a non-empty string!")
  endif()
  if(NOT DEFINED arg_BASE_DIR)
    message(FATAL_ERROR "file_manip(RELATIVE_PATH) requires the keyword BASE_DIR to be provided!")
  endif()
  if("${arg_BASE_DIR}" STREQUAL "")
    message(FATAL_ERROR "file_manip(RELATIVE_PATH) requires BASE_DIR to be a non-empty string!")
  endif()
  if((NOT EXISTS "${arg_BASE_DIR}")
      OR (NOT IS_DIRECTORY "${arg_BASE_DIR}"))
    message(FATAL_ERROR "file_manip(RELATIVE_PATH) requires BASE_DIR '${arg_BASE_DIR}' to be an existing directory on disk!")
  endif()

  set(relative_path_list "")
  foreach(file IN ITEMS ${${arg_RELATIVE_PATH}})
    if(NOT EXISTS "${file}")
      message(FATAL_ERROR "file_manip(RELATIVE_PATH) given path '${file}' does not exist on disk!")
    endif()
    file(RELATIVE_PATH relative_path "${arg_BASE_DIR}" "${file}")
    list(APPEND relative_path_list "${relative_path}")
  endforeach()

  if(NOT DEFINED arg_OUTPUT_VARIABLE)
    set(${arg_RELATIVE_PATH} "${relative_path_list}" PARENT_SCOPE)
  else()
    set(${arg_OUTPUT_VARIABLE} "${relative_path_list}" PARENT_SCOPE)
  endif()
endmacro()

#------------------------------------------------------------------------------
# [Internal use only]
macro(_file_manip_absolute_path)
  if(NOT DEFINED arg_ABSOLUTE_PATH)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() requires the keyword ABSOLUTE_PATH to be provided!")
  endif()
  if("${arg_ABSOLUTE_PATH}" STREQUAL "")
    message(FATAL_ERROR "file_manip(ABSOLUTE_PATH) requires ABSOLUTE_PATH to be a non-empty string!")
  endif()
  if(NOT DEFINED arg_BASE_DIR)
    message(FATAL_ERROR "file_manip(ABSOLUTE_PATH) requires the keyword BASE_DIR to be provided!")
  endif()
  if("${arg_BASE_DIR}" STREQUAL "")
    message(FATAL_ERROR "file_manip(ABSOLUTE_PATH) requires BASE_DIR to be a non-empty string!")
  endif()
  if((NOT EXISTS "${arg_BASE_DIR}")
      OR (NOT IS_DIRECTORY "${arg_BASE_DIR}"))
    message(FATAL_ERROR "file_manip(ABSOLUTE_PATH) requires BASE_DIR '${arg_BASE_DIR}' to be an existing directory on disk!")
  endif()

  set(absolute_path_list "")
  foreach(file IN ITEMS ${${arg_ABSOLUTE_PATH}})
    file(REAL_PATH "${file}" absolute_path BASE_DIRECTORY "${arg_BASE_DIR}")
    if(NOT EXISTS "${absolute_path}")
      message(FATAL_ERROR "file_manip(ABSOLUTE_PATH) given path '${absolute_path}' does not exist on disk!")
    endif()
    list(APPEND absolute_path_list ${absolute_path})
  endforeach()

  if(NOT DEFINED arg_OUTPUT_VARIABLE)
    set(${arg_ABSOLUTE_PATH} "${absolute_path_list}" PARENT_SCOPE)
  else()
    set(${arg_OUTPUT_VARIABLE} "${absolute_path_list}" PARENT_SCOPE)
  endif()
endmacro()

#------------------------------------------------------------------------------
# [Internal use only]
macro(_file_manip_strip_path)
  if(NOT DEFINED arg_STRIP_PATH)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() requires the keyword STRIP_PATH to be provided!")
  endif()
  if("${arg_STRIP_PATH}" STREQUAL "")
    message(FATAL_ERROR "file_manip(STRIP_PATH) requires STRIP_PATH to be a non-empty string!")
  endif()
  if(NOT DEFINED arg_BASE_DIR)
    message(FATAL_ERROR "file_manip(STRIP_PATH) requires the keyword BASE_DIR to be provided!")
  endif()
  if("${arg_BASE_DIR}" STREQUAL "")
    message(FATAL_ERROR "file_manip(STRIP_PATH) requires BASE_DIR to be a non-empty string!")
  endif()

  set(stripped_path_list "")
  foreach(file_path IN ITEMS ${${arg_STRIP_PATH}})
    string(REPLACE "${arg_BASE_DIR}/" "" stripped_path "${file_path}")
    list(APPEND stripped_path_list ${stripped_path})
  endforeach()

  if(NOT DEFINED arg_OUTPUT_VARIABLE)
    set(${arg_STRIP_PATH} "${stripped_path_list}" PARENT_SCOPE)
  else()
    set(${arg_OUTPUT_VARIABLE} "${stripped_path_list}" PARENT_SCOPE)
  endif()
endmacro()

#------------------------------------------------------------------------------
# [Internal use only]
macro(_file_manip_get_component_directory)
  if((NOT DEFINED arg_GET_COMPONENT)
      AND (NOT "GET_COMPONENT" IN_LIST arg_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() requires the keyword GET_COMPONENT to be provided!")
  endif()
  if(NOT DEFINED arg_MODE)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires the keyword MODE to be provided!")
  endif()
  if(NOT "${arg_MODE}" STREQUAL DIRECTORY)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires MODE to have the value 'DIRECTORY'!")
  endif()
  if(NOT DEFINED arg_OUTPUT_VARIABLE)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires the keyword OUTPUT_VARIABLE to be provided!")
  endif()
  if("${arg_OUTPUT_VARIABLE}" STREQUAL "")
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires OUTPUT_VARIABLE to be a non-empty string!")
  endif()

  set(${arg_OUTPUT_VARIABLE} "")
  foreach(file_path IN ITEMS ${arg_GET_COMPONENT})
    cmake_path(GET file_path PARENT_PATH directory_path)
    list(APPEND ${arg_OUTPUT_VARIABLE} "${directory_path}")
  endforeach()

  return(PROPAGATE "${arg_OUTPUT_VARIABLE}")
endmacro()

#------------------------------------------------------------------------------
# [Internal use only]
macro(_file_manip_get_component_name)
  if((NOT DEFINED arg_GET_COMPONENT)
      AND (NOT "GET_COMPONENT" IN_LIST arg_KEYWORDS_MISSING_VALUES))
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION}() requires the keyword GET_COMPONENT to be provided!")
  endif()
  if(NOT DEFINED arg_MODE)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires the keyword MODE to be provided!")
  endif()
  if(NOT "${arg_MODE}" STREQUAL NAME)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires MODE to have the value 'NAME'!")
  endif()
  if(NOT DEFINED arg_OUTPUT_VARIABLE)
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires the keyword OUTPUT_VARIABLE to be provided!")
  endif()
  if("${arg_OUTPUT_VARIABLE}" STREQUAL "")
    message(FATAL_ERROR "file_manip(GET_COMPONENT) requires OUTPUT_VARIABLE to be a non-empty string!")
  endif()

  set(${arg_OUTPUT_VARIABLE} "")
  foreach(file_path IN ITEMS ${arg_GET_COMPONENT})
    cmake_path(GET file_path FILENAME file_name)
    list(APPEND ${arg_OUTPUT_VARIABLE} "${file_name}")
  endforeach()

  return(PROPAGATE "${arg_OUTPUT_VARIABLE}")
endmacro()