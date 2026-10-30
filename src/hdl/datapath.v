module Datapath #(
    parameter I_DWIDTH = 16,
    parameter I_AWIDTH = 4,
    parameter O_DWIDTH = I_DWIDTH * 2,  // 32
    parameter O_AWIDTH = I_AWIDTH - 1   // 3
) (
    input  clk,
    input  rst,
    input  done,

    input  rst_adr,
    input  inc_adr,
    input  rd_addr0,
    input  load_a,
    input  load_b,
    input  shl_a,
    input  shl_b,
    input  mult_start,
    input  load_res,
    input  shr_res,
    input  memout_wr,
    input  wbc_rst,
    input  wbc_inc,
    input  wbc_dec,
    input  shc_rst,
    input  shc_inc,
    input  shc_dec,
    
    output mult_ready,
    output msb_a,
    output msb_b,
    output stop_shift,
    output wbc_zero,
    output last_adr
);

    localparam I_ZERO    = {I_DWIDTH{1'b0}}; // A constant ZERO value whose width is I_DWIDTH
	localparam MULT_SIZE = I_DWIDTH / 2;     // WIDTH of The Multiplier's Input Data
    localparam WBC_BITS  = $clog2(I_DWIDTH)+1;  // 5
    localparam SHC_BITS  = $clog2(I_DWIDTH)-1;  // 3

    wire [I_AWIDTH-1:0] rd_addr;
    wire [O_AWIDTH-1:0] wr_addr;
    
    wire [I_DWIDTH-1:0] rd_data;
    wire [O_DWIDTH-1:0] wr_data;

    wire [I_DWIDTH-1:0] A_value;
    wire [I_DWIDTH-1:0] B_value;
    wire [MULT_SIZE-1:0] mult_inA;    // MULT_SIZE = I_DWIDTH/2 = 8
    wire [MULT_SIZE-1:0] mult_inB;    // MULT_SIZE = I_DWIDTH/2 = 8
    wire [I_DWIDTH -1:0] mult_result;
	wire [O_DWIDTH-1:0] RR_in;         // The input of Result Register

    wire [WBC_BITS-1:0] wbc_amt;
    wire [SHC_BITS-1:0] shl_amt;

    // Address Generation Logic for both Input and Output RAMs
    counter #(.DWIDTH(O_AWIDTH)) AddrGen
    (
        .clk        ( clk     ),
        .rst        ( rst_adr ),
        .inc        ( inc_adr ),
        .dec        ( 1'b0    ),
        .count_out  ( wr_addr )
    );
    
    assign rd_addr  = {wr_addr, rd_addr0};
    assign last_adr = &wr_addr;   // When all bits of wr_addr are ONEs (i.e., 3'b111)


    // INPUT RAM (Used as a ROM, wren=0)
    iBRAM #(
        .AWIDTH (I_AWIDTH),
        .DWIDTH (I_DWIDTH)
    ) InputRAM (
        .clk      ( clk       ),
        .wren     ( 1'b0      ),
        .addr     ( rd_addr   ),
        .data_in  ( I_ZERO    ),
    
        .data_out ( rd_data   )
    );


    // The Multiplier's Input Registers
    ShiftRegister #(.DWIDTH (I_DWIDTH)) A_REG
    (
        .clk  ( clk       ),
        .load ( load_a    ),
        .shr  ( 1'b0      ),
        .shl  ( shl_a     ),
        .din  ( rd_data   ),
        .dout ( A_value   )
    );


    ShiftRegister #(.DWIDTH (I_DWIDTH)) B_REG
    (
        .clk  ( clk       ),
        .load ( load_b    ),
        .shr  ( 1'b0      ),
        .shl  ( shl_b     ),
        .din  ( rd_data   ),
        .dout ( B_value   )
    );
    
    assign msb_a = A_value[I_DWIDTH-1];
    assign msb_b = B_value[I_DWIDTH-1];

    assign mult_inA = A_value[I_DWIDTH-1:I_DWIDTH/2]; // A_value[15:8]
    assign mult_inB = B_value[I_DWIDTH-1:I_DWIDTH/2]; // B_value[15:8]


    // Multiply Engine (It is an Array Multiplier for now)
    ArrayMultiplier #(.IWIDTH (MULT_SIZE)) MULT_UNIT
    (
        .start   ( mult_start  ),
        .Ain     ( mult_inA    ),
        .Bin     ( mult_inB    ),
        .product ( mult_result ),
        .ready   ( mult_ready  ) 
    );


    // Multiply Result-Register

	assign RR_in = {mult_result, I_ZERO};

    ShiftRegister #(.DWIDTH (O_DWIDTH)) RES_REG
    (
        .clk  ( clk        ),
        .load ( load_res   ),
        .shr  ( shr_res    ),
        .shl  ( 1'b0       ),
        .din  ( RR_in      ),
        .dout ( wr_data    )
    );

	
    // OUTPUT RAM (Used as a Write-Only Memory for now)
    oBRAM #(
        .AWIDTH (O_AWIDTH),
        .DWIDTH (O_DWIDTH)
    ) OutputRAM (
        .clk      ( clk       ),
        .wren     ( memout_wr ),
        .addr     ( wr_addr   ),
        .data_in  ( wr_data   ),
        .done     ( done      ),
    
        .data_out (           ) // OPEN for now
    );


    // COUNTERS FOR COUNTING AMOUNTS OF SHL AND SHR

    // Counter of  Worthless-Bits of both Operands
    counter #(.DWIDTH(WBC_BITS)) WBC   // Worthless-Bits Counter
    (
        .clk        ( clk     ),
        .rst        ( wbc_rst ),
        .inc        ( wbc_inc ),
        .dec        ( wbc_dec ),
        .count_out  ( wbc_amt )
    );
    
    assign wbc_zero = (wbc_amt==0) ? 1 : 0;    // if WBC counter is zero
    
    // Counter of  Shift-Lefts for each Operand
    counter #(.DWIDTH(SHC_BITS)) SHC   // SHift-left Counter
    (
        .clk        ( clk     ),
        .rst        ( shc_rst ),
        .inc        ( shc_inc ),
        .dec        ( shc_dec ),
        .count_out  ( shl_amt )
    );
    assign stop_shift = &shl_amt; // If all bits of the counter are '1', then no more shifts
    


endmodule
