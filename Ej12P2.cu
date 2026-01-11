//ENUNCIADO:

/*

Escriba un código CUDA completo (Kernel + llamada desde el Host) que, dado un vector de int (enteros) de tamaño N, 
calcule la SUMA TOTAL de todos sus elementos utilizando Memoria Compartida Dinámica.



Nota: Se debe realizar una reducción parcial en la GPU. El resultado final puede obtenerse sumando los parciales en la CPU.

*/

//----------------------------------------------------------------------------------------------------------------------------------|
//RESULTADO:


#define N 400

__global__ void sumaTotal(int *vector, int *resultado, int size){

	int idx = threadIdx.x + blockIdx.x * blockDim.x;

	extern __shared__ int memoria[];

	int tid = threadIdx.x;


	if(idx < size){

	memoria[tid] = vector[idx];

	}else{
	
	memoria[tid] = 0;

	}

	__syncthreads();

	for(unsigned int i = blockDim.x/2; i > 0; i>>=1){

		if(tid<i){

		memoria[tid] += memoria[tid+i]; 

		}
	__syncthreads();

	} 


	if(tid == 0){

	resultado[blockIdx.x] = memoria[0];

	}



}