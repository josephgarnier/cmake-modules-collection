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
# Test of [Directory module::SCAN_DIRS operation]:
#    directory(SCAN_DIRS <output-list-var>
#              RECURSE <true|false>
#              RELATIVE <true|false>
#              ROOT_DIR <dir-path>
#              <INCLUDE_REGEX|EXCLUDE_REGEX> <regular-expression>)
ct_add_test(NAME "test_directory_scan_dirs_operation")
function(${CMAKETEST_TEST})
  include(Directory)

  # Functionalities checking
  ct_add_section(NAME "list_recursively")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/bin"
        "${TESTS_DATA_DIR}/cmake"
        "${TESTS_DATA_DIR}/config"
        "${TESTS_DATA_DIR}/include"
        "${TESTS_DATA_DIR}/src"
        "${TESTS_DATA_DIR}/src/sub_1"
        "${TESTS_DATA_DIR}/src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE false
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "bin"
        "cmake"
        "config"
        "include"
        "src"
        "src/sub_1"
        "src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE true
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "list_non_recursively")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/bin"
        "${TESTS_DATA_DIR}/cmake"
        "${TESTS_DATA_DIR}/config"
        "${TESTS_DATA_DIR}/include"
        "${TESTS_DATA_DIR}/src")
      directory(SCAN_DIRS output
        RECURSE false
        RELATIVE false
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "bin"
        "cmake"
        "config"
        "include"
        "src")
      directory(SCAN_DIRS output
        RECURSE false
        RELATIVE true
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "list_filtered_with_include_regex")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/src"
        "${TESTS_DATA_DIR}/src/sub_1"
        "${TESTS_DATA_DIR}/src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE false
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX "src"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "src"
        "src/sub_1"
        "src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE true
        ROOT_DIR "${TESTS_DATA_DIR}"
        INCLUDE_REGEX "src"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "list_filtered_with_exclude_regex")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/src"
        "${TESTS_DATA_DIR}/src/sub_1"
        "${TESTS_DATA_DIR}/src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE false
        ROOT_DIR "${TESTS_DATA_DIR}"
        EXCLUDE_REGEX "bin|cmake|config|include"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "src"
        "src/sub_1"
        "src/sub_2")
      directory(SCAN_DIRS output
        RECURSE true
        RELATIVE true
        ROOT_DIR "${TESTS_DATA_DIR}"
        EXCLUDE_REGEX "bin|cmake|config|include"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS ""
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS "output"
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_recurse_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_recurse_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_recurse_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE ""
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_recurse_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE "wrong"
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE ""
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE "wrong"
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR ""
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "fake/directory"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_not_a_diretory" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ""
    )
  endfunction()
  ct_add_section(NAME "throws_if_arg_regex_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      EXCLUDE_REGEX
    )
  endfunction()
  ct_add_section(NAME "throws_if_arg_regex_is_missing_5" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      EXCLUDE_REGEX ""
    )
  endfunction()
  ct_add_section(NAME "throws_if_arg_regex_is_twice" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN_DIRS output
      RECURSE true
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*" EXCLUDE_REGEX ".*"
    )
  endfunction()
endfunction()
