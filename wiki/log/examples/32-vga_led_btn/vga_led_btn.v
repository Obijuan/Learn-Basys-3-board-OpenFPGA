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
vga_sync u_vga_sync (
    .clk(clk),
    .vga_clk(vga_clk),

    .col_(col),
    .row_(row),

    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
);

//-- TEMPORAL!!
wire [9:0] col;
wire [8:0] row;

//──────────────────────────────────
//── PARAMETROS DE LA VGA
//──────────────────────────────────
localparam LINE_WIDTH = 640;
localparam FRAME_HEIGHT = 480;


//───────────────────────────────────────
//── ASIGNACION DE SEÑALES A LA VGA
//───────────────────────────────────────
//-- Intensidad del verde (0-15)
localparam INTENSIDAD = 4'h7;
localparam APAGADO = 4'h0;

//-- Solo hay que asignar color si estamos en la zona visible
//-- De lo contrario NO se vera nada en la VGA
//-- draw=1 cuando estamos en la zona visible y 0 en caso contrario
wire draw;
assign draw = (col < LINE_WIDTH) && (row < FRAME_HEIGHT);

//-- Fin del frame
wire end_frame;
assign end_frame = (row > FRAME_HEIGHT);

//-- Señal de refresco: se ha salido de la zona visible, por tanto
//-- se puede colocar un nuevo valor en la señal de video para
//-- el siguiente frame
wire refresh;
posedge_detector u_posedge0 (
    .clk(clk),
    .value(end_frame),
    .tic(refresh)
);


//--- Establecer colores
assign vga_red   = 4'h0;  //-- Deshabilitado
assign vga_blue  = 4'h0;  //-- Deshabilitado
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
wire video;
assign video = monster_led;

//-- TEST
assign leds[15] = 1;
assign leds[14] = btn_up;

endmodule

