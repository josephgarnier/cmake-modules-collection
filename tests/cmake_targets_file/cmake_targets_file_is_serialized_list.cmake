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
# Test of [CMakeTargetsFile module::_is_serialized_list internal function]:
#    _is_serialized_list(<input-list> <output-var>)
ct_add_test(NAME "test_cmake_targets_file_is_serialized_list_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

    # Functionalities checking
  ct_add_section(NAME "check_in_encoded_string")
  function(${CMAKETEST_SECTION})
    set(input_encoded_string
      "apple|banana|orange|pineapple|carrot\\||strawberry\\|||pineapple|grape|"
    )
    ct_assert_not_list(input_encoded_string)
    _is_serialized_list("${input_encoded_string}" is_serialized)
    ct_assert_equal(is_serialized "true")
    ct_assert_true(is_serialized)

    set(input_encoded_string
      "apple|banana"
    )
    ct_assert_not_list(input_encoded_string)
    _is_serialized_list("${input_encoded_string}" is_serialized)
    ct_assert_equal(is_serialized "true")
    ct_assert_true(is_serialized)

    set(input_encoded_string
      "apple||"
    )
    ct_assert_not_list(input_encoded_string)
    _is_serialized_list("${input_encoded_string}" is_serialized)
    ct_assert_equal(is_serialized "true")
    ct_assert_true(is_serialized)

    set(input_encoded_string
      "apple|"
    )
    ct_assert_not_list(input_encoded_string)
    _is_serialized_list("${input_encoded_string}" is_serialized)
    ct_assert_equal(is_serialized "true")
    ct_assert_true(is_serialized)

    set(input_encoded_string
      "|"
    )
    ct_assert_not_list(input_encoded_string)
    _is_serialized_list("${input_encoded_string}" is_serialized)
    ct_assert_equal(is_serialized "true")
    ct_assert_true(is_serialized)
  endfunction()

  ct_add_section(NAME "check_in_cmake_list")
  function(${CMAKETEST_SECTION})
    set(input_cmake_list
      "apple"
      "banana"
      "orange"
      "pineapple"
      "carrot"
      "strawberry"
      "pineapple"
      "grape"
      "lemon"
      "watermelon"
      "peach"
    )
    ct_assert_list(input_cmake_list)
    _is_serialized_list("${input_cmake_list}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)

    set(input_cmake_list
      "apple"
      "banana"
      "orange"
      "pineapple"
      "carrot\\|"
      "strawberry\\|"
      ""
      "pineapple"
      "grape"
      ""
      "lemon"
      "watermelon"
      "peach"
      ""
    )
    ct_assert_list(input_cmake_list)
    _is_serialized_list("${input_cmake_list}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)

    set(input_cmake_list
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
    ct_assert_list(input_cmake_list)
    _is_serialized_list("${input_cmake_list}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)
  endfunction()

  ct_add_section(NAME "check_in_string")
  function(${CMAKETEST_SECTION})
    set(input_string
      "apple"
    )
    ct_assert_not_list(input_string)
    _is_serialized_list("${input_string}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)

    set(input_string
      "apple banana orange pineapple carrot\\| strawberry\\| pineapple grape "
    )
    ct_assert_not_list(input_string)
    _is_serialized_list("${input_string}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)

    set(input_string
      "apple banana orange pineapple carrot"
    )
    ct_assert_not_list(input_string)
    _is_serialized_list("${input_string}" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)
  endfunction()

  ct_add_section(NAME "check_in_empty_string")
  function(${CMAKETEST_SECTION})
    _is_serialized_list("" is_serialized)
    ct_assert_equal(is_serialized "false")
    ct_assert_false(is_serialized)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list("apple" is_serialized "too" "many" "args")
  endfunction()

    ct_add_section(NAME "throws_if_arg_intput_string_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list(is_serialized)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list("apple")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list("apple" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _is_serialized_list("apple" "is_serialized")
  endfunction()
endfunction()
