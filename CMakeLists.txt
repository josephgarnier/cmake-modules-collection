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

####################### Declare project metadata ##############################
set(PROJECT_NAME                    "cmake-modules-collection")
set(${PROJECT_NAME}_SUMMARY         "A collection of extra macros and functions for CMake")
set(${PROJECT_NAME}_VENDOR_NAME     "Joseph Garnier")
set(${PROJECT_NAME}_VENDOR_CONTACT  "")
set(${PROJECT_NAME}_VERSION_MAJOR   "1")
set(${PROJECT_NAME}_VERSION_MINOR   "0")
set(${PROJECT_NAME}_VERSION_PATCH   "0")
set(${PROJECT_NAME}_VERSION         "${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH}")
project("${PROJECT_NAME}"
  VERSION "${${PROJECT_NAME}_VERSION}"
  DESCRIPTION "${${PROJECT_NAME}_SUMMARY}"
  HOMEPAGE_URL "${${PROJECT_NAME}_VENDOR_CONTACT}"
  LANGUAGES CXX)

####################### Define and check project structure ####################
set(${PROJECT_NAME}_PROJECT_DIR            "${CMAKE_CURRENT_SOURCE_DIR}")
set(${PROJECT_NAME}_BUILD_DIR              "${CMAKE_CURRENT_BINARY_DIR}")
set(${PROJECT_NAME}_CMAKE_DIR              "${${PROJECT_NAME}_PROJECT_DIR}/cmake")
set(${PROJECT_NAME}_CMAKE_MODULES_DIR      "${${PROJECT_NAME}_CMAKE_DIR}/modules")
set(${PROJECT_NAME}_CMAKE_MODULES_EXT_DIR  "${${PROJECT_NAME}_CMAKE_DIR}/modules_ext")
set(${PROJECT_NAME}_CMAKE_TOOLCHAINS_DIR   "${${PROJECT_NAME}_CMAKE_DIR}/toolchains")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}"
  "${${PROJECT_NAME}_CMAKE_MODULES_DIR}"
  "${${PROJECT_NAME}_CMAKE_MODULES_EXT_DIR}"
  "${${PROJECT_NAME}_CMAKE_TOOLCHAINS_DIR}")
set(${PROJECT_NAME}_DOC_DIR                "${${PROJECT_NAME}_PROJECT_DIR}/doc")
set(${PROJECT_NAME}_TESTS_DIR              "${${PROJECT_NAME}_PROJECT_DIR}/tests")
set(${PROJECT_NAME}_VENDORS_DIR            "${${PROJECT_NAME}_PROJECT_DIR}/vendors")

list(APPEND ${PROJECT_NAME}_PROJECT_DIRS
  "${${PROJECT_NAME}_BUILD_DIR}"
  "${${PROJECT_NAME}_CMAKE_DIR}"
  "${${PROJECT_NAME}_CMAKE_MODULES_DIR}"
  "${${PROJECT_NAME}_CMAKE_MODULES_EXT_DIR}"
  "${${PROJECT_NAME}_CMAKE_TOOLCHAINS_DIR}"
  "${${PROJECT_NAME}_DOC_DIR}"
  "${${PROJECT_NAME}_TESTS_DIR}"
  "${${PROJECT_NAME}_VENDORS_DIR}")

foreach(folder IN ITEMS ${${PROJECT_NAME}_PROJECT_DIRS})
  if((NOT EXISTS "${folder}") OR (NOT IS_DIRECTORY "${folder}"))
    message(FATAL_ERROR "Missing directory: ${folder}!")
  endif()
endforeach()

####################### Configure system and architecture info ################
if(NOT CMAKE_SYSTEM_PROCESSOR)
  set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_HOST_SYSTEM_PROCESSOR})
endif()
message(STATUS "Processor architecture is ${CMAKE_SYSTEM_PROCESSOR}")
set(SYSTEM_NAME "${CMAKE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-${CMAKE_SYSTEM_PROCESSOR}")
string(TOLOWER ${SYSTEM_NAME} SYSTEM_NAME)
message(STATUS "System name set to ${SYSTEM_NAME}")

####################### Set C++ standard and build type #######################
set(CMAKE_CXX_STANDARD "20")
message(STATUS "C++ standard version set to C++${CMAKE_CXX_STANDARD}")
if(NOT DEFINED CMAKE_BUILD_TYPE)
  message(STATUS "Setting build type to Release as none was specified")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
endif()
message(STATUS "Build type set to ${CMAKE_BUILD_TYPE}")

####################### Add module test #######################################
set(BUILD_TESTING on)
if("${BUILD_TESTING}")
  include(CTest)
  enable_testing()
  add_subdirectory(tests)
endif()

####################### Add module doc ########################################
set(BUILD_DOC on)
if("${BUILD_DOC}")
  add_subdirectory(doc)
endif()
