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
# Test of [BinaryTarget module::ADD_SOURCES operation]:
#   binary_target(ADD_SOURCES <target-name>
#                 SOURCE_FILES [<file-path>...]
#                 PRIVATE_HEADER_FILES [<file-path>...]
#                 PUBLIC_HEADER_FILES [<file-path>...])
ct_add_test(NAME "test_binary_target_add_sources_operation")
function(${CMAKETEST_TEST})
  include(BinaryTarget)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Create mock binary targets for tests
  add_mock_lib("new_static_mock_lib" STATIC SKIP_IF_EXISTS)
  add_mock_lib("new_shared_mock_lib" SHARED SKIP_IF_EXISTS)

  # Set global test variables
  set(new_static_mock_lib "${PROJECT_NAME}_new_static_mock_lib")
  set(new_shared_mock_lib "${PROJECT_NAME}_new_shared_mock_lib")

  # To call before each test
  macro(_set_up_test mock_target)
    # Reset properties used by `binary_target(ADD_SOURCES)`
    set_property(TARGET "${mock_target}" PROPERTY SOURCES)
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_SOURCES)
  endmacro()

  # Set global test variables
  set(CMAKE_SOURCE_DIR "${TESTS_DATA_DIR}") # This var is used by binary_target(ADD_SOURCES) but CMakeTest change this value while it should be the same as the root of the sources.
  set(input_sources
    "${TESTS_DATA_DIR}/src/main.cpp"
    "${TESTS_DATA_DIR}/src/source_1.cpp"
    "${TESTS_DATA_DIR}/src/source_2.cpp"
    "${TESTS_DATA_DIR}/src/source_3.cpp"
    "${TESTS_DATA_DIR}/src/source_4.cpp"
    "${TESTS_DATA_DIR}/src/source_5.cpp"
    "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
    "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
  set(input_private_headers
    "${TESTS_DATA_DIR}/src/source_1.h"
    "${TESTS_DATA_DIR}/src/source_2.h"
    "${TESTS_DATA_DIR}/src/source_3.h"
    "${TESTS_DATA_DIR}/src/source_4.h"
    "${TESTS_DATA_DIR}/src/source_5.h"
    "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.h"
    "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.h")
  set(input_public_headers
    "${TESTS_DATA_DIR}/include/include_1.h"
    "${TESTS_DATA_DIR}/include/include_2.h"
    "${TESTS_DATA_DIR}/include/include_pch.h")
  set(input_mixed_paths
    "../data/src/main.cpp"
    "../data/src"
    "${TESTS_DATA_DIR}/src/main.cpp"
    "${TESTS_DATA_DIR}/src"
    "../data/fake/directory/file.cpp"
    "../data/fake/directory"
    "${TESTS_DATA_DIR}/fake/directory/file.cpp"
    "${TESTS_DATA_DIR}/fake/directory")

  # Functionalities checking
  ct_add_section(NAME "add_no_file_1")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_SOURCES "${new_static_mock_lib}"
      SOURCE_FILES
      PRIVATE_HEADER_FILES
      PUBLIC_HEADER_FILES
    )
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      SOURCES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_SOURCES)
    target_sources("${new_static_mock_lib}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES
      PRIVATE_HEADER_FILES
      PUBLIC_HEADER_FILES
    )
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      SOURCES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_SOURCES)
    target_sources("${new_shared_mock_lib}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
  endfunction()

  ct_add_section(NAME "add_no_file_2")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_SOURCES "${new_static_mock_lib}"
      SOURCE_FILES ""
      PRIVATE_HEADER_FILES ""
      PUBLIC_HEADER_FILES ""
    )
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      SOURCES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_SOURCES)
    target_sources("${new_static_mock_lib}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ""
      PRIVATE_HEADER_FILES ""
      PUBLIC_HEADER_FILES ""
    )
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      SOURCES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_SOURCES)
    target_sources("${new_shared_mock_lib}" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
  endfunction()

  ct_add_section(NAME "add_source_and_header_files")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_SOURCES "${new_static_mock_lib}"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
    get_target_property(output_bin_property "${new_static_mock_lib}"
      SOURCES)
    ct_assert_list(output_bin_property)
    ct_assert_equal(output_bin_property "${input_sources};${input_private_headers};${input_public_headers}")
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_SOURCES)

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
    get_target_property(output_bin_property "${new_shared_mock_lib}"
      SOURCES)
    ct_assert_list(output_bin_property)
    ct_assert_equal(output_bin_property "${input_sources};${input_private_headers};${input_public_headers}")
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_SOURCES)
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES ""
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "unknown_target"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_source_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_source_files_contains_nonexistent_files" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_mixed_paths}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_private_header_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_sources}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_private_header_files_contains_nonexistent_files" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_mixed_paths}
      PUBLIC_HEADER_FILES ${input_public_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_header_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_header_files_contains_nonexistent_files" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_SOURCES "${new_shared_mock_lib}"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_mixed_paths}
    )
  endfunction()
endfunction()
