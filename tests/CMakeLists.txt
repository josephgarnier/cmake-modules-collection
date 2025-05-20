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
	set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
	
	# Download CMakeTest and bring it into scope
	message(STATUS "Downloading CMakeTest in the build-tree...")
	include(FetchContent)
	set(FETCHCONTENT_QUIET off)
	FetchContent_Declare(
		cmake_test
		GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
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
include(cmake_test/cmake_test)

####################### Call tests ############################################
message(CHECK_START "Building tests")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

ct_set_print_length("${CT_DEFAULT_PRINT_LENGTH}")
ct_add_dir("./" CT_DEBUG_MODE_ON)

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")