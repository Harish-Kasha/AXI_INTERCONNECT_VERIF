/********************************************************************
 *
 * Project     : AXI VIP
 * File        : axi_adapter.svh
 * Description : RAL adapter for AXI master agent
 *
 *
 *******************************************************************/

class axi_adapter extends uvm_reg_adapter;

   `uvm_object_utils(axi_adapter)

   extern function new(string name = "axi_adapter");

   /// reg2bus:register trans to bus trans;
   extern virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);

   /// bus2reg: bus trans to register trans;
   extern virtual function void bus2reg (uvm_sequence_item bus_item,
                                         ref uvm_reg_bus_op rw);

   bit fix_tr_size = 0;
   int fixed_tr_size = 4;
   bit fixed_reg_tr_size = 1;
   bit enable_debug_messages = 1'b0;

endclass

function axi_adapter::new(string name = "axi_adapter");
   super.new(name);
   supports_byte_enable = 1;
   provides_responses = 1;
endfunction

function uvm_sequence_item axi_adapter::reg2bus (const ref uvm_reg_bus_op rw);
  int tr_size;
  axi_seq_item bus = axi_seq_item::type_id::create("bus");
  uvm_reg_item reg_item = get_item();

  if (fix_tr_size == 1)
    tr_size = fixed_tr_size;
  else if (reg_item.element_kind != UVM_MEM) begin
    // Only 32bit accesses supported to registers
    if(fixed_reg_tr_size) begin
      //`uvm_info("AXI ADAPTER","Accessing register tr_size fixed to 4", UVM_DEBUG)
      tr_size = 4;
    end else begin
      //`uvm_info("AXI ADAPTER","Accessing register tr_size from reg_map", UVM_DEBUG)
      tr_size = reg_item.local_map.get_n_bytes(UVM_HIER);
    end
  end
  else begin
     if (rw.n_bits <= 8)
       tr_size = 1;
     else if (rw.n_bits <= 16)
       tr_size = 2;
     else if (rw.n_bits <= 32)
       tr_size = 4;
     else if (rw.n_bits <= 64)
       tr_size = 8;
     else if (rw.n_bits <= 128)
       tr_size = 16;
     else if (rw.n_bits <= 256)
       tr_size = 32;
     else if (rw.n_bits <= 512)
       tr_size = 64;
     else if (rw.n_bits <= 1024)
       tr_size = 128;
  end

  bus.data = new[1];
  bus.byte_en = new[1];
 
  bus.burst_length = 1;
  bus.op_type = ((rw.kind == UVM_READ) ? AXI_READ:AXI_WRITE);
  bus.addr    = rw.addr;
  bus.data[0] = rw.data;
  bus.byte_en[0] = rw.byte_en;

  bus.tr_size_in_bytes = tr_size;

   if (this.enable_debug_messages == 1'b1) begin
     `uvm_info ("AXI ADAPTER", $sformatf ("reg2bus rw.data = %0h", rw.data), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("reg2bus rw.addr = %0h", rw.addr), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("reg2bus bus.byte_en[0] = %0h", bus.byte_en[0]), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("reg2bus rw.n_bits = %0d", rw.n_bits), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("reg2bus bus.tr_size_in_bytes = %0d", bus.tr_size_in_bytes), UVM_DEBUG);
   end
   
   return bus;
endfunction

function void axi_adapter::bus2reg (uvm_sequence_item bus_item,
                                         ref uvm_reg_bus_op rw);
   axi_seq_item bus;
   if (!$cast(bus,bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE","Provided bus_item is not of the correct type")
      return;
   end
   rw.kind = ((bus.op_type == AXI_READ) ? UVM_READ : UVM_WRITE);
   rw.addr = bus.addr;
   rw.data = bus.data[0];
  if (bus.op_type == AXI_WRITE)
    rw.byte_en = bus.byte_en[0];
  
   if (this.enable_debug_messages == 1'b1) begin
     `uvm_info ("AXI ADAPTER", $sformatf ("bus2reg rw.addr = %0h", rw.addr), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("bus2reg rw.data  = %0h", rw.data ), UVM_DEBUG);
     `uvm_info ("AXI ADAPTER", $sformatf ("bus2reg rw.byte_en  = %0h", rw.byte_en ), UVM_DEBUG);
   end
  
endfunction

