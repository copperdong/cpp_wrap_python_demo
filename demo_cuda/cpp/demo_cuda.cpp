//
// Created by zjx on 2019/12/4.
//
#include "demo_cuda.h"
#include "calculate.h"

namespace zjx {

// Default constructor
demo_cuda::demo_cuda () {}

// Overloaded constructor
demo_cuda::demo_cuda(int * pointer, int length) {
  this->pointer = pointer;
  this->length = length;
}

// Destructor
demo_cuda::~demo_cuda () {}

void demo_cuda::calculate(){
  add_ceshi(this->pointer, this->length);
}
}