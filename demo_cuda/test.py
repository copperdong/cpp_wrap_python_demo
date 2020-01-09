import cuda_demo as demo_cuda
import numpy as np
import timeit 
import time

arry=range(1,200000000)
I=np.asarray(arry)
pydemo=demo_cuda.Pydemo_cuda(I,len(I))
print(I)
since =time.time()
pydemo.calculate()
print(len(I))
time_elapsed = time.time() - since
print('Training complete in {:.0f}ms'.format(
    time_elapsed*1000 %60000))