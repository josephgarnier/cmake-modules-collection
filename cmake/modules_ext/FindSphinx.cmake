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

This module provides the following executable, if found:

``sphinx-build`` or ``sphinx-build`.exe``
  The Sphinx documentation generator

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``SPHINX_EXECUTABLE``
  The full path to the ``sphinx-build`` executable.
``Sphinx_FOUND``
  True if the system has the Sphinx executable.

Cache Variables
^^^^^^^^^^^^^^^

None

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
