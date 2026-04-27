`default_nettype none   


//-- Animacion del mensaje "HOLA". Se mueve automaticamente
//-- de derecha a izquierda
module chrono (
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

//-- Perscaler para la cuenta
prescaler #(.N(23)
) u_press1 (
    .clk(clk),
    .signal(), //-- No usado  
    .done(timer)
);

//-- Generador de señal cuadrada
wire [1:0] gen;

//-- Señal de temporizacion
wire timer;

//-------------------------------
//--  CONVERSOR BCD-7SEG
//-------------------------------
wire [7:0] disp7;
wire [3:0] bcd;
bcd_to_7seg u_con0 (
    .bcd_in(bcd),
    .disp_out(disp7)
);

//-------------------------
//--       MAIN
//-------------------------

//-- Seleccionar display
assign disp_sel = gen;

//-- Mostrar los numeros en el display
assign seg = disp7;

//-- Letras a sacar en el display
assign bcd =  gen==2'b11 ? bcd3 :
              gen==2'b10 ? bcd2 :
              gen==2'b01 ? bcd1 :
              gen==2'b00 ? bcd0 :
              4'h0;

//-- Digito BCD0
reg [3:0] bcd0 = 0;
wire bcd0_max;
always @(posedge clk) begin
    if (timer) begin
        if (bcd0_max)
          bcd0 <= 0;
        else
          bcd0 <= bcd0 + 1;
    end
end

//-- Valor maximo alcanzado en bcd0
assign bcd0_max = (bcd0 == 9);

//----- Digito bcd1
reg [3:0] bcd1 = 0;
wire bcd1_max;
always @(posedge clk) begin
    if (timer & bcd0_max) begin
        if (bcd1_max)
          bcd1 <= 0;
        else
          bcd1 <= bcd1 + 1;
    end
end

//-- Valor maximo alcanzado en bcd1
assign bcd1_max = (bcd1 == 9);


//----- Digito BCD 2
reg [3:0] bcd2 = 0;
wire bcd2_max;
always @(posedge clk) begin
    if (timer & bcd1_max & bcd0_max) begin
        if (bcd2_max)
          bcd2 <= 0;
        else
          bcd2 <= bcd2 + 1;
    end
end

//-- Valor maximo alcanzado en bcd2
assign bcd2_max = (bcd2 == 9);

//----- Digito BCD 3
reg [3:0] bcd3 = 0;
wire bcd3_max;
always @(posedge clk) begin
    if (timer && bcd2_max && bcd1_max && bcd0_max) begin
        if (bcd3_max)
          bcd3 <= 0;
        else
          bcd3 <= bcd3 + 1;
    end
end

//-- Valor maximo alcanzado en bcd3
assign bcd3_max = (bcd3 == 9);

endmodule

