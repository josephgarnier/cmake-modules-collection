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

####################### Init level variables ##################################
set(TESTS_DATA_DIR "${CMAKE_CURRENT_SOURCE_DIR}/data")

####################### Import CMakeTest ######################################

# Set CMakeTest options
set(CMAKETEST_USE_COLORS on)
set(CT_DEFAULT_PRINT_LENGTH 80 CACHE STRING "The default print length for pass/fail lines. Can be overriden by individual tests.")

# Search for CMakeTest
message(CHECK_START "Importing CMakeTest")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

include(cmake_test/cmake_test OPTIONAL RESULT_VARIABLE cmake_test_found)
if(cmake_test_found)
	message(STATUS "CMakeTest found....... YES")
else()
	message(STATUS "CMakeTest found....... NO")
	
	# Store whether we are building tests or not, then turn off the tests
	set(build_testing_old "${BUILD_TESTING}")
	set(BUILD_TESTING off CACHE BOOL "" FORCE)
	
	# Download CMakeTest and bring it into scope
	message(STATUS "Downloading CMakeTest in the build-tree...")
	include(FetchContent)
	set(FETCHCONTENT_QUIET off)
	FetchContent_Declare(
		cmake_test
		GIT_REPOSITORY https://github.com/josephgarnier/CMakeTest.git
		GIT_SHALLOW on
		GIT_PROGRESS on
		EXCLUDE_FROM_ALL
		SYSTEM
		STAMP_DIR "${${PROJECT_NAME}_BUILD_DIR}"
		DOWNLOAD_NO_PROGRESS off
		LOG_DOWNLOAD on
		LOG_UPDATE on
		LOG_PATCH on
		LOG_CONFIGURE on
		LOG_BUILD on
		LOG_INSTALL on
		LOG_TEST on
		LOG_MERGED_STDOUTERR on
		LOG_OUTPUT_ON_FAILURE on
		USES_TERMINAL_DOWNLOAD on
	)
	FetchContent_MakeAvailable(cmake_test)
	
	# Restore the previous value
	set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
	
	if(${cmake_test_POPULATED})
		message(STATUS "CMakeTest downloaded.......... YES")
	else()
		message(STATUS "CMakeTest downloaded.......... NO")
	endif()
endif()

if(NOT ${cmake_test_found} AND NOT ${cmake_test_POPULATED})
	message(STATUS "Please install the CMakeTest CMake module")
	list(POP_BACK CMAKE_MESSAGE_INDENT)
	message(CHECK_FAIL "failed")
	return()
else()
	list(POP_BACK CMAKE_MESSAGE_INDENT)
	message(CHECK_PASS "done")
endif()

# Include CMakeTest
set(CMAKETEST_USE_COLORS on)
set(CMAKEPP_LANG_DEBUG_MODE off)
include(cmake_test/cmake_test)

####################### Prepare test data #####################################
add_subdirectory(data)

####################### Call tests ############################################
message(CHECK_START "Building tests")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

ct_set_print_length("${CT_DEFAULT_PRINT_LENGTH}")
cpp_set_global("CT_DEBUG_MODE" "FALSE")
ct_add_dir("./build_bin_target" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
	"-DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}"
)
ct_add_dir("./dependency" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
)
ct_add_dir("./directory" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
)
ct_add_dir("./file_manip" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
)
ct_add_dir("./print" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
)
ct_add_dir("./string_manip" USE_REL_PATH_NAMES LANGUAGES FORWARD_LANGUAGES CMAKE_OPTIONS
	"-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
	"-DCMAKE_GENERATOR=${CMAKE_GENERATOR}"
	"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
	"-DTESTS_DATA_DIR=${TESTS_DATA_DIR}"
)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")