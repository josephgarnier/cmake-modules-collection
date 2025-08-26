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
# Test of [CMakeTargetsFile module::IS_LOADED operation]:
#    cmake_targets_file(IS_LOADED <output-var>)
ct_add_test(NAME "test_cmake_targets_file_is_loaded_operation")
function(${CMAKETEST_TEST})
	include(CMakeTargetsFile)

	# To call before each test
	macro(_set_up_test)
		# Reset properties used by `cmake_targets_file(IS_LOADED)`
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED)
	endmacro()

	# Functionalities checking
	ct_add_section(NAME "check_when_global_property_is_not_set")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED" SET)
		ct_assert_false(output_property)
		get_property(output_property GLOBAL PROPERTY "TARGETS_CONFIG_LOADED")
		ct_assert_equal(output_property "")
		ct_assert_not_defined(output_property)
		
		cmake_targets_file(IS_LOADED is_file_loaded)
		ct_assert_false(is_file_loaded)
	endfunction()

	ct_add_section(NAME "check_when_global_property_is_empty")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "")
		cmake_targets_file(IS_LOADED is_file_loaded)
		ct_assert_false(is_file_loaded)
	endfunction()

	ct_add_section(NAME "check_when_global_property_is_not_bool")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "not-bool")
		cmake_targets_file(IS_LOADED is_file_loaded)
		ct_assert_false(is_file_loaded)
	endfunction()

	ct_add_section(NAME "check_when_global_property_is_off")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "off")
		cmake_targets_file(IS_LOADED is_file_loaded)
		ct_assert_false(is_file_loaded)
	endfunction()

	ct_add_section(NAME "check_when_global_property_is_on")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		set_property(GLOBAL PROPERTY TARGETS_CONFIG_LOADED "on")
		cmake_targets_file(IS_LOADED is_file_loaded)
		ct_assert_true(is_file_loaded)
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		_set_up_test()
		cmake_targets_file(IS_LOADED)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		_set_up_test()
		cmake_targets_file(IS_LOADED "")
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		_set_up_test()
		cmake_targets_file(IS_LOADED "is_file_loaded")
	endfunction()
endfunction()
