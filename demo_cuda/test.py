import cuda_demo as demo_cuda
import numpy as np

arry=range(1,55)
I=np.asarray(arry)
pydemo=demo_cuda.Pydemo_cuda(I,len(I))
print(I)
pydemo.calculate()
print(I)