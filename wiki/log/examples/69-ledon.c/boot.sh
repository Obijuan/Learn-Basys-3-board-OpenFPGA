#!/usr/bin/env bash

#-- Compilar el bootloader
#-- Herramientas
BIN="/opt/riscv32i/bin"
GCC=$BIN"/riscv32-unknown-elf-gcc"
OBJDUMP=$BIN"/riscv32-unknown-elf-objdump"
OBJCOPY=$BIN"/riscv32-unknown-elf-objcopy"

#-- Directorio asm
ASM="asm"

#-- Directorio de construccion
BUILD="./_build"

#-- Directorio fuente en c
SRC="c"

#------- Opciones
#-- -fdata-section: Optimizacion. Las variables se ponen en secciones separadas
#--   esto permite que linker elimine las variables NO USADAS en el codigo
#-- -ffunction-sections: Optimizacion. Lo mismo pero para funciones. Las que NO se usan se
#--   eliminan y no se incluyen en el archivo ejecutable final
$GCC -fdata-sections -ffunction-sections -I $SRC -c \
      $SRC/bootloader.c \
      -o $BUILD/bootloader.o \
     
     
$GCC -fdata-sections -ffunction-sections -I $SRC -c \
     $SRC/boot.c \
     -o $BUILD/boot.o

$GCC -fdata-sections -ffunction-sections -I $SRC -c \
     $SRC/boot_internal.c \
     -o $BUILD/boot_internal.o

$GCC -fdata-sections -ffunction-sections -I $SRC -c \
     $SRC/start.c \
     -o $BUILD/start.o

#-- GENERACION DEL EJECUTABLE
$GCC -nostdlib -nostartfiles -T $ASM/hades-v.ld \
     $BUILD/bootloader.o \
     $BUILD/boot.o \
     $BUILD/boot_internal.o \
     $BUILD/start.o \
     -lgcc -Wl,--no-warn-rwx-segments -Wl,--gc-sections \
     -o $BUILD/out.elf  

#-- Obtener el .bin
$OBJCOPY -O binary $BUILD/out.elf $BUILD/out.bin

#-- Obtener init.mem
$OBJCOPY -I binary -O verilog -S --verilog-data-width 4 --reverse-bytes=4 \
           $BUILD/out.bin init.mem

#-- Obtener el .hex
$OBJCOPY -O ihex $BUILD/out.elf $BUILD/out.hex

#-- Obtener el desensamblado
$OBJDUMP -d -x $BUILD/out.elf > $BUILD/out.dis
