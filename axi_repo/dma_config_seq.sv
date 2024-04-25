 //***********************************************************************************************************************************************************
 //	File_name   : dma_config_seq.sv
 //     Description : This class is used to configure the DMA. For more details about DMA go through PR200 document 
 //     
 //***********************************************************************************************************************************************************
// (Register address) = (Core base address) + (Channel base address) + (register offset) 

`include "dma_reg_hdr.svh" 
import axi_parameter_pkg::*;

class dma_config_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(dma_config_seq)

   int start_address; // source address
   int end_address;   // target address
   int n_bytes;       // size of transfer

  // using pipeline sequence
  axi_pipeline_write_seq pw_seq;

  uvm_sequencer_base seqr;

  // Used to store configuration data
  logic  [`AXI_MAX_DW-1:0] wr_data        [];

  function new(string name="dma_config_seq");
     super.new(name);
  endfunction

  // Mandatory virtual task for sequence execution
  virtual task body();
    pw_seq     = axi_pipeline_write_seq::type_id::create("pw_seq");
    wr_data    = new[1];

    // configuring the start address for read operation from source 
    wr_data[0] = start_address; 
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`CMD_REG0_OFFSET, wr_data, 'd1, 'hF,seqr,'d4);
    #300;
   
    // configuring the destination address for write operation on the target
    wr_data[0] = end_address; 
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`CMD_REG1_OFFSET, wr_data, 'd1, 'hF0,seqr,'d4);
    #300;

    // configured number of bytes to be transferred between source and  
    wr_data[0] = n_bytes; 
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`CMD_REG2_OFFSET, wr_data, 'd1, 'hF00,seqr,'d4);
    #300;

    // To stop the channel after the tranfer 
    wr_data[0] = 'd2; 
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`CMD_REG3_OFFSET, wr_data, 'd1, 'hF000,seqr,'d4);
    #300;

    // To set Maximum number of bytes of an AXI read burst
    wr_data[0]='h00000000;
    wr_data[0][9:0]='d4;    // Maximum number of bytes of an AXI read burst
    wr_data[0][12]='d0;     // Status register, indicates if burst size can exceed data buffer size (joint mode).Reset value is 0.
    wr_data[0][13]='d0;     // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[0][21:16]='d1;  // Number of AXI read commands to issue before the channel releases the AXI command bus.Default value is 1.
    wr_data[0][27:24]='d4;  // Number of maximum outstanding AXI read commands. Default value is 4.
    wr_data[0][30]='d0;     // If set it allows the controller to issue the AXI read command while the FIFO is full, expecting the data to be outputted before the read data arrives. If this does not happen the FIFO will be overflown, data lost, and an OVERFLOW interrupt will be issued. Default value is 0.
    wr_data[0][31]='d1;     // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`STATIC_REG0_OFFSET, wr_data, 'd1, 'hF,seqr,'d4);
    #300;

    // To set Maximum number of bytes of an AXI write burst
    wr_data[0][0]='h00000000;
    wr_data[0][9:0]='d4;       // Maximum number of bytes of an AXI read burst
    wr_data[0][12]='d0;        // Status register, indicates if burst size can exceed data buffer size (joint mode). Reset value is 0.
    wr_data[0][13]='d0;        // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[0][21:16]='d1;     // Number of AXI write commands to issue before the channel releases the AXI command bus. Default value is 1. 
    wr_data[0][27:24]='d4;     // Number of maximum outstanding AXI write commands. Default value is 4.
    wr_data[0][30]='d1;        // If set it allows the controller to issue the AXI write command immediately after the AXI read command has been given, before the read data actually arrived. Default value is 1.	
    wr_data[0][31]='d1;        // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.    
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`STATIC_REG1_OFFSET, wr_data, 'd1, 'hF0,seqr,'d4);
    #300;

    // Channel start. 
    wr_data[0]='h00000001;
    pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`CH_START_REG_OFFSET, wr_data, 'd1, 'hF0,seqr,'d4);
    #3000;
  endtask


  task dma_config(int start_address,int end_address,int n_bytes,uvm_sequencer_base seqr);
     this.start_address = start_address;
     this.end_address   = end_address;
     this.n_bytes       = n_bytes;
     this.seqr          = seqr;
     this.start(seqr);
  endtask

endclass




