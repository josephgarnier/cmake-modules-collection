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
# Test of [CMakeTargetsFile module::PRINT_TARGET_CONFIG operation]:
#    cmake_targets_file(PRINT_TARGET_CONFIG <target-dir-path>)
ct_add_test(NAME "test_cmake_targets_file_print_target_config_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_config_map
    "name:fruit-salad"
    "type:executable"
    "mainFile:src/main.cpp"
    "pchFile:include/fruit_salad_pch.h"
    "build.compileFeatures:cxx_std_20"
    "build.compileDefinitions:MY_DEFINE=42|MY_OTHER_DEFINE|MY_OTHER_DEFINE=42"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:split"
    "headerPolicy.includeDir:include"
    "dependencies:AppleLib|BananaLib"
    "dependencies.AppleLib.rulesFile:FindAppleLib.cmake"
    "dependencies.AppleLib.minVersion:2"
    "dependencies.AppleLib.autodownload:ON"
    "dependencies.AppleLib.optional:OFF"
    "dependencies.BananaLib.rulesFile:FindBananaLib.cmake"
    "dependencies.BananaLib.minVersion:4"
    "dependencies.BananaLib.autodownload:OFF"
    "dependencies.BananaLib.optional:ON"
    "invalid"
    ":invalid"
  )

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(PRINT_TARGET_CONFIG)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
  endmacro()
  
  # Functionalities checking
  ct_add_section(NAME "print_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(PRINT_TARGET_CONFIG)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(PRINT_TARGET_CONFIG "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_unknown")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    
    ct_add_section(NAME "throws_if_global_property_is_not_set")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_different_target")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src/apple")
      endfunction()
    endfunction()
  endfunction()

  ct_add_section(NAME "throws_if_config_file_not_loaded")
  function(${CMAKETEST_SECTION})
    
    ct_add_section(NAME "throws_if_global_property_not_set")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_off")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_off_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()
  endfunction()
endfunction()
