cmake_minimum_required(VERSION 3.15)

PROJECT(test_add)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(CUDA)

if(${CUDA_FOUND})
	include_directories(${CUDA_INCLUDE_DIRS})
	link_directories($ENV{CUDA_PATH}/lib/x64)
else(${CUDA_FOUND})
	MESSAGE(STATUS "cuda not found!")
endif(${CUDA_FOUND})


INCLUDE_DIRECTORIES(
./
)
AUX_SOURCE_DIRECTORY(. DIR_INTERFACE)
SET(TEST_ADD
${DIR_INTERFACE}
)

CUDA_ADD_LIBRARY(add SHARED ${TEST_ADD})

