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
# Test of [CMakeTargetsFile module::_validate_json_number internal function]:
#    _validate_json_number(PROP_PATH [<prop-key>...]
#                          PROP_VALUE <number>
#                          [MULTIPLE_OF <number>]
#                          [MIN <number>]
#                          [EXCLU_MIN <number>]
#                          [MAX <number>]
#                          [EXCLU_MAX <number>])
ct_add_test(NAME "test_cmake_targets_file_validate_json_number_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Functionalities checking
  ct_add_section(NAME "check_value_is_number")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "" PROP_VALUE "1")
    _validate_json_number(PROP_PATH "one" PROP_VALUE "1")
    _validate_json_number(PROP_PATH "one;two" PROP_VALUE "1")
    _validate_json_number(PROP_PATH "one" "two" PROP_VALUE "1")
    _validate_json_number(PROP_PATH "one" "two" "three" PROP_VALUE "1")

    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1.0")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1.1")

    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "+1")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "+1.0")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "+1.1")

    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "0")

    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-1")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-1.0")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-1.1")

    ct_add_section(NAME "error_if_string" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "foo")
    endfunction()

    ct_add_section(NAME "error_if_object" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "{}")
    endfunction()

    ct_add_section(NAME "error_if_array" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "[]")
    endfunction()

    ct_add_section(NAME "error_if_boolean_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "on")
    endfunction()

    ct_add_section(NAME "error_if_boolean_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "off")
    endfunction()

    ct_add_section(NAME "error_if_null" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "null")
    endfunction()

    ct_add_section(NAME "error_if_malformed" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE ".1")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_is_multiple_of")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MULTIPLE_OF "2")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MULTIPLE_OF "+2")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "+10" MULTIPLE_OF "2")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" MULTIPLE_OF "2")

    ct_add_section(NAME "error_if_not_multiple_of_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MULTIPLE_OF "3")
    endfunction()

    ct_add_section(NAME "error_if_not_multiple_of_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" MULTIPLE_OF "3")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_min_positive")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "+3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3" MIN "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" MIN "3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.5" MIN "3.5")

    ct_add_section(NAME "error_if_less_than_min_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" MIN "3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" MIN "3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.4" MIN "3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" MIN "3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_min_negative")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3" MIN "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" MIN "-3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.5" MIN "-3.5")

    ct_add_section(NAME "error_if_less_than_min_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-4" MIN "-3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" MIN "-3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.6" MIN "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" MIN "-3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_exclu_min_positive")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "+3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" EXCLU_MIN "3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.6" EXCLU_MIN "3.5")

    ct_add_section(NAME "error_if_equal_to_min_integer" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3" EXCLU_MIN "3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" EXCLU_MIN "3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" EXCLU_MIN "3")
    endfunction()

    ct_add_section(NAME "error_if_equal_to_min_float" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.5" EXCLU_MIN "3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.4" EXCLU_MIN "3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" EXCLU_MIN "3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_exclu_min_negative")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" EXCLU_MIN "-3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.4" EXCLU_MIN "-3.5")

    ct_add_section(NAME "error_if_equal_to_min_integer" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3" EXCLU_MIN "-3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-4" EXCLU_MIN "-3")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" EXCLU_MIN "-3")
    endfunction()

    ct_add_section(NAME "error_if_equal_to_min_float" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.5" EXCLU_MIN "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.6" EXCLU_MIN "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_less_than_min_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" EXCLU_MIN "-3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_max_positive")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" MAX "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" MAX "+3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3" MAX "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2.0" MAX "3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.5" MAX "3.5")

    ct_add_section(NAME "error_if_greater_than_max_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "4" MAX "3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.6" MAX "3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" MAX "3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_max_negative")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" MAX "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3" MAX "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" MAX "-3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.5" MAX "-3.5")

    ct_add_section(NAME "error_if_greater_than_max_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-2" MAX "-3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "-3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.4" MAX "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" MAX "-3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_exclu_max_positive")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" EXCLU_MAX "3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2" EXCLU_MAX "+3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "2.0" EXCLU_MAX "3.5")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.4" EXCLU_MAX "3.5")

    ct_add_section(NAME "error_if_equal_to_max_integer" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3" EXCLU_MAX "3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "4" EXCLU_MAX "3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "3")
    endfunction()

    ct_add_section(NAME "error_if_equal_to_max_float" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.5" EXCLU_MAX "3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "3.6" EXCLU_MAX "3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" EXCLU_MAX "3.5")
    endfunction()
  endfunction()

  ct_add_section(NAME "check_value_in_range_exclu_max_negative")
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10" EXCLU_MAX "-3")
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-10.0" EXCLU_MAX "-3.5")

    ct_add_section(NAME "error_if_equal_to_max_integer" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3" EXCLU_MAX "-3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-2" EXCLU_MAX "-3")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_integer_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "-3")
    endfunction()

    ct_add_section(NAME "error_if_equal_to_max_float" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.5" EXCLU_MAX "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "-3.4" EXCLU_MAX "-3.5")
    endfunction()

    ct_add_section(NAME "error_if_greater_than_max_float_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10.0" EXCLU_MAX "-3.5")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_unrecognized_argument" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(FOO)
  endfunction()

  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number()
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_VALUE "1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
  _validate_json_number(PROP_PATH PROP_VALUE "1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF)
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_float" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "1.1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_zero" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "0")
  endfunction()

  ct_add_section(NAME "throws_if_arg_multiple_of_is_negative" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "1" MULTIPLE_OF "-1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN)
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_min_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MIN ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN)
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_min_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MIN ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX)
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_max_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" MAX ".1")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX)
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_string" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "foo")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_object" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "{}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_array" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "[]")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_boolean_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "on")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_boolean_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "off")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_null" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX "null")
  endfunction()

  ct_add_section(NAME "throws_if_arg_exclu_max_is_malformed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_number(PROP_PATH "one;two;three" PROP_VALUE "10" EXCLU_MAX ".1")
  endfunction()
endfunction()
