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
# Test of [CMakeTargetsFile module::_get_json_array internal function]:
#    _get_json_array(<json-block> <json-path-list> <is-required> <output-list-var>)
ct_add_test(NAME "test_cmake_targets_file_get_json_array_internal_function")
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
    "",
    "lemon",
    "watermelon",
    "peach",
    ""
  ]
  ]=])

  # Functionalities checking
  ct_add_section(NAME "get_from_filled_array")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[{
  "items" : [ "pineapple", "banana" ],
  "name" : "classic"
}]=]
[=[{
  "items" : [ "coconut", "papaya" ],
  "name" : "exotic"
}]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "tropical mix;variants" true output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        "apple"
        "banana"
        "orange"
        "grape"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "fruit salad;fruits" true output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        "pineapple"
        "banana"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "tropical mix;variants;0;items" true output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_required_property_with_no_path")
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
      string(JSON json_block_type TYPE "${input_json_array}")
      ct_assert_equal(json_block_type "ARRAY")
      _get_json_array("${input_json_array}" "" true output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[{
  "items" : [ "pineapple", "banana" ],
  "name" : "classic"
}]=]
[=[{
  "items" : [ "coconut", "papaya" ],
  "name" : "exotic"
}]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "tropical mix;variants" false output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        "apple"
        "banana"
        "orange"
        "grape"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "fruit salad;fruits" false output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        "pineapple"
        "banana"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "tropical mix;variants;0;items" false output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      # Get nonexistent property
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_array("${input_json_object}" "tropical mix;invalid" false output)
      ct_assert_equal(output "tropical mix-invalid-NOTFOUND")
      ct_assert_false(output) # equals to "tropical mix-invalid-NOTFOUND"
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_no_path")
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
      string(JSON json_block_type TYPE "${input_json_array}")
      ct_assert_equal(json_block_type "ARRAY")
      _get_json_array("${input_json_array}" "" false output)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "get_from_empty_array")
  function(${CMAKETEST_SECTION})
    _get_json_array("[]" "" false output)
    ct_assert_equal(output "")

    _get_json_array("[]" "" true output)
    ct_assert_equal(output "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "" false output "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("" "" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_json_array_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("invalid json" "" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_json_array_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "fruit salad;info" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "invalid" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "fruit salad;invalid" false output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "fruit salad;fruits" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "fruit salad;fruits" "wrong" output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "" false "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_array("${input_json_object}" "" false "output")
  endfunction()
endfunction()
