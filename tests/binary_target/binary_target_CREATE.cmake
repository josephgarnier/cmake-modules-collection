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

	# Functionalities checking
	ct_add_section(NAME "create_static_lib")
	function(${CMAKETEST_SECTION})
		set(bin_target_name "static_mock_lib")
		ct_assert_target_does_not_exist("${bin_target_name}")
		binary_target(CREATE "${bin_target_name}" STATIC)
		target_sources("${bin_target_name}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		ct_assert_target_exists("${bin_target_name}")
		get_target_property(output_bin_property "${bin_target_name}" TYPE)
		ct_assert_equal(output_bin_property "STATIC_LIBRARY")
	endfunction()

	ct_add_section(NAME "create_shared_lib")
	function(${CMAKETEST_SECTION})
		set(bin_target_name "shared_mock_lib")
		ct_assert_target_does_not_exist("${bin_target_name}")
		binary_target(CREATE "${bin_target_name}" SHARED)
		target_sources("${bin_target_name}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		ct_assert_target_exists("${bin_target_name}")
		get_target_property(output_bin_property "${bin_target_name}" TYPE)
		ct_assert_equal(output_bin_property "SHARED_LIBRARY")
	endfunction()

	ct_add_section(NAME "create_header_lib")
	function(${CMAKETEST_SECTION})
		set(bin_target_name "header_mock_lib")
		ct_assert_target_does_not_exist("${bin_target_name}")
		binary_target(CREATE "${bin_target_name}" HEADER)
		target_sources("${bin_target_name}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		ct_assert_target_exists("${bin_target_name}")
		get_target_property(output_bin_property "${bin_target_name}" TYPE)
		ct_assert_equal(output_bin_property "INTERFACE_LIBRARY")
	endfunction()

	ct_add_section(NAME "create_exec_lib")
	function(${CMAKETEST_SECTION})
		set(bin_target_name "exec_mock_lib")
		ct_assert_target_does_not_exist("${bin_target_name}")
		binary_target(CREATE "${bin_target_name}" EXEC)
		target_sources("${bin_target_name}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		ct_assert_target_exists("${bin_target_name}")
		get_target_property(output_bin_property "${bin_target_name}" TYPE)
		ct_assert_equal(output_bin_property "EXECUTABLE")
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
		binary_target(CREATE "static_mock_lib_2" STATIC)
	endfunction()

	ct_add_section(NAME "throws_if_arg_binary_type_is_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(CREATE "static_mock_lib_3")
	endfunction()

	ct_add_section(NAME "throws_if_arg_binary_type_is_twice" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(CREATE "static_mock_lib_4" STATIC SHARED)
	endfunction()
endfunction()
