//ENUNCIADO:

/*

Escriba un programa en CUDA que, dados dos vectores v_a y v_b de tamaño N y tipo float,
 calcule en paralelo el vector v_c tal que, para cada elemento i:

v_c[i] = v_a[i] * v_b[i] + sqrtf(v_a[i]);



Se supone que:

- N está definido mediante una macro (#define N).
- Cada hilo CUDA procesa un único elemento del vector.
- El kernel debe evitar accesos fuera de rango.



Esqueleto:

#define N  /* tamaño del vector */

__global__ void kernel(float *v_a, float *v_b, float *v_c) {

    // Índice global
    int idx = /* COMPLETAR */;

    // Comprobación de límites
    if (/* COMPLETAR */) {

        // Operación matemática
        /* v_c[idx] = v_a[idx] * v_b[idx] + sqrtf(v_a[idx]); */
    }
}

int main() {

    int threadsPerBlock = 256;
    int size = N * sizeof(float);

    // Punteros en host
    float *v_a_h, *v_b_h, *v_c_h;

    // Punteros en device
    float *v_a_d, *v_b_d, *v_c_d;

    // Reserva de memoria en host
    /* COMPLETAR */

    // Reserva de memoria en device
    /* COMPLETAR */

    // Copia Host → Device
    /* COMPLETAR */

    // Configuración de bloques
    dim3 threads(threadsPerBlock);
    dim3 blocks(/* COMPLETAR */);

    // Lanzamiento del kernel
    kernel<<<blocks, threads>>>(/* COMPLETAR */);

    // Copia Device → Host
    /* COMPLETAR */

    // Liberar memoria
    /* COMPLETAR */

    return 0;
}




*/

//----------------------------------------------------------------------------------------------|
//RESULTADO:


#define N 4050

__global__ void kernel(float *v_a, float *v_b, float *v_c) {

	int idx = threadIdx.x + blockIdx.x *blockDim.x;


	if(idx < N){

	v_c[idx] = v_a[idx] * v_b[idx] + sqrtf(v_a[idx]);

	}

}

int main(){


   int threadsPerBlock = 256;
   int size = N * sizeof(float);


   float *v_a_h, *v_b_h, *v_c_h;

   	v_a_h = (float*)malloc(size);
	v_b_h = (float*)malloc(size);
	v_c_h = (float*)malloc(size);


   float *v_a_d, *v_b_d, *v_c_d;

	cudaMalloc((void**)&v_a_d,size);
	cudaMalloc((void**)&v_b_d,size);
	cudaMalloc((void**)&v_c_d,size);


   cudaMemcpy(v_a_d,v_a_h,size,cudaMemcpyHostToDevice);
   cudaMemcpy(v_b_d,v_b_h,size,cudaMemcpyHostToDevice);


	dim3 thread(threadsPerBlock);
	dim3 block((N + threadsPerBlock - 1)/threadsPerBlock);


    kernel <<<block,thread>>>(v_a_d,v_b_d,v_c_d);

   cudaMemcpy(v_c_h,v_c_d,size,cudaMemcpyDeviceToHost);


free(v_a_h);
free(v_b_h);
free(v_c_h);

cudaFree(v_a_d);
cudaFree(v_b_d);
cudaFree(v_c_d);


return 0;
}