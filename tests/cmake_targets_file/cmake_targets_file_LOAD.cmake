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
      "dependencies": {
        "AppleLib": {
          "rulesFile": "generic",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "minVersion": "1.15.0",
          "fetchInfo": {
            "autodownload": true,
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
          "optional": false,
          "configuration": {
            "compileFeatures": ["cxx_std_20"],
            "compileDefinitions": ["DEFINE_ONE=1"],
            "compileOptions": ["-Wall"],
            "linkOptions": ["-s"]
          }
        },
        "BananaLib": {
          "rulesFile": "RulesBananaLib.cmake",
          "minVersion": "4",
          "fetchInfo": {
            "autodownload": false
          },
          "optional": true
        },
        "CarrotLib": {
          "rulesFile": "RulesCarrotLib.cmake",
          "fetchInfo": {
            "autodownload": true,
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "RulesOrangeLib.cmake",
          "fetchInfo": {
            "autodownload": true,
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "RulesPineappleLib.cmake",
          "fetchInfo": {
            "autodownload": true,
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
      "dependencies.AppleLib.configuration.compileFeatures:cxx_std_20"
      "dependencies.AppleLib.configuration.compileDefinitions:DEFINE_ONE=1"
      "dependencies.AppleLib.configuration.compileOptions:-Wall"
      "dependencies.AppleLib.configuration.linkOptions:-s"
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
      "dependencies:"
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
      "dependencies:"
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
      "dependencies": {
        "AppleLib": {
          "rulesFile": "generic",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "minVersion": "1.15.0",
          "fetchInfo": {
            "autodownload": true,
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
          "optional": false,
          "configuration": {
            "compileFeatures": ["cxx_std_20"],
            "compileDefinitions": ["DEFINE_ONE=1"],
            "compileOptions": ["-Wall"],
            "linkOptions": ["-s"]
          },
          "extraDepKey": "extraValue"
        },
        "BananaLib": {
          "rulesFile": "RulesBananaLib.cmake",
          "minVersion": "4",
          "fetchInfo": {
            "autodownload": false
          },
          "optional": true,
          "extraDepKey": "extraValue"
        },
        "CarrotLib": {
          "rulesFile": "RulesCarrotLib.cmake",
          "fetchInfo": {
            "autodownload": true,
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "RulesOrangeLib.cmake",
          "fetchInfo": {
            "autodownload": true,
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "RulesPineappleLib.cmake",
          "fetchInfo": {
            "autodownload": true,
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
      "dependencies.AppleLib.configuration.compileFeatures:cxx_std_20"
      "dependencies.AppleLib.configuration.compileDefinitions:DEFINE_ONE=1"
      "dependencies.AppleLib.configuration.compileOptions:-Wall"
      "dependencies.AppleLib.configuration.linkOptions:-s"
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
      "dependencies:"
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
      "dependencies:"
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
