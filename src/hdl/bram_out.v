module oBRAM #(
    parameter AWIDTH = 3,
    parameter DWIDTH = 32
)(
    input clk,
    input wren,                   // Write Enable
    input [AWIDTH-1:0] addr,      // Read & Write Address
    input [DWIDTH-1:0] data_in,
    input done,

    output reg [DWIDTH-1:0] data_out
);

    reg [DWIDTH-1:0] memory [0:2**AWIDTH-1];


    always @ (posedge clk)
    begin
        if (wren) begin
            memory[addr] <= data_in;  
        end
        
        data_out <= memory[addr];
    end


    // For DEBUG Purpose
    integer fout, i;
    always @ (posedge clk)
    begin
        if (done)
            $writememh("./file/data_out.txt", memory);
    end
	
endmodule
