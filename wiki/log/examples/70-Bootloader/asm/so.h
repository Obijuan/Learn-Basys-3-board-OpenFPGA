#--- Registro MIE: INTERRUPT ENABLE
.equ MIE_MEIE, 11  #-- Bit: Machine External Interrupt Enable
.equ MIE_MTIE,  7  #-- Bit: Machine Timer Interrupt Enable

.equ MIE_MEIE_MASK, (1 << MIE_MEIE)  #-- Mascara para activa el bit
.equ MIE_MTIE_MASK, (1 << MIE_MTIE)      #-- Mascara


#--- Registro MSTATUS
.equ MSTATUS_MIE, 3  #-- Bit: Machine Interrupt Enable
.equ MSTATUS_MIE_MASK, (1 << MSTATUS_MIE)  #-- Mascara para activa el bit



#-------------------------------------------------------
#-- Macros y constantes relacionadas con el sistema 
#-------------------------------------------------------

#-- STOP: Entrar en bucle infinito
.macro halt
    j .
.endm
