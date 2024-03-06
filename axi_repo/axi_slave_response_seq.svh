 /********************************************************************
 *
 *******************************************************************/

`ifndef _AXI_SLAVE_RESPONSE_SEQ__SVH
`define _AXI_SLAVE_RESPONSE_SEQ__SVH

//ONLY HERE FOR BACKWARDS COMPATIBILITY - DO NOT USE

class axi_slave_response_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(axi_slave_response_seq)
   `uvm_declare_p_sequencer(axi_slave_sequencer)

   function new(string name="axi_slave_response_seq");
      super.new(name);
   endfunction

   extern virtual task body();

endclass : axi_slave_response_seq

task axi_slave_response_seq::body();

   axi_seq_item req;
   axi_seq_item item;
   axi_seq_item resp;

   forever begin


      $cast(item, req.clone());

      case(req.op_type)
         AXI_WRITE : begin
            start_item(item);
            finish_item(item);
         end
         AXI_READ : begin
            start_item(item);
            finish_item(item);
         end
      endcase

   get_response(resp);

   end

endtask

`endif


