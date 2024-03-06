`ifndef axi_burst_write_seq__
`define axi_burst_write_seq__


class axi_burst_write_seq extends uvm_sequence#(axi_seq_item);
   `uvm_object_utils(axi_burst_write_seq)

//   rand bit addr;
   rand bit [`AXI_MAX_AW-1:0] addr;      //    int addr;
   rand logic [`AXI_MAX_DW-1:0] payload []; //    bit[128-1:0] payload[];
   rand bit [`AXI_MAX_DW-1:0] byte_en;
   rand int size_in_bytes;            //    int size_in_bytes;
   rand int burst_len;                //    int burst_len;
   rand logic [1:0] bresp;


 

   extern function new(string name="axi_burst_write_seq");
   extern virtual task body();

    
/*
    function void do_record(uvm_recorder recorder);
	static int num;	
	super.do_record(recorder); 
//	`uvm_record_attribute(recorder.tr_handle, "addr", addr);
//	`uvm_record_attribute(recorder.tr_handle, "payload", payload);
	`uvm_record_field("num", num++ ); // increment some static data
    endfunction
*/

     
   extern virtual task write(input bit [`AXI_MAX_AW-1:0]   addr,
                             input logic [`AXI_MAX_DW-1:0] data,
                             input bit [`AXI_MAX_DW/8-1:0] byte_en,
                             output logic [1:0]            bresp,
                             input                         uvm_sequencer_base seqr,
                             input int                     tr_size_in_bytes = `AXI_MAX_DW/8,
                             input                         uvm_sequence_base parent = null);

   extern virtual task write_burst(input bit [`AXI_MAX_AW-1:0]   addr,
                                   input logic [`AXI_MAX_DW-1:0] data [],
                                   input int                     burst_length,
                                   input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                   output logic [1:0]            bresp,
                                   input                         uvm_sequencer_base seqr,
                                   input int                     tr_size_in_bytes = `AXI_MAX_DW/8,
                                   input                         uvm_sequence_base parent = null);

endclass : axi_burst_write_seq   

function axi_burst_write_seq::new(string name="axi_burst_write_seq");
   super.new(name);
endfunction

   
  task axi_burst_write_seq::body();
  
      //axi_seq_item item = new("item");
      //axi_seq_item resp = new("resp");
      axi_seq_item item;
      axi_seq_item resp;
    
       item = axi_seq_item::type_id::create("axi_seq_item_tr");
       resp = axi_seq_item::type_id::create("axi_seq_item_resp");
    
      start_item(item);

      item.randomize() with {
        addr == local::addr;

         burst_type == 2'b01;
         burst_length == burst_len;
        
         if (size_in_bytes == 16) {
           byte_en.size == 1; 
           byte_en[0] == 16'hFFFF;
         } else if (size_in_bytes == 8) {
           byte_en.size == 2; 
           byte_en[0] == 16'h00FF;
           byte_en[1] == 16'hFF00;
         } else if (size_in_bytes == 4){
           byte_en.size == 4;
           byte_en[0] == 16'h000F;
           byte_en[1] == 16'h00F0;
           byte_en[2] == 16'h0F00;
           byte_en[3] == 16'hF000;
         } else if (size_in_bytes == 2){
           byte_en.size == 8;
           byte_en[0] == 16'h0003;
           byte_en[1] == 16'h000C;
           byte_en[2] == 16'h0030;
           byte_en[3] == 16'h00C0;
           byte_en[4] == 16'h0300;
           byte_en[5] == 16'h0C00;
           byte_en[6] == 16'h3000;
           byte_en[7] == 16'hC000;
         } else {
           byte_en.size == 16;
           byte_en[0] == 16'h0001;
           byte_en[1] == 16'h0002;
           byte_en[2] == 16'h0004;
           byte_en[3] == 16'h0008;
           byte_en[4] == 16'h0010;
           byte_en[5] == 16'h0020;
           byte_en[6] == 16'h0040;
           byte_en[7] == 16'h0080;
           byte_en[8] == 16'h0100;
           byte_en[9] == 16'h0200;
           byte_en[10] == 16'h0400;
           byte_en[11] == 16'h0800;
           byte_en[12] == 16'h1000;
           byte_en[13] == 16'h2000;
           byte_en[14] == 16'h4000;
           byte_en[15] == 16'h8000;
         }

         data.size == burst_length;
         foreach (data[i]) {
           data[i] == payload[i];
         }

         tr_size_in_bytes == size_in_bytes;
         op_type == axi_agent_pkg::AXI_WRITE;

         rresp.size == 0;

      };


      finish_item(item);
     
      get_response(resp);
   endtask : body

task axi_burst_write_seq::write(input bit [`AXI_MAX_AW-1:0]   addr,
                                    input logic [`AXI_MAX_DW-1:0] data,
                                    input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                    output logic [1:0]                 bresp,
                                    input                              uvm_sequencer_base seqr,
                                    input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                                    input                              uvm_sequence_base parent = null);

   this.burst_len = 1;
   this.payload = new[1];
   this.addr = addr;
   this.payload[0] = data;
   this.byte_en = byte_en;
   this.size_in_bytes = tr_size_in_bytes;
   this.start(seqr, parent);

   bresp = this.bresp;

endtask

task axi_burst_write_seq::write_burst(input bit [`AXI_MAX_AW-1:0]   addr,
                                          input logic [`AXI_MAX_DW-1:0] data [],
                                          input int                          burst_length,
                                          input bit [`AXI_MAX_DW/8-1:0] byte_en,
                                          output logic [1:0]                 bresp,
                                          input                              uvm_sequencer_base seqr,
                                          input int                          tr_size_in_bytes = `AXI_MAX_DW/8,
                                          input                              uvm_sequence_base parent = null);

   this.burst_len = burst_length;
   this.payload = new[burst_length];
   this.addr = addr;
   this.payload = data;
   this.byte_en = byte_en;
   this.size_in_bytes = tr_size_in_bytes;
   this.start(seqr, parent);

   bresp = this.bresp;

endtask

`endif


