//--- Registro MIE: INTERRUPT ENABLE
#define MIE_MEIE 11  //-- Bit: Machine External Interrupt Enable
#define MIE_MTIE  7  //-- Bit: Machine Timer Interrupt Enable

#define MIE_MEIE_MASK (1 << MIE_MEIE)  //-- Mascara para activa el bit
#define MIE_MTIE_MASK (1 << MIE_MTIE)  //-- Mascara


//--- Registro MSTATUS
#define MSTATUS_MIE 3  //-- Bit: Machine Interrupt Enable
#define MSTATUS_MIE_MASK (1 << MSTATUS_MIE)  //-- Mascara para activa el bit
