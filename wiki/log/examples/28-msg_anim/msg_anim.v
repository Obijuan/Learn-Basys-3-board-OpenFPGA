`default_nettype none   


//-- Se muestra el mensaje "HOLA" en el display de 7 segmentos
//-- Con los pulsadores izquierda-derecha se mueve manualmente
module msg_anim (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds,
    output wire [7:0] segments,
    output wire [3:0] display_sel
);

//------ DISPLAY DE 7 SEGMENTOS
//-- Señales para el usuario, con logica positiva
wire [1:0] disp_sel; //-- Seleccion del display (0-3)
wire [7:0] seg;      //-- Segmentos a encender

//-- Mapear las señales del usuario a las reales
//-- Conexion con el display
assign segments = ~seg;

//-- Decodificador de 2 a 4, negado
assign display_sel = ~(1 << disp_sel);

//----------------------------
//-- PULSADOR
//----------------------------
//-- Constantes para pulsadores
localparam CENTER = 0;
localparam UP = 1;
localparam DOWN = 4;
localparam LEFT = 2;
localparam RIGHT = 3;

wire butt_left;
wire butt_left_press;
button_input u_btn0 (
    .clk(clk),
    .button_pin_in(buttons[LEFT]), 
    .button_state_out(butt_left),
    .press_out(butt_left_press),
    .release_out()  //-- Sin conectar
);

wire butt_right;
wire butt_right_press;
button_input u_btn1 (
    .clk(clk),
    .button_pin_in(buttons[RIGHT]), 
    .button_state_out(butt_right),
    .press_out(butt_right_press),
    .release_out()  //-- Sin conectar
);

//----------------------------
//-- PRESCALER
//----------------------------

prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);

//-- Generador de señal cuadrada
wire [1:0] gen;

//-------------------------
//--       MAIN
//-------------------------

//-- Seleccionar display
assign disp_sel = gen;

//-- Funcion para obtener el codigo de cada
//-- letra, a partir de su codigo ASCII
function [4:0] letra (
    input [7:0] car
);

    letra = car-65;
endfunction

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

//-- Generador de letras
wire [7:0] letter;
wire [4:0] code;
disp_letter u_disp_letter0 (
    .code_in(code),
    .letter_out(letter)
);


//-- Contador de limites, para que la palabra NO se
//-- salga de su zona
reg [3:0] cnt_zone = 4;

//--- Registro de desplazamiento de las letras
always @(posedge clk) begin
    if (butt_left_press && cnt_zone < 8) begin
        msg <= {msg[54:0], ESP}; 
        cnt_zone <= cnt_zone + 1;
    end
    else if (butt_right_press && cnt_zone > 0) begin
        msg <= {ESP,msg[59:5]};
        cnt_zone <= cnt_zone - 1;
    end
end

endmodule

