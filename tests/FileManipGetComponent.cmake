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
# Test of [FileManip module::GET_COMPONENT operation]:
#    ``file_manip(GET_COMPONENT <file_list>... MODE <mode> OUTPUT_VARIABLE <output_list_var>)``
ct_add_test(NAME "test_file_manip_get_component_operation")
function(${CMAKETEST_TEST})
	include(FuncFileManip)

	# Functionalities checking
	ct_add_section(NAME "directory_mode") # s'insipirer de ce fichier et notamment des exceptions et des noms "input" et "output" pour refaire tous les autres (sauf FileManipStripPath)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data")

		set(input "data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "data")
		
		set(input
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		set(expected_output
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE output)
		ct_assert_list(output)
		ct_assert_equal(output "${expected_output}")
	endfunction()

	ct_add_section(NAME "name_mode")
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE NAME OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "main.cpp")

		set(input "data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE NAME OUTPUT_VARIABLE output)
		ct_assert_string(output)
		ct_assert_equal(output "main.cpp")
		
		set(input
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		set(expected_output
			"main.cpp"
			"source_1.cpp"
			"source_2.cpp"
			"source_3.cpp"
			"source_4.cpp"
			"source_5.cpp"
			"source_sub_1.cpp"
			"source_sub_2.cpp")
		file_manip(GET_COMPONENT "${input}" MODE NAME OUTPUT_VARIABLE output)
		ct_assert_list(output)
		ct_assert_equal(output "${expected_output}")
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_file_list_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(GET_COMPONENT MODE DIRECTORY OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(GET_COMPONENT "" MODE DIRECTORY OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file_manip(GET_COMPONENT "" MODE DIRECTORY OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input)
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_mode_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_mode_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE "" OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_mode_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE "mode" OUTPUT_VARIABLE output)
	endfunction()

	ct_add_section(NAME "throws_if_arg_mode_is_wrong" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE FAKE OUTPUT_VARIABLE output)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE "output")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp")
		unset(output)
		file_manip(GET_COMPONENT "${input}" MODE DIRECTORY OUTPUT_VARIABLE output)
	endfunction()
endfunction()
