module mcu #(
    parameter real CLK_FREQUENCY_MHZ,
    parameter int  UART_BAUD_RATE,
    parameter int DEBOUNCER_SIZE
) (
    //── Reloj del sistema
    input logic clk,

    //── Reloj de acceso a memoria
    input logic clk_mem,

    //── Entrada: Pulsadores
    //-- Centro: 0, Arriba: 1, Izq: 2, Der: 3, Abajo 4
    input  logic [4:0] buttons_async,

    //── Entrada: Switches
    input logic [15:0] switches_async,

    //── Salida: LEDs
    output logic [15:0] leds,

    //── Salida: Display 7 segmentos
    output logic [7:0] segments,
    output logic [3:0] segments_select,

    //── Consola de texto: Puerto serie
    output logic uart_tx,
    input logic uart_rx_async
);

//───────────────────────────────────────────────────────────────────────────
//── RESET: El reset se realiza tras 32 ciclos
//── En las FPGAs ICE40 la memoria tarda 32 ciclos en inicializarse tras
//── la carga del bitstream
//── En la tarjeta Basys3 No es necesario. Pero se deja por compatiblidad
//───────────────────────────────────────────────────────────────────────────
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

//───────────────────────────────────────────────────────────
//──          CPU
//───────────────────────────────────────────────────────────
//-- Acceso a la memoria
wishbone_interface fetch_bus();
wishbone_interface mem_bus();

//-- Interrupciones    
logic uart_interrupt;
logic test_interrupt;
logic timer_interrupt;
logic external_interrupt;

assign external_interrupt = uart_interrupt | test_interrupt;

cpu cpu(
    .clk(clk),
    .rst(rst),

    //-- Memoria de instrucciones
    .memory_fetch_port(fetch_bus.master),

    //-- Memoria de Datos
    .memory_mem_port(mem_bus.master),

    //-- Interrupcion externa
    .external_interrupt_in(external_interrupt),

    //-- Interrupcion del periferico contador
    .timer_interrupt_in(timer_interrupt)
);


//───────────────────────────────────────────────────────────
//──          PERIFERICOS
//───────────────────────────────────────────────────────────
import constants::MEMORY_START;
import constants::MEMORY_SIZE;
import constants::LEDS_START;
import constants::LEDS_SIZE;
import constants::BUTTONS_START;
import constants::BUTTONS_SIZE;
import constants::SWITCHES_START;
import constants::SWITCHES_SIZE;
import constants::SEGMENTS_START;
import constants::SEGMENTS_SIZE;
import constants::UART_START;
import constants::UART_SIZE;
import constants::TIMER_START;
import constants::TIMER_SIZE;
import constants::TEST_START;
import constants::TEST_SIZE;


//──────────────────────────────────────────────
//──    BUS WISHBONE
//──────────────────────────────────────────────

//-- Numero total de perifericos en el wishbone
localparam NP = 8;

//-- Esclavos
wishbone_interface mem_bus_slaves[NP]();

//───────────────────────────────
//──   INTERCONEXION
//───────────────────────────────
wishbone_interconnect #(
    .NUM_SLAVES(NP),
    .SLAVE_ADDRESS({
        MEMORY_START,   //-- 0
        LEDS_START,     //-- 1
        BUTTONS_START,  //-- 2
        SWITCHES_START, //-- 3
        SEGMENTS_START, //-- 4
        UART_START,     //-- 5
        TIMER_START,    //-- 6
        TEST_START      //-- 7
    }),
    .SLAVE_SIZE({
        MEMORY_SIZE,
        LEDS_SIZE,
        BUTTONS_SIZE,
        SWITCHES_SIZE,
        SEGMENTS_SIZE,
        UART_SIZE,
        TIMER_SIZE,
        TEST_SIZE
    })
) peripheral_bus_interconnect (
    .clk(clk),
    .rst(rst),
    .master(mem_bus),
    .slaves(mem_bus_slaves)
);

//───────────────────────────────
//──   MEMORIA RAM
//───────────────────────────────
wishbone_ram #(
    .ADDRESS(MEMORY_START),
    .SIZE(MEMORY_SIZE)
) ram (
    .clk(clk_mem),
    .rst(rst),
    .port_a(fetch_bus.slave),
    .port_b(mem_bus_slaves[0])
);

//───────────────────────────────
//──   LEDS
//───────────────────────────────
wishbone_leds #(
    .ADDRESS(LEDS_START),
    .SIZE(LEDS_SIZE)
) u_wishbone_leds (
    .clk(clk),
    .rst(rst),
    .leds(leds),
    .wishbone(mem_bus_slaves[1])
);

//───────────────────────────────
//──   BOTONES
//───────────────────────────────
wishbone_buttons #(
    .ADDRESS(BUTTONS_START),
    .SIZE(BUTTONS_SIZE)
) u_wishbone_buttons(
    .clk(clk),
    .rst(rst),
    .buttons(buttons_sync),
    .wishbone(mem_bus_slaves[2])
);

//───────────────────────────────
//──   SWITCHES
//───────────────────────────────
wishbone_switches #(
    .ADDRESS(SWITCHES_START),
    .SIZE(SWITCHES_SIZE)
) u_wishbone_switches(
    .clk(clk),
    .rst(rst),
    .switches(switches_sync),
    .wishbone(mem_bus_slaves[3])
);

//───────────────────────────────
//──   DISPLAY 7 SEGMENTOS
//───────────────────────────────
wishbone_segments #(
    .ADDRESS(SEGMENTS_START),
    .SIZE(SEGMENTS_SIZE)
) wb_segments (
    .clk(clk),
    .rst(rst),
    .segments(segments),
    .segments_select(segments_select),
    .wishbone(mem_bus_slaves[4])
);

//───────────────────────────────
//──   CONSOLA: PUERTO SERIE
//───────────────────────────────
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
    .wishbone(mem_bus_slaves[5])
);

//───────────────────────────────
//──   TEMPORIZADOR
//───────────────────────────────
wishbone_timer #(
    .ADDRESS(TIMER_START),
    .SIZE(TIMER_SIZE),
    .CLK_FREQUENCY_MHZ(CLK_FREQUENCY_MHZ)
) wb_timer (
    .clk(clk),
    .rst(rst),
    .interrupt(timer_interrupt),
    .wishbone(mem_bus_slaves[6])
);

//───────────────────────────────
//──   TEST
//───────────────────────────────
wishbone_test #(
        .ADDRESS(TEST_START),
        .SIZE(TEST_SIZE)
    ) wb_test (
        .clk(clk),
        .rst(rst),
        .interrupt(test_interrupt),
        .wishbone(mem_bus_slaves[7])
    );

endmodule
