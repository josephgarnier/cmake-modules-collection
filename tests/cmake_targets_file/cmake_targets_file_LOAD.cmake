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
        "compileFeatures": ["cxx_std_20", "cxx_thread_local", "cxx_trailing_return_types"],
        "compileDefinitions": ["DEFINE_ONE=1", "DEFINE_TWO=2", "OPTION_1"],
        "compileOptions": ["-Wall", "-Wextra"],
        "linkOptions": ["-s", "-z"]
      },
      "mainFile": "src/main.cpp",
      "pchFile": "include/fruit_salad_pch.h",
      "headerPolicy": {
        "mode": "split",
        "includeDir": "include"
      },
      "extDependencies": {
        "AppleLib": {
          "rulesFile": "generic",
          "minVersion": "1.15.0",
          "integrationMethod": "FIND_AND_FETCH",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "fetchInfo": {
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
          "optional": false,
          "build": {
            "compileFeatures": ["cxx_std_20"],
            "compileDefinitions": ["DEFINE_ONE=1"],
            "compileOptions": ["-Wall"],
            "linkOptions": ["-s"]
          }
        },
        "BananaLib": {
          "rulesFile": "cmake/rules/RulesBananaLib.cmake",
          "minVersion": "4",
          "fetchInfo": {},
          "optional": true
        },
        "CarrotLib": {
          "rulesFile": "cmake/rules/RulesCarrotLib.cmake",
          "fetchInfo": {
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "cmake/rules/RulesOrangeLib.cmake",
          "fetchInfo": {
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "cmake/rules/RulesPineappleLib.cmake",
          "fetchInfo": {
            "kind": "url",
            "repository": "https://example.com/PineappleLib.zip",
            "hash": "1234567"
          }
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
      "headerPolicy": {
        "mode": "merged"
      },
      "extDependencies": {}
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
      "headerPolicy": {
        "mode": "merged"
      },
      "extDependencies": {}
    }
  }
}]=]
    )
    set(expected_src_config_output
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
      "extDependencies.AppleLib.fetchInfo.kind:git"
      "extDependencies.AppleLib.fetchInfo.repository:https://github.com/lib/apple.git"
      "extDependencies.AppleLib.fetchInfo.tag:1234567"
      "extDependencies.AppleLib.build.compileFeatures:cxx_std_20"
      "extDependencies.AppleLib.build.compileDefinitions:DEFINE_ONE=1"
      "extDependencies.AppleLib.build.compileOptions:-Wall"
      "extDependencies.AppleLib.build.linkOptions:-s"
      "extDependencies.BananaLib.rulesFile:cmake/rules/RulesBananaLib.cmake"
      "extDependencies.BananaLib.minVersion:4"
      "extDependencies.BananaLib.optional:ON"
      "extDependencies.CarrotLib.rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "extDependencies.CarrotLib.fetchInfo.kind:svn"
      "extDependencies.CarrotLib.fetchInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "extDependencies.CarrotLib.fetchInfo.revision:1234567"
      "extDependencies.OrangeLib.rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "extDependencies.OrangeLib.fetchInfo.kind:mercurial"
      "extDependencies.OrangeLib.fetchInfo.repository:https://hg.example.com/RulesOrangeLib"
      "extDependencies.OrangeLib.fetchInfo.tag:1234567"
      "extDependencies.PineappleLib.rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "extDependencies.PineappleLib.fetchInfo.kind:url"
      "extDependencies.PineappleLib.fetchInfo.repository:https://example.com/PineappleLib.zip"
      "extDependencies.PineappleLib.fetchInfo.hash:1234567"
    )
    set(expected_src_apple_config_output
      "name:apple"
      "type:staticLib"
      "mainFile:src/apple/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "extDependencies:"
    )
    set(expected_src_banana_config_output
      "name:banana"
      "type:staticLib"
      "mainFile:src/banana/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "extDependencies:"
    )

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_regular.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/apple;src/banana")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

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

  ct_add_section(NAME "load_config_file_with_extras")
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
        "compileFeatures": ["cxx_std_20", "cxx_thread_local", "cxx_trailing_return_types"],
        "compileDefinitions": ["DEFINE_ONE=1", "DEFINE_TWO=2", "OPTION_1"],
        "compileOptions": ["-Wall", "-Wextra"],
        "linkOptions": ["-s", "-z"]
      },
      "mainFile": "src/main.cpp",
      "pchFile": "include/fruit_salad_pch.h",
      "headerPolicy": {
        "mode": "split",
        "includeDir": "include"
      },
      "extDependencies": {
        "AppleLib": {
          "rulesFile": "generic",
          "minVersion": "1.15.0",
          "integrationMethod": "FIND_AND_FETCH",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "fetchInfo": {
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
          "optional": false,
          "build": {
            "compileFeatures": ["cxx_std_20"],
            "compileDefinitions": ["DEFINE_ONE=1"],
            "compileOptions": ["-Wall"],
            "linkOptions": ["-s"]
          },
          "extraDepKey": "extraValue"
        },
        "BananaLib": {
          "rulesFile": "cmake/rules/RulesBananaLib.cmake",
          "minVersion": "4",
          "fetchInfo": {},
          "optional": true,
          "extraDepKey": "extraValue"
        },
        "CarrotLib": {
          "rulesFile": "cmake/rules/RulesCarrotLib.cmake",
          "fetchInfo": {
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "cmake/rules/RulesOrangeLib.cmake",
          "fetchInfo": {
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "cmake/rules/RulesPineappleLib.cmake",
          "fetchInfo": {
            "kind": "url",
            "repository": "https://example.com/PineappleLib.zip",
            "hash": "1234567"
          }
        }
      },
      "extraKey": "extraValue"
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
      "headerPolicy": {
        "mode": "merged"
      },
      "extDependencies": {}
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
      "headerPolicy": {
        "mode": "merged"
      },
      "extDependencies": {}
    }
  }
}]=]
    )
    set(expected_src_config_output
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
      "extDependencies.AppleLib.fetchInfo.kind:git"
      "extDependencies.AppleLib.fetchInfo.repository:https://github.com/lib/apple.git"
      "extDependencies.AppleLib.fetchInfo.tag:1234567"
      "extDependencies.AppleLib.build.compileFeatures:cxx_std_20"
      "extDependencies.AppleLib.build.compileDefinitions:DEFINE_ONE=1"
      "extDependencies.AppleLib.build.compileOptions:-Wall"
      "extDependencies.AppleLib.build.linkOptions:-s"
      "extDependencies.BananaLib.rulesFile:cmake/rules/RulesBananaLib.cmake"
      "extDependencies.BananaLib.minVersion:4"
      "extDependencies.BananaLib.optional:ON"
      "extDependencies.CarrotLib.rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "extDependencies.CarrotLib.fetchInfo.kind:svn"
      "extDependencies.CarrotLib.fetchInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "extDependencies.CarrotLib.fetchInfo.revision:1234567"
      "extDependencies.OrangeLib.rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "extDependencies.OrangeLib.fetchInfo.kind:mercurial"
      "extDependencies.OrangeLib.fetchInfo.repository:https://hg.example.com/RulesOrangeLib"
      "extDependencies.OrangeLib.fetchInfo.tag:1234567"
      "extDependencies.PineappleLib.rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "extDependencies.PineappleLib.fetchInfo.kind:url"
      "extDependencies.PineappleLib.fetchInfo.repository:https://example.com/PineappleLib.zip"
      "extDependencies.PineappleLib.fetchInfo.hash:1234567"
    )
    set(expected_src_apple_config_output
      "name:apple"
      "type:staticLib"
      "mainFile:src/apple/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "extDependencies:"
    )
    set(expected_src_banana_config_output
      "name:banana"
      "type:staticLib"
      "mainFile:src/banana/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "extDependencies:"
    )

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_extra.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/apple;src/banana")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_list(output_property)
    message("output_property            : ${output_property}")
    message("expected_src_config_output : ${expected_src_config_output}")
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
