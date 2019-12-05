from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize(
    "rect.pyx",
    language="c++", ## 如果是C++就需要
))