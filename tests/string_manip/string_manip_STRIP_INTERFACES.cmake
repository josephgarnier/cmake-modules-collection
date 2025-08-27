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
# Test of [StringManip module::STRIP_INTERFACES operation]:
#    string_manip(STRIP_INTERFACES <string-var> [OUTPUT_VARIABLE <output-var>])
ct_add_test(NAME "test_string_manip_strip_interfaces_operation")
function(${CMAKETEST_TEST})
  include(StringManip)

  # Functionalities checking
  ct_add_section(NAME "strip_interfaces")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "inplace_version")
    function(${CMAKETEST_SECTION})
      set(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
      string_manip(STRIP_INTERFACES input)
      ct_assert_list(input)
      ct_assert_equal(input "libA;libB;libClibD")

      set(input "libA$<BUILD_INTERFACE:src>libB$<INSTALL_INTERFACE:include/>")
      string_manip(STRIP_INTERFACES input)
      ct_assert_string(input)
      ct_assert_equal(input "libAlibB")
    endfunction()

    ct_add_section(NAME "output_version")
    function(${CMAKETEST_SECTION})
      set(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
      ct_assert_list(output)
      ct_assert_equal(output "libA;libB;libClibD")

      set(input "libA$<BUILD_INTERFACE:src>libB$<INSTALL_INTERFACE:include/>")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "libA$<BUILD_INTERFACE:src>libB$<INSTALL_INTERFACE:include/>")
      ct_assert_string(output)
      ct_assert_equal(output "libAlibB")
    endfunction()
  endfunction()
  
  ct_add_section(NAME "strip_nothing_no_interfaces_detected")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "inplace_version")
    function(${CMAKETEST_SECTION})
      set(input "")
      string_manip(STRIP_INTERFACES input)
      ct_assert_string(input)
      ct_assert_equal(input "")

      set(input "libA;libB")
      string_manip(STRIP_INTERFACES input)
      ct_assert_list(input)
      ct_assert_equal(input "libA;libB")

      set(input "libAlibB")
      string_manip(STRIP_INTERFACES input)
      ct_assert_string(input)
      ct_assert_equal(input "libAlibB")
    endfunction()

    ct_add_section(NAME "output_version")
    function(${CMAKETEST_SECTION})
      set(input "")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "")
      ct_assert_string(output)
      ct_assert_equal(output "")

      set(input "libA;libB")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "libA;libB")
      ct_assert_list(output)
      ct_assert_equal(output "libA;libB")

      set(input "libAlibB")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "libAlibB")
      ct_assert_string(output)
      ct_assert_equal(output "libAlibB")
    endfunction()
  endfunction()

  ct_add_section(NAME "strip_all_when_only_interfaces_detected")
  function(${CMAKETEST_SECTION})

    ct_add_section(NAME "inplace_version")
    function(${CMAKETEST_SECTION})
      set(input "$<BUILD_INTERFACE:src>;$<INSTALL_INTERFACE:include/>")
      string_manip(STRIP_INTERFACES input)
      ct_assert_string(input)
      ct_assert_equal(input "")

      set(input "$<BUILD_INTERFACE:src>$<INSTALL_INTERFACE:include/>")
      string_manip(STRIP_INTERFACES input)
      ct_assert_string(input)
      ct_assert_equal(input "")
    endfunction()

    ct_add_section(NAME "output_version")
    function(${CMAKETEST_SECTION})
      set(input "$<BUILD_INTERFACE:src>;$<INSTALL_INTERFACE:include/>")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "$<BUILD_INTERFACE:src>;$<INSTALL_INTERFACE:include/>")
      ct_assert_string(output)
      ct_assert_equal(output "")

      set(input "$<BUILD_INTERFACE:src>$<INSTALL_INTERFACE:include/>")
      unset(output)
      string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE output)
      ct_assert_equal(input "$<BUILD_INTERFACE:src>$<INSTALL_INTERFACE:include/>")
      ct_assert_string(output)
      ct_assert_equal(output "")
    endfunction()
  endfunction()
  
  # Errors checking
  ct_add_section(NAME "throws_if_arg_string_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string_manip(STRIP_INTERFACES)
  endfunction()

  ct_add_section(NAME "throws_if_arg_string_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string_manip(STRIP_INTERFACES "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_string_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    string_manip(STRIP_INTERFACES "input")
  endfunction()

  ct_add_section(NAME "throws_if_arg_string_var_is_missing_4" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    unset(input)
    string_manip(STRIP_INTERFACES input)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_1" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
    string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE)
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_2" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
    string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE "")
  endfunction()

  ct_add_section(NAME "throws_if_arg_output_var_is_missing_3" EXPECTFAIL)
  function(${CMAKETEST_SECTION})
    set(input "libA;$<BUILD_INTERFACE:src>;libB;libC;$<INSTALL_INTERFACE:include/>libD")
    string_manip(STRIP_INTERFACES input OUTPUT_VARIABLE "output")
  endfunction()
endfunction()
