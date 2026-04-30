`default_nettype none   


//-- Cronometro de 4 digitos (no es tiempo exacto)
module chrono (
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

//─────────────────────────────────────────────
//──  CONVESOR DE BCD A 7 SEGMENTOS
//─────────────────────────────────────────────
wire [3:0] bcd;
wire [7:0] disp7;
bcd_to_7seg U_conv0 (
    .bcd_in(bcd),
    .disp_out(disp7)
);


//──────────────────────
//──  PRESCALER 
//──────────────────────
//-- Temporizacion DISPLAY
wire [1:0] gen;
prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);

//------- Perscaler para el cronometro
wire timer;
prescaler #(.N(23)
) u_press1 (
    .clk(clk),
    .signal(),  
    .done(timer)
);

//─────────────────────────
//──       MAIN
//─────────────────────────

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

