module approx_mult #(
    parameter I_DWIDTH = 16,
    parameter I_AWIDTH = 4,
    parameter O_DWIDTH = I_DWIDTH * 2,  // 32
    parameter O_AWIDTH = I_AWIDTH - 1   // 3
) (
    input  clk,
    input  rst,
    input  start,
    output done
);

    wire rst_adr;
    wire inc_adr;
    wire rd_addr0;
    wire load_a;
    wire load_b;
    wire shl_a;
    wire shl_b;
    wire mult_start;
    wire load_res;
    wire shr_res;
    wire memout_wr;
    wire wbc_rst;
    wire wbc_inc;
    wire wbc_dec;
    wire shc_rst;
    wire shc_inc;
    wire shc_dec;
    
    wire mult_ready;
    wire msb_a;
    wire msb_b;
    wire stop_shift;
    wire wbc_zero;
    wire last_adr;



    Datapath #(
        .I_DWIDTH (I_DWIDTH),
        .I_AWIDTH (I_AWIDTH),
        .O_DWIDTH (O_DWIDTH),
        .O_AWIDTH (O_AWIDTH)
    ) DP (
        .clk        ( clk          ),
        .rst        ( rst          ),
        .done       ( done         ),
    
        .rst_adr    ( rst_adr      ),
        .inc_adr    ( inc_adr      ),
        .rd_addr0   ( rd_addr0     ),
        .load_a     ( load_a       ),
        .load_b     ( load_b       ),
        .shl_a      ( shl_a        ),
        .shl_b      ( shl_b        ),
        .mult_start ( mult_start   ),
        .load_res   ( load_res     ),
        .shr_res    ( shr_res      ),
        .memout_wr  ( memout_wr    ),
        .wbc_rst    ( wbc_rst      ),
        .wbc_inc    ( wbc_inc      ),
        .wbc_dec    ( wbc_dec      ),
        .shc_rst    ( shc_rst      ),
        .shc_inc    ( shc_inc      ),
        .shc_dec    ( shc_dec      ),
        
        .mult_ready ( mult_ready   ),
        .msb_a      ( msb_a        ),
        .msb_b      ( msb_b        ),
        .stop_shift ( stop_shift   ),
        .wbc_zero   ( wbc_zero     ),
        .last_adr   ( last_adr     )
    );

    ControlUnit CU (
        .clk         ( clk          ),
        .rst         ( rst          ),
        .start       ( start        ),
    
        .mult_ready  ( mult_ready   ),
        .msb_a       ( msb_a        ),
        .msb_b       ( msb_b        ),
        .stop_shift  ( stop_shift   ),
        .wbc_zero    ( wbc_zero     ),
        .last_adr    ( last_adr     ),
    
        .rst_adr     ( rst_adr      ),
        .inc_adr     ( inc_adr      ),
        .rd_addr0    ( rd_addr0     ),
        .load_a      ( load_a       ),
        .load_b      ( load_b       ),
        .shl_a       ( shl_a        ),
        .shl_b       ( shl_b        ),
        .mult_start  ( mult_start   ),
        .load_res    ( load_res     ),
        .shr_res     ( shr_res      ),
        .memout_wr   ( memout_wr    ),
        .wbc_rst     ( wbc_rst      ),
        .wbc_inc     ( wbc_inc      ),
        .wbc_dec     ( wbc_dec      ),
        .shc_rst     ( shc_rst      ),
        .shc_inc     ( shc_inc      ),
        .shc_dec     ( shc_dec      ),
        .finish      ( done         )
    );


endmodule
