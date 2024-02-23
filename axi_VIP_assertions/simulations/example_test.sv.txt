 /********************************************************************
 *******************************************************************/

`ifndef _EXAMPLE_TEST_
`define _EXAMPLE_TEST_

`include "example_env.sv"

class example_test extends uvm_test;
   `uvm_component_utils(example_test)
   example_env env;
   axi_agent_configuration master_cfg;
   axi_agent_configuration slave_cfg;
   axi_agent_configuration mon_cfg;
   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern function void start_of_simulation_phase (uvm_phase phase);
   extern task reg_write(string reg_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");
   extern task field_write(string field_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");
   extern task reg_read(string reg_name, ref uvm_reg_data_t data,
                        input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
   extern task field_read(string field_name, ref uvm_reg_data_t data,
                          input int ref_val = -1, input string subblk1 = "", input string subblk2 = "");
endclass

function example_test::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction

function void example_test::build_phase(uvm_phase phase);

   super.build_phase(phase);
   //ENV
   env = example_env::type_id::create("env", this);

   //MASTER
   master_cfg = axi_agent_configuration::type_id::create("master_cfg");
   master_cfg.fast_mode = 0;
   master_cfg.wait_all_data = 1;
   master_cfg.max_read_requests = 16;
   master_cfg.max_write_requests = 16;
   master_cfg.data_width = 128;
   //master_cfg.aw_before_w_channel = 1;
   master_cfg.has_perf_analysis = 1;
   master_cfg.log_verbosity = "none";
   master_cfg.has_pipelining = 1;
   master_cfg.last_signaling_used = 1;
   
   if(!uvm_config_db #(virtual axi_footprint_interface)::get( this, "", "axi_master_vif", master_cfg.axi_vif))
     `uvm_fatal("NOVIF", "No virtual interface set")
   uvm_config_db #(axi_agent_configuration)::set(this,"env.u_axi_master_agt","cfg", master_cfg);

   //SLAVE
   slave_cfg = axi_agent_configuration::type_id::create("slave_cfg");
   slave_cfg.fast_mode = 0;
   slave_cfg.max_read_requests = 16;
   slave_cfg.max_write_requests = 16;
   slave_cfg.data_width = 128;
   //slave_cfg.aw_before_w_channel = 1;
   slave_cfg.has_perf_analysis = 0;
   slave_cfg.log_verbosity = "medium";
   slave_cfg.memory_debug_verbosity = 0;
   slave_cfg.enable_addr_to_cause_error = 1'b1;
   slave_cfg.addr_to_cause_error = 32'h12345678;
   slave_cfg.has_pipelining = 1;
   slave_cfg.last_signaling_used = 1;
   
   if(!uvm_config_db #(virtual axi_footprint_interface)::get( this, "", "axi_slave_vif", slave_cfg.axi_vif))
     `uvm_fatal("NOVIF", "No virtual interface set")
   uvm_config_db #(axi_agent_configuration)::set(this,"env.u_axi_slave_agt","cfg", slave_cfg);

   //MONITOR
   mon_cfg = axi_agent_configuration::type_id::create("mon_cfg");
   mon_cfg.data_width = 128;
   if(!uvm_config_db #(virtual axi_footprint_interface)::get( this, "", "axi_mon_vif", mon_cfg.axi_vif))
     `uvm_fatal("NOVIF", "No virtual interface set")
   uvm_config_db #(axi_agent_configuration)::set(this,"env.u_axi_mon_agt","cfg", mon_cfg);

endfunction: build_phase

function void example_test::start_of_simulation_phase (uvm_phase phase);
   uvm_root top = uvm_root::get();
endfunction

/// Register write function to simplify RAL register access.
/// If there are hierarchical registres with same name, use subblk1/2 to define sub block hierarchy
/// Example: To access register env.u_reg_block.axc_pipe0.axc0.AxC_RATE, use
/// reg_write("AxC_RATE", `AXC_RATE, "axc_pipe0", "axc0");
task example_test::reg_write(string reg_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");

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
task example_test::field_write(string field_name, bit[31:0] data, string subblk1 = "", string subblk2 = "");

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
task example_test::reg_read(string reg_name, ref uvm_reg_data_t data,
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
task example_test::field_read(string field_name, ref uvm_reg_data_t data,
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

