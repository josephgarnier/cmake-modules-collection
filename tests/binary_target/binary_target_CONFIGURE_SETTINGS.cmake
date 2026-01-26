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
# Test of [BinaryTarget module::CONFIGURE_SETTINGS operation]:
#   binary_target(CONFIGURE_SETTINGS <target-name>
#                 COMPILE_FEATURES [<feature>...]
#                 COMPILE_DEFINITIONS [<definition>...]
#                 COMPILE_OPTIONS [<option>...]
#                 LINK_OPTIONS [<option>...])
ct_add_test(NAME "test_binary_target_configure_settings_operation")
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
    # Reset properties used by `binary_target(CONFIGURE_SETTINGS)`
    set_property(TARGET "${mock_target}" PROPERTY COMPILE_FEATURES)
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_COMPILE_FEATURES)
    set_property(TARGET "${mock_target}" PROPERTY COMPILE_DEFINITIONS)
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_COMPILE_DEFINITIONS)
    set_property(TARGET "${mock_target}" PROPERTY COMPILE_OPTIONS)
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_COMPILE_OPTIONS)
    set_property(TARGET "${mock_target}" PROPERTY LINK_OPTIONS)
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_LINK_OPTIONS)
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "configure_all_with_no_values")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
      COMPILE_FEATURES
      COMPILE_DEFINITIONS
      COMPILE_OPTIONS
      LINK_OPTIONS
    )
    get_target_property(output_bin_property "${new_static_mock_lib}"
      COMPILE_FEATURES)
    ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_FEATURES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      LINK_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_LINK_OPTIONS)

    _set_up_test("${new_shared_mock_lib}")
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES
      COMPILE_DEFINITIONS
      COMPILE_OPTIONS
      LINK_OPTIONS
    )
    get_target_property(output_bin_property "${new_shared_mock_lib}"
      COMPILE_FEATURES)
    ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_FEATURES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      LINK_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_LINK_OPTIONS)
  endfunction()

  ct_add_section(NAME "configure_all_with_empty_values")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    # Link options cannot be added to a static library
    binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
      COMPILE_FEATURES ""
      COMPILE_DEFINITIONS ""
      COMPILE_OPTIONS ""
      LINK_OPTIONS
    )
    get_target_property(output_bin_property "${new_static_mock_lib}"
      COMPILE_FEATURES)
    ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_FEATURES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      LINK_OPTIONS)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_LINK_OPTIONS)

    _set_up_test("${new_shared_mock_lib}")
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES ""
      COMPILE_DEFINITIONS ""
      COMPILE_OPTIONS ""
      LINK_OPTIONS ""
    )
    get_target_property(output_bin_property "${new_shared_mock_lib}"
      COMPILE_FEATURES)
    ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_FEATURES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_DEFINITIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_COMPILE_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      LINK_OPTIONS)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_LINK_OPTIONS)
  endfunction()

  ct_add_section(NAME "configure_all_with_filled_values")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "add_all_settings")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      # Link options cannot be added to a static library
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
        COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS "-Wall" "-Wextra"
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_trailing_return_types;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        LINK_OPTIONS)
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_LINK_OPTIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
        COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS "-Wall" "-Wextra"
        LINK_OPTIONS "-s" "-z"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_trailing_return_types;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-s;-z")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_LINK_OPTIONS)
    endfunction()

    ct_add_section(NAME "append_all_settings")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      # Link options cannot be added to a static library
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS "DEFINE_ONE=1"
        COMPILE_OPTIONS "-Wall"
        LINK_OPTIONS
      )
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_trailing_return_types"
        COMPILE_DEFINITIONS "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS "-Wextra"
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD};cxx_trailing_return_types")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        LINK_OPTIONS)
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_LINK_OPTIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS "DEFINE_ONE=1"
        COMPILE_OPTIONS "-Wall"
        LINK_OPTIONS "-s"
      )
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_trailing_return_types"
        COMPILE_DEFINITIONS "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS "-Wextra"
        LINK_OPTIONS "-z"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD};cxx_trailing_return_types")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-s;-z")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_LINK_OPTIONS)
    endfunction()
  endfunction()

  ct_add_section(NAME "configure_compile_features")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "cxx_standard_is_set_automatically")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()

    ct_add_section(NAME "cxx_standard_is_set_by_user_first")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_std_${CMAKE_CXX_STANDARD}"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_std_${CMAKE_CXX_STANDARD}"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()

    ct_add_section(NAME "cxx_standard_is_set_by_user_second")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_std_${CMAKE_CXX_STANDARD}"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_std_${CMAKE_CXX_STANDARD}"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()

    ct_add_section(NAME "cxx_standard_is_restored_after_deletion")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      # Delete C++ standard
      set_property(TARGET "${new_static_mock_lib}" PROPERTY COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      # Delete C++ standard again
      set_property(TARGET "${new_static_mock_lib}" PROPERTY COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      # Delete C++ standard
      set_property(TARGET "${new_shared_mock_lib}" PROPERTY COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
      # Delete C++ standard again
      set_property(TARGET "${new_shared_mock_lib}" PROPERTY COMPILE_FEATURES)
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()

    ct_add_section(NAME "add_compile_features")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_trailing_return_types;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_trailing_return_types;cxx_std_${CMAKE_CXX_STANDARD}")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()

    ct_add_section(NAME "append_compile_features")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES "cxx_trailing_return_types"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD};cxx_trailing_return_types")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_FEATURES)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_thread_local"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES "cxx_trailing_return_types"
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_FEATURES)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "cxx_thread_local;cxx_std_${CMAKE_CXX_STANDARD};cxx_trailing_return_types")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_FEATURES)
    endfunction()
  endfunction()

  ct_add_section(NAME "configure_compile_definitions")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "add_compile_definitions")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
    endfunction()

    ct_add_section(NAME "append_compile_definitions")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_ONE=1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_ONE=1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS "DEFINE_TWO=2" "OPTION_1"
        COMPILE_OPTIONS ""
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_DEFINITIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "DEFINE_ONE=1;DEFINE_TWO=2;OPTION_1")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_DEFINITIONS)
    endfunction()
  endfunction()

  ct_add_section(NAME "configure_compile_options")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "add_compile_options")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wall" "-Wextra"
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wall" "-Wextra"
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
    endfunction()

    ct_add_section(NAME "append_compile_options")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wall"
        LINK_OPTIONS
      )
      binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wextra"
        LINK_OPTIONS
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_static_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)

      _set_up_test("${new_shared_mock_lib}")
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wall"
        LINK_OPTIONS ""
      )
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS "-Wextra"
        LINK_OPTIONS ""
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        COMPILE_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-Wall;-Wextra")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_COMPILE_OPTIONS)
    endfunction()
  endfunction()

  ct_add_section(NAME "configure_link_options")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "add_link_options")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_shared_mock_lib}")
      # Link options cannot be added to a static library
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS "-s" "-z"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-s;-z")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_LINK_OPTIONS)
    endfunction()

    ct_add_section(NAME "append_link_options")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_shared_mock_lib}")
      # Link options cannot be added to a static library
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS "-s"
      )
      binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
        COMPILE_FEATURES ""
        COMPILE_DEFINITIONS ""
        COMPILE_OPTIONS ""
        LINK_OPTIONS "-z"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_OPTIONS)
      ct_assert_list(output_bin_property)
      ct_assert_equal(output_bin_property "-s;-z")
      ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
        INTERFACE_LINK_OPTIONS)
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS ""
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "unknown_target"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_features_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_definitions_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_compile_options_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_link_options_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
    )
  endfunction()

  ct_add_section(NAME "throws_if_link_options_are_added_to_static_lib_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS ""
    )
  endfunction()

  ct_add_section(NAME "throws_if_link_options_are_added_to_static_lib_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(CONFIGURE_SETTINGS "${new_static_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(CMAKE_CXX_STANDARD)
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()

  ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(CMAKE_CXX_STANDARD "")
    binary_target(CONFIGURE_SETTINGS "${new_shared_mock_lib}"
      COMPILE_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
      COMPILE_DEFINITIONS "DEFINE_ONE=1" "DEFINE_TWO=2" "OPTION_1"
      COMPILE_OPTIONS "-Wall" "-Wextra"
      LINK_OPTIONS "-s" "-z"
    )
  endfunction()
endfunction()
