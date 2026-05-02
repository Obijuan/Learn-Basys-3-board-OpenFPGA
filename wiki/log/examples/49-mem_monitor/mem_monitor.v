`default_nettype none
`include "buttons.vh" 


//-- Mostrar contenido de la memoria en los 7 segmentos y
//-- los LEDs
module mem_monitor (
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

wire btn_center;
wire btn_center_press;
normal_button u_btn4 (
    .clk(clk),
    .btn_pin(buttons[BTN_CENTER]),  
    .btn_state(btn_center),
    .tic_press(btn_center_press),
    .tic_release(),
);

//─────────────────────────────────
//──   DISPLAY DE 7 SEGMENTOS
//─────────────────────────────────
//-- Señales para el usuario, con logica positiva
wire [7:0] seg;      //-- Segmentos a encender
wire [1:0] disp_sel; //-- Seleccion del display (0-3)

display7seg u_disp7 (
    .seg_in(seg),
    .sel_in(disp_sel),

    //-- Conexion al display físico
    .segments_out(segments),
    .display_sel_out(display_sel)
);

//──────────────────────────────────
//── CONVERSORES BCD-7SEG
//──────────────────────────────────
wire [3:0] num;
bcd_to_7seg u_conv_bcd2seg (
    .bcd_in(num),
    .disp_out(seg)
);

//─────────────────────────────────────
//──  PRESCALER para Display 7-seg
//─────────────────────────────────────
wire [1:0] gen;

prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);


//─────────────────────────
//──    MEMORIA
//─────────────────────────
reg [9:0] addr = 0;
wire [31:0] data;
memory4 u_mem0 (
    .clk(clk),
    .addr(addr),
    .data_in(31'h0),
    .wr(1'b0),
    .data_out(data)
);

//─────────────────────────
//──    MAIN
//─────────────────────────

//-- Acceso a la memoria
//-- Con el pulsador se incrementa la direccion
always @(posedge clk) begin

    //-- Incrementar direccion actual
    if (btn_up_press)
        addr <= addr + 1;  

    //-- Decrementar direccion actual
    else if (btn_down_press)
        addr <= addr - 1;  

    //-- Leer nueva direccion de los switches
    else if (btn_center_press)
        addr <= {16'h0, switches};
end

//-- Biestable para mostrar la parte alta o baja del dato de memoria
//-- en los LEDs
reg show_hi = 0;
always @(posedge clk) begin
    if (btn_left_press)
        show_hi <= 1;
    else if (btn_right_press)
        show_hi <= 0;
end


//-- Obtener los 16-bits a visualizar
wire [15:0] data_show1;
wire [15:0] data_show2;
assign data_show1 = (show_hi) ? data[31:16] : data[15:0];
assign data_show2 = (show_hi) ? data[15:0] : data[31:16];

//-- Ver el contenido actual en los LEDs
assign leds = data_show2;

//-- Seleccionar display
assign disp_sel = gen;

//-- Multiplexar los digitos BCD
assign num = gen==2'b00 ? data_show1[3:0] : 
             gen==2'b01 ? data_show1[7:4] : 
             gen==2'b10 ? data_show1[11:8] :
             gen==2'b11 ? data_show1[15:12] : 
             8'h0;


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

endmodule
