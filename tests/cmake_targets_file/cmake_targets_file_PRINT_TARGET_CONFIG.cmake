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
#   cmake_targets_file(PRINT_TARGET_CONFIG <target-dir-path>)
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
    "externalDeps:AppleLib|BananaLib|CarrotLib|OrangeLib|PineappleLib"
    "externalDeps.AppleLib.rulesFile:generic"
    "externalDeps.AppleLib.optional:OFF"
    "externalDeps.AppleLib.minVersion:1.15.0"
    "externalDeps.AppleLib.integrationMethod:FIND_THEN_FETCH"
    "externalDeps.AppleLib.packageLocation.windows:C:/Program Files/libs/apple/1.15.0"
    "externalDeps.AppleLib.packageLocation.unix:/opt/apple/1.15.0"
    "externalDeps.AppleLib.packageLocation.macos:/opt/apple/1.15.0"
    "externalDeps.AppleLib.downloadInfo.kind:git"
    "externalDeps.AppleLib.downloadInfo.repository:https://github.com/lib/apple.git"
    "externalDeps.AppleLib.downloadInfo.tag:1234567"
    "externalDeps.AppleLib.build.compileFeatures:cxx_std_20"
    "externalDeps.AppleLib.build.compileDefinitions:DEFINE_ONE=1"
    "externalDeps.AppleLib.build.compileOptions:-Wall"
    "externalDeps.AppleLib.build.linkOptions:-s"
    "externalDeps.BananaLib.rulesFile:RulesBananaLib.cmake"
    "externalDeps.BananaLib.optional:ON"
    "externalDeps.BananaLib.minVersion:4"
    "externalDeps.CarrotLib.rulesFile:RulesCarrotLib.cmake"
    "externalDeps.CarrotLib.downloadInfo.kind:svn"
    "externalDeps.CarrotLib.downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
    "externalDeps.CarrotLib.downloadInfo.revision:1234567"
    "externalDeps.OrangeLib.rulesFile:RulesOrangeLib.cmake"
    "externalDeps.OrangeLib.downloadInfo.kind:mercurial"
    "externalDeps.OrangeLib.downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
    "externalDeps.OrangeLib.downloadInfo.tag:1234567"
    "externalDeps.PineappleLib.rulesFile:RulesPineappleLib.cmake"
    "externalDeps.PineappleLib.downloadInfo.kind:url"
    "externalDeps.PineappleLib.downloadInfo.repository:https://example.com/PineappleLib.zip"
    "externalDeps.PineappleLib.downloadInfo.hash:1234567"
    "invalid"
    ":invalid"
  )
  set(input_src_grape_config
    "name:grape"
    "type:staticLib"
    "mainFile:src/grape/main.cpp"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "externalDeps:"
    "invalid"
    ":invalid"
  )
  set(input_src_lemon_config
    "name:lemon"
    "type:staticLib"
    "mainFile:src/lemon/main.cpp"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "externalDeps:"
    "invalid"
    ":invalid"
  )

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(PRINT_TARGET_CONFIG)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon")
  endmacro()
  
  # Functionalities checking
  ct_add_section(NAME "print_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src/grape")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "src/lemon")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(PRINT_TARGET_CONFIG "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_unknown")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    
    ct_add_section(NAME "throws_if_global_property_is_not_set")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
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
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src/grape")
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

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED false)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_TARGET_CONFIG "src")
      endfunction()
    endfunction()
  endfunction()
endfunction()
