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
# Test of [BinaryTarget module::ADD_DEPENDENCIES operation]:
#    binary_target(ADD_DEPENDENCIES <target-name> DEPENDENCIES [<target-name>...|<gen-expr>...])
ct_add_test(NAME "test_binary_target_add_dependencies_operation")
function(${CMAKETEST_TEST})
	include(BinaryTarget)

	# Create mock binary targets for tests
	macro(_create_mock_bins)
		add_library("new_static_mock_lib" STATIC)
		target_sources("new_static_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		add_library("dep_static_mock_lib_1" STATIC)
		target_sources("dep_static_mock_lib_1" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")
		add_library("dep_static_mock_lib_2" STATIC)
		target_sources("dep_static_mock_lib_2" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")

		add_library("new_shared_mock_lib" SHARED)
		target_sources("new_shared_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
		add_library("dep_shared_mock_lib_1" SHARED)
		target_sources("dep_shared_mock_lib_1" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")
		add_library("dep_shared_mock_lib_2" SHARED)
		target_sources("dep_shared_mock_lib_2" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp")
	endmacro()
	if(NOT TARGET "new_static_mock_lib" OR NOT TARGET "new_shared_mock_lib")
		_create_mock_bins()
	endif()

	# To call before each test
	macro(_set_up_test)
		# Reset properties used by `binary_target(ADD_DEPENDENCIES)`
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_LINK_LIBRARIES)
		set_property(TARGET "new_static_mock_lib" PROPERTY LINK_LIBRARIES)

		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_LINK_LIBRARIES)
		set_property(TARGET "new_shared_mock_lib" PROPERTY LINK_LIBRARIES)
	endmacro()

	# Functionalities checking
	ct_add_section(NAME "add_no_deps")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		binary_target(ADD_DEPENDENCIES "new_static_mock_lib" DEPENDENCIES "")
		ct_assert_target_does_not_have_property("new_static_mock_lib"
			INTERFACE_LINK_LIBRARIES)
		ct_assert_target_does_not_have_property("new_static_mock_lib"
			LINK_LIBRARIES)

		binary_target(ADD_DEPENDENCIES "new_shared_mock_lib" DEPENDENCIES "")
		ct_assert_target_does_not_have_property("new_shared_mock_lib"
			INTERFACE_LINK_LIBRARIES)
		ct_assert_target_does_not_have_property("new_shared_mock_lib"
			LINK_LIBRARIES)
	endfunction()

	ct_add_section(NAME "add_with_target_name")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		binary_target(ADD_DEPENDENCIES "new_static_mock_lib"
			DEPENDENCIES "dep_static_mock_lib_1" "dep_static_mock_lib_2")
		get_target_property(output_bin_property "new_static_mock_lib"
			INTERFACE_LINK_LIBRARIES)
		ct_assert_equal(output_bin_property "dep_static_mock_lib_1;dep_static_mock_lib_2")
		get_target_property(output_bin_property "new_static_mock_lib"
			LINK_LIBRARIES)
		ct_assert_equal(output_bin_property "dep_static_mock_lib_1;dep_static_mock_lib_2")

		binary_target(ADD_DEPENDENCIES "new_shared_mock_lib"
			DEPENDENCIES "dep_shared_mock_lib_1" "dep_shared_mock_lib_2")
		get_target_property(output_bin_property "new_shared_mock_lib"
			INTERFACE_LINK_LIBRARIES)
		ct_assert_equal(output_bin_property "dep_shared_mock_lib_1;dep_shared_mock_lib_2")
		get_target_property(output_bin_property "new_shared_mock_lib"
			LINK_LIBRARIES)
		ct_assert_equal(output_bin_property "dep_shared_mock_lib_1;dep_shared_mock_lib_2")
	endfunction()

	ct_add_section(NAME "add_with_gen_expr")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "add_all_interfaces")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			binary_target(ADD_DEPENDENCIES "new_static_mock_lib"
				DEPENDENCIES
					"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
					"$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>;$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>;$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)

			binary_target(ADD_DEPENDENCIES "new_shared_mock_lib"
				DEPENDENCIES
					"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
					"$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>;$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>;$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
		endfunction()

		ct_add_section(NAME "add_build_interfaces")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			binary_target(ADD_DEPENDENCIES "new_static_mock_lib"
				DEPENDENCIES
					"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)

			binary_target(ADD_DEPENDENCIES "new_shared_mock_lib"
				DEPENDENCIES
					"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<BUILD_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
		endfunction()

		ct_add_section(NAME "add_install_interfaces")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			binary_target(ADD_DEPENDENCIES "new_static_mock_lib"
				DEPENDENCIES
					"$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_static_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<INSTALL_INTERFACE:dep_static_mock_lib_1;dep_static_mock_lib_2>"
			)

			binary_target(ADD_DEPENDENCIES "new_shared_mock_lib"
				DEPENDENCIES
					"$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				INTERFACE_LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
			get_target_property(output_bin_property "new_shared_mock_lib"
				LINK_LIBRARIES)
			ct_assert_equal(output_bin_property
				"$<INSTALL_INTERFACE:dep_shared_mock_lib_1;dep_shared_mock_lib_2>"
			)
		endfunction()
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_DEPENDENCIES
			DEPENDENCIES "dep_shared_mock_lib_1")
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_DEPENDENCIES ""
			DEPENDENCIES "dep_shared_mock_lib_1")
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_DEPENDENCIES "unknown_target"
			DEPENDENCIES "dep_shared_mock_lib_1")
	endfunction()

	ct_add_section(NAME "throws_if_arg_dependencies_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_DEPENDENCIES "new_shared_mock_lib")
	endfunction()

	ct_add_section(NAME "throws_if_arg_dependencies_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		binary_target(ADD_DEPENDENCIES "new_shared_mock_lib"
			DEPENDENCIES)
	endfunction()
endfunction()
