`default_nettype none   

//-- Pintar cada mitad de la pantalla de un color: Verde - Negro
//-- Con el botón UP se niega. El efecto es que se mueve la barra vertical
module vga_2x1 (
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

//------------------------------------------------------
//-- BOTONES

//-- Constantes para pulsadores
localparam CENTER = 0;
localparam UP = 1;
localparam DOWN = 4;
localparam LEFT = 2;
localparam RIGHT = 3;

wire btn_up;
wire btn_up_press;
button_input u_btn0 (
    .clk(clk),
    .button_pin_in(buttons[UP]), 
    .button_state_out(btn_up),
    .press_out(btn_up_press),
    .release_out()  //-- Sin conectar
);


//------------------------------------------------------------
//-- Parametros de la VGA
localparam LINE_WIDTH = 640;
localparam LINE_FRONT_PORCH = 16;
localparam LINE_SYNC_PULSE = 96;
localparam LINE_BACK_PORCH = 48;

localparam FRAME_HEIGHT = 480;
localparam FRAME_FRONT_PORCH = 10;
localparam FRAME_SYNC_PULSE = 2;
localparam FRAME_BACK_PORCH = 29; //33

//------------------------------------------------------------
//-- Reloj de la vga: 25Mhz
wire vga_clk;
reg [1:0] vga_prescaler = 0;
always @(posedge clk) begin
    vga_prescaler <= vga_prescaler + 1;
end

//-- Este es mi pixel clock
assign vga_clk = vga_prescaler[1];


//-------------------------------------------------------------
//-- Sincronizacion

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


//-----------------------------------------------------------
//-- Asignacion de señales a la VGA

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
posedge_detector u_posedge (
    .clk(clk),
    .value(end_frame),
    .pos_edge(refresh)
);

//-- Enviar las señales de sincronizacion a la VGA
assign vga_hsync = hsync;
assign vga_vsync = vsync;

//--- Establecer colores
assign vga_red   = 4'h0;  //-- Deshabilitado
assign vga_blue  = 4'h0;  //-- Deshabilitado
assign vga_green = (video & draw) ? INTENSIDAD : APAGADO;

//----------------------------------------------
//-- Coordenadas del pixel
wire [9:0] px;
wire [8:0] py;
assign px = draw ? col : 0;
assign py = draw ? row : 0;

//-------------------------------------------------------
//-- GENERACION DE LA SEÑAL DE VIDEO

//-- Objeto a dibujar: Se ponen en verde el conjunto
//-- de pixeles cuyas coordenadas x están en la parte izquierda
//-- y el resto negros
wire object;
assign object = px < 320;

//-- Valor estable a pintar. Se captura el estado del pulsador
//-- Cuando se ha terminado de renderizar el frame
//-- Actual
reg stable;
always @(posedge clk) begin
    if (refresh)
        stable <= btn_up;
end

//-- Señal que se envía. El objeto o su negado en funcion
//-- del estado del pulsador
wire video;
assign video = (stable) ? object : ~object;

//-- TEST
assign leds[15] = 1;
assign leds[14] = btn_up;
assign leds[9:0] = px;

endmodule

