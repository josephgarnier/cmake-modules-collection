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
# Test of [CMakeTargetsFile module::_assert_config_file_loaded internal function]:
#    _assert_config_file_loaded()
ct_add_test(NAME "test_cmake_targets_file_assert_config_file_loaded_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `_assert_config_file_loaded()`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "check_when_global_property_is_on")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
    ct_assert_true(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_defined(output_property)
    ct_assert_equal(output_property "on")
    _assert_config_file_loaded()
  endfunction()

  ct_add_section(NAME "check_when_global_property_is_not_set")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
    ct_assert_false(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_equal(output_property "")
    ct_assert_not_defined(output_property)
    
    ct_add_section(NAME "check_when_global_property_is_not_set" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _assert_config_file_loaded()
    endfunction()
  endfunction()

  ct_add_section(NAME "check_when_global_property_is_empty")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
    ct_assert_true(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_equal(output_property "")
    ct_assert_defined(output_property)

    ct_add_section(NAME "check_when_global_property_is_empty_inner" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _assert_config_file_loaded()
    endfunction()
  endfunction()

  ct_add_section(NAME "check_when_global_property_is_not_bool")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")

    ct_add_section(NAME "check_when_global_property_is_not_bool_inner" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _assert_config_file_loaded()
    endfunction()
  endfunction()

  ct_add_section(NAME "check_when_global_property_is_off")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")

    ct_add_section(NAME "check_when_global_property_is_off_inner" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      _assert_config_file_loaded()
    endfunction()
  endfunction()
endfunction()
