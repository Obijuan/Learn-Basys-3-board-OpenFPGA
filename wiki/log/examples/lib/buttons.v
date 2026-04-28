//══════════════════════════════════════════════════════════
//─ Bibloteca de modulos para acceder a los PULSADORES
//══════════════════════════════════════════════════════════

//──────────────────────────────────────────────────────────────────────
//──  BOTON NORMAL
//──────────────────────────────────────────────────────────────────────
//── Lectura de un pulsador normal
//── A la salida se obtiene la señal de estado y los eventos:
//──   * Botón apretado
//──   * Botón liberado
//──────────────────────────────────────────────────────────────────────
module normal_button (
    input wire clk,
    input wire btn_pin,  //-- Pin del boton

    output wire btn_state,   //-- Estado del pulsador
    output wire tic_press,   //-- Evento: Buton apretado
    output wire tic_release, //-- Evento: Botón liberado
);


//──────────── Sincronizador para el pulsador
//── Pulsador sincronizado
wire btn_sync;
synchronizer u_sync (
    .clk(clk),
    .async_in(btn_pin),  //-- Entrada asíncrona
    .sync_out(btn_sync)  //-- Salida sincronizada
);

//-- Tamaño del contador
parameter SIZE = 18;

//-------------------------------------------------------------
//-- Tiempo que tarda el contador en alcanzar su valor maximo
//-- t (seg) = (2**SIZE) / F
//--
//-- Para la Basys3, F=100Mhz = 100_000_000
//--
//-- Para SIZE=18 --> t = 2.6ms
//--------------------------------------------------------------


//-- NOTA: Código adaptado de fpga4fun.com

//-- Estado del pulsador
reg state = 0;  //-- Inicialmente 0

//-- Detectar estado de reposo: no hay cambios entre el 
//-- estado actual y el siguiente
wire idle;
assign idle = (state == btn_sync);

//-- Contador de SIZE bits para medir la estabilidad
reg [15:0] cnt;

//-- El contador empieza a contar cuando hay cambio en 
//-- la señal. De lo contrario se lleva a 0, absorbiendo
//-- todos los pulsos espúreos
always @(posedge clk) begin
    if (idle)
        cnt <= 0;

    //-- Hay cambio. Contar!
    else begin
        cnt <= cnt + 16'd1;

        //-- Calcular el valor del estado actual
        //-- Si el contador llega al valor maximo, el cambio
        //-- es estable: cambiar el estado!
        if (cnt_max)
            state <= ~state;
    end
end

//-- Calcular cuando el contador llega al valor maximo
wire cnt_max;
assign cnt_max = &cnt;

//--------------- SALIDAS
assign btn_state = state;

//-- Eventos
assign tic_press   = ~idle & cnt_max & (state==0);
assign tic_release = ~idle & cnt_max & (state==1);

endmodule
