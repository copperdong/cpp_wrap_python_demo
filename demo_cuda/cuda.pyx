# distutils: language = c++

from demo_cuda cimport demo_cuda
import numpy as np
cimport numpy as np


cdef class Pydemo_cuda:
    cdef demo_cuda c_cuda

    def __cinit__(self, pointer, length):
        self.c_cuda = demo_cuda(<int *> np.PyArray_DATA(pointer), length)

    def calculate(self):
        return self.c_cuda.calculate()


    