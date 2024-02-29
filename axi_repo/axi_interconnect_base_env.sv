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

   axi_master_agent #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]) master_agt_0;
   axi_master_agent #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]) master_agt_1;
   axi_master_agent #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]) master_agt_2;
   axi_master_agent #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]) master_agt_3;

   axi_slave_agent #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH) slave_agt_0;
   axi_slave_agent #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH) slave_agt_1;
   axi_slave_agent #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH) slave_agt_2;
   axi_slave_agent #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH) slave_agt_3;
   axi_slave_agent #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH) slave_agt_4;
   axi_slave_agent #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH) slave_agt_5;

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
      
     if(!uvm_config_db #(axi_agent_configuration #(M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0]))::get(this,"","cfgm_0", master_cfg_0))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of master 0")
     if(!uvm_config_db #(axi_agent_configuration #(M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1]))::get(this,"","cfgm_1", master_cfg_1))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of master 1")
     if(!uvm_config_db #(axi_agent_configuration #(M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2]))::get(this,"","cfgm_2", master_cfg_2))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of master 2")
     if(!uvm_config_db #(axi_agent_configuration #(M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3]))::get(this,"","cfgm_3", master_cfg_3))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of master 3")

               
         master_agt_0 = axi_master_agent # (M_DATA_W[0],M_ADDR_W,M_ID_WIDTH[0])::type_id::create ("master_agt_0",this);
         master_agt_0.cfg = master_cfg_0;         
         master_agt_1 = axi_master_agent # (M_DATA_W[1],M_ADDR_W,M_ID_WIDTH[1])::type_id::create ("master_agt_1",this);
         master_agt_1.cfg = master_cfg_1;         
         master_agt_2 = axi_master_agent # (M_DATA_W[2],M_ADDR_W,M_ID_WIDTH[2])::type_id::create ("master_agt_2",this);
         master_agt_2.cfg = master_cfg_2;         
         master_agt_3 = axi_master_agent # (M_DATA_W[3],M_ADDR_W,M_ID_WIDTH[3])::type_id::create ("master_agt_3",this);
         master_agt_3.cfg = master_cfg_3;         
                        

      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH))::get(this,"","cfgs_0", slave_cfg_0))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 0")
      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH))::get(this,"","cfgs_1", slave_cfg_1))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 1")
      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH))::get(this,"","cfgs_2", slave_cfg_2))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 2")
      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH))::get(this,"","cfgs_3", slave_cfg_3))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 3")
      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH))::get(this,"","cfgs_4", slave_cfg_4))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 4")
      if(!uvm_config_db #(axi_agent_configuration #(S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH))::get(this,"","cfgs_5", slave_cfg_5))
            `uvm_fatal(get_full_name (),"Can't get configuration object through config_db of slave 5")


      // creation of slave agents based on agent configuration
         slave_agt_0 = axi_slave_agent # (S_DATA_W[0],S_ADDR_W[0],S_ID_WIDTH)::type_id::create ("slave_cfg_0",this);
         slave_agt_0.cfg = slave_cfg_0;        
         slave_agt_1 = axi_slave_agent # (S_DATA_W[1],S_ADDR_W[1],S_ID_WIDTH)::type_id::create ("slave_agt_1",this);
         slave_agt_1.cfg = slave_cfg_1;        
         slave_agt_2 = axi_slave_agent # (S_DATA_W[2],S_ADDR_W[2],S_ID_WIDTH)::type_id::create ("slave_agt_2",this);
         slave_agt_2.cfg = slave_cfg_2;        
         slave_agt_3 = axi_slave_agent # (S_DATA_W[3],S_ADDR_W[3],S_ID_WIDTH)::type_id::create ("slave_agt_3",this);
         slave_agt_3.cfg = slave_cfg_3;        
         slave_agt_4 = axi_slave_agent # (S_DATA_W[4],S_ADDR_W[4],S_ID_WIDTH)::type_id::create ("slave_agt_4",this);
         slave_agt_4.cfg = slave_cfg_4;        
         slave_agt_5 = axi_slave_agent # (S_DATA_W[5],S_ADDR_W[5],S_ID_WIDTH)::type_id::create ("slave_agt_5",this);
         slave_agt_5.cfg = slave_cfg_5;         
      
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
         master_agt_0.mon.axi_analysis_port.connect(scr.M0_imp);
         master_agt_1.mon.axi_analysis_port.connect(scr.M1_imp);
         master_agt_2.mon.axi_analysis_port.connect(scr.M2_imp);
         master_agt_3.mon.axi_analysis_port.connect(scr.M3_imp);
      //end
      //for(int i=0;i< NO_S; i++)begin
         slave_agt_0.mon.axi_analysis_port.connect(scr.S0_imp);
         slave_agt_1.mon.axi_analysis_port.connect(scr.S1_imp);
         slave_agt_2.mon.axi_analysis_port.connect(scr.S2_imp);
         slave_agt_3.mon.axi_analysis_port.connect(scr.S3_imp);
         slave_agt_4.mon.axi_analysis_port.connect(scr.S4_imp);
         slave_agt_5.mon.axi_analysis_port.connect(scr.S5_imp);
      //end

   endfunction


