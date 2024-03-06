 /********************************************************************
 *
 *******************************************************************/

`ifndef _AXI_SLAVE_SEQUENCER__SVH
`define _AXI_SLAVE_SEQUENCER__SVH

class axi_slave_sequencer extends uvm_sequencer #(axi_seq_item);

   `uvm_component_utils(axi_slave_sequencer)

  extern function new (string name="", uvm_component parent = null);

endclass : axi_slave_sequencer

function axi_slave_sequencer::new (string name="", uvm_component parent = null);
   super.new(name, parent);
endfunction : new

`endif


