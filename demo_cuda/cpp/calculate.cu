#include <calculate.h>
#include <malloc.h>
namespace zjx{
const int block_max=1024;
const int grid_max=1024;
struct grid_struct{
    int block_num;
    int grid_num;
};
struct grid_struct* compute_num(int number){

    struct grid_struct *pp = (struct grid_struct*)malloc(sizeof(struct grid_struct));
    if(number<=256){
        pp->block_num=number;
        pp->grid_num=1;
    }else{
        pp->block_num=block_max;
        pp->grid_num=number/block_max > grid_max ? grid_max:number/block_max;
    }
    return pp;
}
__global__ void addwithcuda(int64_t* pointer, int length){
    const int64_t num_threads = gridDim.x * blockDim.x;
    int64_t thread_id = blockIdx.x * blockDim.x + threadIdx.x;
    for (int64_t i = thread_id; i < length; i += num_threads){
        *(pointer + i)=*(pointer + i) + 100;
    }
}
void add_ceshi(int* pointer, int length){
    int *pointer_cuda;
    cudaMalloc((void**)&pointer_cuda,sizeof(int64_t)*length);
    cudaMemcpy(pointer_cuda, pointer, sizeof(int64_t)*length, cudaMemcpyHostToDevice);
    struct grid_struct *cuda_struct=compute_num(length);
    addwithcuda<<<cuda_struct->block_num, cuda_struct->grid_num >>>((int64_t*)pointer_cuda,length);
    cudaMemcpy(pointer, pointer_cuda, sizeof(int64_t)*length, cudaMemcpyDeviceToHost);
    cudaFree(pointer_cuda);
}
}