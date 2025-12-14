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

  set(PRINT_BASE_DIR "${CMAKE_CURRENT_FUNCTION_LIST_DIR}")

  # Functionalities checking
  ct_add_section(NAME "print_empty_message")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print("")
      ct_assert_prints("")

      # Test with extra argument
      print("" "extra argument")
      ct_assert_prints("")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS "")
      ct_assert_prints("")

      # Test with extra argument
      print(STATUS "" "extra argument")
      ct_assert_prints("")
    endfunction()

  endfunction()

  ct_add_section(NAME "print_message_without_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print("a text to print")
      ct_assert_prints("a text to print")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      # Test with no argument
      print(STATUS "a text to print")
      ct_assert_prints("a text to print") # This function ignores the status mode

      # Test with extra argument
      print(STATUS "a text to print" "extra argument")
      ct_assert_prints("a text to print") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_ap_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print("Before @ap@ After" "../data/src/main.cpp")
      ct_assert_prints("Before ${TESTS_DATA_DIR}/src/main.cpp After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS "Before @ap@ After" "../data/src/main.cpp")
      ct_assert_prints("Before ${TESTS_DATA_DIR}/src/main.cpp After") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_rp_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print("Before @rp@ After" "${TESTS_DATA_DIR}/src/main.cpp")
      ct_assert_prints("Before ../data/src/main.cpp After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS "Before @rp@ After" "${TESTS_DATA_DIR}/src/main.cpp")
      ct_assert_prints("Before ../data/src/main.cpp After") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_apl_directive")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_paths_arg
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print("Before @apl@ After" ${input_paths_arg})
      ct_assert_prints("Before ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp After")

      # Test with empty argument
      print("Before @apl@ After" "")
      ct_assert_prints("Before  After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_paths_arg
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print(STATUS "Before @apl@ After" ${input_paths_arg})
      ct_assert_prints("Before ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp After") # This function ignores the status mode

      # Test with empty argument
      print(STATUS "Before @apl@ After" "")
      ct_assert_prints("Before  After") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_rpl_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_paths_arg
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      print("Before @rpl@ After" ${input_paths_arg})
      ct_assert_prints("Before ../data/src/main.cpp, ../data/src/source_1.cpp, ../data/src/source_2.cpp, ../data/src/source_3.cpp, ../data/src/source_4.cpp, ../data/src/source_5.cpp, ../data/src/sub_1/source_sub_1.cpp, ../data/src/sub_2/source_sub_2.cpp After")

      # Test with empty argument
      print("Before @rpl@ After" "")
      ct_assert_prints("Before  After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_paths_arg
        "${TESTS_DATA_DIR}/src/main.cpp"
        "${TESTS_DATA_DIR}/src/source_1.cpp"
        "${TESTS_DATA_DIR}/src/source_2.cpp"
        "${TESTS_DATA_DIR}/src/source_3.cpp"
        "${TESTS_DATA_DIR}/src/source_4.cpp"
        "${TESTS_DATA_DIR}/src/source_5.cpp"
        "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
        "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
      print(STATUS "Before @rpl@ After" ${input_paths_arg})
      ct_assert_prints("Before ../data/src/main.cpp, ../data/src/source_1.cpp, ../data/src/source_2.cpp, ../data/src/source_3.cpp, ../data/src/source_4.cpp, ../data/src/source_5.cpp, ../data/src/sub_1/source_sub_1.cpp, ../data/src/sub_2/source_sub_2.cpp After") # This function ignores the status mode

      # Test with empty argument
      print(STATUS "Before @rpl@ After" "")
      ct_assert_prints("Before  After") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_mixed_directives")
  function(${CMAKETEST_SECTION})
  
    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      # RP + AP
      print("Before @rp@ Middle @ap@ After" "${TESTS_DATA_DIR}/src/main.cpp" "../data/src/main.cpp")
      ct_assert_prints("Before ../data/src/main.cpp Middle ${TESTS_DATA_DIR}/src/main.cpp After")

      # RP + APL
      set(input_paths_arg
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print("Before @rp@ Middle @apl@ After" "${TESTS_DATA_DIR}/src/main.cpp" ${input_paths_arg})
      ct_assert_prints("Before ../data/src/main.cpp Middle ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp After")

      # RP + APL with empty argument
      print("Before @rp@ Middle @apl@ After" "${TESTS_DATA_DIR}/src/main.cpp" "")
      ct_assert_prints("Before ../data/src/main.cpp Middle  After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      # RP + AP
      print(STATUS "Before @rp@ Middle @ap@ After" "${TESTS_DATA_DIR}/src/main.cpp" "../data/src/main.cpp")
      ct_assert_prints("Before ../data/src/main.cpp Middle ${TESTS_DATA_DIR}/src/main.cpp After")

      # RP + APL
      set(input_paths_arg
        "../data/src/main.cpp"
        "../data/src/source_1.cpp"
        "../data/src/source_2.cpp"
        "../data/src/source_3.cpp"
        "../data/src/source_4.cpp"
        "../data/src/source_5.cpp"
        "../data/src/sub_1/source_sub_1.cpp"
        "../data/src/sub_2/source_sub_2.cpp")
      print(STATUS "Before @rp@ Middle @apl@ After" "${TESTS_DATA_DIR}/src/main.cpp" ${input_paths_arg})
      ct_assert_prints("Before ../data/src/main.cpp Middle ${TESTS_DATA_DIR}/src/main.cpp, ${TESTS_DATA_DIR}/src/source_1.cpp, ${TESTS_DATA_DIR}/src/source_2.cpp, ${TESTS_DATA_DIR}/src/source_3.cpp, ${TESTS_DATA_DIR}/src/source_4.cpp, ${TESTS_DATA_DIR}/src/source_5.cpp, ${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp, ${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp After") # This function ignores the status mode

      # RP + APL with empty argument
      print("Before @rp@ Middle @apl@ After" "${TESTS_DATA_DIR}/src/main.cpp" "")
      ct_assert_prints("Before ../data/src/main.cpp Middle  After") # This function ignores the status mode
    endfunction()
  endfunction()

  ct_add_section(NAME "print_message_with_sl_directive")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_strings_arg
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
      print("Before @sl@ After" ${input_strings_arg})
      ct_assert_prints("Before apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon After")

      # Test with empty argument
      print("Before @sl@ After" "")
      ct_assert_prints("Before  After")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      # Test with input argument
      set(input_strings_arg
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
      print(STATUS "Before @sl@ After" ${input_strings_arg})
      ct_assert_prints("Before apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon After") # This function ignores the status mode

      # Test with empty argument
      print(STATUS "Before @sl@ After" "")
      ct_assert_prints("Before  After") # This function ignores the status mode
    endfunction()
  endfunction()

  # Errors checking
  ct_add_section(NAME "throws_if_message_is_missing" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print()
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_unsupported_directive_is_missing1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@unsupported@")
  endfunction()

  ct_add_section(NAME "throws_if_message_has_unsupported_directive_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@unsupported@" "")
  endfunction()

  ct_add_section(NAME "throws_if_message_has_unsupported_directive_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @unsupported@" "")
  endfunction()

  ct_add_section(NAME "throws_if_message_has_unsupported_directive_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@unsupported@ After" "")
  endfunction()

  ct_add_section(NAME "throws_if_message_has_unsupported_directive_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @unsupported@ After" "")
  endfunction()

  foreach(directive IN ITEMS "ap" "rp" "sl" "apl" "rpl")
    ct_add_section(NAME "throws_if_arg_for_${directive}_directive_is_missing_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("@${directive}@")
    endfunction()

    ct_add_section(NAME "throws_if_arg_for_${directive}_directive_is_missing_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("Before @${directive}@")
    endfunction()

    ct_add_section(NAME "throws_if_arg_for_${directive}_directive_is_missing_3" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("@${directive}@ After")
    endfunction()
    
    ct_add_section(NAME "throws_if_arg_for_${directive}_directive_is_missing_4" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("Before @${directive}@ After")
    endfunction()

    ct_add_section(NAME "throws_if_${directive}_directive_is_mixed_with_unsupported_directive_1" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("@unsupported@ @${directive}@" "arg" "${TESTS_DATA_DIR}/src/main.cpp")
    endfunction()

    ct_add_section(NAME "throws_if_${directive}_directive_is_mixed_with_unsupported_directive_2" EXPECTFAIL)
    function(${CMAKETEST_SECTION})
      print("@${directive}@ @unsupported@" "${TESTS_DATA_DIR}/src/main.cpp" "arg")
    endfunction()
  endforeach()

  ct_add_section(NAME "throws_if_arg_for_ap_directive_is_empty_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@ap@" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_ap_directive_is_empty_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @ap@" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_ap_directive_is_empty_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@ap@ After" "")
  endfunction()
  
  ct_add_section(NAME "throws_if_arg_for_ap_directive_is_empty_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @ap@ After" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_rp_directive_is_empty_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@rp@" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_rp_directive_is_empty_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @rp@" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_rp_directive_is_empty_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("@rp@ After" "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_for_rp_directive_is_empty_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    print("Before @rp@ After" "")
  endfunction()

  ct_add_section(NAME "throws_if_apl_directive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input_paths_arg
      "../data/src/main.cpp"
      "../data/src/source_1.cpp"
      "../data/src/source_2.cpp"
      "../data/src/source_3.cpp"
      "../data/src/source_4.cpp"
      "../data/src/source_5.cpp"
      "../data/src/sub_1/source_sub_1.cpp"
      "../data/src/sub_2/source_sub_2.cpp")
    print("Before @apl@ Middle @rp@ After" ${input_paths_arg} "${TESTS_DATA_DIR}/src/main.cpp")
  endfunction()

  ct_add_section(NAME "throws_if_rpl_directive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input_paths_arg
      "${TESTS_DATA_DIR}/src/main.cpp"
      "${TESTS_DATA_DIR}/src/source_1.cpp"
      "${TESTS_DATA_DIR}/src/source_2.cpp"
      "${TESTS_DATA_DIR}/src/source_3.cpp"
      "${TESTS_DATA_DIR}/src/source_4.cpp"
      "${TESTS_DATA_DIR}/src/source_5.cpp"
      "${TESTS_DATA_DIR}/src/sub_1/source_sub_1.cpp"
      "${TESTS_DATA_DIR}/src/sub_2/source_sub_2.cpp")
    print("Before @rpl@ Middle @ap@ After" ${input_paths_arg} "data/src/main.cpp")
  endfunction()

  ct_add_section(NAME "throws_if_sl_directive_is_not_the_last" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
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
    print("Before @sl@ Middle @ap@ After" ${input_string_list} "data/src/main.cpp")
  endfunction()
endfunction()
