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
# Test of [Print module::REL_PATHS operation]:
#   print([<mode>] REL_PATHS [<file-path>...] [INDENT])
ct_add_test(NAME "test_print_paths_operation")
function(${CMAKETEST_TEST})
  include(Print)

  set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")

  # Functionalities checking
  ct_add_section(NAME "print_empty_message")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print(REL_PATHS)
      ct_assert_prints("")

      print(REL_PATHS INDENT)
      ct_assert_prints("")

      print(REL_PATHS "")
      ct_assert_prints("")

      print(REL_PATHS "" INDENT)
      ct_assert_prints("")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS REL_PATHS)
      ct_assert_prints("")

      print(STATUS REL_PATHS INDENT)
      ct_assert_prints("")

      print(STATUS REL_PATHS "")
      ct_assert_prints("")

      print(STATUS REL_PATHS "" INDENT)
      ct_assert_prints("")
    endfunction()
  endfunction()

  ct_add_section(NAME "print_paths")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(input_mixed_paths
        "../data/src/main.cpp"
        "../data/src"
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src"
        "../data/fake/directory/file.cpp"
        "../data/fake/directory"
        "${TESTS_DATA_DIR}/fake/directory/file.cpp"
        "${TESTS_DATA_DIR}/fake/directory")
      print(REL_PATHS ${input_mixed_paths})
      ct_assert_prints("../data/src/main.cpp, ../data/src, ../data/src/main.cpp, ../data/src, ../data/fake/directory/file.cpp, ../data/fake/directory, ../data/fake/directory/file.cpp, ../data/fake/directory")

      print(REL_PATHS ${input_mixed_paths} INDENT)
      ct_assert_prints("../data/src/main.cpp, ../data/src, ../data/src/main.cpp, ../data/src, ../data/fake/directory/file.cpp, ../data/fake/directory, ../data/fake/directory/file.cpp, ../data/fake/directory")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(input_mixed_paths
        "../data/src/main.cpp"
        "../data/src"
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src"
        "../data/fake/directory/file.cpp"
        "../data/fake/directory"
        "${TESTS_DATA_DIR}/fake/directory/file.cpp"
        "${TESTS_DATA_DIR}/fake/directory")
      print(STATUS REL_PATHS ${input_mixed_paths})
      ct_assert_prints("../data/src/main.cpp, ../data/src, ../data/src/main.cpp, ../data/src, ../data/fake/directory/file.cpp, ../data/fake/directory, ../data/fake/directory/file.cpp, ../data/fake/directory")

      print(STATUS REL_PATHS ${input_mixed_paths} INDENT)
      ct_assert_prints("../data/src/main.cpp, ../data/src, ../data/src/main.cpp, ../data/src, ../data/fake/directory/file.cpp, ../data/fake/directory, ../data/fake/directory/file.cpp, ../data/fake/directory")
    endfunction()
  endfunction()

  # Errors checking
endfunction()
