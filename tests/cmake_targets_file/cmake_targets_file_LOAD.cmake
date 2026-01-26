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
#   cmake_targets_file(LOAD <json-file-path>)
ct_add_test(NAME "test_cmake_targets_file_load_operation")
function(${CMAKETEST_TEST})
  include(CMakeTargetsFile)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `cmake_targets_file(LOAD)`
    set_property(GLOBAL PROPERTY TARGETS_CONFIG_RAW_JSON)
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
  ct_add_section(NAME "load_regular_config_file")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    # The JSON comparison is space sensitive, so the indentation does not be changed
    set(expected_raw_json_output
[=[{
  "$schema": "../../../cmake/modules/schema.json",
  "$id": "schema.json",
  "externalDeps": {
    "remotes": {
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
    },
    "vendoredBinaries": {},
    "vendoredSources": {}
  },
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
      "dependencies": ["grape", "lemon", "AppleLib", "BananaLib", "CarrotLib", "OrangeLib", "PineappleLib"]
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
      "dependencies": []
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
      "dependencies": []
    }
  }
}]=]
    )
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

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_regular.json")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_apple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_banana_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_carrot_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_orange_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_pineapple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/grape;src/lemon")

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

  ct_add_section(NAME "load_extra_config_file")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    # The JSON comparison is space sensitive, so the indentation does not be changed
    set(expected_raw_json_output
[=[{
  "$schema": "../../../cmake/modules/schema.json",
  "$id": "schema.json",
  "externalDeps": {
    "remotes": {
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
    "vendoredBinaries": {},
    "vendoredSources": {}
  },
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
      "dependencies": ["grape", "lemon", "AppleLib", "BananaLib", "CarrotLib", "OrangeLib", "PineappleLib"],
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
      "dependencies": []
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
      "dependencies": []
    }
  }
}]=]
    )
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

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_extra.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_apple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_banana_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_carrot_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_orange_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_pineapple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/grape;src/lemon")

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

  ct_add_section(NAME "load_minimal_config_file")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    # The JSON comparison is space sensitive, so the indentation does not be changed
    set(expected_raw_json_output
[=[{
  "$schema": "../../../cmake/modules/schema.json",
  "$id": "schema.json",
  "externalDeps": {
    "remotes": {
      "AppleLib": {
        "rulesFile": "generic",
        "optional": false,
        "minVersion": "1.15.0",
        "integrationMethod": "FIND_THEN_FETCH",
        "packageLocation": {},
        "downloadInfo": {
          "kind": "git",
          "repository": "https://github.com/lib/apple.git",
          "tag": ""
        },
        "build": {
          "compileFeatures": [],
          "compileDefinitions": [],
          "compileOptions": [],
          "linkOptions": []
        }
      },
      "BananaLib": {
        "rulesFile": "generic",
        "optional": false,
        "minVersion": "1.15.0",
        "integrationMethod": "EXTERNAL_PROJECT",
        "downloadInfo": {
          "kind": "git",
          "repository": "https://github.com/lib/banana.git",
          "tag": ""
        },
        "build": {
          "compileFeatures": [],
          "compileDefinitions": [],
          "compileOptions": [],
          "linkOptions": []
        }
      },
      "CarrotLib": {
        "rulesFile": "generic",
        "optional": false,
        "minVersion": "1.15.0",
        "integrationMethod": "FETCH_CONTENT",
        "downloadInfo": {
          "kind": "git",
          "repository": "https://github.com/lib/carrot.git",
          "tag": ""
        },
        "build": {
          "compileFeatures": [],
          "compileDefinitions": [],
          "compileOptions": [],
          "linkOptions": []
        }
      },
      "OrangeLib": {
        "rulesFile": "generic",
        "optional": false,
        "minVersion": "1.15.0",
        "integrationMethod": "FIND_PACKAGE",
        "packageLocation": {},
        "build": {
          "compileFeatures": [],
          "compileDefinitions": [],
          "compileOptions": [],
          "linkOptions": []
        }
      },
      "PineappleLib": {
        "rulesFile": "cmake/rules/RulesPineappleLib.cmake"
      }
    },
    "vendoredBinaries": {},
    "vendoredSources": {}
  },
  "targets": {
    "src": {
      "name": "fruit-salad",
      "type": "executable",
      "build": {
        "compileFeatures": [],
        "compileDefinitions": [],
        "compileOptions": [],
        "linkOptions": []
      },
      "mainFile": "src/main.cpp",
      "pchFile": "include/fruit_salad_pch.h",
      "headerPolicy": {
        "mode": "split",
        "includeDir": "include"
      },
      "dependencies": []
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
      "dependencies": []
    }
  }
}]=]
    )
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

    cmake_targets_file(LOAD "${TESTS_DATA_DIR}/config/CMakeTargets_minimal.json")
    
    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_RAW_JSON")
    ct_assert_string(output_property)
    ct_assert_equal(output_property "${expected_raw_json_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
    ct_assert_string(output_property)
    ct_assert_true(output_property)
    ct_assert_equal(output_property "true")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_REMOTE_DEPS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "AppleLib;BananaLib;CarrotLib;OrangeLib;PineappleLib")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_AppleLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_apple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_BananaLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_banana_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_CarrotLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_carrot_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_OrangeLib")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_orange_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_DEP_PineappleLib")
    ct_assert_not_list(output_property)
    ct_assert_equal(output_property "${expected_pineapple_lib_dep_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_TARGETS")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "src;src/grape")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_config_output}")

    get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_src/grape")
    ct_assert_list(output_property)
    ct_assert_equal(output_property "${expected_src_grape_config_output}")
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
