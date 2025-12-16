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
# Test of [Dependency module::Public command]:
ct_add_test(NAME "test_dependency")
function(${CMAKETEST_TEST})
  include(Dependency)

  ct_add_section(NAME "public_command")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "throws_if_unrecognized_argument" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      dependency(FOO)
    endfunction()
    
    ct_add_section(NAME "throws_if_arg_op_is_missing" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      dependency()
    endfunction()
  endfunction()
endfunction()
