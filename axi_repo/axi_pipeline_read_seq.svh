 /********************************************************************
 *
 *******************************************************************/

`ifndef axi_pipeline_read_seq__
`define axi_pipeline_read_seq__

class axi_pipeline_read_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(axi_pipeline_read_seq)

   rand bit [`AXI_MAX_AW-1:0] addr;
   rand int tr_size_in_bytes;
   rand logic [`AXI_MAX_DW-1:0] data [];
   rand logic [1:0] rresp [];
   rand int burst_length;
   bit pipelined;

   extern function new(string name="axi_pipeline_read_seq");
   extern virtual task body();

   /// Read data
   /// - addr : Read address
   /// - data : Read data, right-aligned
   /// - seqr : Sequencer used to drive the transaction
   /// - check : Check data against ref_val
   /// - ref_val: Reference value in data compare
   /// - tr_size_in_bytes : Transaction size in bytes
   /// - parent : Parent sequence (if NULL, sequence is a root parent)
   extern virtual task read(input bit [`AXI_MAX_AW-1:0]    addr,
                            input                               uvm_sequencer_base seqr,
                            input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                            input                               uvm_sequence_base parent = null);

   extern virtual task read_burst(input bit [`AXI_MAX_AW-1:0]    addr,
                                  input int                           burst_length,
                                  input                               uvm_sequencer_base seqr,
                                  input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                  input                               uvm_sequence_base parent = null);

endclass

function axi_pipeline_read_seq::new(string name="axi_pipeline_read_seq");
   super.new(name);
endfunction : new

task axi_pipeline_read_seq::body();
   axi_seq_item tr;
   axi_seq_item resp;

   tr   = axi_seq_item::type_id::create("axi_seq_item_tr");
   resp = axi_seq_item::type_id::create("axi_seq_item_resp");

   data = new[burst_length];
   rresp = new[burst_length];
   tr.data = data;
   tr.rresp = rresp;
      
   start_item(tr);
   tr.burst_length = burst_length;
   tr.addr = addr;
   tr.pipelined = pipelined;
   tr.tr_size_in_bytes = tr_size_in_bytes;
   tr.op_type = AXI_READ;
   finish_item(tr);

endtask

task axi_pipeline_read_seq::read(input bit [`AXI_MAX_AW-1:0]    addr,
                                 input                               uvm_sequencer_base seqr,
                                 input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                 input                               uvm_sequence_base parent = null);

   logic [`AXI_MAX_DW-1:0] data_i;

   this.burst_length = 1;
   this.addr = addr;
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.pipelined = 1;
   this.start(seqr, parent);

endtask

task axi_pipeline_read_seq::read_burst(input bit [`AXI_MAX_AW-1:0]    addr,
                                        input int                           burst_length,
                                        input                               uvm_sequencer_base seqr,
                                        input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                        input                               uvm_sequence_base parent = null);

   this.burst_length = burst_length;
   this.addr = addr;
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.pipelined = 1;
   this.start(seqr, parent);

endtask

`endif

