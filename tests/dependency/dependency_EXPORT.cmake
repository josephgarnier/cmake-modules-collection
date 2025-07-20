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
# Test of [Dependency module::EXPORT operation]:
#    dependency(EXPORT <lib-target-name>...
#              <BUILD_TREE|INSTALL_TREE>
#              [APPEND]
#              OUTPUT_FILE <file_name>)
ct_add_test(NAME "test_dependency_export_operation")
function(${CMAKETEST_TEST})
	include(Dependency)

	set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")
	# Simulate a call to `dependency(IMPORT)`, then `dependency(ADD_INCLUDE_DIRECTORIES)`, then `dependency(IMPORTED_LOCATION)`
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
			INTERFACE_INCLUDE_DIRECTORIES_BUILD "${TESTS_DATA_DIR}/include"
			INTERFACE_INCLUDE_DIRECTORIES_INSTALL "include"
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
			IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} "${lib_file_path}"
			IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} "lib/${lib_file_name}"
			IMPORTED_IMPLIB_${cmake_build_type_upper} "${implib_file_path}"
			IMPORTED_SONAME_${cmake_build_type_upper} "${lib_file_name}"
		)
		set_property(TARGET "imp_static_mock_lib"
			APPEND PROPERTY IMPORTED_CONFIGURATIONS "${CMAKE_BUILD_TYPE}"
		)

		# Import shared lib
		add_library("imp_shared_mock_lib" SHARED IMPORTED)
		set(lib_base_filename "shared_mock_lib")
		if("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
			set(lib_base_filename "shared_mock_libd")
		endif()
		set_target_properties("imp_shared_mock_lib" PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${TESTS_DATA_DIR}/include"
			INTERFACE_INCLUDE_DIRECTORIES_BUILD "${TESTS_DATA_DIR}/include"
			INTERFACE_INCLUDE_DIRECTORIES_INSTALL "include"
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
			IMPORTED_LOCATION_BUILD_${cmake_build_type_upper} "${lib_file_path}"
			IMPORTED_LOCATION_INSTALL_${cmake_build_type_upper} "lib/${lib_file_name}"
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

	# Functionalities checking
	# Since dependency() generates the “part” files created during the generation phase and the final file during the build phase from the “part” files created during the generation phase, it is not possible to test the results of several calls to dependency() during the test phase. Therefore, tests on result are commented.
	# ct_add_section(NAME "export_from_build_tree")
	# function(${CMAKETEST_SECTION})

	# 	set(expected_export_file "${CMAKE_BINARY_DIR}/ImpMockLibTargets.cmake")
	# 	set(expected_part_static_file "${CMAKE_BINARY_DIR}/imp_static_mock_libTargets-STATIC.part.cmake")
	# 	set(expected_part_shared_file "${CMAKE_BINARY_DIR}/imp_static_mock_libTargets-SHARED.part.cmake")
	# 	file(REMOVE "${expected_export_file}" "${expected_part_static_file}" "${expected_part_shared_file}")

	# 	ct_add_section(NAME "overwrite_1")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-overwrite-01-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_does_not_exist("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "overwrite_2")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-overwrite-02-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_1")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-append-01-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_does_not_exist("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_2")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-append-02-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_3")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-append-03-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_4")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-build-append-04-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# ct_add_section(NAME "export_from_install_tree")
	# function(${CMAKETEST_SECTION})
	# 	set(expected_export_file "${CMAKE_BINARY_DIR}/cmake/export/ImpMockLibTargets.cmake")
	# 	set(expected_part_static_file "${CMAKE_BINARY_DIR}/cmake/export/imp_static_mock_libTargets-STATIC.part.cmake")
	# 	set(expected_part_shared_file "${CMAKE_BINARY_DIR}/cmake/export/imp_static_mock_libTargets-SHARED.part.cmake")
	# 	file(REMOVE "${expected_export_file}" "${expected_part_static_file}" "${expected_part_shared_file}")

	# 	ct_add_section(NAME "overwrite_1")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-overwrite-01-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_does_not_exist("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "overwrite_2")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-overwrite-02-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_1")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-append-01-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_does_not_exist("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_2")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-append-02-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_3")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-append-03-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# 	ct_add_section(NAME "append_4")
	# 	function(${CMAKETEST_SECTION})
	# 		file(READ
	# 			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/dependency_EXPORT-install-append-04-expected.txt"
	# 			expected_file_content
	# 		)
	# 		string(REPLACE
	# 			"@TESTS_DATA_DIR@" "${TESTS_DATA_DIR}"
	# 			expected_file_content "${expected_file_content}")
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_export_file}")
	# 		ct_assert_file_exists("${expected_part_static_file}")
	# 		ct_assert_file_exists("${expected_part_shared_file}")
	# 		ct_assert_file_contains("${expected_export_file}" "${expected_file_content}")
	# 	endfunction()

	# ct_add_section(NAME "export_from_all_trees")
	# function(${CMAKETEST_SECTION})
	# 	set(expected_build_export_file "${CMAKE_BINARY_DIR}/ImpMockLibTargets.cmake")
	# 	set(expected_install_export_file "${CMAKE_BINARY_DIR}/cmake/export/ImpMockLibTargets.cmake")
	# 	file(REMOVE "${expected_build_export_file}" "${expected_install_export_file}")

	# 	ct_add_section(NAME "overwrite")
	# 	function(${CMAKETEST_SECTION})
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_build_export_file}")
	# 		ct_assert_file_exists("${expected_install_export_file}")
	# 	endfunction()

	# 	ct_add_section(NAME "append")
	# 	function(${CMAKETEST_SECTION})
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			BUILD_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_static_mock_lib"
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		dependency(EXPORT "imp_shared_mock_lib"
	# 			APPEND
	# 			INSTALL_TREE
	# 			OUTPUT_FILE "ImpMockLibTargets.cmake"
	# 		)
	# 		ct_assert_file_exists("${expected_build_export_file}")
	# 		ct_assert_file_exists("${expected_install_export_file}")
	# 	endfunction()
	# endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT
			APPEND
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT ""
			APPEND
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_twice_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_static_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_twice_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
		dependency(EXPORT "imp_static_mock_lib"
			APPEND
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "unknown_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_type_is_unsupported" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		add_library("imp_unsupported_lib" MODULE)
		dependency(EXPORT "imp_unsupported_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_append_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
		dependency(EXPORT "imp_shared_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_append_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib"
			APPEND
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
		dependency(EXPORT "imp_shared_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_tree_type_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
			APPEND
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_tree_type_is_twice" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
			APPEND
			BUILD_TREE INSTALL_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_file_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
			APPEND
			BUILD_TREE
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_file_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
			APPEND
			BUILD_TREE
			OUTPUT_FILE
		)
	endfunction()
	ct_add_section(NAME "throws_if_arg_output_file_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		dependency(EXPORT "imp_static_mock_lib" "imp_shared_mock_lib"
			APPEND
			BUILD_TREE
			OUTPUT_FILE ""
		)
	endfunction()

	ct_add_section(NAME "throws_if_build_type_var_is_not_set_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(CMAKE_BUILD_TYPE)
		dependency(EXPORT "imp_static_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()

	ct_add_section(NAME "throws_if_build_type_var_is_not_set_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(CMAKE_BUILD_TYPE "")
		dependency(EXPORT "imp_static_mock_lib"
			BUILD_TREE
			OUTPUT_FILE "ImpMockLibTargets.cmake"
		)
	endfunction()
endfunction()
