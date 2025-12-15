/*

Explique con sus palabras o mediante código, como extrapolaría la solución anterior (Ej6P2.cu) sin utilizar memoria compartida. ¿Es posible? Indique sí o no, justificando adecuadamente su respuesta.

*/


//SOLUCIÓN:


/*

Si, es posible.

Para extrapolar la solución sin usarla, debemos realizar las operaciones de lectura, comparación y escritura directamente sobre la Memoria Global (los punteros que recibimos como argumentos), en lugar de cargar los datos primero en un array intermedio "sdata".

El problema de no utilizar memoria compartida, es que el código será mucho más lento debido a la alta latencia de la memoria global y al tráfico constante hacia la memoria principal de la tarjeta gráfica.


El kernel "extrapolado" para trabajar directamente sobre la memoria global:


#define N 1024

__global__ void getMax_NoShared(float *gin, float *gout, int n_size) {

    // 1. Solo el primer hilo de cada bloque hace el trabajo.
    // Todos los demás hilos (1 a 255) permanecen inactivos.
    if (threadIdx.x == 0) {
        
        // Calcular el inicio del segmento de datos que le toca a este bloque
        int start = blockIdx.x * blockDim.x;
        
        // Calcular el final del segmento, asegurando no exceder N
        int end = start + blockDim.x;
        if (end > n_size) {
            end = n_size;
        }

        // Si el segmento es vacío (no hay datos), no hacemos nada
        if (start >= n_size) return;

        // 2. Búsqueda Secuencial (Lenta)
        // El Hilo 0 itera sobre todo su segmento en la Memoria Global
        float max_val = gin[start]; // Inicializa con el primer valor
        
        for (int i = start + 1; i < end; i++) {
            // Este es un acceso LENTO a la Memoria Global en cada paso
            if (gin[i] > max_val) {
                max_val = gin[i];
            }
        }

        // 3. Escribir el Máximo del Bloque
        // El resultado se escribe en el índice de 'gout' correspondiente a este bloque
        gout[blockIdx.x] = max_val;
    }
}
*/


//EJEMPLO CODIGO EJECUTABLE:


#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define N 1024
#define THREADS_PER_BLOCK 256

__global__ void getMax_Global(float *gin, float *gout) {
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned int tid = threadIdx.x;

    __syncthreads();

    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s) {
            if (gin[i + s] > gin[i]) {
                gin[i] = gin[i + s];
            }
        }
        __syncthreads();
    }

    if (tid == 0) {
        gout[blockIdx.x] = gin[i];
    }
}



int main() {

    //CPU


    float *h_in, *h_out;
    float *d_in, *d_out;


    int blocks = N / THREADS_PER_BLOCK;
    size_t size = N * sizeof(float);
    size_t size_out = blocks * sizeof(float);


    h_in = (float*)malloc(size);
    h_out = (float*)malloc(size_out);


    cudaMalloc((void**)&d_in, size);
    cudaMalloc((void**)&d_out, size_out);


    for (int i = 0; i < N; i++) {
        h_in[i] = (float)i;
    }
    h_in[500] = 9999.0f;


    cudaMemcpy(d_in, h_in, size, cudaMemcpyHostToDevice);

//-------------------------------------------------------------------------------------------------
    //GPU

    dim3 thread(THREADS_PER_BLOCK);
    dim3 block(blocks);

    getMax_Global<<<block, thread>>>(d_in, d_out);

    cudaDeviceSynchronize();

    cudaMemcpy(h_out, d_out, size_out, cudaMemcpyDeviceToHost);


//-------------------------------------------------------------------------------------------------
    //CPU


    float max_val = 0.0f;
    for (int i = 0; i < blocks; i++) {
        if (h_out[i] > max_val) {
            max_val = h_out[i];
        }
    }


    printf("Maximo: %f\n", max_val);


    cudaFree(d_in);
    cudaFree(d_out);

    free(h_in);
    free(h_out);

    return 0;

}
