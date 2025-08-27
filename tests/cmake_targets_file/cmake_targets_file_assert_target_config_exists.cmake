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
# Test of [CMakeTargetsFile module::_assert_target_config_exists internal function]:
#   _assert_target_config_exists(<target-dir-path>)
ct_add_test(NAME "test_cmake_targets_file_assert_target_config_exists_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `_assert_target_config_exists()`
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "global_property_is_not_set")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" SET)
    ct_assert_false(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad")
    ct_assert_equal(output_property "")
    ct_assert_not_defined(output_property)

    ct_add_section(NAME "global_property_is_not_set_inner" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _assert_target_config_exists("fruit salad")
    endfunction()
  endfunction()

  ct_add_section(NAME "global_property_is_empty")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" SET)
    ct_assert_true(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad")
    ct_assert_equal(output_property "")
    ct_assert_defined(output_property)
    _assert_target_config_exists("fruit salad")
  endfunction()

  ct_add_section(NAME "global_property_is_filled")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    _assert_target_config_exists("fruit salad")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    _assert_target_config_exists()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    _assert_target_config_exists("fruit salad" "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    _assert_target_config_exists()
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    _assert_target_config_exists("")
  endfunction()
endfunction()
