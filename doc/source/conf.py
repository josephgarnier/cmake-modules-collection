# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html
#
# Some config options comes from the official CMake respository:
# https://github.com/Kitware/CMake/blob/master/Utilities/Sphinx/conf.py.in


# -- Path setup --------------------------------------------------------------
import sys
import os
from pathlib import Path

dir_path = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0,dir_path)

doc_path = os.path.dirname(dir_path)
build_path = os.path.join(doc_path, "build")
source_path = os.path.join(doc_path, "source")
extensions_path = os.path.join(source_path, "extensions")
sys.path.append(os.path.abspath(extensions_path))


# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
project = 'CMake Modules Collection'
copyright = '2025, Joseph Garnier'
author = 'Joseph Garnier'
release = '4.0.1'
version = '1.0.0'


# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
extensions = ['sphinxcontrib.moderncmakedomain','show_cmake_objects']
highlight_language = 'cmake'
pygments_style = 'colors.CMakeTemplateStyle'
language = 'en'
primary_domain = 'cmake'
nitpicky = True
exclude_patterns = []
smartquotes = False
templates_path = ['_templates']
master_doc = 'index'
source_suffix = '.rst'


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_theme = 'default'
html_show_sourcelink = True
html_static_path = ['_static']
htmlhelp_basename = '{project}doc'
html_style = 'cmake.css'
html_theme_options = {
    'footerbgcolor':    '#00182d',
    'footertextcolor':  '#ffffff',
    'sidebarbgcolor':   '#e4ece8',
    'sidebarbtncolor':  '#00a94f',
    'sidebartextcolor': '#333333',
    'sidebarlinkcolor': '#00a94f',
    'relbarbgcolor':    '#00529b',
    'relbartextcolor':  '#ffffff',
    'relbarlinkcolor':  '#ffffff',
    'bgcolor':          '#ffffff',
    'textcolor':        '#444444',
    'headbgcolor':      '#f2f2f2',
    'headtextcolor':    '#003564',
    'headlinkcolor':    '#3d8ff2',
    'linkcolor':        '#2b63a8',
    'visitedlinkcolor': '#2b63a8',
    'codebgcolor':      '#eeeeee',
    'codetextcolor':    '#333333',
}
html_title = 'CMake Modules Collection'
html_short_title = 'CMake Modules Collection'
html_favicon = '_static/cmake-favicon.ico'


# -- Options for manual page output ------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-manual-page-output
man_pages = []
man_show_urls = False
man_make_section_directory = False