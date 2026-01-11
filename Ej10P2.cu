//ENUNCIADO:

/*

Escriba un código CUDA completo (main y kernel), centrándose en la gestión de memoria y configuración de ejecución. 
Dados dos vectores v_a y v_b de tamaño N de tipo float, calcule el vector de salida v_res según la siguiente fórmula:


v_res[idx] = (v_a[idx] + v_b[idx]) / (v_a[idx] * v_b[idx] + 1.0f);


(Nota: Se suma 1.0f para evitar división por cero, asuma que los datos son seguros).


Debes definir N como 5120.
*/


//--------------------------------------------------------------------------------------------------------------------------|

//RESULTADO:

#define N 5120

__global__ void operacion (float *v_a, float *v_b, float *v_res){

	int idx = threadIdx.x + blockIdx.x * blockDim.x;


	if(idx<N){

	v_res[idx] = (v_a[idx] + v_b[idx]) / (v_a[idx] * v_b[idx] + 1.0f);

	}


}

int main(){

int blockSize= 256;
int size = N * sizeof(float);

float *v_a_h,*v_b_h,*v_res_h;

v_a_h = (float*)malloc(size);
v_b_h = (float*)malloc(size);
v_res_h = (float*)malloc(size);


float *v_a_d,*v_b_d,*v_res_d;

cudaMalloc(&v_a_d,size);
cudaMalloc(&v_b_d,size);
cudaMalloc(&v_res_d,size);

cudaMemcpy(v_a_d,v_a_h,size,cudaMemcpyHostToDevice);
cudaMemcpy(v_b_d,v_b_h,size,cudaMemcpyHostToDevice);

dim3 thread(blockSize);
dim3 block((N+blockSize-1)/blockSize);

operacion<<<block,thread>>>(v_a_d,v_b_d,v_res_d);


cudaMemcpy(v_res_h,v_res_d,size,cudaMemcpyDeviceToHost);


    free(v_a_h);
    free(v_b_h);
    free(v_res_h);

    cudaFree(v_a_d);
    cudaFree(v_b_d);
    cudaFree(v_res_d);

return 0;
}




//ENUNCIADO 2:

/*

Suponga que ahora le piden modificar el kernel para realizar la siguiente operación sobre el vector de resultados v_res que acaba de calcular:

v_res[0] = v_res[0] + v_res[i];

Es decir, se quiere acumular la suma de todos los elementos del vector en la primera posición v_res[0].¿Podría realizarse esta operación correctamente dentro del mismo Kernel (usando la variable idx para acceder a i) de forma directa? Justifique su respuesta (Sí/no y por qué).


*/


//--------------------------------------------------------------------------------------------------------------------------|

//RESULTADO:

No, porque esto genera una Condición de Carrera (Race Condition) crítica. Todos los hilos (miles de ellos) intentarían escribir en la posición v_res[0] al mismo tiempo. Al no ser una operación atómica, los valores se sobrescribirían unos a otros sin control y el resultado final sería basura (probablemente solo la suma de unos pocos hilos al azar). Para hacer esto se necesita una Reducción.

