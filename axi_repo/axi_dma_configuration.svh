class axi_dma_configuration extends uvm_object;
  `uvm_object_utils(axi_dma_configuration)
  
  bit core;
  bit [2:0]ch;
  int m_no;
  uvm_sequencer_base seqr;
 // int no_of_transfers;
  int awsize;
  int arsize;
  int no_of_bytes;
  int start_address;
  int end_address;
  int stop_after_transfer; 
  extern function new(string name = "axi_dma_configuration");

endclass: axi_dma_configuration

function axi_dma_configuration::new(string name = "axi_dma_configuration");
   super.new(name);
endfunction
   

