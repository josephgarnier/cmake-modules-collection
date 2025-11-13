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
# Test of [Dependency module::ADD_INCLUDE_DIRECTORIES operation]:
#    dependency(ADD_INCLUDE_DIRECTORIES <lib-target-name>
#              <SET|APPEND>
#              PUBLIC <gen-expr>...)
ct_add_test(NAME "test_dependency_add_include_directories_operation")
function(${CMAKETEST_TEST})
  include(Dependency)
  include(${TESTS_DATA_DIR}/cmake/Common.cmake)

  # Simulate a call to `dependency(IMPORT)`
  string(TOUPPER "${CMAKE_BUILD_TYPE}" cmake_build_type_upper)
  set(build_type_suffix "")
  if("${cmake_build_type_upper}" STREQUAL "DEBUG")
    set(build_type_suffix "d")
  endif()
  import_mock_lib("imp_static_mock_lib" "static_mock_lib${build_type_suffix}"
    STATIC SKIP_IF_EXISTS)
  import_mock_lib("imp_shared_mock_lib" "shared_mock_lib${build_type_suffix}"
    SHARED SKIP_IF_EXISTS)

  # To call before each test
  macro(_set_up_test)
    # Set to empty the properties changed by `dependency(ADD_INCLUDE_DIRECTORIES)`
    set_target_properties("imp_static_mock_lib" PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ""
      INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
    )
    set_target_properties("imp_shared_mock_lib" PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ""
      INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
    )

  endmacro()

  # Functionalities checking
  ct_add_section(NAME "overwrite_all_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_equal(output_lib_property "include")

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_equal(output_lib_property "include")
  endfunction()

  ct_add_section(NAME "overwrite_build_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
    )
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    ct_assert_target_does_not_have_property("imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    get_property(output_lib_property TARGET "imp_static_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL SET)
    ct_assert_true(output_lib_property)

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
    )
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
    ct_assert_target_does_not_have_property("imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    get_property(output_lib_property TARGET "imp_shared_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL SET)
    ct_assert_true(output_lib_property)
  endfunction()

  ct_add_section(NAME "overwrite_install_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<INSTALL_INTERFACE:include>"
    )
    ct_assert_target_does_not_have_property("imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    get_property(output_lib_property TARGET "imp_static_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    get_property(output_lib_property TARGET "imp_static_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_equal(output_lib_property "include")

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<INSTALL_INTERFACE:include>"
    )
    ct_assert_target_does_not_have_property("imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    get_property(output_lib_property TARGET "imp_shared_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    get_property(output_lib_property TARGET "imp_shared_mock_lib"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_equal(output_lib_property "include")
  endfunction()
  
  ct_add_section(NAME "append_all_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" APPEND
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-2>"
        "$<INSTALL_INTERFACE:include-2>"
    )
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1;include-2")

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" APPEND
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-2>"
        "$<INSTALL_INTERFACE:include-2>"
    )
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1;include-2")
  endfunction()

  ct_add_section(NAME "append_build_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" APPEND
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-2>"
    )
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1")

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" APPEND
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-2>"
    )
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1;${TESTS_DATA_DIR}/include-2")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1")
  endfunction()

  ct_add_section(NAME "append_install_interfaces")
  function(${CMAKETEST_SECTION})
    _set_up_test()
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_static_mock_lib" APPEND
      PUBLIC
        "$<INSTALL_INTERFACE:include-2>"
    )
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1")
    get_target_property(output_lib_property "imp_static_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1;include-2")

    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include-1>"
        "$<INSTALL_INTERFACE:include-1>"
    )
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" APPEND
      PUBLIC
        "$<INSTALL_INTERFACE:include-2>"
    )
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    ct_assert_not_list(output_lib_property)
    ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include-1")
    get_target_property(output_lib_property "imp_shared_mock_lib"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    ct_assert_list(output_lib_property)
    ct_assert_equal(output_lib_property "include-1;include-2")
  endfunction()
  
  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "unknown_target" SET
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_modifier_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib"
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_modifier_is_twice" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET APPEND
      PUBLIC
        "$<BUILD_INTERFACE:${TESTS_DATA_DIR}/include>"
        "$<INSTALL_INTERFACE:include>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC
    )
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_public_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(ADD_INCLUDE_DIRECTORIES "imp_shared_mock_lib" SET
      PUBLIC ""
    )
  endfunction()
endfunction()
