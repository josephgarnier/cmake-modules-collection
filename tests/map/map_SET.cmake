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
# Test of [Map module::SET operation]:
#    map(SET <map-var> <key> <value>)
ct_add_test(NAME "test_map_set_operation")
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
	ct_add_section(NAME "set_to_existing_key")
	function(${CMAKETEST_SECTION})
		# Set full value
		set(copy_of_input_map "${input_map}")
		set(expected_result
			"entry 1:apple"
			"entry 2:banana"
			"entry 3:orange"
			"entry 4:pineapple"
			"entry 5:carrot"
			"entry 6:peach"
			"entry 7:pineapple"
			"entry 8:grape"
			"entry 9:"
			"invalid"
			":invalid"
			"entry 10:lemon:watermelon"
		)
		map(SET copy_of_input_map "entry 6" "peach")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
		
		set(copy_of_input_map "${input_map}")
		set(expected_result
			"entry 1:apple"
			"entry 2:banana"
			"entry 3:orange"
			"entry 4:pineapple"
			"entry 5:carrot"
			"entry 6:blueberry:blackberry"
			"entry 7:pineapple"
			"entry 8:grape"
			"entry 9:"
			"invalid"
			":invalid"
			"entry 10:lemon:watermelon"
		)
		map(SET copy_of_input_map "entry 6" "blueberry:blackberry")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")

		# Set empty value
		set(copy_of_input_map "${input_map}")
		set(expected_result
			"entry 1:apple"
			"entry 2:banana"
			"entry 3:orange"
			"entry 4:pineapple"
			"entry 5:carrot"
			"entry 6:"
			"entry 7:pineapple"
			"entry 8:grape"
			"entry 9:"
			"invalid"
			":invalid"
			"entry 10:lemon:watermelon"
		)
		map(SET copy_of_input_map "entry 6" "")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
	endfunction()

	ct_add_section(NAME "set_to_inexisting_key")
	function(${CMAKETEST_SECTION})
		# Set full value
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"entry 11:peach"
		)
		map(SET copy_of_input_map "entry 11" "peach")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
		
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"entry 11:blueberry:blackberry"
		)
		map(SET copy_of_input_map "entry 11" "blueberry:blackberry")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
		
		# Set empty value
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"entry 11:"
		)
		map(SET copy_of_input_map "entry 11" "")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
	endfunction()

	ct_add_section(NAME "set_to_invalide_key")
	function(${CMAKETEST_SECTION})
		# Set full value
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"invalid:peach"
		)
		map(SET copy_of_input_map "invalid" "peach")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
		
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"invalid:blueberry:blackberry"
		)
		map(SET copy_of_input_map "invalid" "blueberry:blackberry")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
		
		# Set empty value
		set(copy_of_input_map "${input_map}")
		set(expected_result
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
			"invalid:"
		)
		map(SET copy_of_input_map "invalid" "")
		ct_assert_list(copy_of_input_map)
		ct_assert_equal(copy_of_input_map "${expected_result}")
	endfunction()

	ct_add_section(NAME "set_in_empty_map")
	function(${CMAKETEST_SECTION})
		# Set full value
		set(input_map "")
		set(expected_result "entry 6:peach")
		map(SET input_map "entry 6" "peach")
		ct_assert_equal(input_map "${expected_result}")
		
		# Set empty value
		set(input_map "")
		set(expected_result "entry 6:")
		map(SET input_map "entry 6" "")
		ct_assert_equal(input_map "${expected_result}")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET)
	endfunction()

	ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET input_map "entry 6" "peach" "too" "many" "args")
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET "entry 6" "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET "" "entry 6" "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET "input_map" "entry 6" "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input_map)
		map(SET input_map "entry 6" "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_key_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET input_map "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_key_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET input_map "" "peach")
	endfunction()

	ct_add_section(NAME "throws_if_arg_value_is_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		map(SET input_map "entry 6")
	endfunction()
endfunction()
