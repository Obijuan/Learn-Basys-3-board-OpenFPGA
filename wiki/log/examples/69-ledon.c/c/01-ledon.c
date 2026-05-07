
//-- Al atributo (naked) define una funcion cuyo punto
//-- de entrada es '__reset' PERO no se añade nada ni al
//-- comienzo ni al final de la funcion
__attribute__((naked))
void __reset() {
    
    //-- Encender un led en ensamblador
    asm("li s0, 0x00200000");
    asm("li t0, 1");
    asm("sw t0, (s0)");
    asm("j .");
}

