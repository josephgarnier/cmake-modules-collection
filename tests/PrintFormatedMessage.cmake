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
		set(input "")
		print("")
		ct_assert_prints("")
		
		set(input "a text to print")
		print("${input}")
		ct_assert_prints("${input}")

		print(STATUS "${input}")
		ct_assert_prints("${input}") # This function ignores the status mode

		print(STATUS "${input}" "unused argument")
		ct_assert_prints("${input}") # This function ignores the status mode

		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(input "data/src/main.cpp")
		print("" "${input}")
		ct_assert_prints("")
	endfunction()

	ct_add_section(NAME "message_with_ap_directive")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(input "data/src/main.cpp")
		set(expected_result "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${input}")
		print("Absolute: @ap@" "${input}")
		ct_assert_prints("Absolute: ${expected_result}")

		print(STATUS "Absolute: @ap@" "${input}")
		ct_assert_prints("Absolute: ${expected_result}") # This function ignores the status mode
	endfunction()

	ct_add_section(NAME "message_with_rp_directive")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(expected_result "data/src/main.cpp")
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/${expected_result}")
		print("Relative: @rp@" "${input}")
		ct_assert_prints("Relative: ${expected_result}")

		print(STATUS "Relative: @rp@" "${input}")
		ct_assert_prints("Relative: ${expected_result}") # This function ignores the status mode
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
