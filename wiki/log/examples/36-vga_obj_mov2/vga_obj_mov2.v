`default_nettype none   
`include "buttons.vh" 

module vga_obj_mov2 (
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
//── PULSADORES
//────────────────────────────────────────────
wire btn_right;
wire btn_right_press;
normal_button u_btn0 (
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),  
    .btn_state(btn_right),
    .tic_press(btn_right_press),
    .tic_release(),
);

wire btn_left;
wire btn_left_press;
normal_button u_btn1 (
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),  
    .btn_state(btn_left),
    .tic_press(btn_left_press),
    .tic_release(),
);

wire btn_up;
wire btn_up_press;
normal_button u_btn2 (
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),  
    .btn_state(btn_up),
    .tic_press(btn_up_press),
    .tic_release(),
);

wire btn_down;
wire btn_down_press;
normal_button u_btn3 (
    .clk(clk),
    .btn_pin(buttons[BTN_DOWN]),  
    .btn_state(btn_down),
    .tic_press(btn_down_press),
    .tic_release(),
);


//────────────────────────────────────────────
//── DIBUJAR
//────────────────────────────────────────────

//-- Dimensiones del personaje
localparam HERO_WX = 10;
localparam HERO_WY = 10;

//-- Velocidad del personaje
localparam HERO_VX = 5;
localparam HERO_VY = 5;

//-- Coordenadas del personaje
reg [9:0] hero_x = 40;
reg [8:0] hero_y = 40;

//-- Objeto a dibujar:  Un personaje, que es un cuadrado
wire hero;
assign hero = (px >= hero_x) && (px <= hero_x + HERO_WX) &&
              (py >= hero_y) && (py <= hero_y + HERO_WY); 

//-- Dibujar personaje
wire video;
assign video = hero;
                
//-- Limites derecho de izquierdo
wire right_end;
wire left_end;
assign right_end = (hero_x >= 639-HERO_WX);
assign left_end = (hero_x == 0);

//-- Limites superior e inferior
wire top_end;
wire bottom_end;
assign top_end = (hero_y == 0);
assign bottom_end = (hero_y >= 480-HERO_WY);

//-- Incremento de la coordenada x
always @(posedge clk) begin
    if (btn_right && refresh) begin
        if (!right_end)
            hero_x <= hero_x + HERO_VX;
    end
    else if (btn_left && refresh) begin
        if (!left_end)
            hero_x <= hero_x - HERO_VX;
    end
end

//-- Cambio en la coordenada y
always @(posedge clk) begin
    if (btn_up && refresh) begin
        if (!top_end)
            hero_y <= hero_y - HERO_VY;
    end
    else if (btn_down && refresh) begin
        if (!bottom_end)
            hero_y <= hero_y + HERO_VY;
    end
end


//-- TEST: Mostrar la posición en los LEDs
assign leds[15:6] = hero_x;

endmodule

