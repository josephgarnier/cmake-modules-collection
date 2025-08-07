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
#              <STATIC|SHARED>
#              [RELEASE_NAME <raw-filename>]
#              [DEBUG_NAME <raw-filename>]
#              ROOT_DIR <dir-path>
#              INCLUDE_DIR <dir-path>)
ct_add_test(NAME "test_dependency_import_operation")
function(${CMAKETEST_TEST})
	include(Dependency)
	string(TOUPPER "${CMAKE_BUILD_TYPE}" cmake_build_type_upper)

	# Functionalities checking
	ct_add_section(NAME "import_static_lib")
	function(${CMAKETEST_SECTION})
		set(lib_base_filename "")
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(lib_base_filename "static_mock_lib")
			set(build_type_arg "RELEASE_NAME" "${lib_base_filename}")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(lib_base_filename "static_mock_libd")
			set(build_type_arg "DEBUG_NAME" "${lib_base_filename}")
		endif()

		directory(FIND_LIB expected_lib_file_path
			FIND_IMPLIB expected_implib_file_path
			NAME "${lib_base_filename}"
			STATIC
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
		cmake_path(GET expected_lib_file_path FILENAME expected_lib_file_name)

		set(lib_target_name "imp_static_mock_lib-1")
		ct_assert_target_does_not_exist("${lib_target_name}")
		dependency(IMPORT "${lib_target_name}"
			STATIC
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
		ct_assert_target_exists("${lib_target_name}")
		get_target_property(output_lib_property "${lib_target_name}"
			INTERFACE_INCLUDE_DIRECTORIES)
		ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
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
		ct_assert_equal(output_lib_property "${CMAKE_BUILD_TYPE}")
	endfunction()

	ct_add_section(NAME "import_shared_lib")
	function(${CMAKETEST_SECTION})
		set(lib_base_filename "")
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(lib_base_filename "shared_mock_lib")
			set(build_type_arg "RELEASE_NAME" "${lib_base_filename}")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(lib_base_filename "shared_mock_libd")
			set(build_type_arg "DEBUG_NAME" "${lib_base_filename}")
		endif()

		directory(FIND_LIB expected_lib_file_path
			FIND_IMPLIB expected_implib_file_path
			NAME "${lib_base_filename}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
		cmake_path(GET expected_lib_file_path FILENAME expected_lib_file_name)

		set(lib_target_name "imp_shared_mock_lib-1")
		ct_assert_target_does_not_exist("${lib_target_name}")
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
		ct_assert_target_exists("${lib_target_name}")
		get_target_property(output_lib_property "${lib_target_name}"
			INTERFACE_INCLUDE_DIRECTORIES)
		ct_assert_equal(output_lib_property "${TESTS_DATA_DIR}/include")
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
		ct_assert_equal(output_lib_property "${CMAKE_BUILD_TYPE}")
	endfunction()

	ct_add_section(NAME "include_dir_does_not_exists")
	function(${CMAKETEST_SECTION})
		set(lib_base_filename "")
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(lib_base_filename "shared_mock_lib")
			set(build_type_arg "RELEASE_NAME" "${lib_base_filename}")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(lib_base_filename "shared_mock_libd")
			set(build_type_arg "DEBUG_NAME" "${lib_base_filename}")
		endif()

		directory(FIND_LIB expected_lib_file_path
			FIND_IMPLIB expected_implib_file_path
			NAME "${lib_base_filename}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
		cmake_path(GET expected_lib_file_path FILENAME expected_lib_file_name)

		set(lib_target_name "imp_shared_mock_lib-2")
		ct_assert_target_does_not_exist("${lib_target_name}")
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "fake/directory"
		)
		ct_assert_target_exists("${lib_target_name}")
		get_target_property(output_lib_property "${lib_target_name}"
			INTERFACE_INCLUDE_DIRECTORIES)
		ct_assert_equal(output_lib_property "fake/directory")
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
		ct_assert_equal(output_lib_property "${CMAKE_BUILD_TYPE}")
	endfunction()

	# Errors checking
	set(lib_base_filename "")
	set(build_type_arg "")
	if("${cmake_build_type_upper}" STREQUAL "RELEASE")
		set(lib_base_filename "shared_mock_lib")
		set(build_type_arg "RELEASE_NAME" "${lib_base_filename}")
	elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
		set(lib_base_filename "shared_mock_libd")
		set(build_type_arg "DEBUG_NAME" "${lib_base_filename}")
	endif()
	
	ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT ""
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_already_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "imp_shared_mock_lib-1"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_binary_type_is_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_binary_type_is_twice" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED STATIC
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_lib_base_filename_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_lib_base_filename_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(build_type_arg "RELEASE_NAME")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(build_type_arg "DEBUG_NAME")
		endif()
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_lib_base_filename_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(build_type_arg "RELEASE_NAME" "")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(build_type_arg "DEBUG_NAME" "")
		endif()
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_lib_base_filename_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_base_filename "fake_lib")
		set(build_type_arg "")
		if("${cmake_build_type_upper}" STREQUAL "RELEASE")
			set(build_type_arg "RELEASE_NAME" "${lib_base_filename}")
		elseif("${cmake_build_type_upper}" STREQUAL "DEBUG")
			set(build_type_arg "DEBUG_NAME" "${lib_base_filename}")
		endif()
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR ""
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "fake/directory"
			INCLUDE_DIR "${TESTS_DATA_DIR}/include"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_include_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_include_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_include_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(IMPORT "${lib_target_name}"
			SHARED
			${build_type_arg}
			ROOT_DIR "${TESTS_DATA_DIR}"
			INCLUDE_DIR ""
		)
	endfunction()
endfunction()
