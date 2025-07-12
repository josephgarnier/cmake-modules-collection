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
# Test of [FileManip module::STRIP_PATH operation]:
#    file_manip(STRIP_PATH <file-list-var>
#              BASE_DIR <directory-path>
#              [OUTPUT_VARIABLE <output-list-var>])
ct_add_test(NAME "test_file_manip_strip_path_operation")
function(${CMAKETEST_TEST})
	include(FileManip)

	# Functionalities checking
	ct_add_section(NAME "path_to_existing_files")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
			ct_assert_string(input)
			ct_assert_equal(input "")

			set(input "${TESTS_DATA_DIR}/src/main.cpp")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
			ct_assert_string(input)
			ct_assert_equal(input "src/main.cpp")

			set(input
				"${TESTS_DATA_DIR}/src/main.cpp"
				"${TESTS_DATA_DIR}/src/source_1.cpp"
				"${TESTS_DATA_DIR}/src/source_2.cpp"
				"${TESTS_DATA_DIR}/src/source_3.cpp"
				"${TESTS_DATA_DIR}/src/source_4.cpp"
				"${TESTS_DATA_DIR}/src/source_5.cpp"
				"${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
				"${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
			set(expected_result
				"src/main.cpp"
				"src/source_1.cpp"
				"src/source_2.cpp"
				"src/source_3.cpp"
				"src/source_4.cpp"
				"src/source_5.cpp"
				"src/sub_1/source_sub_1.cpp"
				"src/sub_2/source_sub_2.cpp")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
			ct_assert_list(input)
			ct_assert_equal(input "${expected_result}")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
			ct_assert_string(output)
			ct_assert_equal(output "")

			set(input "${TESTS_DATA_DIR}/src/main.cpp")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
			ct_assert_string(output)
			ct_assert_equal(output "src/main.cpp")

			set(input
				"${TESTS_DATA_DIR}/src/main.cpp"
				"${TESTS_DATA_DIR}/src/source_1.cpp"
				"${TESTS_DATA_DIR}/src/source_2.cpp"
				"${TESTS_DATA_DIR}/src/source_3.cpp"
				"${TESTS_DATA_DIR}/src/source_4.cpp"
				"${TESTS_DATA_DIR}/src/source_5.cpp"
				"${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
				"${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
			set(expected_result
				"src/main.cpp"
				"src/source_1.cpp"
				"src/source_2.cpp"
				"src/source_3.cpp"
				"src/source_4.cpp"
				"src/source_5.cpp"
				"src/sub_1/source_sub_1.cpp"
				"src/sub_2/source_sub_2.cpp")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
			ct_assert_list(output)
			ct_assert_equal(output "${expected_result}")
		endfunction()
	endfunction()

	ct_add_section(NAME "path_to_not_existing_input_file")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/src/fake.cpp")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
			ct_assert_string(input)
			ct_assert_equal(input "src/fake.cpp")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/src/fake.cpp")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE output)
			ct_assert_string(output)
			ct_assert_equal(output "src/fake.cpp")
		endfunction()
	endfunction()

	ct_add_section(NAME "path_to_not_existing_base_dir")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/fake/src/main.cpp")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake")
			ct_assert_string(input)
			ct_assert_equal(input "src/main.cpp")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/fake/src/main.cpp")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake" OUTPUT_VARIABLE output)
			ct_assert_string(output)
			ct_assert_equal(output "src/main.cpp")
		endfunction()
	endfunction()

	ct_add_section(NAME "path_to_inconsistent_base_dir")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/src/main.cpp")
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake")
			ct_assert_string(input)
			ct_assert_equal(input "${TESTS_DATA_DIR}/src/main.cpp")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "${TESTS_DATA_DIR}/src/main.cpp")
			unset(output)
			file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}/fake" OUTPUT_VARIABLE output)
			ct_assert_string(output)
			ct_assert_equal(output "${TESTS_DATA_DIR}/src/main.cpp")
		endfunction()
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(STRIP_PATH BASE_DIR "${TESTS_DATA_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(STRIP_PATH "" BASE_DIR "${TESTS_DATA_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(STRIP_PATH "intput" BASE_DIR "${TESTS_DATA_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input)
		file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input)
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input BASE_DIR)
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input BASE_DIR "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${TESTS_DATA_DIR}/src/main.cpp")
		file_manip(STRIP_PATH input BASE_DIR "${TESTS_DATA_DIR}" OUTPUT_VARIABLE "output")
	endfunction()
endfunction()
