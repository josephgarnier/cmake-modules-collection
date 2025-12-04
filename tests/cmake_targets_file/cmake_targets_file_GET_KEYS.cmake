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
# Test of [CMakeTargetsFile module::GET_KEYS operation]:
#    cmake_targets_file(GET_KEYS <output-list-var> TARGET <target-dir-path>)
ct_add_test(NAME "test_cmake_targets_file_get_keys_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_config_map
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
    "dependencies.AppleLib.build.compileFeatures:cxx_std_20"
    "dependencies.AppleLib.build.compileDefinitions:DEFINE_ONE=1"
    "dependencies.AppleLib.build.compileOptions:-Wall"
    "dependencies.AppleLib.build.linkOptions:-s"
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

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(GET_KEYS)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
  endmacro()
  
  # Functionalities checking
  ct_add_section(NAME "get_keys_of_config_with_various_keys")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set(expected_output
      "name"
      "type"
      "mainFile"
      "pchFile"
      "build.compileFeatures"
      "build.compileDefinitions"
      "build.compileOptions"
      "build.linkOptions"
      "headerPolicy.mode"
      "headerPolicy.includeDir"
      "dependencies"
      "dependencies.AppleLib.rulesFile"
      "dependencies.AppleLib.minVersion"
      "dependencies.AppleLib.optional"
      "dependencies.AppleLib.packageLocation.windows"
      "dependencies.AppleLib.packageLocation.unix"
      "dependencies.AppleLib.packageLocation.macos"
      "dependencies.AppleLib.fetchInfo.autodownload"
      "dependencies.AppleLib.fetchInfo.kind"
      "dependencies.AppleLib.fetchInfo.repository"
      "dependencies.AppleLib.fetchInfo.tag"
      "dependencies.AppleLib.build.compileFeatures"
      "dependencies.AppleLib.build.compileDefinitions"
      "dependencies.AppleLib.build.compileOptions"
      "dependencies.AppleLib.build.linkOptions"
      "dependencies.BananaLib.rulesFile"
      "dependencies.BananaLib.minVersion"
      "dependencies.BananaLib.optional"
      "dependencies.BananaLib.fetchInfo.autodownload"
      "dependencies.CarrotLib.rulesFile"
      "dependencies.CarrotLib.fetchInfo.autodownload"
      "dependencies.CarrotLib.fetchInfo.kind"
      "dependencies.CarrotLib.fetchInfo.repository"
      "dependencies.CarrotLib.fetchInfo.revision"
      "dependencies.OrangeLib.rulesFile"
      "dependencies.OrangeLib.fetchInfo.autodownload"
      "dependencies.OrangeLib.fetchInfo.kind"
      "dependencies.OrangeLib.fetchInfo.repository"
      "dependencies.OrangeLib.fetchInfo.tag"
      "dependencies.PineappleLib.rulesFile"
      "dependencies.PineappleLib.fetchInfo.autodownload"
      "dependencies.PineappleLib.fetchInfo.kind"
      "dependencies.PineappleLib.fetchInfo.repository"
      "dependencies.PineappleLib.fetchInfo.hash"
    )
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS output TARGET "src")
    ct_assert_list(output)
    ct_assert_equal(output "${expected_output}")
  endfunction()

  ct_add_section(NAME "get_keys_of_empty_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "")
    cmake_targets_file(GET_KEYS output TARGET "src")
    ct_assert_equal(output "")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS "" TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS "output" TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS output TARGET)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_KEYS output TARGET "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_does_not_exist")
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
        cmake_targets_file(GET_KEYS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_different_target")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_KEYS output TARGET "src/apple")
      endfunction()
    endfunction()
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_KEYS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_KEYS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_KEYS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_off")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_off_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_KEYS output TARGET "src")
      endfunction()
    endfunction()
  endfunction()
endfunction()
