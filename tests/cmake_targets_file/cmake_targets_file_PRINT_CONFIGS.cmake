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
# Test of [CMakeTargetsFile module::PRINT_CONFIGS operation]:
#    cmake_targets_file(PRINT_CONFIGS [])
ct_add_test(NAME "test_cmake_targets_file_print_configs_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_src_config
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
  set(input_src_apple_config
    "name:apple"
    "type:staticLib"
    "mainFile:src/apple/main.cpp"
    "pchFile:src/apple/apple_pch.h"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "dependencies:"
    "invalid"
    ":invalid"
  )
  set(input_src_banana_config
    "name:banana"
    "type:staticLib"
    "mainFile:src/banana/main.cpp"
    "pchFile:src/banana/banana_pch.h"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "dependencies:"
    "invalid"
    ":invalid"
  )
  
  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(PRINT_CONFIGS)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "print_target_configs")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    cmake_targets_file(PRINT_CONFIGS)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_config_file_not_loaded")
  function(${CMAKETEST_SECTION})
    
    ct_add_section(NAME "throws_if_global_property_not_set_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_3_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_3_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_off")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_is_off_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()
  endfunction()
  
  
  
  
  
  
  
  
  
  ct_add_section(NAME "throws_if_arg_x_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP)
  endfunction()

  ct_add_section(NAME "throws_if_arg_x_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_x_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP)
  endfunction()

  ct_add_section(NAME "throws_if_arg_x_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP "")
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_x_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP "foo")
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP "foo" OUTPUT_VARIABLE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP foo OUTPUT_VARIABLE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    func(OP foo OUTPUT_VARIABLE "foo")
  endfunction()
endfunction()
