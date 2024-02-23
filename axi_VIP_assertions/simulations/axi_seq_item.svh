 /********************************************************************
 *
 *******************************************************************/

`ifndef AXI_SEQ_ITEM_SV
`define AXI_SEQ_ITEM_SV

class axi_seq_item extends uvm_sequence_item;

   rand bit [`AXI_MAX_AW-1:0] addr;
   rand logic [`AXI_MAX_DW-1:0] data [];
   rand int burst_length;
   rand int burst_type;
   rand bit [`AXI_MAX_DW/8-1:0] byte_en []; ///< tr_size_in_bytes lowest bits used as byte enable for data
   bit  				   byte_en_first_custom;
   bit  				   byte_en_last_custom;
   bit [`AXI_MAX_DW/8-1:0] byte_en_last;
   rand int tr_size_in_bytes;
   rand int size;
   rand axi_agent_pkg::axi_op_type_t op_type; ///< AXI_WRITE, AXI_READ
   bit use_last_signaling;
   bit pipelined;
   bit between_pipelined_access;
   rand int id;
   rand logic [1:0] bresp; ///< write response from AXI bus
   rand logic [1:0] rresp []; ///< read response from AXI bus
   rand logic [2:0] prot;
   
   int transaction_cycles; ///< Latency of transaction
   int num_timeout_cycles;
   real start_time;
   real end_time;
   real total_time;
   real end_of_rw;
   int data_amount_in_bits;
   int data_amount_in_bytes;
   real bw_in_bits;
   real bw_in_bytes;
   
   axi_delay_vars delay_vars;
   
   string parent;

   `uvm_object_param_utils_begin (axi_seq_item)
	   `uvm_field_int (id, UVM_ALL_ON);
	   `uvm_field_int (prot, UVM_ALL_ON);
       `uvm_field_int (addr, UVM_ALL_ON);
       `uvm_field_array_int (data,   UVM_ALL_ON);
       `uvm_field_int (burst_length, UVM_ALL_ON);
	   `uvm_field_int (burst_type, UVM_ALL_ON);
       `uvm_field_array_int (byte_en,   UVM_ALL_ON);
       `uvm_field_int (byte_en_first_custom,   UVM_ALL_ON);
       `uvm_field_int (byte_en_last_custom,   UVM_ALL_ON);
       `uvm_field_int (byte_en_last, UVM_ALL_ON);
       `uvm_field_int (tr_size_in_bytes,   UVM_ALL_ON);
       `uvm_field_int (transaction_cycles,   UVM_ALL_ON);
       `uvm_field_enum(axi_op_type_t, op_type, UVM_ALL_ON);
       `uvm_field_int (bresp, UVM_ALL_ON);
       `uvm_field_array_int (rresp, UVM_ALL_ON);
   `uvm_object_utils_end

   constraint tr_size_c {tr_size_in_bytes <= `AXI_MAX_DW/8;} // hk: limiting transfer axsize to Data Width of the bus

   extern function new (string name = "axi_seq_item");
   extern virtual function void print ();

endclass: axi_seq_item

function axi_seq_item::new (string name = "axi_seq_item");
   super.new (name);
   delay_vars = axi_delay_vars::type_id::create("delay_vars");
endfunction

function void axi_seq_item::print ();
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("addr    = %0h", addr), UVM_HIGH)
   foreach (data[i]) begin
      `uvm_info ("AXI_SEQ_ITEM", $sformatf ("data[%0d] = %0h", i, data[i]), UVM_HIGH)
   end
   foreach (byte_en[i]) begin
      `uvm_info ("AXI_SEQ_ITEM", $sformatf ("byte_en[%0d] = %0h", i, byte_en[i]), UVM_HIGH)
   end
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("tr_size_in_bytes = %0h", tr_size_in_bytes), UVM_HIGH)
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("op_type = %0h", op_type), UVM_HIGH)
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("transaction_cycles = %0h", transaction_cycles), UVM_HIGH)
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("op_type = %0s", op_type), UVM_HIGH)
   `uvm_info ("AXI_SEQ_ITEM", $sformatf ("bresp = %0h", bresp), UVM_HIGH)
   foreach (rresp[i]) begin
      `uvm_info ("AXI_SEQ_ITEM", $sformatf ("rresp[%0d] = %0h", i, rresp[i]), UVM_HIGH)
   end
endfunction

`endif // AXI_SEQ_ITEM_SV

