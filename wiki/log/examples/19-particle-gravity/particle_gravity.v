`default_nettype none   


module particle_gravity (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Constantes para pulsadores
localparam CENTER = 0;
localparam UP = 1;
localparam DOWN = 4;
localparam LEFT = 2;
localparam RIGHT = 3;

//-- Valores iniciales
localparam POS_INI = 0;
localparam VEL_INI = 9'd22;

//--------------------------------------------
//-- PULSADORES
//--------------------------------------------
//-- Se usa el pulsador UP para comenzar la simulacion
wire butt_up;
wire butt_up_press;
button_input u_btn_up (
    .clk(clk),
    .button_pin_in(buttons[UP]),  //-- Pulsador arriba
    .button_state_out(butt_up),
    .press_out(butt_up_press),
    .release_out()  //-- Sin conectar
);

//-- Se usa el pulsador IZQ para generar tics de simulacion
//-- manuales
wire butt_izq;
wire butt_izq_press;
button_input u_btn_izq (
    .clk(clk),
    .button_pin_in(buttons[LEFT]),  //-- Pulsador arriba
    .button_state_out(butt_izq),
    .press_out(butt_izq_press),
    .release_out()  //-- Sin conectar
);

//-- Se usa el pulsador DOWN para el reset
wire butt_down;;
button_input u_btn_down (
    .clk(clk),
    .button_pin_in(buttons[DOWN]),
    .button_state_out(butt_down),
    .press_out(),   //-- Sin conectar
    .release_out()  //-- Sin conectar
);

//------- RESET
//-- Señal de reset
wire reset; 
assign reset = butt_down;

//----------------------------------------
//-- TEMPORIZADOR DE TIEMPO DE SIMULACION
//----------------------------------------
localparam TBIT = 22;
reg [TBIT:0] sim_time = 0;
always @(posedge clk) begin
    if (reset || step)
      sim_time <= 0;
    else begin
        sim_time <= sim_time + 1;
    end
end

//-- Señal de paso de simulacion 
wire step;
assign step = sim_time[TBIT];  //butt_izq_press;  //-- Manual

//-- Señal de comienzo
wire start;
assign start = butt_up;

//-- Señal de contacto con el suelo
wire is_ground;


//---------------------------------------
//-- AUTOMATA
//---------------------------------------
//-- Estados
reg E0 = 1;  //-- REPOSO
reg E1 = 0;  //-- MOVIMIENTO

//-- Señal de actualizacion al siguiente estado
wire next;

//-- Evolucion del estado
always @(posedge clk) begin
    if (reset) begin
        E0 <= 1;
        E1 <= 0;
    end
    else if (next) begin
        E0 <= E1;
        E1 <= E0;
    end
end

//-- Transiciones
wire T01;
assign T01 = E0 && start && step;

wire T10;
assign T10 = E1 && is_ground && step;

//-- Señal de actualizacion de estado
assign next = T01 || T10;




//-- Detectar colision con suelo!
assign is_ground = pos[8] || pos==8'h0;

//--------------------------------------------
//-- Posicion de la particula
//-- Usamos 8 bits
//---------------------------------------------
reg [8:0] pos = POS_INI;
always @(posedge clk) begin
    if (reset || T10) 
        pos <= POS_INI;
    
    else if ((E1 && step) || T01)
        pos <= pos + vel;
end

//-- Velocidad de la particula
reg [8:0] vel = VEL_INI;
always @(posedge clk) begin
    if (reset || T10)
        vel <= VEL_INI;
    else if ((E1 && step) || T01)
        vel <= vel + accel;
end 

//-- Gravedad. Es una constante
wire [8:0] accel = 9'h1FF; //(-1)

//-- Convertir la posicion a coordenadas de pantalla
//-- Decodificador de 4 a 16
//-- Técnica de subpixel. Solo se usan los 4 bits de mayor peso
//-- de la posicion
wire [15:0] screen;
assign screen = 1 << pos[7:4];

//-- Mostrar la particula en los leds!
assign leds[15:0] = screen;

endmodule

