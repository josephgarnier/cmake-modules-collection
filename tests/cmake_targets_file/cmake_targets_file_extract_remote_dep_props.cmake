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
# Test of [CMakeTargetsFile module::_extract_remote_dep_props internal function]:
#    _extract_remote_dep_props(<remote-dep-json-block> <output-map-var>)
ct_add_test(NAME "test_cmake_targets_file_extract_remote_dep_props_internal_function")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # Set global test variables
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_regular.json" regular_json_file_content)
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_extra.json" extra_json_file_content)
  file(READ "${TESTS_DATA_DIR}/config/CMakeTargets_minimal.json" minimal_json_file_content)

  # Functionalities checking
  ct_add_section(NAME "extract_from_regular_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_apple_lib_dep_config_output
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
    )
    set(expected_banana_lib_dep_config_output
      "rulesFile:cmake/rules/RulesBananaLib.cmake"
      "optional:ON"
      "minVersion:4"
    )
    set(expected_carrot_lib_dep_config_output
      "rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "downloadInfo.kind:svn"
      "downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "downloadInfo.revision:1234567"
    )
    set(expected_orange_lib_dep_config_output
      "rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "downloadInfo.kind:mercurial"
      "downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
      "downloadInfo.tag:1234567"
    )
    set(expected_pineapple_lib_dep_config_output
      "rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "downloadInfo.kind:url"
      "downloadInfo.repository:https://example.com/PineappleLib.zip"
      "downloadInfo.hash:1234567"
    )

    # Extract AppleLib
    string(JSON remote_dep_json_block
      GET "${regular_json_file_content}" "externalDeps" "remotes" "AppleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_apple_lib_dep_config_output}")

    # Extract BananaLib
    string(JSON remote_dep_json_block
      GET "${regular_json_file_content}" "externalDeps" "remotes" "BananaLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_banana_lib_dep_config_output}")

    # Extract CarrotLib
    string(JSON remote_dep_json_block
      GET "${regular_json_file_content}" "externalDeps" "remotes" "CarrotLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_carrot_lib_dep_config_output}")

    # Extract OrangeLib
    string(JSON remote_dep_json_block
      GET "${regular_json_file_content}" "externalDeps" "remotes" "OrangeLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_orange_lib_dep_config_output}")

    # Extract PineappleLib
    string(JSON remote_dep_json_block
      GET "${regular_json_file_content}" "externalDeps" "remotes" "PineappleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_pineapple_lib_dep_config_output}")
  endfunction()

  ct_add_section(NAME "extract_from_extra_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_apple_lib_dep_config_output
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
    )
    set(expected_banana_lib_dep_config_output
      "rulesFile:cmake/rules/RulesBananaLib.cmake"
      "optional:ON"
      "minVersion:4"
    )
    set(expected_carrot_lib_dep_config_output
      "rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "downloadInfo.kind:svn"
      "downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "downloadInfo.revision:1234567"
    )
    set(expected_orange_lib_dep_config_output
      "rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "downloadInfo.kind:mercurial"
      "downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
      "downloadInfo.tag:1234567"
    )
    set(expected_pineapple_lib_dep_config_output
      "rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "downloadInfo.kind:url"
      "downloadInfo.repository:https://example.com/PineappleLib.zip"
      "downloadInfo.hash:1234567"
    )

    # Extract AppleLib
    string(JSON remote_dep_json_block
      GET "${extra_json_file_content}" "externalDeps" "remotes" "AppleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_apple_lib_dep_config_output}")

    # Extract BananaLib
    string(JSON remote_dep_json_block
      GET "${extra_json_file_content}" "externalDeps" "remotes" "BananaLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_banana_lib_dep_config_output}")

    # Extract CarrotLib
    string(JSON remote_dep_json_block
      GET "${extra_json_file_content}" "externalDeps" "remotes" "CarrotLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_carrot_lib_dep_config_output}")

    # Extract OrangeLib
    string(JSON remote_dep_json_block
      GET "${extra_json_file_content}" "externalDeps" "remotes" "OrangeLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_orange_lib_dep_config_output}")

    # Extract PineappleLib
    string(JSON remote_dep_json_block
      GET "${extra_json_file_content}" "externalDeps" "remotes" "PineappleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_pineapple_lib_dep_config_output}")
  endfunction()

  ct_add_section(NAME "extract_from_minimal_config_file")
  function(${CMAKETEST_SECTION})
    set(expected_apple_lib_dep_config_output
      "rulesFile:generic"
      "optional:OFF"
      "minVersion:1.15.0"
      "integrationMethod:FIND_THEN_FETCH"
      "downloadInfo.kind:git"
      "downloadInfo.repository:https://github.com/lib/apple.git"
      "downloadInfo.tag:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
    )
    set(expected_banana_lib_dep_config_output
      "rulesFile:generic"
      "optional:OFF"
      "minVersion:1.15.0"
      "integrationMethod:EXTERNAL_PROJECT"
      "downloadInfo.kind:git"
      "downloadInfo.repository:https://github.com/lib/banana.git"
      "downloadInfo.tag:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
    )
    set(expected_carrot_lib_dep_config_output
      "rulesFile:generic"
      "optional:OFF"
      "minVersion:1.15.0"
      "integrationMethod:FETCH_CONTENT"
      "downloadInfo.kind:git"
      "downloadInfo.repository:https://github.com/lib/carrot.git"
      "downloadInfo.tag:"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
    )
    set(expected_orange_lib_dep_config_output
      "rulesFile:generic"
      "optional:OFF"
      "minVersion:1.15.0"
      "integrationMethod:FIND_PACKAGE"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
    )
    set(expected_pineapple_lib_dep_config_output
      "rulesFile:cmake/rules/RulesPineappleLib.cmake"
    )

    # Extract AppleLib
    string(JSON remote_dep_json_block
      GET "${minimal_json_file_content}" "externalDeps" "remotes" "AppleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_apple_lib_dep_config_output}")

    # Extract BananaLib
    string(JSON remote_dep_json_block
      GET "${minimal_json_file_content}" "externalDeps" "remotes" "BananaLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_banana_lib_dep_config_output}")

    # Extract CarrotLib
    string(JSON remote_dep_json_block
      GET "${minimal_json_file_content}" "externalDeps" "remotes" "CarrotLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_carrot_lib_dep_config_output}")

    # Extract OrangeLib
    string(JSON remote_dep_json_block
      GET "${minimal_json_file_content}" "externalDeps" "remotes" "OrangeLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_orange_lib_dep_config_output}")

    # Extract PineappleLib
    string(JSON remote_dep_json_block
      GET "${minimal_json_file_content}" "externalDeps" "remotes" "PineappleLib"
    )
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map)
    ct_assert_not_list(remote_dep_config_map)
    ct_assert_equal(remote_dep_config_map "${expected_pineapple_lib_dep_config_output}")
  endfunction()

  # Errors checking
    ct_add_section(NAME "throws_if_all_args_are_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_remote_dep_props()
  endfunction()

  ct_add_section(NAME "throws_if_too_many_args_are_passed" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON remote_dep_json_block GET "${regular_json_file_content}" "externalDeps" "remotes" "AppleLib")
    _extract_remote_dep_props("${remote_dep_json_block}" remote_dep_config_map "too" "many" "args")
  endfunction()

  ct_add_section(NAME "throws_if_arg_remote_dep_json_block_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_remote_dep_props(remote_dep_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_remote_dep_json_block_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_remote_dep_props("" remote_dep_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_remote_dep_json_block_is_not_a_json_object_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_remote_dep_props("invalid json" remote_dep_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_remote_dep_json_block_is_not_a_json_object_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    _extract_remote_dep_props("[]" remote_dep_config_map)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON remote_dep_json_block GET "${regular_json_file_content}" "externalDeps" "remotes" "AppleLib")
    _extract_remote_dep_props("${remote_dep_json_block}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON remote_dep_json_block GET "${regular_json_file_content}" "externalDeps" "remotes" "AppleLib")
    _extract_remote_dep_props("${remote_dep_json_block}" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_map_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string(JSON remote_dep_json_block GET "${regular_json_file_content}" "externalDeps" "remotes" "AppleLib")
    _extract_remote_dep_props("${remote_dep_json_block}" "remote_dep_config_map")
  endfunction()
endfunction()
