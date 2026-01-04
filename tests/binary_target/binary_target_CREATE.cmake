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
# Test of [BinaryTarget module::CREATE operation]:
#    binary_target(CREATE <target-name> <STATIC|SHARED|HEADER|EXEC>)
ct_add_test(NAME "test_binary_target_create_operation")
function(${CMAKETEST_TEST})
  include(BinaryTarget)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Functionalities checking
  ct_add_section(NAME "create_static_lib")
  function(${CMAKETEST_SECTION})
    set(bin_target_name "new_static_mock_lib_1")
    set(bin_target_fullname "${PROJECT_NAME}_${bin_target_name}")
    set(bin_target_aliasname "${PROJECT_NAME}::${bin_target_name}")
    ct_assert_target_does_not_exist("${bin_target_fullname}")
    ct_assert_target_does_not_exist("${bin_target_aliasname}")
    binary_target(CREATE "${bin_target_name}" STATIC)
    target_sources("${bin_target_fullname}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
    ct_assert_target_exists("${bin_target_fullname}")
    ct_assert_target_exists("${bin_target_aliasname}")
    get_target_property(output_bin_property "${bin_target_fullname}" TYPE)
    ct_assert_equal(output_bin_property "STATIC_LIBRARY")
    get_target_property(output_bin_property "${bin_target_fullname}" NAME)
    ct_assert_equal(output_bin_property "${bin_target_fullname}")
    get_target_property(output_bin_property "${bin_target_fullname}" OUTPUT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
    get_target_property(output_bin_property "${bin_target_fullname}" EXPORT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
  endfunction()

  ct_add_section(NAME "create_shared_lib")
  function(${CMAKETEST_SECTION})
    set(bin_target_name "new_shared_mock_lib_1")
    set(bin_target_fullname "${PROJECT_NAME}_${bin_target_name}")
    set(bin_target_aliasname "${PROJECT_NAME}::${bin_target_name}")
    ct_assert_target_does_not_exist("${bin_target_fullname}")
    ct_assert_target_does_not_exist("${bin_target_aliasname}")
    binary_target(CREATE "${bin_target_name}" SHARED)
    target_sources("${bin_target_fullname}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
    ct_assert_target_exists("${bin_target_fullname}")
    ct_assert_target_exists("${bin_target_aliasname}")
    get_target_property(output_bin_property "${bin_target_fullname}" TYPE)
    ct_assert_equal(output_bin_property "SHARED_LIBRARY")
    get_target_property(output_bin_property "${bin_target_fullname}" NAME)
    ct_assert_equal(output_bin_property "${bin_target_fullname}")
    get_target_property(output_bin_property "${bin_target_fullname}" OUTPUT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
    get_target_property(output_bin_property "${bin_target_fullname}" EXPORT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
  endfunction()

  ct_add_section(NAME "create_header_lib")
  function(${CMAKETEST_SECTION})
    set(bin_target_name "new_header_mock_lib_1")
    set(bin_target_fullname "${PROJECT_NAME}_${bin_target_name}")
    set(bin_target_aliasname "${PROJECT_NAME}::${bin_target_name}")
    ct_assert_target_does_not_exist("${bin_target_fullname}")
    ct_assert_target_does_not_exist("${bin_target_aliasname}")
    binary_target(CREATE "${bin_target_name}" HEADER)
    target_sources("${bin_target_fullname}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
    ct_assert_target_exists("${bin_target_fullname}")
    ct_assert_target_exists("${bin_target_aliasname}")
    get_target_property(output_bin_property "${bin_target_fullname}" TYPE)
    ct_assert_equal(output_bin_property "INTERFACE_LIBRARY")
    get_target_property(output_bin_property "${bin_target_fullname}" NAME)
    ct_assert_equal(output_bin_property "${bin_target_fullname}")
    get_target_property(output_bin_property "${bin_target_fullname}" OUTPUT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
    get_target_property(output_bin_property "${bin_target_fullname}" EXPORT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
  endfunction()

  ct_add_section(NAME "create_exec_lib")
  function(${CMAKETEST_SECTION})
    set(bin_target_name "new_exec_mock_lib_1")
    set(bin_target_fullname "${PROJECT_NAME}_${bin_target_name}")
    set(bin_target_aliasname "${PROJECT_NAME}::${bin_target_name}")
    ct_assert_target_does_not_exist("${bin_target_fullname}")
    ct_assert_target_does_not_exist("${bin_target_aliasname}")
    binary_target(CREATE "${bin_target_name}" EXEC)
    target_sources("${bin_target_fullname}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
    ct_assert_target_exists("${bin_target_fullname}")
    ct_assert_target_exists("${bin_target_aliasname}")
    get_target_property(output_bin_property "${bin_target_fullname}" TYPE)
    ct_assert_equal(output_bin_property "EXECUTABLE")
    get_target_property(output_bin_property "${bin_target_fullname}" NAME)
    ct_assert_equal(output_bin_property "${bin_target_fullname}")
    get_target_property(output_bin_property "${bin_target_fullname}" OUTPUT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
    get_target_property(output_bin_property "${bin_target_fullname}" EXPORT_NAME)
    ct_assert_equal(output_bin_property "${bin_target_name}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE STATIC)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE "" STATIC)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_already_exists" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    add_mock_lib("new_static_mock_lib_2" STATIC)
    binary_target(CREATE "new_static_mock_lib_2" STATIC)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_alias_already_exists" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    add_mock_lib("new_static_mock_lib_3" STATIC)
    add_library("${PROJECT_NAME}::new_static_mock_lib_4" ALIAS "${PROJECT_NAME}_new_static_mock_lib_3")
    binary_target(CREATE "new_static_mock_lib_4" STATIC)
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE "new_static_mock_lib_5")
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_twice" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE "new_static_mock_lib_6" STATIC SHARED)
  endfunction()
endfunction()
