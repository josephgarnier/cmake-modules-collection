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
# Test of [CMakeTargetsFile module::_extract_target_props internal function]:
#   _extract_target_props(<target-json-block> <output-map-var>)
ct_add_test(NAME "test_cmake_targets_file_extract_target_props_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_regular.json" regular_json_file_content)
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_extra.json" extra_json_file_content)
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_minimal.json" minimal_json_file_content)

  # Functionalities checking
  ct_add_section(NAME "extract_from_regular_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_src_config_output
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
    )
    set(expected_src_grape_config_output
      "name:grape"
      "type:staticLib"
      "mainFile:src/grape/main.cpp"
      "dependencies:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
    )
    set(expected_src_lemon_config_output
      "name:lemon"
      "type:staticLib"
      "mainFile:src/lemon/main.cpp"
      "dependencies:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
    )

    # Extract src
    string(JSON target_json_block
      GET "${regular_json_file_content}" "targets" "src"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_config_output}")

    # Extract src/grape
    string(JSON target_json_block
      GET "${regular_json_file_content}" "targets" "src/grape"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_grape_config_output}")

    # Extract src/lemon
    string(JSON target_json_block
      GET "${regular_json_file_content}" "targets" "src/lemon"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_lemon_config_output}")
  endfunction()

  ct_add_section(NAME "extract_from_extra_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_src_config_output
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
    )
    set(expected_src_grape_config_output
      "name:grape"
      "type:staticLib"
      "mainFile:src/grape/main.cpp"
      "dependencies:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
    )
    set(expected_src_lemon_config_output
      "name:lemon"
      "type:staticLib"
      "mainFile:src/lemon/main.cpp"
      "dependencies:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
    )

    # Extract src
    string(JSON target_json_block
      GET "${extra_json_file_content}" "targets" "src"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_config_output}")

    # Extract src/grape
    string(JSON target_json_block
      GET "${extra_json_file_content}" "targets" "src/grape"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_grape_config_output}")

    # Extract src/lemon
    string(JSON target_json_block
      GET "${extra_json_file_content}" "targets" "src/lemon"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_lemon_config_output}")
  endfunction()

  ct_add_section(NAME "extract_from_minimal_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_src_config_output
      "name:fruit-salad"
      "type:executable"
      "mainFile:src/main.cpp"
      "dependencies:"
      "pchFile:include/fruit_salad_pch.h"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:split"
      "headerPolicy.includeDir:include"
    )
    set(expected_src_grape_config_output
      "name:grape"
      "type:staticLib"
      "mainFile:src/grape/main.cpp"
      "dependencies:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
    )

    # Extract src
    string(JSON target_json_block
      GET "${minimal_json_file_content}" "targets" "src"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_config_output}")

    # Extract src/grape
    string(JSON target_json_block
      GET "${minimal_json_file_content}" "targets" "src/grape"
    )
    _extract_target_props("${target_json_block}" target_config_map)
    ct_assert_list(target_config_map)
    ct_assert_equal(target_config_map "${expected_src_grape_config_output}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_target_props()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON target_json_block GET "${regular_json_file_content}" "targets" "src")
    _extract_target_props("${target_json_block}" target_config_map "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_target_props(target_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_target_props("" target_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_json_block_is_not_a_json_object_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_target_props("invalid json" target_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_json_block_is_not_a_json_object_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_target_props("[]" target_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON target_json_block GET "${regular_json_file_content}" "targets" "src")
    _extract_target_props("${target_json_block}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON target_json_block GET "${regular_json_file_content}" "targets" "src")
    _extract_target_props("${target_json_block}" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON target_json_block GET "${regular_json_file_content}" "targets" "src")
    _extract_target_props("${target_json_block}" "target_config_map")
  endfunction()
endfunction()
