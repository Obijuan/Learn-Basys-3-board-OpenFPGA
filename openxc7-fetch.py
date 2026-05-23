#!/usr/bin/env python3

import subprocess
import shutil
import re
from pathlib import Path

import ansi


# ------ Nombre relativos de los directorios
# -- Base de la distribucion
DIST = "dist"
BIN = "bin"
LIBEXEC = "libexec"
LIB = "lib"


# ------------------------------------------------------------------
# -- Obtener las librerias dinámicas que son dependencias del
# -- fichero ejecutable indicado
# --
# -- ENTRADA:
# --   * binary: Nombre del fichero ejecutable
# --
# -- SALIDA:
# --   * Un diccionario con las librerias y sus paths
# ------------------------------------------------------------------
def get_dependencies(binary: str) -> dict:

    # -- Obtener la rutna del fichero binario
    ruta_binary = shutil.which(binary)

    # -- Obtener sus dependencias (Ejecutando el comando ldd)
    # -- Se obtiene la salida de texto en bruto
    deps_raw = subprocess.run(["ldd", str(ruta_binary)],
                              capture_output=True, text=True, check=True)

    # -- Diccionario para guardar las dependencias
    deps = {}

    # -- Recorrer la salida, linea a linea
    for linea in deps_raw.stdout.splitlines():
        linea = linea.strip()

        # Buscar el patrón: libname.so.X => /path/to/libname.so.X (0x0000...)
        match = re.search(r'(\S+)\s+=>\s+(\S+)', linea)
        if match:
            # -- Guardar la biblioteca y su path en el diccionario
            nombre_lib = match.group(1)
            ruta_lib = match.group(2)

            # -- Caso especial: ld-linux-x86-64.so.2
            # -- En nix viene con la ruta completa en el nombre. Lo truncamos 
            # -- solo al nombre
            if "ld-linux-x86" in nombre_lib:
                nombre_lib = Path(nombre_lib).name
            deps[nombre_lib] = ruta_lib

        # Caso especial: El cargador dinámico (ej: /lib64/ld-linux-x86-64.so.2)
        # suele aparecer al final sin el símbolo '=>'
        elif "ld-linux" in linea or "ld.so" in linea:
            match_ld = re.search(r'(/[^ ]+)', linea)
            if match_ld:
                ruta_ld = match_ld.group(1)
                nombre_ld = ruta_ld.split("/")[-1]
                deps[nombre_ld] = ruta_ld

        # Caso especial: linux-vdso.so.1 (no tiene ruta física)
        elif "linux-vdso" in linea:
            match_vdso = re.search(r'(\S+)', linea)
            if match_vdso:
                deps[match_vdso.group(1)] = ""

    # -- Devolver el diccionario
    return deps


# ------------------------------------------------
# -- Copiar solo el fichero ejecutable indicado
# -- sin sus dependencias
# ------------------------------------------------
def copy_exec(binary: str):
    # -- Obtener la ruta del ejecutable
    executable_path = Path(str(shutil.which(binary)))

    # -- Copiar el ejecutable  al directorio de la distribucion
    executable_target_dir = Path.cwd() / DIST / LIBEXEC
    executable_target = executable_target_dir / binary

    # -- Imprimir nombre del ejecutable
    print(f"{ansi.GREEN}  ⚙️  Ejecutable: ",
          end='', flush=True)
    print(f"{ansi.DEFAULT}{binary}", end='', flush=True)

    # -- Si no existe, copiarlo!
    if not executable_target.exists():
        shutil.copy(executable_path, executable_target)
        # -- Marca para indicar que se ha copiad
        print("✅")
    else:
        # -- Si existe, imprimir solo el nombre, sin copiar
        # -- Marca para indicar que ya estaba
        print("📌")

    print(ansi.DEFAULT, end='', flush=True)


# ------------------------------------------------------
# -- Copiar el ejecutable indicado en la distribucion
# -- junto con TODAS sus librerias
# ------------------------------------------------------
def copy_with_deps(binary: str):

    # -- Copiar primero el ejecutable
    copy_exec(binary)

    # -- Leer las librerias dependencias del ejecutable
    executable_deps = get_dependencies(binary)

    # -- Directorio destino para las librerias
    libs_target_dir = Path.cwd() / DIST / LIB

    # -- Copiar todas las dependencias de yosys
    for lib_name, libs_path in executable_deps.items():

        if libs_path != "":
            # -- Ruta completa del archivo en destino
            lib_target = libs_target_dir / Path(libs_path).name

            # -- Imprimir nombre de la biblioteca
            print(f"{ansi.BLUE}  🧾  Lib: ",
                  end='', flush=True)
            print(f"{ansi.DEFAULT}{lib_name}", end='', flush=True)

            # -- Copiar la libreria si no existe ya...
            if not lib_target.exists():
                shutil.copy(libs_path, libs_target_dir)
                # -- Marca que indica que no existe
                print("✅")
            # -- Ya existe. No copiar, solo informar
            else:
                # -- Marca que indica que ya existe
                print("📌")
    print()


# -----------------
#    MAIN
# -----------------
print(ansi.CLS, end='', flush=True)
print(f"{ansi.BLUE}", end='', flush=True)
print("─────────────────────────")
print("OPENXC7-FETCH")
print("─────────────────────────")
print(ansi.DEFAULT, end='', flush=True)

# ------------- Procesar YOSYS
print()
print(f"{ansi.GREEN}────── Yosys ──────")
print(ansi.DEFAULT, end='', flush=True)

# -- Obtener el ejecutable y las librerias
# -- en los directorio dist/libexe y dist/lib
print("🔵 yosys:")
copy_with_deps("yosys")

print("🔵 yosys-abc:")
copy_with_deps("yosys-abc")

# -- No es un ejecutable, es un script bash
print("🔵 yosys-config:")
copy_exec("yosys-config")

print()
# -- Siguiente paso: Observar lo que hay en la carpeta yosys de nix
# yosys-filterlib  yosys-smtbmc  yosys-witness

# ----- Procesar NEXTPNR-XILINX
# print()
# print(f"{ansi.GREEN}────── Nextpnr-Xilinx ──────")
# print(ansi.DEFAULT, end='', flush=True)
# copy_with_deps("nextpnr-xilinx")

# TODO
# Crea el directorio de destino y todos sus padres si no existen
# destino_directorio.mkdir(parents=True, exist_ok=True)
