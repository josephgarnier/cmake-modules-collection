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
# Test of [CMakeTargetsFile module::Public command]:
ct_add_test(NAME "test_cmake_targets_file")
function(${CMAKETEST_TEST})
	include(CMakeTargetsFile)

	ct_add_section(NAME "public_command")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "throws_if_unknown_argument" EXPECTFAIL)
		function(${CMAKETEST_SECTION})
			cmake_targets_file(FOO)
		endfunction()
		
		ct_add_section(NAME "throws_if_arg_op_is_missing" EXPECTFAIL)
		function(${CMAKETEST_SECTION})
			cmake_targets_file()
		endfunction()
	endfunction()
endfunction()
