# Copyright 2025-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
# =============================================================================
# What Is This?
# -------------
# See README file in the root directory of this source tree.

cmake_minimum_required (VERSION 4.0.1 FATAL_ERROR)

####################### Declare project metadata ##############################
set(PROJECT_NAME                    "cmake-modules-collection")
set(${PROJECT_NAME}_SUMMARY         "A collection of extra macros and functions for CMake")
set(${PROJECT_NAME}_VENDOR_NAME     "Joseph Garnier")
set(${PROJECT_NAME}_VENDOR_CONTACT  "")
set(${PROJECT_NAME}_VERSION_MAJOR   "1")
set(${PROJECT_NAME}_VERSION_MINOR   "0")
set(${PROJECT_NAME}_VERSION_PATCH   "0")
set(${PROJECT_NAME}_VERSION         "${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH}")
project("${PARAM_PROJECT_NAME}"
	VERSION "${${PROJECT_NAME}_VERSION}"
	DESCRIPTION "${${PROJECT_NAME}_SUMMARY}"
	HOMEPAGE_URL "${${PROJECT_NAME}_VENDOR_CONTACT}"
	LANGUAGES CXX)
	
####################### Define and check project structure ####################
set(${PROJECT_NAME}_PROJECT_DIR            "${CMAKE_CURRENT_SOURCE_DIR}")
set(${PROJECT_NAME}_BUILD_DIR              "${CMAKE_CURRENT_BINARY_DIR}")
set(${PROJECT_NAME}_CMAKE_DIR              "${${PROJECT_NAME}_PROJECT_DIR}/cmake")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}"
	"${${PROJECT_NAME}_CMAKE_DIR}")

####################### Add modules tests #####################################
set(BUILD_TESTING on)
add_subdirectory(tests)