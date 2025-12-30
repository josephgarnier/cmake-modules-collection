"""Sphinx extension to list CMake commands, modules, and variables."""

from sphinx.application import Sphinx
from sphinx.environment import BuildEnvironment

def list_cmake_objects(objects: dict) -> None:
    """Print CMake-related objects from the domain."""
    categories = {
        'command': "CMake Commands found",
        'module': "CMake Modules found",
        'variable': "CMake Variables found"
    }

    for objtype, title in categories.items():
        print(f"{title}:")
        for obj in objects.values():
            if obj.objtype == objtype:
                print(f" - {obj.name}")

def on_env_updated(app: Sphinx, env: BuildEnvironment) -> None:
    """Callback run after environment is updated (i.e., all sources are read)."""
    domain = env.get_domain('cmake')
    if domain:
        list_cmake_objects(domain.data.get('objects', {}))

def setup(app: Sphinx) -> dict:
    """Register the extension with Sphinx."""
    app.connect('env-updated', on_env_updated)
    return {"parallel_read_safe": True}
