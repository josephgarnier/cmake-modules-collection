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
# Test of [Map module::GET operation]:
#    map(GET <map-var> <key> <output-var>)
ct_add_test(NAME "test_map_get_operation")
function(${CMAKETEST_TEST})
	include(Map)

	# Set global test variables
	set(input_map
		"entry 1:apple"
		"entry 2:banana"
		"entry 3:orange"
		"entry 4:pineapple"
		"entry 5:carrot"
		"entry 6:strawberry"
		"entry 7:pineapple"
		"entry 8:grape"
		"entry 9:"
		"invalid"
		":invalid"
		"entry 10:lemon:watermelon"
	)

	# Functionalities checking
	ct_add_section(NAME "get_from_existing_key")
	function(${CMAKETEST_SECTION})
		# Get full value
		map(GET input_map "entry 6" value)
		ct_assert_string(value)
		ct_assert_equal(value "strawberry")
		
		map(GET input_map "entry 10" value)
		ct_assert_string(value)
		ct_assert_equal(value "lemon:watermelon")
		
		# Get empty value
		map(GET input_map "entry 9" value)
		ct_assert_equal(value "")
	endfunction()

	ct_add_section(NAME "get_from_inexisting_key")
	function(${CMAKETEST_SECTION})
		map(GET input_map "entry 11" value)
		ct_assert_string(value)
		ct_assert_equal(value "value-NOTFOUND")
		ct_assert_false(value) # equals to "value-NOTFOUND"
	endfunction()

	ct_add_section(NAME "get_from_invalide_key")
	function(${CMAKETEST_SECTION})
		map(GET input_map "invalid" value)
		ct_assert_string(value)
		ct_assert_equal(value "value-NOTFOUND")
		ct_assert_false(value) # equals to "value-NOTFOUND"
	endfunction()

	ct_add_section(NAME "get_from_empty_map")
	function(${CMAKETEST_SECTION})
		set(input_map "")
		map(GET input_map "entry 6" value)
		ct_assert_string(value)
		ct_assert_equal(value "value-NOTFOUND")
		ct_assert_false(value) # equals to "value-NOTFOUND"
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET)
	endfunction()

	ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map "entry 6" value "too" "many" "args")
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET "entry 6" value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET "" "entry 6" value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET "input_map" "entry 6" value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input_map)
		map(GET input_map "entry 6" value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_key_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_key_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map "" value)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map "entry 6")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map "entry 6" "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(GET input_map "entry 6" "value")
	endfunction()
endfunction()
