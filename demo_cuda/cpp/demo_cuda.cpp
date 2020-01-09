//
// Created by zjx on 2019/12/4.
//
#include "demo_cuda.h"
#include "calculate.h"
#include <time.h>

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
  clock_t start_time=clock();
    add_ceshi(this->pointer, this->length);
  clock_t end_time=clock();
  std::cout<<"time---------------------------------------"<<std::endl;
  std::cout<< "Running time is: "<<static_cast<double>(end_time-start_time)/CLOCKS_PER_SEC*1000<<"ms"<<std::endl;
  std::cout<<"time---------------------------------------"<<std::endl;
}
}