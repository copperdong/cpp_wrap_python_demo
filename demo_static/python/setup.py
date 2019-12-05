from distutils.core import setup
from Cython.Build import cythonize
from setuptools.extension import Extension


cython_files = ["_lib/*.pyx"]

extensions = [
    Extension(
        name="rect",
        sources=cython_files,
        include_dirs=[
            "../c++/_code",
            "../c++/_lib",
            "../../c++",
        ],
        language="c++",
    )
]

setup(
    ext_modules=cythonize(extensions)
)