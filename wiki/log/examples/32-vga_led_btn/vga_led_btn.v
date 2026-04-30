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
    .vga_clk(vga_clk)
);


//──────────────────────────────────
//── PARAMETROS DE LA VGA
//──────────────────────────────────
localparam LINE_WIDTH = 640;
localparam LINE_FRONT_PORCH = 16;
localparam LINE_SYNC_PULSE = 96;
localparam LINE_BACK_PORCH = 48;

localparam FRAME_HEIGHT = 480;
localparam FRAME_FRONT_PORCH = 10;
localparam FRAME_SYNC_PULSE = 2;
localparam FRAME_BACK_PORCH = 29; //33

//───────────────────────────────────────
//── SINCRONIZACION
//───────────────────────────────────────
//-- Hay 800 pixeles horizontales en total. De todos ellos solo hay 
//-- 680 visibles. 800 --> necesitamos 10 bits para representarlo
//--  --> Las columnas se representan con 10 bits
reg [9:0] col;  //-- Desde la 0 hasta la 799 (800 en total)

//-- Hay 521 lineas verticales en total, de las cuales solo 480 son visibles
//-- Necesitamos 9 bits para su representacion
reg [8:0] row;  //-- Desde 0 hasta 520 (521 en total)
always @(posedge vga_clk) begin
    if (col < 799) begin
        col <= col + 1;
    end
    else begin
        col <= 0;

        //-- Incrementar las filas
        if (row < 520) begin
            row <= row + 1;
        end
        else begin
            row <= 0;
        end
    end
end

//── Contador de sincronizacion horizontal
reg hsync;
always @(posedge vga_clk) begin
    if (col < LINE_WIDTH + LINE_FRONT_PORCH) begin
        hsync <= 1;
    end
    else if (col < LINE_WIDTH + LINE_FRONT_PORCH + LINE_SYNC_PULSE) begin
        hsync <= 0;
    end

    //-- Back porch
    else begin
        hsync <= 1;
    end
end

//── Contador de sincronizacion vertical
reg vsync;
always @(posedge vga_clk) begin
    if (row < FRAME_HEIGHT + FRAME_FRONT_PORCH) begin
        vsync <= 1;
    end
    else if (row < FRAME_HEIGHT + FRAME_FRONT_PORCH + FRAME_SYNC_PULSE) begin
        vsync <= 0;
    end
    else begin
        vsync <= 1;
    end
end


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

//-- Enviar las señales de sincronizacion a la VGA
assign vga_hsync = hsync;
assign vga_vsync = vsync;

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

