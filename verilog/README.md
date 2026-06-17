# Verilog examples

The examples can be synthesized and uploaded to the Basys3 board using apio

1. From the repo main folder execute `. apio-env`
2. Change directory to the example `cd verilog/01-ledon`
3. Upload to the basys3 board: `apio upload`


If you prefer to test it without apio:

1. From the repo main folder execute `. start` to enter to the openxc7 environment
2. Change directory to the example `cd verilog/01-ledon`
3. Run `make`
4. run `make prog` to upload to the Basys3 board

The Makefile is located in verilog/01-ledon. Please, copy it to the other folders to build without apio
