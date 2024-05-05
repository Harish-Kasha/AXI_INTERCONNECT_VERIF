import DMA_ral_pkg::*;
import axi_parameter_pkg::*;
 
class dma_ral_seq extends uvm_sequence;
  `uvm_object_utils(dma_ral_seq)
  
   DMA_block_model regmodel;
   //uvm_reg_data_t ref_data;
  
   
  function new (string name = "dma_ral_seq"); 
    super.new(name);    
  endfunction
  
 
  task body;  
    uvm_status_e   status;
     int  rdata;
     int  des, mir;
     logic  [`AXI_MAX_DW-1:0] wr_data        [];
    
     // reg0 
     regmodel = new("regmodel");
     regmodel.build();
     regmodel.CMD_REG0.poke(status, S0_START);
     des = regmodel.CMD_REG0.get();
     mir = regmodel.CMD_REG0.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.CMD_REG0.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.CMD_REG0.get();
     mir = regmodel.CMD_REG0.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



   // reg1 
     regmodel.CMD_REG1.poke(status, S1_START);
     des = regmodel.CMD_REG1.get();
     mir = regmodel.CMD_REG1.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.CMD_REG1.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.CMD_REG1.get();
     mir = regmodel.CMD_REG1.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



    // reg2 
     regmodel.CMD_REG2.poke(status, 'd80);
     des = regmodel.CMD_REG2.get();
     mir = regmodel.CMD_REG2.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.CMD_REG2.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.CMD_REG2.get();
     mir = regmodel.CMD_REG2.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



    // reg3 
     regmodel.CMD_REG3.poke(status, 2);
     des = regmodel.CMD_REG3.get();
     mir = regmodel.CMD_REG3.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.CMD_REG3.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.CMD_REG3.get();
     mir = regmodel.CMD_REG3.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



      wr_data    = new[1];
 // To set Maximum number of bytes of an AXI read burst
    wr_data[0]='h00000000;
    wr_data[0][9:0]='d4;    // Maximum number of bytes of an AXI read burst
    wr_data[0][12]='d0;     // Status register, indicates if burst size can exceed data buffer size (joint mode).Reset value is 0.
    wr_data[0][13]='d0;     // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[0][21:16]='d1;  // Number of AXI read commands to issue before the channel releases the AXI command bus.Default value is 1.
    wr_data[0][27:24]='d4;  // Number of maximum outstanding AXI read commands. Default value is 4.
    wr_data[0][30]='d0;     // If set it allows the controller to issue the AXI read command while the FIFO is full, expecting the data to be outputted before the read data arrives. If this does not happen the FIFO will be overflown, data lost, and an OVERFLOW interrupt will be issued. Default value is 0.
    wr_data[0][31]='d1;     // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.
   // pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`STATIC_REG0_OFFSET, wr_data, 'd1, 'hF,seqr,'d4);
    //#300;


    // reg4 
     regmodel.STATIC_REG0.poke(status, wr_data[0]);
     des = regmodel.STATIC_REG0.get();
     mir = regmodel.STATIC_REG0.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.STATIC_REG0.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.STATIC_REG0.get();
     mir = regmodel.STATIC_REG0.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);




// To set Maximum number of bytes of an AXI write burst
    wr_data[0][0]='h00000000;
    wr_data[0][9:0]='d4;       // Maximum number of bytes of an AXI read burst
    wr_data[0][12]='d0;        // Status register, indicates if burst size can exceed data buffer size (joint mode). Reset value is 0.
    wr_data[0][13]='d0;        // Status register, indicates if burst can use entire data buffer. Reset value is 0.
    wr_data[0][21:16]='d1;     // Number of AXI write commands to issue before the channel releases the AXI command bus. Default value is 1. 
    wr_data[0][27:24]='d4;     // Number of maximum outstanding AXI write commands. Default value is 4.
    wr_data[0][30]='d1;        // If set it allows the controller to issue the AXI write command immediately after the AXI read command has been given, before the read data actually arrived. Default value is 1.	
    wr_data[0][31]='d1;        // If set the controller will increment the next burst address. Should be set for all memory copy channels. Should be cleared for all peripheral clients that use a static address FIFO. Default value is 1.    
    // pw_seq.write_burst(S5_START+`CORE0_OFFSET+`CH0_OFFSET+`STATIC_REG1_OFFSET, wr_data, 'd1, 'hF0,seqr,'d4);
    #300;

    // reg5 
     regmodel.STATIC_REG1.poke(status, wr_data[0]);
     des = regmodel.STATIC_REG1.get();
     mir = regmodel.STATIC_REG1.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.STATIC_REG1.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.STATIC_REG1.get();
     mir = regmodel.STATIC_REG1.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



    // Channel start. 
    wr_data[0]='h00000001;

    // reg6 
     regmodel.CH_START_REG.poke(status, wr_data[0]);
     des = regmodel.CH_START_REG.get();
     mir = regmodel.CH_START_REG.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Write -> Des: %0d Mir: %0d", des, mir), UVM_NONE);
    $display("-----------------------------------------------");

    regmodel.CH_START_REG.peek(status, rdata);
    `uvm_info(get_type_name(),$sformatf("READ : %0d",rdata),UVM_LOW);
     des = regmodel.CH_START_REG.get();
     mir = regmodel.CH_START_REG.get_mirrored_value();
    `uvm_info("SEQ", $sformatf("Des: %0d Mir: %0d", des, mir), UVM_NONE);



        
    
  endtask
  
  
  
endclass
