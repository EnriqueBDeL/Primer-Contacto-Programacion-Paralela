//ENUNCIDADO:

/*

Paralice la siguiente función. Esta función calcula el número de pares en un array. La función auxiliar “is_par()” devuelve si un número es par.


-----------------------------------------|
void count_pares(int *a, int size)
{
	if(size == 0)
		return;
	int count = 0;
	for(int i=0;i<size;i++)
	{
		if(is_par(a[i]))
			++count;
	}
}
-----------------------------------------|

*/



//-------------------------------------------------------------------------------------------------------------------|
//SOLUCION:



__global__ void count_pares(int *a, int *resultado, int size) { 


    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    int tid = threadIdx.x;

    extern __shared__ int memoria[];


    if(idx < size && is_par(a[idx])){
        memoria[tid] = 1;
    } else {
        memoria[tid] = 0;
    }

    __syncthreads();


    for(unsigned int i = blockDim.x / 2; i > 0; i >>= 1) {
     
   if(tid < i) {

            memoria[tid] += memoria[tid + i];

        }
        __syncthreads();      
    }


    if(tid == 0) {

        resultado[blockIdx.x] = memoria[0];

    }
}




int main(){

...

count_pares<<<numBlocks, threadsPerBlock, threadsPerBlock * sizeof(int)>>>(d_a, d_resultado, size);

...

}






