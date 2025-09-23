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
# Test of [CMakeTargetsFile module::_validate_json_string internal function]:
#    _validate_json_string(PROP_PATH [<prop-key>...]
#                          PROP_VALUE [<string>]
#                          [MIN_LENGTH <number>]
#                          [MAX_LENGTH <number>]
#                          [PATTERN <regex>])
ct_add_test(NAME "test_cmake_targets_file_validate_json_string_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Functionalities checking
  ct_add_section(NAME "check_value_is_string")
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "" PROP_VALUE "banana")
    _validate_json_string(PROP_PATH "one" PROP_VALUE "banana")
    _validate_json_string(PROP_PATH "one;two" PROP_VALUE "banana")
    _validate_json_string(PROP_PATH "one" "two" PROP_VALUE "banana")
    _validate_json_string(PROP_PATH "one" "two" "three" PROP_VALUE "banana")

    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana")

    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "foo")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "{}")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "[]")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "3")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "3.0")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE ".1")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "null")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "true")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "false")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "1")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "0")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "on")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "off")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "ON")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "OFF")
  endfunction()

  ct_add_section(NAME "check_value_has_min_length")
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "6")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "6" MAX_LENGTH "6")

    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" MAX_LENGTH "10")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" PATTERN "^[a-z]+$")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" MAX_LENGTH "10" PATTERN "^[a-z]+$")

    ct_add_section(NAME "error_if_too_short_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "7")
    endfunction()

    ct_add_section(NAME "error_if_too_short_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "" MIN_LENGTH "1")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_has_max_length")
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "" MAX_LENGTH "1")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "6")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "6" MAX_LENGTH "6")

    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "10")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" MAX_LENGTH "10")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "10" PATTERN "^[a-z]+$")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" MAX_LENGTH "10" PATTERN "^[a-z]+$")

    ct_add_section(NAME "error_if_too_long" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_match_pattern")
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" PATTERN "^[a-z]+$")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" PATTERN "^[a-z]+$")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "10" PATTERN "^[a-z]+$")
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "3" MAX_LENGTH "10" PATTERN "^[a-z]+$")

    ct_add_section(NAME "error_if_does_not_match" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana1" PATTERN "^[a-z]+$")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_unknown_argument" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(FOO)
  endfunction()

  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string()
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_VALUE "banana")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
  _validate_json_string(PROP_PATH PROP_VALUE "banana")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH)
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_float" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "1.1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_zero" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "0")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_length_is_negative" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MIN_LENGTH "-1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH)
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_float" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "1.1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_zero" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "0")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_length_is_negative" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" MAX_LENGTH "-1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_pattern_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" PATTERN)
  endfunction()

  ct_add_section(NAME "throws_if_arg_pattern_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_string(PROP_PATH "one;two;three" PROP_VALUE "banana" PATTERN "")
  endfunction()
endfunction()
