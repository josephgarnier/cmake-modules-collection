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
# Test of [Map module::_validate_map_key internal function]:
#    _validate_map_key(<entry> <output-key-var> <output-is-valid-var>)
ct_add_test(NAME "test_map_validate_map_entry_internal_function")
function(${CMAKETEST_TEST})
  include(Map)

  # Functionalities checking
  ct_add_section(NAME "test_with_valid_key")
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry 1")
    ct_assert_true(entry_is_valid)
    ct_assert_equal(entry_is_valid "true")

    _validate_map_key("entry 9:" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry 9")
    ct_assert_true(entry_is_valid)
    ct_assert_equal(entry_is_valid "true")

    _validate_map_key("entry 10:lemon:watermelon" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry 10")
    ct_assert_true(entry_is_valid)
    ct_assert_equal(entry_is_valid "true")
  endfunction()

  ct_add_section(NAME "test_with_invalid_key")
  function(${CMAKETEST_SECTION})
    _validate_map_key("invalid" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry_key-NOTFOUND")
    ct_assert_false(entry_is_valid)
    ct_assert_equal(entry_is_valid "false")
    ct_assert_prints("Skipping malformed map entry 'invalid' (no colon found)")

    _validate_map_key("" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry_key-NOTFOUND")
    ct_assert_false(entry_is_valid)
    ct_assert_equal(entry_is_valid "false")
    ct_assert_prints("Skipping malformed map entry '' (no colon found)")

    _validate_map_key(":invalid" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry_key-NOTFOUND")
    ct_assert_false(entry_is_valid)
    ct_assert_equal(entry_is_valid "false")
    ct_assert_prints("Skipping malformed map entry ':invalid' (empty key)")

    _validate_map_key(":" entry_key entry_is_valid)
    ct_assert_string(entry_key)
    ct_assert_equal(entry_key "entry_key-NOTFOUND")
    ct_assert_false(entry_is_valid)
    ct_assert_equal(entry_is_valid "false")
    ct_assert_prints("Skipping malformed map entry ':' (empty key)")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_key entry_is_valid "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_key_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_is_valid)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_key_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" "" entry_is_valid)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_key_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" "entry_key" entry_is_valid)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_is_valid_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_key)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_is_valid_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_key "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_is_valid_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_map_key("entry 1:apple" entry_key "entry_is_valid")
  endfunction()
endfunction()
