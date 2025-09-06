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
# Test of [CMakeTargetsFile module::_serialize_list internal function]:
#    _serialize_list(<output-var> <item>...)
ct_add_test(NAME "test_cmake_targets_file_serialize_list_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_list
    "apple"
    "banana"
    "orange"
    "pineapple"
    "carrot|"
    "strawberry|"
    ""
    "pineapple"
    "grape"
    ""
  )
  
  # Functionalities checking
  ct_add_section(NAME "serialize_list_with_various_elements")
  function(${CMAKETEST_SECTION})
    set(expected_output
      "apple|banana|orange|pineapple|carrot\\||strawberry\\|||pineapple|grape|"
    )
    ct_assert_list(input_list)
    _serialize_list(encoded_string "${input_list}")
    ct_assert_not_list(encoded_string)
    ct_assert_equal(encoded_string "${expected_output}")
  endfunction()

  ct_add_section(NAME "serialize_empty_list")
  function(${CMAKETEST_SECTION})
    _serialize_list(encoded_string "")
    ct_assert_equal(encoded_string "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list(encoded_string "${input_list}" "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list("${input_list}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list("" "${input_list}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list("encoded_string" "${input_list}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_items_list_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _serialize_list(encoded_string)
  endfunction()
endfunction()
