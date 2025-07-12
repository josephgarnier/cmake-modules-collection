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
# Test of [Directory module::FIND_LIB operation]:
#    directory(FIND_LIB <output-lib-var>
#             FIND_IMPLIB <output-implib-var>
#             NAME <raw-filename>
#             <STATIC|SHARED>
#             RELATIVE <on|off>
#             ROOT_DIR <directory-path>)
ct_add_test(NAME "test_directory_find_lib_operation")
function(${CMAKETEST_TEST})
	include(Directory)

	macro(_build_test_regex LIB_NAME LIB_BINARY_TYPE)
		# Select appropriate prefix/suffix sets based on the requested library type
		if("${LIB_BINARY_TYPE}" STREQUAL "SHARED")
			# Shared library (.dll, .so, .dylib): used at runtime (IMPORTED_LOCATION)
			set(lib_prefix_list "${CMAKE_SHARED_LIBRARY_PREFIX}")
			set(lib_suffix_list "${CMAKE_SHARED_LIBRARY_SUFFIX}")

			# Import library (.lib, .dll.a, .a): used at link time (IMPORTED_IMPLIB)
			set(implib_prefix_list "${CMAKE_FIND_LIBRARY_PREFIXES}")
			set(implib_suffix_list "${CMAKE_FIND_LIBRARY_SUFFIXES}")
		elseif("${LIB_BINARY_TYPE}" STREQUAL "STATIC")
			# Static library (.lib, .a): used at link time (no import lib concept)
			set(lib_prefix_list "${CMAKE_STATIC_LIBRARY_PREFIX}")
			set(lib_suffix_list "${CMAKE_STATIC_LIBRARY_SUFFIX}")

			# Static libraries do not use import libraries
			set(implib_prefix_list "")
			set(implib_suffix_list "")
		else()
			message(FATAL_ERROR "Invalid build type: expected SHARED or STATIC!")
		endif()

		# Build regex to find the binary library (IMPORTED_LOCATION)
		string(REGEX REPLACE [[\.]] [[\\.]] lib_suffix_list "${lib_suffix_list}") # escape '.' char
		set(LIB_REGEX "^(${lib_prefix_list})?${LIB_NAME}(${lib_suffix_list})$")
		
		# Build regex to find the import library (IMPORTED_IMPLIB), only if applicable
		if(NOT "${implib_suffix_list}" STREQUAL "")
			list(JOIN implib_prefix_list "|" implib_prefix_list)
			list(JOIN implib_suffix_list "|" implib_suffix_list)
			string(REGEX REPLACE [[\.]] [[\\.]] implib_suffix_list "${implib_suffix_list}") # escape '.' char
			set(IMPLIB_REGEX "^(${implib_prefix_list})?${LIB_NAME}(${implib_suffix_list})$")
		else()
			# No import library applicable for static libraries
			set(IMPLIB_REGEX "")
		endif()
	endmacro()

	# Functionalities checking
	ct_add_section(NAME "find_static_lib")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "static_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			_build_test_regex("${lib_name}" "STATIC")

			ct_assert_string(output_lib)
			ct_assert_true(output_lib)
			cmake_path(GET output_lib PARENT_PATH lib_dir_path)
			ct_assert_equal(lib_dir_path "${TESTS_DATA_DIR}/bin")
			cmake_path(GET output_lib FILENAME lib_file_name)
			ct_assert_regex_equal(lib_file_name "${LIB_REGEX}")

			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "static_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			_build_test_regex("${lib_name}" "STATIC")

			ct_assert_string(output_lib)
			ct_assert_true(output_lib)
			cmake_path(GET output_lib PARENT_PATH lib_dir_path)
			ct_assert_equal(lib_dir_path "bin")
			cmake_path(GET output_lib FILENAME lib_file_name)
			ct_assert_regex_equal(lib_file_name "${LIB_REGEX}")

			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"
		endfunction()
	endfunction()
	
	ct_add_section(NAME "find_shared_lib")
	function(${CMAKETEST_SECTION})

		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "shared_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				SHARED
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			_build_test_regex("${lib_name}" "SHARED")

			ct_assert_string(output_lib)
			ct_assert_true(output_lib)
			cmake_path(GET output_lib PARENT_PATH lib_dir_path)
			ct_assert_equal(lib_dir_path "${TESTS_DATA_DIR}/bin")
			cmake_path(GET output_lib FILENAME lib_file_name)
			ct_assert_regex_equal(lib_file_name "${LIB_REGEX}")

			ct_assert_string(output_implib)
			ct_assert_true(output_implib)
			cmake_path(GET output_implib PARENT_PATH implib_dir_path)
			ct_assert_equal(lib_dir_path "${TESTS_DATA_DIR}/bin")
			cmake_path(GET output_implib FILENAME implib_file_name)
			ct_assert_regex_equal(implib_file_name "${IMPLIB_REGEX}")
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "shared_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				SHARED
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			_build_test_regex("${lib_name}" "SHARED")

			ct_assert_string(output_lib)
			ct_assert_true(output_lib)
			cmake_path(GET output_lib PARENT_PATH lib_dir_path)
			ct_assert_equal(lib_dir_path "bin")
			cmake_path(GET output_lib FILENAME lib_file_name)
			ct_assert_regex_equal(lib_file_name "${LIB_REGEX}")

			ct_assert_string(output_implib)
			ct_assert_true(output_implib)
			cmake_path(GET output_implib PARENT_PATH implib_dir_path)
			ct_assert_equal(lib_dir_path "bin")
			cmake_path(GET output_implib FILENAME implib_file_name)
			ct_assert_regex_equal(implib_file_name "${IMPLIB_REGEX}")
		endfunction()

	endfunction()

	ct_add_section(NAME "find_not_existing_static_lib")
	function(${CMAKETEST_SECTION})
	
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "fake_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"

			# Try to find an existing lib but with the wrong build type should fail
			set(lib_name "shared_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"
		endfunction()

		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "fake_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"

			# Try to find an existing lib but with the wrong build type should fail
			set(lib_name "shared_mock_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				STATIC
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"
		endfunction()
	endfunction()

	ct_add_section(NAME "find_not_existing_shared_lib")
	function(${CMAKETEST_SECTION})
		ct_add_section(NAME "get_absolute_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "fake_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				SHARED
				RELATIVE off
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"

			# On Windows, a static libary can have the same suffix ('.a' for GCC,
			# '.lib' for MSVC) as a shared import library suffix ('.dll.a|.a|.lib'
			# for GCC, '.dll.lib|.lib|.a' for MSVC)
			if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
				set(lib_name "static_mock_lib")
				directory(FIND_LIB output_lib
					FIND_IMPLIB output_implib
					NAME "${lib_name}"
					SHARED
					RELATIVE off
					ROOT_DIR "${TESTS_DATA_DIR}"
				)
				ct_assert_string(output_lib)
				ct_assert_equal(output_lib "output_lib-NOTFOUND")
				ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
				ct_assert_string(output_implib)
				ct_assert_true(output_implib) # NOT equals to "output_implib-NOTFOUND"
			endif()
		endfunction()
		
		ct_add_section(NAME "get_relative_path")
		function(${CMAKETEST_SECTION})
			set(lib_name "fake_lib")
			directory(FIND_LIB output_lib
				FIND_IMPLIB output_implib
				NAME "${lib_name}"
				SHARED
				RELATIVE on
				ROOT_DIR "${TESTS_DATA_DIR}"
			)
			ct_assert_string(output_lib)
			ct_assert_equal(output_lib "output_lib-NOTFOUND")
			ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
			ct_assert_string(output_implib)
			ct_assert_equal(output_implib "output_implib-NOTFOUND")
			ct_assert_false(output_implib) # equals to "output_implib-NOTFOUND"

			# On Windows, a static libary can have the same suffix ('.a' for GCC,
			# '.lib' for MSVC) as a shared import library suffix ('.dll.a|.a|.lib'
			# for GCC, '.dll.lib|.lib|.a' for MSVC)
			if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
				set(lib_name "static_mock_lib")
				directory(FIND_LIB output_lib
					FIND_IMPLIB output_implib
					NAME "${lib_name}"
					SHARED
					RELATIVE on
					ROOT_DIR "${TESTS_DATA_DIR}"
				)
				ct_assert_string(output_lib)
				ct_assert_equal(output_lib "output_lib-NOTFOUND")
				ct_assert_false(output_lib) # equals to "output_lib-NOTFOUND"
				ct_assert_string(output_implib)
				ct_assert_true(output_implib) # NOT equals to "fake_lib-NOTFOUND"
			endif()
		endfunction()
	endfunction()

	# # Errors checking
	ct_add_section(NAME "throws_if_lib_is_duplicated" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		file(COPY "${TESTS_DATA_DIR}/bin" DESTINATION "${TESTS_DATA_DIR}/bin_temp_copy")	
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
		file(REMOVE_RECURSE "${TESTS_DATA_DIR}/bin_temp_copy")
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_output_lib_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_lib_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB ""
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_lib_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB "output_lib"
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_implib_var_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_implib_var_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB ""
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_output_implib_var_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB "output_implib"
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_name_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_name_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_name_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME ""
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_binary_type_is_missing" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_binary_type_is_twice" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED STATIC
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_relative_var_is_not_boolean" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE "not-bool"
			ROOT_DIR "${TESTS_DATA_DIR}"
		)
	endfunction()
	
	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_1" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_2" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_missing_3" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR ""
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_does_not_exists" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "fake/directory"
		)
	endfunction()

	ct_add_section(NAME "throws_if_arg_root_dir_is_not_a_directory" EXPECTFAIL)
	function(${CMAKETEST_SECTION})
		set(lib_name "shared_mock_lib")
		directory(FIND_LIB output_lib
			FIND_IMPLIB output_implib
			NAME "${lib_name}"
			SHARED
			RELATIVE off
			ROOT_DIR "${TESTS_DATA_DIR}/src/source_1.cpp"
		)
	endfunction()
endfunction()
