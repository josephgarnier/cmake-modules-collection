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
# Test of [Map module::REMOVE operation]:
#   map(REMOVE <map-var> <key>)
ct_add_test(NAME "test_map_remove_operation")
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
  ct_add_section(NAME "remove_with_existing_key")
  function(${CMAKETEST_SECTION})
    # Remove full value
    set(copy_of_input_map "${input_map}")
    set(expected_result
      "entry 1:apple"
      "entry 2:banana"
      "entry 3:orange"
      "entry 4:pineapple"
      "entry 5:carrot"
      "entry 7:pineapple"
      "entry 8:grape"
      "entry 9:"
      "invalid"
      ":invalid"
      "entry 10:lemon:watermelon"
    )
    map(REMOVE copy_of_input_map "entry 6")
    ct_assert_list(copy_of_input_map)
    ct_assert_equal(copy_of_input_map "${expected_result}")

    set(copy_of_input_map "${input_map}")
    set(expected_result
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
    )
    map(REMOVE copy_of_input_map "entry 10")
    ct_assert_list(copy_of_input_map)
    ct_assert_equal(copy_of_input_map "${expected_result}")

    # Remove empty value
    set(copy_of_input_map "${input_map}")
    set(expected_result
      "entry 1:apple"
      "entry 2:banana"
      "entry 3:orange"
      "entry 4:pineapple"
      "entry 5:carrot"
      "entry 6:strawberry"
      "entry 7:pineapple"
      "entry 8:grape"
      "invalid"
      ":invalid"
      "entry 10:lemon:watermelon"
    )
    map(REMOVE copy_of_input_map "entry 9")
    ct_assert_list(copy_of_input_map)
    ct_assert_equal(copy_of_input_map "${expected_result}")
  endfunction()

  ct_add_section(NAME "remove_with_nonexistent_key")
  function(${CMAKETEST_SECTION})
    set(copy_of_input_map "${input_map}")
    set(expected_result
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
    map(REMOVE copy_of_input_map "entry 11")
    ct_assert_list(copy_of_input_map)
    ct_assert_equal(copy_of_input_map "${expected_result}")
  endfunction()

  ct_add_section(NAME "remove_with_invalide_key")
  function(${CMAKETEST_SECTION})
    set(copy_of_input_map "${input_map}")
    set(expected_result
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
    map(REMOVE copy_of_input_map "invalid")
    ct_assert_list(copy_of_input_map)
    ct_assert_equal(copy_of_input_map "${expected_result}")
  endfunction()

  ct_add_section(NAME "remove_in_empty_map")
  function(${CMAKETEST_SECTION})
    set(input_map "")
    set(expected_result "")
    map(REMOVE input_map "entry 6")
    ct_assert_equal(input_map "${expected_result}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE)
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE input_map "entry 6" "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE "entry 6")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE "" "entry 6")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE "input_map" "entry 6")
  endfunction()

  ct_add_section(NAME "throws_if_arg_map_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input_map)
    map(REMOVE input_map "entry 6")
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE input_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    map(REMOVE input_map "")
  endfunction()
endfunction()
