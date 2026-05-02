`default_nettype none
`include "buttons.vh" 


//-- Imprimir la cadena HOLA
module tx_str (
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
    output wire uart_rx_async,
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

//────────────────────────────
//──  PRESCALER
//────────────────────────────
wire timer;
prescaler #(
    .N(26)
) u_prescaler0 (
    .clk(clk),
    .signal(),
    .done(timer)
);

//────────────────────────────────────────────
//── UART: TRANSMISOR
//────────────────────────────────────────────
//-- Instanciar la UART
wire transmit;
uart_tx_module u_uart_tx0 (
    .clk(clk),
    .start_in(transmit),
    .data_in(car),   

    .tx_pin_out(uart_tx),   
    .busy_out(),     
    .done_out(done)
);


//--------------------- Automata
reg E0 = 1;  //-- Idle
reg E1 = 0;  //-- Obtener caracter
reg E2 = 0;  //-- Transmitir caracter

//--       start      car!=0
//--   E0  ------> E1 -------> E2
//--   E0  <------ E1 <------- E2
//--       car==0       done

//-- Señales
wire start;
reg [7:0] car;
reg [2:0] adr;
wire transmit;
wire is_car0;
assign is_car0 = (car==0);

//--- Evolucion del estado
wire next;

always @(posedge clk) begin
    if (next) begin
        E1 <= E0 | E2;
        E2 <= E1 & T12;
        E0 <= E1 & T10;
    end
end

//-- Transiciones
wire T01;
wire T12;
wire T10;
wire T21;
wire done;
assign T01 = E0 && start;
assign T12 = E1 && !is_car0;
assign T10 = E1 && is_car0;
assign T21 = E2 && done;

//-- Siguiente estado
assign next = (T01 | T12 | T10 | T21);

//-- Comienzo de la transmicion
assign start = btn_up_press | timer;

//-- Lectura de los caracteres
always @* begin
    case (adr)
        3'h0: car <= "H";
        3'h1: car <= "O";
        3'h2: car <= "L";
        3'h3: car <= "A";
        3'h4: car <= ".";
        3'h5: car <= ".";
        3'h6: car <= ".";
        default: car <= 8'h0;
    endcase
end 

//-- Direccion del caracter
always @(posedge clk) begin
    if (E0)
      adr <= 0;
    else if (T12)
      adr <= adr + 1; 
end

//-- Tranmision del caaracter
assign transmit = T12;


//-- TEST
assign leds[15] = E0;
assign leds[13] = E2;
assign leds[8] = btn_up;
assign leds[7:0] = car;

endmodule
