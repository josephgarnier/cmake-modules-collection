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
# Test of [BinaryTarget module::CREATE_FULLY operation]:
#   binary_target(CREATE_FULLY <target-name>
#                 <STATIC|SHARED|HEADER|EXEC>
#                 [COMPILE_FEATURES <feature>...]
#                 [COMPILE_DEFINITIONS <definition>...]
#                 [COMPILE_OPTIONS <option>...]
#                 [LINK_OPTIONS <option>...]
#                 SOURCE_FILES [<file-path>...]
#                 PRIVATE_HEADER_FILES [<file-path>...]
#                 PUBLIC_HEADER_FILES [<file-path>...]
#                 [PRECOMPILE_HEADER_FILE <file-path>]
#                 INCLUDE_DIRECTORIES [<dir-path>...|<gen-expr>...]
#                 [LINK_LIBRARIES [<target-name>...|<gen-expr>...] ])
ct_add_test(NAME "test_binary_target_create_fully_operation")
function(${CMAKETEST_TEST})
  include(BinaryTarget)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Create mock binary targets for tests
  add_mock_lib("dep_static_mock_lib_1" STATIC SKIP_IF_EXISTS)
  add_mock_lib("dep_static_mock_lib_2" STATIC SKIP_IF_EXISTS)
  add_mock_lib("dep_shared_mock_lib_1" SHARED SKIP_IF_EXISTS)
  add_mock_lib("dep_shared_mock_lib_2" SHARED SKIP_IF_EXISTS)

  # Set global test variables
  set(CMAKE_SOURCE_DIR "${TESTS_DATA_DIR}") # This var is used by binary_target(ADD_SOURCES) but CMakeTest change this value while it should be the same as the root of the sources.
  set(dep_static_mock_lib_1 "${PROJECT_NAME}_dep_static_mock_lib_1")
  set(dep_static_mock_lib_2 "${PROJECT_NAME}_dep_static_mock_lib_2")
  set(dep_shared_mock_lib_1 "${PROJECT_NAME}_dep_shared_mock_lib_1")
  set(dep_shared_mock_lib_2 "${PROJECT_NAME}_dep_shared_mock_lib_2")
  set(input_mixed_paths
    "../data/src/main.cpp"
    "../data/src"
    "${TESTS_DATA_DIR}/src/main.cpp"
    "${TESTS_DATA_DIR}/src"
    "../data/fake/directory/file.cpp"
    "../data/fake/directory"
    "${TESTS_DATA_DIR}/fake/directory/file.cpp"
    "${TESTS_DATA_DIR}/fake/directory")
  set(input_pch_header "${TESTS_DATA_DIR}/include/include_pch.h")
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

  # Functionalities checking
  ct_add_section(NAME "create_bin_target_with_all_args")
  function(${CMAKETEST_SECTION})
    # LINK_OPTIONS is not set, because link options cannot be added to a static library
    binary_target(CREATE_FULLY "new_static_mock_lib_1" STATIC
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_static_mock_lib_1}" "${dep_static_mock_lib_2}"
    )

    binary_target(CREATE_FULLY "new_shared_mock_lib_1" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "create_bin_target_with_no_values")
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_static_mock_lib_2" STATIC
      SOURCE_FILES
      PRIVATE_HEADER_FILES
      PUBLIC_HEADER_FILES
      INCLUDE_DIRECTORIES
      LINK_LIBRARIES
    )
    target_sources("${PROJECT_NAME}_new_static_mock_lib_2" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

    binary_target(CREATE_FULLY "new_shared_mock_lib_2" SHARED
      SOURCE_FILES
      PRIVATE_HEADER_FILES
      PUBLIC_HEADER_FILES
      INCLUDE_DIRECTORIES
      LINK_LIBRARIES
    )
    target_sources("${PROJECT_NAME}_new_shared_mock_lib_2" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
  endfunction()

  ct_add_section(NAME "create_bin_target_with_empty_values")
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_static_mock_lib_3" STATIC
      SOURCE_FILES ""
      PRIVATE_HEADER_FILES ""
      PUBLIC_HEADER_FILES ""
      INCLUDE_DIRECTORIES ""
      LINK_LIBRARIES ""
    )
    target_sources("${PROJECT_NAME}_new_static_mock_lib_3" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

    binary_target(CREATE_FULLY "new_shared_mock_lib_3" SHARED
      SOURCE_FILES ""
      PRIVATE_HEADER_FILES ""
      PUBLIC_HEADER_FILES ""
      INCLUDE_DIRECTORIES ""
      LINK_LIBRARIES ""
    )
    target_sources("${PROJECT_NAME}_new_shared_mock_lib_3" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
  endfunction()

  ct_add_section(NAME "create_bin_target_with_less_args")
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_static_mock_lib_4" STATIC
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
    )

    binary_target(CREATE_FULLY "new_shared_mock_lib_4" SHARED
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
    )
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_already_exists" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    add_mock_lib("new_shared_mock_lib_5" SHARED)
    binary_target(CREATE_FULLY "new_shared_mock_lib_5" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_alias_already_exists" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    add_mock_lib("new_shared_mock_lib_6" SHARED)
    add_library("${PROJECT_NAME}::new_shared_mock_lib_7" ALIAS "${PROJECT_NAME}_new_shared_mock_lib_6")
    binary_target(CREATE_FULLY "new_shared_mock_lib_7" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_8"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_twice" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_9" STATIC SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_features_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_10" SHARED
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_definition_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_11" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_options_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_12" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_link_options_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_13" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_link_options_are_added_to_static_lib" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_static_mock_lib_5" STATIC
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(CMAKE_CXX_STANDARD)
    binary_target(CREATE_FULLY "new_shared_mock_lib_14" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(CMAKE_CXX_STANDARD "")
    binary_target(CREATE_FULLY "new_shared_mock_lib_15" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_source_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_16" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_private_header_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_17" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_header_files_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_18" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_pch_header_file_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_19" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_pch_header_file_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_20" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ""
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_pch_header_file_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_21" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE "${TESTS_DATA_DIR}/fake/directory/file.cpp"
      INCLUDE_DIRECTORIES ${input_mixed_paths}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_include_directories_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CREATE_FULLY "new_shared_mock_lib_22" SHARED
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
      SOURCE_FILES ${input_sources}
      PRIVATE_HEADER_FILES ${input_private_headers}
      PUBLIC_HEADER_FILES ${input_public_headers}
      PRECOMPILE_HEADER_FILE ${input_pch_header}
      LINK_LIBRARIES "${dep_shared_mock_lib_1}" "${dep_shared_mock_lib_2}"
    )
  endfunction()
endfunction()
