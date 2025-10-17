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
# Test of [Directory module::SCAN operation]:
#    directory(SCAN <output-list-var>
#             LIST_DIRECTORIES <on|off>
#             RELATIVE <on|off>
#             ROOT_DIR <dir-path>
#             <INCLUDE_REGEX|EXCLUDE_REGEX> <regular-expression>)
ct_add_test(NAME "test_directory_scan_operation")
function(${CMAKETEST_TEST})
  include(Directory)

  # Functionalities checking
  ct_add_section(NAME "list_all")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_1.h"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_2.h"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_3.h"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_4.h"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/source_5.h"
        "${TESTS_DATA_DIR}/src/sub_1"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.h"
        "${TESTS_DATA_DIR}/src/sub_2"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.h")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE off
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "main.cpp"
        "source_1.cpp"
        "source_1.h"
        "source_2.cpp"
        "source_2.h"
        "source_3.cpp"
        "source_3.h"
        "source_4.cpp"
        "source_4.h"
        "source_5.cpp"
        "source_5.h"
        "sub_1"
        "sub_1/source_sub_1.cpp"
        "sub_1/source_sub_1.h"
        "sub_2"
        "sub_2/source_sub_2.cpp"
        "sub_2/source_sub_2.h")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE on
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  ct_add_section(NAME "list_only_files")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "get_absolute_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_1.h"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_2.h"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_3.h"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_4.h"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/source_5.h"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.h"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.h")
      directory(SCAN output
        LIST_DIRECTORIES off
        RELATIVE off
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        INCLUDE_REGEX ".*"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "main.cpp"
        "source_1.cpp"
        "source_1.h"
        "source_2.cpp"
        "source_2.h"
        "source_3.cpp"
        "source_3.h"
        "source_4.cpp"
        "source_4.h"
        "source_5.cpp"
        "source_5.h"
        "sub_1/source_sub_1.cpp"
        "sub_1/source_sub_1.h"
        "sub_2/source_sub_2.cpp"
        "sub_2/source_sub_2.h")
      directory(SCAN output
        LIST_DIRECTORIES off
        RELATIVE on
        ROOT_DIR "${TESTS_DATA_DIR}/src"
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
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE off
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        INCLUDE_REGEX ".*[.]cpp$|.*[.]cc$|.*[.]cxx$"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "main.cpp"
        "source_1.cpp"
        "source_2.cpp"
        "source_3.cpp"
        "source_4.cpp"
        "source_5.cpp"
        "sub_1/source_sub_1.cpp"
        "sub_2/source_sub_2.cpp")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE on
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        INCLUDE_REGEX ".*[.]cpp$|.*[.]cc$|.*[.]cxx$"
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
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE off
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        EXCLUDE_REGEX ".*[.]h$|.*[.]hpp$|.*[.]hxx$|.*[.]inl$|.*[.]tpp$"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()

    ct_add_section(NAME "get_relative_path")
    function(${CMAKETEST_SECTION})
      set(expected_output
        "main.cpp"
        "source_1.cpp"
        "source_2.cpp"
        "source_3.cpp"
        "source_4.cpp"
        "source_5.cpp"
        "sub_1"
        "sub_1/source_sub_1.cpp"
        "sub_2"
        "sub_2/source_sub_2.cpp")
      directory(SCAN output
        LIST_DIRECTORIES on
        RELATIVE on
        ROOT_DIR "${TESTS_DATA_DIR}/src"
        EXCLUDE_REGEX ".*[.]h$|.*[.]hpp$|.*[.]hxx$|.*[.]inl$|.*[.]tpp$"
      )
      ct_assert_list(output)
      ct_assert_equal(output "${expected_output}")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN ""
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN "output"
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_list_directories_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_list_directories_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_list_directories_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES ""
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_list_directories_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES "wrong"
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_relative_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE ""
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_relative_is_not_bool" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE "wrong"
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR ""
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "fake/directory"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_root_dir_is_not_a_diretory" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
      INCLUDE_REGEX ".*"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_regex_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    directory(SCAN output
      LIST_DIRECTORIES on
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/src"
      INCLUDE_REGEX ""
    )
  endfunction()
endfunction()
