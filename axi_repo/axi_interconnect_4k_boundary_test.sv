 //***********************************************************************************************************************************************************
 //	File_name   : axi_interconnect_4k_boundary_test.sv
 //     Description : This test class is going to check the 4k_address_boundary_crossing
 //***********************************************************************************************************************************************************

`include "axi_defines.svh"
class axi_interconnect_4k_boundary_test extends axi_interconnect_base_test;
  `uvm_component_utils(axi_interconnect_4k_boundary_test)
  extern function new(string name, uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase (uvm_phase phase);
endclass

  //constructor
  function axi_interconnect_4k_boundary_test::new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //build_phase
  function void axi_interconnect_4k_boundary_test::build_phase(uvm_phase phase);
    super.build_phase(phase);  
  endfunction: build_phase
  
  //end_of elaboration_phase
  function void axi_interconnect_4k_boundary_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);  
    uvm_top.print_topology ();
  endfunction: end_of_elaboration_phase
  
  //run_phase
  task axi_interconnect_4k_boundary_test::run_phase (uvm_phase phase);
    logic [`AXI_MAX_DW-1:0] data    [];	
    logic [`AXI_MAX_DW-1:0] rd_data [];	
    int                     burst_length;
    logic [1:0] 	    resp;   
    logic [1:0] 	    rresp[];   


    //master read and write sequences handles
    axi_pipeline_write_seq  pw_seq;
    axi_pipeline_read_seq   pr_seq;
    axi_master_write_seq    wr_seq;
    axi_master_read_seq     rd_seq;
    
    `uvm_info("TRACE"," Interconnect_extended_test is running. Using read and write sequences to 4k_boundary transfer", UVM_LOW);
    phase.raise_objection (this);

    pw_seq    = axi_pipeline_write_seq::type_id::create   ("pw_seq");
    pr_seq    = axi_pipeline_read_seq::type_id::create    ("pr_seq");
    rd_seq    = axi_master_read_seq::type_id::create      ("rd_seq");
    wr_seq    = axi_master_write_seq::type_id::create     ("wr_seq");
    
    wr_seq.check_4k_boundary = 1;
    rd_seq.check_4k_boundary = 1;
    begin
      burst_length =$urandom_range(8,9);         
      data = new[burst_length];                  
      foreach(data[j])begin                      
        data[j]=j;                               
      end     
      wr_seq.write_burst(32'hff8,data,burst_length, 2'b11, resp, env.master_agt_0.sqr, 2);
    
      #300ns;
      rd_seq.read_burst(32'hff8, rd_data,burst_length, rresp, env.master_agt_0.sqr, 2);
    end
    /*begin  
      burst_length =$urandom_range(2,5);        
      data = new[burst_length];                 
      foreach(data[j])begin                     
        data[j]=$random;                            
      end                                       
      pw_seq.write_burst('h1ffffc, data,burst_length, 16'hF000, env.master_agt_1.sqr,4);
      #3000;
      pr_seq.read_burst('h1ffffc,burst_length, env.master_agt_1.sqr,4);
    end    */ 
    #3000ns;
    phase.drop_objection (this);
  endtask

