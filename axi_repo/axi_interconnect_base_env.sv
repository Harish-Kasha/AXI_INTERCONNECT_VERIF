 /////////////////////////////////////////////////////////////////////////////
 //
 // Project     : AXI VIP
 // File        : axi_interconnect_env.sv
 // Description : Environment for AXI VIP
 //
 /////////////////////////////////////////////////////////////////////////////


// importing packages and including files 
import axi_agent_pkg::*;
import axi_parameter_pkg::*;

`include "uvm_macros.svh"
`include "ral_example_reg_block.sv"
`include "axi_scoreboard.sv"
class axi_interconnect_base_env extends uvm_env;
  `uvm_component_utils(axi_interconnect_base_env)

   // register model here;
   ral_block_example_reg_block u_reg_block;

   // reg adapter;
   axi_adapter u_axi_adapter;
   

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);

endclass


   // new function
   function axi_interconnect_base_env::new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   // build_phase 
   function void axi_interconnect_base_env::build_phase(uvm_phase phase);   
     /* u_axi_adapter = axi_adapter::type_id::create ("u_axi_adapter",,get_full_name ());
      u_reg_block = ral_block_example_reg_block::type_id::create ("u_reg_block");
      u_reg_block.build();
      u_reg_block.lock_model();*/
   endfunction
   
   // connect phase
   function void axi_interconnect_base_env::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
     
   endfunction



//  Contains the master and slave agents creations   
class axi_interconnect_env extends axi_interconnect_base_env;
   `uvm_component_utils(axi_interconnect_env)

   axi_master_agent master_agt[NO_M];
   axi_slave_agent  slave_agt[NO_S];
   axi_agent_configuration master_cfg[NO_M];
   axi_agent_configuration slave_cfg [NO_S];
   interconnect_scoreboard scr;
   
   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
endclass

   // new function
   function axi_interconnect_env::new(string name, uvm_component parent = null);
   super.new(name, parent);
   endfunction

   // build phase
   function void axi_interconnect_env::build_phase(uvm_phase phase);
      super.build_phase(phase);
      scr = interconnect_scoreboard::type_id::create("scr",this);
      // creation of master agents based on agent configuration
      foreach(master_agt[i])begin
         if(!uvm_config_db #(axi_agent_configuration)::get(this,"",$sformatf("cfgm_%0d",i), master_cfg[i]))begin  
            `uvm_fatal(get_full_name (), $sformatf("Can't get configuration object through config_db of master[%0d]",i))
         end

         master_agt[i] = axi_master_agent::type_id::create ($sformatf("master_agt[%0d]",i), this);
         master_agt[i].cfg = master_cfg[i];         
      end
                        
      // creation of slave agents based on agent configuration
      foreach(slave_agt[i])begin
         uvm_config_db #(axi_agent_configuration)::get(this,"",$sformatf("cfgs_%0d",i), slave_cfg[i]);           

         slave_agt[i] = axi_slave_agent::type_id::create ($sformatf("slave_agt[%0d]",i),this);
         slave_agt[i].cfg = slave_cfg[i];         
      end
   endfunction

   // connect phase
   function void axi_interconnect_env::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
     /* for(int i=0;i< NO_M; i++)begin
        u_reg_block.default_map.set_sequencer (master_agt[i].sqr, u_axi_adapter);
      end
      u_reg_block.default_map.set_auto_predict(1);
      u_reg_block.reset(); // Update RAL reset values*/
      
      //for(int i=0;i< NO_M; i++)begin
         master_agt[0].mon.axi_analysis_port.connect(scr.M0_imp);
         master_agt[1].mon.axi_analysis_port.connect(scr.M1_imp);
         master_agt[2].mon.axi_analysis_port.connect(scr.M2_imp);
         master_agt[3].mon.axi_analysis_port.connect(scr.M3_imp);
      //end
      //for(int i=0;i< NO_S; i++)begin
         slave_agt[0].mon.axi_analysis_port.connect(scr.S0_imp);
         slave_agt[1].mon.axi_analysis_port.connect(scr.S1_imp);
         slave_agt[2].mon.axi_analysis_port.connect(scr.S2_imp);
         slave_agt[3].mon.axi_analysis_port.connect(scr.S3_imp);
         slave_agt[4].mon.axi_analysis_port.connect(scr.S4_imp);
         slave_agt[5].mon.axi_analysis_port.connect(scr.S5_imp);
      //end

   endfunction


