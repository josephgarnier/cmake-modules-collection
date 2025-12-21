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
# Test of [Dependency module::IMPORT operation]:
#    dependency(IMPORT <lib-target-name>
#               TYPE <STATIC|SHARED>
#               FIND_ROOT_DIR <dir-path>
#               [FIND_RELEASE_FILE <lib-file-basename>]
#               [FIND_DEBUG_FILE <lib-file-basename>])
ct_add_test(NAME "test_dependency_import_operation")
function(${CMAKETEST_TEST})
  include(Dependency)
  string(TOUPPER "${CMAKE_BUILD_TYPE}" cmake_build_type_upper)

  # To call before each test
  macro(_set_up_test imported_target)
    # Unset the result vars returned by `dependency(IMPORT)`
    unset("${imported_target}_LIBRARY_RELEASE")
    unset("${imported_target}_LIBRARY_DEBUG")
    unset("${imported_target}_IMP_LIBRARY_RELEASE")
    unset("${imported_target}_IMP_LIBRARY_DEBUG")
    unset("${imported_target}_LIBRARY")
    unset("${imported_target}_LIBRARIES")
    unset("${imported_target}_ROOT_DIR")
    unset("${imported_target}_FOUND")
    unset("${imported_target}_FOUND_RELEASE")
    unset("${imported_target}_FOUND_DEBUG")
  endmacro()

  # Functionalities checking
  ct_add_section(NAME "import_static_lib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_static_mock_lib-1")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "static_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "static_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      STATIC
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
    cmake_path(GET expected_lib_file_path FILENAME expected_lib_file_name)

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE STATIC
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
    ct_assert_target_exists("${lib_target_name}")
    ct_assert_target_exists("${lib_target_name}::${lib_target_name}")
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_LOCATION_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "${expected_lib_file_path}")
    ct_assert_target_does_not_have_property("${lib_target_name}"
      IMPORTED_LOCATION_BUILD_${cmake_build_type_upper})
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper})
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      IMPORTED_IMPLIB_${cmake_build_type_upper})
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_IMPLIB_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "")
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY IMPORTED_IMPLIB_${cmake_build_type_upper} SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_SONAME_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "${expected_lib_file_name}")
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_CONFIGURATIONS)
    ct_assert_equal(output_lib_property "${cmake_build_type_upper}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" true)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" true)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${expected_lib_file_path}")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${expected_lib_file_path}")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin")
    ct_assert_equal("${lib_target_name}_FOUND" true)
  endfunction()

  ct_add_section(NAME "import_nonexistent_static_lib_and_implib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_static_mock_lib-2")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "fake_static_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "fake_static_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      STATIC
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE STATIC
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
    ct_assert_target_does_not_exist("${lib_target_name}")
    ct_assert_target_does_not_exist("${lib_target_name}::${lib_target_name}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${lib_target_name}_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" false)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${lib_target_name}_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" false)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin")
    ct_assert_equal("${lib_target_name}_FOUND" false)
  endfunction()

  ct_add_section(NAME "import_nonexistent_static_lib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_static_mock_lib-3")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "static_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "static_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    file(COPY "${TESTS_DATA_DIR}/bin/"
      DESTINATION "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib")
    set(lib_file_name
      "${CMAKE_STATIC_LIBRARY_PREFIX}${lib_file_basename}${CMAKE_STATIC_LIBRARY_SUFFIX}")
    file(REMOVE "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib/${lib_file_name}")

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      STATIC
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib"
    )

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE STATIC
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib"
      ${dep_import_find_args}
    )
    ct_assert_target_does_not_exist("${lib_target_name}")
    ct_assert_target_does_not_exist("${lib_target_name}::${lib_target_name}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${lib_target_name}_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" false)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${lib_target_name}_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" false)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib")
    ct_assert_equal("${lib_target_name}_FOUND" false)
    file(REMOVE_RECURSE "${TESTS_DATA_DIR}/bin_import_nonexistent_static_lib")
  endfunction()

  ct_add_section(NAME "import_shared_lib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_shared_mock_lib-1")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "shared_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "shared_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      SHARED
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
    cmake_path(GET expected_lib_file_path FILENAME expected_lib_file_name)

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
    ct_assert_target_exists("${lib_target_name}")
    ct_assert_target_exists("${lib_target_name}::${lib_target_name}")
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES_BUILD)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_BUILD SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      INTERFACE_INCLUDE_DIRECTORIES_INSTALL)
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY INTERFACE_INCLUDE_DIRECTORIES_INSTALL SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_LOCATION_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "${expected_lib_file_path}")
    ct_assert_target_does_not_have_property("${lib_target_name}"
      IMPORTED_LOCATION_BUILD_${cmake_build_type_upper})
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} SET)
    ct_assert_true(output_lib_property)
    ct_assert_target_does_not_have_property("${lib_target_name}"
      IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper})
    get_property(output_lib_property TARGET "${lib_target_name}"
      PROPERTY IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} SET)
    ct_assert_true(output_lib_property)
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_IMPLIB_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "${expected_implib_file_path}")
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_SONAME_${cmake_build_type_upper})
    ct_assert_equal(output_lib_property "${expected_lib_file_name}")
    get_target_property(output_lib_property "${lib_target_name}"
      IMPORTED_CONFIGURATIONS)
    ct_assert_equal(output_lib_property "${cmake_build_type_upper}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "${expected_implib_file_path}")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" true)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "${expected_implib_file_path}")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" true)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${expected_lib_file_path}")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${expected_lib_file_path}")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin")
    ct_assert_equal("${lib_target_name}_FOUND" true)
  endfunction()

  ct_add_section(NAME "import_nonexistent_shared_lib_and_implib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_shared_mock_lib-2")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "fake_shared_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "fake_shared_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      SHARED
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
    ct_assert_target_does_not_exist("${lib_target_name}")
    ct_assert_target_does_not_exist("${lib_target_name}::${lib_target_name}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${lib_target_name}_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "${lib_target_name}_IMP_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" false)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${lib_target_name}_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "${lib_target_name}_IMP_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" false)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin")
    ct_assert_equal("${lib_target_name}_FOUND" false)
  endfunction()

  ct_add_section(NAME "import_nonexistent_shared_lib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_shared_mock_lib-3")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "shared_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "shared_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    file(COPY "${TESTS_DATA_DIR}/bin/"
      DESTINATION "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib")
    set(lib_file_name
      "${CMAKE_SHARED_LIBRARY_PREFIX}${lib_file_basename}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    file(REMOVE "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib/${lib_file_name}")

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      SHARED
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib"
    )

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib"
      ${dep_import_find_args}
    )
    ct_assert_target_does_not_exist("${lib_target_name}")
    ct_assert_target_does_not_exist("${lib_target_name}::${lib_target_name}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${lib_target_name}_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "${expected_implib_file_path}")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" false)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${lib_target_name}_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "${expected_implib_file_path}")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" false)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib")
    ct_assert_equal("${lib_target_name}_FOUND" false)
    file(REMOVE_RECURSE "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_lib")
  endfunction()

  ct_add_section(NAME "import_nonexistent_shared_implib")
  function(${CMAKETEST_SECTION})
    set(lib_target_name "imp_shared_mock_lib-4")
    _set_up_test("${lib_target_name}")
    set(lib_file_basename "")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(lib_file_basename "shared_mock_lib")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(lib_file_basename "shared_mock_libd")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()

    file(COPY "${TESTS_DATA_DIR}/bin/"
      DESTINATION "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib"
    )
    # Will find `${CMAKE_FIND_LIBRARY_PREFIXES}${lib_file_basename}${CMAKE_FIND_LIBRARY_SUFFIXES}`
    find_library(implib_file_path
      NAMES "${lib_file_basename}"
      PATHS "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib"
      REQUIRED NO_DEFAULT_PATH
    )
    file(REMOVE "${implib_file_path}")

    directory(FIND_LIB expected_lib_file_path
      FIND_IMPLIB expected_implib_file_path
      NAME "${lib_file_basename}"
      SHARED
      RELATIVE false
      ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib"
    )

    ct_assert_target_does_not_exist("${lib_target_name}")
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib"
      ${dep_import_find_args}
    )
    ct_assert_target_does_not_exist("${lib_target_name}")
    ct_assert_target_does_not_exist("${lib_target_name}::${lib_target_name}")

    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      ct_assert_equal("${lib_target_name}_LIBRARY_RELEASE" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_RELEASE" "${lib_target_name}_IMP_LIBRARY_RELEASE-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_DEBUG)
      ct_assert_equal("${lib_target_name}_FOUND_RELEASE" false)
      ct_assert_not_defined(${lib_target_name}_FOUND_DEBUG)
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      ct_assert_not_defined(${lib_target_name}_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_LIBRARY_DEBUG" "${expected_lib_file_path}")
      ct_assert_not_defined(${lib_target_name}_IMP_LIBRARY_RELEASE)
      ct_assert_equal("${lib_target_name}_IMP_LIBRARY_DEBUG" "${lib_target_name}_IMP_LIBRARY_DEBUG-NOTFOUND")
      ct_assert_not_defined(${lib_target_name}_FOUND_RELEASE)
      ct_assert_equal("${lib_target_name}_FOUND_DEBUG" false)
    endif()
    ct_assert_equal("${lib_target_name}_LIBRARY" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_LIBRARIES" "${lib_target_name}_LIBRARY-NOTFOUND")
    ct_assert_equal("${lib_target_name}_ROOT_DIR" "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib")
    ct_assert_equal("${lib_target_name}_FOUND" false)
    file(REMOVE_RECURSE "${TESTS_DATA_DIR}/bin_import_nonexistent_shared_implib")
  endfunction()

  # Errors checking
  set(lib_file_basename "")
  set(dep_import_find_args "")
  if("${cmake_build_type_upper}" STREQUAL "RELEASE")
    set(lib_file_basename "shared_mock_lib")
    set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
  elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
    set(lib_file_basename "shared_mock_libd")
    set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
  endif()

  ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT
      TYPE SHARED
      ${dep_import_find_args}
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT ""
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_target_already_exists" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "imp_shared_mock_lib-1"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_binary_type_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE ""
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_find_root_dir_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_find_root_dir_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_find_root_dir_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR ""
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_find_root_dir_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "fake/directory"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_find_root_dir_is_not_a_diretory" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_lib_file_basename_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_lib_file_basename_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(dep_import_find_args "FIND_RELEASE_FILE")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(dep_import_find_args "FIND_DEBUG_FILE")
    endif()
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_lib_file_basename_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(dep_import_find_args "FIND_RELEASE_FILE" "")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(dep_import_find_args "FIND_DEBUG_FILE" "")
    endif()
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()

  ct_add_section(NAME "throws_if_arg_lib_file_basename_does_not_exist" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(lib_file_basename "fake_lib")
    set(dep_import_find_args "")
    if("${cmake_build_type_upper}" STREQUAL "RELEASE")
      set(dep_import_find_args "FIND_RELEASE_FILE" "${lib_file_basename}")
    elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
      set(dep_import_find_args "FIND_DEBUG_FILE" "${lib_file_basename}")
    endif()
    dependency(IMPORT "${lib_target_name}"
      TYPE SHARED
      FIND_ROOT_DIR "${TESTS_DATA_DIR}/bin"
      ${dep_import_find_args}
    )
  endfunction()
endfunction()
