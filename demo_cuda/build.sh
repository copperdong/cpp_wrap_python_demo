mkdir build
cd build
cmake ../cpp
make 
cd ..
python setup.py build_ext --inplace
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./build
python test.py
