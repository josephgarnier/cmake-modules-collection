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
# Test of [CMakeTargetsFile module::GET_LOADED_FILE operation]:
#    cmake_targets_file(GET_LOADED_FILE <output-var>)
ct_add_test(NAME "test_cmake_targets_file_get_loaded_file_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(GET_LOADED_FILE)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON)
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "get_file_content")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
    cmake_targets_file(GET_LOADED_FILE file_content)
    ct_assert_equal(file_content "file content")

    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "")
    cmake_targets_file(GET_LOADED_FILE file_content)
    ct_assert_equal(file_content "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
    cmake_targets_file(GET_LOADED_FILE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
    cmake_targets_file(GET_LOADED_FILE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
    cmake_targets_file(GET_LOADED_FILE "file_content")
  endfunction()
  
  ct_add_section(NAME "throws_if_config_file_is_not_loaded")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "throws_if_global_property_not_set_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")

      ct_add_section(NAME "throws_if_global_property_not_set_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_LOADED_FILE file_content)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)

      ct_add_section(NAME "throws_if_global_property_not_set_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_LOADED_FILE file_content)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")

      ct_add_section(NAME "throws_if_global_property_is_empty_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_LOADED_FILE file_content)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "")

      ct_add_section(NAME "throws_if_global_property_is_empty_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_LOADED_FILE file_content)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_LOADED_FILE file_content)
      endfunction()
    endfunction()
  endfunction()

  ct_add_section(NAME "throws_if_global_property_is_false")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON "file content")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "false")

    ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      cmake_targets_file(GET_LOADED_FILE file_content)
    endfunction()
  endfunction()
endfunction()
