mkdir build
cd build
cmake ../cpp
build 
cd ..
python setup.py build_ext --inplace
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./build
python test.py
