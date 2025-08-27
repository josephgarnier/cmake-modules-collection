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
#              [CONFIGURATION <config_type>]
#              PUBLIC <gen-expr>...)
ct_add_test(NAME "test_dependency_set_imported_location_operation")
function(${CMAKETEST_TEST})
  include(Dependency)

  # Simulate a call to `dependency(IMPORT)`
  macro(_import_mock_libs)
    include(Directory)
    string(TOUPPER "${CMAKE_BUILD_TYPE}" cmake_build_type_upper)

    # Import static lib
    add_library("imp_static_mock_lib" STATIC IMPORTED)
    set(lib_base_filename "static_mock_lib")
    if("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_base_filename "static_mock_libd")
    endif()
    set_target_properties("imp_static_mock_lib" PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${TESTS_DATA_DIR}/include"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
    )
    directory(FIND_LIB lib_file_path
      FIND_IMPLIB implib_file_path
      NAME "${lib_base_filename}"
      STATIC
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
    if(NOT implib_file_path)
      set(implib_file_path "")
    endif()

    cmake_path(GET lib_file_path FILENAME lib_file_name)
    set_target_properties("imp_static_mock_lib" PROPERTIES
      IMPORTED_LOCATION_${cmake_build_type_upper} "${lib_file_path}"
      IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} ""
      IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} ""
      IMPORTED_IMPLIB_${cmake_build_type_upper} "${implib_file_path}"
      IMPORTED_SONAME_${cmake_build_type_upper} "${lib_file_name}"
    )
    set_property(TARGET "imp_static_mock_lib"
      APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
    )

    # Import shared lib
    add_library("imp_shared_mock_lib" SHARED IMPORTED)
    set(lib_base_filename "shared_mock_lib")
    if("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_base_filename "shared_mock_libd")
    endif()
    set_target_properties("imp_shared_mock_lib" PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${TESTS_DATA_DIR}/include"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD ""
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL ""
    )
    directory(FIND_LIB lib_file_path
      FIND_IMPLIB implib_file_path
      NAME "${lib_base_filename}"
      SHARED
      RELATIVE off
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
    cmake_path(GET lib_file_path FILENAME lib_file_name)
    set_target_properties("imp_shared_mock_lib" PROPERTIES
      IMPORTED_LOCATION_${cmake_build_type_upper} "${lib_file_path}"
      IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} ""
      IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} ""
      IMPORTED_IMPLIB_${cmake_build_type_upper} "${implib_file_path}"
      IMPORTED_SONAME_${cmake_build_type_upper} "${lib_file_name}"
    )
    set_property(TARGET "imp_shared_mock_lib"
      APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
    )
  endmacro()
  if(NOT TARGET "imp_static_mock_lib" OR NOT TARGET "imp_shared_mock_lib")
    _import_mock_libs()
  endif()

  # Set global test variables
  get_target_property(static_lib_file_path "imp_static_mock_lib"
    IMPORTED_LOCATION_${cmake_build_type_upper})
  get_target_property(static_lib_file_name "imp_static_mock_lib"
    IMPORTED_SONAME_${cmake_build_type_upper})
  get_target_property(shared_lib_file_path "imp_shared_mock_lib"
    IMPORTED_LOCATION_${cmake_build_type_upper})
  get_target_property(shared_lib_file_name "imp_shared_mock_lib"
    IMPORTED_SONAME_${cmake_build_type_upper})

  # To call before each test
  macro(_set_up_test)
    # Set to empty the properties changed by `dependency(SET_IMPORTED_LOCATION)`
    set_target_properties("imp_static_mock_lib" PROPERTIES
      IMPORTED_LOCATION_RELEASE ""
      IMPORTED_LOCATION_BUILD_RELEASE ""
      IMPORTED_LOCATION_INSTALL_RELEASE ""
      IMPORTED_LOCATION_DEBUG ""
      IMPORTED_LOCATION_BUILD_DEBUG ""
      IMPORTED_LOCATION_INSTALL_DEBUG ""
    )
    set_target_properties("imp_shared_mock_lib" PROPERTIES
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
      _set_up_test()
      set_target_properties("imp_static_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "")
      dependency(SET_IMPORTED_LOCATION "imp_static_mock_lib"
        PUBLIC
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "")
      dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
        PUBLIC
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()
    
    ct_add_section(NAME "all_build_type")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_target_properties("imp_static_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_static_mock_lib"
        PUBLIC
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
    
      set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
        PUBLIC
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
    endfunction()
  endfunction()

  ct_add_section(NAME "set_to_specified_configuration")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "set_all_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_target_properties("imp_static_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_static_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)

      set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()

    ct_add_section(NAME "set_build_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_target_properties("imp_static_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_static_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<BUILD_INTERFACE:${static_lib_file_path}>"
      )
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${static_lib_file_path}")
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<BUILD_INTERFACE:${shared_lib_file_path}>"
      )
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      ct_assert_equal(output_lib_property "${shared_lib_file_path}")
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()

    ct_add_section(NAME "set_install_interfaces")
    function(${CMAKETEST_SECTION})
      _set_up_test()
      set_target_properties("imp_static_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_static_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<INSTALL_INTERFACE:lib/${static_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      get_target_property(output_lib_property "imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${static_lib_file_name}")
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_static_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_static_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    
      set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "RELEASE;DEBUG")
      dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
        CONFIGURATION "RELEASE"
        PUBLIC
          "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
      )
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_RELEASE SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_RELEASE)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_RELEASE SET)
      ct_assert_true(output_lib_property)
      get_target_property(output_lib_property "imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_RELEASE)
      ct_assert_equal(output_lib_property "lib/${shared_lib_file_name}")
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_BUILD_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_BUILD_DEBUG SET)
      ct_assert_true(output_lib_property)
      ct_assert_target_does_not_have_property("imp_shared_mock_lib"
        IMPORTED_LOCATION_INSTALL_DEBUG)
      get_property(output_lib_property TARGET "imp_shared_mock_lib"
        PROPERTY IMPORTED_LOCATION_INSTALL_DEBUG SET)
      ct_assert_true(output_lib_property)
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION
      CONFIGURATION "RELEASE"
      PUBLIC
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION ""
      CONFIGURATION "RELEASE"
      PUBLIC
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "unknown_target"
      CONFIGURATION "RELEASE"
      PUBLIC
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_configuration_is_unsupported" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set_target_properties("imp_shared_mock_lib" PROPERTIES
        IMPORTED_CONFIGURATIONS "DEBUG")
    dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
      CONFIGURATION "RELEASE"
      PUBLIC
        "$<BUILD_INTERFACE:${shared_lib_file_path}>"
        "$<INSTALL_INTERFACE:lib/${shared_lib_file_name}>"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
      CONFIGURATION "RELEASE"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
      CONFIGURATION "RELEASE"
      PUBLIC
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_public_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(SET_IMPORTED_LOCATION "imp_shared_mock_lib"
      CONFIGURATION "RELEASE"
      PUBLIC ""
    )
  endfunction()
endfunction()
