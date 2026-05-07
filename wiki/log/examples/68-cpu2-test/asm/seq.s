#-------------------------------------------
 #-- play1: Dar una pasada a la secuencia
 #--
 #--  a0: Valor inicial de la secuencia
 #--  a1: Bits a desplazar a la izquierda
 #--  a2: Pasos de la secuencia
 #--
 #------------------------------------------
 play1:
   addi sp, sp, -16
   sw ra, 12(sp)

   #-- Guardar registros estaticos usados
   sw s1, 0(sp)
   sw s2, 4(sp)
   sw s3, 8(sp)

   #-- Leer parametros
   mv s1, a0
   mv s2, a1
   mv s3, a2

 1:
   
   #-- Mostrar secuencia actual
   sw s1, (gp)

   #-- Esperar
   li a0, PAUSA
   jal delay

   #-- Desplazar a la izquierda
   sll s1, s1, s2

   #-- Queda un paso menos
   addi s3, s3, -1
   
   #-- Si quedan pasos, repetir
   bgt s3, zero, 1b

   #-- Secuencia terminada
   #-- Recuperar registros estaticos
   lw s1, 0(sp)
   lw s2, 4(sp)
   lw s3, 8(sp)

   #-- Recuperar direccion de retorno
   lw ra, 12(sp)
   addi sp, sp, 16
   ret
