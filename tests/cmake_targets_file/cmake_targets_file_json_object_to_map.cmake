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
# Test of [CMakeTargetsFile module::_json_object_to_map internal function]:
#   _json_object_to_map(<output-map-var> <json-object>)
ct_add_test(NAME "test_cmake_targets_file_json_object_to_map_internal_function")
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
  ct_add_section(NAME "convert_object_with_various_elements")
  function(${CMAKETEST_SECTION})
    # The JSON comparison is space sensitive, so the indentation does not be changed
    set(expected_output
[=[fruit salad:{
  "fruits" : [ "apple", "banana", "orange", "grape" ],
  "info" : 
  {
    "calories" : 250,
    "organic" : true
  },
  "vegetables" : [ "carrot", "cucumber" ]
}]=]
[=[smoothie:{
  "fruits" : [ "strawberry", "pineapple", "mango" ],
  "info" : 
  {
    "calories" : 180,
    "organic" : false
  }
}]=]
[=[tropical mix:{
  "fruits" : [ "pineapple", "banana", "coconut", "papaya" ],
  "info" : 
  {
    "calories" : 300,
    "organic" : true
  },
  "variants" : 
  [
    {
      "items" : [ "pineapple", "banana" ],
      "name" : "classic"
    },
    {
      "items" : [ "coconut", "papaya" ],
      "name" : "exotic"
    }
  ]
}]=]
    )
    string(JSON json_block_type TYPE "${input_json_object}")
    ct_assert_equal(json_block_type "OBJECT")
    _json_object_to_map(output "${input_json_object}")
    ct_assert_list(output)
    ct_assert_equal(output "${expected_output}")
  endfunction()

  ct_add_section(NAME "convert_empty_object")
  function(${CMAKETEST_SECTION})
    _json_object_to_map(output "{}")
    ct_assert_equal(output "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map(output "${input_json_object}" "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map("${input_json_object}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map("" "${input_json_object}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map("output" "${input_json_object}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_object_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map(output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_object_is_not_a_json_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _json_object_to_map(output "invalid json")
  endfunction()
endfunction()
