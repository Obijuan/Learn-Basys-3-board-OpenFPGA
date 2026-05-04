#-- Punto de entrada del programa de prueba
.global __reset
__reset:
    #-- Se pone primero para ver algo en los leds (op=1)
    auipc x2, 0x41  #-- op=1
    lui x1, 0x40    #-- op=0
    jal x3, etiq1   #-- op=2

etiq1:
    jalr x4, x5       #-- op=3
    beq x6, x7, etiq2 #-- op=4

etiq2:
    bne x8, x9, etiq3 #-- op=5

etiq3:
    blt x10, x11, etiq4 #-- op=6
    bge x12, x13, etiq5 #-- op=7

etiq4:
    bltu x14, x15, etiq6 #-- op=8

etiq5:
    bgeu x16, x17, etiq7 #-- op=9

etiq6:
etiq7:
    lb x18, 0x42(x19)  #-- op=10 0xA
    lh x20, 0x44(x21)  #-- op=11 0xB
    lw x22, 0x50(x23)  #-- op=12 0xC
    lbu x24, 0x60(x25) #-- op=13 0xD
    lhu x26, 0x70(x27) #-- op=14 0xE
    sb x28, 0x80(x29)  #-- op=15 0xF
    sh x30, 0x90(x31)  #-- op=16 0x10
    sw x31, 0xA0(x0)   #-- op=17 0x11
    addi x1, x2, 0xA1  #-- op=18 0x12
    slti x3, x4, 0xA2  #-- op=19 0x13
    sltiu x5, x6, 0xA3 #-- op=20 0x14
    xori x7, x8, 0xA4  #-- op=21 0x15
    ori x9, x10, 0xA5  #-- op=22 0x16
    andi x11, x12, 0xA6 #-- op=23 0x17
    slli x13, x14, 0x01 #-- op=24 0x18
    srli x15, x16, 0x02 #-- op=25 0x19
    srai x17, x18, 0x03 #-- op=26 0x1A
    add x19, x20, x21   #-- op=27 0x1B
    sub x22, x23, x24   #-- op=28 0x1C
    sll x25, x26, x27   #-- op=29 0x1D
    slt x28, x29, x30   #-- op=30 0x1E
    sltu x31, x31, x0   #-- op=31 0x1F
    xor x1, x2, x3      #-- op=32 0x20
    srl x4, x5, x6      #-- op=33 0x21
    sra x7, x8, x9      #-- op=34 0x22
    or x10, x11, x12    #-- op=35 0x23
    and x13, x14, x15   #-- op=36 0x24
    fence               #-- op=37 0x25
    fence.i             #-- op=38 0x26
    ecall               #-- op=39 0x27
    ebreak              #-- op=40 0x28
    csrrw x16, mscratch, x17  #-- op=41 0x29
    csrrs x18, mscratch, x19  #-- op=42 0x2A
    csrrc x20, mscratch, x21  #-- op=43 0x2B
    csrrwi x22, mscratch, 0x10 #-- op=44 0x2C
    csrrsi x23, mscratch, 0x11 #-- op=45 0x2D
    csrrci x24, mscratch, 0x12 #-- op=46 0x2E
    mret                       #-- op=47 0x2F
    wfi                        #-- op=48 0x30
                               

inf: j inf  #-- op=2  0x02
            #-- op=49 0x31  (Ilegal!)
