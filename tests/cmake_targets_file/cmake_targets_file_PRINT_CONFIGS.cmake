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
#   cmake_targets_file(PRINT_CONFIGS [])
ct_add_test(NAME "test_cmake_targets_file_print_configs_operation")
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
  set(input_src_grape_config
    "name:grape"
    "type:staticLib"
    "mainFile:src/grape/main.cpp"
    "dependencies:"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "invalid"
    ":invalid"
  )
  set(input_src_lemon_config
    "name:lemon"
    "type:staticLib"
    "mainFile:src/lemon/main.cpp"
    "dependencies:"
    "build.compileFeatures:"
    "build.compileDefinitions:"
    "build.compileOptions:"
    "build.linkOptions:"
    "headerPolicy.mode:merged"
    "invalid"
    ":invalid"
  )

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(PRINT_CONFIGS)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS)
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "print_target_configs")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    cmake_targets_file(PRINT_CONFIGS)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_config_file_not_loaded")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "throws_if_global_property_not_set_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_LOADED` property is not set
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_REMOTE_DEPS` and `TARGETS_CONFIG_TARGETS`
      # properties are not set
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_not_set_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_DEP_AppleLib` and `TARGETS_CONFIG_src`
      # properties are not set
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
      ct_assert_false(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
      ct_assert_equal(output_property "")
      ct_assert_not_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")

      ct_add_section(NAME "throws_if_global_property_not_set_3_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_1")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_LOADED` property is empty
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_1_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_2")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_REMOTE_DEPS` and `TARGETS_CONFIG_TARGETS`
      # properties are empty
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_2_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_empty_3")
    function(${CMAKETEST_SECTION})
      _set_up_test()

      # Throws if `TARGETS_CONFIG_DEP_AppleLib` and `TARGETS_CONFIG_src`
      # properties are empty
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED true)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "")
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src" SET)
      ct_assert_true(output_property)
      get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
      ct_assert_equal(output_property "")
      ct_assert_defined(output_property)
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_empty_3_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_not_bool")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")
    
      ct_add_section(NAME "throws_if_global_property_is_not_bool_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()

    ct_add_section(NAME "throws_if_global_property_is_false")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED false)
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_REMOTE_DEPS "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib" "${input_apple_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib" "${input_banana_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib" "${input_carrot_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib" "${input_orange_lib_dep_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib" "${input_pineapple_lib_dep_config}")
      set_property(GLOBAL PROPERTY TARGETS_CONFIG_TARGETS "src;src/grape;src/lemon")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src" "${input_src_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape" "${input_src_grape_config}")
      set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon" "${input_src_lemon_config}")

      ct_add_section(NAME "throws_if_global_property_is_false_inner" EXPECTFAIL)
      function(${CMAKETEST_SECTION})
        cmake_targets_file(PRINT_CONFIGS)
      endfunction()
    endfunction()
  endfunction()
endfunction()
