`default_nettype none   


//-- Animacion del mensaje "HOLA". Se mueve automaticamente
//-- de derecha a izquierda
module msg_anim2 (
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
//-- PRESCALERS
//----------------------------
//-- Para los displays de 7 segmentos
prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);

//-- Perscaler para la animacion
prescaler #(.N(26)
) u_press1 (
    .clk(clk),
    .signal(), //-- No usado  
    .done(shift)
);

//-- Generador de señal cuadrada
wire [1:0] gen;

//-- Señal de movimiento para la animacion
wire shift;

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
    if (init) begin
        msg <= { ESP, ESP, ESP, ESP,
                   letra("H"), letra("O"), letra("L"), letra("A"),
                   ESP, ESP, ESP, ESP};
        cnt_zone <= 4;
    end
    else if (shift) begin
        msg <= {msg[54:0], ESP}; 
        cnt_zone <= cnt_zone + 1;
    end
end

//-- Reinicio de la secuencia
wire init;
assign init = (cnt_zone == 11 && shift);

endmodule

