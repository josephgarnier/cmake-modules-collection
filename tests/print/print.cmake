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
# Test of [Print module::Public command]
ct_add_test(NAME "test_print")
function(${CMAKETEST_TEST})
	include(Print)

	ct_add_section(NAME "public_command")
	function(${CMAKETEST_SECTION})
	endfunction()
endfunction()
