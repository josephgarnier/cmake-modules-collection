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
function(add_mock_lib lib_target_name)
  cmake_parse_arguments(PARSE_ARGV 1 arg
    "SKIP_IF_EXISTS;STATIC;SHARED" "" ""
  )
  if(TARGET "${PROJECT_NAME}_${lib_target_name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  set(lib_target_fullname "${PROJECT_NAME}_${lib_target_name}")
  set(lib_target_aliasname "${PROJECT_NAME}::${lib_target_name}")
  if(${arg_STATIC})
    add_library("${lib_target_fullname}" STATIC)
  elseif(${arg_SHARED})
    add_library("${lib_target_fullname}" SHARED)
  endif()
  add_library("${lib_target_aliasname}" ALIAS "${lib_target_fullname}")
  # A target needs at least one source to avoid an error
  target_sources("${lib_target_fullname}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")
endfunction()

#------------------------------------------------------------------------------
# Create an imported mock library target for tests in simulating a call to
# `dependency(IMPORT)`
function(import_mock_lib lib_target_name lib_file_basename)
  cmake_parse_arguments(PARSE_ARGV 2 arg
    "SKIP_IF_EXISTS;STATIC;SHARED" "" ""
  )
  if(TARGET "${PROJECT_NAME}_${lib_target_name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  set(lib_target_fullname "${PROJECT_NAME}_${lib_target_name}")
  set(lib_target_aliasname "${PROJECT_NAME}::${lib_target_name}")
  if(${arg_STATIC})
    set(lib_type "STATIC")
  elseif(${arg_SHARED})
    set(lib_type "SHARED")
  endif()

  string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type)
  directory(FIND_LIB ${lib_target_fullname}_LIBRARY_${build_type}
    FIND_IMPLIB ${lib_target_fullname}_IMP_LIBRARY_${build_type}
    NAME "${lib_file_basename}"
    ${lib_type}
    RELATIVE false
    ROOT_DIR "${TESTS_DATA_DIR}/bin"
  )
  if("${${lib_target_fullname}_IMP_LIBRARY_${build_type}}" MATCHES "-NOTFOUND$")
    set(${lib_target_fullname}_IMP_LIBRARY_${build_type} "")
  endif()

  if((NOT "${${lib_target_fullname}_LIBRARY_${build_type}}" MATCHES "-NOTFOUND$")
      AND (NOT "${${lib_target_fullname}_IMP_LIBRARY_${build_type}}" MATCHES "-NOTFOUND$"))
    set(${lib_target_fullname}_FOUND_${build_type} true)
  endif()

  get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(${lib_target_fullname}_FOUND_RELEASE AND ${lib_target_fullname}_FOUND_DEBUG
      AND (NOT "${${lib_target_fullname}_LIBRARY_RELEASE}" STREQUAL "${${lib_target_fullname}_LIBRARY_DEBUG}")
      AND (is_multi_config OR CMAKE_BUILD_TYPE))
    set(${lib_target_fullname}_LIBRARY "")
    list(APPEND ${lib_target_fullname}_LIBRARY optimized "${${lib_target_fullname}_LIBRARY_RELEASE}")
    list(APPEND ${lib_target_fullname}_LIBRARY debug "${${lib_target_fullname}_LIBRARY_DEBUG}")
  elseif(${lib_target_fullname}_FOUND_RELEASE)
    set(${lib_target_fullname}_LIBRARY "${${lib_target_fullname}_LIBRARY_RELEASE}")
  elseif(${lib_target_fullname}_FOUND_DEBUG)
    set(${lib_target_fullname}_LIBRARY "${${lib_target_fullname}_LIBRARY_DEBUG}")
  else()
    set(${lib_target_fullname}_LIBRARY "${lib_target_fullname}_LIBRARY-NOTFOUND")
  endif()

  set(${lib_target_fullname}_ROOT_DIR "${TESTS_DATA_DIR}/bin")
  set(${lib_target_fullname}_LIBRARIES "${${lib_target_fullname}_LIBRARY}")
  if((DEFINED ${lib_target_fullname}_FOUND_RELEASE AND NOT ${${lib_target_fullname}_FOUND_RELEASE})
      OR (DEFINED ${lib_target_fullname}_FOUND_DEBUG AND NOT ${${lib_target_fullname}_FOUND_DEBUG}))
    set(${lib_target_fullname}_FOUND false)
  else()
    set(${lib_target_fullname}_FOUND true)
  endif()

  if(NOT ${lib_target_fullname}_FOUND)
    message(FATAL_ERROR "Error when importing mock library '${lib_target_fullname}'!")
  endif()

  add_library("${lib_target_fullname}" ${lib_type} IMPORTED)
  add_library("${lib_target_aliasname}" ALIAS "${lib_target_fullname}")
  set_target_properties("${lib_target_fullname}" PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ""
    INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
    INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
  )

  cmake_path(GET ${lib_target_fullname}_LIBRARY_${build_type} FILENAME lib_file_name)
  set_target_properties("${lib_target_fullname}" PROPERTIES
    IMPORTED_LOCATION_${build_type} "${lib_target_fullname}_LIBRARY_${build_type}"
    IMPORTED_LOCATION_BUILD_${build_type} ""
    IMPORTED_LOCATION_INSTALL_${build_type} ""
    IMPORTED_IMPLIB_${build_type} "${${lib_target_fullname}_IMP_LIBRARY_${build_type}}"
    IMPORTED_SONAME_${build_type} "${lib_file_name}"
  )
  set_property(TARGET "${lib_target_fullname}"
    APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
  )

  return(PROPAGATE
    "${lib_target_fullname}_LIBRARY_RELEASE"
    "${lib_target_fullname}_LIBRARY_DEBUG"
    "${lib_target_fullname}_IMP_LIBRARY_RELEASE"
    "${lib_target_fullname}_IMP_LIBRARY_DEBUG"
    "${lib_target_fullname}_LIBRARY"
    "${lib_target_fullname}_LIBRARIES"
    "${lib_target_fullname}_ROOT_DIR"
    "${lib_target_fullname}_FOUND"
    "${lib_target_fullname}_FOUND_RELEASE"
    "${lib_target_fullname}_FOUND_DEBUG"
  )
endfunction()

#------------------------------------------------------------------------------
# Create an imported mock library target for tests in simulating a call to
# `dependency(IMPORT)`, `dependency(ADD_INCLUDE_DIRECTORIES)`, and
# `dependency(IMPORTED_LOCATION)`
function(import_full_mock_lib lib_target_name lib_file_basename)
  cmake_parse_arguments(PARSE_ARGV 2 arg
    "SKIP_IF_EXISTS;STATIC;SHARED" "" ""
  )
  if(TARGET "${PROJECT_NAME}_${lib_target_name}" AND ${arg_SKIP_IF_EXISTS})
    return()
  endif()

  import_mock_lib("${lib_target_name}" "${lib_file_basename}" ${ARGN})
  set(lib_target_fullname "${PROJECT_NAME}_${lib_target_name}")
  set(lib_target_aliasname "${PROJECT_NAME}::${lib_target_name}")
  string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type)
  set_target_properties("${lib_target_fullname}" PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${TESTS_DATA_DIR}/include"
    INTERFACE_INCLUDE_DIRECTORIES_BUILD "${TESTS_DATA_DIR}/include"
    INTERFACE_INCLUDE_DIRECTORIES_INSTALL "include"
  )

  cmake_path(GET ${lib_target_fullname}_LIBRARY_${build_type} FILENAME lib_file_name)
  set_target_properties("${lib_target_fullname}" PROPERTIES
    IMPORTED_LOCATION_${build_type} "${lib_target_fullname}_LIBRARY_${build_type}"
    IMPORTED_LOCATION_BUILD_${build_type} "${lib_target_fullname}_LIBRARY_${build_type}"
    IMPORTED_LOCATION_INSTALL_${build_type} "lib/${lib_file_name}"
    IMPORTED_IMPLIB_${build_type} "${${lib_target_fullname}_IMP_LIBRARY_${build_type}}"
    IMPORTED_SONAME_${build_type} "${lib_file_name}"
  )
  set_property(TARGET "${lib_target_fullname}"
    APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
  )

  set(${lib_target_fullname}_INCLUDE_DIR "${TESTS_DATA_DIR}/include")
  set(${lib_target_fullname}_INCLUDE_DIRS "${TESTS_DATA_DIR}/include")

  return(PROPAGATE
    "${lib_target_fullname}_LIBRARY_RELEASE"
    "${lib_target_fullname}_LIBRARY_DEBUG"
    "${lib_target_fullname}_IMP_LIBRARY_RELEASE"
    "${lib_target_fullname}_IMP_LIBRARY_DEBUG"
    "${lib_target_fullname}_LIBRARY"
    "${lib_target_fullname}_LIBRARIES"
    "${lib_target_fullname}_ROOT_DIR"
    "${lib_target_fullname}_FOUND"
    "${lib_target_fullname}_FOUND_RELEASE"
    "${lib_target_fullname}_FOUND_DEBUG"
    "${lib_target_fullname}_INCLUDE_DIR"
    "${lib_target_fullname}_INCLUDE_DIRS"
  )
endfunction()