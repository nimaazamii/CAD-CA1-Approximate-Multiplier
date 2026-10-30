module iBRAM #(
    parameter AWIDTH = 4,
    parameter DWIDTH = 16
)(
    input clk,
    input wren,                   // Write Enable
    input [AWIDTH-1:0] addr,      // Read & Write Address
    input [DWIDTH-1:0] data_in,

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
    
    initial begin
        $readmemb("./file/data_input.txt", memory);
    end

endmodule
