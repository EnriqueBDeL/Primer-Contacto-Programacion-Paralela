/*

Modifique el código anterior de CUDA (Ej4P2.cu), para que ahora se calcule la siguiente operación:

v_c[i] = (v_a[i] + v_c[i-1]) * (v_a[i] - v_c[i+1])

Pregunta: ¿Podría calcularse a través de un Kernel como la operación anterior (Ej4P2.cu)? 

Indique sí o no, justificando adecuadamente su respuesta.

*/


//SOLUCIÓN:


// NO, porque hay dependencia de datos en el vector v_c.