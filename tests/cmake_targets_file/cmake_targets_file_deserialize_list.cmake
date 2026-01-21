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
# Test of [CMakeTargetsFile module::_deserialize_list internal function]:
#   _deserialize_list(<encoded-string> <output-list-var>)
ct_add_test(NAME "test_cmake_targets_file_deserialize_list_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_encoded_string
    "apple|banana|orange|pineapple|carrot\\||strawberry\\|||pineapple|grape||lemon|watermelon|peach|"
  )

  # Functionalities checking
  ct_add_section(NAME "deserialize_encoded_string_with_various_elements")
  function(${CMAKETEST_SECTION})
    set(expected_output
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
      "lemon"
      "watermelon"
      "peach"
      ""
    )
    ct_assert_string(input_encoded_string)
    _deserialize_list("${input_encoded_string}" deserialized_list)
    ct_assert_list(deserialized_list)
    ct_assert_equal(deserialized_list "${expected_output}")
  endfunction()

  ct_add_section(NAME "serialize_empty_list")
  function(${CMAKETEST_SECTION})
    _deserialize_list("" deserialized_list)
    ct_assert_equal(deserialized_list "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list("${input_encoded_string}" deserialized_list "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_encoded_string_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list(deserialized_list)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list("${input_encoded_string}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list("${input_encoded_string}" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _deserialize_list("${input_encoded_string}" "deserialized_list")
  endfunction()
endfunction()
