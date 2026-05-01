`default_nettype none   

//-- Bola que rebota en las paredes
module vga_bola (
    input wire clk, 

    //-- BOTONES
    input wire [4:0] buttons,

    //-- SWITCHES
    input wire [15:0] switches,

    //-- LEDS 
    output wire [15:0] leds,

    //-- DIPLAY 7 SEGMENTOS
    output wire [7:0] segments,
    output wire [3:0] display_sel,

    //-- VGA
    output wire [3:0] vga_red,
    output wire [3:0] vga_blue,
    output wire [3:0] vga_green,
    output wire       vga_hsync,
    output wire       vga_vsync
);

//──────────────────────────────────
//──   VGA VERDE
//──────────────────────────────────
wire vga_clk;
wire draw;
wire refresh;
wire video;
//-- Coordenadas del pixel
wire [9:0] px;
wire [8:0] py;
vga_sync u_vga_sync (
    .clk(clk),
    .vga_clk(vga_clk),

    .px(px),
    .py(py),
    .draw(draw),
    .refresh(refresh),

    .vga_red(vga_red),
    .vga_blue(vga_blue),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
);

//──────────────────────────────────────────
//── GENERACION DE LA SEÑAL DE VIDEO VERDE
//──────────────────────────────────────────
//--- Señal de video para el color verde
//-- Solo hay señal en la zona visible de la VGA
//-- de lo contrario NO hya que enviar señal
assign vga_green = (video & draw) ? 4'h7 : 4'h0;

//────────────────────────────────────────────
//── DIBUJAR
//────────────────────────────────────────────

//-- Anchura x del personaje
localparam HERO_WX = 10;
localparam HERO_WY = 10;

//-- Velocidades iniciales
localparam HERO_VX = 9'd1;
localparam HERO_VY = 9'd1;

//-- Posiciones iniciales
localparam HERO_X = 50;
localparam HERO_Y = 40;

//-- Posicion del suelo y la pared derecha
localparam PARED_X = 200;
localparam SUELO_Y = 80;

//-- Objeto a dibujar:  Un personaje, que es un cuadrado
wire hero;
reg [9:0] hero_x = HERO_X;
reg [8:0] hero_y = HERO_Y;
assign hero = (px >= hero_x) && (px <= hero_x + HERO_WX) &&
              (py >= hero_y) && (py <= hero_y + HERO_WY); 

//-- Suelo
wire suelo;
assign suelo = (py >= SUELO_Y);

//-- pared
wire pared;
assign pared = (px >= PARED_X);

//-- Dibujar personaje
wire video;
assign video = hero || suelo || pared;
                
//-- Limite derecho
wire right_end;
wire left_end;
assign right_end = (hero_x >= PARED_X - HERO_WX);
assign left_end = (hero_x <= 2);

//-- Limites verticales
wire top_end;
wire bottom_end;
assign top_end = (hero_y == 10);
assign bottom_end = (hero_y == SUELO_Y - HERO_WY);

//-----------------------------------------
//-- VELOCIDAD
//-----------------------------------------
reg [9:0] hero_vx = HERO_VX;
reg [8:0] hero_vy = HERO_VY;

always @(posedge clk) begin

    //-- Actualizar velocidad x
    if (left_end && (hero_vx==-HERO_VX))
        hero_vx <= HERO_VX; 
    else if (right_end && (hero_vx==HERO_VX))
        hero_vx <= -HERO_VX;

    //-- Actualizar velocidad y
    if (top_end && (hero_vy==-HERO_VY))
        hero_vy <= HERO_VY;
    else if (bottom_end && hero_vy==HERO_VY)
            hero_vy <= -HERO_VY;
end

//-------------------------------------------
//-- POSICION
//-------------------------------------------

always @(posedge clk) begin
    if (refresh) begin
        hero_x <= (hero_x + hero_vx);
        hero_y <= (hero_y + hero_vy);
    end
end


//-- TEST: Mostrar la posición en los LEDs
assign leds[15:6] = hero_x;


endmodule

