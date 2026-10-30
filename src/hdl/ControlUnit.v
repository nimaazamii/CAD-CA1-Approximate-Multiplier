module ControlUnit (
    input clk,
    input rst,
    input start,

    input mult_ready,
    input msb_a,
    input msb_b,
    input stop_shift,
    input wbc_zero,
    input last_adr,

    output reg rst_adr,
    output reg inc_adr,
    output reg rd_addr0,
    output reg load_a,
    output reg load_b,
    output reg shl_a,
    output reg shl_b,
    output reg mult_start,
    output reg load_res,
    output reg shr_res,
    output reg memout_wr,
    output reg wbc_rst,
    output reg wbc_inc,
    output reg wbc_dec,
    output reg shc_rst,
    output reg shc_inc,
    output reg shc_dec,
    output reg finish
);

    localparam INIT1      = 4'b0000;
    localparam INIT2      = 4'b0001;
    localparam LOAD_A     = 4'b0010;
    localparam SHL_A      = 4'b0011;
    localparam LOAD_B     = 4'b0100;
    localparam SHL_B      = 4'b0101;
    localparam MULTIPLY   = 4'b0110;
    localparam LOAD_RR    = 4'b0111;
    localparam SHR_RR     = 4'b1000;
    localparam STORE_R    = 4'b1001;
    localparam NEW_MULT   = 4'b1010;
    localparam FINAL      = 4'b1011;

    reg [3:0] PSS, NS;
    reg [3:0] PS;

    always @(posedge clk)
    begin
        if (rst)
            PS = INIT1;
        else
            PS = NS;
    end

    always @ (*)
    begin
        rst_adr    = 0;
        inc_adr    = 0;
        rd_addr0   = 0;
        load_a     = 0;
        load_b     = 0;
        shl_a      = 0;
        shl_b      = 0;
        mult_start = 0;
        load_res   = 0;
        shr_res    = 0;
        memout_wr  = 0;
        wbc_rst    = 0;
        wbc_inc    = 0;
        wbc_dec    = 0;
        shc_rst    = 0;
        shc_inc    = 0;
        shc_dec    = 0;
        finish     = 0;
        NS         = INIT1;

        case (PS)
            INIT1: begin
                rst_adr = 1;
                wbc_rst = 1;
                shc_rst = 1;
                NS = (start) ? INIT2 : INIT1; // When start=1 goes to next
            end

            INIT2: begin
                rd_addr0 = 0;
                NS = (start) ? INIT2 : LOAD_A; // When start=0 goes to next
            end

            LOAD_A: begin
                load_a  = 1;
                shc_rst = 1;
                NS = SHL_A;
            end

            SHL_A: begin
                rd_addr0 = 1;      // To read B and load it in the next state
                shl_a    = (msb_a) ? 0 : 1;
                wbc_inc  = (msb_a) ? 0 : 1;
                shc_inc  = (msb_a) ? 0 : 1;
                NS = (msb_a || stop_shift) ?  LOAD_B : SHL_A;
            end

            LOAD_B: begin
                load_b  = 1;
                shc_rst = 1;
                NS = SHL_B;
            end

            SHL_B: begin
                rd_addr0 = 1;
                shl_b    = (msb_b) ? 0 : 1;
                wbc_inc  = (msb_b) ? 0 : 1;
                shc_inc  = (msb_b) ? 0 : 1;
                NS = (msb_b || stop_shift) ?  MULTIPLY : SHL_B;
            end

            MULTIPLY: begin
                mult_start = 1;
                NS = (mult_ready) ?  LOAD_RR : MULTIPLY;
            end

            LOAD_RR: begin
                load_res = 1;
                NS = SHR_RR;
            end

            SHR_RR: begin
                wbc_dec = 1;
                shr_res = (wbc_zero) ? 0 : 1;
                NS      = (wbc_zero) ?  STORE_R : SHR_RR;
            end

            STORE_R: begin
                memout_wr = 1;
                inc_adr   = 1;     // Increase Write-Address to read a possible new pair 
                NS = (last_adr) ? FINAL : NEW_MULT;
            end

            NEW_MULT: begin
                rd_addr0 = 0;   // Start reading a new pair from input RAM
                wbc_rst  = 1;   // reset worthless bit counter for the new pair
                NS = LOAD_A;
            end

            FINAL: begin
                finish = 1;
                NS = INIT1;
            end

            default: NS = 4'bxxxx; //INIT1;
        endcase
    end

endmodule
