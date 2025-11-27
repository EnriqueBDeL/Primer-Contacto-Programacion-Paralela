//ENUNCIADO:

/*

[1.0 puntos] Escriba un código CUDA, centrándose en las transferencias de memoria, en la llamada al kernel y contenido del kernel, para que dados dos vectores de tamaño N de float, realice la siguiente operación con cada elemento 'i':


v_c[i] = (v_a[i] + v_b[i]) * (v_a[i] - v_b[i])



#define N 4096
__global__ void operacion (float * v_a, float * v_b, float * v_c) 
{
    ....
}

....

float *v_a_d, *v_b_d, *v_c_d;
cudaMalloc (&v_a_d, N*sizeof(float));
cudaMalloc (&v_b_d, N*sizeof(float));
cudaMalloc (&v_c_d, N*sizeof(float));
....
....
dim3 block ( ); //RELLENAR (1 o 2 dimensiones según se considere)
dim3 thread (); //RELLENAR (1 o 2 dimensiones según se considere)
sumaMatrices <<<block,thread>>> (v_a_d, v_b_d, v_c_d);


*/

//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN SIN EJECUCIÓN:


/*

#define N 4096


__global__ void operacion (float * v_a, float * v_b, float * v_c) 
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < N) {
        v_c[i] = (v_a[i] + v_b[i]) * (v_a[i] - v_b[i]);
    }
}


// ... (dentro del main) ...

    float *v_a_d, *v_b_d, *v_c_d;
    float *v_a_h, *v_b_h, *v_c_h; 

    cudaMalloc ((void**)&v_a_d, N*sizeof(float));
    cudaMalloc ((void**)&v_b_d, N*sizeof(float));
    cudaMalloc ((void**)&v_c_d, N*sizeof(float));

    cudaMemcpy(v_a_d, v_a_h, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(v_b_d, v_b_h, N * sizeof(float), cudaMemcpyHostToDevice);

   

    // Usamos 1 dimensión porque son vectores lineales.
    // N = 4096. Si usamos 256 hilos por bloque: 4096 / 256 = 16 bloques exactos.

    dim3 thread (256); // 256 hilos es un tamaño estándar eficiente
    dim3 block (16);  // 16 bloques para cubrir los 4096 elementos

  
    operacion <<<block, thread>>> (v_a_d, v_b_d, v_c_d);

    
    cudaMemcpy(v_c_h, v_c_d, N * sizeof(float), cudaMemcpyDeviceToHost);

*/


//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

//SOLUCIÓN EJECUTABLE:


#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define N 4096 

__global__ void operacion(float *v_a, float *v_b, float *v_c) {

    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < N) {
        v_c[i] = (v_a[i] + v_b[i]) * (v_a[i] - v_b[i]);
    }
}

int main() {

    //CPU

    float *v_a_h, *v_b_h, *v_c_h;
    size_t size = N * sizeof(float);

    v_a_h = (float*)malloc(size);
    v_b_h = (float*)malloc(size);
    v_c_h = (float*)malloc(size);


    for (int i = 0; i < N; i++) {
        v_a_h[i] = 10.0f;         
        v_b_h[i] = 4.0f;  
    }

    float *v_a_d, *v_b_d, *v_c_d;

    cudaMalloc((void**)&v_a_d, size);
    cudaMalloc((void**)&v_b_d, size);
    cudaMalloc((void**)&v_c_d, size);

    
    cudaMemcpy(v_a_d, v_a_h, size, cudaMemcpyHostToDevice);
    cudaMemcpy(v_b_d, v_b_h, size, cudaMemcpyHostToDevice);

//-------------------------------------------------------------------------------------------------
    //GPU
   
    dim3 thread(256); 
    dim3 block(16);  

    printf("Ejecutando kernel con %d bloques de %d hilos...\n", block.x, thread.x);

  
    operacion<<<block, thread>>>(v_a_d, v_b_d, v_c_d);



    cudaMemcpy(v_c_h, v_c_d, size, cudaMemcpyDeviceToHost);

//-------------------------------------------------------------------------------------------------
    //CPU


    bool correcto = true;

    for (int i = 0; i < 5; i++) { // Imprimimos solo los 5 primeros
        printf("i=%d: (%f + %f) * (%f - %f) = %f\n", 
               i, v_a_h[i], v_b_h[i], v_a_h[i], v_b_h[i], v_c_h[i]);
        
        if (v_c_h[i] != 84.0f) correcto = false;
    }

    if (correcto){
        printf("\n¡CÁLCULO CORRECTO!\n");
    }else{
      printf("\nFALLO EN EL CÁLCULO\n");
    }


    cudaFree(v_a_d); 
    cudaFree(v_b_d); 
    cudaFree(v_c_d);
   
    free(v_a_h); 
    free(v_b_h); 
    free(v_c_h);

    return 0;
}