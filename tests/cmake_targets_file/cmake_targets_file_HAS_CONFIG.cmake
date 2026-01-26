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
# Test of [CMakeTargetsFile module::HAS_CONFIG operation]:
#   cmake_targets_file(HAS_CONFIG <output-var> DEP <dep-name>|TARGET <target-dir-path>)
ct_add_test(NAME "test_cmake_targets_file_has_config_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(HAS_CONFIG)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "global_property_is_not_set")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" SET)
    ct_assert_false(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad")
    ct_assert_equal(output_property "")
    ct_assert_not_defined(output_property)

    cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
    ct_assert_false(is_target_configured)
  endfunction()

  ct_add_section(NAME "global_property_is_empty")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "")
    cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
    ct_assert_true(is_target_configured)
  endfunction()

  ct_add_section(NAME "global_property_is_filled")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
    ct_assert_true(is_target_configured)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG TARGET "fruit salad")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG "" TARGET "fruit salad")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG "is_target_configured" TARGET "fruit salad")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG is_target_configured)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG is_target_configured TARGET)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")
    cmake_targets_file(HAS_CONFIG is_target_configured TARGET "")
  endfunction()
  
  ct_add_section(NAME "throws_if_config_file_is_not_loaded")
  function(${CMAKETEST_SECTION})
    
    ct_add_section(NAME "throws_if_global_property_is_not_set")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "false")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_fruit salad" "anything")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(HAS_CONFIG is_target_configured TARGET "fruit salad")
      endfunction()
    endfunction()
  endfunction()
endfunction()
