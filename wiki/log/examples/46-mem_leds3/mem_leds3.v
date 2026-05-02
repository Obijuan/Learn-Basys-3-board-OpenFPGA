`default_nettype none
`include "buttons.vh" 


//-- Mostrar contenido de la memoria en los leds
module mem_leds3 (
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
    output wire       vga_vsync,

    //-- UART
    input wire uart_rx_async,
    output wire uart_tx
);
    
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

wire btn_down;
wire btn_down_press;
normal_button u_btn1 (
    .clk(clk),
    .btn_pin(buttons[BTN_DOWN]),  
    .btn_state(btn_down),
    .tic_press(btn_down_press),
    .tic_release(),
);

wire btn_left;
wire btn_left_press;
normal_button u_btn2 (
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),  
    .btn_state(btn_left),
    .tic_press(btn_left_press),
    .tic_release(),
);

wire btn_right;
wire btn_right_press;
normal_button u_btn3 (
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),  
    .btn_state(btn_right),
    .tic_press(btn_right_press),
    .tic_release(),
);

//---- Memoria
reg [9:0] addr = 0;
wire [31:0] data;
memory3 u_mem0 (
    .clk(clk),
    .addr(addr),
    .data_in(31'h0),
    .wr(1'b0),
    .data_out(data)
);

//-- Acceso a la memoria
//-- Con el pulsador se incrementa la direccion
always @(posedge clk) begin
    if (btn_up_press)
        addr <= addr + 1;  
    else if (btn_down_press)
        addr <= addr - 1;  
end

//-- Biestable para mostrar la parte alto obaja del dato de memoria
//-- en los LEDs
reg show_hi = 0;
always @(posedge clk) begin
    if (btn_left_press)
        show_hi <= 1;
    else if (btn_right_press)
        show_hi <= 0;
end


//-- Ver el contenido actual en los LEDs
assign leds = (show_hi) ? data[31:16] : data[15:0];


//────────────────────────────────────────────
//──  ELIMINAR WARNINGS
//────────────────────────────────────────────
//-- Conexion de las señales de salida NO USADAS
//-- para eliminar los warnings
assign uart_tx = 1'b1;

//-- VGA
assign vga_red = 4'h0;
assign vga_blue = 4'h0;
assign vga_green = 4'h0;
assign vga_hsync = 0;
assign vga_vsync = 0;

//-- DISPLAY 7seg
assign segments = 8'hF;
assign display_sel = 4'hF;

endmodule
