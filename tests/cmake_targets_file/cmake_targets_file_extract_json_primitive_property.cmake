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
# Test of [CMakeTargetsFile module::_extract_json_primitive_property internal function]:
#    _extract_json_primitive_property(
#      <in-out-map-var> <map-key>
#      <json-block> <json-path-list> <is-required>)
ct_add_test(NAME "test_cmake_targets_file_extract_json_primitive_property_internal_function")
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
  ct_add_section(NAME "extract_from_filled_json")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_required_property")
    function(${CMAKETEST_SECTION})
      # First insert in map
      set(expected_output
        "fruit salad.info.calories:250"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _extract_json_primitive_property(
        in_out_map "fruit salad.info.calories"
        "${input_json_object}" "fruit salad;info;calories" on
      )
      ct_assert_equal(in_out_map "${expected_output}")
      
      # Second insert in map
      set(expected_output
        "fruit salad.info.calories:250"
        "smoothie.info.calories:180"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _extract_json_primitive_property(
        in_out_map "smoothie.info.calories"
        "${input_json_object}" "smoothie;info;calories" on
      )
      ct_assert_list(in_out_map)
      ct_assert_equal(in_out_map "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_not_required_property")
    function(${CMAKETEST_SECTION})
      # First insert in map from existing property
      set(expected_output
        "fruit salad.info.calories:250"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _extract_json_primitive_property(
        in_out_map "fruit salad.info.calories"
        "${input_json_object}" "fruit salad;info;calories" off
      )
      ct_assert_equal(in_out_map "${expected_output}")
      
      # Second insert in map from inexisting property
      set(expected_output
        "fruit salad.info.calories:250"
      )
      string(JSON json_block_type TYPE "${input_json_object}")
      ct_assert_equal(json_block_type "OBJECT")
      _extract_json_primitive_property(
        in_out_map "smoothie.info.invalid"
        "${input_json_object}" "smoothie;info;invalid" off
      )
      ct_assert_equal(in_out_map "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "extract_from_empty_json")
  function(${CMAKETEST_SECTION})
    # Try to extract with json path
    set(in_out_map
      "fruit salad.info.calories:250"
    )
    set(expected_output
      "${in_out_map}"
    )
    _extract_json_primitive_property(
      in_out_map "smoothie.info.calories"
      "{}" "fruit salad;info;calories" off
    )
    ct_assert_equal(in_out_map "${expected_output}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;info;calories" off
      "too" "many" "args"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_int_out_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_int_out_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      "" "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_int_out_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      "in_out_map" "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_key_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map
      "${input_json_object}" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_key_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map ""
      "${input_json_object}" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_primitive_type_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "invalid json" "fruit salad;info;calories" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_primitive_type_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad"
      "${input_json_object}" "fruit salad" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_block_is_not_a_primitive_type_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "smoothie.info.calories"
      "{}" "" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "${input_json_object}" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "${input_json_object}" "invalid" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_json_path_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;invalid" off
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_is_required_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_json_primitive_property(
      in_out_map "fruit salad.info.calories"
      "${input_json_object}" "fruit salad;info;calories" "wrong"
    )
  endfunction()
endfunction()
