# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

#-------------------------------------------------------------------------------
# Test of [Directory module::COLLECT_SOURCES_BY_LOCATION operation]:
#    directory(COLLECT_SOURCES_BY_LOCATION
#              [SRC_DIR <dir-path>
#              SRC_SOURCE_FILES <output-list-var>
#              SRC_HEADER_FILES <output-list-var>]
#              [INCLUDE_DIR <dir-path>
#              INCLUDE_HEADER_FILES <output-list-var>])
ct_add_test(NAME "test_directory_collect_sources_by_location_operation")
function(${CMAKETEST_TEST})
  include(Directory)

  # Set global test variables
  set(expected_src_sources_output
    "${TESTS_DATA_DIR}/src/main.cpp"
    "${TESTS_DATA_DIR}/src/source_1.cpp"
    "${TESTS_DATA_DIR}/src/source_2.cpp"
    "${TESTS_DATA_DIR}/src/source_3.cpp"
    "${TESTS_DATA_DIR}/src/source_4.cpp"
    "${TESTS_DATA_DIR}/src/source_5.cpp"
    "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
    "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
  set(expected_src_headers_output
    "${TESTS_DATA_DIR}/src/source_1.h"
    "${TESTS_DATA_DIR}/src/source_2.h"
    "${TESTS_DATA_DIR}/src/source_3.h"
    "${TESTS_DATA_DIR}/src/source_4.h"
    "${TESTS_DATA_DIR}/src/source_5.h"
    "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.h"
    "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.h")
  set(expected_include_headers_output
    "${TESTS_DATA_DIR}/include/include_1.h"
    "${TESTS_DATA_DIR}/include/include_2.h"
    "${TESTS_DATA_DIR}/include/include_pch.h")

  # Functionalities checking
  ct_add_section(NAME "get_from_all_dir_locations")
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
    ct_assert_list(src_sources)
    ct_assert_equal(src_sources "${expected_src_sources_output}")
    ct_assert_list(src_headers)
    ct_assert_equal(src_headers "${expected_src_headers_output}")
    ct_assert_list(include_headers)
    ct_assert_equal(include_headers "${expected_include_headers_output}")
  endfunction()

  ct_add_section(NAME "get_from_src_dir_only")
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
    )
    ct_assert_list(src_sources)
    ct_assert_equal(src_sources "${expected_src_sources_output}")
    ct_assert_list(src_headers)
    ct_assert_equal(src_headers "${expected_src_headers_output}")

    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_HEADER_FILES include_headers
    )
    ct_assert_list(src_sources)
    ct_assert_equal(src_sources "${expected_src_sources_output}")
    ct_assert_list(src_headers)
    ct_assert_equal(src_headers "${expected_src_headers_output}")
    ct_assert_string(include_headers)
    ct_assert_equal(include_headers "")
  endfunction()

  ct_add_section(NAME "get_from_include_dir_only")
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
    ct_assert_list(include_headers)
    ct_assert_equal(include_headers "${expected_include_headers_output}")

    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
    ct_assert_string(src_sources)
    ct_assert_equal(src_sources "")
    ct_assert_string(src_headers)
    ct_assert_equal(src_headers "")
    ct_assert_list(include_headers)
    ct_assert_equal(include_headers "${expected_include_headers_output}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_src_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR ""
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_dir_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "fake/directory"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_dir_is_not_a_directory" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES ""
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES "src_sources"
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_header_files_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_header_files_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_header_files_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES ""
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_src_header_files_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES "src_headers"
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR ""
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_dir_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "fake/directory"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_dir_is_not_a_directory" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
      INCLUDE_HEADER_FILES include_headers
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_header_files_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_header_files_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_header_files_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES ""
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_header_files_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(COLLECT_SOURCES_BY_LOCATION
      SRC_DIR "${TESTS_DATA_DIR}/src"
      SRC_SOURCE_FILES src_sources
      SRC_HEADER_FILES src_headers
      INCLUDE_DIR "${TESTS_DATA_DIR}/include"
      INCLUDE_HEADER_FILES "include_headers"
    )
  endfunction()
endfunction()
