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
# Test of [CMakeTargetsFile module::_get_json_value internal function]:
#    _get_json_value(<output-var> <json-block> <json-path-list> <json-type> <is-required>)
ct_add_test(NAME "test_cmake_targets_file_get_json_value_internal_function")
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
    "peach"
  ]
  ]=])

  # Functionalities checking
  ct_add_section(NAME "get_from_filled_json")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # Get a JSON array of objects
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[
  {
    "items" : [ "pineapple", "banana" ],
    "name" : "classic"
  },
  {
    "items" : [ "coconut", "papaya" ],
    "name" : "exotic"
  }
]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants" "ARRAY" true)
      ct_assert_equal(output "${expected_output}")

      # Get a JSON array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[ "apple", "banana", "orange", "grape" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "fruit salad;fruits" "ARRAY" true)
      ct_assert_equal(output "${expected_output}")

      # Get a JSON sub-array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[ "pineapple", "banana" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants;0;items" "ARRAY" true)
      ct_assert_equal(output "${expected_output}")

      # Get a string
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants;0;name" "STRING" true)
      ct_assert_equal(output "classic")

      # Get a number
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;info;calories" "NUMBER" true)
      ct_assert_equal(output "300")

      # Get a boolean
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;info;organic" "BOOLEAN" true)
      ct_assert_true(output)
      ct_assert_equal(output "ON")
    endfunction()

    ct_add_section(NAME "get_required_property_with_no_path")
    function(${CMAKETEST_SECTION})
      # Get a JSON array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[
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
  "peach"
]]=]
      )
      string(JSON json_block_type TYPE "${input_json_array}")
      ct_assert_equal(json_block_type "ARRAY")
      _get_json_value(output "${input_json_array}" "" "ARRAY" true)
      ct_assert_equal(output "${expected_output}")

      # Get a string
      _get_json_value(output "\"name\"" "" "STRING" true)
      ct_assert_equal(output "name")

      # Get a number
      _get_json_value(output "300" "" "NUMBER" true)
      ct_assert_equal(output "300")

      # Get a boolean
      _get_json_value(output "true" "" "BOOLEAN" true)
      ct_assert_true(output)
      ct_assert_equal(output "ON")
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_path")
    function(${CMAKETEST_SECTION})
      # Get a JSON array of objects
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[
  {
    "items" : [ "pineapple", "banana" ],
    "name" : "classic"
  },
  {
    "items" : [ "coconut", "papaya" ],
    "name" : "exotic"
  }
]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants" "ARRAY" false)
      ct_assert_equal(output "${expected_output}")

      # Get a JSON array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[ "apple", "banana", "orange", "grape" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "fruit salad;fruits" "ARRAY" false)
      ct_assert_equal(output "${expected_output}")

      # Get a JSON sub-array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[ "pineapple", "banana" ]]=]
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants;0;items" "ARRAY" false)
      ct_assert_equal(output "${expected_output}")

      # Get a string
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;variants;0;name" "STRING" false)
      ct_assert_equal(output "classic")

      # Get a number
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;info;calories" "NUMBER" false)
      ct_assert_equal(output "300")

      # Get a boolean
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;info;organic" "BOOLEAN" false)
      ct_assert_true(output)
      ct_assert_equal(output "ON")

      # Get nonexistent property
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _get_json_value(output "${input_json_object}" "tropical mix;invalid" "STRING" false)
      ct_assert_equal(output "tropical mix-invalid-NOTFOUND")
      ct_assert_false(output) # equals to "tropical mix-invalid-NOTFOUND"
    endfunction()

    ct_add_section(NAME "get_not_required_property_with_no_path")
    function(${CMAKETEST_SECTION})
      # Get a JSON array of values
      # The JSON comparison is space sensitive, so the indentation does not be changed
      set(expected_output
[=[[
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
  "peach"
]]=]
      )
      string(JSON json_block_type TYPE "${input_json_array}")
      ct_assert_equal(json_block_type "ARRAY")
      _get_json_value(output "${input_json_array}" "" "ARRAY" false)
      ct_assert_equal(output "${expected_output}")

      # Get a string
      _get_json_value(output "\"name\"" "" "STRING" false)
      ct_assert_equal(output "name")

      # Get a number
      _get_json_value(output "300" "" "NUMBER" false)
      ct_assert_equal(output "300")

      # Get a boolean
      _get_json_value(output "true" "" "BOOLEAN" false)
      ct_assert_true(output)
      ct_assert_equal(output "ON")
    endfunction()
  endfunction()

  ct_add_section(NAME "get_from_empty_json")
  function(${CMAKETEST_SECTION})
    _get_json_value(output "{}" "" "OBJECT" false)
    ct_assert_equal(output "{}")

    _get_json_value(output "{}" "" "OBJECT" true)
    ct_assert_equal(output "{}")

    _get_json_value(output "[]" "" "ARRAY" false)
    ct_assert_equal(output "[]")

    _get_json_value(output "[]" "" "ARRAY" true)
    ct_assert_equal(output "[]")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" "OBJECT" false "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value("${input_json_object}" "fruit salad" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value("" "${input_json_object}" "fruit salad" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value("output" "${input_json_object}" "fruit salad" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "fruit salad" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "" "fruit salad" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "OBJECT" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "invalid" "STRING" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad:invalid" "STRING" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_type_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_type_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" "" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_type_is_wrong" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" "STRING" false)
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" "OBJECT")
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _get_json_value(output "${input_json_object}" "fruit salad" "OBJECT" "wrong")
  endfunction()
endfunction()
