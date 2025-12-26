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
# Test of [CMakeTargetsFile module::_validate_json_boolean internal function]:
#    _validate_json_boolean(PROP_PATH [<prop-key>...]
#                           PROP_VALUE <string>)
ct_add_test(NAME "test_cmake_targets_file_validate_json_boolean_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Functionalities checking
  ct_add_section(NAME "check_value_is_boolean")
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(PROP_PATH PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "" PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "one" PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "one;two" PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "one" "two" PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "one" "two" "three" PROP_VALUE "ON")

    _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "ON")
    _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "OFF")

    ct_add_section(NAME "error_if_string" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "foo")
    endfunction()

    ct_add_section(NAME "error_if_object" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "{}")
    endfunction()

    ct_add_section(NAME "error_if_array" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "[]")
    endfunction()

    ct_add_section(NAME "error_if_integer" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "3")
    endfunction()

    ct_add_section(NAME "error_if_float" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "3.0")
    endfunction()

    ct_add_section(NAME "error_if_null" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "null")
    endfunction()

    ct_add_section(NAME "error_if_true" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "true")
    endfunction()

    ct_add_section(NAME "error_if_false" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "false")
    endfunction()

    ct_add_section(NAME "error_if_one" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "1")
    endfunction()

    ct_add_section(NAME "error_if_zero" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "0")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_unrecognized_argument" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(FOO)
  endfunction()

  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean()
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_path_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(PROP_VALUE "ON")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(PROP_PATH "one;two;three")
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_prop_value_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _validate_json_boolean(PROP_PATH "one;two;three" PROP_VALUE "")
  endfunction()
endfunction()
