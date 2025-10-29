EJERCICIO 1:

Implemente una función en OpenMP (solo la función) que calcule el número de apariciones de un cierto carácter en una matriz de caracteres. 
Genere un código en OMP que contabilice la frecuencia del valor de entrada. Un pseudocódigo puede ser el siguiente:

#define N1 1000
#define N2 1000  

void conteo (char * matriz, char c, int * contador){

	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			if(matrix[i * N2 + j] == c)
				(*contador)++;
}


SOLUCIÓN:


#define N1 1000
#define N2 1000  

void conteo (char * matriz, char c, int * contador){

	#pragma omp parallel for reduction(+:*contador)

	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			if(matrix[i * N2 + j] == c)
				(*contador)++;
}

||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 2:

Implemente una función en OpenMP (sólo la función) que reciba un vector de float y devuelva el elemento MAYOR.


float getMax (float *v_in)
{
	float max;
	
	return max;
}


SOLUCIÓN:



float getMax (float *v_in, int tamano){

	#pargma omp parallel for reduction(max:max)

	for(int i = 1; i<tamano; i++){

		if (max < *v_in[i]){
	
			max = *v_in[i]	

		}
	}

	return max;

	

}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 3:

Implemente una función en OpenMP (solo la función) que reciba un vector de enteros (int), su tamaño y devuelva un 0 en la posición “i” si el número almacenado es par y un 1 si no lo es. 
Realizar el ejercicio de manera que el número de iteraciones a realizar por cada hilo NO se le asigne desde el principio el número de iteraciones que va a ejecutar.


SOLUCIÓN:


int *vector[100];


void detector(int *vector, int tamano) {

#pragma omp parallel for schadule(dinamc)
	for(int i = 0; i < 100; i++){

		if( vactor[i]%2 == 0){

			vector[i] = 0;

		}else{
	
			vector[i] = 1;	

		}

}

||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||




EJERCCIO 4: 


Paralice la siguiente función con omp. Esta función calcula el número de pares en un array. La función auxiliar “is_par()” devuelve si un número es par. 
Cambia el código necesario, para añadir las directivas OMP correspondientes, y que la paralelización de un resultado correcto en el siguiente trozo de código.


void omp_count_pares(int *a, int size)
{
	if(size == 0)
		return;
	int count = 0, i = 0;
	do{
		if(is_par(a[i])
			++count;
		++i;
	} while (i < size)
	cout << “Encontramos “ << count << “numeros pares. “ << end1;
}



SOLUCIÓN:



bool is_par(int n) {
    return (n % 2 == 0);
}

void omp_count_pares(int *a, int size) {
 
   if (size == 0)
        return;

    int count = 0;

    #pragma omp parallel for reduction(+:count)
    for (int i = 0; i < size; i++) {

   
        if (is_par(a[i])) {
            ++count;
        }
    }


    std::cout << "Encontramos " << count << " numeros pares. " << std::endl;
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 5:


Realice un código OMP que obtenga el número e mediante la serie e = 1/1! + 1/2! + 1/3!+...+ 1/n!, puedes usar el siguiente código secuencial.




#define iter 1000

int main(){
	float e1, e2 = 1;



	for(int i = 1; i < ITER; i++){

		e1 = 1.0f;

		for(int j = i; j > 0; j--)

			e1 *= j;

		e2 += 1.0f/e1;
	}

	printf(“e es %f \n”, e2);
}


SOLUCIÓN:


#define iter 1000

int main(){

	float e1, e2 = 1;

#pragma omp parallel for reduction(+:e2)

	for(int i = 1; i < ITER; i++){

		e1 = 1.0f;

		for(int j = i; j > 0; j--){

			e1 *= j;

		e2 += 1.0f/e1;

		}
	}

	printf(“e es %f \n”, e2);
}



||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

EJERCICIO 6:

Implemente una función en OpenMP que reciba un vector de float, que devuelva la suma de todos los elementos del vector al cuadrado. 
Realizar la función de manera que a cada hilo se le asigne desde el principio el número de iteraciones que va a ejecutar. 
No se debe dar por supuesto ninguna opción por defecto en la sentencia pragma.


SOLUCIÓN:



float sumaCuadrado(float *v, int tamano){

float resultado = 0.0f;


#pragma omp parallel for schedule(static) reduction (+:resultado)
	for(int i = 0; i<100; i++){


	       resultado += v[i] * v[i];


	}
	
	return resultado;
	
}

||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 7:


Implemente una función en OpenMP que calcule el producto escalar de dos vectores de float (v1 y v2) de tamaño size. El producto escalar se define como la suma de v1[i] * v2[i].

Requisitos:

La función debe ser paralela y devolver un resultado correcto (float).

Debe gestionar correctamente la variable de acumulación (suma_total) para evitar condiciones de carrera.




#include <omp.h>

float producto_escalar(float *v1, float *v2, int size)
{
    float suma_total = 0.0f;

    for (int i = 0; i < size; i++) {
        suma_total += v1[i] * v2[i];
    }

    return suma_total;
}



SOLUCIÓN:

#include <omp.h>

float producto_escalar(float *v1, float *v2, int size)
{
    float suma_total = 0.0f;

#pragma omp parallel for reduction(+:suma_total)
    for (int i = 0; i < size; i++) {
        suma_total += v1[i] * v2[i];
    }

    return suma_total;
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 8:

Analice el siguiente fragmento de código. ¿Se puede paralelizar el bucle for usando una directiva #pragma omp for y esperar un resultado correcto?

Responda Sí/No y justifique brevemente por qué, mencionando el tipo de problema (si existe) que impide la paralelización.



#define N 10000

int main() {

    double datos[N];
    datos[0] = 42.0;

    for (int i = 1; i < N; i++) {
        datos[i] = datos[i - 1] / 2.0;
    }

    return 0;
}



SOLUCIÓN:

No, no es paralelizable.

El bucle tiene una dependencia de datos entre iteraciones.

La iteración actual (para calcular datos[i]) depende directamente del resultado de la iteración anterior (datos[i-1]). Esto obliga a que el bucle se ejecute en orden secuencial; si los hilos lo ejecutan en paralelo, un hilo podría intentar leer datos[4] antes de que el hilo encargado de datos[3] haya terminado de calcularlo, llevando a un resultado incorrecto.


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

EJERCICIO 9:



Implemente una función en OpenMP que recibe un vector de entrada v_in, un vector de salida v_out y un factor_base.

La función debe calcular v_out[i] = v_in[i] + (i * factor_base).


Paralice el bucle for.

La variable factor_base debe ser copiada al almacenamiento privado de cada hilo justo al entrar en la región paralela, usando la cláusula de OpenMP explícita para esta acción.


void calcular_con_base(int *v_in, int *v_out, int size, int factor_base)
{

    for (int i = 0; i < size; i++) {
        v_out[i] = v_in[i] + (i * factor_base);
    }
}




SOLUCIÓN:



void calcular_con_base(int *v_in, int *v_out, int size, int factor_base)
{

#pragma omp parallel for firstprivate(factor_base)
    for (int i = 0; i < size; i++) {
        v_out[i] = v_in[i] + (i * factor_base);
    }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 10:

Paralice el siguiente código secuencial que calcula una aproximación de pi (Pi) usando la serie de Leibniz. Debe asegurarse de que la suma paralela es correcta.

Pista: La serie es pi = 4 x (1 - 1/3 + 1/5 - 1/7 + 1/9 - ...)


#include <stdio.h>
#include <omp.h>

#define N_ITER 100000000 
int main() {
    double suma_parcial = 0.0;

    for (int i = 0; i < N_ITER; i++) {
        
        if (i % 2 == 0) {
            suma_parcial += 1.0 / (2.0 * i + 1.0);
        } else {
            suma_parcial -= 1.0 / (2.0 * i + 1.0);
        }
    }

    double pi = 4.0 * suma_parcial;
    printf("El valor de PI es aprox: %lf\n", pi);
    
    return 0;
}



SOLUCIÓN:


#include <stdio.h>
#include <omp.h>

#define N_ITER 100000000 

int main() {

    double suma_parcial = 0.0;

#pragma omp parallel for reduction(+:suma_parcial)
    for (int i = 0; i < N_ITER; i++) {
        
        if (i % 2 == 0) {
            suma_parcial += 1.0 / (2.0 * i + 1.0);
        } else {
            suma_parcial -= 1.0 / (2.0 * i + 1.0);
        }
    }


    double pi = 4.0 * suma_parcial;
    printf("El valor de PI es aprox: %lf\n", pi);
    
    return 0;
}

||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 11:


Implemente una función en OpenMP que recibe un vector v_in y un vector v_out. La función debe llenar v_out[i] con el resultado de una función auxiliar trabajo_costoso(v_in[i]).

La función trabajo_costoso tiene un coste computacional muy variable; no se puede asumir que dos iteraciones i y j vayan a tardar el mismo tiempo.

Requisito:

Paralice el bucle for implementando una estrategia de paralelización que minimice el tiempo de inactividad de los hilos y optimice el rendimiento total del cálculo.




int trabajo_costoso(int n) {

    int res = 0;


    for(int k=0; k < (n*1000 + 1000); k++) { 

	res += (k % 123); 

	}

    return res;
}


void procesar_vector(int *v_in, int *v_out, int size)
{
    for (int i = 0; i < size; i++) {
        v_out[i] = trabajo_costoso(v_in[i]);
    }
}





SOLUCIÓN:


int trabajo_costoso(int n) {

    int res = 0;

    for(int k=0; k < (n*1000 + 1000); k++) { 

	res += (k % 123); 

    }

    return res;
}


void procesar_vector(int *v_in, int *v_out, int size){
   
#pragma omp parallel for schedule(dynamic)     

	for (int i = 0; i < size; i++) {
        v_out[i] = trabajo_costoso(v_in[i]);

    }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 12:

Implemente una función en OpenMP (solo la función) que calcule el productorio de un vector de enteros. 
El productorio es la multiplicación de todos sus elementos (v[0] * v[1] * v[2] * ...).




#include <omp.h>


long long productorio(int *v, int size)
{
    long long prod_total = 1;

    for (int i = 0; i < size; i++) {
        prod_total *= v[i];
    }

    return prod_total;
}




SOLUCIÓN:


#include <omp.h>



long long productorio(int *v, int size)
{
    long long prod_total = 1;


#pragma omp parallel for reduction(*:prod_total)
    for (int i = 0; i < size; i++) {
        prod_total *= v[i];
    }

    return prod_total;
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 13:


Implemente una función en OpenMP (solo la función) que calcule el productorio de un vector de enteros. El productorio es la multiplicación de todos sus elementos (v[0] * v[1] * v[2] * ...).

Asegúrese de que la multiplicación paralela sea correcta.



#include <omp.h>


long long productorio(int *v, int size)
{
    long long prod_total = 1;

    for (int i = 0; i < size; i++) {
        prod_total *= v[i];
    }

    return prod_total;
}



SOLUCIÓN:



#include <omp.h>

long long productorio(int *v, int size)
{
    long long prod_total = 1;

    #pragma omp parallel for reduction(*:prod_total)
    for (int i = 0; i < size; i++) {
        prod_total *= v[i];
    }

    return prod_total;
}



||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

EJERCICIO 14:



Analice el siguiente fragmento de código. ¿Se puede paralelizar el bucle for usando una directiva #pragma omp for y esperar un resultado correcto?

Responda Sí/No y justifique brevemente por qué.


#define N 10000

int main() {

    double a[N];

    for (int i = 1; i < N - 1; i++) {
        a[i] = (a[i - 1] + a[i] + a[i + 1]) / 3.0;
    }

    return 0;

}


SOLUCIÓN:

No, no es paralelizable.

El bucle tiene una dependencia de datos entre iteraciones.


La iteración actual (p.ej., i=5) necesita leer a[i-1] (es decir, a[4]). Pero la iteración anterior (i=4) escribe en a[4]. 
Si los hilos se ejecutan en paralelo, el hilo que ejecuta i=5 podría leer a[4] antes o después de que el hilo que ejecuta i=4 lo haya modificado, llevando a un resultado incorrecto e inconsistente (depende del orden de ejecución).


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 15:

Implemente una función en OpenMP que aplique un filtro de suavizado simple (media móvil) a un vector de entrada v_in y guarde el resultado en v_out.

v_out[i] debe ser el promedio de v_in[i-1], v_in[i] y v_in[i+1]. (Nota: los bordes i=0 y i=size-1 se ignoran en el bucle).

Paralice el bucle. ¿Qué ocurre con la variable temp_sum definida dentro del bucle?



void suavizado(float *v_in, float *v_out, int size)
{
    
    for (int i = 1; i < size - 1; i++) {

        float temp_sum = v_in[i-1] + v_in[i] + v_in[i+1];
        v_out[i] = temp_sum / 3.0f;
    }
}


SOLUCIÓN:

void suavizado(float *v_in, float *v_out, int size)
{
       
#pragma omp parallel for
    for (int i = 1; i < size - 1; i++) {

        float temp_sum = v_in[i-1] + v_in[i] + v_in[i+1]; 	//No hay riesgo de que un hilo sobrescriba algo que otro necesita.
								//No hay dependencias entre iteraciones.
        v_out[i] = temp_sum / 3.0f;
    }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 16:



Paralice la siguiente función que calcula la multiplicación de una matriz A por un vector x, guardando el resultado en el vector y. (y = A * x).

El bucle externo (i) itera sobre las filas de la matriz y el resultado y. El bucle interno (j) calcula el producto escalar de la fila i de A con el vector x.



#define N 1000


void mat_vec_mult(float *A, float *x, float *y)
{
    for (int i = 0; i < N; i++) {
        
        float suma_fila = 0.0f; 

        for (int j = 0; j < N; j++) {

            suma_fila += A[i * N + j] * x[j];

        }

        y[i] = suma_fila;
    }
}




SOLUCIÓN:






void mat_vec_mult(float *A, float *x, float *y)
{
  
  
#pragma omp parallel for 
	for (int i = 0; i < N; i++) {
        
       		 float suma_fila = 0.0f; 

        for (int j = 0; j < N; j++) {

            suma_fila += A[i * N + j] * x[j];

        }

        y[i] = suma_fila;
    }
}




||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


EJERCICIO 17:


Implemente una función en OpenMP que encuentre el valor MÁXIMO en una matriz 2D (matriz) de tamaño N x M.

La paralelización debe ser lo más eficiente posible, tratando el espacio 2D de la matriz como un único conjunto de trabajo.



#include <limits.h> // Para INT_MIN

int encontrar_maximo_matriz(int **matriz, int N, int M)
{
    int max_val_global = INT_MIN;

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            if (matriz[i][j] > max_val_global) {
                max_val_global = matriz[i][j];
            }
        }
    }

    return max_val_global;
}





SOLUCIÓN:




#include <limits.h> 


int encontrar_maximo_matriz(int **matriz, int N, int M)
{
  
  int max_val_global = INT_MIN;


#pragma omp parallel for collapse(2) reduction(max:max_val_global)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {

            if (matriz[i][j] > max_val_global) {

                max_val_global = matriz[i][j];
            }
        }
    }

    return max_val_global;
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||




EJERCICIO 18:




Implemente una función en OpenMP que calcula una serie numérica.

El coste de calculo_termino(i) es ligeramente variable y no predecible. 
Para optimizar el balanceo de carga, queremos que los hilos tomen trabajo dinámicamente, pero para 
reducir el overhead (coste de gestión), queremos que cada hilo pida un bloque (chunk) de 64 iteraciones cada vez que se queda libre.



double calculo_termino(int i) {

    int iter = 100 + (i % 13) * 50; 
    double res = 0;
    
     for(int k=0; k < iter; k++) { 
	res += 1.0 / (k+i+1); 

     }
    return res;
}

double calcular_serie(int N)
{
    double suma_total = 0.0;

    for (int i = 0; i < N; i++) {
        suma_total += calculo_termino(i);
    }

    return suma_total;
}


SOLUCIÓN:

double calculo_termino(int i) {

    int iter = 100 + (i % 13) * 50; 
    double res = 0;
    for(int k=0; k < iter; k++) { res += 1.0 / (k+i+1); }
    return res;

}

double calcular_serie(int N)
{
    double suma_total = 0.0;

#pragma omp parallel for reduction(+:suma_total) schedule(dynamic, 64)
    for (int i = 0; i < N; i++) {
        suma_total += calculo_termino(i);
    }

    return suma_total;

}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 19:



Analiza el siguiente código:


#pragma omp parallel for
for (int i = 0; i < N; i++) {
    float temp = v_in[i] * 2.0f;
    v_out[i] = temp + 5.0f;
}


Por defecto, ¿cuál es el ámbito (scope) de la variable temp dentro del bucle paralelo?



SOLUCIÓN:



Las variables declaradas dentro de un bucle paralelo son private por defecto. Cada hilo obtiene su propia copia.




||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 20:



Quieres paralelizar un bucle que calcula el producto de todos los elementos de un vector. El código secuencial es:



long double producto = 1.0;

for (int i = 0; i < N; i++) {
    producto = producto * vector[i];
}


¿Cuál es la directiva de OpenMP correcta para paralelizar este bucle?



SOLUCIÓN:



long double producto = 1.0;

#pragma omp parallel for reduction(*:producto)
for (int i = 0; i < N; i++) {
    producto = producto * vector[i];
}




||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 21:


Analiza el siguiente bucle:


#pragma omp parallel for
for (int i = 1; i < N; i++) {
    A[i] = (A[i-1] + A[i+1]) / 2.0;
}

¿Se puede paralelizar este bucle tal como está con #pragma omp for?



SOLUCIÓN:

No, porque existe una dependencia de datos entre iteraciones.





||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 22:




Observa este código:


int factor = 10;


for (int i = 0; i < N; i++) {
    v_out[i] = v_in[i] * factor;
}


Necesitas que cada hilo tenga su propia copia de factor, y que esa copia se inicialice con el valor 10. ¿Qué cláusula usarías?



SOLUCIÓN:



int factor = 10;

#pragma omp parallel for firstprivate(factor)
for (int i = 0; i < N; i++) {
    v_out[i] = v_in[i] * factor;
}





||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 23:

Quieres paralelizar este bucle para encontrar el valor de la última iteración que cumple una condición:



float ultimo_valor = 0.0f;

for (int i = 0; i < N; i++) {

    if (v[i] > 0.5f) {
        ultimo_valor = v[i];
    }

}

¿Qué cláusula es la más adecuada para ultimo_valor?



SOLUCIÓN:



float ultimo_valor = 0.0f;


#pragma omp parallel for lastprivate(ultimo_valor)

for (int i = 0; i < N; i++) {

    if (v[i] > 0.5f) {
        ultimo_valor = v[i];
    }

}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 24:


Dada esta función para encontrar el valor mínimo en un vector:


float encontrar_min(float *v, int N) {
   
 float min_val = v[0];
    
  for (int i = 1; i < N; i++) {
     
   if (v[i] < min_val) {
            min_val = v[i];
        }

    }
 
   return min_val;
}


Paraleliza.




SOLUCIÓN:

float encontrar_min(float *v, int N) {
   
 float min_val = v[0];
  
  #pragma omp parallel for reduction(min:min_val)
  
  for (int i = 1; i < N; i++) {
     
   if (v[i] < min_val) {
            min_val = v[i];
        }

    }
 
   return min_val;
}




||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 25:


Analiza el siguiente código. Tiene un error de concurrencia (condición de carrera) porque la variable temp es compartida.


void calcular_cuadrados(float *in, float *out, int size) {

    float temp;

    for (int i = 0; i < size; i++) {
        temp = in[i] * in[i];
        out[i] = temp;
    }
}




SOLUCIÓN:

void calcular_cuadrados(float *in, float *out, int size) {

    float temp;

    #pragma omp parallel for private(temp)
    for (int i = 0; i < size; i++) {
        temp = in[i] * in[i];
        out[i] = temp;
    }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 26:


¿Cuál es la directiva OMP más eficiente para paralelizar ambos bucles en esta inicialización de matriz?


#define N 100
#define M 100
int matriz[N][M];

void init_matriz() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            matriz[i][j] = i + j;
        }
    }
}


SOLUCIÓN:


#define N 100
#define M 100
int matriz[N][M];

void init_matriz() {
  #pragma omp parallel for collapse(2)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < M; j++) {
            matriz[i][j] = i + j;
        }
    }
}


||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||



EJERCICIO 27:


Implementa una función OMP que encuentre el elemento MÍNIMO de un vector.


float getMin(float *v_in, int tamano) {
    
float min_val = v_in[0];

    for (int i = 1; i < tamano; i++) {
       
 	if (v_in[i] < min_val) {
            min_val = v_in[i];
        }

    }
    return min_val;
}


SOLUCIÓN:


float getMin(float *v_in, int tamano) {
    
float min_val = v_in[0];
 
 #pragma omp parallel for reduction(min:min_val)
    for (int i = 1; i < tamano; i++) {
       
 	if (v_in[i] < min_val) {
            min_val = v_in[i];
        }

    }
    return min_val;
}


