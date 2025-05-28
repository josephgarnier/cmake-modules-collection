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
# Test of [Print module::default operation]:
#    ``print([<mode>] "message with format text" <argument>...)``
ct_add_test(NAME "test_print_formated_message_operation")
function(${CMAKETEST_TEST})
	include(FuncPrint)

	# Functionalities checking
	ct_add_section(NAME "message_without_directive")
	function(${CMAKETEST_SECTION})
		set(input "a text to print")
		print("${input}")
		ct_assert_prints("${input}")
		print(STATUS "${input}")
		ct_assert_prints("${input}") # This function ignores the status mode
		print(STATUS "${input}" "unused argument")
		ct_assert_prints("${input}") # This function ignores the status mode
	endfunction()

	ct_add_section(NAME "message_with_ap_directive")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(input_relative_path "data/main.cpp")
		set(expected_absolute_path "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${input_relative_path}")
		print("Absolute: @ap@" "${input_relative_path}")
		ct_assert_prints("Absolute: ${expected_absolute_path}")
		print(STATUS "Absolute: @ap@" "${input_relative_path}")
		ct_assert_prints("Absolute: ${expected_absolute_path}") # This function ignores the status mode
	endfunction()

	ct_add_section(NAME "message_with_rp_directive")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(expected_relative_path "data/main.cpp")
		set(input_absolute_path "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${expected_relative_path}")
		print("Relative: @rp@" "${input_absolute_path}")
		ct_assert_prints("Relative: ${expected_relative_path}")
		print(STATUS "Relative: @rp@" "${input_absolute_path}")
		ct_assert_prints("Relative: ${expected_relative_path}") # This function ignores the status mode
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_message_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print()
	endfunction()

	ct_add_section(NAME "throws_if_arg_message_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print("")
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print("Absolute: @ap@")
	endfunction()

	ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print("Relative: @rp@")
	endfunction()

	ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print("Absolute: @ap@, Relative: @rp@")
	endfunction()
endfunction()
