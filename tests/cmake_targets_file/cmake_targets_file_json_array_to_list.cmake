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
# Test of [CMakeTargetsFile module::_json_array_to_list internal function]:
#    _json_array_to_list(<output-list-var> <json-array>)
ct_add_test(NAME "test_cmake_targets_file_json_array_to_list_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_json_array [=[
  [
    "apple",
    "banana",
    "orange",
    "pineapple",
    "carrot|",
    "strawberry|",
    "",
    "pineapple",
    "grape",
    ""
  ]
  ]=])

  # Functionalities checking
  ct_add_section(NAME "convert_array_with_various_elements")
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
    )
    string(JSON json_block_type TYPE "${input_json_array}")
    ct_assert_equal(json_block_type "ARRAY")
    _json_array_to_list(output "${input_json_array}")
    ct_assert_list(output)
    ct_assert_equal(output "${expected_output}")
  endfunction()

  ct_add_section(NAME "convert_empty_array")
  function(${CMAKETEST_SECTION})
    _json_array_to_list(output "[]")
    ct_assert_equal(output "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list(output "${input_json_array}" "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list("${input_json_array}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list("" "${input_json_array}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list("output" "${input_json_array}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_array_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list(output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_array_is_not_a_json_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_array_to_list(output "invalid json")
  endfunction()
endfunction()
