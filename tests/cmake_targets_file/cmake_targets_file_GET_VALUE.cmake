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
# Test of [CMakeTargetsFile module::GET_VALUE operation]:
#   cmake_targets_file(GET_VALUE <output-var> DEP <dep-name>|TARGET <target-dir-path> KEY <setting-name>)
ct_add_test(NAME "test_cmake_targets_file_get_value_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  set(input_apple_dep_config
    "rulesFile:generic"
    "optional:OFF"
    "minVersion:1.15.0"
    "integrationMethod:FIND_THEN_FETCH"
    "packageLocation.windows:C:/Program Files/libs/apple/1.15.0"
    "packageLocation.unix:/opt/apple/1.15.0"
    "packageLocation.macos:/opt/apple/1.15.0"
    "downloadInfo.kind:git"
    "downloadInfo.repository:https://github.com/lib/apple.git"
    "downloadInfo.tag:1234567"
    "build.compileFeatures:cxx_std_20"
    "build.compileDefinitions:DEFINE_ONE=1"
    "build.compileOptions:-Wall"
    "build.linkOptions:-s"
    "invalid"
    ":invalid"
  )
  set(input_src_config
    "name:fruit-salad"
    "type:executable"
    "mainFile:src/main.cpp"
    "dependencies:grape|lemon|AppleLib|BananaLib|CarrotLib|OrangeLib|PineappleLib"
    "pchFile:include/fruit_salad_pch.h"
    "build.compileFeatures:cxx_std_20|cxx_thread_local|cxx_trailing_return_types"
    "build.compileDefinitions:DEFINE_ONE=1|DEFINE_TWO=2|OPTION_1"
    "build.compileOptions:-Wall|-Wextra"
    "build.linkOptions:-s|-z"
    "headerPolicy.mode:split"
    "headerPolicy.includeDir:include"
    "invalid"
    ":invalid"
  )

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(GET_VALUE)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "get_from_dep_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")

    # Get some string values
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
    ct_assert_equal(output "generic")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "minVersion")
    ct_assert_equal(output "1.15.0")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "integrationMethod")
    ct_assert_equal(output "FIND_THEN_FETCH")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "packageLocation.windows")
    ct_assert_equal(output "C:/Program Files/libs/apple/1.15.0")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "downloadInfo.tag")
    ct_assert_equal(output "1234567")

    # Get some boolean values
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "optional")
    ct_assert_equal(output "OFF")

    # Not number values to get

    # Get some arrays
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "build.compileFeatures")
    ct_assert_equal(output "cxx_std_20")
  endfunction()

  ct_add_section(NAME "get_from_target_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

    # Get some string values
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
    ct_assert_equal(output "fruit-salad")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "type")
    ct_assert_equal(output "executable")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "headerPolicy.includeDir")
    ct_assert_equal(output "include")

    # Not boolean values to get
    # Not number values to get

    # Get some arrays
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "build.compileFeatures")
    ct_assert_list(output)
    ct_assert_equal(output "cxx_std_20;cxx_thread_local;cxx_trailing_return_types")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "dependencies")
    ct_assert_list(output)
    ct_assert_equal(output "grape;lemon;AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE TARGET "src" KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE "" TARGET "src" KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE "output" TARGET "src" KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output KEY "rulesFile")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP KEY "rulesFile")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "" KEY "rulesFile")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_missing_5" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "" KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_is_twice" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" TARGET "src" KEY "name")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_does_not_exist")
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
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_different_target")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "BananaLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src/grape" KEY "name")
      endfunction()
    endfunction()
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib")
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY)
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "src")
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_5" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY)
  endfunction()

  ct_add_section(NAME "throws_if_arg_key_is_missing_6" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "")
  endfunction()

  ct_add_section(NAME "throws_if_key_does_not_exist_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "fake.key")
  endfunction()

  ct_add_section(NAME "throws_if_key_does_not_exist_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "fake.key")
  endfunction()

  ct_add_section(NAME "throws_if_key_is_invalid_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "invalid")
  endfunction()

  ct_add_section(NAME "throws_if_key_is_invalid_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    cmake_targets_file(GET_VALUE output TARGET "src" KEY "invalid")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_not_set_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_empty_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_is_empty_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED false)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner_1" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output DEP "AppleLib" KEY "rulesFile")
      endfunction()

      ct_add_section(NAME "throws_if_global_property_is_false_inner_2" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(GET_VALUE output TARGET "src" KEY "name")
      endfunction()
    endfunction()
  endfunction()
endfunction()
