//-- Módulo Maestro: Pone un valor en el bus
module master_mod (
    simple_bus.master bus_if
);
    assign bus_if.data = 16'hAAF1;
    assign bus_if.valid = 1'b1;
endmodule

//-- Módulo Esclavo: Saca lo que llega por los LEDs
module slave_mod (
    input logic clk,
    simple_bus.slave bus_if,
    output logic [15:0] data_out
);
    always_ff @( posedge clk ) begin 
        if (bus_if.valid)
            data_out <= bus_if.data;
    end
        
endmodule


