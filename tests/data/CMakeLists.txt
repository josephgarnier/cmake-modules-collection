# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

cmake_minimum_required(VERSION 4.0.1 FATAL_ERROR)

message(CHECK_START "Creating data for tests")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

####################### Init level variables ##################################
set(BUILD_DIR    "${CMAKE_CURRENT_BINARY_DIR}")
set(BIN_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(SRC_DIR      "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(INCLUDE_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(SOURCE_FILES
  "${SRC_DIR}/main.cpp"
  "${SRC_DIR}/source_1.cpp"
  "${SRC_DIR}/source_2.cpp"
  "${SRC_DIR}/source_3.cpp"
  "${SRC_DIR}/source_4.cpp"
  "${SRC_DIR}/source_5.cpp"
  "${SRC_DIR}/sub_1/source_sub_1.cpp"
  "${SRC_DIR}/sub_2/source_sub_2.cpp")
set(PUBLIC_HEADER_DIR "${INCLUDE_DIR}")
set(PUBLIC_HEADER_FILES
  "${PUBLIC_HEADER_DIR}/include_1.h"
  "${PUBLIC_HEADER_DIR}/include_2.h"
  "${PUBLIC_HEADER_DIR}/include_pch.h")
set(PRIVATE_HEADER_DIR "${SRC_DIR}")
set(PRIVATE_HEADER_FILES
  "${PRIVATE_HEADER_DIR}/source_1.h"	
  "${PRIVATE_HEADER_DIR}/source_2.h"
  "${PRIVATE_HEADER_DIR}/source_3.h"
  "${PRIVATE_HEADER_DIR}/source_4.h"
  "${PRIVATE_HEADER_DIR}/source_5.h"
  "${PRIVATE_HEADER_DIR}/sub_1/source_sub_1.h"
  "${PRIVATE_HEADER_DIR}/sub_2/source_sub_2.h")
set(PRECOMPILE_HEADER_FILE "${PUBLIC_HEADER_DIR}/include_pch.h")

####################### Set up output directories #############################
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY           "${BIN_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG     "${BIN_DIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE   "${BIN_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY           "${BIN_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG     "${BIN_DIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE   "${BIN_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY           "${BIN_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG     "${BIN_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE   "${BIN_DIR}")
file(RELATIVE_PATH relative_bin_dir "${${PROJECT_NAME}_PROJECT_DIR}" "${BIN_DIR}")
message(STATUS "Built files will be located into ${relative_bin_dir}/")

####################### Create a static mock library ##########################
message(CHECK_START "Creating static mock library")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

set(static_mock_lib_name "static_mock_lib")
set(static_mock_lib_fullname "${PROJECT_NAME}_static_mock_lib")
set(static_mock_lib_aliasname "${PROJECT_NAME}::static_mock_lib")
if("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
  set(static_mock_lib_name "static_mock_libd")
  set(static_mock_lib_fullname "${PROJECT_NAME}_static_mock_libd")
  set(static_mock_lib_aliasname "${PROJECT_NAME}::static_mock_libd")
endif()
add_library("${static_mock_lib_fullname}" STATIC)
add_library("${static_mock_lib_aliasname}" ALIAS "${static_mock_lib_fullname}")
message(STATUS "Lib target name set to '${static_mock_lib_name}'")
set_target_properties("${static_mock_lib_fullname}" PROPERTIES
  OUTPUT_NAME "${static_mock_lib_name}"
  EXPORT_NAME "${static_mock_lib_name}"
)
target_compile_features("${static_mock_lib_fullname}"
  PRIVATE
    "cxx_std_${CMAKE_CXX_STANDARD}"
)
target_compile_definitions("${static_mock_lib_fullname}"
  PRIVATE ""
)
target_compile_options("${static_mock_lib_fullname}"
  PRIVATE ""
)
target_link_options("${static_mock_lib_fullname}"
  PRIVATE ""
)
target_sources("${static_mock_lib_fullname}"
  PRIVATE
    "${SOURCE_FILES}"
    "${PUBLIC_HEADER_FILES}"
    "${PRIVATE_HEADER_FILES}"
)
target_precompile_headers("${static_mock_lib_fullname}"
  PRIVATE
    "${PRECOMPILE_HEADER_FILE}"
)
target_include_directories("${static_mock_lib_fullname}"
  PRIVATE
    "${PRIVATE_HEADER_DIR}"
    "${PUBLIC_HEADER_DIR}"
)
# Add bin file to the `clean` target
set_property(DIRECTORY "${${PROJECT_NAME}_PROJECT_DIR}"
  APPEND
  PROPERTY ADDITIONAL_CLEAN_FILES
  "${BIN_DIR}/${static_mock_lib_name}"
)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")

####################### Create a shared mock library ##########################
message(CHECK_START "Creating shared mock library")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

set(shared_mock_lib_name "shared_mock_lib")
set(shared_mock_lib_fullname "${PROJECT_NAME}_shared_mock_lib")
set(shared_mock_lib_aliasname "${PROJECT_NAME}::shared_mock_lib")
if("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
  set(shared_mock_lib_name "shared_mock_libd")
  set(shared_mock_lib_fullname "${PROJECT_NAME}_shared_mock_libd")
  set(shared_mock_lib_aliasname "${PROJECT_NAME}::shared_mock_libd")
endif()
add_library("${shared_mock_lib_fullname}" SHARED)
add_library("${shared_mock_lib_aliasname}" ALIAS "${shared_mock_lib_fullname}")
message(STATUS "Lib target name set to '${shared_mock_lib_name}'")
set_target_properties("${shared_mock_lib_fullname}" PROPERTIES
  OUTPUT_NAME "${shared_mock_lib_name}"
  EXPORT_NAME "${shared_mock_lib_name}"
)
target_compile_features("${shared_mock_lib_fullname}"
  PRIVATE "cxx_std_${CMAKE_CXX_STANDARD}"
)
target_compile_definitions("${shared_mock_lib_fullname}"
  PRIVATE ""
)
target_compile_options("${shared_mock_lib_fullname}"
  PRIVATE ""
)
target_link_options("${shared_mock_lib_fullname}"
  PRIVATE ""
)
target_sources("${shared_mock_lib_fullname}"
  PRIVATE
    "${SOURCE_FILES}"
    "${PUBLIC_HEADER_FILES}"
    "${PRIVATE_HEADER_FILES}"
)
target_precompile_headers("${shared_mock_lib_fullname}"
  PRIVATE
    "${PRECOMPILE_HEADER_FILE}"
)
target_include_directories("${shared_mock_lib_fullname}"
  PRIVATE
    "${PRIVATE_HEADER_DIR}"
    "${PUBLIC_HEADER_DIR}"
)
# Add bin file to the `clean` target
set_property(DIRECTORY "${${PROJECT_NAME}_PROJECT_DIR}"
  APPEND
  PROPERTY ADDITIONAL_CLEAN_FILES
  "${BIN_DIR}/${shared_mock_lib_name}"
)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")