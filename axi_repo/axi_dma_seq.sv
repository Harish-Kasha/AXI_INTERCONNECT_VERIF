`include "dma_reg_hdr.svh" 
import axi_parameter_pkg::*;

class axi_dma_seq extends uvm_sequence #(axi_seq_item);

   `uvm_object_utils(axi_dma_seq)
  
   logic  [`AXI_MAX_DW-1:0] wr_data        [];
   logic  [`AXI_MAX_DW-1:0] data           [2];  
   logic  [`AXI_MAX_DW-1:0] ch_start [1]; 
   int                      burst_length;
  
   axi_pipeline_write_seq pw_seq;

   uvm_sequencer_base seqr;
   axi_dma_configuration   dma_cfg;

   extern function new(string name="axi_dma_seq");
   extern virtual task body();
  // extern virtual task dma_config();
endclass

function axi_dma_seq::new(string name="axi_dma_seq");
   super.new(name);
endfunction : new

task axi_dma_seq::body();
    int core;
    int ch;
    int addr;
    int addr_arr[6];
    int strobe;
    int n_bytes;
    pw_seq     = axi_pipeline_write_seq::type_id::create("pw_seq");
      if(!uvm_config_db #(axi_dma_configuration) ::get(null,"","dma_cfg", dma_cfg))
      `uvm_fatal(get_type_name,"DMA configuration is not created")
    seqr = dma_cfg.seqr; 
    if(dma_cfg.core)
      core = `CORE1_OFFSET;
    else
      core = `CORE0_OFFSET;
    
    case(dma_cfg.ch)
      'd0 : ch = `CH0_OFFSET;
      'd1 : ch = `CH1_OFFSET;
      'd2 : ch = `CH2_OFFSET;
      'd3 : ch = `CH3_OFFSET;
      'd4 : ch = `CH4_OFFSET;
      'd5 : ch = `CH5_OFFSET;
      'd6 : ch = `CH6_OFFSET;
      'd7 : ch = `CH7_OFFSET;
    endcase
       
    case(dma_cfg.m_no)
      'd0 :begin 
             n_bytes = 2;
             strobe  = 2'b11;
           end 
      'd1 :begin 
             n_bytes = 16;
             strobe  = 16'hFFFF;
           end 
           
      'd3 :begin 
             n_bytes = 1;
             strobe  = 1'b1;
           end 
 
    endcase
  
    addr = S5_START + core + ch;
        
    
    wr_data    = new[6];
    wr_data[0] = dma_cfg.start_address;  
    wr_data[1] = dma_cfg.end_address; 
    wr_data[2] = dma_cfg.no_of_bytes; 
    wr_data[3] = dma_cfg.stop_after_transfer; 
   // To set Maximum number of bytes of an AXI read burst
    wr_data[4]='h00000000;
    wr_data[4][9:0]=dma_cfg.arsize;    // Maximum number of bytes of an AXI read burst
    wr_data[4][12]='d0;     // Status register, indicates if burst size can exceed data buffer size (joint mode).Reset value is 0.
    wr_data[4][13]='d0;     // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[4][21:16]='d1;  // Number of AXI read commands to issue before the channel releases the AXI command bus.Default value is 1.
    wr_data[4][27:24]='d4;  // Number of maximum outstanding AXI read commands. Default value is 4.
    wr_data[4][30]='d0;     // If set it allows the controller to issue the AXI read command while the FIFO is full, expecting the data to be outputted before the read data arrives. If this does not happen the FIFO will be overflown, data lost, and an OVERFLOW interrupt will be issued. Default value is 0.
    wr_data[4][31]='d1;     // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.
    
    // To set Maximum number of bytes of an AXI write burst
    wr_data[5]='h00000000;
    wr_data[5][9:0]='d4;       // Maximum number of bytes of an AXI read burst
    wr_data[5][12]='d0;        // Status register, indicates if burst size can exceed data buffer size (joint mode). Reset value is 0.
    wr_data[5][13]='d0;        // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[5][21:16]='d1;     // Number of AXI write commands to issue before the channel releases the AXI command bus. Default value is 1. 
    wr_data[5][27:24]='d4;     // Number of maximum outstanding AXI write commands. Default value is 4.
    wr_data[5][30]='d1;        // If set it allows the controller to issue the AXI write command immediately after the AXI read command has been given, before the read data actually arrived. Default value is 1.	
    wr_data[5][31]='d1;        // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.    
    

   /* if(dma_cfg.m_no == 'd1)begin 
        
      burst_length = 2; 
      wr_data    = new[burst_length];
      // To set Maximum number of bytes of an AXI read burst
      data[0]='h00000000;
      data[0][9:0]=dma_cfg.arsize;    // Maximum number of bytes of an AXI read burst
      data[0][12]='d0;     // Status register, indicates if burst size can exceed data buffer size (joint mode).Reset value is 0.
      data[0][13]='d0;     // Status register, indicates if burst can use entire data buffer. Reset value is 0.
      data[0][21:16]='d1;  // Number of AXI read commands to issue before the channel releases the AXI command bus.Default value is 1.
      data[0][27:24]='d4;  // Number of maximum outstanding AXI read commands. Default value is 4.
      data[0][30]='d0;     // If set it allows the controller to issue the AXI read command while the FIFO is full, expecting the data to be outputted before the read data arrives. If this does not happen the FIFO will be overflown, data lost, and an OVERFLOW interrupt will be issued. Default value is 0.
      data[0][31]='d1;     // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared
      // To set Maximum number of bytes of an AXI write burst
      data[1][0]='h00000000;
      data[1][9:0]=dma_cfg.awsize;    // Maximum number of bytes of an AXI read burst
      data[1][12]='d0;     // Status register, indicates if burst size can exceed data buffer size (joint mode).Reset value is 0.
      data[1][13]='d0;     // Status register, indicates if burst can use entire data buffer. Reset value is 0.
      data[1][21:16]='d1;  // Number of AXI read commands to issue before the channel releases the AXI command bus.Default value is 1.
      data[1][27:24]='d4;  // Number of maximum outstanding AXI read commands. Default value is 4.
      data[1][30]='d0;     // If set it allows the controller to issue the AXI read command while the FIFO is full, expecting the data to be outputted before the read data arrives. If this does not happen the FIFO will be overflown, data lost, and an OVERFLOW interrupt will be issued. Default value is 0.
      data[1][31]='d1;     // If s;       // Maximum number of bytes of an AXI write burst
      data[1][12]='d0;        // Status register, indicates if burst size can exceed data buffer size (joint mode). Reset value is 0.
      data[1][13]='d0;        // Status register, indicates if burst can use entire data buffer. Reset value is 0.
      data[1][21:16]='d1;     // Number of AXI write commands to issue before the channel releases the AXI command bus. Default value is 1. 
      data[1][27:24]='d4;     // Number of maximum outstanding AXI write commands. Default value is 4.
      data[1][30]='d1;        // If set it allows the controller to issue the AXI write command immediately after the AXI read command has been given, before the read data actually arrived. Default value is 1.	
      data[1][31]='d1;        // If set the controller will increment the n
     
      wr_data[0] = {dma_cfg.stop_after_transfer,dma_cfg.no_of_bytes,dma_cfg.end_address,dma_cfg.start_address};  
      wr_data[1] = {data[1],data[0]};   
      addr = S5_STAR + core + ch + `CMD_REG0_OFFSET;
      for(i=0;i<burst_length;i++)begin
        pw_seq.write_burst(addr + (i*'h10), wr_data, burst_length, strobe,seqr,n_bytes);
      end
    end*/
    
    // Channel start. 
    ch_start[0]='h00000001;

    addr_arr = '{0,4,8,12,16,20};
    if(dma_cfg.m_no == 'd0)begin         
      burst_length = 1; 
      foreach(addr_arr[k])begin
        for(int j=0;j<n_bytes;j++)begin
          pw_seq.write_burst((addr_arr[k] +(j*'h2)), wr_data[j*16 +: 16], burst_length, strobe,seqr,n_bytes);
        end
      end
      //#300ns;
      pw_seq.write_burst((addr+`CH_START_REG_OFFSET), ch_start, 'd1, strobe,seqr,n_bytes);     
    end
    else if(dma_cfg.m_no == 'd1)begin         
      burst_length = 6; 
      strobe  = 'hF;
      n_bytes = 4;
      pw_seq.write_burst(addr,wr_data,burst_length, strobe, seqr, n_bytes);
     // #300ns;
      pw_seq.write_burst((addr+`CH_START_REG_OFFSET), ch_start, 'd1, 'hF0,seqr,n_bytes);      
    end

    //addr_arr = '{0,4,8,12,16,20};

    else if(dma_cfg.m_no == 'd3)begin               
      burst_length = 1; 
      foreach(addr_arr[k])begin
        for(int j=0;j<4;j++)begin
          pw_seq.write_burst((addr_arr[k] + (j*'h1)), wr_data[j*8 +: 8],burst_length, strobe,seqr,n_bytes);
        end        
      end
      pw_seq.write_burst((addr+`CH_START_REG_OFFSET), ch_start, 'd1, strobe,seqr,n_bytes);     
    end 
  endtask

/* task axi_dma_seq::dma_config(int start_address,int end_address,int n_bytes,uvm_sequencer_base seqr);
     this.start_address = start_address;
     this.end_address   = end_address;
     this.n_bytes       = n_bytes;
     this.seqr          = seqr;
     this.start(seqr);
  endtask*/
 /*if(dma_cfg.start_address)            addr = S5_STAR + core + ch + `CMD_REG0_OFFSET;
    else if(dma_cfg.end_address)         addr = S5_STAR + core + ch + `CMD_REG1_OFFSET;
    else if(dma_cfg.no_of_bytes)         addr = S5_STAR + core + ch + `CMD_REG2_OFFSET;
    else if(dma_cfg.stop_after_transfer) addr = S5_STAR + core + ch + `CMD_REG3_OFFSET;*/

