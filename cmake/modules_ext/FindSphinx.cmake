# Copyright 2015-present, Joseph Garnier
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

#[=======================================================================[.rst:

FindSphinx
-------

Finds the Sphinx software.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Foo::Foo``
  The Foo library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Foo_FOUND``
  True if the system has the Foo library.
``Foo_VERSION``
  The version of the Foo library which was found.
``Foo_INCLUDE_DIRS``
  Include directories needed to use Foo.
``Foo_LIBRARIES``
  Libraries needed to link to Foo.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Foo_INCLUDE_DIR``
  The directory containing ``foo.h``.
``Foo_LIBRARY``
  The path to the Foo library.

#]=======================================================================]
include_guard()

include(FindPackageHandleStandardArgs)

find_package (Python COMPONENTS Interpreter)
if(Python_Interpreter_FOUND)
	get_filename_component(PYTHON_ROOT_DIR "${PYTHON_EXECUTABLE}" DIRECTORY)
	set(PYTHON_ROOT_DIR
		"${PYTHON_ROOT_DIR}"
		"${PYTHON_ROOT_DIR}/bin"
		"${PYTHON_ROOT_DIR}/Scripts")
		
	find_program(
		SPHINX_EXECUTABLE
		NAMES "sphinx-build" "sphinx-build.exe"
		HINTS "${PYTHON_ROOT_DIR}"
	)
	find_package_handle_standard_args(Sphinx DEFAULT_MSG SPHINX_EXECUTABLE)
endif()
