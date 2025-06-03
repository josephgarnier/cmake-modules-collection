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
# Test of [FileManip module::ABSOLUTE_PATH operation]:
#    ``file_manip(ABSOLUTE_PATH <file_list_var> BASE_DIR <directory_path> [OUTPUT_VARIABLE <output_list_var>])``
ct_add_test(NAME "test_file_manip_absolute_path_operation")
function(${CMAKETEST_TEST})
	include(FuncFileManip)

	# Functionalities checking
	ct_add_section(NAME "inplace_version")
	function(${CMAKETEST_SECTION})
		set(input "")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		ct_assert_string(input)
		ct_assert_equal(input "")

		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		ct_assert_string(input)
		ct_assert_equal(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")

		set(input
			"data/main.cpp"
			"data/source_1.cpp"
			"data/source_2.cpp"
			"data/source_3.cpp"
			"data/source_4.cpp"
			"data/source_5.cpp"
			"data/sub_1/source_sub_1.cpp"
			"data/sub_2/source_sub_2.cpp")
		set(expected_result
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		ct_assert_list(input)
		ct_assert_equal(input "${expected_result}")
	endfunction()

	ct_add_section(NAME "output_version")
	function(${CMAKETEST_SECTION})
		set(input "")
		unset(output)
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "")

		set(input "data/main.cpp")
		unset(output)
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")

		set(input
			"data/main.cpp"
			"data/source_1.cpp"
			"data/source_2.cpp"
			"data/source_3.cpp"
			"data/source_4.cpp"
			"data/source_5.cpp"
			"data/sub_1/source_sub_1.cpp"
			"data/sub_2/source_sub_2.cpp")
		set(expected_result
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		unset(output)
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE output)
		ct_assert_list(output)
		ct_assert_equal(output "${expected_result}")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(ABSOLUTE_PATH BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(ABSOLUTE_PATH "" BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(ABSOLUTE_PATH "input" BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input)
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input)
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR)
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "fake/directory")
	endfunction()

	ct_add_section(NAME "throws_if_arg_base_dir_is_not_a_directory" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp")
	endfunction()

	ct_add_section(NAME "throws_if_resulting_file_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/not-exists.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE "output")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "data/main.cpp")
		unset(output)
		file_manip(ABSOLUTE_PATH input BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}" OUTPUT_VARIABLE output)
	endfunction()
endfunction()
