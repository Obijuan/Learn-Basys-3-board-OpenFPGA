`default_nettype none   
`include "buttons.vh" 


module vga_led_btn (
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

//────────────────────────────────────────────
//── PULSADORES
//────────────────────────────────────────────
//-- Se usa el pulsador UP para encender el 
//-- MONSTER-LED (la pantalla VGA se pone verde)
wire btn_up;
wire btn_up_press;
normal_button u_btn0 (
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),  
    .btn_state(btn_up),
    .tic_press(btn_up_press),
    .tic_release(),
);

//──────────────────────────────────
//──   VGA VERDE
//──────────────────────────────────
wire vga_clk;
wire draw;
wire refresh;
wire video;
vga_sync u_vga_sync (
    .clk(clk),
    .vga_clk(vga_clk),

    .px(),
    .py(),
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

//-- Intensidad del verde (0-15)
localparam [3:0] INTENSIDAD = 4'h7;
localparam [3:0] APAGADO = 4'h0;

//--- Señal de video para el color verde
//-- Solo hay señal en la zona visible de la VGA
//-- de lo contrario NO hya que enviar señal
assign vga_green = (video & draw) ? INTENSIDAD : APAGADO;

//-- Biestable con el estado del MONSTER-LED
reg monster_led;
always @(posedge clk) begin

    //-- Cuando se termina de pintar el frame,
    //-- ya se puede capturar el nuevo valor
    //-- del pulsador
    //-- Es para evitar que cambie de valor
    //-- en mitad del frame, lo que provoca un efecto
    //-- visual extraño
    if (refresh)
      monster_led <= btn_up;
end

//-- Visualizar el monsterled
assign video = monster_led;

//-- TEST
assign leds[15] = 1;
assign leds[14] = btn_up;

endmodule

