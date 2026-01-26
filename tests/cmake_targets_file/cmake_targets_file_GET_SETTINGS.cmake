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
# Test of [CMakeTargetsFile module::GET_SETTINGS operation]:
#   cmake_targets_file(GET_SETTINGS <output-map-var> TARGET <target-dir-path>)
ct_add_test(NAME "test_cmake_targets_file_get_settings_operation")
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

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(GET_SETTINGS)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "get_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS output TARGET "src")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_equal(output_property "${input_config_map}")
    ct_assert_defined(output_property)
    ct_assert_equal(output "${input_config_map}")
    ct_assert_equal(output "${output_property}")
  endfunction()

  ct_add_section(NAME "get_empty_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "")
    cmake_targets_file(GET_SETTINGS output TARGET "src")
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
    ct_assert_true(output_property)
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_equal(output_property "")
    ct_assert_defined(output_property)
    ct_assert_equal(output "")
    ct_assert_equal(output "${output_property}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS "" TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS "output" TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS output TARGET)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")
    cmake_targets_file(GET_SETTINGS output TARGET "")
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
        cmake_targets_file(GET_SETTINGS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_different_target")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_SETTINGS output TARGET "src/grape")
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
        cmake_targets_file(GET_SETTINGS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_SETTINGS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_SETTINGS output TARGET "src")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED false)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_config_map}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_SETTINGS output TARGET "src")
      endfunction()
    endfunction()
  endfunction()
endfunction()
