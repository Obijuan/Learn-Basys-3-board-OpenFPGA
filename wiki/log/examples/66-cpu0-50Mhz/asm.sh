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

#-- Directorio fuente
ASM="asm"

#-- Crear directorio de construccion, si no lo está ya
mkdir -p $BUILD

#-- Crear directorio de construccion, si no lo está ya
mkdir -p $BUILD/$ASM

if [ -z "$1" ]; then
    echo "Uso: $0 fichero"
    echo "Ejemplo: $0 test-synth-01-decode"
    echo ""
    exit 1
fi

#-- Nombre del fichero a ensamblar, sin extension
NAME=$1
NAME="${NAME%.*}" #-- Quitar extension

#-- Ensamblado
echo -e $BLUE"\n• Ensamblando:"$RESET
$GCC -nostdlib -nostartfiles  -T $ASM/hades-v.ld -o $BUILD/$NAME.elf $NAME.s

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

#-- Fichero ejecutable para integrar en la memoria
#-- del diseño en verilog
echo -e $BLUE"• Ejecutable verilog: ${RESET}"$BUILD/$NAME.mem
$OBJCOPY -I binary -O verilog --verilog-data-width 4 \
  --reverse-bytes=4 $BUILD/$NAME.bin $BUILD/$NAME.mem

#-- Es el nuevo init.mem
mv $BUILD/$NAME.mem init.mem
echo -e $BLUE"• Generado: ${RESET}init.mem"
echo ""


