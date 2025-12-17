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
# Test of [FileManip module::GET_COMPONENT operation]:
#    file_manip(GET_COMPONENT [<file-path>...]
#               MODE <mode>
#               OUTPUT_VARIABLE <output-list-var>)
ct_add_test(NAME "test_file_manip_get_component_operation")
function(${CMAKETEST_TEST})
  include(FileManip)

  # Functionalities checking
  ct_add_section(NAME "directory_mode")
  function(${CMAKETEST_SECTION})
    file_manip(GET_COMPONENT MODE DIRECTORY OUTPUT_VARIABLE output)
    ct_assert_string(output)
    ct_assert_equal(output "")

    file_manip(GET_COMPONENT "" MODE DIRECTORY OUTPUT_VARIABLE output)
    ct_assert_string(output)
    ct_assert_equal(output "")

    set(input_mixed_paths
      "../data/src/main.cpp"
      "../data/src"
      "${TESTS_DATA_DIR}/src/main.cpp"
      "${TESTS_DATA_DIR}/src"
      "../data/fake/directory/file.cpp"
      "../data/fake/directory"
      "${TESTS_DATA_DIR}/fake/directory/file.cpp"
      "${TESTS_DATA_DIR}/fake/directory")
    set(expected_output
      "../data/src"
      "../data"
      "${TESTS_DATA_DIR}/src"
      "${TESTS_DATA_DIR}"
      "../data/fake/directory"
      "../data/fake"
      "${TESTS_DATA_DIR}/fake/directory"
      "${TESTS_DATA_DIR}/fake")
    file_manip(GET_COMPONENT ${input_mixed_paths} MODE DIRECTORY OUTPUT_VARIABLE output)
    ct_assert_list(output)
    ct_assert_equal(output "${expected_output}")
  endfunction()

  ct_add_section(NAME "name_mode")
  function(${CMAKETEST_SECTION})
    file_manip(GET_COMPONENT MODE NAME OUTPUT_VARIABLE output)
    ct_assert_string(output)
    ct_assert_equal(output "")

    file_manip(GET_COMPONENT "" MODE NAME OUTPUT_VARIABLE output)
    ct_assert_string(output)
    ct_assert_equal(output "")

    set(input_mixed_paths
      "../data/src/main.cpp"
      "../data/src"
      "${TESTS_DATA_DIR}/src/main.cpp"
      "${TESTS_DATA_DIR}/src"
      "../data/fake/directory/file.cpp"
      "../data/fake/directory"
      "${TESTS_DATA_DIR}/fake/directory/file.cpp"
      "${TESTS_DATA_DIR}/fake/directory")
    set(expected_output
      "main.cpp"
      "src"
      "main.cpp"
      "src"
      "file.cpp"
      "directory"
      "file.cpp"
      "directory")
    file_manip(GET_COMPONENT ${input_mixed_paths} MODE NAME OUTPUT_VARIABLE output)
    ct_assert_list(output)
    ct_assert_equal(output "${expected_output}")
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_mode_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" OUTPUT_VARIABLE output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_mode_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE "" OUTPUT_VARIABLE output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_mode_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE "mode" OUTPUT_VARIABLE output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_mode_is_wrong" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE FAKE OUTPUT_VARIABLE output)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE DIRECTORY)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE "output")
  endfunction()
endfunction()
