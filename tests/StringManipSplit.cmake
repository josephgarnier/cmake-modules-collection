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
# Test of [StringManip module::SPLIT operation]:
#    ``string_manip(SPLIT <string> <output_list_var>)``
ct_add_test(NAME "test_string_manip_split_operation")
function(${CMAKETEST_TEST})
	include(FuncStringManip)

	# Functionalities checking
	ct_add_section(NAME "no_split_point_detected")
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "mystringtosplit" output)
		ct_assert_string(output)
		ct_assert_equal(output "mystringtosplit")

		string_manip(SPLIT "my1string2to3split" output)
		ct_assert_string(output)
		ct_assert_equal(output "my1string2to3split")
	endfunction()
	
	ct_add_section(NAME "split_on_uppercase")
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "myStringToSplit" output)
		ct_assert_list(output)
		ct_assert_equal(output "my;String;To;Split")
	endfunction()

	ct_add_section(NAME "split_on_non_alphanumeric")
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "my-string/to*split" output)
		ct_assert_list(output)
		ct_assert_equal(output "my;string;to;split")
	endfunction()

	ct_add_section(NAME "split_on_multiple_criteria")
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "myString_to*Split" output)
		ct_assert_list(output)
		ct_assert_equal(output "my;String;to;Split")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_string_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "" output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "mystringtosplit")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "mystringtosplit" "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(SPLIT "mystringtosplit" "output")
	endfunction()
endfunction()
