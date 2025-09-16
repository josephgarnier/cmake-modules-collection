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
  set(input_src_config
    "name:fruit-salad"
    "type:executable"
    "mainFile:src/main.cpp"
    "pchFile:include/fruit_salad_pch.h"
    "build.compileFeatures:cxx_std_20|cxx_thread_local|cxx_trailing_return_types"
    "build.compileDefinitions:DEFINE_ONE=1|DEFINE_TWO=2|OPTION_1"
    "build.compileOptions:-Wall|-Wextra"
    "build.linkOptions:-s|-z"
    "headerPolicy.mode:split"
    "headerPolicy.includeDir:include"
    "dependencies:AppleLib|BananaLib|CarrotLib|OrangeLib|PineappleLib"
    "dependencies.AppleLib.rulesFile:generic"
    "dependencies.AppleLib.minVersion:1.15.0"
    "dependencies.AppleLib.optional:OFF"
    "dependencies.AppleLib.packageLocation.windows:C:/Program Files/libs/apple/1.15.0"
    "dependencies.AppleLib.packageLocation.unix:/opt/apple/1.15.0"
    "dependencies.AppleLib.packageLocation.macos:/opt/apple/1.15.0"
    "dependencies.AppleLib.fetchInfo.autodownload:ON"
    "dependencies.AppleLib.fetchInfo.kind:git"
    "dependencies.AppleLib.fetchInfo.repository:https://github.com/lib/apple.git"
    "dependencies.AppleLib.fetchInfo.tag:1234567"
    "dependencies.AppleLib.configuration.compileFeatures:cxx_std_20"
    "dependencies.AppleLib.configuration.compileDefinitions:DEFINE_ONE=1"
    "dependencies.AppleLib.configuration.compileOptions:-Wall"
    "dependencies.AppleLib.configuration.linkOptions:-s"
    "dependencies.BananaLib.rulesFile:RulesBananaLib.cmake"
    "dependencies.BananaLib.minVersion:4"
    "dependencies.BananaLib.optional:ON"
    "dependencies.BananaLib.fetchInfo.autodownload:OFF"
    "dependencies.CarrotLib.rulesFile:RulesCarrotLib.cmake"
    "dependencies.CarrotLib.fetchInfo.autodownload:ON"
    "dependencies.CarrotLib.fetchInfo.kind:svn"
    "dependencies.CarrotLib.fetchInfo.repository:svn://svn.carrot.lib.org/links/trunk"
    "dependencies.CarrotLib.fetchInfo.revision:1234567"
    "dependencies.OrangeLib.rulesFile:RulesOrangeLib.cmake"
    "dependencies.OrangeLib.fetchInfo.autodownload:ON"
    "dependencies.OrangeLib.fetchInfo.kind:mercurial"
    "dependencies.OrangeLib.fetchInfo.repository:https://hg.example.com/RulesOrangeLib"
    "dependencies.OrangeLib.fetchInfo.tag:1234567"
    "dependencies.PineappleLib.rulesFile:RulesPineappleLib.cmake"
    "dependencies.PineappleLib.fetchInfo.autodownload:ON"
    "dependencies.PineappleLib.fetchInfo.kind:url"
    "dependencies.PineappleLib.fetchInfo.repository:https://example.com/PineappleLib.zip"
    "dependencies.PineappleLib.fetchInfo.hash:1234567"
    "invalid"
    ":invalid"
  )
  set(input_src_apple_config
    "name:apple"
    "type:staticLib"
    "mainFile:src/apple/main.cpp"
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
    # Reset properties used by `cmake_targets_file(PRINT_TARGET_CONFIG)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana")
  endmacro()
  
  # Functionalities checking
  ct_add_section(NAME "print_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src/apple")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src/banana")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_off")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_off_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()
  endfunction()
endfunction()
