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
# Test of [CMakeTargetsFile module::_get_json_object internal function]:
#    _get_json_object(<output-map-var> <json-block> <json-path-list> <is-required>)
ct_add_test(NAME "test_cmake_targets_file_get_json_object_internal_function")
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
  ct_add_section(NAME "get_from_filled_object")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # The JSON comparison is space sensitive, so the indentation does
      # not be changed
      set(expected_output
[=[fruits:[ "apple", "banana", "orange", "grape" ]]=]
[=[info:{
  "calories" : 250,
  "organic" : true
}]=]
[=[vegetables:[ "carrot", "cucumber" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
       _get_json_object(output "${input_json_object}" "fruit salad" true)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        [=[calories:180]=]
        [=[organic:OFF]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_object(output "${input_json_object}" "smoothie;info" true)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        [=[items:[ "pineapple", "banana" ]]=]
        [=[name:classic]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_object(output "${input_json_object}" "tropical mix;variants;0" true)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_required_property_with_no_path")
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
      _get_json_object(output "${input_json_object}" "" true)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # The JSON comparison is space sensitive, so the indentation does
      # not be changed
      set(expected_output
[=[fruits:[ "apple", "banana", "orange", "grape" ]]=]
[=[info:{
  "calories" : 250,
  "organic" : true
}]=]
[=[vegetables:[ "carrot", "cucumber" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
       _get_json_object(output "${input_json_object}" "fruit salad" false)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        [=[calories:180]=]
        [=[organic:OFF]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_object(output "${input_json_object}" "smoothie;info" false)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      set(expected_output
        [=[items:[ "pineapple", "banana" ]]=]
        [=[name:classic]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_object(output "${input_json_object}" "tropical mix;variants;0" false)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")

      # Get nonexistent property
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_object(output "${input_json_object}" "tropical mix;invalid" false)
      ct_assert_equal(output "tropical mix-invalid-NOTFOUND")
      ct_assert_false(output) # equals to "tropical mix-invalid-NOTFOUND"
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_no_path")
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
      _get_json_object(output "${input_json_object}" "" false)
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "get_from_empty_object")
  function(${CMAKETEST_SECTION})
    _get_json_object(output "{}" "" false)
    ct_assert_equal(output "")

    _get_json_object(output "{}" "" true)
    ct_assert_equal(output "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "" false "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object("${input_json_object}" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object("" "${input_json_object}" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object("output" "${input_json_object}" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_json_object_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "invalid json" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_json_object_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "fruit salad;fruits" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "invalid" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "fruit salad;invalid" false)
  endfunction()

    ct_add_section(NAME "throws_if_arg_is_required_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "fruit salad;fruits")
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_object(output "${input_json_object}" "fruit salad;fruits" "wrong")
  endfunction()
endfunction()
