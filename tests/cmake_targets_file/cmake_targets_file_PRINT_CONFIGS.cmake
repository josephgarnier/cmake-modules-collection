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
    "build.compileFeatures:cxx_std_20|cxx_thread_local|cxx_trailing_return_types"
    "build.compileDefinitions:DEFINE_ONE=1|DEFINE_TWO=2|OPTION_1"
    "build.compileOptions:-Wall|-Wextra"
    "build.linkOptions:-s|-z"
    "headerPolicy.mode:split"
    "headerPolicy.includeDir:include"
    "extDependencies:AppleLib|BananaLib|CarrotLib|OrangeLib|PineappleLib"
    "extDependencies.AppleLib.rulesFile:generic"
    "extDependencies.AppleLib.minVersion:1.15.0"
    "extDependencies.AppleLib.integrationMethod:FIND_AND_FETCH"
    "extDependencies.AppleLib.optional:OFF"
    "extDependencies.AppleLib.packageLocation.windows:C:/Program Files/libs/apple/1.15.0"
    "extDependencies.AppleLib.packageLocation.unix:/opt/apple/1.15.0"
    "extDependencies.AppleLib.packageLocation.macos:/opt/apple/1.15.0"
    "extDependencies.AppleLib.fetchInfo.autodownload:ON"
    "extDependencies.AppleLib.fetchInfo.kind:git"
    "extDependencies.AppleLib.fetchInfo.repository:https://github.com/lib/apple.git"
    "extDependencies.AppleLib.fetchInfo.tag:1234567"
    "extDependencies.AppleLib.build.compileFeatures:cxx_std_20"
    "extDependencies.AppleLib.build.compileDefinitions:DEFINE_ONE=1"
    "extDependencies.AppleLib.build.compileOptions:-Wall"
    "extDependencies.AppleLib.build.linkOptions:-s"
    "extDependencies.BananaLib.rulesFile:RulesBananaLib.cmake"
    "extDependencies.BananaLib.minVersion:4"
    "extDependencies.BananaLib.optional:ON"
    "extDependencies.BananaLib.fetchInfo.autodownload:OFF"
    "extDependencies.CarrotLib.rulesFile:RulesCarrotLib.cmake"
    "extDependencies.CarrotLib.fetchInfo.autodownload:ON"
    "extDependencies.CarrotLib.fetchInfo.kind:svn"
    "extDependencies.CarrotLib.fetchInfo.repository:svn://svn.carrot.lib.org/links/trunk"
    "extDependencies.CarrotLib.fetchInfo.revision:1234567"
    "extDependencies.OrangeLib.rulesFile:RulesOrangeLib.cmake"
    "extDependencies.OrangeLib.fetchInfo.autodownload:ON"
    "extDependencies.OrangeLib.fetchInfo.kind:mercurial"
    "extDependencies.OrangeLib.fetchInfo.repository:https://hg.example.com/RulesOrangeLib"
    "extDependencies.OrangeLib.fetchInfo.tag:1234567"
    "extDependencies.PineappleLib.rulesFile:RulesPineappleLib.cmake"
    "extDependencies.PineappleLib.fetchInfo.autodownload:ON"
    "extDependencies.PineappleLib.fetchInfo.kind:url"
    "extDependencies.PineappleLib.fetchInfo.repository:https://example.com/PineappleLib.zip"
    "extDependencies.PineappleLib.fetchInfo.hash:1234567"
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
    "extDependencies:"
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
    "extDependencies:"
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
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "true")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "false")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST "src;src/apple;src/banana")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple" "${input_src_apple_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana" "${input_src_banana_config}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()
  endfunction()
endfunction()
