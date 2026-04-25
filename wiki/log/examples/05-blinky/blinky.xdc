
//-- Placa Basys3

//-- Reloj del sistema
set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports {clk}]

//-- LED
set_property -dict { PACKAGE_PIN L1   IOSTANDARD LVCMOS33 } [get_ports {led}]

