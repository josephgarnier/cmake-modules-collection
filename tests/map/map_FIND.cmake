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
# Test of [Map module::FIND operation]:
#    map(FIND <map-var> <value> <output-list-var>)
ct_add_test(NAME "test_map_find_operation")
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
  ct_add_section(NAME "find_existing_one_occurrence")
  function(${CMAKETEST_SECTION})
    map(FIND input_map "strawberry" map_keys)
    ct_assert_string(map_keys)
    ct_assert_equal(map_keys "entry 6")

    map(FIND input_map "lemon:watermelon" map_keys)
    ct_assert_string(map_keys)
    ct_assert_equal(map_keys "entry 10")
  endfunction()

  ct_add_section(NAME "find_existing_multiple_occurrences")
  function(${CMAKETEST_SECTION})
    map(FIND input_map "pineapple" map_keys)
    ct_assert_list(map_keys)
    ct_assert_equal(map_keys "entry 4;entry 7")
  endfunction()

  ct_add_section(NAME "find_empty_value")
  function(${CMAKETEST_SECTION})
    map(FIND input_map "" map_keys)
    ct_assert_string(map_keys)
    ct_assert_equal(map_keys "entry 9")
  endfunction()

  ct_add_section(NAME "find_inexisting_value")
  function(${CMAKETEST_SECTION})
    map(FIND input_map "cat" map_keys)
    ct_assert_equal(map_keys "")
  endfunction()

  ct_add_section(NAME "find_in_empty_map")
  function(${CMAKETEST_SECTION})
    set(input_map "")
    map(FIND input_map "strawberry" map_keys)
    ct_assert_equal(map_keys "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND)
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND input_map "strawberry" map_keys "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND "strawberry" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND "" "strawberry" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND "input_map" "strawberry" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input_map)
    map(FIND input_map "strawberry" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_value_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND input_map map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND input_map "strawberry")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND input_map "strawberry" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(FIND input_map "strawberry" "map_keys")
  endfunction()
endfunction()
