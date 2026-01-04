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
# Test of [Dependency module::IMPORTED_LOCATION operation]:
#    dependency(SET_IMPORTED_LOCATION <lib-target-name>
#               [CONFIGURATION <config_type>]
#               INTERFACE <gen-expr>...)
ct_add_test(NAME "test_dependency_set_imported_location_operation")
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

  # Set global test variables
  set(static_target_fullname "${PROJECT_NAME}_imp_static_mock_lib")
  set(shared_target_fullname "${PROJECT_NAME}_imp_shared_mock_lib")
  get_target_property(static_lib_file_path "${static_target_fullname}"
    IMPORTED_LOCATION_${cmake_build_type_upper})
  get_target_property(static_lib_file_name "${static_target_fullname}"
    IMPORTED_SONAME_${cmake_build_type_upper})
  get_target_property(shared_lib_file_path "${shared_target_fullname}"
    IMPORTED_LOCATION_${cmake_build_type_upper})
  get_target_property(shared_lib_file_name "${shared_target_fullname}"
    IMPORTED_SONAME_${cmake_build_type_upper})

  # To call before each test
  macro(_set_up_test imported_target)
    # Set to empty the properties changed by `dependency(SET_IMPORTED_LOCATION)`
    set_target_properties("${imported_target}" PROPERTIES
      IMPORTED_LOCATION_RELEASE ""
      IMPORTED_LOCATION_BUILD_RELEASE ""
      IMPORTED_LOCATION_INSTALL_RELEASE ""
      IMPORTED_LOCATION_DEBUG ""
      IMPORTED_LOCATION_BUILD_DEBUG ""
      IMPORTED_LOCATION_INSTALL_DEBUG ""
    )
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "set_to_default_configuration")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "no_build_type")
    function(${CMAKETEST_SECTION})
      _set_up_test("${static_target_fullname}")
      set_target_properties("${static_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "")
      dependency(SET_IMPORTED_LOCATION "${static_target_fullname}"
        INTERFACE
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      _set_up_test("${shared_target_fullname}")
      set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "")
      dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
        INTERFACE
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()
    
    ct_add_section(NAME "all_build_type")
    function(${CMAKETEST_SECTION})
      _set_up_test("${static_target_fullname}")
      set_target_properties("${static_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${static_target_fullname}"
        INTERFACE
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
    
      _set_up_test("${shared_target_fullname}")
      set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
        INTERFACE
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
    endfunction()
  endfunction()

  ct_add_section(NAME "set_to_specified_configuration")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "set_all_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${static_target_fullname}")
      set_target_properties("${static_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${static_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)

      _set_up_test("${shared_target_fullname}")
      set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()

    ct_add_section(NAME "set_build_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${static_target_fullname}")
      set_target_properties("${static_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${static_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
      )
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      _set_up_test("${shared_target_fullname}")
      set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
      )
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()

    ct_add_section(NAME "set_install_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test("${static_target_fullname}")
      set_target_properties("${static_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${static_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      get_target_property(output_lib_property "${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${static_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${static_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      _set_up_test("${shared_target_fullname}")
      set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
        CONFIGURATION "RELEASE"
        INTERFACE
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      get_target_property(output_lib_property "${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("${shared_target_fullname}"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "${shared_target_fullname}"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION
      CONFIGURATION "RELEASE"
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION ""
      CONFIGURATION "RELEASE"
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "unknown_target"
      CONFIGURATION "RELEASE"
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_configuration_is_unsupported" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set_target_properties("${shared_target_fullname}" PROPERTIES
        IMPORTED_CONFIGURATIONS "DEBUG")
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION "RELEASE"
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_configuration_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_configuration_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION ""
      INTERFACE
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_interface_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION "RELEASE"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_interface_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION "RELEASE"
      INTERFACE
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_interface_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "${shared_target_fullname}"
      CONFIGURATION "RELEASE"
      INTERFACE ""
    )
  endfunction()
endfunction()
