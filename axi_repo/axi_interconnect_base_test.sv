 //***********************************************************************************************************************************************************
 //	File_name   : interconnect_base_test.sv
 //     Description : This class is used to create the environment and congifuarion objects for masters and slaves 
 //***********************************************************************************************************************************************************

`ifndef _EXAMPLE_TEST_
`define _EXAMPLE_TEST_

`include "axi_interconnect_base_env.sv"

   import axi_parameter_pkg::*;
class axi_interconnect_base_test extends uvm_test;
   `uvm_component_utils(axi_interconnect_base_test)
 // uvm_active_passive_enum is_active = UVM_ACTIVE;
   axi_interconnect_env env;
   axi_agent_configuration #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]) master_cfg_0;  // can we set here with fixed parametrs for different master
   axi_agent_configuration #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]) master_cfg_1;
   axi_agent_configuration #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]) master_cfg_2;
   axi_agent_configuration #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]) master_cfg_3;
   axi_agent_configuration #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH) slave_cfg_0;
   axi_agent_configuration #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH) slave_cfg_1;
   axi_agent_configuration #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH) slave_cfg_2;
   axi_agent_configuration #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH) slave_cfg_3;
   axi_agent_configuration #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH) slave_cfg_4;
   axi_agent_configuration #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH) slave_cfg_5;
   
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
   int D,I;
   super.build_phase(phase);

   //environment creation
   env = axi_interconnect_env::type_id::create("env", this);

   //Master configuration object creation
      
   master_cfg_0 = axi_agent_configuration #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0])::type_id::create("master_cfg_0");
   master_cfg_1 = axi_agent_configuration #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1])::type_id::create("master_cfg_1");
   master_cfg_2 = axi_agent_configuration #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2])::type_id::create("master_cfg_2");
   master_cfg_3 = axi_agent_configuration #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3])::type_id::create("master_cfg_3");

   // changing the configuration values  
      master_cfg_0.data_width 	 = m_array[0];
      master_cfg_0.master_i      = 0;
      master_cfg_1.data_width 	 = m_array[1];
      master_cfg_1.master_i      = 1;
      master_cfg_2.data_width 	 = m_array[2];
      master_cfg_2.master_i      = 2;
      master_cfg_2.is_active     = UVM_PASSIVE;
      master_cfg_3.data_width 	 = m_array[3];
      master_cfg_3.master_i      = 3;
   
   
      if(!uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]))::get( this, "","axi_master_vif_0", master_cfg_0.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to master 0")

      if(!uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]))::get( this, "", "axi_master_vif_1", master_cfg_1.axi_vif))
         `uvm_fatal("NOVIF","No virtual interface set to master 1")

      if(!uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]))::get( this, "", "axi_master_vif_2", master_cfg_2.axi_vif))
         `uvm_fatal("NOVIF","No virtual interface set to master 2")

      if(!uvm_config_db #(virtual axi_footprint_interface #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]))::get( this, "", "axi_master_vif_3", master_cfg_3.axi_vif))
         `uvm_fatal("NOVIF","No virtual interface set to master 3")



   // setting the master configuration object to the data base
           
      //master_cfg[NO_M-1].is_active = UVM_PASSIVE; //passive master_agent creation --> making last master agent as passive
 
      uvm_config_db #(axi_agent_configuration #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]))::set(this,"*","cfgm_0", master_cfg_0);
      uvm_config_db #(axi_agent_configuration #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]))::set(this,"*","cfgm_1", master_cfg_1);
      uvm_config_db #(axi_agent_configuration #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]))::set(this,"*","cfgm_2", master_cfg_2);
      uvm_config_db #(axi_agent_configuration #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]))::set(this,"*","cfgm_3", master_cfg_3);



   
   slave_cfg_0 = axi_agent_configuration #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH)::type_id::create("slave_cfg_0");
   slave_cfg_1 = axi_agent_configuration #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH)::type_id::create("slave_cfg_1");
   slave_cfg_2 = axi_agent_configuration #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH)::type_id::create("slave_cfg_2");
   slave_cfg_3 = axi_agent_configuration #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH)::type_id::create("slave_cfg_3");
   slave_cfg_4 = axi_agent_configuration #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH)::type_id::create("slave_cfg_4");
   slave_cfg_5 = axi_agent_configuration #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH)::type_id::create("slave_cfg_5");
  
 //Slave configuration object creation
  
      slave_cfg_0.data_width = s_array[0];
      slave_cfg_0.has_perf_analysis = 0;
      slave_cfg_0.log_verbosity = "medium";
      slave_cfg_0.memory_debug_verbosity = 0;
      slave_cfg_0.enable_addr_to_cause_error = 1'b1;
      slave_cfg_0.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_0.master   = 0;
      slave_cfg_0.slave_i = 0;

       
      slave_cfg_1.data_width = s_array[1];
      slave_cfg_1.has_perf_analysis = 0;
      slave_cfg_1.log_verbosity = "medium";
      slave_cfg_1.memory_debug_verbosity = 0;
      slave_cfg_1.enable_addr_to_cause_error = 1'b1;
      slave_cfg_1.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_1.master   = 0;
      slave_cfg_1.slave_i = 1;

       
      slave_cfg_2.data_width = s_array[2];
      slave_cfg_2.has_perf_analysis = 0;
      slave_cfg_2.log_verbosity = "medium";
      slave_cfg_2.memory_debug_verbosity = 0;
      slave_cfg_2.enable_addr_to_cause_error = 1'b1;
      slave_cfg_2.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_2.master   = 0;
      slave_cfg_2.slave_i = 2;
      
      slave_cfg_3.data_width = s_array[3];
      slave_cfg_3.has_perf_analysis = 0;
      slave_cfg_3.log_verbosity = "medium";
      slave_cfg_3.memory_debug_verbosity = 0;
      slave_cfg_3.enable_addr_to_cause_error = 1'b1;
      slave_cfg_3.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_3.master   = 0;
      slave_cfg_3.slave_i = 3;
       
 
      slave_cfg_4.data_width = s_array[4];
      slave_cfg_4.has_perf_analysis = 0;
      slave_cfg_4.log_verbosity = "medium";
      slave_cfg_4.memory_debug_verbosity = 0;
      slave_cfg_4.enable_addr_to_cause_error = 1'b1;
      slave_cfg_4.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_4.master   = 0;
      slave_cfg_4.slave_i = 4;
 
      slave_cfg_5.data_width = s_array[5];
      slave_cfg_5.has_perf_analysis = 0;
      slave_cfg_5.log_verbosity = "medium";
      slave_cfg_5.memory_debug_verbosity = 0;
      slave_cfg_5.enable_addr_to_cause_error = 1'b1;
      slave_cfg_5.addr_to_cause_error = 32'hEEEEEEEE; 
      slave_cfg_5.master   = 0;
      slave_cfg_5.slave_i = 5;
      slave_cfg_5.is_active     = UVM_PASSIVE;

    //  slave_cfg_3.is_active = UVM_PASSIVE;  //passive agent creation--> making last slave agent as passive
   
  

   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH))::get( this, "","axi_slave_vif_0", slave_cfg_0.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 0")
   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH))::get( this, "","axi_slave_vif_1", slave_cfg_1.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 1")
   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH))::get( this, "","axi_slave_vif_2", slave_cfg_2.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 2")
   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH))::get( this, "","axi_slave_vif_3", slave_cfg_3.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 3")
   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH))::get( this, "","axi_slave_vif_4", slave_cfg_4.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 4")
   if(!uvm_config_db #(virtual axi_footprint_interface #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH))::get( this, "","axi_slave_vif_5", slave_cfg_5.axi_vif)) 
         `uvm_fatal("NOVIF","No virtual interface set to slave 5")
 


  // setting the salve configuration object to the data base
 
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH))::set(this,"*","cfgs_0", slave_cfg_0);
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH))::set(this,"*","cfgs_1", slave_cfg_1);
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH))::set(this,"*","cfgs_2", slave_cfg_2);
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH))::set(this,"*","cfgs_3", slave_cfg_3);
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH))::set(this,"*","cfgs_4", slave_cfg_4);
      uvm_config_db #(axi_agent_configuration #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH))::set(this,"*","cfgs_5", slave_cfg_5);
        
  
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

