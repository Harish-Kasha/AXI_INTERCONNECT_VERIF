 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_PIPELINE_WRITE_SEQ__SVH
`define AXI_PIPELINE_WRITE_SEQ__SVH

class axi_pipeline_write_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(axi_pipeline_write_seq)

   rand bit [`AXI_MAX_AW-1:0] addr;
   rand logic [`AXI_MAX_DW-1:0] data [];
   rand bit [`AXI_MAX_DW-1:0] byte_en;
   rand int tr_size_in_bytes;
   rand int burst_length;
   rand logic [1:0] bresp;
   bit pipelined;

   extern function new(string name="axi_pipeline_write_seq");
   extern virtual task body();

   /// Write data
   /// - addr : Write address
   /// - data : Write data, right-aligned
   /// - byte_en : Byte enable bus. Width equals tr_size_in_bytes, right-aligned
   /// - seqr : Sequencer used to drive the transaction
   /// - tr_size_in_bytes : Transaction size in bytes
   /// - parent : Parent sequence (if NULL, sequence is a root parent)
   extern virtual task write(input bit [`AXI_MAX_AW-1:0]   addr,
                             input logic [`AXI_MAX_DW-1:0] data,
                             input bit [`AXI_MAX_DW/8-1:0] byte_en,
                             input                              uvm_sequencer_base seqr,
                             input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                             input                              uvm_sequence_base parent = null);

   extern virtual task write_burst(input bit [`AXI_MAX_AW-1:0]   addr,
                                   input logic [`AXI_MAX_DW-1:0] data [],
                                   input int                          burst_length,
                                   input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                   input                              uvm_sequencer_base seqr,
                                   input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                                   input                              uvm_sequence_base parent = null);

   extern virtual task write_burst_ba(input bit [7:0] addr [],
                                      input bit [7:0] data [][],
                                      input int burst_length,
                                      input bit byte_en [],
                                      input uvm_sequencer_base seqr,
                                      input int tr_size_in_bytes,
                                      input uvm_sequence_base parent = null);

endclass

function axi_pipeline_write_seq::new(string name="axi_pipeline_write_seq");
   super.new(name);
endfunction

task axi_pipeline_write_seq::body();
   axi_seq_item tr;
   axi_seq_item resp;

   tr = axi_seq_item::type_id::create("axi_seq_item_tr");
   tr.data = new[burst_length];
   tr.byte_en = new[burst_length];
   
   start_item(tr);
   tr.burst_length = burst_length;
   tr.addr = addr;
   tr.data = data;
   tr.pipelined = pipelined;
   tr.byte_en[0] = byte_en;
   tr.tr_size_in_bytes = tr_size_in_bytes;
   tr.op_type = AXI_WRITE;
   tr.burst_type = 1;
   finish_item(tr);
   
endtask


task axi_pipeline_write_seq::write(input bit [`AXI_MAX_AW-1:0]   addr,
                                    input logic [`AXI_MAX_DW-1:0] data,
                                    input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                    input                              uvm_sequencer_base seqr,
                                    input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                                    input                              uvm_sequence_base parent = null);

   this.burst_length = 1;
   this.data = new[1];
   this.addr = addr;
   this.data[0] = data;
   this.byte_en = byte_en;
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.pipelined = 1;
   this.start(seqr, parent);
`uvm_info(get_full_name,"from pipeline write seq",UVM_NONE)
endtask

task axi_pipeline_write_seq::write_burst(input bit [`AXI_MAX_AW-1:0]   addr,
                                          input logic [`AXI_MAX_DW-1:0] data [],
                                          input int                          burst_length,
                                          input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                          input                              uvm_sequencer_base seqr,
                                          input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                                          input                              uvm_sequence_base parent = null);

   this.burst_length = burst_length;
   this.data = new[burst_length];
   this.addr = addr;
   this.data = data;
   this.byte_en = byte_en;
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.pipelined = 1;
   this.start(seqr, parent);

endtask

task axi_pipeline_write_seq::write_burst_ba(input bit [7:0] addr [],
                                            input bit [7:0] data [][],
                                            input int burst_length,
                                            input bit byte_en [],
                                            input uvm_sequencer_base seqr,
                                            input int tr_size_in_bytes,
                                            input uvm_sequence_base parent = null);

   if (addr.size() > `AXI_MAX_AW/8 || data[0].size() > `AXI_MAX_DW/8 || byte_en.size() > `AXI_MAX_DW/8)
      `uvm_fatal("Array size error", $sformatf("Input array size too big. addr: %0d, data: %0d, byte_en: %0d. Max addr size: %0d. Max data size: %0d.", 
         addr.size(), data[0].size(), byte_en.size(), `AXI_MAX_AW, `AXI_MAX_DW))  
   
   this.burst_length = burst_length;
   this.data = new[burst_length];
   this.addr = {<<8{addr}};
   foreach (byte_en[i])
      this.byte_en[i] = byte_en[i];
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.pipelined = 1;
   foreach (data[i])
      this.data[i] = {<<8{data[i]}};

   this.start(seqr, parent);

endtask

`endif


