`include "axi_defines.svh"
`include "dma_reg_hdr.svh" 

class axi_dma_test_2 extends axi_interconnect_base_test;
   `uvm_component_utils(axi_dma_test_2)
   
   axi_dma_configuration   dma_cfg;
   axi_dma_seq             dma_seq;
   axi_pipeline_write_seq  pw_seq;
   axi_pipeline_read_seq   pr_seq;

///bit a;
   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern task run_phase (uvm_phase phase);

endclass

   //constructor
   function axi_dma_test_2::new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   //build_phase
   function void axi_dma_test_2::build_phase(uvm_phase phase);
      super.build_phase(phase); 
     dma_cfg = axi_dma_configuration::type_id::create("dma_cfg");
     pw_seq = axi_pipeline_write_seq::type_id::create("pw_seq");
     pr_seq = axi_pipeline_read_seq::type_id::create("pr_seq");
     dma_seq = axi_dma_seq::type_id::create("dma_seq");

       endfunction: build_phase
   
   //run_phase
   task axi_dma_test_2::run_phase (uvm_phase phase);
     logic  [`AXI_MAX_DW-1:0] wr_data        [];
     int burst_length;
     phase.raise_objection (this);
    
      dma_cfg.start_address   = S0_START;
      dma_cfg.end_address     = S1_START;
      dma_cfg.no_of_bytes     = 'd40; 
      dma_cfg.awsize          = 'd4;
      dma_cfg.arsize          = 'd4;
      dma_cfg.core            = 'd0;
      dma_cfg.ch              = 'd0;
      dma_cfg.m_no            = 'd1;
      dma_cfg.stop_after_transfer  = 'd2;
      dma_cfg.seqr                 = env.master_agt_1.sqr ;

     uvm_config_db #(axi_dma_configuration) ::set(null,"*","dma_cfg", dma_cfg);
 
 
     // start address for read
     burst_length = 5;
     wr_data    = new[burst_length];
     foreach(wr_data[i]) wr_data[i] = i*2;
     pw_seq.write_burst('d0, wr_data,burst_length, 'hF,env.master_agt_1.sqr,'d4);
     #300;

     dma_seq.start(env.master_agt_1.sqr);

    // dma_seq.dma_config(dma_cfg.start_address,dma_cfg.end_address,dma_cfg.no_of_bytes,dma_cfg.no_of_transfers,dma_cfg.core,dma_cfg.ch,dma_cfg.m_no,env.master_agt_1.sqr); 
     #5000;
     pr_seq.read_burst('h2000, 'd6,env.master_agt_1.sqr,'d4);
     #3000;
     phase.drop_objection (this);
     
   endtask


