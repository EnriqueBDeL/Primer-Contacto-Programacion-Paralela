/*

Escriba una función en CUDA que dado un vector de float devuelva el elemento MAYOR.


__global__ void getMax (float * gin, float * gout) {
}
....
//Rellenar número de hilos por bloque, número de bloques y el kernel.
dim3 thread ( );
dim3 block ( );
getMax <<<block, thread>>> (gin, gout);

*/


//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN SIN EJECUCIÓN:


/*

#define N 1024 


__global__ void getMax (float * gin, float * gout) {
   
    __shared__ float sdata[256];

   
    unsigned int tid = threadIdx.x;            
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x; 
   

    if (i < N) {
        sdata[tid] = gin[i];
    } else {
        sdata[tid] = -1000000000.0f; 
    }
    __syncthreads(); 

  
    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
           
            if (sdata[tid + s] > sdata[tid]) {
                sdata[tid] = sdata[tid + s];             }
        }
        __syncthreads(); 
    }

        if (tid == 0) {
        gout[blockIdx.x] = sdata[0];
    }
}


// ... (dentro del main) ...


dim3 thread ( 256 );

dim3 block ( (N + thread.x - 1) / thread.x );

getMax <<<block, thread>>> (gin, gout);

*/



//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN EJECUTABLE:


#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 10240            // Tamaño del vector
#define THREADS_PER_BLOCK 256

__global__ void getMax(float *gin, float *gout, int n) {
    
    __shared__ float sdata[THREADS_PER_BLOCK];

    unsigned int tid = threadIdx.x;
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

   
    
    if (i < n) {
        sdata[tid] = gin[i];
    } else {
        sdata[tid] = -99999999.0f;     // Usamos -99999999.0 como valor "muy pequeño"  

    }

    __syncthreads(); // Esperar a que todos carguen


    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            if (sdata[tid + s] > sdata[tid]) {
                sdata[tid] = sdata[tid + s];
            }
        }
        __syncthreads();
    }

    if (tid == 0) {
        gout[blockIdx.x] = sdata[0];
    }
}


int main() {

    //CPU

    float *h_in, *h_out_parcial;
    float *d_in, *d_out_parcial;


    int blocksPerGrid = (N + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;
    
    size_t size_in = N * sizeof(float);
    size_t size_out = blocksPerGrid * sizeof(float);


    h_in = (float*)malloc(size_in);
    h_out_parcial = (float*)malloc(size_out);


    for (int i = 0; i < N; i++) {
        h_in[i] = (float)(i % 100); // Valores del 0 al 99
    }
    h_in[500] = 12345.0f; // Ponemos un valor GIGANTE trampa para probar


    cudaMalloc((void**)&d_in, size_in);
    cudaMalloc((void**)&d_out_parcial, size_out);


    cudaMemcpy(d_in, h_in, size_in, cudaMemcpyHostToDevice);

//-------------------------------------------------------------------------------------------------
    //GPU
   
    dim3 thread(THREADS_PER_BLOCK);
    dim3 block(blocksPerGrid);

    printf("Lanzando kernel con %d bloques de %d hilos...\n", block.x, thread.x);

    getMax<<<block, thread>>>(d_in, d_out_parcial, N);
    
    cudaDeviceSynchronize();

    
    cudaMemcpy(h_out_parcial, d_out_parcial, size_out, cudaMemcpyDeviceToHost);


//-------------------------------------------------------------------------------------------------
    //CPU

    float max_final = -99999999.0f;
    for (int i = 0; i < blocksPerGrid; i++) {
        if (h_out_parcial[i] > max_final) {
            max_final = h_out_parcial[i];
        }
    }


    printf("El valor maximo encontrado es: %f\n", max_final);

    if (max_final == 12345.0f) {
        printf("RESULTADO CORRECTO\n");
    } else {
        printf("RESULTADO INCORRECTO\n");
    }

    cudaFree(d_in);
    cudaFree(d_out_parcial);
    free(h_in);
    free(h_out_parcial);

    return 0;
}


