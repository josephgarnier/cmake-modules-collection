<div style="text-align: center;">

# CMake Modules Collection

</div>

<p style="text-align: center;">
<strong>A collection of modules for a more practical use of CMake.</strong>
</p>

<p style="text-align: center;">
<a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img alt="Static Badge" src="https://img.shields.io/badge/licence-GNU_GPLv3-brightgreen">
</a> <img alt="Static Badge" src="https://img.shields.io/badge/plateform-Windows%20%7C%20Linux%20%7C%20Mac-lightgrey"> <img alt="Static Badge" src="https://img.shields.io/badge/language-CMake%20%7C%20C%2B%2B-blue"> <img alt="Static Badge" src="https://img.shields.io/badge/status-in_dev-orange">
</p>

This collection of CMake modules provides macros and functions that extend official functionality or wrap it in higher-level abstractions to make writing CMake code faster and easier. Each module is documented and tested using the unit-testing framework [CMakeTest](https://github.com/CMakePP/CMakeTest).

<p style="text-align: center;">
<a href="#-features">Features</a> &nbsp;&bull;&nbsp;
<a href="#-requirements">Requirements</a> &nbsp;&bull;&nbsp;
<a href="#-module-overview">Module overview</a> &nbsp;&bull;&nbsp;
<a href="#-integration">Integration</a> &nbsp;&bull;&nbsp;
<a href="#-development">Development</a> &nbsp;&bull;&nbsp;
<a href="#-resources">Resources</a> &nbsp;&bull;&nbsp;
<a href="#️-license">License</a>

## ✨ Features

- Modern CMake code.
- Well-documented on a [dedicted doc website](https://josephgarnier.github.io/cmake-modules-collection/) for ease of use.
- Reliable code thanks to extensive unit testing, written using [CMakeTest](https://github.com/CMakePP/CMakeTest).
- A coding and documentation style similar to official CMake modules.

## ⚓ Requirements

The following dependencies are **required** to execute the modules and must be installed:

- **CMake v4.0.1 or higher** - can be found [here](https://cmake.org/).
- **C++ compiler** (any version) - e.g., [GCC v15.2+](https://gcc.gnu.org/), [Clang C++ v19.1.3+](https://clang.llvm.org/cxx_status.html) or [MSVC](https://visualstudio.microsoft.com). The project is developed with the GCC compiler, and its dependencies are provided pre-compiled with GCC.

The following dependencies are **optional** and only required to contribute to this project and to run it in standalone mode:

- Python >= 3.12.9 (for doc generation).
- Sphinx >= 8.2.3 (for doc generation) - can be found [here](https://www.sphinx-doc.org/en/master/usage/installation.html) or installed from `requirements.txt` in `doc/` folder.
- Sphinx Domain for Modern CMake (for doc generation) - can be found [here](https://github.com/scikit-build/moderncmakedomain) or installed from `requirements.txt` in `doc/` folder.
- doc8 (for doc style checking) - can be found [here](https://github.com/PyCQA/doc8) or installed from `requirements.txt` in `doc/` folder.

The following dependencies are **used and delivered** by the project:

- CMakeTest - can be found [here](https://github.com/CMakePP/CMakeTest).

In addition for **Visual Studio Code users** these extensions are recommended to help with development:

- [ms-vscode.cpptools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools): add C/C++ support.
- [ms-vscode.cmake-tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools): add CMake support.
- [lextudio.restructuredtext](https://marketplace.visualstudio.com/items?itemName=lextudio.restructuredtext): add reStrcturedText support.

## 💫 Module overview

### Module structure

> [!note]
>
> Before reading, it is recommended to understand the [difference between a function and a macro](https://cmake.org/cmake/help/latest/command/macro.html#macro-vs-function) in CMake.

A module is a text file with the `.cmake` extension that provides a [CMake command](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html) for performing various types of data manipulation within a build project. The general format of a module filename is `<module-name>.cmake`, where `<module-name>` uses PascalCase (also called UpperCamelCase), e.g., `StringManip`. 

Each module provides a single public function responsible for dispatching multiple operations, internally using private macros. In the "public" interface, CMake `function()` are preferred over `macro()` due to better encapsulation and its own variable scope.

The public function follows a signature and call pattern identical to what is found in official CMake [modules](https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html) and [commands](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html), such as the [`string()`](https://cmake.org/cmake/help/latest/command/string.html) command:

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

Within the public function, the first parameter `<operation-name>` acts as a dispatcher, routing the execution flow to the internal macro that implements the requested operation. Therefore, the function’s role is limited to parsing arguments, initializing scoped variables, and calling an internal macro.

Regarding **module documentation**, just like the code follows a style consistent with official CMake conventions, the documentation also aims to follow the [*CMake Documentation Guide*](https://github.com/Kitware/CMake/blob/master/Help/dev/documentation.rst). It is written in *reStructuredText* format and placed at the top of the file. The visual style replicates [the official one](https://github.com/Kitware/CMake/tree/master/Utilities/Sphinx).

### Module description

Detailed module documentation is available by opening the `doc/build/html/index.html` file in a browser and on [the doc website](https://josephgarnier.github.io/cmake-modules-collection/).

| Name | Description | Location |
|---|---|---|
| `BuildBinTarget` | Operations to fully create and configure a binary target ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/BundleBinTarget.html)) | `cmake/modules/BundleBinTarget.cmake` |
| `Debug` | Operations for helping with debug ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/Debug.html)) | `cmake/modules/Debug.cmake` |
| `Dependency` | Operations to manipule dependencies ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/Dependency.html)) | `cmake/modules/Dependency.cmake` |
| `Directory` | Operations to manipule directories ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/Directory.html)) | `cmake/modules/Directory.cmake` |
| `FileManip` | Operations on files ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/FileManip.html)) | `cmake/modules/FileManip.cmake` |
| `Print` | Log a message ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/Print.html)) | `cmake/modules/Print.cmake` |
| `StringManip` | Operations on strings ([more details](https://josephgarnier.github.io/cmake-modules-collection/module/StringManip.html)) | `cmake/modules/StringManip.cmake` |

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

Several *commands* and *scripts* are available for the development of this project, including: build system generation and cleanup, documentation generation, test execution. The scripts are stored in the project root, and the commands can be run from a command prompt.

If you are a VS Code user, all commands have been written as **Visual Studio Code tasks** in `.vscode/tasks.json` and can be launched from the [command palette](https://code.visualstudio.com/docs/editor/tasks). Many of them can also be run from the [Visual Studio Code CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools).

The use of commands and scripts is described below, in the order of execution of a complete and classic sequence of build phases. They must be executed from the root project directory:

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
  - **Note:** before running it, edit the script to change the build sub-folder.
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
  cmake --build --preset "<build-preset-name>" --target clean

  # Run the CMake target 'clean' without preset
  cmake --build ./build/<preset-build-folder> --target clean
  ```

  - VS Code task: `CMake: Clean`.
  </details>

- To **execute the `default`** build phase (call the CMake target 'all'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'all'
  cmake --build --preset "<build-preset-name>" --target all

  # Run the CMake target 'all' in verbose mode
  cmake --build --preset "<build-preset-name>" --verbose
  
  # Run the CMake target 'all' without preset
  cmake --build ./build/<preset-build-folder> --target all

  # Run the CMake target 'all' in verbose mode without preset
  cmake --build ./build/<preset-build-folder> --target all --verbose
  ```

  - VS Code task: `CMake: Build all`.
  </details>

- To **execute the `clean` and `default`** build phases (call the CMake targets 'clean' then 'all'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'all' after the target 'clean'
  cmake --build --preset "<build-preset-name>" --target all --clean-first

  # Run the CMake target 'all' after the target 'clean' in verbose mode
  cmake --build --preset "<build-preset-name>" --target all --clean-first --verbose
  
  # Run the CMake target 'all' after the target 'clean' without preset
  cmake --build ./build/<preset-build-folder> --target all --clean-first

  # Run the CMake target 'all' after the target 'clean' in verbose mode without preset
  cmake --build ./build/<preset-build-folder> --target all --clean-first --verbose
  ```

  - VS Code task: `CMake: Clean and Rebuild all`.
  </details>

- To **execute the `test`** build phase (call the CMake command 'ctest'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake command 'ctest'
  ctest --preset "<test-preset-name>"
  
  # Run the CMake command 'ctest' while displaying much more information
  ctest --preset "<test-preset-name>" --extra-verbose --debug
  
  # Run the CMake command 'ctest' without preset
  ctest --test-dir ./build/<preset-build-folder>
  
  # Run the CMake command 'ctest' while displaying much more information without preset
  ctest --test-dir ./build/<preset-build-folder> --extra-verbose --debug
  ```

  - VS Code task: `CMake: Test`.
  </details>

- To **execute the `doc`** build phase (call the CMake target 'doc'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'doc'
  cmake --build --preset "<build-preset-name>" --target doc
  
  # Run the CMake target 'doc' without preset
  cmake --build ./build/<preset-build-folder> --target doc
  ```

  - VS Code task: `CMake: Doc`.
  - **Note:** the 'doc' CMake target is included in 'all' CMake target.
  </details>

- To **execute the `install`** build phase (call the CMake target 'install'):

  <details>
  <summary>see details</summary>

  ```bash
  # Run the CMake target 'install'
  cmake --build --preset "<build-preset-name>" --target install
  
  # Run the CMake target 'install' without preset
  cmake --build ./build/<preset-build-folder> --target install
  ```

  - VS Code task: `CMake: Install`.
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
  
  # Print all available test labels without running any tests
  ctest --preset "<test-preset-name>" --extra-verbose --debug --print-labels
  
  # Showing all links of CMake Intersphinx mapping file
  python -m sphinx.ext.intersphinx https://cmake.org/cmake/help/latest/objects.inv
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
