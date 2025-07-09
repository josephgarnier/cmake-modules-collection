.. CMake Modules Collection documentation master file, created by
   sphinx-quickstart on Fri May 16 19:20:47 2025.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

cmake-modules-collection
************************

The modules listed here are part of the CMake Modules Collection. Projects
may provide further modules; their location(s) can be specified in the
:cmake:variable:`CMAKE_MODULE_PATH <cmake:variable:CMAKE_MODULE_PATH>` variable.

Function Modules
================

These modules are loaded using the :cmake:command:`include() <cmake:command:include()>`
command. They are prefixed with `Func` and provide a single public function
responsible for dispatching multiple operations, internally using private
macros. Only one public command is exposed per module.

.. toctree::
   :maxdepth: 1

   /module/FuncDebug
   /module/FuncDependency
   /module/FuncDirectory
   /module/FuncFileManip
   /module/FuncPrint
   /module/FuncStringManip

Bundle Modules
==============

These modules are loaded using the :cmake:command:`include() <cmake:command:include()>`
command. They are prefixed with `Bundle` and contain a set of functions and
macros designed to operate on a common object, in a way that reflects
object-oriented programming. Each function defines a separate command, and a
module may include multiple commands.

.. toctree::
   :maxdepth: 1

   /module/BinTarget
