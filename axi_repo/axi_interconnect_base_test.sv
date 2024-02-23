 //***********************************************************************************************************************************************************
 //	File_name   : interconnect_base_test.sv
 //     Description : This class is used to create the environment and congifuarion objects for masters and slaves 
 //***********************************************************************************************************************************************************

`ifndef _EXAMPLE_TEST_
`define _EXAMPLE_TEST_

`include "axi_interconnect_base_env.sv"

class axi_interconnect_base_test extends uvm_test;
   `uvm_component_utils(axi_interconnect_base_test)
 // uvm_active_passive_enum is_active = UVM_ACTIVE;
//  import axi_parameter_pkg::*;
   axi_interconnect_env env;
   axi_agent_configuration master_cfg[NO_M];
   axi_agent_configuration slave_cfg [NO_S];
   
   extern function new(string name, uvm_component parent = null);
   extern function void start_of_simulation_phase (uvm_phase phase);

   extern function void build_phase(uvm_phase phase);

   extern task reg_write  (string reg_name,   bit[31:0] data, string subblk1 = "", string subblk2 = "");
   extern task field_write(string field_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");

   extern task reg_read  (string reg_name, ref uvm_reg_data_t data,
                          input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
   extern task field_read(string field_name, ref uvm_reg_data_t data,
                          input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
endclass

//constructor
function axi_interconnect_base_test::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction

//build_phase
function void axi_interconnect_base_test::build_phase(uvm_phase phase);
   //data_widths for master and slave agents
   int m_array[NO_M] = '{M_DATA_W[0],M_DATA_W[1],M_DATA_W[2],M_DATA_W[3]};
   int s_array[NO_S] = '{S_DATA_W[0],S_DATA_W[1],S_DATA_W[2],S_DATA_W[3],S_DATA_W[4],S_DATA_W[5]};

   super.build_phase(phase);

   //environment creation
   env = axi_interconnect_env::type_id::create("env", this);

   //Master configuration object creation
   for(int i=0; i< NO_M ;i++)begin
      master_cfg[i] = axi_agent_configuration::type_id::create($sformatf("master_cfg[%0d]",i));

      master_cfg[i].fast_mode	        = 0;
      master_cfg[i].wait_all_data       = 1;
      master_cfg[i].max_read_requests   = 16;
      master_cfg[i].max_write_requests  = 16;
      master_cfg[i].data_width 	        = m_array[i];
      master_cfg[i].has_perf_analysis   = 1;
      master_cfg[i].log_verbosity       = "none";
      master_cfg[i].has_pipelining      = 1;
      master_cfg[i].last_signaling_used = 1;
      master_cfg[i].master 	 	= 1;
      master_cfg[i].master_i 	 	= i;
   end
   
   // setting the master configuration object to the data base
   for(int i=0; i< NO_M ;i++)begin           
      master_cfg[NO_M-1].is_active = UVM_PASSIVE; //passive master_agent creation --> making last master agent as passive

      if(!uvm_config_db #(virtual axi_footprint_interface)::get( this, "", $sformatf("axi_master_vif_%0d",i), master_cfg[i].axi_vif))
            `uvm_fatal("NOVIF", $sformatf("No virtual interface set to master_%0d",i))
      uvm_config_db #(axi_agent_configuration)::set(this,"*",$sformatf("cfgm_%0d",i), master_cfg[i]);

   end

   
   //Slave configuration object creation
   for(int i=0; i< NO_S ;i++)begin

      slave_cfg[i] = axi_agent_configuration::type_id::create($sformatf("slave_cfg[%0d]",i));

      slave_cfg[i].fast_mode = 0;
      slave_cfg[i].max_read_requests = 16;
      slave_cfg[i].max_write_requests = 16;
      slave_cfg[i].data_width = s_array[i];
      slave_cfg[i].has_perf_analysis = 0;
      slave_cfg[i].log_verbosity = "medium";
      slave_cfg[i].memory_debug_verbosity = 0;
      slave_cfg[i].enable_addr_to_cause_error = 1'b1;
      slave_cfg[i].addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg[i].has_pipelining = 1;
      slave_cfg[i].last_signaling_used = 1;
      slave_cfg[i].master   = 0;
      slave_cfg[i].slave_i = i;
   end
   
  // setting the salve configuration object to the data base
   for(int i=0; i< NO_S ;i++)begin
      slave_cfg[NO_S-1].is_active = UVM_PASSIVE;  //passive agent creation--> making last slave agent as passive

      if(!uvm_config_db #(virtual axi_footprint_interface)::get( this, "",$sformatf("axi_slave_vif_%0d",i), slave_cfg[i].axi_vif))
         `uvm_fatal("NOVIF", $sformatf("No virtual interface set to slave_%0d",i))

      uvm_config_db #(axi_agent_configuration)::set(this,"*",$sformatf("cfgs_%0d",i), slave_cfg[i]);
   end     
  
  endfunction: build_phase

  //start_of_simulation phase
  function void axi_interconnect_base_test::start_of_simulation_phase (uvm_phase phase);
     uvm_root top = uvm_root::get();
  endfunction

  // Register write function to simplify RAL register access.
  // If there are hierarchical registres with same name, use subblk1/2 to define sub block hierarchy
  // Example: To access register env.u_reg_block.axc_pipe0.axc0.AxC_RATE, use
  // reg_write("AxC_RATE", `AXC_RATE, "axc_pipe0", "axc0");
  task axi_interconnect_base_test::reg_write(string reg_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");
  
     uvm_reg         ral_reg;
     uvm_reg_block   ral_block;
     uvm_status_e    status;
     uvm_reg_field   ral_field;
  
     // By default, get register name without any sub-block references
     if (subblk1 == "")
       ral_reg = env.u_reg_block.get_reg_by_name(reg_name);
     else begin
        ral_block = env.u_reg_block.get_block_by_name(subblk1);
        if (subblk2 != "")
          ral_block = ral_block.get_block_by_name(subblk2);
        ral_reg = ral_block.get_reg_by_name(reg_name);
     end
     if(ral_reg != null) begin
        ral_reg.write(.status(status), .value(data));
        `uvm_info("TRACE", $sformatf("%0s write: %0h", reg_name, data), UVM_MEDIUM);
     end else
       `uvm_error("RAL WRITE",$sformatf("INVALID REG: %0s", reg_name));
  
  endtask : reg_write
  
  /// Register field write function to simplify RAL register access.
  /// If there are hierarchical registres with same name, use subblk1/2 to define sub block hierarchy
  /// Example: To access register field env.u_reg_block.axc_pipe0.axc0.AxC_RATE.UL, use
  /// field_write("AxC_RATE.UL", `AXC_RATE, "axc_pipe0", "axc0");
  task axi_interconnect_base_test::field_write(string field_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");
  
     uvm_reg         ral_reg;
     uvm_reg_block   ral_block;
     uvm_status_e    status;
     uvm_reg_field   ral_field;
     string rn, fn;
  
     int    l = field_name.len() ;
     for (int i=0; i<l ; i++) begin
        if (field_name.substr(i,i) == "." ) begin
           // REG_NAME.FIELD_NAME
           rn =  field_name.substr(0,i-1) ;
           fn = field_name.substr(i+1,l-1) ;
           break ;
        end
     end
  
     // By default, get register name without any sub-block references
     if (subblk1 == "")
       ral_reg = env.u_reg_block.get_reg_by_name(rn);
     else begin
        ral_block = env.u_reg_block.get_block_by_name(subblk1);
        if (subblk2 != "")
          ral_block = ral_block.get_block_by_name(subblk2);
        ral_reg = ral_block.get_reg_by_name(rn);
     end
     if(ral_reg != null) begin
        ral_field = ral_reg.get_field_by_name(fn);
        if(ral_field != null) begin
           ral_field.write(.status(status), .value(data));
           `uvm_info("TRACE", $sformatf("%0s write: %0h", field_name, data), UVM_MEDIUM);
        end else
          `uvm_error("RAL WRITE",$sformatf("INVALID FIELD: %0s", fn));
     end
     else
       `uvm_error("RAL WRITE",$sformatf("INVALID REG: %0s", rn));
  
  endtask : field_write
  
  /// Register read function to simplify RAL register access.
  /// If there are hierarchical registres with same name, use subblk1/2 to define sub block hierarchy
  /// Example: To access register env.u_reg_block.axc_pipe0.axc0.AxC_RATE, use
  /// reg_read("AxC_RATE", data, "axc_pipe0", "axc0");
  task axi_interconnect_base_test::reg_read(string reg_name, ref uvm_reg_data_t data,
                              input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
  
     uvm_reg         ral_reg;
     uvm_reg_block   ral_block;
     uvm_status_e    status;
     uvm_reg_field   ral_field;
  
     // By default, get register name without any sub-block references
     if (subblk1 == "")
       ral_reg = env.u_reg_block.get_reg_by_name(reg_name);
     else begin
        ral_block = env.u_reg_block.get_block_by_name(subblk1);
        if (subblk2 != "")
          ral_block = ral_block.get_block_by_name(subblk2);
        ral_reg = ral_block.get_reg_by_name(reg_name);
     end
     if(ral_reg != null) begin
        ral_reg.read(.status(status), .value(data));
        `uvm_info("TRACE", $sformatf("%0s read: %0h", reg_name, data), UVM_MEDIUM);
     end else
       `uvm_error("RAL READ",$sformatf("INVALID REG: %0s", reg_name));
  
     if (ref_val != -1) begin
        if (data !== ref_val) begin
           `uvm_error("RAL READ",$sformatf("%0s data not expected: exp: 0x%0h, act: 0x%0h", reg_name, ref_val, data));
        end else
          `uvm_info("TRACE", $sformatf("%0s data as expected: %0h", reg_name, ref_val), UVM_MEDIUM);
     end
  
  endtask : reg_read
  
  /// Register field read function to simplify RAL register access.
  /// Example: To access register field env.u_reg_block.axc_pipe0.axc0.AxC_RATE.UL, use
  /// field_write("AxC_RATE.UL", `AXC_RATE, "axc_pipe0", "axc0");
  task axi_interconnect_base_test::field_read(string field_name, ref uvm_reg_data_t data,
                                input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
  
     uvm_reg   ral_reg;
     uvm_reg_block   ral_block;
     uvm_status_e   status;
     uvm_reg_field   ral_field;
     string rn, fn;
  
     int    l = field_name.len() ;
     for (int i=0; i<l ; i++) begin
        if (field_name.substr(i,i) == "." ) begin
           // REG_NAME.FIELD_NAME
           rn =  field_name.substr(0,i-1) ;
           fn = field_name.substr(i+1,l-1) ;
           break ;
        end
     end
  
     // By default, get register name without any sub-block references
     if (subblk1 == "")
       ral_reg = env.u_reg_block.get_reg_by_name(rn);
     else begin
        ral_block = env.u_reg_block.get_block_by_name(subblk1);
        if (subblk2 != "")
          ral_block = ral_block.get_block_by_name(subblk2);
        ral_reg = ral_block.get_reg_by_name(rn);
     end
     if(ral_reg != null) begin
        ral_field = ral_reg.get_field_by_name(fn);
        if(ral_field != null) begin
           ral_field.read(.status(status), .value(data));
        end else
          `uvm_error("RAL READ",$sformatf("INVALID FIELD: %0s", fn));
     end
     else
       `uvm_error("RAL READ",$sformatf("INVALID REG: %0s", rn));
  
     if (ref_val != -1) begin
        if (data !== ref_val) begin
           `uvm_error("RAL READ",$sformatf("%0s data not expected: exp: 0x%0h, act: 0x%0h", field_name, ref_val, data));
        end else
          `uvm_info("TRACE", $sformatf("%0s data as expected: %0h", field_name, ref_val), UVM_MEDIUM);
     end
  
  endtask : field_read

`endif

