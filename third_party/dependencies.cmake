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

  include(cmake_test/cmake_test OPTIONAL RESULT_VARIABLE cmake_test_path)
  if(NOT "${cmake_test_path}" STREQUAL "NOTFOUND")
    set(cmake_test_FOUND 1)
    message(STATUS "CMakeTest found locally")
  else()
    message(STATUS "CMakeTest not found locally, try to download it in the build-tree")

    # Store whether we are building tests or not, then turn off the tests
    set(build_testing_old "${BUILD_TESTING}")
    set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

    # Download CMakeTest and bring it into scope
    include(FetchContent)
    FetchContent_Declare(
      cmake_test
      GIT_REPOSITORY "https://github.com/josephgarnier/CMakeTest.git"
      GIT_SHALLOW ON
      GIT_PROGRESS ON
      LOG_DOWNLOAD ON
      LOG_UPDATE ON
      LOG_PATCH ON
      LOG_CONFIGURE ON
      LOG_BUILD ON
      LOG_INSTALL ON
      LOG_TEST ON
      LOG_MERGED_STDOUTERR ON
      LOG_OUTPUT_ON_FAILURE ON
      USES_TERMINAL_DOWNLOAD ON
      EXCLUDE_FROM_ALL
      SYSTEM
    )
    FetchContent_MakeAvailable(cmake_test)

    # Restore the previous value
    set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

    if(${cmake_test_POPULATED})
      set(cmake_test_FOUND 1)
      message(STATUS "CMakeTest downloaded with success")
    else()
      set(cmake_test_FOUND 0)
      message(STATUS "CMakeTest downloading failed")
    endif()
  endif()

  if(NOT ${cmake_test_FOUND})
    message(STATUS "Please install the CMakeTest CMake module")
    list(POP_BACK CMAKE_MESSAGE_INDENT)
    message(CHECK_FAIL "failed")
  else()
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