# CMake Modules Collection

<p align="center">
<strong>A collection of modules for a more practical use of CMake.</strong>
</p>

<p align="center">
<a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img alt="Static Badge" src="https://img.shields.io/badge/licence-GNU_GPLv3-brightgreen">
</a> <img alt="Static Badge" src="https://img.shields.io/badge/plateform-Windows%20%7C%20Linux%20%7C%20Mac-lightgrey"> <img alt="Static Badge" src="https://img.shields.io/badge/language-CMake%20%7C%20C%2B%2B-blue"> <img alt="Static Badge" src="https://img.shields.io/badge/status-in_dev-orange">
</p>

This collection of CMake modules provides macros and functions that extend official functionality or wrap it in higher-level abstractions to make writing CMake code faster and easier. Each module is documented and tested using the unit-testing framework [CMakeTest](https://github.com/CMakePP/CMakeTest).

<p align="center">
<a href="#-features">Features</a> &nbsp;&bull;&nbsp;
<a href="#-requirements">Requirements</a> &nbsp;&bull;&nbsp;
<a href="#-module-overview">Module overview</a> &nbsp;&bull;&nbsp;
<a href="#-integration">Integration</a> &nbsp;&bull;&nbsp;
<a href="#️-usag">Usage</a> &nbsp;&bull;&nbsp;
<a href="#-resources">Resources</a> &nbsp;&bull;&nbsp;
<a href="#️-license">License</a>

## ✨ Features

- Modern CMake code.
- Well-documented for ease of use.
- Reliable code thanks to extensive unit testing, written using [CMakeTest](https://github.com/CMakePP/CMakeTest).
- A coding and documentation style similar to official CMake modules.

## ⚓ Requirements

The following dependencies are **required** for development and must be installed:

- **CMake v3.20+** - can be found [here](https://cmake.org/).
- **C++ compiler** (any version) - e.g., [GCC v15.2+](https://gcc.gnu.org/), [Clang C++ v19.1.3+](https://clang.llvm.org/cxx_status.html) or [MSVC](https://visualstudio.microsoft.com). The project is developed with the GCC compiler, and its dependencies are provided pre-compiled with GCC.

## 💫 Module overview

### Module structure

**Note**: Before proceeding, it is recommended to understand the [difference between a function and a macro](https://cmake.org/cmake/help/latest/command/macro.html#macro-vs-function) in CMake.

A module is a text file with the `.cmake` extension that provides a [CMake command](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html) for performing various types of data manipulation within a build project.

This collection provides two types of modules, distinguished by a prefix in the filename:

- The ***Function*-type** module, prefixed with `Func`, provide a single public function responsible for dispatching multiple operations, internally using private macros. Only one public command is exposed per module.
- The ***Bundle*-type** module, prefixed with `Bundle`, contains a set of functions and macros designed to operate on a common object, in a way that reflects object-oriented programming. Each function defines a separate command, and a module may include multiple commands.

The general format of a module filename is `<Func|Bundle><module-name>.cmake`, where `<module-name>` uses PascalCase (also called UpperCamelCase), e.g., `StringManip`.

In the "public" interface of modules, CMake `function()` are preferred over `macro()` due to better encapsulation and its own variable scope.

The public function of a *Function*-type module follows a **signature and call pattern** identical to what is found in official CMake [modules](https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html) and [commands](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html), such as the [`string()`](https://cmake.org/cmake/help/latest/command/string.html) command:

```cmake
<command-name>(<operation-name> [<option>|<options>...] [<input-params>...] [<output-params>...])
```

where :

- `<command-name>`: the name of the single command defined by the module, written entirely in lowercase with words separated by `_`, e.g. `print`, `string_manip`.
- `<operation-name>`: the name of the operation to be performed by the command, written entirely in uppercase with words separated by `_`, e.g. `SPLIT`, `EXTRACT_INTERFACE`.
- `[<option>|<options>...]`: a value, a list of values, or a [*variable reference*](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variable-references) passed as an argument to the command, e.g. `file_manip(STRIP_PATH "path/to/file")`, `file_manip(STRIP_PATH MY_FILE_PATH)`
- `[<input-params>...]`: read-only input parameters in the form:
  - `input-param ::= <constant> [<var-ref>|<value>|<values>...]`: where a parameter is either a keyword or a pair combining a keyword with a value, a list of values, or a [*variable reference*](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variable-references).
- `[<output-params>...]`: write-only output parameters in the form:
  - `output-param ::= <constant> [<var-ref>|<value>|<values>...]`: where a parameter is either a keyword or a pair combining a keyword with a value, a list of values, or a [*variable reference*](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variable-references).

The structure of this function signature results from the use of the CMake command `cmake_parse_arguments` to parse the function's arguments. The official [command documentation](https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html) provides further explanations on the concepts mentioned above.

Within the public function of a module, the first parameter `<operation-name>` acts as a **dispatcher**, routing the execution flow to the internal macro that implements the requested operation. Therefore, the function’s role is limited to parsing arguments, initializing scoped variables, and calling an internal macro.

Regarding **module documentation**, just like the code follows a style consistent with official CMake conventions, the documentation also aims to follow the [*CMake Documentation Guide*](https://github.com/Kitware/CMake/blob/master/Help/dev/documentation.rst). It is written in *reStructuredText* format and placed at the top of the file.

### Module description

| Name | Type | Description |
|---|---|---|
|   |   |   |

## 🧩 Integration

To integrate the CMake module collection into a development project using CMake and C++., follow these steps:

1. Download the module collection using one of the following methods:
    - [Direct download as a ZIP archive](https://github.com/josephgarnier/cmake-modules-collection/archive/refs/heads/main.zip)
    - Clone the repository with Git:

      ```console
      git clone https://github.com/josephgarnier/cmake-modules-collection.git
      ```

2. If the ZIP archive was downloaded, extract its contents to any folder.

3. Open the project's `cmake` folder, then copy or move the extracted `modules` folder into the CMake code directory of the project.

    > **Example**: for a project located at `<path-to-my-project>/`, copy the folder to `<path-to-my-project>/cmake/`.

4. (Optional) Delete the downloaded repository and extracted files if they are no longer needed.

## ⚙️ Usage

This procedure explains how to configure a C++/CMake project to use the previously integrated modules.

**Prerequisites**:

- All [required dependencies](#-requirements) are satisfied.
- The modules [are integrated](#-integration) into the development project.

To use the modules in a C++/CMake project, follow these steps:

1. Open the `CMakeLists.txt` file located at the root of the C++/CMake project.

2. Append the module path after the `project(...)` command:

    ```cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/<path-to-cmake>/modules")
    ```

    where `<path-to-cmake>` is the relative path to the directory containing the modules.  
    > **Example**: `${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules`

3. Include the required modules using the following command:

    ```cmake
    include(<module-name>)
    ```

## 📚 Resources

General links:

- [*CMakeTest*, the unit-testing framework used in this project](https://github.com/CMakePP/CMakeTest).

CMake documentation:

- [List of official modules](https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html).
- [List of official commands](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html).
- [A *function* in CMake](https://cmake.org/cmake/help/latest/command/function.html).
- [A *macro* in CMake](https://cmake.org/cmake/help/latest/command/macro.html).
- [The CMake Documentation Guide](https://github.com/Kitware/CMake/blob/master/Help/dev/documentation.rst).
- [Manual for CMake developers](https://cmake.org/cmake/help/latest/manual/cmake-developer.7.html).
- [Description of the CMake language](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html).

Non-exhaustive list of **other CMake module collections** on GitHub:

- [*Additional CMake Modules*, by Lars Bilke](https://github.com/bilke/cmake-modules).
- [*CMake-modules*, by Kartik Kumar](https://github.com/kartikkumar/cmake-modules).
- [*Rylie's CMake Modules Collection*, by Rylie Pavlik](https://github.com/rpavlik/cmake-modules).
- [*Extra CMake Modules*, by KDE](https://github.com/KDE/extra-cmake-modules).

## ©️ License

This work is licensed under the terms of the <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">GNU GPLv3</a>.  See the [LICENSE.md](LICENSE.md) file for details.