`default_nettype none   


//-- Mostrar un numero hexadecimal de 4 digitos
//-- en los 4 displays de menor peso
//-- El numero se obtiene de los switches
module display_hex4 (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds,
    output wire [7:0] segments,
    output wire [3:0] display_sel
);

//─────────────────────────────────
//──   DISPLAY DE 7 SEGMENTOS
//─────────────────────────────────
//-- Señales para el usuario, con logica positiva
wire [7:0] seg;      //-- Segmentos a encender
wire [1:0] disp_sel; //-- Seleccion del display (0-3)

display7seg u_disp7 (
    .seg_in(seg),
    .sel_in(disp_sel),

    //-- Conexion al display físico
    .segments_out(segments),
    .display_sel_out(display_sel)
);

//──────────────────────────────────
//── CONVERSORES BCD-7SEG
//──────────────────────────────────
wire [3:0] num;
bcd_to_7seg u_conv_bcd2seg (
    .bcd_in(num),
    .disp_out(seg)
);

//──────────────────────
//──  PRESCALER 
//──────────────────────
wire [1:0] gen;

prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);


//─────────────────────────
//──       MAIN
//─────────────────────────

//-- Seleccionar display
assign disp_sel = gen;

//-- Multiplexar los digitos BCD que vienen
//-- de los switches
assign num = gen==2'b00 ? switches[3:0] : 
             gen==2'b01 ? switches[7:4] : 
             gen==2'b10 ? switches[11:8] :
             gen==2'b11 ? switches[15:12] : 
             8'h0;

endmodule

