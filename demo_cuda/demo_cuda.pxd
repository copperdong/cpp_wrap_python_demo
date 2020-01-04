# distutils: sources = demo_cuda.cpp

# Declare the class with cdef
cdef extern from "demo_cuda.h" namespace "zjx":
    cdef cppclass demo_cuda:
        demo_cuda() except +
        demo_cuda(int *, int) except +
        int* pointer
        int length
        void calculate()