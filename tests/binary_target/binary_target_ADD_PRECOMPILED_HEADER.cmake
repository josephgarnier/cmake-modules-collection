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
# Test of [BinaryTarget module::ADD_PRECOMPILED_HEADER operation]:
#    binary_target(ADD_PRECOMPILED_HEADER <target-name> HEADER_FILE <file-path>)
ct_add_test(NAME "test_binary_target_add_precompiled_header_operation")
function(${CMAKETEST_TEST})
	include(BinaryTarget)

	# Create a mock bin static target for tests
	macro(_create_mock_bins)
		add_library("new_static_mock_lib" STATIC)
		target_sources("new_static_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

		add_library("new_shared_mock_lib" SHARED)
		target_sources("new_shared_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
	endmacro()
	if(NOT TARGET "new_static_mock_lib" OR NOT TARGET "new_shared_mock_lib")
		_create_mock_bins()
	endif()

	# To call before each test
	macro(_set_up_test)
		# Reset properties set by `binary_target(ADD_PRECOMPILED_HEADER)`
		set_property(TARGET "new_static_mock_lib" PROPERTY PRECOMPILE_HEADERS)
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_PRECOMPILE_HEADERS)

		set_property(TARGET "new_shared_mock_lib" PROPERTY PRECOMPILE_HEADERS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_PRECOMPILE_HEADERS)
	endmacro()

	# Set global test variables
	set(input_pch_header "${TESTS_DATA_DIR}/include/include_pch.h")

	# Functionalities checking
	ct_add_section(NAME "add_pch_header_file")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		binary_target(ADD_PRECOMPILED_HEADER "new_static_mock_lib" HEADER_FILE "${input_pch_header}")
		get_target_property(output_bin_property "new_static_mock_lib"
			PRECOMPILE_HEADERS)
		ct_assert_string(output_bin_property)
		ct_assert_equal(output_bin_property "${input_pch_header}")
		ct_assert_target_does_not_have_property("new_static_mock_lib"
			INTERFACE_PRECOMPILE_HEADERS)

		binary_target(ADD_PRECOMPILED_HEADER "new_shared_mock_lib" HEADER_FILE "${input_pch_header}")
		get_target_property(output_bin_property "new_shared_mock_lib"
			PRECOMPILE_HEADERS)
		ct_assert_string(output_bin_property)
		ct_assert_equal(output_bin_property "${input_pch_header}")
		ct_assert_target_does_not_have_property("new_shared_mock_lib"
			INTERFACE_PRECOMPILE_HEADERS)
	endfunction()

	# # Errors checking
	ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER HEADER_FILE "${input_pch_header}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "" HEADER_FILE "${input_pch_header}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "unknown_target" HEADER_FILE "${input_pch_header}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_header_file_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "new_static_mock_lib")
	endfunction()

	ct_add_section(NAME "throws_if_arg_header_file_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "new_static_mock_lib" HEADER_FILE)
	endfunction()

	ct_add_section(NAME "throws_if_arg_header_file_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "new_static_mock_lib" HEADER_FILE "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_header_file_does_not_exist" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_PRECOMPILED_HEADER "new_static_mock_lib" HEADER_FILE "data/src/not-exists.h")
	endfunction()
endfunction()
