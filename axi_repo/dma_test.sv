
 //***********************************************************************************************************************************************************
 //	File_name   : dma_test.sv
 //     Description : This class is going to test the acceptance limit of the crossbar 
 //***********************************************************************************************************************************************************
`include "axi_defines.svh"
class dma_test extends axi_interconnect_base_test;
   `uvm_component_utils(dma_test)

   dma_config_seq          dma_cfg_seq;
   axi_pipeline_write_seq  pw_seq;
   axi_pipeline_read_seq   pr_seq;

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern task run_phase (uvm_phase phase);

endclass

   //constructor
   function dma_test::new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   //build_phase
   function void dma_test::build_phase(uvm_phase phase);
      super.build_phase(phase);  
   endfunction: build_phase
   
   //run_phase
   task dma_test::run_phase (uvm_phase phase);
     logic  [`AXI_MAX_DW-1:0] wr_data        [];

     phase.raise_objection (this);

     pw_seq = axi_pipeline_write_seq::type_id::create("pw_seq");
     pr_seq = axi_pipeline_read_seq::type_id::create("pr_seq");
     dma_cfg_seq = dma_config_seq::type_id::create("dma_cfg_seq");
     
     // start address for read
     wr_data    = new[6];
     foreach(wr_data[i]) wr_data[i] = i;
     pw_seq.write_burst('d0, wr_data, 'd6, 'hF,env.master_agt_1.sqr,'d4);
     #300;

     dma_cfg_seq.dma_config(S0_START,S1_START,'d24,env.master_agt_1.sqr); 
     #5000;
     pr_seq.read_burst('h2000, 'd6,env.master_agt_1.sqr,'d4);
     #3000;
     phase.drop_objection (this);
     
   endtask





