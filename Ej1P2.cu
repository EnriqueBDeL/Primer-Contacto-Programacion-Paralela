// Paraleliza en CUDA la siguiente operación vectorial:
// c[i] = (a[i] + b[i]) * (a[i] - b[i])

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 1000000 //Tamaño del vector


__global__ void vectorMathKernel(float *d_a, float *d_b, float *d_c, int n) {
   
    int i = blockIdx.x * blockDim.x + threadIdx.x;

   
    if (i < n) {
   
        d_c[i] = (d_a[i] + d_b[i]) * (d_a[i] - d_b[i]);
    }
}



int main(){

    //CPU

    float *h_a, *h_b, *h_c;
    
    float *d_a, *d_b, *d_c;

    size_t size = N * sizeof(float);

   
    h_a = (float *)malloc(size);
    h_b = (float *)malloc(size);
    h_c = (float *)malloc(size);


//Inicializamos los vectores con datos. 

   for (int i = 0; i < N; i++) {
     
	   h_a[i] = 5.0f; 
        
	   h_b[i] = 2.0f; 
        
    }


    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);



    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice); 
    cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

//-------------------------------------------------------------------------------------------------
    //GPU

    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

    printf("Lanzando kernel con %d bloques de %d hilos...%n", blocksPerGrid, threadsPerBlock);

    
    vectorMathKernel<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, N);


    cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

//-------------------------------------------------------------------------------------------------
    //CPU


bool correcto = true;
    
    for (int i = 0; i < 5; i++) {
        
	    printf("c[%d]: (%f + %f) * (%f - %f) = %f%n", i, h_a[i], h_b[i], h_a[i], h_b[i], h_c[i]);
        
        if(h_c[i] != 21.0f){ 
		correcto = false;
	}
	
    }
  


    if(correcto){
	    printf("%n¡Éxito! El cálculo es correcto.%n");
    }else{ 
	    printf("%nError en el cálculo.%n");
    }




    cudaFree(d_a);
    cudaFree(d_b); 
    cudaFree(d_c);
     
    free(h_a); 
    free(h_b); 
    free(h_c);

    return 0;

}