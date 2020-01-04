from distutils.core import setup
from Cython.Build import cythonize
from setuptools.extension import Extension
import numpy as numpy

cython_files = ["./*.pyx"]

extensions = [
    Extension(
        name="cuda_demo",
        sources=cython_files,
        include_dirs=[
           numpy.get_include()
        ],
        language="c++",
        library_dirs=["./build"],
        libraries=["add"],
    )
]

setup(
    ext_modules=cythonize(extensions)
)