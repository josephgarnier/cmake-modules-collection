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
# Test of [Directory module::COLLECT_SOURCES_BY_POLICY operation]:
#    directory(COLLECT_SOURCES_BY_POLICY
#             PUBLIC_HEADERS_SEPARATED <on|off> [<include-dir-path>]
#             SRC_DIR <dir-path>
#             SRC_SOURCE_FILES <output-list-var>
#             PUBLIC_HEADER_DIR <output-var>
#             PUBLIC_HEADER_FILES <output-list-var>
#             PRIVATE_HEADER_DIR <output-var>
#             PRIVATE_HEADER_FILES <output-list-var>)
ct_add_test(NAME "test_directory_collect_sources_by_policy_operation")
function(${CMAKETEST_TEST})
	include(FuncDirectory)

	# Set global test variables
	set(expected_src_sources_output
		"${TESTS_DATA_DIR}/src/main.cpp"
		"${TESTS_DATA_DIR}/src/source_1.cpp"
		"${TESTS_DATA_DIR}/src/source_2.cpp"
		"${TESTS_DATA_DIR}/src/source_3.cpp"
		"${TESTS_DATA_DIR}/src/source_4.cpp"
		"${TESTS_DATA_DIR}/src/source_5.cpp"
		"${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
		"${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
	set(expected_src_headers_output
		"${TESTS_DATA_DIR}/src/source_1.h"
		"${TESTS_DATA_DIR}/src/source_2.h"
		"${TESTS_DATA_DIR}/src/source_3.h"
		"${TESTS_DATA_DIR}/src/source_4.h"
		"${TESTS_DATA_DIR}/src/source_5.h"
		"${TESTS_DATA_DIR}/src/sub_1/source_sub_1.h"
		"${TESTS_DATA_DIR}/src/sub_2/source_sub_2.h")
	set(expected_include_headers_output
		"${TESTS_DATA_DIR}/include/include_1.h"
		"${TESTS_DATA_DIR}/include/include_2.h"
		"${TESTS_DATA_DIR}/include/include_pch.h")

	# Functionalities checking
	ct_add_section(NAME "get_with_headers_separated")
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
		ct_assert_list(src_sources)
		ct_assert_equal(src_sources "${expected_src_sources_output}")
		ct_assert_string(public_header_dir)
		ct_assert_equal(public_header_dir "${TESTS_DATA_DIR}/include")
		ct_assert_list(public_header_files)
		ct_assert_equal(public_header_files "${expected_include_headers_output}")
		ct_assert_string(private_header_dir)
		ct_assert_equal(private_header_dir "${TESTS_DATA_DIR}/src")
		ct_assert_list(private_header_files)
		ct_assert_equal(private_header_files "${expected_src_headers_output}")
	endfunction()

	ct_add_section(NAME "get_without_headers_separated")
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED off
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
		ct_assert_list(src_sources)
		ct_assert_equal(src_sources "${expected_src_sources_output}")
		ct_assert_string(public_header_dir)
		ct_assert_equal(public_header_dir "${TESTS_DATA_DIR}/src")
		ct_assert_list(public_header_files)
		ct_assert_equal(public_header_files "${expected_src_headers_output}")
		ct_assert_string(private_header_dir)
		ct_assert_equal(private_header_dir "")
		ct_assert_string(private_header_files)
		ct_assert_equal(private_header_files "")

		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED off "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
		ct_assert_list(src_sources)
		ct_assert_equal(src_sources "${expected_src_sources_output}")
		ct_assert_string(public_header_dir)
		ct_assert_equal(public_header_dir "${TESTS_DATA_DIR}/src")
		ct_assert_list(public_header_files)
		ct_assert_equal(public_header_files "${expected_src_headers_output}")
		ct_assert_string(private_header_dir)
		ct_assert_equal(private_header_dir "")
		ct_assert_string(private_header_files)
		ct_assert_equal(private_header_files "")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED ""
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_not_boolean" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED "not-bool" "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_is_missing_5" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on ""
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_headers_separated_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "fake/directory"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_src_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR ""
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "fake/directory"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES ""
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_src_source_files_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES "src_sources"
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_dir_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_dir_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_dir_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR ""
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_dir_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR "public_header_dir"
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_files_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_files_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_files_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES ""
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_public_header_files_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES "public_header_files"
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_dir_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_dir_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_dir_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR ""
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_dir_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR "private_header_dir"
			PRIVATE_HEADER_FILES private_header_files
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_files_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_files_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_files_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES ""
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_private_header_files_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(COLLECT_SOURCES_BY_POLICY
			PUBLIC_HEADERS_SEPARATED on "${TESTS_DATA_DIR}/include"
			SRC_DIR "${TESTS_DATA_DIR}/src"
			SRC_SOURCE_FILES src_sources
			PUBLIC_HEADER_DIR public_header_dir
			PUBLIC_HEADER_FILES public_header_files
			PRIVATE_HEADER_DIR private_header_dir
			PRIVATE_HEADER_FILES "private_header_files"
		)
	endfunction()
endfunction()
