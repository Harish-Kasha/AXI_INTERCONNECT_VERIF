 /********************************************************************
 *
 *******************************************************************/

`ifndef axi_master_read_seq__
`define axi_master_read_seq__

class axi_master_read_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(axi_master_read_seq)

   rand bit [`AXI_MAX_AW-1:0] addr;
   rand int tr_size_in_bytes;
   rand logic [`AXI_MAX_DW-1:0] data [];
   rand logic [1:0] rresp [];
   rand int burst_length;
   bit check_4k_boundary = 0; // default: no check

   extern function new(string name="axi_master_read_seq");
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
                            output logic [`AXI_MAX_DW-1:0] data,
                            output logic [1:0]                  rresp,
                            input                               uvm_sequencer_base seqr,
                            input bit                           check = 0,
                            input logic [`AXI_MAX_DW-1:0]  ref_val = 0,
                            input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                            input                               uvm_sequence_base parent = null);

   extern virtual task read_burst(input bit [`AXI_MAX_AW-1:0]    addr,
                                  output logic [`AXI_MAX_DW-1:0] data [],
                                  input int                           burst_length,
                                  output logic [1:0]                  rresp [],
                                  input                               uvm_sequencer_base seqr,
                                  input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                  input                               uvm_sequence_base parent = null);

endclass

function axi_master_read_seq::new(string name="axi_master_read_seq");
   super.new(name);
endfunction : new

task axi_master_read_seq::body();
   axi_seq_item tr;
   axi_seq_item resp;

   tr   = axi_seq_item::type_id::create("axi_seq_item_tr");
   resp = axi_seq_item::type_id::create("axi_seq_item_resp");

   data = new[burst_length];
   rresp = new[burst_length];
   tr.data = data;
   tr.rresp = rresp;
   tr.pipelined = 0;
   
   start_item(tr);
   tr.burst_length = burst_length;
   tr.addr = addr;
   tr.tr_size_in_bytes = tr_size_in_bytes;
   tr.op_type = AXI_READ;
   finish_item(tr);

   get_response(resp);
   data = resp.data;
   rresp = resp.rresp;

endtask

task axi_master_read_seq::read(input bit [`AXI_MAX_AW-1:0]    addr,
                                  output logic [`AXI_MAX_DW-1:0] data,
                                  output logic [1:0]                  rresp,
                                  input                               uvm_sequencer_base seqr,
                                  input bit                           check = 0,
                                  input logic [`AXI_MAX_DW-1:0]  ref_val = 0,
                                  input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                  input                               uvm_sequence_base parent = null);

   logic [`AXI_MAX_DW-1:0] data_i;

   this.burst_length = 1;
   this.addr = addr;
   this.tr_size_in_bytes = tr_size_in_bytes;
   this.start(seqr, parent);

   rresp = this.rresp[0];
   data_i = this.data[0];

   for(int i = `AXI_MAX_DW-1; i >= tr_size_in_bytes*8; i--)
     data_i[i] = 0;
   data = data_i;

   if (check == 1) begin
      if (data_i !== ref_val) begin
         `uvm_error("AXI VIP :: MASTER",$sformatf("0x%0h data not expected: exp: 0x%0h, act: 0x%0h", addr, ref_val, data_i));
      end else
        `uvm_info("AXI VIP :: MASTER", $sformatf("0x%0h data as expected: 0x%0h", addr, data_i), UVM_MEDIUM);
   end

endtask

task axi_master_read_seq::read_burst(input bit [`AXI_MAX_AW-1:0]    addr,
                                        output logic [`AXI_MAX_DW-1:0] data [],
                                        input int                           burst_length,
                                        output logic [1:0]                  rresp [],
                                        input                               uvm_sequencer_base seqr,
                                        input int                           tr_size_in_bytes = `AXI_MAX_DW/8,
                                        input                               uvm_sequence_base parent = null);

   this.burst_length = burst_length;
   this.addr = addr;
   this.tr_size_in_bytes = tr_size_in_bytes;
   if (axi_common::check_burst(this.addr,INCR,this.burst_length,this.tr_size_in_bytes,check_4k_boundary)) begin
     `uvm_fatal(get_type_name(), "ERROR: inconsistent read burst parameters");
   end
   this.start(seqr, parent);

   rresp = this.rresp;
   data = this.data;
   for(int j = 0; j < burst_length; j++) begin
      for(int i = `AXI_MAX_DW-1; i >= tr_size_in_bytes*8; i--)
        data[j][i] = 0;
   end
endtask

`endif

