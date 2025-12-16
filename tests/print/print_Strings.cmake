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
# Test of [Print module::LISTS operation]:
#    print([<mode>] STRINGS [<string>...] [INDENT])
ct_add_test(NAME "test_print_strings_operation")
function(${CMAKETEST_TEST})
  include(Print)

  # Functionalities checking
  ct_add_section(NAME "print_empty_message")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      print(STRINGS)
      ct_assert_prints("")

      print(STRINGS INDENT)
      ct_assert_prints("")

      print(STRINGS "")
      ct_assert_prints("")

      print(STRINGS "" INDENT)
      ct_assert_prints("")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      print(STATUS STRINGS)
      ct_assert_prints("")

      print(STATUS STRINGS INDENT)
      ct_assert_prints("")

      print(STATUS STRINGS "")
      ct_assert_prints("")

      print(STATUS STRINGS "" INDENT)
      ct_assert_prints("")
    endfunction()
  endfunction()

  ct_add_section(NAME "print_strings")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "without_mode")
    function(${CMAKETEST_SECTION})
      set(input_strings
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
      print(STRINGS ${input_strings})
      ct_assert_prints("apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon")

      print(STRINGS ${input_strings} INDENT)
      ct_assert_prints("apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon")
    endfunction()

    ct_add_section(NAME "with_mode")
    function(${CMAKETEST_SECTION})
      set(input_strings
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
      print(STATUS STRINGS ${input_strings})
      ct_assert_prints("apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon")

      print(STATUS STRINGS ${input_strings} INDENT)
      ct_assert_prints("apple, banana, orange, pineapple, carrot, strawberry, pineapple, grape, lemon, watermelon")
    endfunction()
  endfunction()

  # Errors checking
endfunction()
