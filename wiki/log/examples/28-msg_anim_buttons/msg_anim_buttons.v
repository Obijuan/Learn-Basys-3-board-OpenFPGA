`default_nettype none   
`include "buttons.vh" 


//-- Se muestra el mensaje "HOLA" en el display de 7 segmentos
//-- Con los pulsadores izquierda-derecha se mueve manualmente
module msg_anim_buttons (
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
    .segments_out(segments),
    .display_sel_out(display_sel)
);

//─────────────────────────────
//──  GENERADOR DE LETRAS
//─────────────────────────────
wire [7:0] letter;
wire [4:0] code;
disp_letter u_disp_letter0 (
    .code_in(code),
    .letter_out(letter)
);

//────────────────────────────────────────────
//── PULSADORES
//────────────────────────────────────────────
//-- Se usa el pulsador UP para comenzar la simulacion
wire btn_left;
wire btn_left_press;
normal_button u_btn0 (
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),  
    .btn_state(btn_left),
    .tic_press(btn_left_press),
    .tic_release(),
);

wire btn_right;
wire btn_right_press;
normal_button u_btn1 (
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),  
    .btn_state(btn_right),
    .tic_press(btn_right_press),
    .tic_release(),
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

//-- Funcion para obtener el codigo de cada
//-- letra, a partir de su codigo ASCII
function [4:0] letra (
    input [7:0] car
);

    letra = car-65;
endfunction

//-- Espacio
localparam ESP = 5'd26;

//-- Registro con las letras a mostrar en el display
reg [59:0] msg = { ESP, ESP, ESP, ESP,
                   letra("H"), letra("O"), letra("L"), letra("A"),
                   ESP, ESP, ESP, ESP};

//-- Mostrar las letras en el display
assign seg = letter;

//-- Letras a sacar en el display
assign code = gen==2'b11 ? msg[39:35] :
              gen==2'b10 ? msg[34:30] :
              gen==2'b01 ? msg[29:25] :
              gen==2'b00 ? msg[24:20] :
              8'h0;

//-- Contador de limites, para que la palabra NO se
//-- salga de su zona
reg [3:0] cnt_zone = 4;

//--- Registro de desplazamiento de las letras
always @(posedge clk) begin
    if (btn_left_press && cnt_zone < 8) begin
        msg <= {msg[54:0], ESP}; 
        cnt_zone <= cnt_zone + 1;
    end
    else if (btn_right_press && cnt_zone > 0) begin
        msg <= {ESP,msg[59:5]};
        cnt_zone <= cnt_zone - 1;
    end
end

endmodule

