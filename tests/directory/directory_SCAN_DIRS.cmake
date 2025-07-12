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
# Test of [Directory module::SCAN_DIRS operation]:
#    directory(SCAN_DIRS <output-list-var>
#              RECURSE <on|off>
#              RELATIVE <on|off>
#              ROOT_DIR <directory-path>
#              <INCLUDE_REGEX|EXCLUDE_REGEX> <regular-expression>)
ct_add_test(NAME "test_directory_scan_dirs_operation")
function(${CMAKETEST_TEST})
	include(Directory)

	# Functionalities checking
	ct_add_section(NAME "list_recursively")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"${TESTS_DATA_DIR}/bin"
				"${TESTS_DATA_DIR}/include"
				"${TESTS_DATA_DIR}/src"
				"${TESTS_DATA_DIR}/src/sub_1"
				"${TESTS_DATA_DIR}/src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX ".*"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"bin"
				"include"
				"src"
				"src/sub_1"
				"src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX ".*"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()
	endfunction()

	ct_add_section(NAME "list_not_recursively")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"${TESTS_DATA_DIR}/bin"
				"${TESTS_DATA_DIR}/include"
				"${TESTS_DATA_DIR}/src")
			directory(SCAN_DIRS output
				RECURSE off
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX ".*"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"bin"
				"include"
				"src")
			directory(SCAN_DIRS output
				RECURSE off
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX ".*"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()
	endfunction()

	ct_add_section(NAME "list_filtered_with_include_regex")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"${TESTS_DATA_DIR}/src"
				"${TESTS_DATA_DIR}/src/sub_1"
				"${TESTS_DATA_DIR}/src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX "src"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"src"
				"src/sub_1"
				"src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
				INCLUDE_REGEX "src"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()
	endfunction()

	ct_add_section(NAME "list_filtered_with_exclude_regex")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"${TESTS_DATA_DIR}/src"
				"${TESTS_DATA_DIR}/src/sub_1"
				"${TESTS_DATA_DIR}/src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
				EXCLUDE_REGEX "bin|include"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(expected_output
				"src"
				"src/sub_1"
				"src/sub_2")
			directory(SCAN_DIRS output
				RECURSE on
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
				EXCLUDE_REGEX "bin|include"
			)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_output}")
		endfunction()
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS ""
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_list_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS "output"
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_recurse_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_recurse_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_recurse_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE ""
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_recurse_is_not_bool" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE "wrong"
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_relative_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE ""
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_is_not_bool" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE "wrong"
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR ""
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR "fake/directory"
			INCLUDE_REGEX ".*"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_regex_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_regex_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_regex_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		directory(SCAN_DIRS output
			RECURSE on
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src"
			INCLUDE_REGEX ""
		)
	endfunction()
endfunction()
