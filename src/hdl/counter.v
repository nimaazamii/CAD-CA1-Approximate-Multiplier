module counter #(
    parameter DWIDTH = 5
)(
    input clk,
    input rst,
    input inc,
    input dec,
    output reg [DWIDTH-1:0] count_out
);

    always @(posedge clk)
    begin
        if (rst)
            count_out <= {DWIDTH{1'b0}};
        else if (inc)
            count_out <= count_out + 1;
        else if (dec)
            count_out <= count_out - 1;
    end

endmodule
