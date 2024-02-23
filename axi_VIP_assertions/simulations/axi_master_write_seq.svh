/********************************************************************
 *
 *******************************************************************/

`ifndef axi_master_write_seq__
`define axi_master_write_seq__

class axi_master_write_seq extends uvm_sequence #(axi_seq_item);
  `uvm_object_utils(axi_master_write_seq)
  
  rand bit   [`AXI_MAX_AW-1:0]   addr;
  rand logic [`AXI_MAX_DW-1:0]   data [];
  rand bit   [`AXI_MAX_DW/8-1:0] byte_en;
  bit                       byte_en_first_custom;
  bit                       byte_en_last_custom;
  bit   [`AXI_MAX_DW/8-1:0] byte_en_last;
  rand int                       tr_size_in_bytes;
  rand int                       burst_length;
  rand logic [1:0]               bresp;
  bit check_4k_boundary = 0; // default: no check

  extern function new(string name="axi_master_write_seq");
  extern virtual task body();

  /// Write data
  /// - addr : Write address
  /// - data : Write data, right-aligned
  /// - byte_en : Byte enable bus. Width equals tr_size_in_bytes, right-aligned
  /// - seqr : Sequencer used to drive the transaction
  /// - tr_size_in_bytes : Transaction size in bytes
  /// - parent : Parent sequence (if NULL, sequence is a root parent)
  extern virtual task write(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  extern virtual task write_burst(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  extern virtual task write_burst_byte_en_first_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  extern virtual task write_burst_byte_en_last_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en_last,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  extern virtual task write_burst_byte_en_first_and_last_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en_last,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

endclass


function axi_master_write_seq::new(string name="axi_master_write_seq");
  super.new(name);
endfunction


task axi_master_write_seq::body();
  axi_seq_item tr;
  axi_seq_item resp;

  tr = axi_seq_item::type_id::create("axi_seq_item_tr");
  tr.data = new[this.burst_length];
  tr.byte_en = new[this.burst_length];
  tr.pipelined = 0;

  start_item(tr);
  tr.burst_length = this.burst_length;
  tr.addr = this.addr;
  tr.data = this.data;

  tr.byte_en[0] = this.byte_en;
  tr.byte_en_last = this.byte_en_last;
  tr.byte_en_first_custom = this.byte_en_first_custom;
  tr.byte_en_last_custom = this.byte_en_last_custom;
  tr.tr_size_in_bytes = this.tr_size_in_bytes;
  tr.op_type = AXI_WRITE;
  finish_item(tr);
  this.byte_en_first_custom = 0;
  this.byte_en_last_custom = 0;

  get_response(resp);
  bresp = resp.bresp;
endtask


task axi_master_write_seq::write(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  this.burst_length = 1;
  this.data = new[1];
  this.addr = addr;
  this.data[0] = data;
  this.byte_en = byte_en;
  this.tr_size_in_bytes = tr_size_in_bytes;
  this.start(seqr, parent);

  bresp = this.bresp;
endtask


task axi_master_write_seq::write_burst(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  this.burst_length = burst_length;
  this.data = new[burst_length];
  this.addr = addr;
  this.data = data;
  this.byte_en = byte_en;
  this.tr_size_in_bytes = tr_size_in_bytes;
  if (axi_common::check_burst(this.addr,INCR,this.burst_length,this.tr_size_in_bytes,check_4k_boundary)) begin
    `uvm_fatal(get_type_name(), "ERROR: inconsistent write burst parameters");
  end
  this.start(seqr, parent);

  bresp = this.bresp;
endtask


task axi_master_write_seq::write_burst_byte_en_first_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  this.burst_length = burst_length;
  this.data = new[burst_length];
  this.addr = addr;
  this.data = data;
  this.byte_en = byte_en; // first beat wstrb
  this.byte_en_first_custom = 1;
  this.tr_size_in_bytes = tr_size_in_bytes;
  if (axi_common::check_burst(this.addr,INCR,this.burst_length,this.tr_size_in_bytes,check_4k_boundary)) begin
    `uvm_fatal(get_type_name(), "ERROR: inconsistent write burst parameters");
  end
  this.start(seqr, parent);

  bresp = this.bresp;
endtask


task axi_master_write_seq::write_burst_byte_en_last_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en_last,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  this.burst_length = burst_length;
  this.data = new[burst_length];
  this.addr = addr;
  this.data = data;
  this.byte_en = byte_en; // first beat wstrb
  this.byte_en_last_custom = 1;
  this.byte_en_last = byte_en_last;
  this.tr_size_in_bytes = tr_size_in_bytes;
  if (axi_common::check_burst(this.addr,INCR,this.burst_length,this.tr_size_in_bytes,check_4k_boundary)) begin
    `uvm_fatal(get_type_name(), "ERROR: inconsistent write burst parameters");
  end
  this.start(seqr, parent);

  bresp = this.bresp;
endtask


task axi_master_write_seq::write_burst_byte_en_first_and_last_custom(
    input  bit   [`AXI_MAX_AW-1:0]   addr,
    input  logic [`AXI_MAX_DW-1:0]   data [],
    input  int                       burst_length,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en,
    input  bit   [`AXI_MAX_DW/8-1:0] byte_en_last,
    output logic [1:0]               bresp,
    input  uvm_sequencer_base        seqr,
    input  int                       tr_size_in_bytes = `AXI_MAX_DW/8,
    input  uvm_sequence_base         parent = null);

  this.burst_length = burst_length;
  this.data = new[burst_length];
  this.addr = addr;
  this.data = data;
  this.byte_en = byte_en; // first beat wstrb
  this.byte_en_first_custom = 1;
  this.byte_en_last_custom = 1;
  this.byte_en_last = byte_en_last;
  this.tr_size_in_bytes = tr_size_in_bytes;
  if (axi_common::check_burst(this.addr,INCR,this.burst_length,this.tr_size_in_bytes,check_4k_boundary)) begin
    `uvm_fatal(get_type_name(), "ERROR: inconsistent write burst parameters");
  end
  this.start(seqr, parent);

  bresp = this.bresp;
endtask

`endif


