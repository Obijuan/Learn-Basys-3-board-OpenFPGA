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

# -- TIPOS DE FICHERO
EJECUTABLE = 0
SHELL_SCRIPT = 1
PYTHON = 2


class ToolWrapper:

    # -- Cabecera del shell wrapper, comun a todos los wrappers
    BIN_WRAPPER = """\
#!/usr/bin/env bash\n
release_bindir="$(dirname "${BASH_SOURCE[0]}")"
release_bindir_abs="$(readlink -f "$release_bindir")"
release_topdir_abs="$(readlink -f "$release_bindir/..")"
export PATH="$release_bindir_abs:$PATH"
"""

    def __init__(self, bin_name: str):

        # -- Guardar el nombre del binario
        self.bin = bin_name

        # -- Shell: contenido del wrapper
        self.shell = self.BIN_WRAPPER

    # -- Añadir trazas de depuracion
    def add_debug(self):
        self.shell += 'echo Bindir: ${release_bindir}\n'
        self.shell += 'echo Bindir_abs: ${release_bindir_abs}\n'
        self.shell += 'echo Topdir_abs: ${release_topdir_abs}\n'

    def add_exec(self):
        self.shell += 'exec "$release_topdir_abs"/lib/ld-linux-x86-64.so.2 '\
                      '--inhibit-cache '\
                      '--inhibit-rpath "" '\
                      '--library-path "$release_topdir_abs"/lib '\
                      f'"$release_topdir_abs"/libexec/{self.bin} "$@"\n'

    def write_bin(self):

        # -- Obtener el path donde escribir el wrapper
        wrapper_file = Path.cwd() / DIST / BIN / self.bin

        try:
            wrapper_file.write_text(self.shell, encoding="utf-8")

        except PermissionError:
            print(f"❌ Error: sin permisos '{self.bin}'.")
        except FileNotFoundError:
            print("❌ Directorio no existe")
        except Exception as e:
            print(f"❌ Error inesperado al escribir el archivo: {e}")


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

    # -- Marca para indicar el tipo de archivo
    mark = ""

    # -- Si no existe, copiarlo!
    if not executable_target.exists():
        shutil.copy(executable_path, executable_target)
        # -- Marca para indicar que se ha copiad
        mark = "✅"
    else:
        # -- Si existe, imprimir solo el nombre, sin copiar
        # -- Marca para indicar que ya estaba
        mark = "📌"

    # -- Imprimir nombre del ejecutable
    print(f"{ansi.GREEN}  ⚙️  Ejecutable: ",
          end='', flush=True)
    print(f"{ansi.DEFAULT}{mark}{binary}")


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

    # -- Marca para indicar si el archivo se ha copiado (✅)
    # -- o bien no ha sido necesario porque ya estaba (📌)
    mark = ""

    # -- Copiar todas las dependencias de yosys
    for lib_name, libs_path in executable_deps.items():

        if libs_path != "":
            # -- Ruta completa del archivo en destino
            lib_target = libs_target_dir / Path(libs_path).name

            # -- Copiar la libreria si no existe ya...
            if not lib_target.exists():
                shutil.copy(libs_path, libs_target_dir)
                # -- Marca que indica que no existe
                mark = "✅"
            # -- Ya existe. No copiar, solo informar
            else:
                # -- Marca que indica que ya existe
                mark = "📌"

            # -- Imprimir nombre de la biblioteca
            print(f"{ansi.BLUE}  🧾 Lib: ",
                  end='', flush=True)
            print(f"{ansi.DEFAULT}{mark}{lib_name}")


# ------------------------------------
# -- Ejecutar el comando "file -b fich"
# -- Se devuelve la cadena procesada y
# -- en minusculas
# -------------------------------------
def cmd_file(fich: Path) -> str:
    # -- Ejecutar "file -b fich"
    resultado = subprocess.run(
        ['file', '-b', fich],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=True
    )

    # -- Obtener la salida en crudo
    output_cmd = resultado.stdout.strip()

    # -- Pasarla a minusculas
    output_cmd = output_cmd.lower()

    # -- Devolver resultado
    return output_cmd


# ----------------------------------------------------
# -- Comprobar si el fichero es un ejecutable ELF
# -- Se hace llamando al comando "file"
# ----------------------------------------------------
def is_elf(fich: Path) -> bool:

    # -- Ejecutar comando "file -b fich"
    # -- Para saber el tipo de fichero
    output = cmd_file(fich)

    # -- Detectar el patron "elf"
    return "elf " in output


# -----------------------------------------------------
# -- Comprobar si es un programa PYTHON
# -----------------------------------------------------
def is_python_script(fich: Path) -> bool:

    # -- Ejecutar comando "file -b fich"
    # -- Para saber el tipo de fichero
    output = cmd_file(fich)

    # -- Detectar si es un script python
    return "python script" in output


# -----------------------------------------------------
# -- Comprobar si es un script shell
# -----------------------------------------------------
def is_shell_script(fich: Path) -> bool:

    # -- Ejecutar comando "file -b fich"
    # -- Para saber el tipo de fichero
    output = cmd_file(fich)

    # -- Detectar si es un script shell
    return "bash script" in output


def run_fase1(name: str):
    print(ansi.YELLOW, end='')
    print("Fase 1: Copiando ejecutables a la distribucion")
    print(ansi.DEFAULT, end='')
    print("Ejecutables ---> dist/libexec")
    print("Bibliotecas ---> dist/lib")
    print()

    # -- Obtener la ruta del ejecutable
    executable_path = Path(str(shutil.which(name)))

    # -- Obtener su directorio
    executable_path_dir = executable_path.parent

    # -- Leer todos los ficheros que hay en ese directorio
    list_exec = [fich for fich in executable_path_dir.iterdir()
                 if fich.is_file()]

    # -- Recorrer todos los ficheros
    for fich in list_exec:

        # -- Informar del fichero actual
        print(f"🔵 {fich.name}", end='')

        # -- Es un EJECUTABLE
        if is_elf(fich):

            print("(ELF)")

            # -- Copiarlo a la distribucion
            # -- Junto a todas librerias
            copy_with_deps(fich.name)

        # -- Es un Script Python
        elif is_python_script(fich):
            print("(PYTHON)")

            # -- Copiarlo a la distribucion, sin mas
            copy_exec(fich.name)

        # -- Es un script shell
        elif is_shell_script(fich):
            print("(SHELL)")

            # -- Copiarlo a la distribucion, sin mas
            copy_exec(fich.name)

        # -- Es otro tipo de archivo
        else:
            print("(UNKNOWN)")

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
name = "yosys"
print()
print(f"{ansi.GREEN}────── {name.capitalize()} ────────────────────────────")
print(ansi.DEFAULT, end='', flush=True)

# -- Ejecutar fase 1: Copiar ejecutables y bibliotecas
run_fase1(name)
print()

# -- Fase 2: Crear los wrappers para los ejecutables
name = "yosys"
print(ansi.YELLOW, end='')
print("Fase 2: Creando ejecutables (wrappers) en dist/bin")
print(ansi.DEFAULT, end='')

# -- Obtener la ruta del ejecutable
executable_path = Path(str(shutil.which(name)))

# -- Obtener su directorio
executable_path_dir = executable_path.parent

# -- Leer todos los ficheros que hay en ese directorio
list_exec = [fich for fich in executable_path_dir.iterdir()
             if fich.is_file()]

# -- Recorrer todos los ficheros
for fich in list_exec:

    # -- Es un EJECUTABLE
    if is_elf(fich):
        # -- Informar del fichero actual
        print(f"🔵 {fich.name}")

        # -- Crear el wrapper
        wrapper = ToolWrapper(fich.name)
        wrapper.add_debug()
        wrapper.add_exec()
        wrapper.write_bin()

print()


# ----- Procesar NEXTPNR-XILINX
# print()
# print(f"{ansi.GREEN}────── Nextpnr-Xilinx ──────")
# print(ansi.DEFAULT, end='', flush=True)
# copy_with_deps("nextpnr-xilinx")

# TODO
# Crea el directorio de destino y todos sus padres si no existen
# destino_directorio.mkdir(parents=True, exist_ok=True)
