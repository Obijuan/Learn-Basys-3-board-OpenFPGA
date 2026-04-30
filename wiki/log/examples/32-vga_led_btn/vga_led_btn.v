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
//──   VGA
//──────────────────────────────────
wire vga_clk;
wire draw;
wire refresh;
wire video;
vga_sync u_vga_sync (
    .clk(clk),
    .vga_clk(vga_clk),

    .col_(),
    .row_(),
    .draw(draw),
    .refresh(refresh),

    .vga_red(vga_red),
    .vga_blue(vga_blue),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
);

//-- Intensidad del verde (0-15)
localparam INTENSIDAD = 4'h7;
localparam APAGADO = 4'h0;

//--- Establecer colores
assign vga_green = (video & draw) ? INTENSIDAD : APAGADO;

//──────────────────────────────────────────
//── GENERACION DE LA SEÑAL DE VIDEO
//──────────────────────────────────────────

//-- Biestable con el estado del MONSTER-LED
reg monster_led;
always @(posedge clk) begin

    //-- Caputrar el nuevo valor, del pulsador
    if (refresh)
      monster_led <= btn_up;
end

//-- Visualizar el monsterled
assign video = monster_led;

//-- TEST
assign leds[15] = 1;
assign leds[14] = btn_up;

endmodule

