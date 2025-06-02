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
<a href="#-development">Development</a> &nbsp;&bull;&nbsp;
<a href="#-resources">Resources</a> &nbsp;&bull;&nbsp;
<a href="#️-license">License</a>

## ✨ Features

- Modern CMake code.
- Well-documented for ease of use.
- Reliable code thanks to extensive unit testing, written using [CMakeTest](https://github.com/CMakePP/CMakeTest).
- A coding and documentation style similar to official CMake modules.

## ⚓ Requirements

The following dependencies are **required** to execute the modules and must be installed:

- **CMake v4.0.1+** - can be found [here](https://cmake.org/).
- **C++ compiler** (any version) - e.g., [GCC v15.2+](https://gcc.gnu.org/), [Clang C++ v19.1.3+](https://clang.llvm.org/cxx_status.html) or [MSVC](https://visualstudio.microsoft.com). The project is developed with the GCC compiler, and its dependencies are provided pre-compiled with GCC.

These *optional dependencies* are only required to contribute to this project or to run it in standalone mode:

- **Python 3.12.9+** (for doc generation).
- **Sphinx 8.2.3+** (for doc generation) - can be found [here](https://www.sphinx-doc.org/en/master/usage/installation.html) or use `requirements.txt` in `doc/` folder.
- **Sphinx Domain for Modern CMake** (for doc generation) - can be found [here](https://github.com/scikit-build/moderncmakedomain) or use `requirements.txt` in `doc/` folder.
- **doc8** (for doc style checking) - can be found [here](https://github.com/PyCQA/doc8) or use `requirements.txt` in `doc/` folder.
- For **Visual Studio Code users**, these extensions are commanded:
  - [ms-vscode.cpptools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) (for C/C++ support)
  - [ms-vscode.cmake-tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) (for CMake support)
  - [lextudio.restructuredtext](https://marketplace.visualstudio.com/items?itemName=lextudio.restructuredtext) (for reStrcturedText support)

The following dependencies are *used by the project*, but already delivered with it:

- [CMakeTest](https://github.com/CMakePP/CMakeTest) (for unit tests).

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

Regarding **module documentation**, just like the code follows a style consistent with official CMake conventions, the documentation also aims to follow the [*CMake Documentation Guide*](https://github.com/Kitware/CMake/blob/master/Help/dev/documentation.rst). It is written in *reStructuredText* format and placed at the top of the file. The visual style replicates [the official one](https://github.com/Kitware/CMake/tree/master/Utilities/Sphinx).

### Module description

Detailed module documentation is available by opening the `doc/build/html/index.html` file in a browser.

| Name | Type | Description | Location |
|---|---|---|---|
| `Debug` | Function | Operations for helping with debug ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncDebug.html)) | `cmake/modules/FuncDebug.cmake` |
| `Dependency` | Function | Operations to manipule dependencies ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncDependency.html)) | `cmake/modules/FuncDependency.cmake` |
| `Directory` | Function | Operations to manipule directories ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncDirectory.html)) | `cmake/modules/FuncDirectory.cmake` |
| `FileManip` | Function | Operations on files ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncFileManip.html)) | `cmake/modules/FuncFileManip.cmake` |
| `Print` | Function | Log a message ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncPrint.html)) | `cmake/modules/FuncPrint.cmake` |
| `StringManip` | Function | Operations on strings ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FuncStringManip.html)) | `cmake/modules/FuncStringManip.cmake` |
| `BinTarget` | Bundle | Operations to fully create and configure a binary target ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/BundleBinTarget.html)) | `cmake/modules/BundleBinTarget.cmake` |

## 🧩 Integration

This procedure explains how to get the collection of modules and configure a C++/CMake project to use them.

**Prerequisites**:

- All [required dependencies](#-requirements) are satisfied.

To integrate the CMake module collection into a development project using CMake and C++., follow these steps:

1. Download the module collection using one of the following methods:
    - [Direct download as a ZIP archive](https://github.com/josephgarnier/cmake-modules-collection/archive/refs/heads/main.zip)
    - Clone the repository with Git:

      ```console
      git clone https://github.com/josephgarnier/cmake-modules-collection.git
      ```

2. If the ZIP archive was downloaded, extract its contents to any folder.

3. Open the project's `cmake` folder, then copy or move the extracted `modules` folder into the CMake code directory of the C++/CMake project.
    > **Example**: for a project located at `<path-to-my-project>/`, copy the folder to `<path-to-my-project>/cmake/`.

4. (Optional) Delete the downloaded repository and extracted files if they are no longer needed.

5. Open the `CMakeLists.txt` file located at the root of the C++/CMake project.

6. Append the module path after the `project(...)` command:

    ```cmake
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/<path-to-cmake>/modules")
    ```

    where `<path-to-cmake>` is the relative path to the directory containing the modules.  
    > **Example**: `${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules`

7. Include the required modules using the following command:

    ```cmake
    include(<module-name>)
    ```

## 💻 Development

Several *commands* and *scripts* are available for the development of this project, including: build system generation and cleanup, documentation generation, test execution.

Commands are also written as **Visual Studio Code tasks** in `.vscode/tasks.json` and can be launched from the [command palette](https://code.visualstudio.com/docs/editor/tasks). Many of them can also be run from the [Visual Studio Code CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools). Scripts are stored in the project root.

The use of commands and scripts is described below, they must be run from the root project directory:

- To **clean** the buildsystem (remove content of `build/`, `doc/` and `bin/`):

  <details>
  <summary>see details</summary>

  ```bash
  # On Linux/MacOS
  ./clean-cmake.sh

  # On Windows
  clean-cmake.bat
  ```

  - VS Code task: `Project: Clean`.
  </details>

- To **generate** the buildsystem (call the `cmake` command):

  <details>
  <summary>see details</summary>
  
  ```bash
  # On Linux/MacOS
  ./run-cmake.sh

  # On Windows
  run-cmake.bat
  ```

  - VS Code task: `Project: Clean`.
  - **Note:** before running it, edit the script to change the default [cmake-presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html).
  </details>

- To **clean and generate** the buildsystem:

  <details>
  <summary>see details</summary>

  ```bash
  # On Linux/MacOS
  ./clean-cmake.sh && echo \"\" && ./run-cmake.sh

  # On Windows
  clean-cmake.bat && echo. && run-cmake.bat
  ```

  - VS Code task: `Project: Clean and Generate`.
  - **Note:** before running it, edit the script to change the default [cmake-presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html).
  </details>

- To **execute the `clean`** build phase (call the CMake target 'clean'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'clean'
  cmake --build ./build/<preset-build-folder> --target clean
  ```

  - VS Code task: `CMake: Clean`.
  </details>

- To **execute the `default`** build phase (call the CMake target 'all'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'all'
  cmake --target all --preset "<build-preset-name>"

  # Run the CMake target 'all' in verbose mode
  cmake --target all --verbose --preset "<build-preset-name>"
  ```

  - VS Code task: `CMake: Build all`.
  </details>

- To **execute the `clean` and `default`** build phases (call the CMake targets 'clean' then 'all'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'all' after the target 'clean'
  cmake --target all --clean-first --preset "<build-preset-name>"

  # Run the CMake target 'all' after the target 'clean' in verbose mode
  cmake --target all --clean-first --verbose --preset "<build-preset-name>"
  ```

  - VS Code task: `CMake: Clean and Rebuild all`.
  </details>

- To **execute the `test`** build phases (call the CMake command 'ctest'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake command 'ctest'
  ctest --preset "<test-preset-name>"
  ```

  - VS Code task: `CMake: Test`.
  </details>

- To **execute the `doc`** build phases (call the CMake target 'doc'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'doc'
  cmake --build ./build/<preset-build-folder> --target doc
  ```

  - VS Code task: `CMake: Doc`.
  - **Note:** the 'doc' CMake target is included in 'all' CMake target.
  </details>

- To **execute a default workflow with `default`, `test`, `doc`** build phases:

  <details>
  <summary>see details</summary>

  ```bash
  # Run a default CMake workflow
  cmake --workflow --preset "<workflow-preset-name>"
  ```

  - VS Code task: `CMake: Workflow`.
  </details>

- Some useful commands for debugging:

  <details>
  <summary>see details</summary>
  
  ```bash
  # List what targets has been generated
  cmake --build ./build/<preset-build-folder> --target help

  # List variables in the cache and their descriptions
  cmake -LAH ./build/<preset-build-folder>
  ```

  </details>

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
- [reStructuredText syntax](https://www.sphinx-doc.org/en/master/usage/restructuredtext/index.html).

Non-exhaustive list of **other CMake module collections** on GitHub:

- [*Additional CMake Modules*, by Lars Bilke](https://github.com/bilke/cmake-modules).
- [*CMake-modules*, by Kartik Kumar](https://github.com/kartikkumar/cmake-modules).
- [*Rylie's CMake Modules Collection*, by Rylie Pavlik](https://github.com/rpavlik/cmake-modules).
- [*Extra CMake Modules*, by KDE](https://github.com/KDE/extra-cmake-modules).

## ©️ License

This work is licensed under the terms of the <a href="https://www.gnu.org/licenses/gpl-3.0.en.html" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">GNU GPLv3</a>.  See the [LICENSE.md](LICENSE.md) file for details.
