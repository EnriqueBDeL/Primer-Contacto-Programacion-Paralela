/*

 Implemente una función en CUDA que reciba un vector de floats, y devuelva en la misma casilla el resultado de elevar el numero guardado en esa casilla, sumando un 1 si el elemento es par.

Ejemplo: Si en la posición "i" hay un 2, el nuevo valor de la posición "i" será 4+1=5;



__global__ void funcion (float * c_entrada, int tam)
{
      
}


//Rellenar el número de hilos por bloque, numero de bloques y kernel.


dim3 thread ();
dim3 block ();

funcion <<< block, thread >>>(entrada, tam);



*/


//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN SIN EJECUCIÓN:


/*

__global__ void funcion (float * c_entrada, int tam) 
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < tam) {
        float valor = c_entrada[i];
        
        float resultado = valor * valor;

        
        if ( (int)valor % 2 == 0 ) {
            resultado = resultado + 1.0f;
        }

        c_entrada[i] = resultado;
    }
}



// ... (dentro del main) ...

dim3 thread ( 256 ); 
dim3 block ( (tam + thread.x - 1) / thread.x );

funcion <<< block, thread >>> (entrada, tam);

*/



//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN EJECUTABLE:



#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 10 

__global__ void funcion(float *c_entrada, int tam) {
   
 int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < tam) {
        float val = c_entrada[i];
        
        float res = val * val;

        if ((int)val % 2 == 0) {
            res += 1.0f;
        }

        c_entrada[i] = res;
    }
}



int main() {

    //CPU

    float *h_vec, *d_vec;
    size_t size = N * sizeof(float);

    h_vec = (float*)malloc(size);



    printf("Vector Original:\n");

    for (int i = 0; i < N; i++) {
        h_vec[i] = (float)i;        
        printf("%.0f ", h_vec[i]);
    }

    printf("\n");

    cudaMalloc((void**)&d_vec, size);

    cudaMemcpy(d_vec, h_vec, size, cudaMemcpyHostToDevice);


//-------------------------------------------------------------------------------------------------
    //GPU


    dim3 thread(256);
    dim3 block((N + thread.x - 1) / thread.x);

    funcion<<<block, thread>>>(d_vec, N);

    cudaDeviceSynchronize();

    cudaMemcpy(h_vec, d_vec, size, cudaMemcpyDeviceToHost);


//-------------------------------------------------------------------------------------------------
    //CPU


    printf("Vector Resultado:\n");

    for (int i = 0; i < N; i++) {
        printf("%.0f ", h_vec[i]);
    }

    printf("\n");
    
   
    if (h_vec[2] == 5.0f) {
        printf("\nPrueba del 2 -> 5: CORRECTO\n");
    }


    cudaFree(d_vec);

    free(h_vec);

    return 0;
}
