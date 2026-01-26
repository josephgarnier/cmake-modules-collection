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
# Test of [Map module::HAS_KEY operation]:
#   map(HAS_KEY <map-var> <key> <output-var>)
ct_add_test(NAME "test_map_has_key_operation")
function(${CMAKETEST_TEST})
  include(Map)

  # Set global test variables
  set(input_map
    "entry 1:apple"
    "entry 2:banana"
    "entry 3:orange"
    "entry 4:pineapple"
    "entry 5:carrot"
    "entry 6:strawberry"
    "entry 7:pineapple"
    "entry 8:grape"
    "entry 9:"
    "invalid"
    ":invalid"
    "entry 10:lemon:watermelon"
  )

  # Functionalities checking
  ct_add_section(NAME "has_existing_key")
  function(${CMAKETEST_SECTION})
    # Check key with full value
    map(HAS_KEY input_map "entry 6" map_has_key)
    ct_assert_equal(map_has_key "true")
    ct_assert_true(map_has_key)

    map(HAS_KEY input_map "entry 10" map_has_key)
    ct_assert_equal(map_has_key "true")
    ct_assert_true(map_has_key)
    
    # Check key with empty value
    map(HAS_KEY input_map "entry 9" map_has_key)
    ct_assert_equal(map_has_key "true")
    ct_assert_true(map_has_key)
  endfunction()

  ct_add_section(NAME "has_nonexistent_key")
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "entry 11" map_has_key)
    ct_assert_equal(map_has_key "false")
    ct_assert_false(map_has_key)
  endfunction()

  ct_add_section(NAME "has_invalid_key")
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "invalid" map_has_key)
    ct_assert_equal(map_has_key "false")
    ct_assert_false(map_has_key)
  endfunction()

  ct_add_section(NAME "has_key_in_empty_map")
  function(${CMAKETEST_SECTION})
    set(input_map "")
    map(HAS_KEY input_map "entry 6" map_has_key)
    ct_assert_equal(map_has_key "false")
    ct_assert_false(map_has_key)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY)
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "entry 6" map_has_key "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY "entry 6" map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY "" "entry 6" map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY "input_map" "entry 6" map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input_map)
    map(HAS_KEY input_map "entry 6" map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "" map_has_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "entry 6")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "entry 6" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_KEY input_map "entry 6" "map_has_key")
  endfunction()
endfunction()
