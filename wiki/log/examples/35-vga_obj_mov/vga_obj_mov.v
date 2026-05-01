`default_nettype none   
`include "buttons.vh" 

module vga_obj_mov (
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


//────────────────────────────────────────────
//── DIBUJAR
//────────────────────────────────────────────

//-- Anchura x del personaje
localparam HERO_WX = 10;

//-- Velocidad x del personaje
localparam HERO_VX = 10;

//-- Objeto a dibujar:  Un personaje, que es una barra vertical
wire hero;

//-- Posicion de la barra
reg [9:0] hero_x = 40;

//-- Dibujo de la barra: se pintan los pixeles que se encuentra
//-- en el intervalo [hero_x, hero_x + HERO_WX]
assign hero = (px >= hero_x) && (px <= hero_x + HERO_WX); 

//-- Dibujar personaje
wire video;
assign video = hero;
                
//-- Limites derecho de izquierdo
wire right_end;
wire left_end;
assign right_end = (hero_x >= 639-HERO_WX);
assign left_end = (hero_x == 0);

//-- Incremento de la coordenada x, si está dentro
//-- de los límites
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

//-- TEST: Mostrar la posición en los LEDs
assign leds[15:6] = hero_x;

endmodule

