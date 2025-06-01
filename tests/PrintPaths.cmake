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
# Test of [Print module::PATHS operation]:
#    ``print([<mode>] PATHS <file_list>... [INDENT])``
ct_add_test(NAME "test_print_paths_operation")
function(${CMAKETEST_TEST})
	include(FuncPrint)

	# Functionalities checking
	ct_add_section(NAME "no_mode")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(input
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		print(PATHS "${input}")
		ct_assert_prints("data/main.cpp ; data/source_1.cpp ; data/source_2.cpp ; data/source_3.cpp ; data/source_4.cpp ; data/source_5.cpp ; data/sub_1/source_sub_1.cpp ; data/sub_2/source_sub_2.cpp")
		print(PATHS "${input}" INDENT)
		ct_assert_prints("data/main.cpp ; data/source_1.cpp ; data/source_2.cpp ; data/source_3.cpp ; data/source_4.cpp ; data/source_5.cpp ; data/sub_1/source_sub_1.cpp ; data/sub_2/source_sub_2.cpp") # This function ignores the indentation
	endfunction()

	ct_add_section(NAME "status_mode")
	function(${CMAKETEST_SECTION})
		set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
		set(input
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/main.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_2.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_3.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_4.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/source_5.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_1/source_sub_1.cpp"
			"${CMAKE_CURRENT_FUNCTION_LIST_DIR}/data/sub_2/source_sub_2.cpp")
		print(STATUS PATHS "${input}")
		ct_assert_prints("data/main.cpp ; data/source_1.cpp ; data/source_2.cpp ; data/source_3.cpp ; data/source_4.cpp ; data/source_5.cpp ; data/sub_1/source_sub_1.cpp ; data/sub_2/source_sub_2.cpp")
		print(STATUS PATHS "${input}" INDENT)
		ct_assert_prints("data/main.cpp ; data/source_1.cpp ; data/source_2.cpp ; data/source_3.cpp ; data/source_4.cpp ; data/source_5.cpp ; data/sub_1/source_sub_1.cpp ; data/sub_2/source_sub_2.cpp") # This function ignores the indentation
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_file_list_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(PATHS)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(PATHS INDENT)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STATUS PATHS)
	endfunction()

	ct_add_section(NAME "throws_if_arg_file_list_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		print(STATUS PATHS INDENT)
	endfunction()
endfunction()
