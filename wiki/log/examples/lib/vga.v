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
    output wire vga_clk

);

//──────────────────────────────────
//── RELOJ de la VGA: 25Mhz
//──────────────────────────────────
reg [1:0] vga_prescaler = 0;
always @(posedge clk) begin
    vga_prescaler <= vga_prescaler + 1;
end

//-- Este es mi pixel clock
assign vga_clk = vga_prescaler[1];


endmodule