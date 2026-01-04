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
# Test of [BinaryTarget module::ADD_LINK_LIBRARIES operation]:
#    binary_target(ADD_LINK_LIBRARIES <target-name> PUBLIC [<target-name>...|<gen-expr>...])
ct_add_test(NAME "test_binary_target_add_link_libraries_operation")
function(${CMAKETEST_TEST})
  include(BinaryTarget)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Create mock binary targets for tests
  add_mock_lib("new_static_mock_lib" STATIC SKIP_IF_EXISTS)
  add_mock_lib("dep_static_mock_lib_1" STATIC SKIP_IF_EXISTS)
  add_mock_lib("dep_static_mock_lib_2" STATIC SKIP_IF_EXISTS)
  add_mock_lib("new_shared_mock_lib" SHARED SKIP_IF_EXISTS)
  add_mock_lib("dep_shared_mock_lib_1" SHARED SKIP_IF_EXISTS)
  add_mock_lib("dep_shared_mock_lib_2" SHARED SKIP_IF_EXISTS)

  # Set global test variables
  set(new_static_mock_lib "${PROJECT_NAME}_new_static_mock_lib")
  set(dep_static_mock_lib_1 "${PROJECT_NAME}_dep_static_mock_lib_1")
  set(dep_static_mock_lib_2 "${PROJECT_NAME}_dep_static_mock_lib_2")
  set(new_shared_mock_lib "${PROJECT_NAME}_new_shared_mock_lib")
  set(dep_shared_mock_lib_1 "${PROJECT_NAME}_dep_shared_mock_lib_1")
  set(dep_shared_mock_lib_2 "${PROJECT_NAME}_dep_shared_mock_lib_2")

  # To call before each test
  macro(_set_up_test mock_target)
    # Reset properties used by `binary_target(ADD_LINK_LIBRARIES)`
    set_property(TARGET "${mock_target}" PROPERTY INTERFACE_LINK_LIBRARIES)
    set_property(TARGET "${mock_target}" PROPERTY LINK_LIBRARIES)
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "add_no_deps_1")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
      PUBLIC
    )
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      LINK_LIBRARIES)

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
      PUBLIC
    )
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      LINK_LIBRARIES)
  endfunction()

  ct_add_section(NAME "add_no_deps_2")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
      PUBLIC
        ""
    )
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_target_does_not_have_property("${new_static_mock_lib}"
      LINK_LIBRARIES)

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
      PUBLIC
        ""
    )
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_target_does_not_have_property("${new_shared_mock_lib}"
      LINK_LIBRARIES)
  endfunction()

  ct_add_section(NAME "add_with_target_name")
  function(${CMAKETEST_SECTION})
    _set_up_test("${new_static_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
      PUBLIC 
        "${dep_static_mock_lib_1}"
        "${dep_static_mock_lib_2}"
    )
    get_target_property(output_bin_property "${new_static_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_equal(output_bin_property "${dep_static_mock_lib_1};${dep_static_mock_lib_2}")
    get_target_property(output_bin_property "${new_static_mock_lib}"
      LINK_LIBRARIES)
    ct_assert_equal(output_bin_property "${dep_static_mock_lib_1};${dep_static_mock_lib_2}")

    _set_up_test("${new_shared_mock_lib}")
    binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
      PUBLIC
        "${dep_shared_mock_lib_1}"
        "${dep_shared_mock_lib_2}"
    )
    get_target_property(output_bin_property "${new_shared_mock_lib}"
      INTERFACE_LINK_LIBRARIES)
    ct_assert_equal(output_bin_property "${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}")
    get_target_property(output_bin_property "${new_shared_mock_lib}"
      LINK_LIBRARIES)
    ct_assert_equal(output_bin_property "${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}")
  endfunction()

  ct_add_section(NAME "add_with_gen_expr")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "add_all_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
        PUBLIC
          "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
          "$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>;$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>;$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )

      _set_up_test("${new_shared_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
        PUBLIC
          "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
          "$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>;$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>;$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
    endfunction()

    ct_add_section(NAME "add_build_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
        PUBLIC
          "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )

      _set_up_test("${new_shared_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
        PUBLIC
          "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<BUILD_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
    endfunction()

    ct_add_section(NAME "add_install_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${new_static_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_static_mock_lib}"
        PUBLIC
          "$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_static_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<INSTALL_INTERFACE:${dep_static_mock_lib_1};${dep_static_mock_lib_2}>"
      )

      _set_up_test("${new_shared_mock_lib}")
      binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}"
        PUBLIC
          "$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        INTERFACE_LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
      get_target_property(output_bin_property "${new_shared_mock_lib}"
        LINK_LIBRARIES)
      ct_assert_equal(output_bin_property
        "$<INSTALL_INTERFACE:${dep_shared_mock_lib_1};${dep_shared_mock_lib_2}>"
      )
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_LINK_LIBRARIES
      PUBLIC "${dep_shared_mock_lib_1}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_LINK_LIBRARIES ""
      PUBLIC "${dep_shared_mock_lib_1}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_LINK_LIBRARIES "unknown_target"
      PUBLIC "${dep_shared_mock_lib_1}")
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    binary_target(ADD_LINK_LIBRARIES "${new_shared_mock_lib}")
  endfunction()
endfunction()
