Instructions
=============
工程通过三个小例子阐述cython的编译方法，了解如何使用cython利用c++为Python编写动态运行库

demo_simple
-------------
这是最简单的一个方案，使用静态编译，运行 **./build.sh** 之后 **python rect_test.py** 即可看到对应的输出。

demo_static
-------------
这个方案相比上面可以看到C++文件和Python文件不在一个目录中，我们需要在setup.py中指定我们的编译路径。  
language 其实默认就是 c，我们使用的c++ 需要指定c++。  
include_dirs 这个就是传给 gcc 的 -I 参数，我们需要制定编译目录。  
使用方法：在工程python目录下运行 **./build.sh** 之后 **python rect_test.py** 即可看到对应的输出。

demo_dynamic
-------------
静态编译有很多缺点，cython同样也可以使用动态编译，我们需要在setup.py中指定我们的编译路径，指明我们动态链接库的目录。  
library_dirs 这个就是传给 gcc 的 -L 参数，我们指定对应的动态链接库的目录。  
libraries 这个就是传给 gcc 的 -l 参数，我们指定动态链接库的名称。  
其实还有很多参数，感兴趣的可以搜索一下。  
使用方法：  
1. 运行 _source build_env.sh_ 设置动态库的环境变量。  
2. 运行 _./build.sh_ 生成Python的动态链接库。  
3. 在python目录下执行 _python rect_test.py_ 即可看到对应的输出。  
详细介绍参考cython_use_instruction.md
