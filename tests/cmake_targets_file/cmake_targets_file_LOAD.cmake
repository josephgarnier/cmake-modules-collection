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
# Test of [CMakeTargetsFile module::LOAD operation]:
#    cmake_targets_file(LOAD <json-file-path>)
ct_add_test(NAME "test_cmake_targets_file_load_operation")
function(${CMAKETEST_TEST})
	include(CMakeTargetsFile)

	# To call before each test
	macro(_set_up_test)
		# Reset properties used by `cmake_targets_file(LOAD)`
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON)
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LIST)
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
		set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src")
		set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/apple")
		set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/banana")
	endmacro()

	# Functionalities checking
	ct_add_section(NAME "load_config_file")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		# The JSON comparison is space sensitive, so the indentation does not be changed
		set(expected_raw_json_output
[=[{
  "$schema": "../../../cmake/modules/schema.json",
  "$id": "schema.json",
  "targets": {
    "src": {
      "name": "fruit-salad",
      "type": "executable",
      "build": {
        "compileFeatures": ["cxx_std_20"],
        "compileDefinitions": ["MY_DEFINE=42", "MY_OTHER_DEFINE", "MY_OTHER_DEFINE=42"],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/main.cpp",
      "pchFile": "include/fruit_salad_pch.h",
      "headerPolicy": {
        "mode": "split",
        "includeDir": "include"
      },
      "dependencies": {
        "AppleLib": {
          "rulesFile": "FindAppleLib.cmake",
          "minVersion": 2,
          "autodownload": true,
          "optional": false
        },
        "BananaLib": {
          "rulesFile": "FindBananaLib.cmake",
          "minVersion": 4,
          "autodownload": false,
          "optional": true
        }
      }
    },
    "src/apple": {
      "name": "apple",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/apple/main.cpp",
      "pchFile": "src/apple/apple_pch.h",
      "headerPolicy": {
        "mode": "merged"
      },
      "dependencies": {}
    },
    "src/banana": {
      "name": "banana",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/banana/main.cpp",
      "pchFile": "src/banana/banana_pch.h",
      "headerPolicy": {
        "mode": "merged"
      },
      "dependencies": {}
    }
  }
}]=]
		)
		set(expected_src_config_output
			"name:fruit-salad"
			"type:executable"
			"mainFile:src/main.cpp"
			"pchFile:include/fruit_salad_pch.h"
			"build.compileFeatures:cxx_std_20"
			"build.compileDefinitions:MY_DEFINE=42|MY_OTHER_DEFINE|MY_OTHER_DEFINE=42"
			"build.compileOptions:"
			"build.linkOptions:"
			"headerPolicy.mode:split"
			"headerPolicy.includeDir:include"
			"dependencies:AppleLib|BananaLib"
			"dependencies.AppleLib.rulesFile:FindAppleLib.cmake"
			"dependencies.AppleLib.minVersion:2"
			"dependencies.AppleLib.autodownload:ON"
			"dependencies.AppleLib.optional:OFF"
			"dependencies.BananaLib.rulesFile:FindBananaLib.cmake"
			"dependencies.BananaLib.minVersion:4"
			"dependencies.BananaLib.autodownload:OFF"
			"dependencies.BananaLib.optional:ON"
		)
		set(expected_src_apple_config_output
			"name:apple"
			"type:staticLib"
			"mainFile:src/apple/main.cpp"
			"pchFile:src/apple/apple_pch.h"
			"build.compileFeatures:"
			"build.compileDefinitions:"
			"build.compileOptions:"
			"build.linkOptions:"
			"headerPolicy.mode:merged"
			"dependencies:"
		)
		set(expected_src_banana_config_output
			"name:banana"
			"type:staticLib"
			"mainFile:src/banana/main.cpp"
			"pchFile:src/banana/banana_pch.h"
			"build.compileFeatures:"
			"build.compileDefinitions:"
			"build.compileOptions:"
			"build.linkOptions:"
			"headerPolicy.mode:merged"
			"dependencies:"
		)

		cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets.json")
		
		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
		ct_assert_string(output_property)
		ct_assert_equal(output_property "${expected_raw_json_output}")

		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
		ct_assert_list(output_property)
		ct_assert_equal(output_property "src;src/apple;src/banana")

		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
		ct_assert_string(output_property)
		ct_assert_true(output_property)
		ct_assert_equal(output_property "on")

		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
		ct_assert_list(output_property)
		ct_assert_equal(output_property "${expected_src_config_output}")

		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/apple")
		ct_assert_list(output_property)
		ct_assert_equal(output_property "${expected_src_apple_config_output}")

		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/banana")
		ct_assert_list(output_property)
		ct_assert_equal(output_property "${expected_src_banana_config_output}")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_json_file_path_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD)
	endfunction()

	ct_add_section(NAME "throws_if_arg_json_file_path_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_json_file_path_does_not_exist" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD "fake/file")
	endfunction()

	ct_add_section(NAME "throws_if_arg_json_file_path_is_not_a_file" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config")
	endfunction()

	ct_add_section(NAME "throws_if_arg_json_file_path_is_not_a_json_file" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD "${TESTS_DATA_DIR}/src/main.cpp")
	endfunction()

	ct_add_section(NAME "throws_if_arg_json_file_path_is_an_empty_file" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_empty.json")
	endfunction()
endfunction()
