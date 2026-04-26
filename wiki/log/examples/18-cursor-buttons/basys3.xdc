
#-- Placa Basys3

#-- Reloj del sistema
set_property -dict { PACKAGE_PIN W5    IOSTANDARD LVCMOS33 } [get_ports {clk}]

#-- LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {leds[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {leds[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {leds[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {leds[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {leds[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {leds[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {leds[7]}]
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {leds[8]}]
set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {leds[9]}]
set_property -dict { PACKAGE_PIN W3    IOSTANDARD LVCMOS33 } [get_ports {leds[10]}]
set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports {leds[11]}]
set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {leds[12]}]
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {leds[13]}]
set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {leds[14]}]
set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {leds[15]}]

#------------- Botones
#-- Centro
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports {buttons[0]}]

#-- Arriba
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports {buttons[1]}]

#-- Izquierda
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports {buttons[2]}]

#-- Derecha
set_property -dict { PACKAGE_PIN T17   IOSTANDARD LVCMOS33 } [get_ports {buttons[3]}]

#-- Abajo
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports {buttons[4]}]
