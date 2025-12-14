/*
======================================================================================|
Los patrones "Stencil" están muy presentes en algoritmos computacionales para el
cálculo de ecuaciones diferenciales. Un patrón "Stencil" es una disposición geométrica
de un grupo que se relaciona con un punto de interés. Esta geometría puede ser de n
dimensiones.

y[i] = 0.3 * (y[i - 1] * y[i] * y[i + 1])
=======================================================================================|
*/

/*
a. Realice un programa que resuelva en la GPU el patrón 1D stencil que se
muestra en la ecuación anterior.
*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void patronStencil(float *Y_in, float *Y_out, int N) {

    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx > 0 && idx < N - 1) {
        Y_out[idx] = 0.3f * (Y_in[idx - 1] * Y_in[idx] * Y_in[idx + 1]);
    } else if (idx < N) {
        Y_out[idx] = Y_in[idx];
    }
}

int main(int argc, char **argv) {

    int N = 16;
    size_t size = N * sizeof(float);

    float *h_Y_in = (float *)malloc(size);
    float *h_Y_out = (float *)malloc(size);

    for (int i = 0; i < N; i++) {
        h_Y_in[i] = (float)(i + 1);
    }

    float *d_Y_in, *d_Y_out;
    
    cudaMalloc(&d_Y_in, size);
    cudaMalloc(&d_Y_out, size);

    cudaMemcpy(d_Y_in, h_Y_in, size, cudaMemcpyHostToDevice);
    
//----------------------------------------------------------------------------|

    dim3 blockDim(4);
    dim3 gridDim((N + 3) / 4);

    patronStencil<<<gridDim, blockDim>>>(d_Y_in, d_Y_out, N);

    cudaMemcpy(h_Y_out, d_Y_out, size, cudaMemcpyDeviceToHost);

//----------------------------------------------------------------------------|

    printf("\nRESULTADOS DEL STENCIL (1D)\n");
    printf("======================================\n");
    printf("| INDICE |  ORIGINAL  |  RESULTADO |\n");
    printf("|--------|------------|------------|\n");

    for (int i = 0; i < N; i++) {
        char cambio = (i > 0 && i < N - 1) ? '*' : ' ';

        printf("|   %2d   |  %8.2f  |  %8.2f %c|\n", i, h_Y_in[i], h_Y_out[i], cambio);
    }
    printf("======================================\n");
    printf("Nota: '*' indica valores calculados por el stencil.\n\n");

    free(h_Y_in);
    free(h_Y_out);
    cudaFree(d_Y_in);
    cudaFree(d_Y_out);

    return 0;
}

/*
   b) Escribe un kernel CUDA usando la técnica de tiling para un patrón
   Stencil 1-D indicando el número de hilos y de threads que ejecutaron el
   mismo. ¿Crees que es interesante aplicar tiling en este código?
   ¿Por qué? (Punto a realizar después de explicar la shared memory).
*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define BLOCK_SIZE 256 // Número de hilos por bloque

// Kernel usando Tiling (Shared Memory)
__global__ void patronStencilTiled(float *Y_in, float *Y_out, int N) {
    
    // 1. Declarar memoria compartida: 
    // Tamaño = hilos del bloque + 2 (uno extra a la izq y otro a la der para los vecinos)
    __shared__ float s_data[BLOCK_SIZE + 2];

    int tid = threadIdx.x; // Índice local (dentro del bloque)
    int idx = blockIdx.x * blockDim.x + threadIdx.x; // Índice global
    
    int s_idx = tid + 1; // Índice en shared memory (desplazado +1 para dejar hueco al halo izquierdo)

    // 2. Carga del dato central a Shared Memory
    if (idx < N) {
        s_data[s_idx] = Y_in[idx];
    } else {
        s_data[s_idx] = 0.0f; // Relleno si nos salimos del rango
    }

    // 3. Carga de los HALOS (Bordes del tile)
    // El primer hilo del bloque carga el vecino izquierdo
    if (tid == 0) {
        if (idx > 0) 
            s_data[0] = Y_in[idx - 1];
        else 
            s_data[0] = 0.0f; // Borde global izquierdo
    }

    // El último hilo del bloque carga el vecino derecho
    if (tid == BLOCK_SIZE - 1) {
        if (idx + 1 < N) 
            s_data[BLOCK_SIZE + 1] = Y_in[idx + 1];
        else 
            s_data[BLOCK_SIZE + 1] = 0.0f; // Borde global derecho
    }
    
    // 4. BARRERA DE SINCRONIZACIÓN
    // Esperamos a que todos los hilos (y los halos) estén cargados
    __syncthreads();

    // 5. Cálculo usando SOLO Shared Memory (muy rápido)
    if (idx > 0 && idx < N - 1) {
        float val_izq = s_data[s_idx - 1];
        float val_cen = s_data[s_idx];
        float val_der = s_data[s_idx + 1];

        Y_out[idx] = 0.3f * (val_izq * val_cen * val_der);
    } 
    else if (idx < N) {
        // Copia simple para los bordes globales 0 y N-1
        Y_out[idx] = Y_in[idx];
    }
}

int main(int argc, char **argv) {

    int N = 16; 
    size_t size = N * sizeof(float);

    float *h_Y_in = (float *)malloc(size);
    float *h_Y_out = (float *)malloc(size);

    for (int i = 0; i < N; i++) {
        h_Y_in[i] = (float)(i + 1);
    }

    float *d_Y_in, *d_Y_out;
    
    cudaMalloc(&d_Y_in, size);
    cudaMalloc(&d_Y_out, size);

    cudaMemcpy(d_Y_in, h_Y_in, size, cudaMemcpyHostToDevice);
    
    dim3 threadsPerBlock(BLOCK_SIZE);
    dim3 blocksPerGrid((N + BLOCK_SIZE - 1) / BLOCK_SIZE);
   
    patronStencilTiled<<<blocksPerGrid, threadsPerBlock>>>(d_Y_in, d_Y_out, N); // Lanzar Kernel Tiled

    cudaMemcpy(h_Y_out, d_Y_out, size, cudaMemcpyDeviceToHost);
    
    printf("\nRESULTADOS STENCIL TILED (SHARED MEMORY)\n");
    printf("======================================\n");
    printf("| INDICE |  ORIGINAL  |  RESULTADO |\n");
    printf("|--------|------------|------------|\n");
    for (int i = 0; i < N; i++) {
        char cambio = (i > 0 && i < N - 1) ? '*' : ' ';

        printf("|   %2d   |  %8.2f  |  %8.2f %c|\n", i, h_Y_in[i], h_Y_out[i], cambio);
    }
    printf("======================================\n");

    free(h_Y_in);
    free(h_Y_out);
    cudaFree(d_Y_in);
    cudaFree(d_Y_out);

    return 0;

}

