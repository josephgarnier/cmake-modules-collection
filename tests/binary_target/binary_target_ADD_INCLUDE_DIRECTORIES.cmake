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
# Test of [BinaryTarget module::ADD_INCLUDE_DIRECTORIES operation]:
#    binary_target(ADD_INCLUDE_DIRECTORIES <target-name> PRIVATE [<dir-path>...|<gen-expr>...])
ct_add_test(NAME "test_binary_target_add_include_directories_operation")
function(${CMAKETEST_TEST})
  include(BinaryTarget)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Create mock binary targets for tests
  add_mock_lib("new_static_mock_lib" STATIC SKIP_IF_EXISTS)
  add_mock_lib("new_shared_mock_lib" SHARED SKIP_IF_EXISTS)

  # To call before each test
  macro(_set_up_test)
    # Reset properties used by `binary_target(ADD_INCLUDE_DIRECTORIES)`
    set_property(TARGET "new_static_mock_lib" PROPERTY INCLUDE_DIRECTORIES)
    set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_INCLUDE_DIRECTORIES)

    set_property(TARGET "new_shared_mock_lib" PROPERTY INCLUDE_DIRECTORIES)
    set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
  endmacro()

  # Set global test variables
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
    "${CMAKE_CURRENT_SOURCE_DIR}/../data/src/main.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../data/src"
    "${TESTS_DATA_DIR}/src/main.cpp"
    "${TESTS_DATA_DIR}/src"
    "${CMAKE_CURRENT_SOURCE_DIR}/../data/fake/directory/file.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/../data/fake/directory"
    "${TESTS_DATA_DIR}/fake/directory/file.cpp"
    "${TESTS_DATA_DIR}/fake/directory")

  # Functionalities checking
  ct_add_section(NAME "add_no_dir_1")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib"
      PRIVATE
    )
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)

    binary_target(ADD_INCLUDE_DIRECTORIES "new_shared_mock_lib"
      PRIVATE
    )
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
  endfunction()

  ct_add_section(NAME "add_no_dir_2")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib"
      PRIVATE ""
    )
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)

    binary_target(ADD_INCLUDE_DIRECTORIES "new_shared_mock_lib"
      PRIVATE ""
    )
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
  endfunction()

  ct_add_section(NAME "add_header_dirs")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib"
      PRIVATE ${input_mixed_paths}
    )
    get_target_property(output_bin_property "new_static_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_list(output_bin_property)
    ct_assert_equal(output_bin_property "${expected_output}")
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)

    binary_target(ADD_INCLUDE_DIRECTORIES "new_shared_mock_lib"
      PRIVATE ${input_mixed_paths}
    )
    get_target_property(output_bin_property "new_shared_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_list(output_bin_property)
    ct_assert_equal(output_bin_property "${expected_output}")
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES
      PRIVATE
        ${input_mixed_paths}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES ""
      PRIVATE
        ${input_mixed_paths}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "unknown_target"
      PRIVATE
        ${input_mixed_paths}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_private_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib")
  endfunction()
endfunction()
