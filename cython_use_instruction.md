从cudf源码看cython使用方法
========================
一、 介绍
----------
python是一种高层级的，动态的，解释性的，易学的语言，但是其带来的副作用是，运行效率可能会比静态编译语言慢几个数量级。我们可以使用python调用外部接口的方式，极大的提高python的运行效率，cython正是一种可以为Python编写接口的语言。相当于Python做前端的计算，后台的运行就交给用c或者c++实现的这些动态库来完成了，效率相比之前快了很多，既拥有了Python的便捷，又拥有了静态语言的速度，实在是不亦乐乎！
cudf当然也注意到了这一点，所以就使用cython来为pandas写封装了，大大提升了数据分析的速度。那么既然cython这么神奇我们又怎么使用cython为Python编写接口呢？  

二、三个小例子
------------
请看范例：https://github.com/zhangjiaxinghust/cpp_warp_python_demo
环境配置:(ubuntu 16.04)
* 下载conda安装脚本 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 运行安装conda环境。
*  `conda install cython` 安装cython，下面demo均在conda下使用。  

###1. 简单入门示例demo_simple
我们使用的类示例是一个矩形类，四个变量x0，y0，x1，y1代表矩形的变量位置，定义了构造函数，析构函数，提供了三个函数 `int getArea();`  `void getSize(int* width, int* height);` 和 `void move(int dx, int dy);`分别在 `Rectangle.h`和`Rectangle.cpp`中完成声明和编写。
同时我们可以看到有两个文件`Rectangle.pxd`和`rect.pyx`，他们的后缀名是不一样的，这类似于c++中的`.h`文件和`.cpp`文件，`.pxd` 文件中有 Cython 模块要包含的 Cython 声明 (或代码段)。`.pxd`文件可共享外部 C 语言声明，也能包含 C 编译器内联函数。可用 `cimport` 关键字将 `.pxd` 文件导入 `.pyx` 模块文件中。`.pyx` 文件是由 Cython 编程语言 "编写" 而成的 Python 扩展模块源代码文件。`.pyx` 文件类似于 C++ 语言的 .cpp 源代码文件，`.pyx` 文件中有 Cython 模块的源代码。不像 Python 语言可直接解释使用的 `.py` 文件，`.pyx` 文件必须先被编译成 `.c`或者`.cpp` 文件，再编译成 `.pyd` (Windows 平台) 或 `.so` (Linux 平台) 文件，才可作为模块 import 导入使用。
`Rectangle.pxd`文件内容如下：

```
# distutils: sources = Rectangle.cpp
cdef extern from "Rectangle.cpp":
    pass

# Declare the class with cdef
cdef extern from "Rectangle.h" namespace "shapes":
    cdef cppclass Rectangle:
        Rectangle() except +
        Rectangle(int, int, int, int) except +
        int x0, y0, x1, y1
        int getArea()
        void getSize(int* width, int* height)
        void move(int, int)
```
文件开始的语句`cdef extern from "Rectangle.cpp"`不可或缺，它代表后面的`.h`文件中定义的函数体(如果没有编写只做了声明)应该如何去寻找，声明之后后续编译程序会自动从`Rectangle.cpp`中去寻找对应的代码。
下面的就是从.h中引用具体的函数，写法和c++语法大同小异，值得注意的是两个后面函数后面添加了`except +`语句。如果C ++代码或初始内存分配由于故障而引发异常，这将使Cython安全地引发适当的Python异常。没有此声明，Cython将不会处理源自构造函数的C ++异常。
这样我们就声明了cython可以调用的c++接口，但是这个接口Python依然无法调用，我们需要对这个接口进行包装之后Python才可以使用，具体包装在文件`rect.pyx`中

```
# distutils: language = c++

from Rectangle cimport Rectangle

cdef class PyRectangle:
    cdef Rectangle c_rect

    def __cinit__(self, int x0, int y0, int x1, int y1):
        self.c_rect = Rectangle(x0, y0, x1, y1)

    def get_area(self):
        return self.c_rect.getArea()

    def get_size(self):
        cdef int width, height
        self.c_rect.getSize(&amp;width, &amp;height)
        return width, height

    def move(self, dx, dy):
        self.c_rect.move(dx, dy)

    # Attribute access
    @property
    def x0(self):
        return self.c_rect.x0
    @x0.setter
    def x0(self, x0):
        self.c_rect.x0 = x0

    # Attribute access
    @property
    def x1(self):
        return self.c_rect.x1
    @x1.setter
    def x1(self, x1):
        self.c_rect.x1 = x1

    # Attribute access
    @property
    def y0(self):
        return self.c_rect.y0
    @y0.setter
    def y0(self, y0):
        self.c_rect.y0 = y0

    # Attribute access
    @property
    def y1(self):
        return self.c_rect.y1
    @y1.setter
    def y1(self, y1):
        self.c_rect.y1 = y1
```
首先`from Rectangle cimport Rectangle`表示我们从上面编写的文件中引入`Rectangle`类，然后我们就可以使用类定义的接口了。我们实例化了一个对象，然后声明了各个函数和变量的`set`与`get`方法。值得注意的是Cython使用空构造函数初始化cdef类的C ++类属性。如果要包装的类没有null构造函数，则必须存储指向包装好的类的指针，然后手动分配和取消分配它。这样做的方便和安全的方式是`__cinit__`和`__dealloc__`方法，这些方法保证在创建和删除Python实例时精确地调用一次。
声明好Python可以使用的接口之后下面我们就可以在Linux下面生成Python可以调用的动态库了。这时候`setup.py`就要闪亮登场了。

```
from distutils.core import setup
from Cython.Build import cythonize

setup(
    ext_modules = cythonize(
    "rect.pyx",
    language="c++", ## 如果是C++就需要
))
```
我们在文件中指明需要编译的文件是`rect.pyx`，定义好语言是`c++`，然后运行 `python setup.py build_ext --inplace` 就大功告成了。之前说过cython是先将cython文件翻译为`.c`文件或`.cpp`文件然后编译为Python可以调用的动态库，所以你会发现目录下会多了一个`rect.cpp`文件，这个文件就是中间的翻译文件。生成`.so`文件之后，我们进行测试，测试文件如下：

```
import rect

pyRect = rect.PyRectangle(100, 100, 300, 500)
width, height = pyRect.get_size()
print("size: width = %d, height = %d" % (width, height))
```
Python运行之后输出正确就代表大功告成了！  

###2. 进阶静态编译入门示例demo_static
很多情况下项目很大，我们根本无法像上面那样在一个目录下完成，那又该怎么去编写呢？
可以告诉大家的是，cython非常的人性化，大家现在可以把`setup.py`看做是一个有着类似`gcc`功能的编译配置文件。如果更改了目录结构之后不改变`setup.py`的任何内容的话，直接编译会报错，因为这时候在链接翻译文件`rect.cpp`的时候找不到源码文件。这时后我们只需要将`setup.py`做小小的修改即可。
```
from distutils.core import setup
from Cython.Build import cythonize
from setuptools.extension import Extension


cython_files = ["_lib/*.pyx"]

extensions = [
    Extension(
        name="rect",
        sources=cython_files,
        include_dirs=[
            "../c++/_code",
            "../c++/_lib",
            "../../c++",
        ],
        language="c++",
    )
]

setup(
    ext_modules=cythonize(extensions)
)
```
`name`代表我们编译出的动态库的名称。`include_dirs`代表传给 gcc 的 -I 参数` ，只需要稍作指定即可，是不是感觉so easy！  

###3. 进阶动态编译入门示例demo_dynamic  

很多时候，随着我们项目的开发，静态编译有很多缺点，那么我们是否可以进行动态编译呢？
可以发现，cython本身就是先翻译为`.c`或者`cpp`文件然后再进行链接，自然可以支持动态编译了。只需要在链接的时候链接对应的动态库，然后执行是寻找动态库就可以了。同样使用动态链接的话我们需要在上面静态例子中更改`setup.py`和`Rectangle.pxd`我们需要在`Rectangle.pxd`中去掉`cdef extern from "Rectangle.cpp"`，因为我们是动态链接，直接寻找动态库中的函数声明就可以，相应的我们需要在`setup.py`中添加关于动态库的声明：
```
from distutils.core import setup
from Cython.Build import cythonize
from setuptools.extension import Extension


cython_files = ["_lib/*.pyx"]

extensions = [
    Extension(
        name="rect",
        sources=cython_files,
        include_dirs=[
            "../c++/_lib",
        ],
        library_dirs=["../"],
        libraries=["Rectangle"],
        language="c++",
    )
]

setup(
    ext_modules=cythonize(extensions)
)
```
`library_dirs` 这个就是传给 gcc 的 -L 参数，我们指定对应的动态链接库的目录。`libraries` 这个就是传给 gcc 的 -l 参数，我们指定动态链接库的名称。同时，我们只需要在`setup.py`中指定`.h`头文件所在的目录即可。  
官方参考：https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html 