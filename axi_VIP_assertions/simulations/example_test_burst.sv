// Adaptions from example_test1.sv

class example_test_burst extends example_test;
    `uvm_component_utils(example_test_burst)

    extern function new(string name, uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    extern task main_phase (uvm_phase phase);

endclass

function example_test_burst::new(string name, uvm_component parent = null);
    super.new(name, parent);
endfunction

function void example_test_burst::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //env = super.env;
endfunction: build_phase


task example_test_burst::main_phase (uvm_phase phase);
    uvm_reg_data_t data;
    bit[31:0] addr;
    logic [1:0] resp;
    // uvm_status_e    status; // not used yet

    axi_master_write_seq wr_seq;
    axi_master_read_seq rd_seq;
    axi_burst_write_seq bw_seq;

    logic [`AXI_MAX_DW-1:0] wr_data [];
    logic [128-1:0]         wdata;
    logic [`AXI_MAX_DW-1:0] rd_data [];

    //uvm_reg_data_t rd_data_single;
    logic [1:0]             rresp [];
    logic [1:0]             bresp;
    int                     wr_data_length;
    bit                     state;
    axi_seq_item tr[];
    axi_seq_item t;
   
    `uvm_info("TRACE","Example test_burst is running.", UVM_LOW);

    uvm_top.print_topology ();
    phase.raise_objection (this);

    rd_seq          = axi_master_read_seq::type_id::create("rd_seq");
    wr_seq          = axi_master_write_seq::type_id::create("wr_seq");
    bw_seq          = axi_burst_write_seq::type_id::create("bw_seq");

    
    // adding burst sequence
    wr_data_length    = 16 ;
    wr_data         = new[wr_data_length];
    for(int i = 0; i < wr_data_length ; i++) begin
        wr_data[i]  = (i+1) 
                      * 128'h10101010101010101010101010101010
                      + 128'h0f0e0d0c0b0a09080706050403020100;
	/** So that:
	 * High nibbles are (i+1),
	 * low nibble are byte number in word. */
    end



// Utility macro to repeat seq_write_burst call with some randomization
`define REPEAT_SEQ_NUM 6
`define REPEAT_SEQ_WRITE_BURST(addr, data, burst_length, byte_en, bresp, seqr, tr_size_in_bytes)\
    #40ns;\
    for (int i=0; i<`REPEAT_SEQ_NUM; i++) begin \
	#10ns;\
	wr_seq.write_burst(addr+i*'h00010000, data, burst_length, 16'hFFFF, bresp, seqr, tr_size_in_bytes, null); \
    end


//  `REPEAT_SEQ_WRITE_BURST( addr		, wr_data       , burst_length  , byte_en       , bresp , uvm_sequencer_base      , tr_size_in_byte)

     // align full band				: 4 beats of 16 bytes (128 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h00000000       , wr_data       , 4             , 16'hFFFF      , bresp , env.u_axi_master_agt.sqr, 16)
    
    // align narrow band (low half)		: 8 beats of 8 bytes (64 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h01000000       , wr_data       , 8             , 16'h00FF      , bresp , env.u_axi_master_agt.sqr,  8)
    // align narrow band (high half)		: 8 beats of 8 bytes (64 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h02000008       , wr_data       , 8             , 16'hFF00      , bresp , env.u_axi_master_agt.sqr,  8)

    // align narrow band (low quarter)		: 16 beats of 4 bytes (32 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h03000000       , wr_data       , 16            , 16'h000F      , bresp , env.u_axi_master_agt.sqr,  4)
    // align narrow band (mid-low quarter)	: 16 beats of 4 bytes (32 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h04000004       , wr_data       , 16            , 16'h00F0      , bresp , env.u_axi_master_agt.sqr,  4)
    // align narrow band (mid-high quarter)	: 16 beats of 4 bytes (32 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h05000008       , wr_data       , 16            , 16'h0F00      , bresp , env.u_axi_master_agt.sqr,  4)
    // align narrow band (high quarter)		: 16 beats of 4 bytes (32 bits)
    `REPEAT_SEQ_WRITE_BURST(32'h0600000C       , wr_data       , 16            , 16'hF000      , bresp , env.u_axi_master_agt.sqr,  4)


    // unaligned full band                      : 4 beats of 16 bytes (first beat incomplete because unaligned)
      `REPEAT_SEQ_WRITE_BURST(32'h07000006       , wr_data       , 4             , 16'hFF00      , bresp , env.u_axi_master_agt.sqr, 16)

    // unalign narrow band (low half shifted)	: 7 beats of 8 bytes (64 bits), (first beat incomplete because unaligned)
    `REPEAT_SEQ_WRITE_BURST(32'h08000006       , wr_data       , 7             , 16'h0FF0      , bresp , env.u_axi_master_agt.sqr,  8)
    // unalign narrow band (high half shifted)	: 7 beats of 8 bytes (64 bits), (first beat incomplete because unaligned)
    `REPEAT_SEQ_WRITE_BURST(32'h0900000A       , wr_data       , 7             , 16'hF000      , bresp , env.u_axi_master_agt.sqr,  8)



      #200ns;
    $stop;
    
      #100ns;
    phase.drop_objection (this);
    
endtask



