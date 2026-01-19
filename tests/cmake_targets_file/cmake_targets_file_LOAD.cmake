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
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    set_property(GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon")
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
      "externalDeps": {
        "AppleLib": {
          "rulesFile": "generic",
          "optional": false,
          "minVersion": "1.15.0",
          "integrationMethod": "FIND_THEN_FETCH",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "downloadInfo": {
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
          "build": {
            "compileFeatures": ["cxx_std_20"],
            "compileDefinitions": ["DEFINE_ONE=1"],
            "compileOptions": ["-Wall"],
            "linkOptions": ["-s"]
          }
        },
        "BananaLib": {
          "rulesFile": "cmake/rules/RulesBananaLib.cmake",
          "optional": true,
          "minVersion": "4",
          "downloadInfo": {}
        },
        "CarrotLib": {
          "rulesFile": "cmake/rules/RulesCarrotLib.cmake",
          "downloadInfo": {
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "cmake/rules/RulesOrangeLib.cmake",
          "downloadInfo": {
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "cmake/rules/RulesPineappleLib.cmake",
          "downloadInfo": {
            "kind": "url",
            "repository": "https://example.com/PineappleLib.zip",
            "hash": "1234567"
          }
        }
      }
    },
    "src/grape": {
      "name": "grape",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/grape/main.cpp",
      "headerPolicy": {
        "mode": "merged"
      },
      "externalDeps": {}
    },
    "src/lemon": {
      "name": "lemon",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/lemon/main.cpp",
      "headerPolicy": {
        "mode": "merged"
      },
      "externalDeps": {}
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
      "externalDeps.BananaLib.rulesFile:cmake/rules/RulesBananaLib.cmake"
      "externalDeps.BananaLib.optional:ON"
      "externalDeps.BananaLib.minVersion:4"
      "externalDeps.CarrotLib.rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "externalDeps.CarrotLib.downloadInfo.kind:svn"
      "externalDeps.CarrotLib.downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "externalDeps.CarrotLib.downloadInfo.revision:1234567"
      "externalDeps.OrangeLib.rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "externalDeps.OrangeLib.downloadInfo.kind:mercurial"
      "externalDeps.OrangeLib.downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
      "externalDeps.OrangeLib.downloadInfo.tag:1234567"
      "externalDeps.PineappleLib.rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "externalDeps.PineappleLib.downloadInfo.kind:url"
      "externalDeps.PineappleLib.downloadInfo.repository:https://example.com/PineappleLib.zip"
      "externalDeps.PineappleLib.downloadInfo.hash:1234567"
    )
    set(expected_src_grape_config_output
      "name:grape"
      "type:staticLib"
      "mainFile:src/grape/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "externalDeps:"
    )
    set(expected_src_lemon_config_output
      "name:lemon"
      "type:staticLib"
      "mainFile:src/lemon/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "externalDeps:"
    )

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_regular.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/grape;src/lemon")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_grape_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_lemon_config_output}")
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
      "externalDeps": {
        "AppleLib": {
          "rulesFile": "generic",
          "optional": false,
          "minVersion": "1.15.0",
          "integrationMethod": "FIND_THEN_FETCH",
          "packageLocation": {
            "windows": "C:/Program Files/libs/apple/1.15.0",
            "unix": "/opt/apple/1.15.0",
            "macos": "/opt/apple/1.15.0"
          },
          "downloadInfo": {
            "kind": "git",
            "repository": "https://github.com/lib/apple.git",
            "tag": "1234567"
          },
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
          "optional": true,
          "minVersion": "4",
          "downloadInfo": {},
          "extraDepKey": "extraValue"
        },
        "CarrotLib": {
          "rulesFile": "cmake/rules/RulesCarrotLib.cmake",
          "downloadInfo": {
            "kind": "svn",
            "repository": "svn://svn.carrot.lib.org/links/trunk",
            "revision": "1234567"
          }
        },
        "OrangeLib": {
          "rulesFile": "cmake/rules/RulesOrangeLib.cmake",
          "downloadInfo": {
            "kind": "mercurial",
            "repository": "https://hg.example.com/RulesOrangeLib",
            "tag": "1234567"
          }
        },
        "PineappleLib": {
          "rulesFile": "cmake/rules/RulesPineappleLib.cmake",
          "downloadInfo": {
            "kind": "url",
            "repository": "https://example.com/PineappleLib.zip",
            "hash": "1234567"
          }
        }
      },
      "extraKey": "extraValue"
    },
    "src/grape": {
      "name": "grape",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/grape/main.cpp",
      "headerPolicy": {
        "mode": "merged"
      },
      "externalDeps": {}
    },
    "src/lemon": {
      "name": "lemon",
      "type": "staticLib",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/lemon/main.cpp",
      "headerPolicy": {
        "mode": "merged"
      },
      "externalDeps": {}
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
      "externalDeps.BananaLib.rulesFile:cmake/rules/RulesBananaLib.cmake"
      "externalDeps.BananaLib.optional:ON"
      "externalDeps.BananaLib.minVersion:4"
      "externalDeps.CarrotLib.rulesFile:cmake/rules/RulesCarrotLib.cmake"
      "externalDeps.CarrotLib.downloadInfo.kind:svn"
      "externalDeps.CarrotLib.downloadInfo.repository:svn://svn.carrot.lib.org/links/trunk"
      "externalDeps.CarrotLib.downloadInfo.revision:1234567"
      "externalDeps.OrangeLib.rulesFile:cmake/rules/RulesOrangeLib.cmake"
      "externalDeps.OrangeLib.downloadInfo.kind:mercurial"
      "externalDeps.OrangeLib.downloadInfo.repository:https://hg.example.com/RulesOrangeLib"
      "externalDeps.OrangeLib.downloadInfo.tag:1234567"
      "externalDeps.PineappleLib.rulesFile:cmake/rules/RulesPineappleLib.cmake"
      "externalDeps.PineappleLib.downloadInfo.kind:url"
      "externalDeps.PineappleLib.downloadInfo.repository:https://example.com/PineappleLib.zip"
      "externalDeps.PineappleLib.downloadInfo.hash:1234567"
    )
    set(expected_src_grape_config_output
      "name:grape"
      "type:staticLib"
      "mainFile:src/grape/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "externalDeps:"
    )
    set(expected_src_lemon_config_output
      "name:lemon"
      "type:staticLib"
      "mainFile:src/lemon/main.cpp"
      "build.compileFeatures:"
      "build.compileDefinitions:"
      "build.compileOptions:"
      "build.linkOptions:"
      "headerPolicy.mode:merged"
      "externalDeps:"
    )

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_extra.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LIST")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/grape;src/lemon")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_list(output_property)
    message("output_property            : ${output_property}")
    message("expected_src_config_output : ${expected_src_config_output}")
    ct_assert_equal(output_property "${expected_src_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_grape_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/lemon")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_lemon_config_output}")
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
