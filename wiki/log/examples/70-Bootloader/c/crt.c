//──────────────────────────────────────────────────────
//──    C RUNTIME
//──────────────────────────────────────────────────────
//── Esta es una funcion del sistema, que se linka con
//── TODOS los programas en C
//──────────────────────────────────────────────────────
#include <peripherals.h>

//-- Prototipo de la funcion de usuario
int main();

//-- Prototipo rutina de atencion excepciones
void __panic_interrupt();


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

    //-- Deshabilitar las interrupciones
    asm("csrw mie, x0");

    //── Pasamos a funciones en C!!!
    asm("j __start");
}

//───────────────────────────────────────────────────────────
//──  PUNTO DE ENTRADA EN C
//───────────────────────────────────────────────────────────
void __start() {

    //-- Gestor de excepciones
    //-- Poner un gestor mínimo, en caso de ocurrir una excepcion
    asm("csrw mtvec, %0": : "r"(__panic_interrupt));

    //-- Realizar las inicializaciones necesarias
    //-- Llamar a main del usuario!! 
    main();

    //-- Bucle infinito!
    while (1);
}


//───────────────────────────────────────────────────────────
//──  RUTINA DE ATENCION A LAS EXCEPCIONES: PANIC!
//──  Si ocurre un error grave, parar la cpu!!!
//───────────────────────────────────────────────────────────
__attribute__((interrupt))
void __panic_interrupt() {

    //-- Encender los LEDs
    LEDS = 0xFFFF;

    //-- STOP!!
    while(1);
}
