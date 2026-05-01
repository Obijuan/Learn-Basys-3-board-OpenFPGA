`default_nettype none   
`include "buttons.vh" 


//-- Pintar cada mitad de la pantalla de un color: Verde - Negro
//-- Con el botón UP se niega. El efecto es que se mueve la barra vertical
module vga_2x1 (
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
//-- Objeto a dibujar: Se ponen en verde el conjunto
//-- de pixeles cuyas coordenadas x están en la parte izquierda
//-- y el resto negros
wire object;
assign object = px < 320;

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
assign video = (stable) ? object : ~object;

endmodule

