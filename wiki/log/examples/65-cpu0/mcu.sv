module mcu #(
    parameter real CLK_FREQUENCY_MHZ,
    parameter int  UART_BAUD_RATE,
    parameter int DEBOUNCER_SIZE
) (
    //-- Main system clk
    input logic clk,

    //-- Memory clock
    input logic clk_mem,

    //-- Buttons (order: 4 - drluc- 0)
    input  logic [4:0] buttons_async,

    //-- Switches
    input logic [15:0] switches_async,

    //-- LEDs
    output logic [15:0] leds,

    //-- Display 7 segmentos
    output logic [7:0] segments,
    output logic [3:0] segments_select,

    //-- SERIAL PORT
    output logic uart_tx,
    input logic uart_rx_async
);

//-----------------------------------------------------------------------
//-- RESET: El reset se realiza tras 32 ciclos
//-- En las FPGAs ICE40 la memoria tarda 32 ciclos en inicializarse tras
//-- la carga del bitstream
//-----------------------------------------------------------------------
logic rst;
logic [6:0] rst_cnt = 7'b0;

assign rst = ~rst_cnt[5];

always_ff @( posedge(clk) ) begin
    if (rst_cnt[5]==0)
        rst_cnt <= rst_cnt + 1;
end

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE PULSADORES 
//───────────────────────────────────────────────────────────
localparam BOTONES = 5;
logic [4:0] buttons_sync;
for (genvar btn_i = 0; btn_i < BOTONES; btn_i++) begin : gen_0

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(buttons_async[btn_i]),
        .sync_out(buttons_sync[btn_i])
    );
end

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE SWITCHES 
//───────────────────────────────────────────────────────────
localparam SWITCHES = 16;
logic [15:0] switches_sync;
for (genvar sw_i = 0; sw_i < SWITCHES; sw_i++) begin : gen_1

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(switches_async[sw_i]),
        .sync_out(switches_sync[sw_i])
    );
end

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE RX
//───────────────────────────────────────────────────────────
logic rx_serial_in;
synchronizer u_rx_sync (
    .clk(clk),
    .async_in(uart_rx_async),
    .sync_out(rx_serial_in)
);


//------------------------------------------
//-- PERIFERICOS
//------------------------------------------
import constants::MEMORY_START;
import constants::MEMORY_SIZE;
import constants::LEDS_START;
import constants::LEDS_SIZE;
import constants::UART_START;
import constants::UART_SIZE;


//--- Interrupciones
logic external_interrupt;
logic timer_interrupt;
logic uart_interrupt;

//-- Acceso a la memoria
wishbone_interface fetch_bus();
wishbone_interface mem_bus();

wishbone_interface mem_bus_slaves[3]();
wishbone_interconnect #(
    .NUM_SLAVES(3),
    .SLAVE_ADDRESS({
        MEMORY_START,
        LEDS_START,
        UART_START
    }),
    .SLAVE_SIZE({
        MEMORY_SIZE,
        LEDS_SIZE,
        UART_SIZE
    })
) peripheral_bus_interconnect (
    .clk(clk),
    .rst(rst),
    .master(mem_bus),
    .slaves(mem_bus_slaves)
);

//-- MEMORIA RAM
wishbone_ram #(
    .ADDRESS(MEMORY_START),
    .SIZE(MEMORY_SIZE)
) ram (
    .clk(clk_mem),
    .rst(rst),
    .port_a(fetch_bus.slave),
    .port_b(mem_bus_slaves[0])
);

//-- PUERTO DE SALIDA CON LEDS
wishbone_leds #(
    .ADDRESS(LEDS_START),
    .SIZE(LEDS_SIZE)
) u_wishbone_leds (
    .clk(clk),
    .rst(rst),
    .leds(leds),
    .wishbone(mem_bus_slaves[1])
);

//-- PUERTO SERIE (UART)
wishbone_uart #(
    .ADDRESS(UART_START),
    .SIZE(UART_SIZE),
    .BAUD_RATE(UART_BAUD_RATE),
    .CLK_FREQUENCY_MHZ(CLK_FREQUENCY_MHZ)
) wb_uart (
    .clk(clk),
    .rst(rst),
    .rx_serial_in(rx_serial_in),
    .tx_serial_out(uart_tx),
    .interrupt(uart_interrupt),
    .wishbone(mem_bus_slaves[2])
);


//-- CPU
cpu cpu(
    .clk(clk),
    .rst(rst),
    .memory_fetch_port(fetch_bus.master),
    .memory_mem_port(mem_bus.master),
    .external_interrupt_in(external_interrupt),
    .timer_interrupt_in(timer_interrupt)
);


//-- Conexion de interrupciones
assign timer_interrupt = 0;
assign external_interrupt_in = uart_interrupt;


endmodule
