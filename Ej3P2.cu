/*

Dada la siguiente operación recursiva sobre un vector C de N elementos:

c[i] = c[i] + c[i-1]

(Asumiendo que i va de 1 a N, y c[0] es el valor base).


¿Es esta operación paralelizable directamente en CUDA?

Justifica tu respuesta


*/


//SOLUCIÓN:


/*

No se puede paralelizar.

Existe una dependencia de datos entre iteraciones (específicamente una dependencia Read-After-Write). Para calcular el valor de la posición i, necesito el valor nuevo/actualizado de la posición i-1.

Si lanzamos un kernel en CUDA donde todos los hilos se ejecutan simultáneamente, el hilo i leerá el valor de i-1 antes de que el hilo i-1 haya terminado de calcularlo y escribirlo. Esto provocaría que estuviéramos sumando valores antiguos y el resultado sería incorrecto. La operación es inherentemente secuencial.

*/