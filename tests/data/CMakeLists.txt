# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

cmake_minimum_required (VERSION 4.0.1 FATAL_ERROR)

message(CHECK_START "Creating data test")
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
set(PRECOMPILED_HEADER_FILE "${PUBLIC_HEADER_DIR}/include_pch.h")

####################### Configure system and architecture info ################
if(NOT CMAKE_SYSTEM_PROCESSOR)
	set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_HOST_SYSTEM_PROCESSOR})
endif()
message(STATUS "Processor architecture is: ${CMAKE_SYSTEM_PROCESSOR}")
set(SYSTEM_NAME "${CMAKE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-${CMAKE_SYSTEM_PROCESSOR}")
string(TOLOWER ${SYSTEM_NAME} SYSTEM_NAME)
message(STATUS "System name set to: ${SYSTEM_NAME}")

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
message(STATUS "Output directory set to: ${relative_bin_dir}/")

####################### Set C++ standard and build type #######################
set(CMAKE_CXX_STANDARD "20")
message(STATUS "C++ standard version set to: C++${CMAKE_CXX_STANDARD}")
set(CMAKE_BUILD_TYPE "RELEASE")
message(STATUS "Build type set to: ${CMAKE_BUILD_TYPE}")

####################### Create a static mock library ##########################
message(CHECK_START "Creating static mock library")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

set(STATIC_MOCK_LIB_TARGET_NAME "static_mock_lib")
if("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
	set(STATIC_MOCK_LIB_TARGET_NAME "static_mock_libd")
endif()
message(STATUS "Lib target name set to: ${STATIC_MOCK_LIB_TARGET_NAME}")
add_library("${STATIC_MOCK_LIB_TARGET_NAME}" STATIC)
target_compile_features("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"cxx_std_${CMAKE_CXX_STANDARD}"
)
target_compile_definitions("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_compile_options("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_link_options("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_sources("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${SOURCE_FILES}"
		"${PUBLIC_HEADER_FILES}"
		"${PRIVATE_HEADER_FILES}"
)
target_precompile_headers("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${PRECOMPILED_HEADER_FILE}"
)
target_include_directories("${STATIC_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${PRIVATE_HEADER_DIR}"
		"${PUBLIC_HEADER_DIR}"
)
# Add bin file to the `clean` target
set_property(DIRECTORY "${${PROJECT_NAME}_PROJECT_DIR}"
	APPEND
	PROPERTY ADDITIONAL_CLEAN_FILES
	"${BIN_DIR}/${STATIC_MOCK_LIB_TARGET_NAME}"
)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")

####################### Create a shared mock library ##########################
message(CHECK_START "Creating shared mock library")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

set(SHARED_MOCK_LIB_TARGET_NAME "shared_mock_lib")
if("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
	set(SHARED_MOCK_LIB_TARGET_NAME "shared_mock_libd")
endif()
add_library("${SHARED_MOCK_LIB_TARGET_NAME}" SHARED)
message(STATUS "Lib target name set to: ${SHARED_MOCK_LIB_TARGET_NAME}")
target_compile_features("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE "cxx_std_${CMAKE_CXX_STANDARD}"
)
target_compile_definitions("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_compile_options("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_link_options("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE ""
)
target_sources("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${SOURCE_FILES}"
		"${PUBLIC_HEADER_FILES}"
		"${PRIVATE_HEADER_FILES}"
)
target_precompile_headers("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${PRECOMPILED_HEADER_FILE}"
)
target_include_directories("${SHARED_MOCK_LIB_TARGET_NAME}"
	PRIVATE
		"${PRIVATE_HEADER_DIR}"
		"${PUBLIC_HEADER_DIR}"
)
# Add bin file to the `clean` target
set_property(DIRECTORY "${${PROJECT_NAME}_PROJECT_DIR}"
	APPEND
	PROPERTY ADDITIONAL_CLEAN_FILES
	"${BIN_DIR}/${SHARED_MOCK_LIB_TARGET_NAME}"
)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")