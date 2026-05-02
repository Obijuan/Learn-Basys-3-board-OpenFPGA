//-- Modulo leds_port.sv
//-- Puerto de salida de 16 leds

module leds_port(
    input logic clk,
    input logic rst,

    input logic [15:0] data_in,
    input logic wen,

    output logic [15:0] data_out
);

    //-- Registro para almacenar el valor de los leds
    always_ff @(posedge clk) begin
        if (rst) begin
            data_out <= 16'b0;
        end else if (wen) begin
            data_out <= data_in;
        end
    end

endmodule
