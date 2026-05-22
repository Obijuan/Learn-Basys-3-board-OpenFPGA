# Learn-Basys-3-board-OpenFPGA
Learning about the Basys-3 FPGA board using Opensource tools
More information on the [wiki](https://github.com/Obijuan/Learn-Basys-3-board-OpenFPGA/wiki)  (In Spanish)

# Puesta en marcha

1. Instalar el entorno  [Nix](https://nixos.org/)

```bash
curl -L https://nixos.org/nix/install | sh
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

