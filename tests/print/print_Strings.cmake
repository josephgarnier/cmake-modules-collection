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
# Test of [Print module::LISTS operation]:
#    print([<mode>] STRINGS <string>... [INDENT])
ct_add_test(NAME "test_print_strings_operation")
function(${CMAKETEST_TEST})
	include(FuncPrint)

	# Functionalities checking
	ct_add_section(NAME "print_without_mode")
	function(${CMAKETEST_SECTION})
		set(input "")
		print(STRINGS "${input}")
		ct_assert_prints("")

		set(input
			"apple"
			"banana"
			"orange"
			"carrot"
			"strawberry"
			"pineapple"
			"grape"
			"lemon"
			"watermelon")
		print(STRINGS "${input}")
		ct_assert_prints("apple ; banana ; orange ; carrot ; strawberry ; pineapple ; grape ; lemon ; watermelon")

		print(STRINGS "${input}" INDENT)
		ct_assert_prints("apple ; banana ; orange ; carrot ; strawberry ; pineapple ; grape ; lemon ; watermelon") # This function ignores the indentation
	endfunction()

	ct_add_section(NAME "print_with_status_mode")
	function(${CMAKETEST_SECTION})
		set(input "")
		print(STATUS STRINGS "${input}")
		ct_assert_prints("") # This function ignores the status

		set(input
			"apple"
			"banana"
			"orange"
			"carrot"
			"strawberry"
			"pineapple"
			"grape"
			"lemon"
			"watermelon")
		print(STATUS STRINGS "${input}")
		ct_assert_prints("apple ; banana ; orange ; carrot ; strawberry ; pineapple ; grape ; lemon ; watermelon") # This function ignores the status

		print(STATUS STRINGS "${input}" INDENT)
		ct_assert_prints("apple ; banana ; orange ; carrot ; strawberry ; pineapple ; grape ; lemon ; watermelon") # This function ignores the indentation and the status
	endfunction()

	# Errors checking	
	ct_add_section(NAME "throws_if_arg_string_list_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STRINGS)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_list_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STRINGS INDENT)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_string_list_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STATUS STRINGS)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_list_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STATUS STRINGS INDENT)
	endfunction()
endfunction()
