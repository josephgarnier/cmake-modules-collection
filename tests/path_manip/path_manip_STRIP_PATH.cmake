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
# Test of [PathManip module::STRIP_PATH operation]:
#    path_manip(STRIP_PATH <file-list-var>
#               BASE_DIR <dir-path>
#               [OUTPUT_VARIABLE <output-list-var>])
ct_add_test(NAME "test_path_manip_strip_path_operation")
function(${CMAKETEST_TEST})
  include(PathManip)

  # Functionalities checking
  ct_add_section(NAME "inplace_version")
  function(${CMAKETEST_SECTION})
    set(input "")
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
    ct_assert_string(input)
    ct_assert_equal(input "")

    set(input_mixed_paths
      "../data/src/main.cpp"
      "../data/src"
      "${TESTS_DATA_DIR}/src/main.cpp"
      "${TESTS_DATA_DIR}/src"
      "../data/fake/directory/file.cpp"
      "../data/fake/directory"
      "${TESTS_DATA_DIR}/fake/directory/file.cpp"
      "${TESTS_DATA_DIR}/fake/directory")
    set(expected_result
      "../data/src/main.cpp"
      "../data/src"
      "src/main.cpp"
      "src"
      "../data/fake/directory/file.cpp"
      "../data/fake/directory"
      "fake/directory/file.cpp"
      "fake/directory")
    path_manip(STRIP_PATH input_mixed_paths BASE_DIR "${TESTS_DATA_DIR}")
    ct_assert_list(input_mixed_paths)
    ct_assert_equal(input_mixed_paths "${expected_result}")
  endfunction()

  ct_add_section(NAME "output_version")
  function(${CMAKETEST_SECTION})
    set(input "")
    unset(output)
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
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
    set(expected_result
      "../data/src/main.cpp"
      "../data/src"
      "src/main.cpp"
      "src"
      "../data/fake/directory/file.cpp"
      "../data/fake/directory"
      "fake/directory/file.cpp"
      "fake/directory")
    unset(output)
    path_manip(STRIP_PATH input_mixed_paths BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
    ct_assert_list(output)
    ct_assert_equal(output "${expected_result}")
  endfunction()

  ct_add_section(NAME "strip_with_different_and_nonexistent_base_dir")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "inplace_version")
    function(${CMAKETEST_SECTION})
      set(input "${TESTS_DATA_DIR}/src/main.cpp")
      path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake/directory")
      ct_assert_string(input)
      ct_assert_equal(input "${TESTS_DATA_DIR}/src/main.cpp")
    endfunction()

    ct_add_section(NAME "output_version")
    function(${CMAKETEST_SECTION})
      set(input "${TESTS_DATA_DIR}/src/main.cpp")
      unset(output)
      path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake/directory" OUTPUT_VARIABLE output)
      ct_assert_string(output)
      ct_assert_equal(output "${TESTS_DATA_DIR}/src/main.cpp")
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    path_manip(STRIP_PATH BASE_DIR "${TESTS_DATA_DIR}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    path_manip(STRIP_PATH "" BASE_DIR "${TESTS_DATA_DIR}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    path_manip(STRIP_PATH "intput" BASE_DIR "${TESTS_DATA_DIR}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input)
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_base_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input)
  endfunction()

  ct_add_section(NAME "throws_if_arg_base_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input BASE_DIR)
  endfunction()

  ct_add_section(NAME "throws_if_arg_base_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input BASE_DIR "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "${TESTS_DATA_DIR}/src/main.cpp")
    path_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE "output")
  endfunction()
endfunction()
