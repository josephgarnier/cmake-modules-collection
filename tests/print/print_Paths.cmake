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
# Test of [Print module::PATHS operation]:
#    print([<mode>] PATHS [<file-path>...] [INDENT])
ct_add_test(NAME "test_print_paths_operation")
function(${CMAKETEST_TEST})
  include(Print)

  set(PRINT_BASE_DIR "${TESTS_DATA_DIR}")

  # Functionalities checking
  ct_add_section(NAME "print_empty_message")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print(PATHS)
      ct_assert_prints("")

      print(PATHS INDENT)
      ct_assert_prints("")

      print(PATHS "")
      ct_assert_prints("")

      print(PATHS "" INDENT)
      ct_assert_prints("")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS PATHS)
      ct_assert_prints("") # This function ignores the status

      print(STATUS PATHS INDENT)
      ct_assert_prints("") # This function ignores the status

      print(STATUS PATHS "")
      ct_assert_prints("") # This function ignores the status

      print(STATUS PATHS "" INDENT)
      ct_assert_prints("") # This function ignores the status
    endfunction()
  endfunction()

  ct_add_section(NAME "print_paths")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(input_paths
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      print(PATHS ${input_paths})
      ct_assert_prints("src/main.cpp, src/source_1.cpp, src/source_2.cpp, src/source_3.cpp, src/source_4.cpp, src/source_5.cpp, src/sub_1/source_sub_1.cpp, src/sub_2/source_sub_2.cpp")

      print(PATHS ${input_paths} INDENT)
      ct_assert_prints("src/main.cpp, src/source_1.cpp, src/source_2.cpp, src/source_3.cpp, src/source_4.cpp, src/source_5.cpp, src/sub_1/source_sub_1.cpp, src/sub_2/source_sub_2.cpp") # This function ignores the indentation
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(input_paths
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      print(STATUS PATHS ${input_paths})
      ct_assert_prints("src/main.cpp, src/source_1.cpp, src/source_2.cpp, src/source_3.cpp, src/source_4.cpp, src/source_5.cpp, src/sub_1/source_sub_1.cpp, src/sub_2/source_sub_2.cpp")

      print(STATUS PATHS ${input_paths} INDENT)
      ct_assert_prints("src/main.cpp, src/source_1.cpp, src/source_2.cpp, src/source_3.cpp, src/source_4.cpp, src/source_5.cpp, src/sub_1/source_sub_1.cpp, src/sub_2/source_sub_2.cpp") # This function ignores the indentation and the status
    endfunction()
  endfunction()

  # Errors checking
endfunction()
