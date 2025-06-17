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
# Test of [StringManip module::EXTRACT_INTERFACE operation]:
#    ``string_manip(EXTRACT_INTERFACE <string_var> <BUILD|INSTALL> [OUTPUT_VARIABLE <output_var>])``
ct_add_test(NAME "test_string_manip_extract_interface_operation")
function(${CMAKETEST_TEST})
	include(FuncStringManip)

	# Functionalities checking
	ct_add_section(NAME "extract_build_interface")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			string_manip(EXTRACT_INTERFACE input BUILD)
			ct_assert_list(input)
			ct_assert_equal(input "src/file-a.cpp;src/file-b.cpp;src/file-c.cpp;src/file-d.cpp;src/file-e.cpp;src/file-f.cpp")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			unset(output)
			string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE output)
			ct_assert_equal(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			ct_assert_list(output)
			ct_assert_equal(output "src/file-a.cpp;src/file-b.cpp;src/file-c.cpp;src/file-d.cpp;src/file-e.cpp;src/file-f.cpp")
		endfunction()
	endfunction()

	ct_add_section(NAME "extract_install_interface")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			string_manip(EXTRACT_INTERFACE input INSTALL)
			ct_assert_list(input)
			ct_assert_equal(input "include/file-a.h;include/file-b.h;include/file-c.h")
		endfunction()
		
		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			unset(output)
			string_manip(EXTRACT_INTERFACE input INSTALL OUTPUT_VARIABLE output)
			ct_assert_equal(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			ct_assert_list(output)
		endfunction()
	endfunction()

	ct_add_section(NAME "extract_nothing_build_interface")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			string_manip(EXTRACT_INTERFACE input BUILD)
			ct_assert_string(input)
			ct_assert_equal(input "")

			set(input "before;$<BUILD_INTERFACE:>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			string_manip(EXTRACT_INTERFACE input BUILD)
			ct_assert_string(input)
			ct_assert_equal(input "")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			unset(output)
			string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE output)
			ct_assert_equal(input "")
			ct_assert_string(output)
			ct_assert_equal(output "")

			set(input "before;$<BUILD_INTERFACE:>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			unset(output)
			string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE output)
			ct_assert_equal(input "before;$<BUILD_INTERFACE:>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
			ct_assert_string(output)
			ct_assert_equal(output "")
		endfunction()
	endfunction()

	ct_add_section(NAME "extract_nothing_install_interface")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "inplace_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			string_manip(EXTRACT_INTERFACE input INSTALL)
			ct_assert_string(input)
			ct_assert_equal(input "")

			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;between;$<INSTALL_INTERFACE:>;after")
			string_manip(EXTRACT_INTERFACE input INSTALL)
			ct_assert_string(input)
			ct_assert_equal(input "")
		endfunction()

		ct_add_section(NAME "output_version")
		function(${CMAKETEST_SECTION})
			set(input "")
			unset(output)
			string_manip(EXTRACT_INTERFACE input INSTALL OUTPUT_VARIABLE output)
			ct_assert_equal(input "")
			ct_assert_string(output)
			ct_assert_equal(output "")

			set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;between;$<INSTALL_INTERFACE:>;after")
			unset(output)
			string_manip(EXTRACT_INTERFACE input INSTALL OUTPUT_VARIABLE output)
			ct_assert_equal(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;between;$<INSTALL_INTERFACE:>;after")
			ct_assert_string(output)
			ct_assert_equal(output "")
		endfunction()
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_string_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(EXTRACT_INTERFACE BUILD)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(EXTRACT_INTERFACE "" BUILD)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		string_manip(EXTRACT_INTERFACE "input" BUILD)
	endfunction()

	ct_add_section(NAME "throws_if_arg_string_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(input)
		string_manip(EXTRACT_INTERFACE input BUILD)
	endfunction()

	ct_add_section(NAME "throws_if_arg_interface_type_is_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		string_manip(EXTRACT_INTERFACE input)
	endfunction()

	ct_add_section(NAME "throws_if_arg_interface_type_is_twice" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		string_manip(EXTRACT_INTERFACE input BUILD INSTALL)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE "foo")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_4" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(input "before;$<BUILD_INTERFACE:src/file-a.cpp;src/file-b.cpp;src/file-c.cpp>;$<BUILD_INTERFACE:src/file-d.cpp;src/file-e.cpp;src/file-f.cpp>;between;$<INSTALL_INTERFACE:include/file-a.h;include/file-b.h;include/file-c.h>;after")
		unset(output)
		string_manip(EXTRACT_INTERFACE input BUILD OUTPUT_VARIABLE output)
	endfunction()
endfunction()
