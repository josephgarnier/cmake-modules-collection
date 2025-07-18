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
# Test of [BuildBinTarget module::CONFIGURE_SETTINGS operation]:
#    build_bin_target(CONFIGURE_SETTINGS <target-name>
#                    [COMPILER_FEATURES <feature>...]
#                    [COMPILE_DEFINITIONS <definition>...]
#                    [COMPILE_OPTIONS <option>...]
#                    [LINK_OPTIONS <option>...])
ct_add_test(NAME "test_build_bin_target_configure_settings_operation")
function(${CMAKETEST_TEST})
	include(BuildBinTarget)

	# Create a mock bin static target for tests
	macro(_create_mock_bins)
		add_library("new_static_mock_lib" STATIC)
		target_sources("new_static_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error

		add_library("new_shared_mock_lib" SHARED)
		target_sources("new_shared_mock_lib" PRIVATE "${TESTS_DATA_DIR}/src/main.cpp") # A target needs at least one source to avoid an error
	endmacro()
	if(NOT TARGET "new_static_mock_lib" OR NOT TARGET "new_shared_mock_lib")
		_create_mock_bins()
	endif()

	# To call before each test
	macro(_set_up_test)
		# Reset properties set by `build_bin_target(CONFIGURE_SETTINGS)`
		set_property(TARGET "new_static_mock_lib" PROPERTY COMPILE_FEATURES)
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_COMPILE_FEATURES)
		set_property(TARGET "new_static_mock_lib" PROPERTY COMPILE_DEFINITIONS)
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_COMPILE_DEFINITIONS)
		set_property(TARGET "new_static_mock_lib" PROPERTY COMPILE_OPTIONS)
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_COMPILE_OPTIONS)
		set_property(TARGET "new_static_mock_lib" PROPERTY LINK_OPTIONS)
		set_property(TARGET "new_static_mock_lib" PROPERTY INTERFACE_LINK_OPTIONS)

		set_property(TARGET "new_shared_mock_lib" PROPERTY COMPILE_FEATURES)
		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_COMPILE_FEATURES)
		set_property(TARGET "new_shared_mock_lib" PROPERTY COMPILE_DEFINITIONS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_COMPILE_DEFINITIONS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY COMPILE_OPTIONS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_COMPILE_OPTIONS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY LINK_OPTIONS)
		set_property(TARGET "new_shared_mock_lib" PROPERTY INTERFACE_LINK_OPTIONS)
	endmacro()

	# Functionalities checking
	ct_add_section(NAME "configure_nothing")
	function(${CMAKETEST_SECTION})
		_set_up_test()
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib")
		get_target_property(output_bin_property "new_static_mock_lib"
			COMPILE_FEATURES)
		ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
		ct_assert_target_does_not_have_property("new_static_mock_lib"
			INTERFACE_COMPILE_FEATURES)

		build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib")
		get_target_property(output_bin_property "new_shared_mock_lib"
			COMPILE_FEATURES)
		ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD}")
		ct_assert_target_does_not_have_property("new_shared_mock_lib"
			INTERFACE_COMPILE_FEATURES)
	endfunction()

	ct_add_section(NAME "configure_compiler_features")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "cxx_standard_is_not_duplicated")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib")
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib")
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILER_FEATURES "cxx_thread_local")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_FEATURES)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILER_FEATURES "cxx_thread_local")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_FEATURES)
		endfunction()

		ct_add_section(NAME "add_compiler_features")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local;cxx_trailing_return_types")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_FEATURES)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local;cxx_trailing_return_types")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_FEATURES)
		endfunction()

		ct_add_section(NAME "append_compiler_features")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILER_FEATURES "cxx_thread_local")
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILER_FEATURES "cxx_trailing_return_types")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local;cxx_trailing_return_types")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_FEATURES)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILER_FEATURES "cxx_thread_local")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILER_FEATURES "cxx_trailing_return_types")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_FEATURES)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "cxx_std_${CMAKE_CXX_STANDARD};cxx_thread_local;cxx_trailing_return_types")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_FEATURES)
		endfunction()
	endfunction()

	ct_add_section(NAME "configure_compile_definitions")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "add_compile_definitions")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_DEFINITIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "DEFINE_ONE;DEFINE_TWO")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_DEFINITIONS)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_DEFINITIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "DEFINE_ONE;DEFINE_TWO")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_DEFINITIONS)
		endfunction()

		ct_add_section(NAME "append_compile_definitions")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_ONE")
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_TWO")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_DEFINITIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "DEFINE_ONE;DEFINE_TWO")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_DEFINITIONS)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_ONE")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_DEFINITIONS "DEFINE_TWO")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_DEFINITIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "DEFINE_ONE;DEFINE_TWO")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_DEFINITIONS)
		endfunction()
	endfunction()

	ct_add_section(NAME "configure_compile_options")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "add_compile_options")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_OPTIONS "-Wall" "-Wextra")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_OPTIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-Wall;-Wextra")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_OPTIONS)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_OPTIONS "-Wall" "-Wextra")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_OPTIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-Wall;-Wextra")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_OPTIONS)
		endfunction()

		ct_add_section(NAME "append_compile_options")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_OPTIONS "-Wall")
			build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
				COMPILE_OPTIONS "-Wextra")
			get_target_property(output_bin_property "new_static_mock_lib"
				COMPILE_OPTIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-Wall;-Wextra")
			ct_assert_target_does_not_have_property("new_static_mock_lib"
				INTERFACE_COMPILE_OPTIONS)

			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_OPTIONS "-Wall")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				COMPILE_OPTIONS "-Wextra")
			get_target_property(output_bin_property "new_shared_mock_lib"
				COMPILE_OPTIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-Wall;-Wextra")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_COMPILE_OPTIONS)
		endfunction()
	endfunction()

	ct_add_section(NAME "configure_link_options")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "add_link_options")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			# Link options cannot be add to a static library, so it will be ignored
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				LINK_OPTIONS "-s" "-z")
			get_target_property(output_bin_property "new_shared_mock_lib"
				LINK_OPTIONS)
			message("output_bin_property: ${output_bin_property}")
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-s;-z")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_LINK_OPTIONS)
		endfunction()

		ct_add_section(NAME "append_link_options")
		function(${CMAKETEST_SECTION})
			_set_up_test()
			# Link options cannot be add to a static library, so it will be ignored
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				LINK_OPTIONS "-s")
			build_bin_target(CONFIGURE_SETTINGS "new_shared_mock_lib"
				LINK_OPTIONS "-z")
			get_target_property(output_bin_property "new_shared_mock_lib"
				LINK_OPTIONS)
			ct_assert_list(output_bin_property)
			ct_assert_equal(output_bin_property "-s;-z")
			ct_assert_target_does_not_have_property("new_shared_mock_lib"
				INTERFACE_LINK_OPTIONS)
		endfunction()
	endfunction()

	# Errors checking
	ct_add_section(NAME "throws_if_arg_target_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS ""
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_target_is_unknown" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "unknown_target"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compiler_features_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compiler_features_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES ""
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compile_definitions_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compile_definitions_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS ""
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compile_options_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_compile_options_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS ""
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_link_options_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_link_options_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS ""
		)
	endfunction()

	ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		unset(CMAKE_CXX_STANDARD)
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()

	ct_add_section(NAME "throws_if_cmake_cxx_standard_is_not_set_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(CMAKE_CXX_STANDARD "")
		build_bin_target(CONFIGURE_SETTINGS "new_static_mock_lib"
			COMPILER_FEATURES "cxx_thread_local" "cxx_trailing_return_types"
			COMPILE_DEFINITIONS "DEFINE_ONE" "DEFINE_TWO"
			COMPILE_OPTIONS "-Wall" "-Wextra"
			LINK_OPTIONS "-s" "-z"
		)
	endfunction()
endfunction()
