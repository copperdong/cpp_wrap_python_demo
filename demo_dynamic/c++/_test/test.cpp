//
// Created by zjx on 2019/12/4.
//

#include "_lib/Rectangle.h"
#include <iostream>
using namespace std;

int main(){
  int x0=1;
  shapes::Rectangle  R1(1,1,0,0);
  int area= R1.getArea();
  std::cout<<area;
}