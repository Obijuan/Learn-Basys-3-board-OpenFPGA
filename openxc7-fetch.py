#!/usr/bin/env python3

import subprocess
import shutil
import re
import stat
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

        # -- Guardar el path completo
        self.path = Path.cwd() / DIST / BIN / self.bin

    # -- Añadir trazas de depuracion
    def add_debug(self):
        self.shell += 'echo Bindir: ${release_bindir}\n'
        self.shell += 'echo Bindir_abs: ${release_bindir_abs}\n'
        self.shell += 'echo Topdir_abs: ${release_topdir_abs}\n'

    def add_exec_python(self):
        self.shell += 'export PYTHONEXECUTABLE='\
                      '"$release_bindir_abs/tabbypy3"\n'\
                      'exec "$release_bindir_abs/tabbypy3" '\
                      f'"$release_topdir_abs"/libexec/{self.bin} "$@"\n'

    def add_exec(self):
        self.shell += 'exec "$release_topdir_abs"/lib/ld-linux-x86-64.so.2 '\
                      '--inhibit-cache '\
                      '--inhibit-rpath "" '\
                      '--library-path "$release_topdir_abs"/lib '\
                      f'"$release_topdir_abs"/libexec/{self.bin} "$@"\n'

    # -- Devolver el path completo del wrapper
    def get_path(self) -> Path:
        return self.path

    def write_bin(self):

        # -- Obtener el path donde escribir el wrapper
        wrapper_file = self.path

        try:
            wrapper_file.write_text(self.shell, encoding="utf-8")

        except PermissionError:
            print(f"❌ Error: sin permisos '{self.bin}'.")
        except FileNotFoundError:
            print("❌ Directorio no existe")
        except Exception as e:
            print(f"❌ Error inesperado al escribir el archivo: {e}")

        # -- Dar permisos de ejecucion
        wrapper_file.chmod(wrapper_file.stat().st_mode | stat.S_IXUSR)


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
def copy_exec(binary: str, target_dir: str = LIBEXEC):
    # -- Obtener la ruta del ejecutable
    executable_path = Path(str(shutil.which(binary)))

    # -- Copiar el ejecutable  al directorio de la distribucion
    executable_target_dir = Path.cwd() / DIST / target_dir
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


# -----------------------------------------------------------
# -- Copiar todas las dependencias de python
# --
# -- store/tabbypy3 --> dist/bin
# -- nix-python/bin/python3.12 --> dist/libexec
# -- nix-python/lib/python3.12/* --> dist/lib/python3.12/
# -----------------------------------------------------------
def copy_python():

    # --- Copiar el wrapper (tabbypy3)
    origen = Path.cwd() / "store" / "tabbypy3"
    destino = Path.cwd() / DIST / BIN / "tabbypy3"
    if destino.exists():
        mark = "📌"
    else:
        shutil.copy(origen, destino)
        mark = "✅"
    print(f"➡️  Dep: {mark}bin/tabbypy3")

    # -- Copiar el ejecutable de python
    origen = Path(str(shutil.which("python3.12")))
    destino = Path.cwd() / DIST / LIBEXEC / "python3.12"
    if destino.exists():
        mark = "📌"
    else:
        shutil.copy(origen, destino)
        mark = "✅"
    print(f"➡️  Dep: {mark}libexec/{origen.name}")

    # -- Copiar el directorio completo de python
    origen = origen.parent.parent / "lib" / "python3.12"
    destino = Path.cwd() / DIST / LIB / "python3.12"
    if destino.exists():
        mark = "📌"
    else:
        shutil.copytree(origen, destino, dirs_exist_ok=True)
        mark = "✅"
    write_access(destino)
    print(f"➡️  Dep: {mark}lib/{origen.name}/")


# ----------------------------------------------------------------
# -- Localizar el path nix cuyo nombre contiene la cadena 'text'
# -- Devuelve el path completo
# --
# --  Ej.  nix_locate("python3.12-click-8.1.7") devuelve
# --       7b7509xv9aqdrayjf1fv5ialf4gbi5wd-python3.12-click-8.1.7
# ------------------------------------------------------------------
def nix_locate(text: str) -> Path:

    # -- Path de la tienda nix
    nix_store = Path("/nix/store")

    # -- Patron de busqueda
    patron = f"*{text}*"

    paths = [dir for dir in nix_store.glob(patron)
             if dir.is_dir()]

    # -- Devolver la primera coincidencia
    return paths[0]


# -----------------------------------------------------------------------
# -- Copiar una biblioteca de python de nix a la distribucion
# -- El directorio del paquete copia a dist/lib/python3.12/site-packages
# --
# -- Ej. paquete click
# --    - Origen:
# --    /nix/store/xxx-python3.12-click/lib/python3.12/site-packages/
# --    - Desino:
# --      dist/lib/python3.12/site-packages
# -----------------------------------------------------------------------
def copy_python_dep(name: str, version: str):

    # -- Localizar la carpeta donde esta el paquete
    dir = nix_locate(f"python3.12-{name}-{version}")

    # -- Directorio origen
    site_pack = dir / "lib" / "python3.12" / "site-packages"
    origen = site_pack / name

    # -- Directorio destino
    dst_site_pack = Path.cwd() / DIST / LIB / "python3.12" / "site-packages"
    destino = dst_site_pack / name

    # -- Dar permisos de escritura al directorio "site-packges" 
    # -- de la distribucion
    write_access(dst_site_pack)

    mark = ""

    if destino.exists():
        mark = "📌"
    else:
        shutil.copytree(origen, destino, dirs_exist_ok=True)
        mark = "✅"

    print(f"➡️  Dep: {mark}{name}-{version}")


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
    return ("bash script" in output) or ("bash -e script" in output)


# -----------------------------------------
# --  Añadir un shebang a un archivo python
# -----------------------------------------
def python_shebang_add(file_path: Path):

    try:
        # -- Leer archivo python
        contents = file_path.read_text(encoding="utf-8")

        # -- Shebang a añadir
        shebang = "#!/usr/bin/env python3\n"

        # -- Añadir shebang!
        contents = shebang + contents

        # -- Escribir nuevos contenidos
        file_path.write_text(contents, encoding="utf-8")
        # print(f"✔️ Shebang añadido con éxito a: {file_path}")

    except PermissionError:
        print(f"❌ Error: Sin permisos '{file_path}'.")
    except Exception as e:
        print(f"❌ Ocurrió un error inesperado: {e}")


# -----------------------------------------
# -- Añadir un shebang a un archivo bash
# -----------------------------------------
def bash_shebang_add(file_path: Path):

    try:
        # -- Leer archivo bash
        contents = file_path.read_text(encoding="utf-8")

        # -- Shebang a añadir
        shebang = "#!/usr/bin/env bash\n"

        # -- Añadir shebang!
        contents = shebang + contents

        # -- Escribir nuevos contenidos
        file_path.write_text(contents, encoding="utf-8")
        # print(f"✔️ Shebang añadido con éxito a: {file_path}")

    except PermissionError:
        print(f"❌ Error: Sin permisos '{file_path}'.")
    except Exception as e:
        print(f"❌ Ocurrió un error inesperado: {e}")


# -----------------------------------------
# -- Dar permisos de escritura al fichero
# -----------------------------------------
def write_access(file_path: Path):

    try:
        # Obtener los permisos
        permissions = file_path.stat().st_mode

        # Activar permisso de escritura
        permissions = permissions | stat.S_IWUSR

        # Aplicar los cambios
        file_path.chmod(permissions)
        # print(f"✔️ Permiso de escritura añadido a: {file_path}")

    except PermissionError:
        print("❌ Error: No tienes permiso")


def run_fase1(name: str):
    print(ansi.YELLOW, end='')
    print("───────────────────────────────────")
    print("Fase 1: Ejecutables y bibliotecas")
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
            # -- en el directorio dist/bin
            copy_exec(fich.name)

            # -- Dar permisos de escritura al fichero python
            python_file_path = Path.cwd() / DIST / LIBEXEC / fich.name
            write_access(python_file_path)

            # -- Añadir un shee bang al comienzo
            python_shebang_add(python_file_path)

        # -- Es un script shell
        elif is_shell_script(fich):
            print("(SHELL)")

            # -- Copiarlo a la distribucion, sin mas
            copy_exec(fich.name, BIN)

            # -- Dar permisos de escritura al fichero bash
            bash_file_path = Path.cwd() / DIST / BIN / fich.name
            write_access(bash_file_path)

            # -- Añadir un shee bang al comienzo
            bash_shebang_add(bash_file_path)

        # -- Es otro tipo de archivo
        else:
            print("(UNKNOWN)")

        print()


def run_fase2(name: str):
    print(ansi.YELLOW, end='')
    print("─────────────────────────────────────────────────────")
    print("Fase 2: Generacion de wrappers")
    print(ansi.DEFAULT, end='')
    print()

    # -- Obtener la ruta del ejecutable
    executable_path = Path(str(shutil.which(name)))

    # -- Obtener su directorio
    executable_path_dir = executable_path.parent

    # -- Leer todos los ficheros que hay en ese directorio
    list_exec = [fich for fich in executable_path_dir.iterdir()
                 if fich.is_file()]

    mark = ""
    info = ""

    # -- Recorrer todos los ficheros
    for fich in list_exec:

        # -- Es un EJECUTABLE
        if is_elf(fich):

            # -- Crear el wrapper
            wrapper = ToolWrapper(fich.name)
            wrapper.add_debug()
            wrapper.add_exec()

            wrapper_path = wrapper.get_path()
            mark = "⬇️ " if wrapper_path.exists() else "✅"
            wrapper.write_bin()

            info = f"🔵 {mark}{fich.name}(ELF)"

        elif is_python_script(fich):

            # -- Crear el wrapper
            wrapper = ToolWrapper(fich.name)
            wrapper.add_debug()
            wrapper.add_exec_python()

            wrapper_path = wrapper.get_path()
            mark = "⬇️ " if wrapper_path.exists() else "✅"
            wrapper.write_bin()
            info = f"🔵 {mark}{fich.name}(PYTHON)"

        elif is_shell_script(fich):
            info = f"❌ {fich.name}(SHELL)"

        else:
            info = f"❌ {fich.name}(UNKNOWN)"

        # -- Informar del fichero actual
        print(f"{info}")


# -----------------------------------------
# -- Copiar archivos especificos de yosys
# -----------------------------------------
def copy_tree(src: Path, dst: Path):

    mark = ""

    try:
        shutil.copytree(src, dst, dirs_exist_ok=True)
        write_access(dst)
        mark = "✅"

    except Exception:  # as e:
        mark = "📌"
        # print(f"❌ Error: {e}")

    finally:
        print(f"{mark} {dst.relative_to(Path.cwd())}")


# ------------------------------------------------
# -- Copiar solo el fichero ejecutable indicado
# -- sin sus dependencias
# ------------------------------------------------
def copy_file(src: Path, dst: Path):

    # mark = ""

    try:
        shutil.copy(src, dst)
        write_access(dst)
        # mark = "✅"

    except Exception:  # as e:
        pass
        # mark = "📌"
        # print(f"❌ Error: {e}")

    # print(f"{mark} {dst.relative_to(Path.cwd())}")


def run_fase3_yosys():
    print(ansi.YELLOW, end='')
    print("───────────────────────────────────")
    print("Fase 3: Copiar datos de yosys")
    print()
    print(ansi.DEFAULT, end='')

    # ---- Obtener directorios
    # -- Directorio base de yosys
    base_dir = Path(str(shutil.which("yosys"))).parent.parent

    # -- Copiar /share/yosys
    origen = base_dir / "share" / "yosys"
    destino = Path.cwd() / DIST / "share" / "yosys"
    copy_tree(origen, destino)

    # -- TODO: Copiar aqui las dependencias de python...
    # -- Copiar las dependencias de python
    copy_python()

    # -- Copiar los paquetes especificos de python
    # -- que necesita cada herramienta
    # -- Yosys:
    copy_python_dep("click", "8.1.7")


def procesar(name: str):
    print()
    print(f"{ansi.GREEN}──────────────────────────────────")
    print(f"  {name.capitalize()}")
    print(f"{ansi.GREEN}──────────────────────────────────")
    print(ansi.DEFAULT, end='', flush=True)
    print()

    # -- Ejecutar fase 1: Copiar ejecutables y bibliotecas
    run_fase1(name)

    # -- Fase 2: Crear los wrappers para los ejecutables
    run_fase2(name)
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

# ---- Prcesar cada una de las herramientas
# -- Yosys
procesar("yosys")
run_fase3_yosys()

# -- Nextpnr-xilinx
procesar("nextpnr-xilinx")

# --- Herramienta fasm
# -- Herramienta PYTHON!
# -- Ficheros:
# 🔵 fasm
# 🔵 .fasm-wrapped
# procesar("fasm")

# name = "fasm"
# print()
# print(f"{ansi.GREEN}──────────────────────────────────")
# print(f"{name.capitalize()}")
# print(f"{ansi.GREEN}──────────────────────────────────")
# print(ansi.DEFAULT, end='', flush=True)
# print()

# # -- Ejecutar fase 1: Copiar ejecutables y bibliotecas
# run_fase1(name)

# print(ansi.YELLOW, end='')
# print("─────────────────────────────────────────────────────")
# print("Fase 2: Generacion de wrappers")
# print(ansi.DEFAULT, end='')
# print()

# # -- Obtener la ruta del ejecutable
# executable_path = Path(str(shutil.which(name)))

# # -- Obtener su directorio
# executable_path_dir = executable_path.parent

# # -- Leer todos los ficheros que hay en ese directorio
# list_exec = [fich for fich in executable_path_dir.iterdir()
#              if fich.is_file()]

# # -- Recorrer todos los ficheros
# for fich in list_exec:

#     if is_python_script(fich) or is_shell_script(fich):
#         # -- Informar del fichero actual
#         print(f"🔵 {fich.name}")

#         # -- Crear el wrapper
#         wrapper = ToolWrapper(fich.name)
#         wrapper.add_debug()
#         wrapper.add_exec()
#         wrapper.write_bin()


# # -- Obtener la ruta del ejecutable
# executable_path = Path(str(shutil.which(name)))

# # -- Obtener su directorio
# executable_path_dir = executable_path.parent

# # -- Leer todos los ficheros que hay en ese directorio
# list_exec = [fich for fich in executable_path_dir.iterdir()
#              if fich.is_file()]

# # -- Recorrer todos los ficheros
# for fich in list_exec:

#     # -- Informar del fichero actual
#     print(f"🔵 {fich.name}")

#     # -- Es un Script Python
#     if is_python_script(fich):
#         print("(PYTHON)")

#         # -- Copiarlo a la distribucion, sin mas
#         # -- en el directorio dist/bin
#         copy_exec(fich.name, BIN)

#         # -- Dar permisos de escritura al fichero python
#         python_file_path = Path.cwd() / DIST / BIN / fich.name
#         write_access(python_file_path)

#         # -- Añadir un shee bang al comienzo
#         python_shebang_add(python_file_path)

#     # -- Es un script shell
#     elif is_shell_script(fich):
#         print("(SHELL)")

#         # -- Copiarlo a la distribucion, sin mas
#         copy_exec(fich.name, BIN)

#     else:
#         print("What?")


# ---- herramienta prjxray. Hay que procesar todos estos ejecutables
# 🔵 bitread (elf)
# 🔵 xc7patch (elf)
# 🔵 xc7frames2bit (elf)
# 🔵 bit2fasm (python)
# 🔵 fasm2frames (python)

# ------ prjxray
# name = "fasm2frames"
# print()
# print(f"{ansi.GREEN}──────────────────────────────────")
# print(f"{name.capitalize()}")
# print(f"{ansi.GREEN}──────────────────────────────────")
# print(ansi.DEFAULT, end='', flush=True)
# print()


# print(ansi.YELLOW, end='')
# print("───────────────────────────────────")
# print("Fase 1: Ejecutables y bibliotecas")
# print(ansi.DEFAULT, end='')
# print("Ejecutables ---> dist/libexec")
# print("Bibliotecas ---> dist/lib")
# print()

# # -- Obtener la ruta del ejecutable
# executable_path = Path(str(shutil.which(name)))

# # -- Obtener su directorio
# executable_path_dir = executable_path.parent

# # -- Leer todos los ficheros que hay en ese directorio
# list_exec = [fich for fich in executable_path_dir.iterdir()
#                 if fich.is_file()]

# # -- Recorrer todos los ficheros
# for fich in list_exec:

#     # -- Informar del fichero actual
#     print(f"🔵 {fich.name}")

#     # -- Es un EJECUTABLE
#     if is_elf(fich):

#         print("(ELF)")

#         # -- Copiarlo a la distribucion
#         # -- Junto a todas librerias
#         copy_with_deps(fich.name)


print()
