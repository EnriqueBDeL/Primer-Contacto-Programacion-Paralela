//ENUNCIADO:

/*

Escriba un código CUDA completo (main y kernel), centrándose en la gestión de memoria y configuración de ejecución. 
Dados dos vectores v_in1 y v_in2 de tamaño N de tipo float, calcule el vector de salida v_out según la siguiente fórmula:




v_out[i] = (v_in1[i] * v_in1[i]) + (v_in2[i] / 2.0);


Debes definir N como 2048.

*/

//------------------------------------------------------------------------------------------------------------------------------|
//SOLUCIÓN:


#define N 2048



__global__ void SumaVectores(float *v_in1, float *v_in2, float *v_out){


	int idx = threadIdx.x + blockIdx.x * blockDim.x;

	if(idx < N){

	v_out[idx] = (v_in1[idx] * v_in1[idx]) + (v_in2[idx] / 2.0);

	}
} 

int main(){


int blockSize = 256;

int size = N * sizeof(float);


float *v_in1_h, *v_in2_h, *v_out_h;

v_in1_h = (float*)malloc(size);
v_in2_h = (float*)malloc(size);
v_out_h = (float*)malloc(size);


float *v_in1_d, *v_in2_d, *v_out_d;

cudaMalloc(&v_in1_d,size);
cudaMalloc(&v_in2_d,size);
cudaMalloc(&v_out_d,size);


cudaMemcpy(v_in1_d,v_in1_h,size,cudaMemcpyHostToDevice);
cudaMemcpy(v_in2_d,v_in2_h,size,cudaMemcpyHostToDevice);


dim3 thread(blockSize);
dim3 block((N+blockSize-1)/blockSize);

SumaVectores<<<block,thread>>>(v_in1_d,v_in2_d,v_out_d);

cudaMemcpy(v_out_h,v_out_d,size,cudaMemcpyDeviceToHost);


free(v_in1_h);
free(v_in2_h);
free(v_out_h);

cudaFree(v_in1_d);
cudaFree(v_in2_d);
cudaFree(v_out_d);


return 0;

}
