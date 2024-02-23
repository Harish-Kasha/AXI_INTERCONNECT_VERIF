 /********************************************************************
 *******************************************************************/


  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_defines.svh"

class axi_common;
   extern static function void shift_data_left(input bit [`AXI_MAX_AW-1:0]    addr,
                                      input logic [`AXI_MAX_DW-1:0]  in_data,
                                      output logic [`AXI_MAX_DW-1:0] out_data,
                                      input int                           tr_size_in_bytes,
                                      input bit                           byte_en_shift,
                                      input int                           data_width);
   extern static function void shift_data_right(input bit [`AXI_MAX_AW-1:0]    addr,
                                       input logic [`AXI_MAX_DW-1:0]  in_data,
                                       output logic [`AXI_MAX_DW-1:0] out_data,
                                       input int                           tr_size_in_bytes,
                                       input bit                           byte_en_shift,
                                       input int                           data_width);
   extern static function bit check_burst(input bit [`AXI_MAX_AW-1:0] start_addr,
                                          input axi_agent_pkg::burst_type_t burst_type,
                                          input int                   burst_length,
                                          input int                   tr_size_in_bytes,
									      input bit                   check_4k_boundary = 0);
endclass: axi_common

/// Shift write data (or byte enable bus) in AXI data bus based on address LSbits
/// tr_size is transaction size in bytes
/// byte_en_shift: 0 - shift data, 1 - shift byte enables
function void axi_common::shift_data_left(input bit [`AXI_MAX_AW-1:0]    addr,
                                      input logic [`AXI_MAX_DW-1:0]  in_data,
                                      output logic [`AXI_MAX_DW-1:0] out_data,
                                      input int                           tr_size_in_bytes,
                                      input bit                           byte_en_shift,
                                      input int                           data_width);
   int shift_mult;

   if (byte_en_shift == 1'b0)
     shift_mult = 8;
   else
     shift_mult = 1;

   case (data_width/8) // Bytes in bus
     1:   out_data = in_data;
     2:   out_data = in_data << shift_mult*addr[0];
     4:   out_data = in_data << shift_mult*addr[1:0];
     8:   out_data = in_data << shift_mult*addr[2:0];
     16:  out_data = in_data << shift_mult*addr[3:0];
     32:  out_data = in_data << shift_mult*addr[4:0];
     64:  out_data = in_data << shift_mult*addr[5:0];
     128: out_data = in_data << shift_mult*addr[6:0];
   endcase
endfunction

/// Shift read data in AXI data bus based on address LSbits
/// tr_size is transaction size in bytes
/// byte_en_shift: 0 - shift data, 1 - shift byte enables
function void axi_common::shift_data_right(input bit [`AXI_MAX_AW-1:0]   addr,
                                       input logic [`AXI_MAX_DW-1:0]  in_data,
                                       output logic [`AXI_MAX_DW-1:0] out_data,
                                       input int                           tr_size_in_bytes,
                                       input bit                           byte_en_shift,
                                       input int                           data_width);
   int shift_mult;

   if (byte_en_shift == 1'b0)
     shift_mult = 8;
   else
     shift_mult = 1;

   case (data_width/8) // Bytes in bus
     1:   out_data = in_data;
     2:   out_data = in_data >> shift_mult*addr[0];
     4:   out_data = in_data >> shift_mult*addr[1:0];
     8:   out_data = in_data >> shift_mult*addr[2:0];
     16:  out_data = in_data >> shift_mult*addr[3:0];
     32:  out_data = in_data >> shift_mult*addr[4:0];
     64:  out_data = in_data >> shift_mult*addr[5:0];
     128: out_data = in_data >> shift_mult*addr[6:0];
   endcase
endfunction

// Check burst
function bit axi_common::check_burst(input bit [`AXI_MAX_AW-1:0] start_addr,
                         			 input axi_agent_pkg::burst_type_t burst_type,
                         			 input int  				 burst_length,
                         			 input int  				 tr_size_in_bytes,
									 input bit                   check_4k_boundary = 0
						 			 );
  const int AXI_VIP_MAX_BURST_LENGTH = `AXI_VIP_MAX_BURST_LENGTH;
  const int AXI_VIP_MAX_BURST_LENGTH_INCR = `AXI_VIP_MAX_BURST_LENGTH_INCR;
  if (burst_type == axi_agent_pkg::INCR && burst_length > AXI_VIP_MAX_BURST_LENGTH_INCR) begin
    `uvm_warning("In function check_burst:",$sformatf("Burst INCR length (%0d) must not exceed %0d", burst_length,AXI_VIP_MAX_BURST_LENGTH_INCR));
	return 1;
  end else if (burst_type == axi_agent_pkg::WRAP && !(burst_length == 2 || burst_length == 4 || burst_length == 8 || burst_length == 16)) begin
    `uvm_warning("In function check_burst: ",$sformatf("Burst WRAP length (%0d) must not exceed %0d",burst_length,AXI_VIP_MAX_BURST_LENGTH));
	return 1;
  end else if (check_4k_boundary == 1 && (start_addr%4096 + burst_length*tr_size_in_bytes > 4096)) begin
    `uvm_warning("In function check_burst:",$sformatf("Burst INCR 4K boundary crossed for start_addr=%h(%0d), burst_length=%0d, beat_size=%0d",start_addr,start_addr,burst_length,tr_size_in_bytes));
	return 1;
  end else begin
    `uvm_info("In function check_burst:","In function check_burst: OK",UVM_MEDIUM);
	return 0;
  end
endfunction : check_burst

