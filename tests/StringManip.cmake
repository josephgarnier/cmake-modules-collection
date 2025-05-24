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
# Test of [StringManip module::Public command]
ct_add_test(NAME "test_string_manip")
function(${CMAKETEST_TEST})
	include(FuncStringManip)

	ct_add_section(NAME "public_command")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "throws_if_unknown_argument" EXPECTFAIL)
		function(${CMAKETEST_SECTION})
			string_manip(FOO)
			ct_assert_prints("Unrecognized arguments: \"FOO\"")
		endfunction()
		
		ct_add_section(NAME "throws_if_arg_op_is_missing_1" EXPECTFAIL)
		function(${CMAKETEST_SECTION})
			string_manip()
		endfunction()
		
		ct_add_section(NAME "throws_if_arg_op_is_missing_2" EXPECTFAIL)
		function(${CMAKETEST_SECTION})
			string_manip(BAR)
		endfunction()
	endfunction()
endfunction()
