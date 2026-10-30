module ShiftRegister #(
    parameter DWIDTH = 32
)(
    input clk,
    input load,
    input shr,
    input shl,
    input [DWIDTH-1:0] din,
    output reg [DWIDTH-1:0] dout
);

    always @(posedge clk)
    begin
        if (load)
            dout <= din;
        else if (shr)
            dout <= dout >> 1;
        else if (shl)
            dout <= dout << 1;
    end

endmodule
