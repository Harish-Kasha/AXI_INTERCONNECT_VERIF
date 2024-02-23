 /********************************************************************
 *
 * Project     : AXI VIP
 * File        : example_env.sv
 * Description : Example environment for AXI VIP
 *
 *
 *******************************************************************/

import axi_agent_pkg::*;
`include "uvm_macros.svh"
`include "ral_example_reg_block.sv"

class example_env extends uvm_env;

   axi_master_agent u_axi_master_agt;
   axi_slave_agent u_axi_slave_agt;
   axi_monitor_agent u_axi_mon_agt;

   // register model here;
   ral_block_example_reg_block u_reg_block;

   // reg adapter;
   axi_adapter u_axi_adapter;

   // add knobs here;
   `uvm_component_utils_begin(example_env)
   `uvm_component_utils_end

   extern function new(string name, uvm_component parent = null);
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);

endclass

function example_env::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction

function void example_env::build_phase(uvm_phase phase);
   u_axi_master_agt = axi_master_agent::type_id::create ("u_axi_master_agt", this);
   u_axi_slave_agt = axi_slave_agent::type_id::create ("u_axi_slave_agt", this);
   //u_axi_mon_agt = axi_monitor_agent::type_id::create ("u_axi_mon_agt", this);
   
   u_axi_adapter = axi_adapter::type_id::create ("u_axi_adapter",,get_full_name ());

   u_reg_block = ral_block_example_reg_block::type_id::create ("u_reg_block");
   u_reg_block.build();
   u_reg_block.lock_model();

endfunction

function void example_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   u_reg_block.default_map.set_sequencer (u_axi_master_agt.sqr, u_axi_adapter);
   u_reg_block.default_map.set_auto_predict(1);
   u_reg_block.reset(); // Update RAL reset values

   // Analysis port connection examples
   //u_axi_agt.axi_analysis_port.connect(<scoreboard instance>.after_export);

endfunction


