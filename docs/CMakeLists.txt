# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

cmake_minimum_required(VERSION 4.0.1 FATAL_ERROR)

####################### Create doc target #####################################
message(CHECK_START "Creating doc target")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

set(TARGET_DIR         "${CMAKE_CURRENT_SOURCE_DIR}")
set(TARGET_BUILD_DIR   "${CMAKE_CURRENT_BINARY_DIR}")
set(DOC_INPUT_DIR      "${TARGET_DIR}/source")
set(DOC_OUTPUT_DIR     "${TARGET_DIR}/build")

if(NOT TARGET "doc")
  add_custom_target("doc"
    COMMAND ${SPHINX_EXECUTABLE} -M html "${DOC_INPUT_DIR}" "${DOC_OUTPUT_DIR}"
    WORKING_DIRECTORY "${TARGET_BUILD_DIR}"
    COMMENT "Generating the doc with Sphinx..."
    VERBATIM
  )
  message(STATUS "Doc target 'doc' added to buildsystem")
endif()

# Add generated doc files to the `clean` target
set_property(DIRECTORY "${${PROJECT_NAME}_PROJECT_DIR}"
  APPEND
  PROPERTY ADDITIONAL_CLEAN_FILES
  "${DOC_OUTPUT_DIR}/doctrees"
  "${DOC_OUTPUT_DIR}/html"
)
message(STATUS "Doc files added to clean target")

list(POP_BACK CMAKE_MESSAGE_INDENT)
message(CHECK_PASS "done")
