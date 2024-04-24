 //******************************************************************************************************************************************************
 //	File_name   : axi_interconnect_reset_test.sv
 //     Description : This class is going to test the reset is active_low or active_high and make the reset active during the burst transactions 
 //******************************************************************************************************************************************************

`include "axi_defines.svh"
class axi_interconnect_reset_test extends axi_interconnect_base_test;
  `uvm_component_utils(axi_interconnect_reset_test)
  extern function new(string name, uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase (uvm_phase phase);
endclass

  //constructor
  function axi_interconnect_reset_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //build_phase
  function void axi_interconnect_reset_test::build_phase(uvm_phase phase);
    super.build_phase(phase);  
  endfunction: build_phase
  
  //end_of elaboration_phase
  function void axi_interconnect_reset_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);  
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase
  
  //run_phase
  task axi_interconnect_reset_test::run_phase (uvm_phase phase);
    logic [`AXI_MAX_DW-1:0] data [];	
    int  		    rd_data;
    int                     burst_length;
    logic [1:0] 	    resp;   
    
    //master read and write sequences handles
    axi_master_write_seq    wr_seq;
    axi_master_read_seq     rd_seq;
    axi_pipeline_write_seq  pw_seq,pw_seq1;     
    axi_pipeline_read_seq   pr_seq;     
    
    `uvm_info("TRACE"," Interconnect_extended_test is running. Using read and write sequences to check the reset state", UVM_LOW);
    phase.raise_objection (this);

      rd_seq = axi_master_read_seq::type_id::create    ("rd_seq");
      wr_seq = axi_master_write_seq::type_id::create   ("wr_seq");
      pw_seq = axi_pipeline_write_seq::type_id::create ("pw_seq");
      pw_seq1 = axi_pipeline_write_seq::type_id::create ("pw_seq1");
      pr_seq = axi_pipeline_read_seq::type_id::create  ("pr_seq");
      fork
       /* begin
          wr_seq.write(32'h100, 16'hABBA, 2'b11, resp, env.master_agt_0.sqr, 2);
        end
        begin
          #300ns;
          rd_seq.read(32'h100, rd_data, resp, env.master_agt_0.sqr, 1, 16'hABBA, 2);
         // pr_seq.read('h100,env.master_agt_0.sqr,2);
        end*/

        begin
          #160;
          if(!uvm_hdl_force("axi_interconnect_top.aresetn",1'b1))
          `uvm_error(get_type_name,"reset is not de-asserted through test")
        end
       begin
         #3440ns;
         // #900;
          if(!uvm_hdl_force("axi_interconnect_top.aresetn",1'b0))
          `uvm_error(get_type_name,"reset is not asserted through test")
          #100;
          if(!uvm_hdl_force("axi_interconnect_top.aresetn",1'b1))
          `uvm_error(get_type_name,"reset is not de-asserted through test")
        end
        begin        
           for(int i = 0; i < 5; i++) begin
             burst_length =$urandom_range(6,8);
             data = new[burst_length]; 
             foreach(data[j])begin
               data[j]=$urandom;
             end
             pw_seq.write_burst(i*'h200,data,burst_length, 2'b11, env.master_agt_0.sqr,2);       
             #30;
           end 
          /* burst_length =4;
             data = new[burst_length]; 
             foreach(data[j])begin
               data[j]=$urandom;
             end
           pw_seq.write_burst('h900,data,burst_length, 2'b1, env.master_agt_0.sqr,1);       */
           
        end
        begin  
           #3000;      
           for(int i = 0; i < 5; i++) begin
             burst_length =$urandom_range(6,10);
             pr_seq.read_burst(i*'h200,burst_length, env.master_agt_0.sqr,2);       
             #30;
           end 
        end
      /* begin
        burst_length =$urandom_range(6,8);
             data = new[burst_length]; 
             foreach(data[j])begin
               data[j]=$urandom;
             end
       pw_seq1.write_burst('h100000,data,burst_length, 16'h00ff, env.master_agt_1.sqr,8);       
       end */
      join
      #3000ns;
    phase.drop_objection (this);
  endtask

