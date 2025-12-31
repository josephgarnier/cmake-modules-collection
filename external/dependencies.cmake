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

####################### Import CMakeTest ######################################
set(cmake_test_FOUND 0)
if (${BUILD_TESTS})
  # Set CMakeTest options
  set(CMAKETEST_USE_COLORS on)
  set(CT_DEFAULT_PRINT_LENGTH 80 CACHE STRING "The default print length for pass/fail lines. Can be overriden by individual tests.")

  # Search for CMakeTest
  message(CHECK_START "Importing CMakeTest")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  include(cmake_test/cmake_test OPTIONAL RESULT_VARIABLE cmake_test_found)
  if(NOT "${cmake_test_found}" STREQUAL "NOTFOUND")
    message(STATUS "CMakeTest found locally")
  else()
    message(STATUS "CMakeTest not found locally, try to download it in the build-tree")

    # Store whether we are building tests or not, then turn off the tests
    set(build_testing_old "${BUILD_TESTING}")
    set(BUILD_TESTING off CACHE BOOL "" FORCE)

    # Download CMakeTest and bring it into scope
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
      message(STATUS "CMakeTest downloaded with success")
    else()
      message(STATUS "CMakeTest downloading failed")
      set(cmake_test_found "NOTFOUND")
    endif()
  endif()

  if("${cmake_test_found}" STREQUAL "NOTFOUND")
    set(cmake_test_FOUND 0)
    message(STATUS "Please install the CMakeTest CMake module")
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(CHECK_FAIL "failed")
  else()
    set(cmake_test_FOUND 1)

    # Include CMakeTest
    set(CMAKETEST_USE_COLORS on)
    set(CMAKEPP_LANG_DEBUG_MODE off)
    include(cmake_test/cmake_test)

    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(CHECK_PASS "done")
  endif()
endif()

####################### Import Sphinx #########################################
set(sphinx_FOUND 0)
if (${BUILD_DOCS})
  message(CHECK_START "Importing Sphinx")
  list(APPEND CMAKE_MESSAGE_INDENT "  ")

  find_package(Sphinx)
  if(Sphinx_FOUND)
    set(sphinx_FOUND 1)
    message(STATUS "Sphinx found locally")
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(CHECK_PASS "done")
  else()
    set(sphinx_FOUND 0)
    message(STATUS "Sphinx not found locally, 'doc' target will not be available")
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(CHECK_FAIL "failed")
  endif()
endif()