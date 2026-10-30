`timescale 1ns/1ns

module test_top;

	reg clk, rst, start;
	wire done;

    approx_mult #(
        .I_DWIDTH (16),
        .I_AWIDTH (4 ),
        .O_DWIDTH (32), 
        .O_AWIDTH (3 )
    ) UUT (
        .clk   (clk   ),
        .rst   (rst   ),
        .start (start ),
        .done  (done  )
    );

    initial
    begin
        clk = 1;
        repeat(1000)
        	#10 clk = ~clk;
    end
    
    initial
    begin
        rst   = 0;
        start = 0;
        #10 rst = 1;
        #20 rst = 0;  start = 1;
        #40 start = 0;
    end

endmodule
