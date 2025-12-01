/*

Suma todos los valores de un arreglo primero en CPU y luego en GPU mediante reducción paralela, comparando ambos resultados.
Cada bloque de hilos calcula una suma parcial y luego la CPU suma esos parciales para obtener el total final.

*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>


__global__ void reduce0(float *g_idata, float *g_odata, int n){


  extern __shared__ float sdata[]; //Declara un arreglo sin tamaño definido en memoria compartida. 
  				                         //El tamaño se decide en el <<...>> al ejecutar el kernel.
                                   //Solo puede declararse una vez por archico o función kernel.


  unsigned int tid = threadIdx.x; //"unsigned" se utiliza para declarar variables sin signo. (valores >= 0)
  unsigned int i = blockIdx.x*blockDim.x+ threadIdx.x;

  
    // Cargar solo elementos válidos
    sdata[tid] = (i < n) ? g_idata[i] : 0.0f;

    __syncthreads();

    // Reducción en shared memory usando patrón seguro tipo árbol binario
    for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
        if (tid < s)
            sdata[tid] += sdata[tid + s];
        __syncthreads();
    }

    // Hilo 0 escribe el resultado parcial del bloque
    if (tid == 0)
        g_odata[blockIdx.x] = sdata[0];
}



//---------------------------------------------
// MAIN
//---------------------------------------------


int main(int argc, char **argv) {

    if (argc < 3) {
        printf("Uso: %s <tam_array> <threads_por_bloque>%n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);       // tamaño total del arreglo
    int threads = atoi(argv[2]); // hilos por bloque
    int blocks = (n + threads - 1) / threads; // bloques necesarios

    float *h_input  = (float*) malloc(n * sizeof(float));
    float *h_output = (float*) malloc(blocks * sizeof(float));

   
    float *d_input, *d_output;
   
    cudaMalloc(&d_input, n * sizeof(float));
    cudaMalloc(&d_output, blocks * sizeof(float));


    srand(time(NULL));
    for (int i = 0; i < n; i++)
        h_input[i] = (rand() % 100) * 0.2f;

    cudaMemcpy(d_input, h_input, n * sizeof(float), cudaMemcpyHostToDevice);


    //---------------------------------------------
    // Suma CPU
    //---------------------------------------------
   
    float suma_cpu = 0;
    for (int i = 0; i < n; i++)
        suma_cpu += h_input[i];
    printf("CPU Suma total: %.4f%n", suma_cpu);

    
    //---------------------------------------------
    // Suma GPU (kernel)
    //---------------------------------------------
    reduce0<<<blocks, threads, threads * sizeof(float)>>>(d_input, d_output, n);
    
    
    cudaMemcpy(h_output, d_output, blocks * sizeof(float), cudaMemcpyDeviceToHost);

    // Reducir resultados parciales en CPU
    float suma_gpu = 0;
    for (int i = 0; i < blocks; i++)
        suma_gpu += h_output[i];

    printf("GPU Suma total: %.4f%n", suma_gpu);

    //---------------------------------------------
    // Liberar memoria
    //---------------------------------------------
    cudaFree(d_input);
    cudaFree(d_output);
    free(h_input);
    free(h_output);

    return 0;
}