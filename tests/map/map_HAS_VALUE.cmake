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
# Test of [Map module::HAS_VALUE operation]:
#    map(HAS_VALUE <map-var> <value> <output-var>)
ct_add_test(NAME "test_map_has_value_operation")
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
  ct_add_section(NAME "has_existing_value_in_one_occurrence")
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "strawberry" map_has_value)
    ct_assert_equal(map_has_value "true")
    ct_assert_true(map_has_value)

    map(HAS_VALUE input_map "lemon:watermelon" map_has_value)
    ct_assert_equal(map_has_value "true")
    ct_assert_true(map_has_value)
  endfunction()

  ct_add_section(NAME "has_existing_value_in_multiple_occurrences")
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "pineapple" map_has_value)
    ct_assert_equal(map_has_value "true")
    ct_assert_true(map_has_value)
  endfunction()

  ct_add_section(NAME "has_empty_value")
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "" map_has_value)
    ct_assert_equal(map_has_value "true")
    ct_assert_true(map_has_value)
  endfunction()

  ct_add_section(NAME "has_nonexistent_value")
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "cat" map_has_value)
    ct_assert_equal(map_has_value "false")
    ct_assert_false(map_has_value)
  endfunction()

  ct_add_section(NAME "has_value_in_empty_map")
  function(${CMAKETEST_SECTION})
    set(input_map "")
    map(HAS_VALUE input_map "strawberry" map_has_value)
    ct_assert_equal(map_has_value "false")
    ct_assert_false(map_has_value)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE)
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "strawberry" map_has_value "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE "strawberry" map_has_value)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE "" "strawberry" map_has_value)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE "input_map" "strawberry" map_has_value)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input_map)
    map(HAS_VALUE input_map "strawberry" map_has_value)
  endfunction()

  ct_add_section(NAME "throws_if_arg_value_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map map_has_value)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "strawberry")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "strawberry" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(HAS_VALUE input_map "strawberry" "map_has_value")
  endfunction()
endfunction()
