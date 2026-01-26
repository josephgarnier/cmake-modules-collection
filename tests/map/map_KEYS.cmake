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
# Test of [Map module::KEYS operation]:
#   map(KEYS <map-var> <output-list-var>)
ct_add_test(NAME "test_map_keys_operation")
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
  ct_add_section(NAME "get_keys_of_map_with_various_keys")
  function(${CMAKETEST_SECTION})
    set(expected_result
      "entry 1"
      "entry 2"
      "entry 3"
      "entry 4"
      "entry 5"
      "entry 6"
      "entry 7"
      "entry 8"
      "entry 9"
      "entry 10"
    )
    map(KEYS input_map map_keys)
    ct_assert_list(map_keys)
    ct_assert_equal(map_keys "${expected_result}")
  endfunction()

  ct_add_section(NAME "get_keys_of_empty_map")
  function(${CMAKETEST_SECTION})
    set(input_map "")
    map(KEYS input_map map_keys)
    ct_assert_equal(map_keys "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS)
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS input_map map_keys "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS "" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS "input_map" map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input_map)
    map(KEYS input_map map_keys)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS input_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS input_map "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(KEYS input_map "map_keys")
  endfunction()
endfunction()
