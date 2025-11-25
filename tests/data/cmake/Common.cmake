# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

include_guard()

cmake_minimum_required(VERSION 4.0.1 FATAL_ERROR)
include(Directory)

#------------------------------------------------------------------------------
# Create a mock library targets for tests
function(add_mock_lib name)
  cmake_parse_arguments(arg "SKIP_IF_EXISTS;STATIC;SHARED" "" "" ${ARGN})
  if(TARGET "${name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  if(${arg_STATIC})
    add_library("${name}" STATIC)
  elseif(${arg_SHARED})
    add_library("${name}" SHARED)
  endif()
  # A target needs at least one source to avoid an error
  target_sources("${name}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")
endfunction()

#------------------------------------------------------------------------------
# Create an imported mock library target for tests in simulating a call to
# `dependency(IMPORT)`
function(import_mock_lib imp_lib_name base_lib_name)
  cmake_parse_arguments(arg "SKIP_IF_EXISTS;STATIC;SHARED" "" "" ${ARGN})
  if(TARGET "${imp_lib_name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  if(${arg_STATIC})
    set(lib_build_type "STATIC")
  elseif(${arg_SHARED})
    set(lib_build_type "SHARED")
  endif()

  add_library("${imp_lib_name}" ${lib_build_type} IMPORTED)
  set_target_properties("${imp_lib_name}" PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ""
    INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
    INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
  )
  directory(FIND_LIB lib_file_path
    FIND_IMPLIB implib_file_path
    NAME "${base_lib_name}"
    ${lib_build_type}
    RELATIVE off
    ROOT_DIR "${TESTS_DATA_DIR}/bin"
  )
  if("${implib_file_path}" MATCHES "-NOTFOUND$")
    set(implib_file_path "")
  endif()

  cmake_path(GET lib_file_path FILENAME lib_file_name)
  set_target_properties("${imp_lib_name}" PROPERTIES
    IMPORTED_LOCATION_${cmake_build_type_upper} "${lib_file_path}"
    IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} ""
    IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} ""
    IMPORTED_IMPLIB_${cmake_build_type_upper} "${implib_file_path}"
    IMPORTED_SONAME_${cmake_build_type_upper} "${lib_file_name}"
  )
  set_property(TARGET "${imp_lib_name}"
    APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
  )
endfunction()

#------------------------------------------------------------------------------
# Create an imported mock library target for tests in simulating a call to
# `dependency(IMPORT)`, `dependency(ADD_INCLUDE_DIRECTORIES)`, and
# `dependency(IMPORTED_LOCATION)`
function(import_full_mock_lib imp_lib_name base_lib_name)
  cmake_parse_arguments(arg "SKIP_IF_EXISTS;STATIC;SHARED" "" "" ${ARGN})
  if(TARGET "${imp_lib_name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  if(${arg_STATIC})
    set(lib_build_type "STATIC")
  elseif(${arg_SHARED})
    set(lib_build_type "SHARED")
  endif()

  add_library("${imp_lib_name}" ${lib_build_type} IMPORTED)
  set_target_properties("${imp_lib_name}" PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${TESTS_DATA_DIR}/include"
    INTERFACE_INCLUDE_DIRECTORIES_BUILD "${TESTS_DATA_DIR}/include"
    INTERFACE_INCLUDE_DIRECTORIES_INSTALL "include"
  )
  directory(FIND_LIB lib_file_path
    FIND_IMPLIB implib_file_path
    NAME "${base_lib_name}"
    ${lib_build_type}
    RELATIVE off
    ROOT_DIR "${TESTS_DATA_DIR}/bin"
  )
  if("${implib_file_path}" MATCHES "-NOTFOUND$")
    set(implib_file_path "")
  endif()

  cmake_path(GET lib_file_path FILENAME lib_file_name)
  set_target_properties("${imp_lib_name}" PROPERTIES
    IMPORTED_LOCATION_${cmake_build_type_upper} "${lib_file_path}"
    IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} "${lib_file_path}"
    IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} "lib/${lib_file_name}"
    IMPORTED_IMPLIB_${cmake_build_type_upper} "${implib_file_path}"
    IMPORTED_SONAME_${cmake_build_type_upper} "${lib_file_name}"
  )
  set_property(TARGET "${imp_lib_name}"
    APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
  )
endfunction()