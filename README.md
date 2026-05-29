# Learn-Basys-3-board-OpenFPGA
Learning about the Basys-3 FPGA board using Opensource tools
More information on the [wiki](https://github.com/Obijuan/Learn-Basys-3-board-OpenFPGA/wiki)  (In Spanish)

# Puesta en marcha

Para probar los ejemplos tienes que instalar la **toolchain**, que se compone de las [oss-cad-suite](https://github.com/yosyshq/oss-cad-suite-build) y [openxc7](https://github.com/FPGAwars/tools-openxc7)

1. Clona este repositorio

```bash
git clone https://github.com/Obijuan/Learn-Basys-3-board-OpenFPGA.git
```

2. Instalación de las toolchains

Ejecuta este comando:

```bash
curl -L https://github.com/FPGAwars/tools-openxc7/raw/refs/heads/main/install | sh
```

3. Acceder al entorno de la toolchain

Entra en el directorio `Learn-Basys-3-board-OpenFPGA` y ejecuta `. start`

```bash
obijuan@JANEL:~/Develop/Learn-Basys-3-board-OpenFPGA$ . start
───────────────────────────────
Entorno TOOLS-OPENXC7
(c) OPENXC7 Project
(c) Obijuan (FPGAwars, 2026)
───────────────────────────────

[OSS-CAD-SUITE][TOOLS-OPENXC7] ───────────────────────
obijuan@JANEL:~/Develop/Learn-Basys-3-board-OpenFPGA$
```

# Probando el ejemplo hola mundo

Comprueba que todo funciona bien sintetizando el ejemplo 1: El "hola mundo " que enciende el LED15 de la tarjeta Basys3

```bash
cd verilog/01-ledon
make
```


1. Instalar el entorno  [Nix](https://nixos.org/)

```bash
```

2. Clonar este repositorio

3. Entrar en el directorio Learn-Basys-3-board-openFPGA

4. Ejecutar `nix-develop`

  La primera vez se empezarán a bajar, compilar e instalar todas las herramientas. Esto llevará bastante tiempo (20 minnutos en mi ordenador)
  (Estoy trabajando en otras soluciones para mejorar esto)

5. Ejemplo HOLA-MUNDO

  Vamos a hacer una prueba: encender el LED 15 de la Basys3

  1. Entrar en el directorio verilog/01-ledon
  2. Ejecutar `make prog`

Se realiza la síntesis completa y se carga el bitstream en la placa
El resultado es que el LED 15 se enciende

El resultado se muestra en esta animación:

![Animacion de la carga en laplaca](wiki/images/basys-demo.gif)

# Creditos

Las herramientas libres para las FPGAs de Xilinx las tenemos gracias al [Proyecto openXC7](https://github.com/openxc7). Están haciendo un trabajo increible. ¡Muchísimas gracias!

