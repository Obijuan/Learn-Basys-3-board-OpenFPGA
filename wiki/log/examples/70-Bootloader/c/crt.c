//──────────────────────────────────────────────────────
//──    C RUNTIME
//──────────────────────────────────────────────────────
//── Esta es una funcion del sistema, que se linka con
//── TODOS los programas en C
//──────────────────────────────────────────────────────

//-- Prototipo de la funcion de usuario
int main();


//───────────────────────────────────────────────────────────
//──  PUNTO DE ENTRADA 
//──  (Definido en el linker script)
//──
//──  Se define la funcion como "nake" para que el compilador
//──  de C NO añada nada (ni pila ni nada...)
//───────────────────────────────────────────────────────────
__attribute__((naked))
void __reset() {

    //── Inicializar la PILA. La etiqueta __ram_end esta definida
    //── en el linker script
    asm("la sp, __ram_end");

    //── Pasamos a funciones en C!!!
    asm("j __start");
}

//───────────────────────────────────────────────────────────
//──  PUNTO DE ENTRADA EN C
//───────────────────────────────────────────────────────────
void __start() {

    //-- Realizar las inicializaciones necesarias
    //-- Llamar a main del usuario!! 
    main();

    //-- Bucle infinito!
    while (1);
}

