//
// Created by zjx on 2019/12/4.
//
#pragma once
#ifndef RECTANGLE_H
#define RECTANGLE_H
#include <iostream>
#include <stdio.h>

namespace zjx {
class demo_cuda {
public:
  int* pointer;
  int length;
  void calculate();
  demo_cuda ();
  ~demo_cuda();
  demo_cuda (int * pointer, int length);
};
}

#endif