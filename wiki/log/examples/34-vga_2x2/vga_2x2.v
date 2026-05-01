`default_nettype none   
`include "buttons.vh" 


module vga_2x2 (
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
wire btn_up;
wire btn_up_press;
normal_button u_btn0 (
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),  
    .btn_state(btn_up),
    .tic_press(btn_up_press),
    .tic_release(),
);


//────────────────────────────────────────────
//── DIBUJAR
//────────────────────────────────────────────
//-- Objeto a dibujar:  Dos regiones cuadradas
wire cuad0;
wire cuad1;
assign cuad0 = (py < 240) && (px < 320);
assign cuad1 = (py >= 240) && (px >= 320);

//-- Dibujar la union de ambas regiones
wire object;
assign object = cuad0 || cuad1;
                
//-- Valor estable a pintar. Se captura el estado del pulsador
//-- Cuando se ha terminado de renderizar el frame
//-- Actual
reg stable;
always @(posedge clk) begin
    if (refresh)
        stable <= btn_up;
end

//-- Señal que se envía. El objeto o su negado en funcion
//-- del estado del pulsador
wire video;
assign video = (stable) ? ~object : object;

endmodule

