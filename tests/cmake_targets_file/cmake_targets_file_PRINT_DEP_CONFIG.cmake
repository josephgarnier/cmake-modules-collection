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
# Test of [CMakeTargetsFile module::PRINT_DEP_CONFIG operation]:
#   cmake_targets_file(PRINT_DEP_CONFIG <dep-name>)
ct_add_test(NAME "test_cmake_targets_file_print_dep_config_operation")
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
  set(input_banana_lib_dep_config
    "rulesFile:cmake/rules/RulesBananaLib.cmake"
    "optional:ON"
    "minVersion:4"
    "invalid"
    ":invalid"
  )
  set(input_carrot_lib_dep_config
    "rulesFile:cmake/rules/RulesCarrotLib.cmake"
    "downloadInfo.kind:svn"
    "downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
    "downloadInfo.revision:1234567"
    "invalid"
    ":invalid"
  )
  set(input_orange_lib_dep_config
    "rulesFile:cmake/rules/RulesOrangeLib.cmake"
    "downloadInfo.kind:mercurial"
    "downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
    "downloadInfo.tag:1234567"
    "invalid"
    ":invalid"
  )
  set(input_pineapple_lib_dep_config
    "rulesFile:cmake/rules/RulesPineappleLib.cmake"
    "downloadInfo.kind:url"
    "downloadInfo.repository:https://example.com/PineappleLib.zip"
    "downloadInfo.hash:1234567"
    "invalid"
    ":invalid"
  )

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(PRINT_DEP_CONFIG)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib")
  endmacro()
  
  # Functionalities checking
  ct_add_section(NAME "print_dep_config")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "BananaLib")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "CarrotLib")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "OrangeLib")

    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "PineappleLib")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_dir_path_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    cmake_targets_file(PRINT_DEP_CONFIG "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_requested_config_does_not_exist")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    
    ct_add_section(NAME "throws_if_global_property_is_not_set")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)

      ct_add_section(NAME "throws_if_global_property_is_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_different_target")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")

      ct_add_section(NAME "throws_if_global_property_is_different_target_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "BananaLib")
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
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")
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

      ct_add_section(NAME "throws_if_global_property_is_empty_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")

      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED false)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_DEP_CONFIG "AppleLib")
      endfunction()
    endfunction()
  endfunction()
endfunction()
