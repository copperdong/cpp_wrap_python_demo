g++ c++/_code/Rectangle.cpp -fPIC -shared -o libRectangle.so
cd python
python setup.py build_ext --inplace
cd ..
