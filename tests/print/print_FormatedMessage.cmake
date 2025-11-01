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
# Test of [Print module::default operation]:
#    print([<mode>] "message with formated text" <argument>...)
ct_add_test(NAME "test_print_formated_message_operation")
function(${CMAKETEST_TEST})
  include(Print)

  # Functionalities checking
  ct_add_section(NAME "print_empty_message")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      print("")
      ct_assert_prints("")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      print(STATUS "")
      ct_assert_prints("")

      # The extra argument should be ignored
      print(STATUS "" "extra argument")
      ct_assert_prints("")
    endfunction()

  endfunction()

  ct_add_section(NAME "print_message_without_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "a text to print")
      print("${input}")
      ct_assert_prints("${input}")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "a text to print")
      print(STATUS "${input}")
      ct_assert_prints("${input}") # This function ignores the status mode

      # The extra argument should be ignored
      print(STATUS "${input}" "extra argument")
      ct_assert_prints("${input}") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_ap_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "../data/src/main.cpp")
      set(expected_result "${TESTS_DATA_DIR}/src/main.cpp")

      print("Absolute: @ap@." "${input}")
      ct_assert_prints("Absolute: ${expected_result}.")

      # Test with empty input
      print("Absolute: @ap@." "")
      ct_assert_prints("Absolute: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "../data/src/main.cpp")
      set(expected_result "${TESTS_DATA_DIR}/src/main.cpp")

      print(STATUS "Absolute: @ap@." "${input}")
      ct_assert_prints("Absolute: ${expected_result}.") # This function ignores the status mode

      # Test with empty input
      print(STATUS "Absolute: @ap@." "")
      ct_assert_prints("Absolute: .") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_rp_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "${TESTS_DATA_DIR}/src/main.cpp")
      set(expected_result "../data/src/main.cpp")

      print("Relative: @rp@." "${input}")
      ct_assert_prints("Relative: ${expected_result}.")

      # Test with empty input
      print("Relative: @rp@." "")
      ct_assert_prints("Relative: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input "${TESTS_DATA_DIR}/src/main.cpp")
      set(expected_result "../data/src/main.cpp")

      print(STATUS "Relative: @rp@." "${input}")
      ct_assert_prints("Relative: ${expected_result}.") # This function ignores the status mode

      # Test with empty input
      print(STATUS "Relative: @rp@." "")
      ct_assert_prints("Relative: .") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_apl_directive")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")

      print("Absolute path list: @apl@." "${input}")
      ct_assert_prints("Absolute path list: ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp.")

      # Test with empty input
      print("Absolute path list: @apl@." "")
      ct_assert_prints("Absolute path list: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")

      print(STATUS "Absolute path list: @apl@." "${input}")
      ct_assert_prints("Absolute path list: ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp.") # This function ignores the status mode
      
      # Test with empty input
      print(STATUS "Absolute path list: @apl@." "")
      ct_assert_prints("Absolute path list: .") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_rpl_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")

      print("Relative path list: @rpl@." "${input}")
      ct_assert_prints("Relative path list: ../data/src/main.cpp, ../data/src/source_1.cpp, ../data/src/source_2.cpp, ../data/src/source_3.cpp, ../data/src/source_4.cpp, ../data/src/source_5.cpp, ../data/src/sub_1/source_sub_1.cpp, ../data/src/sub_2/source_sub_2.cpp.")

      # Test with empty input
      print("Relative path list: @rpl@." "")
      ct_assert_prints("Relative path list: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      set(input
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")

      print(STATUS "Relative path list: @rpl@." "${input}")
      ct_assert_prints("Relative path list: ../data/src/main.cpp, ../data/src/source_1.cpp, ../data/src/source_2.cpp, ../data/src/source_3.cpp, ../data/src/source_4.cpp, ../data/src/source_5.cpp, ../data/src/sub_1/source_sub_1.cpp, ../data/src/sub_2/source_sub_2.cpp.") # This function ignores the status mode
      
      # Test with empty input
      print(STATUS "Relative path list: @rpl@." "")
      ct_assert_prints("Relative path list: .") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_mixed_directives")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
      
      # RP + AP
      set(input_relative_path "../data/src/main.cpp")
      set(input_absolute_path "${TESTS_DATA_DIR}/src/main.cpp")
      print("Relative: @rp@, Absolute: @ap@." "${input_absolute_path}" "${input_relative_path}")
      ct_assert_prints("Relative: ../data/src/main.cpp, Absolute: ${TESTS_DATA_DIR}/src/main.cpp.")

      # Test RP + AP with empty input
      print("Relative: @rp@, Absolute: @ap@." "" "")
      ct_assert_prints("Relative: , Absolute: .")

      # RP + APL
      set(input_relative_path_list
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print("Relative: @rp@, Absolute path list: @apl@." "${input_absolute_path}" "${input_relative_path_list}")
      ct_assert_prints("Relative: ../data/src/main.cpp, Absolute path list: ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp.")

      # Test RP + APL with empty input
      print("Relative: @rp@, Absolute path list: @apl@." "" "")
      ct_assert_prints("Relative: , Absolute path list: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")

      # RP + AP
      set(input_relative_path "../data/src/main.cpp")
      set(input_absolute_path "${TESTS_DATA_DIR}/src/main.cpp")
      print(STATUS "Relative: @rp@, Absolute: @ap@." "${input_absolute_path}" "${input_relative_path}")
      ct_assert_prints("Relative: ../data/src/main.cpp, Absolute: ${TESTS_DATA_DIR}/src/main.cpp.") # This function ignores the status mode

      # Test RP + AP with empty input
      print(STATUS "Relative: @rp@, Absolute: @ap@." "" "")
      ct_assert_prints("Relative: , Absolute: .") # This function ignores the status mode

      # RP + APL
      set(input_relative_path_list
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print(STATUS "Relative: @rp@, Absolute path list: @apl@." "${input_absolute_path}" "${input_relative_path_list}")
      ct_assert_prints("Relative: ../data/src/main.cpp, Absolute path list: ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp.") # This function ignores the status mode

      # Test RP + APL with empty input
      print(STATUS "Relative: @rp@, Absolute path list: @apl@." "" "")
      ct_assert_prints("Relative: , Absolute path list: .") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_sl_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(input
        "apple"
        "banana"
        "orange"
        "pineapple"
        "carrot"
        "strawberry"
        "pineapple"
        "grape"
        "lemon"
        "watermelon")
      print("String list: @sl@." "${input}")
      ct_assert_prints("String list: banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon.")

      # Test with empty input
      print("String list: @sl@." "")
      ct_assert_prints("String list: .")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(input
        "apple"
        "banana"
        "orange"
        "pineapple"
        "carrot"
        "strawberry"
        "pineapple"
        "grape"
        "lemon"
        "watermelon")
      print(STATUS "String list: @sl@." "${input}")
      ct_assert_prints("String list: banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon.") # This function ignores the status mode

      # Test with empty input
      print(STATUS "String list: @sl@." "")
      ct_assert_prints("String list: .") # This function ignores the status mode
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_arg_message_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print()
  endfunction()

  ct_add_section(NAME "throws_if_arg_message_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("")
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Absolute: @ap@")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Relative: @rp@")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_directrive_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Absolute: @ap@, Relative: @rp@")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_directrive_is_unsupported" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("What: @what@" "value")
  endfunction()

  ct_add_section(NAME "throws_if_apl_directrive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
    set(input_absolute_path "${TESTS_DATA_DIR}/src/main.cpp")
    set(input_relative_path_list
      "../data/src/main.cpp"
      "../data/src/source_1.cpp"
      "../data/src/source_2.cpp"
      "../data/src/source_3.cpp"
      "../data/src/source_4.cpp"
      "../data/src/source_5.cpp"
      "../data/src/sub_1/source_sub_1.cpp"
      "../data/src/sub_2/source_sub_2.cpp")
    print("Absolute path list: @apl@, Relative: @rp@." "${input_relative_path_list}" "${input_absolute_path}")
  endfunction()

  ct_add_section(NAME "throws_if_rpl_directrive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
    set(input_relative_path "data/src/main.cpp")
    set(input_absolute_path_list
      "${TESTS_DATA_DIR}/src/main.cpp"
      "${TESTS_DATA_DIR}/src/source_1.cpp"
      "${TESTS_DATA_DIR}/src/source_2.cpp"
      "${TESTS_DATA_DIR}/src/source_3.cpp"
      "${TESTS_DATA_DIR}/src/source_4.cpp"
      "${TESTS_DATA_DIR}/src/source_5.cpp"
      "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
      "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
    print("Relative path list: @rpl@, Absolute: @ap@." "${input_absolute_path_list}" "${input_relative_path}")
  endfunction()

  ct_add_section(NAME "throws_if_sl_directrive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")
    set(input_relative_path "data/src/main.cpp")
    set(input_string_list
        "apple"
        "banana"
        "orange"
        "pineapple"
        "carrot"
        "strawberry"
        "pineapple"
        "grape"
        "lemon"
        "watermelon")
    print("String list: @sl@, Absolute: @ap@." "${input_string_list}" "${input_relative_path}")
  endfunction()
endfunction()
