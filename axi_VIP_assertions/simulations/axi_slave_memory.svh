/********************************************************************
 *
 *******************************************************************/

 `ifndef _AXI_SLAVE_MEMORY__SVH
 `define _AXI_SLAVE_MEMORY__SVH

class axi_slave_memory extends uvm_object;

	`uvm_object_utils(axi_slave_memory)

  //Internal memory array
  logic [`AXI_MAX_DW-1:0] mem[bit[`AXI_MAX_AW-1:0]];//'{default : 0};

	axi_agent_configuration cfg;
   bit debug_verbosity = 0;
	bit [`AXI_MAX_AW-1:0] addr_to_cause_error;
	bit enable_error = 0;

   extern function new(string name = "axi_slave_memory"); //, uvm_component parent = null);

   extern function void backdoor_write(input bit [`AXI_MAX_AW-1:0] addr, input logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);
   extern function void backdoor_read(input bit [`AXI_MAX_AW-1:0] addr, output logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);
   extern function int write(input bit [`AXI_MAX_AW-1:0] addr, input logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes, input bit [`AXI_MAX_DW/8-1:0] byte_en);
   extern function int read(input bit [`AXI_MAX_AW-1:0] addr, output logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);
   extern task init(bit v, bit [`AXI_MAX_AW-1:0] error_addr, bit enable_addr_to_cause_error);

endclass : axi_slave_memory

function axi_slave_memory::new(string name = "axi_slave_memory"); //, uvm_component parent = null);
   super.new(name); //, parent);
endfunction

task axi_slave_memory::init(bit v, bit [`AXI_MAX_AW-1:0] error_addr, bit enable_addr_to_cause_error);
	
	enable_error = enable_addr_to_cause_error;
	addr_to_cause_error = error_addr;
   debug_verbosity = v;   

endtask

function void axi_slave_memory::backdoor_read(input bit [`AXI_MAX_AW-1:0] addr, output logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);

  int memory_row;
  int lsbyte;

  memory_row = addr / ( `AXI_MAX_DW / 8 ); /* data row in memory */
  lsbyte = addr % ( `AXI_MAX_DW / 8 ); /* offset to the least significant byte of the data to be read */

  if(addr % tr_size_in_bytes) begin
     if(debug_verbosity) begin
         `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR READ Unaligned read address: %x", addr), UVM_DEBUG); /*check alignment*/
     end
     //TODO: Check if misalignment might cause problems.
  end
  
  if(mem.exists(memory_row)) begin
    for( int i=0; i < tr_size_in_bytes; i++ )
    data[i*8 +: 8] = mem[ memory_row ][ (lsbyte + i) * 8 +: 8 ];
    if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR READ Reading from memory location: %x, data: %x, tr_size: %0d ", addr, data, tr_size_in_bytes), UVM_DEBUG);

    return;

  end
  else begin
      mem[ memory_row ] = 0;
      for( int i=0; i < tr_size_in_bytes; i++ )
      data[i*8 +: 8] = mem[ memory_row ][ (lsbyte + i) * 8 +: 8];
       if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR READ Memory location: %x was not initialized. Set data: %x, tr_size: %0d ", addr, data, tr_size_in_bytes), UVM_DEBUG);

      return;
  end

  data = 0;
  if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR READ memory location: %x empty", addr), UVM_DEBUG);

endfunction


function void axi_slave_memory::backdoor_write(input bit [`AXI_MAX_AW-1:0] addr, input logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);

  int memory_row;
  int lsbyte;
  int bytes_per_row = `AXI_MAX_DW/8;
  int misalignment;
  logic [`AXI_MAX_DW/8-1:0] byte_en;
  
  logic [`AXI_MAX_DW-1:0] tail_data;
  int next_row_addr;

  memory_row = addr / ( `AXI_MAX_DW / 8 ); /* data row in memory */
  lsbyte = addr % ( `AXI_MAX_DW / 8 ); /* offset to the least significant byte of the data to be written */

  for(int i = 0; i < tr_size_in_bytes; i++) begin
    byte_en[i]=1;
  end

  if(addr % tr_size_in_bytes) begin
    if(debug_verbosity) begin
         `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR WRITE Unaligned write address: %x", addr), UVM_DEBUG); /*check alignment*/
    end
    //Check if misalignment cause lowest bytes to fall next `AXI_MAX_DW bit memory row.
    if((addr + tr_size_in_bytes) / bytes_per_row != addr / bytes_per_row) begin
       /* write tail of the data to the beginning of next row */
       misalignment = addr % tr_size_in_bytes;
       /* data value is shifted "misalignment" bytes */
       tail_data = data >> ((tr_size_in_bytes - misalignment) * 8);
       next_row_addr = ((addr + tr_size_in_bytes) / bytes_per_row)*bytes_per_row;
       if(debug_verbosity) begin
         `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Triggering recursive backdoor write addr: %x, data: %x, tr_size: %x bytes", next_row_addr, tail_data, misalignment), UVM_DEBUG); /*check alignment*/
       end
       backdoor_write(next_row_addr, tail_data, misalignment);
    end
    
  end      
   
  if(mem.exists(memory_row)) begin
    /*Memory row exists. Do nothing*/
  end
  else begin
    /*New memory row to be added. Fill with zeros.*/
    mem[memory_row] = 0;
  end

  foreach(byte_en[j]) begin
    if (byte_en[j] === 1'b1) mem[memory_row][(lsbyte+j)*8 +:8] = data[ j*8 +: 8 ];
  end

  if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("BACKDOOR WRITE to memory location: %x, data: %0x, tr_size: %0d", addr, data, tr_size_in_bytes), UVM_DEBUG);

endfunction

function int axi_slave_memory::write(input bit [`AXI_MAX_AW-1:0] addr, input logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes, input bit [`AXI_MAX_DW/8-1:0] byte_en);
  int memory_row;
  int lsbyte;

  memory_row = addr / ( `AXI_MAX_DW / 8 ); /* data row in memory */
  lsbyte = addr % ( `AXI_MAX_DW / 8 ); /* offset to the least significant byte of the data to be written */

	if(addr === addr_to_cause_error && enable_error) begin
		return 0;	
	end
	
  if(addr % tr_size_in_bytes) begin
     if(debug_verbosity) begin
        `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Unaligned write address: %x", addr), UVM_DEBUG); /*check alignment*/
     end
     //TODO: Check if misalignment might cause problems.
  end
  
  if(mem.exists(memory_row)) begin
    /*Memory row exists. Do nothing*/
  end
  else begin
    /*New memory row to be added. Fill with zeros.*/
    mem[memory_row] = 0;
  end
  
  foreach(byte_en[j]) begin
    if (byte_en[j] === 1'b1) mem[memory_row][(lsbyte+j)*8 +:8] = data[ j*8 +: 8 ];
  end
    if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("location: %x, data: %0x, : byte_en: %0x", addr, data, byte_en), UVM_DEBUG);
        //`uvm_info("AXI SLAVE :: MEMORY", $sformatf("Writing to memory location: %x, data: %0x, tr_size: %0d ", addr+i, data[((tr_size_in_bytes*8-1)-(i*8)) -: 8], tr_size_in_bytes), UVM_DEBUG);

   if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Writing to memory location: %x, data: %0x, tr_size: %0d ", addr, data, tr_size_in_bytes), UVM_DEBUG);

   return 1;

endfunction

function int axi_slave_memory::read(input bit [`AXI_MAX_AW-1:0] addr, output logic [`AXI_MAX_DW-1:0] data, input int tr_size_in_bytes);
  int memory_row;
  int lsbyte;

  memory_row = addr / ( `AXI_MAX_DW / 8 ); /* data row in memory */
  lsbyte = addr % ( `AXI_MAX_DW / 8 ); /* offset to the least significant byte of the data to be read */

	if(addr === addr_to_cause_error && enable_error) begin
		data = 0;
		return 0;	
	end
	
  if(addr % tr_size_in_bytes) begin 
     if(debug_verbosity) begin
        `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Unaligned read address: %x", addr), UVM_DEBUG); /*check alignment*/
     end
  end
  
  if(mem.exists(memory_row)) begin
    for( int i=0; i < tr_size_in_bytes; i++ )
    data[i*8 +: 8] = mem[ memory_row ][ (lsbyte + i) * 8 +: 8 ];
    if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Reading from memory location: %x, data: %0x, tr_size: %0d ", addr, data, tr_size_in_bytes), UVM_DEBUG);

    return 1;

  end
  else begin

      mem[ memory_row ] = 0;
      for( int i=0; i < tr_size_in_bytes; i++ )
      data[i*8 +: 8] = mem[ memory_row ][ (lsbyte + i) * 8 +: 8];
       if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("Memory location: %x was not initialized. Set data: %0x, tr_size: %0d ", addr, data, tr_size_in_bytes), UVM_DEBUG);

      return 1;

  end

  data = 0;
  if(debug_verbosity) `uvm_info("AXI SLAVE :: MEMORY", $sformatf("memory location: %x empty", addr), UVM_DEBUG);
  return 0;

endfunction

 `endif

