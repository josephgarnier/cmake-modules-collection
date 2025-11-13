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
#    binary_target(ADD_INCLUDE_DIRECTORIES <target-name> INCLUDE_DIRECTORIES [<dir-path>...])
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
  set(input_public_header_dir "${TESTS_DATA_DIR}/include")

  # Functionalities checking
  ct_add_section(NAME "add_no_dir")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib" INCLUDE_DIRECTORIES "")
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)

    binary_target(ADD_INCLUDE_DIRECTORIES "new_shared_mock_lib" INCLUDE_DIRECTORIES "")
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
  endfunction()

  ct_add_section(NAME "add_header_dirs")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib" INCLUDE_DIRECTORIES "${input_public_header_dir}")
    get_target_property(output_bin_property "new_static_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_string(output_bin_property)
    ct_assert_equal(output_bin_property "${input_public_header_dir}")
    ct_assert_target_does_not_have_property("new_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)

    binary_target(ADD_INCLUDE_DIRECTORIES "new_shared_mock_lib" INCLUDE_DIRECTORIES "${input_public_header_dir}")
    get_target_property(output_bin_property "new_shared_mock_lib"
      INCLUDE_DIRECTORIES)
    ct_assert_string(output_bin_property)
    ct_assert_equal(output_bin_property "${input_public_header_dir}")
    ct_assert_target_does_not_have_property("new_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES INCLUDE_DIRECTORIES "${input_public_header_dir}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "" INCLUDE_DIRECTORIES "${input_public_header_dir}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "unknown_target" INCLUDE_DIRECTORIES "${input_public_header_dir}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_directories_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib")
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_directories_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_INCLUDE_DIRECTORIES "new_static_mock_lib" INCLUDE_DIRECTORIES)
  endfunction()
endfunction()
