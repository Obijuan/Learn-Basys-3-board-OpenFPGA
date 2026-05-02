module memory1 (
    input wire clk,
    input wire [9:0] addr,
    input wire [31:0] data_in,
    input wire wr,
    output wire [31:0] data_out
);

//-- Address with
localparam ADDR_WIDTH = 10;
//-- Data with
localparam DATA_WIDTH = 32;

//-- Size of the memory
localparam SIZE = 1 << ADDR_WIDTH;

//-- Memory itself
reg [DATA_WIDTH-1:0] mem[0:SIZE-1];

//-- The data_out is a registered output (not a wire)
reg [31:0] data_out_i;
assign data_out = data_out_i;

//-- Reading port: Synchronous
always @(posedge clk)
begin
  data_out_i <= mem[addr];
end

//-- Writing port: Synchronous
always @(posedge clk)
begin
    if (wr) mem[addr] <= data_in;
end


//-- Init the memory
initial begin

    //-- Valores iniciales para pruebas
    mem[0] = 32'h0000_00AA;
    mem[1] = 32'h0000_0055;
    mem[2] = 32'h0000_00F0;
    mem[3] = 32'h0000_000F;
    mem[4] = 32'h0000_00FF;
    
    //$readmemh(ROMF, mem, 0, SIZE-1);
  
end

endmodule


module memory2 (
    input wire clk,
    input wire [9:0] addr,
    input wire [31:0] data_in,
    input wire wr,
    output wire [31:0] data_out
);

//-- Address with
localparam ADDR_WIDTH = 10;
//-- Data with
localparam DATA_WIDTH = 32;

//-- Size of the memory
localparam SIZE = 1 << ADDR_WIDTH;

//-- Memory itself
reg [DATA_WIDTH-1:0] mem[0:SIZE-1];

//-- The data_out is a registered output (not a wire)
reg [31:0] data_out_i;
assign data_out = data_out_i;

//-- Reading port: Synchronous
always @(posedge clk)
begin
  data_out_i <= mem[addr];
end

//-- Writing port: Synchronous
always @(posedge clk)
begin
    if (wr) mem[addr] <= data_in;
end


//-- Init the memory
initial begin

    //-- Valores iniciales para pruebas
    mem[0] = 32'h0000_F000;
    mem[1] = 32'h0000_0F00;
    mem[2] = 32'h0000_00F0;
    mem[3] = 32'h0000_000F;
    mem[4] = 32'h0000_FFFF;
  
end

endmodule
