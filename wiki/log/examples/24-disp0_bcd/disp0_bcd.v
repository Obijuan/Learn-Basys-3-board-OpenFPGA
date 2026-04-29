`default_nettype none   
`include "buttons.vh"   


//-- Mostrar un digito BCD en el display 7 segmentos
//-- Con el botón de UP se incrementa el numero que se muestra
//-- en el display 0
module disp0_bcd (
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
//── CONVERSOR BCD-7SEG
//──────────────────────────────────
bcd_to_7seg u_conv_bcd2seg (
    .bcd_in(num),
    .disp_out(seg)
);

//────────────────────────────────────────────
//── PULSADORES
//────────────────────────────────────────────
wire btn_up;
wire btn_up_press;

normal_button u_btn_up(
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),  
    .btn_state(btn_up),
    .tic_press(btn_up_press),
    .tic_release(), 
);


//─────────────────────────────────
//──   MAIN
//─────────────────────────────────

//-- Contador BCD
reg [3:0] num = 0;
always @(posedge clk) begin
    if (btn_up_press)
        num <= num + 1; 
end

//-- Seleccionar display
assign disp_sel = 0;

endmodule

