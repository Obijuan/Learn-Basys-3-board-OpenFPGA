#!/usr/bin/env bash

#-- Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
RESET='\033[0m'  #-- Color por defecto

#-- Herramientas
BIN="/opt/riscv32i/bin"
GCC=$BIN"/riscv32-unknown-elf-gcc"
OBJDUMP=$BIN"/riscv32-unknown-elf-objdump"
OBJCOPY=$BIN"/riscv32-unknown-elf-objcopy"

#-- Directorio de construccion
BUILD="./_build"

#-- Directorio fuente asm
ASM="asm"

#-- Directorio fuente en c
C="c"

#-- Crear directorio de construccion, si no lo está ya
mkdir -p $BUILD

#-- Crear directorio de construccion, si no lo está ya
mkdir -p $BUILD/$ASM
mkdir -p $BUILD/$C

if [ -z "$1" ]; then
    echo "Uso: $0 fichero"
    echo "Ejemplo: $0 test-synth-01-decode"
    echo ""
    exit 1
fi

#-- Nombre del fichero a ensamblar, sin extension
NAME=$1
NAME="${NAME%.*}" #-- Quitar extension

#-------------------------- Compilacion!
CMD1="\
$GCC $NAME.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/$NAME.o \
"
echo -e $BLUE"\n• Compilando:"$RESET
echo "➡️ $CMD1"
$CMD1

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------- Compilado de las dependencias: crt.c
CMD2="\
$GCC $C/crt.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/crt.o\
"
echo ""
echo "➡️ $CMD2"
$CMD2

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi


#--------- Compilado de las dependencias: delay.c
CMD="\
$GCC $C/delay.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/delay.o\
"
echo ""
echo "➡️ $CMD"
$CMD

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------- Compilado de las dependencias: buttons.c
CMD="\
$GCC $C/buttons.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/buttons.o\
"
echo ""
echo "➡️ $CMD"
$CMD

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------- Compilado de las dependencias: disp7.c
CMD="\
$GCC $C/disp7.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/disp7.o\
"
echo ""
echo "➡️ $CMD"
$CMD

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------- Compilado de las dependencias: uart.c
CMD="\
$GCC $C/uart.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/uart.o\
"
echo ""
echo "➡️ $CMD"
$CMD

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#--------- Compilado de las dependencias: timer.c
CMD="\
$GCC $C/timer.c -I$C \
     -fdata-sections -ffunction-sections  \
     -c \
     -o $BUILD/timer.o\
"
echo ""
echo "➡️ $CMD"
$CMD

if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#---------- Linkado: generacion del elf
CMD="\
$GCC -nostdlib -nostartfiles -mno-relax \
     -Wl,--no-warn-rwx-segments -Wl,--gc-sections \
     -T $ASM/hades-v.ld \
     $BUILD/$NAME.o \
     $BUILD/crt.o \
     $BUILD/delay.o \
     $BUILD/buttons.o \
     $BUILD/disp7.o \
     $BUILD/uart.o \
     $BUILD/timer.o \
     -o $BUILD/$NAME.elf \
     -lgcc \
"
echo -e $BLUE"\n• Linkando:"$RESET
echo "➡️ $CMD"
$CMD


if [ $? -ne 0 ]; then
    echo -e $RED"> Abortando...\n"$RESET
    exit 1
fi

#-- Desensamblado
echo ""
echo -e $BLUE"• Desensamblado: ${RESET}"$BUILD/$NAME.dis
$OBJDUMP -d -r -t -S $BUILD/$NAME.elf > $BUILD/$NAME.dis

#-- Fichero ejecutable en binario
echo -e $BLUE"• Ejecutable binario: ${RESET}"$BUILD/$NAME.bin
$OBJCOPY -O binary $BUILD/$NAME.elf $BUILD/$NAME.bin

#-- Fichero .hex
echo -e $BLUE"• Ejecutable HEX: ${RESET}"$BUILD/$NAME.hex
$OBJCOPY -O ihex $BUILD/$NAME.elf $BUILD/$NAME.hex


#-- Fichero ejecutable para integrar en la memoria
#-- del diseño en verilog
echo -e $BLUE"• Ejecutable verilog: ${RESET}"$BUILD/$NAME.mem
$OBJCOPY -I binary -O verilog --verilog-data-width 4 \
  --reverse-bytes=4 $BUILD/$NAME.bin $BUILD/$NAME.mem

#-- Es el nuevo init.mem
cp $BUILD/$NAME.mem init.mem
echo -e $BLUE"• Generado: ${RESET}init.mem"
echo ""


