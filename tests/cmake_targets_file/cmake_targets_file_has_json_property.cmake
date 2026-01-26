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
# Test of [CMakeTargetsFile module::_has_json_property internal function]:
#   _has_json_property(<json-block> <json-path-list> <output-var>)
ct_add_test(NAME "test_cmake_targets_file_has_json_property_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_json_object [=[
  {
    "fruit salad": {
      "fruits": ["apple", "banana", "orange", "grape"],
      "vegetables": ["carrot", "cucumber"],
      "info": { "organic": true, "calories": 250 }
    },
    "smoothie": {
      "fruits": ["strawberry", "pineapple", "mango"],
      "info": { "organic": false, "calories": 180}
    },
    "tropical mix": {
      "fruits": ["pineapple", "banana", "coconut", "papaya"],
      "variants": [
        {"name": "classic", "items": ["pineapple", "banana"]},
        {"name": "exotic", "items": ["coconut", "papaya"]}
      ],
      "info": { "organic": true, "calories": 300 }
    }
  }
  ]=])

  # Functionalities checking
  ct_add_section(NAME "check_in_filled_json")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "with_path")
    function(${CMAKETEST_SECTION})
      _has_json_property("${input_json_object}" "fruit salad" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("${input_json_object}" "smoothie;info" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("${input_json_object}" "tropical mix;variants;0" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("${input_json_object}" "tropical mix;invalid" output)
      ct_assert_equal(output "false")
      ct_assert_false(output)
    endfunction()

    ct_add_section(NAME "with_no_path")
    function(${CMAKETEST_SECTION})
      _has_json_property("${input_json_object}" "" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("\"name\"" "" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("300" "" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)

      _has_json_property("true" "" output)
      ct_assert_equal(output "true")
      ct_assert_true(output)
    endfunction()
  endfunction()

  ct_add_section(NAME "check_in_empty_json")
  function(${CMAKETEST_SECTION})
    _has_json_property("{}" "" output)
    ct_assert_equal(output "true")
    ct_assert_true(output)

    _has_json_property("[]" "" output)
    ct_assert_equal(output "true")
    ct_assert_true(output)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "fruit salad" output "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("fruit salad" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("" "fruit salad" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "invalid" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "fruit salad:invalid" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "fruit salad")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "fruit salad" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _has_json_property("${input_json_object}" "fruit salad" "output")
  endfunction()

endfunction()
