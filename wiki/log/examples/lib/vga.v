//══════════════════════════════════════════════════════════
//─            MODULOS PARA LA VGA
//══════════════════════════════════════════════════════════

//─────────────────────────────────────
//──  VGA-SYNC
//─────────────────────────────────────
module vga_sync (

    //-- Reloj del sistema
    input wire clk,

    //-- Reloj para la VGA (25Mhz). Pixel-clock
    output wire vga_clk,

    output wire [9:0] col_, 
    output wire [8:0] row_,

    //-- Señales de la VGA
    output wire vga_hsync

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

//──────────────────────────────────
//── RELOJ de la VGA: 25Mhz
//──────────────────────────────────
reg [1:0] vga_prescaler = 0;
always @(posedge clk) begin
    vga_prescaler <= vga_prescaler + 1;
end

//-- Este es mi pixel clock
assign vga_clk = vga_prescaler[1];

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

//-- Enviar las señales de sincronizacion a la VGA
assign vga_hsync = hsync;


//-- TEMPORAL!!
assign col_ = col;
assign row_ = row;

endmodule
