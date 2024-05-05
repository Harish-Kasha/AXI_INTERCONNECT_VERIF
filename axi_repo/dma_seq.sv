class axi_dma_configuration extends uvm_object;
  `uvm_object_utils(axi_dma_configuration)
  
  bit core;
  bit [3:0]ch[2];
 // int no_m;
  uvm_sequencer#(axi_seq_item) seqr;
  int burst_length;
  int no_of_bytes;
  int start_address;
  int end_address;
  
  extern function new(string name = "axi_dma_configuration");

endclass: axi_dma_configuration

function axi_dma_configuration::new(string name = "axi_dma_configuration");
   super.new(name);
endfunction
   

