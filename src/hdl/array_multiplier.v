module ArrayMultiplier #(
    parameter IWIDTH = 8,
    parameter OWIDTH = 2*IWIDTH
)(
    input  start,    // In Array Multiplier which is combinational, this signal is useless
    input  [IWIDTH-1:0] Ain,
    input  [IWIDTH-1:0] Bin,
    output [OWIDTH-1:0] product,
    output ready    // In Array Multiplier which is combinational, this signal is always '1'
);

	assign product = Ain * Bin;
	assign ready   = 1'b1;    // Multiplier is combinational. So, this signal is always '1'
	
endmodule
